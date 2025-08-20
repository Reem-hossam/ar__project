import 'dart:async';
import 'dart:math';
import 'package:ar_flutter_plugin_updated/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin_updated/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_updated/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_updated/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_updated/models/ar_node.dart';
import 'package:ar_project/presentation/screens/win_screen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:isar/isar.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'core/db.dart';
import 'data/models/user.dart';
import 'data/services/api_service.dart';

class ARViewScreen extends StatefulWidget {
  const ARViewScreen({super.key});

  @override
  State<ARViewScreen> createState() => _ARViewScreenState();
}

class _ARViewScreenState extends State<ARViewScreen> {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;
  final player = AudioPlayer();
  ARNode? currentCharacter;
  int points = 0;
  bool isSpawning = false;
  bool showBravo = false;
  int remainingTime = 60;
  Timer? countdownTimer;
  User? _currentUser;
  final String characterUrl = "https://raw.githubusercontent.com/Reem-hossam/ar__project/main/assets/models/robot.glb";
  bool hasWon = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserAndPoints();
  }

  Future<void> _loadCurrentUserAndPoints() async {
    final allUsers = await DB.isar.users.where().findAll();
    allUsers.sort((a, b) => b.id.compareTo(a.id));
    final lastUser = allUsers.isNotEmpty ? allUsers.first : null;
    if (lastUser != null) {
      setState(() {
        _currentUser = lastUser;
        points = _currentUser!.points;
        print('Loaded user: ${_currentUser!.username} with points: ${points}');
      });
    } else {
      print('No user found in local database.');
    }
  }

  @override
  void dispose() {
    arSessionManager.dispose();
    countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          ARView(onARViewCreated: onARViewCreated),
          Positioned(
            top: 60.h,
            left: 20.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFDB2653),
                    const Color(0xFFE91E63).withOpacity(0.8)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                "Score: $points",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            top: 130.h,
            left: 20.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                "Character will move in: $remainingTime s",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onARViewCreated(ARSessionManager sessionManager,
      ARObjectManager objectManager,
      _,
      __,) async {
    arSessionManager = sessionManager;
    arObjectManager = objectManager;

    await arSessionManager.onInitialize(
      showPlanes: true,
      handleTaps: false,
      showFeaturePoints: false,
    );
    await arObjectManager.onInitialize();

    spawnCharacter();
  }

  void spawnCharacter() async {
    if (isSpawning) return;
    isSpawning = true;

    if (currentCharacter != null) {
      await arObjectManager.removeNode(currentCharacter!);
      currentCharacter = null;
    }

    List<vector.Vector3> safePositions = List.generate(8, (i) {
      final angle = i * (2 * pi / 8);
      final distance = 2.0;
      final dx = distance * cos(angle);
      final dz = -distance * sin(angle);
      return vector.Vector3(dx, 0, dz);
    });


    final position = (safePositions..shuffle()).first;

    final newNode = ARNode(
      type: NodeType.webGLB,
      uri: characterUrl,
      scale: vector.Vector3.all(0.7),
      position: position,
      rotation: vector.Vector4(0, 1, 0, pi),
    );
    remainingTime = 60;
    countdownTimer?.cancel();
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        remainingTime--;
        if (remainingTime <= 0) {
          remainingTime = 0;
          timer.cancel();
          if (currentCharacter != null) {
            arObjectManager.removeNode(currentCharacter!);
            currentCharacter = null;
            spawnCharacter();
          }
        }
      });
    });



    bool success = await arObjectManager.addNode(newNode) ?? false;

    if (success) {
      currentCharacter = newNode;
      await Future.delayed(const Duration(seconds: 2));
      monitorProximity();
    } else {
      Future.delayed(const Duration(seconds: 2), () => spawnCharacter());
    }

    isSpawning = false;
  }

  void monitorProximity() async {
    while (currentCharacter != null) {
      await Future.delayed(const Duration(milliseconds: 500));
      final matrix = await arSessionManager.getCameraPose();
      if (matrix == null || currentCharacter == null) continue;

      final camPosition = vector.Vector3(
        matrix.entry(0, 3),
        matrix.entry(1, 3),
        matrix.entry(2, 3),
      );

      final charPos = currentCharacter?.position;
      if (charPos == null) continue;

      final distance = camPosition.distanceTo(charPos);

      if (distance < 1.0) {
        countdownTimer?.cancel();
        setState(() {
          points++;
          if (points >= 10) {
            hasWon = true;
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => WinScreen(finalScore: points),
              ),
            );
            return;
          }
        });

        await player.play(
            AssetSource('sounds/mixkit-achievement-bell-600.wav'));
        await arObjectManager.removeNode(currentCharacter!);
        currentCharacter = null;

        if (_currentUser != null) {
          await _updateUserPointsLocallyAndSync(_currentUser!, points);
        } else {
          print('Error: Current user is null. Cannot save points.');
        }

        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) spawnCharacter();
        });
        break;
      }
    }
  }

  Future<void> _updateUserPointsLocallyAndSync(User user, int newPoints) async {
    user.points = newPoints;
    await DB.isar.writeTxn(() async {
      await DB.isar.users.put(user);
    });
    print('User points updated locally for ${user.username}: ${user.points}');

    if (user.serverId != null) {
      try {
        final success = await ApiService.sendPointsUpdateToServer(user.serverId!, user.points);
        if (success) {
          print('Points sent to server successfully for ${user.username}');
        } else {
          print('Failed to send points to server for ${user.username}. Will retry on next sync.');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Check your connection")),
            );
          }
        }
      } catch (e) {
        print('Error sending points: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Check your connection")),
          );
        }
      }
    } else {
      print('User ${user.username} is not synced with server yet. Points saved locally.');
    }
  }
}


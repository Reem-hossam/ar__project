import 'dart:async';
import 'dart:math';
import 'package:ar_flutter_plugin_updated/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin_updated/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_updated/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_updated/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_updated/models/ar_node.dart';
import 'package:ar_project/presentation/screens/win_screen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import '../data/models/user.dart';
import '../data/services/user_local_service.dart';

class ARViewScreen extends StatefulWidget {
  static const String routeName = "ARViewScreen";
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
  int gameTimeRemaining = 120;
  Timer? gameTimer;
  User? _currentUser;
  final String characterUrl = "https://raw.githubusercontent.com/Reem-hossam/ar__project/main/assets/models/robot.glb";
  bool hasWon = false;

  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserAndPoints();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        _showNoInternetSnackBar();
      }
    });
  }

  Future<void> _loadCurrentUserAndPoints() async {
    final activeUser = await UserLocalService.getActiveUser();
    if (activeUser != null) {
      setState(() {
        _currentUser = activeUser;
        points = activeUser.points;
        gameTimeRemaining = activeUser.gameTimeRemaining;
        print('Loaded user: ${activeUser.username} with points: $points');
      });
    } else {
      print('No active user found.');
    }
  }

  @override
  void dispose() {
    arSessionManager.dispose();
    countdownTimer?.cancel();
    gameTimer?.cancel();
    super.dispose();
  }

  void _showNoInternetSnackBar() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "Connection lost. Please check your internet.",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(days: 1),
          action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    }
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
                  colors: [const Color(0xFF0180CD), const Color(0xFF0180CD).withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15.r),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), spreadRadius: 2, blurRadius: 5, offset: const Offset(0, 3))],
              ),
              child: Text(
                "Score: $points",
                style: TextStyle(color: Colors.white, fontSize: 22.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Positioned(
            top: 130.h,
            left: 20.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 6.h),
              decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12.r)),
              child: Text(
                "Character will move in: $remainingTime s",
                style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Positioned(
            top: 170.h,
            left: 20.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 6.h),
              decoration: BoxDecoration(color: Colors.blue.withOpacity(0.2), borderRadius: BorderRadius.circular(12.r)),
              child: Text(
                "Game ends in: $gameTimeRemaining s",
                style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onARViewCreated(ARSessionManager sessionManager, ARObjectManager objectManager, _, __,) async {
    arSessionManager = sessionManager;
    arObjectManager = objectManager;

    await arSessionManager.onInitialize(showPlanes: true, handleTaps: false, showFeaturePoints: false);
    await arObjectManager.onInitialize();

    startGameTimer();
    spawnCharacter();
  }

  void startGameTimer() {
    gameTimer?.cancel();
    gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (gameTimeRemaining > 0) {
          gameTimeRemaining--;
        } else {
          timer.cancel();
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => WinScreen(finalScore: points)));
        }
      });

      if (_currentUser != null) {
        _currentUser!.gameTimeRemaining = gameTimeRemaining;
        await _currentUser!.save();
      }
    });
  }

  void startCharacterTimer() {
    countdownTimer?.cancel();
    remainingTime = 60;
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
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
  }

  void spawnCharacter() async {
    if (isSpawning || gameTimeRemaining <= 0) return;
    isSpawning = true;

    if (currentCharacter != null) {
      await arObjectManager.removeNode(currentCharacter!);
      currentCharacter = null;
    }

    List<vector.Vector3> safePositions = List.generate(8, (i) {
      final angle = i * (2 * pi / 8);
      const distance = 3.0;
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

    bool success = await arObjectManager.addNode(newNode) ?? false;

    if (success) {
      currentCharacter = newNode;
      await Future.delayed(const Duration(seconds: 2));
      startCharacterTimer();
      monitorProximity();
    } else {
      Future.delayed(const Duration(seconds: 2), () => spawnCharacter());
    }

    isSpawning = false;
  }

  void monitorProximity() async {
    while (currentCharacter != null && gameTimeRemaining > 0) {
      await Future.delayed(const Duration(milliseconds: 500));
      final matrix = await arSessionManager.getCameraPose();
      if (matrix == null || currentCharacter == null) continue;

      final camPosition = vector.Vector3(matrix.entry(0, 3), matrix.entry(1, 3), matrix.entry(2, 3));
      final charPos = currentCharacter?.position;
      if (charPos == null) continue;

      final distance = camPosition.distanceTo(charPos);

      if (distance < 1.0) {
        countdownTimer?.cancel();
        setState(() {
          points++;
        });

        await player.play(AssetSource('sounds/mixkit-achievement-bell-600.wav'));
        await arObjectManager.removeNode(currentCharacter!);
        currentCharacter = null;

        if (_currentUser != null) {
          await UserLocalService.updatePoints(_currentUser!, points);
        } else {
          print('Error: Current user is null. Cannot save points.');
        }

        Future.delayed(const Duration(seconds: 1), () {
          if (mounted && gameTimeRemaining > 0) spawnCharacter();
        });
        break;
      }
    }
  }
}
import 'dart:async';
import 'dart:math';
import 'package:ar_flutter_plugin_updated/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin_updated/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_updated/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_updated/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_updated/models/ar_node.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

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

  final String characterUrl = "https://raw.githubusercontent.com/Reem-hossam/ar__project/main/assets/models/robot.glb";

  @override
  void dispose() {
    arSessionManager.dispose();
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
          )
        ],
      ),
    );
  }

  void onARViewCreated(
      ARSessionManager sessionManager,
      ARObjectManager objectManager,
      _,
      __,
      ) async {
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
    Timer(const Duration(seconds: 60), () {
      if (currentCharacter != null) {
        arObjectManager.removeNode(currentCharacter!);
        currentCharacter = null;
        if (mounted) spawnCharacter();
      }
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
        setState(() {
          points++;
          if (points == 5) {
            showBravo = true;
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) setState(() => showBravo = false);
            });
          }
        });

        await player.play(AssetSource('sounds/mixkit-achievement-bell-600.wav'));
        await arObjectManager.removeNode(currentCharacter!);
        currentCharacter = null;

        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) spawnCharacter();
        });
        break;
      }
    }
  }
}

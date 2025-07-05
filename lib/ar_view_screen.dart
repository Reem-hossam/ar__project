import 'dart:async';
import 'dart:math';
import 'package:ar_flutter_plugin_updated/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin_updated/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_updated/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_updated/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_updated/models/ar_node.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
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

  final List<String> characters = [
    "https://raw.githubusercontent.com/Reem-hossam/ar__project/main/assets/models/round_robot.glb",
    "https://raw.githubusercontent.com/Reem-hossam/ar__project/main/assets/models/robot.glb",
    "https://raw.githubusercontent.com/Reem-hossam/ar__project/main/assets/models/little_cute_robot.glb",
  ];

  @override
  void dispose() {
    arSessionManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          ARView(onARViewCreated: onARViewCreated),
          Positioned(
            top: 70,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(

                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFDB2653),
                    const Color(0xFFE91E63).withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
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
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onARViewCreated(
      ARSessionManager sessionManager,
      ARObjectManager objectManager,
      _,
      __) async {
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

  Future<void> spawnCharacter() async {
    if (currentCharacter != null) {
      await arObjectManager.removeNode(currentCharacter!);
      currentCharacter = null;
    }

    final url = (characters..shuffle()).first;
    final position = vector.Vector3(
      Random().nextDouble() * 2 - 1,
      0.0,
      -(1.5 + Random().nextDouble()),
    );

    final newNode = ARNode(
      type: NodeType.webGLB,
      uri: url,
      scale: vector.Vector3.all(0.4),
      position: position,
      rotation: vector.Vector4(0, 1, 0, pi),
    );

    final success = await arObjectManager.addNode(newNode);
    if (success == true) {
      currentCharacter = newNode;
      monitorProximity();
    }
  }

  void monitorProximity() async {
    while (currentCharacter != null) {
      try {
        await Future.delayed(const Duration(milliseconds: 500));

        final matrix = await arSessionManager.getCameraPose();
        if (matrix == null) return;

        final camPosition = vector.Vector3(
          matrix.entry(0, 3),
          matrix.entry(1, 3),
          matrix.entry(2, 3),
        );

        final charPos = currentCharacter!.position;
        if (charPos == null) return;

        final distance = camPosition.distanceTo(charPos);

        if (distance < 1.0) {
          setState(() => points++);

          await player.play(AssetSource('sounds/mixkit-achievement-bell-600.wav'));

          await arObjectManager.removeNode(currentCharacter!);
          currentCharacter = null;

          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) spawnCharacter();
          });
          break;
        }
      } catch (e) {
        debugPrint("❌ Error in proximity loop: $e");
      }
    }
  }
}
import 'package:ar_flutter_plugin_updated/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_updated/managers/ar_location_manager.dart';
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin_updated/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin_updated/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_updated/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_updated/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_updated/models/ar_node.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'dart:async';
import 'dart:math';

class ARViewScreen extends StatefulWidget {
  const ARViewScreen({super.key});

  @override
  State<ARViewScreen> createState() => _ARViewScreenState();
}

class _ARViewScreenState extends State<ARViewScreen> {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;
  ARNode? myCharacter;
  int points = 0;
  Timer? proximityTimer;
  Timer? characterTimer;

  final List<String> charactersUrls = [
    "https://raw.githubusercontent.com/Reem-hossam/ar__project/main/assets/models/robot.glb",
  ];

  @override
  void dispose() {
    proximityTimer?.cancel();
    characterTimer?.cancel();
    arSessionManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AR")),
      body: Stack(
        children: [
          ARView(
            onARViewCreated: onARViewCreated,
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "Score: $points",
                style: const TextStyle(color: Colors.white, fontSize: 18),
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
      ARAnchorManager _,
      ARLocationManager __,
      ) async {
    arSessionManager = sessionManager;
    arObjectManager = objectManager;

    await arSessionManager.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      customPlaneTexturePath: "Triangle.png",
      showWorldOrigin: true,
    );

    await arObjectManager.onInitialize();

    await spawnRandomCharacter();

    proximityTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      checkProximity();
    });

    characterTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      spawnRandomCharacter();
    });
  }

  Future<void> spawnRandomCharacter() async {
    if (myCharacter != null) {
      await arObjectManager.removeNode(myCharacter!);
    }

    final randomUrl = (charactersUrls..shuffle()).first;

    myCharacter = ARNode(
      type: NodeType.webGLB,
      uri: randomUrl,
      scale: vector.Vector3(0.5, 0.5, 0.5),
      position: vector.Vector3(
        Random().nextDouble() * 2 - 1,
        0.0,
        -(1.5 + Random().nextDouble()),
      ),
      rotation: vector.Vector4(1.0, 0.0, 0.0, 0.0),
    );

    await arObjectManager.addNode(myCharacter!);
  }

  void checkProximity() async {
    if (myCharacter?.position == null) return;

    try {
      var camMatrix = await arSessionManager.getCameraPose();

      if (camMatrix == null) return;

      final camPosition = vector.Vector3(
        camMatrix.entry(0, 3),
        camMatrix.entry(1, 3),
        camMatrix.entry(2, 3),
      );

      final characterPos = myCharacter!.position!;

      final distance = camPosition.distanceTo(characterPos);

      if (distance < 1.0) {
        setState(() {
          points++;
        });
        await spawnRandomCharacter();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("📍new point")),
        );

      }
    } catch (e) {
      debugPrint("💥 Error in proximity: $e");
    }
  }

}

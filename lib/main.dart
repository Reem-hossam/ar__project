import 'package:ar_flutter_plugin_updated/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_updated/managers/ar_session_manager.dart';
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin_updated/ar_flutter_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ARViewScreen(),
    );
  }
}

class ARViewScreen extends StatefulWidget {
  @override
  State<ARViewScreen> createState() => _ARViewScreenState();
}

class _ARViewScreenState extends State<ARViewScreen> {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AR View")),
      body: ARView(
        onARViewCreated: onARViewCreated,
      ),
    );
  }

  void onARViewCreated(ARSessionManager sessionManager, ARObjectManager objectManager, _, __) {
    arSessionManager = sessionManager;
    arObjectManager = objectManager;

    arSessionManager.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      customPlaneTexturePath: "Triangle.png",
      showWorldOrigin: true,
    );
    arObjectManager.onInitialize();
  }
}

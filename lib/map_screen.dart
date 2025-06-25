import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Map")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(30.033333, 31.233334), 
          zoom: 14,
        ),
      ),
    );
  }
}

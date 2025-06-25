import 'package:location/location.dart';

Future<void> getLocation() async {
  Location location = Location();

  bool serviceEnabled;
  PermissionStatus permissionGranted;
  LocationData locationData;

  // Check service
  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) return;
  }

  // Check permission
  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) return;
  }

  // Get location
  locationData = await location.getLocation();
  print('Latitude: ${locationData.latitude}, Longitude: ${locationData.longitude}');
}

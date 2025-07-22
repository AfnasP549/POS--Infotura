import 'dart:developer';

import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<bool> isWithinRange(
    double targetLat,
    double targetLon,
    double radius,
  ) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    log(
      'Current position - Latitude: ${position.latitude}, Longitude: ${position.longitude}',
    );

    double distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      targetLat,
      targetLon,
    );
    log(
      'Distance to target (Lat: $targetLat, Lon: $targetLon): $distance meters',
    );

    bool withinRange = distance <= radius;
    log('Within range ($radius meters): $withinRange');

    return withinRange;
  }
}

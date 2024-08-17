import 'dart:async';

import 'package:fl_location/fl_location.dart';

class LocationService {
  // Check and request location permissions
  static Future<bool> _checkAndRequestPermission({bool? background}) async {
    if (!await FlLocation.isLocationServicesEnabled) {
      // Location services are disabled.
      return false;
    }

    var locationPermission = await FlLocation.checkLocationPermission();
    if (locationPermission == LocationPermission.deniedForever) {
      // Location permission has been permanently denied.
      return false;
    } else if (locationPermission == LocationPermission.denied) {
      // Ask the user for location permission.
      locationPermission = await FlLocation.requestLocationPermission();
      if (locationPermission == LocationPermission.denied ||
          locationPermission == LocationPermission.deniedForever) {
        // Location permission has been denied.
        return false;
      }
    }

    // Location permission must always be granted to collect location data in the background.
    if (background == true &&
        locationPermission == LocationPermission.whileInUse) {
      return false;
    }

    return true;
  }

  // Get the current location
  static Future<Location?> getCurrentLocation() async {
    if (await _checkAndRequestPermission()) {
      const Duration timeLimit = Duration(seconds: 30);
      try {
        return await FlLocation.getLocation(timeLimit: timeLimit);
      } catch (error) {
        print('Error getting location: $error');
        return null;
      }
    }
    return null;
  }

  // Subscribe to real-time location updates
  static StreamSubscription<Location>? _locationSubscription;

  static Future<void> subscribeLocationStream(
      void Function(Location location) onLocation) async {
    if (await _checkAndRequestPermission()) {
      if (_locationSubscription != null) {
        await _locationSubscription?.cancel();
      }

      _locationSubscription = FlLocation.getLocationStream().listen(onLocation);
    }
  }

  static Future<void> unsubscribeLocationStream() async {
    await _locationSubscription?.cancel();
    _locationSubscription = null;
  }

  // Subscribe to location services status changes
  static StreamSubscription<LocationServicesStatus>?
      _locationServicesStatusSubscription;

  static Future<void> subscribeLocationServicesStatusStream(
      void Function(LocationServicesStatus status) onStatusChange) async {
    if (_locationServicesStatusSubscription != null) {
      await _locationServicesStatusSubscription?.cancel();
    }

    _locationServicesStatusSubscription =
        FlLocation.getLocationServicesStatusStream().listen(onStatusChange);
  }

  static Future<void> unsubscribeLocationServicesStatusStream() async {
    await _locationServicesStatusSubscription?.cancel();
    _locationServicesStatusSubscription = null;
  }
}

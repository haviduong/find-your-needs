import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';

class PositionProvider extends ChangeNotifier {
  final Logger logger = Logger(); // logging instead of print

  // Position known bool
  bool positionKnown = false;
  // Long of our position
  double longitude = 0.0;
  // Latitude of our position
  double latitude = 0.0;
  // Timer
  late Timer _locationCheckerTimer;

  // Updating our position and notifies listeners of update
  // Params:
  //  - newLongitude: double
  //  - newLatitude: double
  updatePosition(double newLongitude, double newLatitude) {
    // Checks if the long and lat of the params are 0.0 or not
    if (newLongitude != 0.0 && newLatitude != 0.0) {
      // Updates long
      longitude = newLongitude;
      // Updates lat
      latitude = newLatitude;
      // Sets known bool to true
      positionKnown = true;
    } else {
      // Otherwise, bool is false
      positionKnown = false;
    }
    // Notifies listeners of update
    notifyListeners();
  }

  PositionProvider() {
    // Finds the position of us
    _determinePosition().then(
      (position) {
        // Updates position after we find our position
        updatePosition(position.longitude, position.latitude);
      },
      onError: (error) {
        logger.e('Error with location: $error');
      },
    );

    // Sets a periodic timer to keep finding our location and updating it
    _locationCheckerTimer =
        Timer.periodic(const Duration(seconds: 60), (timer) {
      _determinePosition().then(
        (position) {
          // Updates position after we find our position
          updatePosition(position.longitude, position.latitude);
        },
        onError: (error) {
          logger.e('Error with location: $error');
        },
      );
    });
  }

  // Disposes timer
  @override
  void dispose() {
    _locationCheckerTimer.cancel();
    super.dispose();
  }
}

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

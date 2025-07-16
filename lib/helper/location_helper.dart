import 'dart:developer';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationHelper {
  final Location _location = Location();

  Future<void> requestAllPermissions() async {
    final permissions = [
      Permission.location,
      Permission.storage,
      Permission.photos, // For Android 13+
      Permission.mediaLibrary, // Optional for iOS
    ];

    for (var permission in permissions) {
      final status = await permission.status;

      if (!status.isGranted) {
        final result = await permission.request();
        if (!result.isGranted) {
          if (await permission.isPermanentlyDenied) {
            await openAppSettings(); // Opens system settings
          }

          log('Permission ${permission.toString()} denied.');
        }
      }
    }

    // Check location services
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }
    }
  }

  Future<LocationData> getCurrentPosition() async {
    return await _location.getLocation();
  }
}

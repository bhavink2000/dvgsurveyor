import 'dart:developer';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as perm;

class LocationHelper {
  final Location _location = Location();

  Future<void> requestAllPermissions() async {
    final permissions = [
      perm.Permission.location,
      perm.Permission.storage,
      perm.Permission.photos, // For Android 13+
      perm.Permission.mediaLibrary, // Optional for iOS
    ];

    for (var permission in permissions) {
      final status = await permission.status;

      if (!status.isGranted) {
        final result = await permission.request();
        if (!result.isGranted) {
          if (await permission.isPermanentlyDenied) {
            await perm.openAppSettings(); // Opens system settings
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

  Future<bool> checkPermission() async {
    PermissionStatus permissionGranted = await _location.hasPermission();

    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }

    if (permissionGranted == PermissionStatus.deniedForever) {
      return false;
    }

    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }

    return true;
  }
}

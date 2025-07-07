import 'package:get/get.dart';

enum RoleEnum { admin, worker }

extension RoleEnumExtension on RoleEnum {
  String get displayName {
    switch (this) {
      case RoleEnum.admin:
        return 'Admin';
      case RoleEnum.worker:
        return 'Worker';
    }
  }

  static RoleEnum? fromString(String? value) {
    if (value == null) return null;
    return RoleEnum.values.firstWhereOrNull(
      (e) => e.displayName.toLowerCase() == value.toLowerCase(),
    );
  }
}
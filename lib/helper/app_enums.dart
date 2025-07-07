enum RoleEnum { superAdmin, admin, worker }

extension RoleEnumExtension on RoleEnum {
  String get displayName {
    switch (this) {
      case RoleEnum.superAdmin:
        return 'Super Admin';
      case RoleEnum.admin:
        return 'Admin';
      case RoleEnum.worker:
        return 'Worker';
    }
  }
}

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

enum AreaCategoryType { slab, papda, patara, nadiya, open }


extension AreaCategoryTypeExtension on AreaCategoryType {
  String get label {
    switch (this) {
      case AreaCategoryType.slab:
        return 'સ્લેબ';
      case AreaCategoryType.papda:
        return 'પાપડા';
      case AreaCategoryType.patara:
        return 'પતરા';
      case AreaCategoryType.nadiya:
        return 'નાળિયા';
      case AreaCategoryType.open:
        return 'ખુલ્લું';
    }
  }
}

enum FloorType {
  ground,
  first,
  second,
  third,
  basementOne,
}

extension FloorTypeExt on FloorType {
  String get label {
    switch (this) {
      case FloorType.ground:
        return 'Ground';
      case FloorType.first:
        return 'First';
      case FloorType.second:
        return 'Second';
      case FloorType.third:
        return 'Third';
      case FloorType.basementOne:
        return 'Basement One';
    }
  }
}


import 'package:cloud_firestore/cloud_firestore.dart';

class PropertyTypeItem {
  final String? pId;
  final String? propertyName;

  PropertyTypeItem({
    this.propertyName,
    this.pId,
  });

  factory PropertyTypeItem.fromMap(Map<String, dynamic>? map) {
    if (map == null) return PropertyTypeItem();
    return PropertyTypeItem(
      propertyName: map['propertyName'],
      pId: map['propertyId'],
    );
  }

  Map<String, dynamic> toMap() => {
        'propertyName': propertyName,
        'propertyId': pId,
      };
}

class PropertyDescriptionItem {
  final String? propertyDesId;
  final String? propertyDes;
  final String? propertyId;

  PropertyDescriptionItem({
    this.propertyDesId,
    this.propertyDes,
    this.propertyId,
  });

  factory PropertyDescriptionItem.fromMap(Map<String, dynamic>? map) {
    if (map == null) return PropertyDescriptionItem();
    return PropertyDescriptionItem(
      propertyDesId: map['propertDesId'],
      propertyDes: map['propertyDes'],
      propertyId: map['propertyId'],
    );
  }

  Map<String, dynamic> toMap() => {
        'propertyDesId': propertyDesId,
        'propertyDes': propertyDes,
        'propertyId': propertyId,
      };
}

class AreaItem {
  final double length;
  final double width;

  AreaItem({
    required this.length,
    required this.width,
  });

  double get count => length * width;

  factory AreaItem.fromMap(Map<String, dynamic> map) => AreaItem(
        length: (map['length'] ?? 0).toDouble(),
        width: (map['width'] ?? 0).toDouble(),
      );

  Map<String, dynamic> toMap() => {
        'length': length,
        'width': width,
        'count': count,
      };

  AreaItem copyWith({
    double? length,
    double? width,
  }) {
    return AreaItem(
      length: length ?? this.length,
      width: width ?? this.width,
    );
  }
}

class AreaCategory {
  final List<AreaItem> items;

  AreaCategory({List<AreaItem>? items}) : items = items ?? [];

  factory AreaCategory.fromMap(Map<String, dynamic> map) => AreaCategory(
        items: (map['items'] as List? ?? [])
            .map((e) => AreaItem.fromMap(Map<String, dynamic>.from(e)))
            .toList(),
      );

  /// Computed total area (sum of length * width for each item)
  double get totalCount =>
      items.fold<double>(0, (sum, item) => sum + (item.length * item.width));

  Map<String, dynamic> toMap() => {
        'items': items.map((e) => e.toMap()).toList(),
        'totalCount': totalCount,
      };
}

class AreaDetail {
  final AreaCategory slab;
  final AreaCategory papda;
  final AreaCategory patara;
  final AreaCategory nadiya;
  final AreaCategory open;

  AreaDetail({
    AreaCategory? slab,
    AreaCategory? papda,
    AreaCategory? patara,
    AreaCategory? nadiya,
    AreaCategory? open,
  })  : slab = slab ?? AreaCategory(),
        papda = papda ?? AreaCategory(),
        patara = patara ?? AreaCategory(),
        nadiya = nadiya ?? AreaCategory(),
        open = open ?? AreaCategory();

  /// Access categories by string (use lowercased label or .tr)
  Map<String, AreaCategory> get categoriesMap => {
        'slab': slab,
        'સ્લેબ': slab,
        'papda': papda,
        'પાપડા': papda,
        'patara': patara,
        'પાટરા': patara,
        'nadiya': nadiya,
        'નાળિયા': nadiya,
        'open': open,
        'ખુલ્લું': open,
      };

  Map<String, dynamic> toMap() => {
        'slab': slab.toMap(),
        'papda': papda.toMap(),
        'patara': patara.toMap(),
        'nadiya': nadiya.toMap(),
        'open': open.toMap(),
        'totalArea': totalArea,
      };

  /// ✅ Total area for this floor
  double get totalArea =>
      slab.totalCount +
      papda.totalCount +
      patara.totalCount +
      nadiya.totalCount +
      open.totalCount;

  factory AreaDetail.fromMap(Map<String, dynamic> map) => AreaDetail(
        slab: AreaCategory.fromMap(map['slab'] ?? {}),
        papda: AreaCategory.fromMap(map['papda'] ?? {}),
        patara: AreaCategory.fromMap(map['patara'] ?? {}),
        nadiya: AreaCategory.fromMap(map['nadiya'] ?? {}),
        open: AreaCategory.fromMap(map['open'] ?? {}),
      );
}

class SurveyModel {
  final String userId;
  final String userRole;
  final String userName;
  final String id;
  final String ownerName;
  final String oldHomeNumber;
  final String index;
  final String newHomeNumber;
  final String rentPersonName;
  final String address;
  final String propertyStayType;
  final Map<String, PropertyTypeItem> propertyType;
  final Map<String, PropertyDescriptionItem> propertyDescription;
  final String mobileNumber;
  final String waterPipeline;
  final String banthkamYear;
  final String totalFloors;
  final Map<String, AreaDetail> area;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? gamName;
  final Map<String, LocationMap> locationMap;
  final bool? isFormEdit;

  SurveyModel({
    required this.userId,
    required this.userRole,
    required this.userName,
    required this.id,
    required this.ownerName,
    required this.oldHomeNumber,
    required this.index,
    required this.newHomeNumber,
    required this.rentPersonName,
    required this.address,
    required this.propertyStayType,
    required this.propertyType,
    required this.propertyDescription,
    required this.mobileNumber,
    required this.waterPipeline,
    required this.banthkamYear,
    required this.totalFloors,
    required this.area,
    required this.createdAt,
    required this.updatedAt,
    this.gamName,
    required this.locationMap,
    this.isFormEdit = false,
  });

  factory SurveyModel.fromFirebase(DocumentSnapshot json) {
    final data = json.data() as Map<String, dynamic>? ?? {};

    return SurveyModel(
      userId: data['userId'] ?? '',
      userRole: data['userRole'] ?? '',
      userName: data['userName'] ?? '',
      id: data['id'] ?? '',
      ownerName: data['ownerName'] ?? '',
      oldHomeNumber: data['oldHomeNumber'] ?? '',
      index: data['index'] ?? '',
      newHomeNumber: data['newHomeNumber'] ?? '',
      rentPersonName: data['rentPersonName'] ?? '',
      address: data['address'] ?? '',
      propertyStayType: data['propertyStayType'] ?? '',
      propertyType: (data['propertyType'] as Map<String, dynamic>? ?? {}).map(
        (key, value) => MapEntry(key, PropertyTypeItem.fromMap(value)),
      ),
      propertyDescription:
          (data['propertyDescription'] as Map<String, dynamic>? ?? {}).map(
        (key, value) => MapEntry(key, PropertyDescriptionItem.fromMap(value)),
      ),
      mobileNumber: data['mobileNumber'] ?? '',
      waterPipeline: data['waterPipeline'] ?? '0',
      banthkamYear: data['banthkamYear'] ?? '0',
      totalFloors: data['totalFloors'] ?? '0',
      area: (data['area'] as Map<String, dynamic>? ?? {}).map(
        (key, value) => MapEntry(key, AreaDetail.fromMap(value)),
      ),
      createdAt: data['createdAt']?.toDate(),
      updatedAt: data['updatedAt']?.toDate(),
      gamName: data['gamName'] ?? '',
      locationMap: (data['locationMap'] as Map<String, dynamic>? ?? {}).map(
        (key, value) => MapEntry(key, LocationMap.fromMap(value)),
      ),
      isFormEdit: data['isFormEdit'] ?? false,
    );
  }

  Map<String, dynamic> toFirebase() => {
        'userId': userId,
        'userRole': userRole,
        'userName': userName,
        'id': id,
        'ownerName': ownerName,
        'oldHomeNumber': oldHomeNumber,
        'index': index,
        'newHomeNumber': newHomeNumber,
        'rentPersonName': rentPersonName,
        'address': address,
        'propertyStayType': propertyStayType,
        'propertyType':
            propertyType.map((key, value) => MapEntry(key, value.toMap())),
        'propertyDescription': propertyDescription
            .map((key, value) => MapEntry(key, value.toMap())),
        'mobileNumber': mobileNumber,
        'waterPipeline': waterPipeline,
        'banthkamYear': banthkamYear,
        'totalFloors': totalFloors,
        'area': area.map((key, value) => MapEntry(key, value.toMap())),
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'gamName': gamName,
        'locationMap':
            locationMap.map((key, value) => MapEntry(key, value.toMap())),
        'isFormEdit': isFormEdit,
      };

  SurveyModel copyWith({
    String? userId,
    String? userRole,
    String? userName,
    String? id,
    String? ownerName,
    String? oldHomeNumber,
    String? index,
    String? newHomeNumber,
    String? rentPersonName,
    String? address,
    String? propertyStayType,
    Map<String, PropertyTypeItem>? propertyType,
    Map<String, PropertyDescriptionItem>? propertyDescription,
    String? mobileNumber,
    String? waterPipeline,
    String? banthkamYear,
    String? totalFloors,
    Map<String, AreaDetail>? area,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    String? gamName,
    Map<String, LocationMap>? locationMap,
    bool? isFormEdit,
  }) {
    return SurveyModel(
      userId: userId ?? this.userId,
      userRole: userRole ?? this.userRole,
      userName: userName ?? this.userName,
      id: id ?? this.id,
      ownerName: ownerName ?? this.ownerName,
      oldHomeNumber: oldHomeNumber ?? this.oldHomeNumber,
      index: index ?? this.index,
      newHomeNumber: newHomeNumber ?? this.newHomeNumber,
      rentPersonName: rentPersonName ?? this.rentPersonName,
      address: address ?? this.address,
      propertyStayType: propertyStayType ?? this.propertyStayType,
      propertyType: propertyType ?? this.propertyType,
      propertyDescription: propertyDescription ?? this.propertyDescription,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      waterPipeline: waterPipeline ?? this.waterPipeline,
      banthkamYear: banthkamYear ?? this.banthkamYear,
      totalFloors: totalFloors ?? this.totalFloors,
      area: area ?? this.area,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      gamName: gamName ?? this.gamName,
      locationMap: locationMap ?? this.locationMap,
      isFormEdit: isFormEdit ?? this.isFormEdit,
    );
  }
}

class LocationMap {
  final String lag;
  final String lug;

  LocationMap({required this.lag, required this.lug});

  factory LocationMap.fromMap(Map<String, dynamic> map) {
    return LocationMap(
      lag: map['lag'] ?? '',
      lug: map['lug'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lag': lag,
      'lug': lug,
    };
  }

  LocationMap copyWith({String? lag, String? lug}) {
    return LocationMap(
      lag: lag ?? this.lag,
      lug: lug ?? this.lug,
    );
  }
}

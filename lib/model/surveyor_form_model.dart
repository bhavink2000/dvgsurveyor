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
        'પતરા': patara,
        'nadiya': nadiya,
        'નળિયા': nadiya,
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

T? asType<T>(dynamic value) => value is T ? value : null;
String asString(dynamic value, [String fallback = '']) =>
    value is String ? value : fallback;
bool asBool(dynamic value, [bool fallback = false]) =>
    value is bool ? value : fallback;
List<String> asStringList(dynamic value) =>
    (value as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];

DateTime? asDate(dynamic value) {
  if (value == null) return null;
  if (value is Timestamp) return value.toDate();
  if (value is String) return DateTime.tryParse(value);
  return null;
}

/// ------------------
/// Survey Model
/// ------------------
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
  final bool isFormEdit;
  final String? surveyNumber;
  final String? remarks;
  final String? isDabaan;
  final String? signature; // base64 encoded signature
  final bool isOffProperty;
  final bool isNonResidential;
  final List<RcNumberItem>? rcNumber;
  final String? ecNumber;
  final String? srNo;

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
    this.createdAt,
    this.updatedAt,
    this.gamName,
    required this.locationMap,
    this.isFormEdit = false,
    this.surveyNumber,
    this.remarks,
    this.isDabaan = 'ના',
    this.signature,
    this.isOffProperty = false,
    this.isNonResidential = false,
    this.rcNumber,
    this.ecNumber,
    this.srNo,
  });

  /// ✅ From Firestore
  factory SurveyModel.fromFirebase(DocumentSnapshot json) {
    final data = json.data() as Map<String, dynamic>? ?? {};
    return SurveyModel.fromJson(data);
  }

  /// ✅ From Map (handles both Firebase + JSON)
  factory SurveyModel.fromJson(Map<String, dynamic> data) {
    return SurveyModel(
      userId: asString(data['userId']),
      userRole: asString(data['userRole']),
      userName: asString(data['userName']),
      id: asString(data['id']),
      ownerName: asString(data['ownerName']),
      oldHomeNumber: asString(data['oldHomeNumber']),
      index: asString(data['index']),
      newHomeNumber: asString(data['newHomeNumber']),
      rentPersonName: asString(data['rentPersonName']),
      address: asString(data['address']),
      propertyStayType: asString(data['propertyStayType']),
      propertyType: (data['propertyType'] as Map<String, dynamic>? ?? {})
          .map((k, v) => MapEntry(k, PropertyTypeItem.fromMap(v))),
      propertyDescription:
          (data['propertyDescription'] as Map<String, dynamic>? ?? {})
              .map((k, v) => MapEntry(k, PropertyDescriptionItem.fromMap(v))),
      mobileNumber: asString(data['mobileNumber']),
      waterPipeline: asString(data['waterPipeline'], '0'),
      banthkamYear: asString(data['banthkamYear'], '0'),
      totalFloors: asString(data['totalFloors'], '0'),
      area: (data['area'] as Map<String, dynamic>? ?? {})
          .map((k, v) => MapEntry(k, AreaDetail.fromMap(v))),
      createdAt: asDate(data['createdAt']),
      updatedAt: asDate(data['updatedAt']),
      gamName: asString(data['gamName']),
      locationMap: (data['locationMap'] as Map<String, dynamic>? ?? {})
          .map((k, v) => MapEntry(k, LocationMap.fromMap(v))),
      isFormEdit: asBool(data['isFormEdit']),
      surveyNumber: asString(data['surveyNumber']),
      remarks: asString(data['remarks']),
      isDabaan: asString(data['isDabaan']),
      signature: asString(data['signature']),
      isOffProperty: asBool(data['isOffProperty']),
      isNonResidential: asBool(data['isNonResidential']),
      rcNumber: (data['rcNumber'] as List<dynamic>?)
          ?.map((e) => RcNumberItem.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      ecNumber: asString(data['ecNumber']),
      srNo: asString(data['srNo']),
    );
  }

  /// ✅ To Map
  Map<String, dynamic> toJson() => {
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
        'propertyType': propertyType.map((k, v) => MapEntry(k, v.toMap())),
        'propertyDescription':
            propertyDescription.map((k, v) => MapEntry(k, v.toMap())),
        'mobileNumber': mobileNumber,
        'waterPipeline': waterPipeline,
        'banthkamYear': banthkamYear,
        'totalFloors': totalFloors,
        'area': area.map((k, v) => MapEntry(k, v.toMap())),
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'gamName': gamName,
        'locationMap': locationMap.map((k, v) => MapEntry(k, v.toMap())),
        'isFormEdit': isFormEdit,
        'surveyNumber': surveyNumber,
        'remarks': remarks,
        'isDabaan': isDabaan,
        'signature': signature,
        'isOffProperty': isOffProperty,
        'isNonResidential': isNonResidential,
        "rcNumber": rcNumber?.map((e) => e.toJson()).toList(),
        'ecNumber': ecNumber,
        'srNo': srNo,
      };

  /// ✅ CopyWith
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
    DateTime? createdAt,
    DateTime? updatedAt,
    String? gamName,
    Map<String, LocationMap>? locationMap,
    bool? isFormEdit,
    String? surveyNumber,
    String? remarks,
    String? isDabaan,
    String? signature,
    bool? isOffProperty,
    bool? isNonResidential,
    List<RcNumberItem>? rcNumber,
    String? ecNumber,
    String? srNo,
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
      surveyNumber: surveyNumber ?? this.surveyNumber,
      remarks: remarks ?? this.remarks,
      isDabaan: isDabaan ?? this.isDabaan,
      signature: signature ?? this.signature,
      isOffProperty: isOffProperty ?? this.isOffProperty,
      isNonResidential: isNonResidential ?? this.isNonResidential,
      rcNumber: rcNumber ?? this.rcNumber,
      ecNumber: ecNumber ?? this.ecNumber,
      srNo: srNo ?? this.srNo,
    );
  }
}

class RcNumberItem {
  final String contractorName;
  final String rcNumber;

  RcNumberItem({required this.contractorName, required this.rcNumber});

  factory RcNumberItem.fromJson(Map<String, dynamic> json) {
    return RcNumberItem(
      contractorName: json['contractorName'] ?? '',
      rcNumber: json['rcNumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "contractorName": contractorName,
      "rcNumber": rcNumber,
    };
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

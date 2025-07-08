import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dvgsurveyor/common_widgets/custom_labeldropdown_widget.dart';

class PropertyDescriptionModel implements DropdownItem{
  final String id;
  final String name;
  final String propertyTypeId;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PropertyDescriptionModel({
    required this.id,
    required this.name,
    required this.propertyTypeId,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  /// 🔄 From Firestore
  factory PropertyDescriptionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PropertyDescriptionModel(
      id: data['id'] ?? doc.id,
      name: data['name'] ?? '',
      propertyTypeId: data['propertyTypeId'] ?? '',
      isActive: data['isActive'] ?? true,
      createdAt: data['createdAt']?.toDate(),
      updatedAt: data['updatedAt']?.toDate(),
    );
  }

  /// 🔁 To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'propertyTypeId': propertyTypeId,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  /// 🧪 CopyWith
  PropertyDescriptionModel copyWith({
    String? id,
    String? name,
    String? propertyTypeId,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PropertyDescriptionModel(
      id: id ?? this.id,
      name: name ?? this.name,
      propertyTypeId: propertyTypeId ?? this.propertyTypeId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dvgsurveyor/common_widgets/custom_labeldropdown_widget.dart';

class PropertyTypeModel implements DropdownItem{
  final String id;
  final String name;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PropertyTypeModel({
    required this.id,
    required this.name,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  /// 🔄 From Firestore
  factory PropertyTypeModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PropertyTypeModel(
      id: data['id'] ?? doc.id,
      name: data['name'] ?? '',
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
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  /// 🧪 CopyWith
  PropertyTypeModel copyWith({
    String? id,
    String? name,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PropertyTypeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dvgsurveyor/common_widgets/custom_labeldropdown_widget.dart';

class PropertyTypeModel implements DropdownItem {
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

  ///  From Firestore
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

  ///  To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  // Generic Map-based (e.g. JSON, SharedPrefs, etc.)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isActive': isActive,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
    };
  }

  factory PropertyTypeModel.fromMap(Map<String, dynamic> map) {
    return PropertyTypeModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      isActive: map['isActive'] ?? true,
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'])
          : null,
    );
  }

  ///  CopyWith
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

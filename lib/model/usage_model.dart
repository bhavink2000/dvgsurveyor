import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dvgsurveyor/common_widgets/custom_labeldropdown_widget.dart';

class UsageTypeModel implements DropdownItem{
  final String id;
  final String name;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UsageTypeModel({
    required this.id,
    required this.name,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory UsageTypeModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UsageTypeModel(
      id: data['id'] ?? doc.id,
      name: data['name'] ?? '',
      isActive: data['isActive'] ?? true,
      createdAt: data['createdAt']?.toDate(),
      updatedAt: data['updatedAt']?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

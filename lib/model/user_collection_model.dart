import 'package:cloud_firestore/cloud_firestore.dart';

class UserCollectionModel {
  final String id;
  final String username;
  final String password;
  final String firstName;
  final String lastName;
  final String? email;
  final String mobileNumber;
  final String? gender;
  final String? role;
  final bool? isActive;
  final bool? isExcelDownload;
  final bool? isEditable;
  final bool? isDelete;
  final bool? isApproved; // Default value, can be changed later
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? gamName;

  UserCollectionModel({
    required this.id,
    required this.username,
    required this.password,
    required this.firstName,
    required this.lastName,
    this.email,
    required this.mobileNumber,
    this.gender,
    this.role,
    this.isActive = true,
    this.isExcelDownload = false,
    this.isEditable = false, // Default value for isEditable
    this.isDelete = false, // Default value for isDelete
    this.isApproved = false, // Default value for isApproved
    this.createdAt,
    this.updatedAt,
    this.gamName,
  });

  // Convert to Firestore document map
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'mobileNumber': mobileNumber,
      'gender': gender,
      'role': role,
      'isActive': isActive,
      'isExcelDownload': isExcelDownload,
      'isEditable': isEditable, // Include isEditable in Firestore document
      'isDelete': isDelete, // Include isDelete in Firestore document
      'isApproved': isApproved, // Include isApproved in Firestore document
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'gamName': gamName,
      // Note: 'id' is not included as it's the document ID in Firestore
    };
  }

  // Create from Firestore document
  factory UserCollectionModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() as Map<String, dynamic>;
    return UserCollectionModel(
      id: data['id'] ?? doc.id, // Document ID from Firestore
      username: data['username'] ?? '',
      password: data['password'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      email: data['email'] ?? '',
      mobileNumber: data['mobileNumber'] ?? '',
      gender: data['gender'] ?? '',
      role: data['role'] ?? '',
      isActive: data['isActive'] ?? true,
      isExcelDownload: data['isExcelDownload'] ?? false,
      isEditable: data['isEditable'] ?? false, // Default value for isEditable
      isDelete: data['isDelete'] ?? false, // Default value for isDelete
      isApproved: data['isApproved'] ?? false, // Default value for isApproved
      createdAt: data['createdAt']?.toDate(),
      updatedAt: data['updatedAt']?.toDate(),
      gamName: data['gamName'] ?? '',
    );
  }

  // Create from JSON
  factory UserCollectionModel.fromJson(Map<String, dynamic> json) {
    DateTime? _parseDate(dynamic value) {
      if (value == null) return null;
      if (value is Timestamp) return value.toDate();
      if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
      if (value is String) return DateTime.tryParse(value);
      return null;
    }

    return UserCollectionModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      gender: json['gender'] ?? '',
      role: json['role'] ?? '',
      isActive: json['isActive'] ?? true,
      isExcelDownload: json['isExcelDownload'] ?? false,
      isEditable: json['isEditable'] ?? false, // Default value for isEditable
      isDelete: json['isDelete'] ?? false, // Default value for isDelete
      isApproved: json['isApproved'] ?? false, // Default value for isApproved
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
      gamName: json['gamName'] ?? '',
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'mobileNumber': mobileNumber,
      'gender': gender,
      'role': role,
      'isActive': isActive,
      'isExcelDownload': isExcelDownload,
      'isEditable': isEditable, // Include isEditable in JSON
      'isDelete': isDelete, // Include isDelete in JSON
      'isApproved': isApproved, // Include isApproved in JSON
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'gamName': gamName,
    };
  }

  // Copy with method for updates
  UserCollectionModel copyWith({
    String? id,
    String? username,
    String? password,
    String? firstName,
    String? lastName,
    String? email,
    String? mobileNumber,
    String? gender,
    String? role,
    bool? isActive,
    bool? isExcelDownload,
    bool? isEditable,
    bool? isDelete,
    bool? isApproved,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? gamName,
  }) {
    return UserCollectionModel(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      gender: gender ?? this.gender,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      isExcelDownload: isExcelDownload ?? this.isExcelDownload,
      isEditable: isEditable ?? this.isEditable, // Include isEditable in copy
      isDelete: isDelete ?? this.isDelete, // Include isDelete in copy
      isApproved: isApproved ?? this.isApproved, // Include isApproved in copy
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      gamName: gamName ?? this.gamName,
    );
  }
}

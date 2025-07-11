import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dvgsurveyor/helper/firebase_const.dart';
import 'package:dvgsurveyor/model/property_description_model.dart';
import 'package:dvgsurveyor/model/property_type_model.dart';
import 'package:dvgsurveyor/model/surveyor_form_model.dart';
import 'package:dvgsurveyor/model/usage_model.dart';
import 'package:dvgsurveyor/model/user_collection_model.dart';

class AuthRepo {
  AuthRepo._(); // Private constructor for singleton
  static final AuthRepo instance = AuthRepo._(); // Singleton instance

  factory AuthRepo() => instance;

  CollectionReference<UserCollectionModel> get _userCollection =>
      FirebaseFirestore.instance
          .collection(FirebaseConst.userCollection)
          .withConverter<UserCollectionModel>(
            fromFirestore: (snapshot, _) =>
                UserCollectionModel.fromFirestore(snapshot),
            toFirestore: (model, _) => model.toFirestore(),
          );

  CollectionReference<UsageTypeModel> get _usageTypeCollection =>
      FirebaseFirestore.instance
          .collection(FirebaseConst.usageCollection)
          .withConverter<UsageTypeModel>(
            fromFirestore: (snapshot, _) =>
                UsageTypeModel.fromFirestore(snapshot),
            toFirestore: (model, _) => model.toFirestore(),
          );

  CollectionReference<PropertyTypeModel> get _propertyTypeCollection =>
      FirebaseFirestore.instance
          .collection(FirebaseConst.propertyType)
          .withConverter<PropertyTypeModel>(
            fromFirestore: (snapshot, _) =>
                PropertyTypeModel.fromFirestore(snapshot),
            toFirestore: (model, _) => model.toFirestore(),
          );

  CollectionReference<PropertyDescriptionModel>
      get _propertyDescriptionCollection => FirebaseFirestore.instance
          .collection(FirebaseConst.propertyDescription)
          .withConverter<PropertyDescriptionModel>(
            fromFirestore: (snapshot, _) =>
                PropertyDescriptionModel.fromFirestore(snapshot),
            toFirestore: (model, _) => model.toFirestore(),
          );

  CollectionReference<SurveyModel> get _surveyCollection =>
      FirebaseFirestore.instance
          .collection(FirebaseConst.surveyCollection)
          .withConverter<SurveyModel>(
            fromFirestore: (snapshot, _) => SurveyModel.fromFirebase(snapshot),
            toFirestore: (model, _) => model.toFirebase(),
          );

  /// Get user by username+password OR mobile number
  Future<UserCollectionModel?> getUser({
    String? username,
    String? password,
    String? mobileNumber,
    String? userId,
  }) async {
    try {
      QuerySnapshot<UserCollectionModel> querySnapshot;

      if (mobileNumber != null) {
        querySnapshot = await _userCollection
            .where('mobileNumber', isEqualTo: mobileNumber)
            .limit(1)
            .get();
      } else if (username != null && password != null) {
        querySnapshot = await _userCollection
            .where('username', isEqualTo: username)
            .where('password', isEqualTo: password)
            .limit(1)
            .get();
      } else {
        final docRef = _userCollection.doc(userId);

        final snapshot = await docRef.get();

        return snapshot.data();
      }

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data();
      }
    } catch (e) {
      log('Error fetching user: $e');
    }
    return null;
  }

  /// Save new user
  Future<UserCollectionModel?> saveUser({UserCollectionModel? user}) async {
    try {
      final docRef = _userCollection.doc(user?.id);
      await docRef.set(user!);
      final snapshot = await docRef.get();

      return snapshot.data();
    } catch (e) {
      log('Error saving user: $e');
      return null;
    }
  }

  Future<List<UserCollectionModel>> getAllUser() async {
    try {
      final querySnapshot = await _userCollection.get();

      return querySnapshot.docs
          .map((doc) => doc.data()) // no need for fromFirestore
          .whereType<UserCollectionModel>() // safety check
          .toList();
    } catch (e) {
      log('Error fetching all users -> $e');
      return []; // Return empty list on failure
    }
  }

  Future<UserCollectionModel?> updateUser(
      {UserCollectionModel? userData}) async {
    try {
      final docRef = _userCollection.doc(userData?.id);
      await docRef.set(userData!);
      final snapShot = await docRef.get();
      return snapShot.data();
    } catch (e) {
      log('error update user $e');
      return null;
    }
  }

  Future<List<UsageTypeModel>> getUsageType() async {
    try {
      final querySnapshot = await _usageTypeCollection.get();
      return querySnapshot.docs
          .map((doc) => doc.data())
          .whereType<UsageTypeModel>()
          .toList();
    } catch (e) {
      log('error usage type $e');
      return [];
    }
  }

  Future<List<PropertyTypeModel>> getPropertyType() async {
    try {
      final querySnapshot = await _propertyTypeCollection.get();
      return querySnapshot.docs
          .map((doc) => doc.data())
          .whereType<PropertyTypeModel>()
          .toList();
    } catch (e) {
      log('error get property type data $e');
      return [];
    }
  }

  Future<List<PropertyDescriptionModel>> getPropertyDescription({
    required String propertyId,
  }) async {
    try {
      final querySnapshot = await _propertyDescriptionCollection
          .where(
            'propertyTypeId',
            isEqualTo: propertyId,
          )
          .get();
      return querySnapshot.docs
          .map((doc) => doc.data())
          .whereType<PropertyDescriptionModel>()
          .toList();
    } catch (e) {
      log('error property description $e');
      return [];
    }
  }

  Future<SurveyModel?> saveSurveyForm({required SurveyModel surveyData}) async {
    try {
      final docRef = _surveyCollection.doc(surveyData.id);
      await docRef.set(surveyData);
      final snapshot = await docRef.get();

      return snapshot.data();
    } catch (e) {
      log('Log: error to save survey form data -> $e');
      return null;
    }
  }

  Future<List<SurveyModel>> getSurveyData({required String userId}) async {
    try {
      final querySnap = await _surveyCollection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnap.docs
          .map((doc) => doc.data())
          .whereType<SurveyModel>()
          .toList();
    } catch (e) {
      log('Log: get error in get survey data $e');
      return [];
    }
  }
}

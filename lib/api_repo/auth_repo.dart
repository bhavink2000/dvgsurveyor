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
            toFirestore: (model, _) => model.toJson(),
          );

  /// Get user by username+password OR mobile number
  Future<UserCollectionModel?> getUser({
    String? username,
    String? password,
    String? mobileNumber,
    String? userId,
    String? gamName, // new field to update
  }) async {
    try {
      QuerySnapshot<UserCollectionModel> querySnapshot;

      // Step 1: Get user by mobile or username/password
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
      } else if (userId != null) {
        // if userId is directly passed
        final docRef = _userCollection.doc(userId);
        final snapshot = await docRef.get();
        return snapshot.data();
      } else {
        return null; // no valid params
      }

      // Step 2: If user found, update gamName
      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first;
        final userId = userDoc.id;

        // Only update if gamName is provided
        if (gamName != null && gamName.isNotEmpty) {
          await _userCollection.doc(userId).update({'gamName': gamName});
        }

        // Step 3: Get updated snapshot
        final updatedSnapshot = await _userCollection.doc(userId).get();
        return updatedSnapshot.data();
      }
    } catch (e) {
      log('Error fetching or updating user: $e');
    }

    return null;
  }

  /// Save new user
  Future<UserCollectionModel?> saveUser({UserCollectionModel? user}) async {
    try {
      final docRef = _userCollection.doc(user?.id);
      final newModel = user?.copyWith(id: docRef.id);
      await docRef.set(newModel!);
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
      var querySnapshot;
      if (propertyId == '') {
        querySnapshot = await _propertyDescriptionCollection.get();
      } else {
        querySnapshot = await _propertyDescriptionCollection
            .where(
              'propertyTypeId',
              isEqualTo: propertyId,
            )
            .get();
      }
      return querySnapshot.docs
          .map((doc) => doc.data())
          .whereType<PropertyDescriptionModel>()
          .toList();
    } catch (e) {
      log('error property description $e');
      return [];
    }
  }

  // Future<SurveyModel?> saveSurveyForm({
  //   required SurveyModel surveyData,
  //   bool? isEditData = false,
  //   bool? isPendingData = false,
  // }) async {
  //   try {
  //     final docRef = _surveyCollection.doc(surveyData.id);

  //     if (isEditData == true && isPendingData == false) {
  //       await docRef.update(surveyData.toJson()); // Convert model to Map
  //     } else {
  //       await docRef.set(surveyData);
  //     }

  //     final snapshot = await docRef.get();

  //     if (isPendingData == true) {
  //       await deletePendingSurvey(surveyId: surveyData.id);
  //     }
  //     return snapshot.data();
  //   } catch (e) {
  //     log('Log: error to save survey form data -> $e');
  //     return null;
  //   }
  // }

  // Future<List<SurveyModel>> getSurveyData({required String userId}) async {
  //   try {
  //     final querySnap;
  //     if (userId != '' || userId.isNotEmpty) {
  //       querySnap = await _surveyCollection
  //           .where('userId', isEqualTo: userId)
  //           .orderBy('createdAt', descending: true)
  //           .get();
  //     } else {
  //       querySnap = await _surveyCollection
  //           .orderBy('createdAt', descending: true)
  //           .get();
  //     }

  //     return querySnap.docs
  //         .map((doc) => doc.data())
  //         .whereType<SurveyModel>()
  //         .toList();
  //   } catch (e) {
  //     log('Log: get error in get survey data $e');
  //     return [];
  //   }
  // }

  Future<PropertyTypeModel?> addUpdatePropertyType({
    required PropertyTypeModel proData,
    bool isEdit = false,
    bool isDelete = false,
  }) async {
    try {
      final docRef = _propertyTypeCollection.doc(proData.id);

      // DELETE
      if (isDelete) {
        await docRef.delete();
        return null; // No need to fetch deleted doc
      }

      //  ADD or UPDATE
      final dataToSave = isEdit ? proData : proData.copyWith(id: docRef.id);

      await docRef.set(dataToSave);

      final snapshot = await docRef.get();

      return snapshot.exists ? snapshot.data() : null;
    } catch (e) {
      log("Error in addUpdatePropertyType: $e");
      return null;
    }
  }

  Future<PropertyDescriptionModel?> addUpdatePropertyDesc(
      {required PropertyDescriptionModel proDescData,
      bool isEdit = false,
      bool isDelete = false}) async {
    try {
      final docRef = _propertyDescriptionCollection.doc(proDescData.id);

      if (isDelete) {
        await docRef.delete();
        return null;
      }

      final dataSave =
          isEdit ? proDescData : proDescData.copyWith(id: docRef.id);

      await docRef.set(dataSave);

      final snapshot = await docRef.get();

      return snapshot.exists ? snapshot.data() : null;
    } catch (e) {
      log('Error in add update property Desc $e');
      return null;
    }
  }

  // Future<SurveyModel?> deleteSurvey({String? surveyId}) async {
  //   try {
  //     final docRef = _surveyCollection.doc(surveyId);
  //     await docRef.delete();
  //     return null;
  //   } catch (e) {
  //     log('Log error in delete survey ->$e');
  //     return null;
  //   }
  // }

  Future<void> deleteUser({String? userId}) async {
    try {
      if (userId != null) {
        await _userCollection.doc(userId).delete();
      }
    } catch (e) {
      log('Error deleting user: $e');
    }
  }

  Future<SurveyModel?> deletePendingSurvey({String? surveyId}) async {
    try {
      await FirebaseFirestore.instance
          .collection(FirebaseConst.pendingCollection)
          .doc(surveyId)
          .delete();
    } catch (e) {
      log('Log error in delete survey ->$e');
      return null;
    }
    return null;
  }

  // ✅ New method: listen to user document changes
  Stream<UserCollectionModel?> listenUser(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .withConverter<UserCollectionModel>(
          fromFirestore: (snap, _) =>
              UserCollectionModel.fromJson(snap.data()!),
          toFirestore: (user, _) => user.toJson(),
        )
        .doc(userId)
        .snapshots()
        .map((doc) => doc.data());
  }

  Future<SurveyModel?> saveSurveyInsideWorkerCityWise({
    required String workerId,
    required String cityName,
    required SurveyModel surveyData,
    bool? isEditData = false,
    bool? isPendingData = false,
  }) async {
    try {
      // path: surveys/{workerId}/{cityName}/{surveyId}
      final docRef = _surveyCollection
          .doc(workerId)
          .collection(cityName)
          .doc(surveyData.id);

      if (isEditData == true && isPendingData == false) {
        await docRef.update(surveyData.toJson());
      } else {
        await docRef.set(surveyData.toJson()); // always use Map for Firestore
      }

      final snapshot = await docRef.get();

      if (isPendingData == true) {
        await deletePendingSurvey(surveyId: surveyData.id);
      }

      // Convert back to SurveyModel
      return snapshot.exists ? SurveyModel.fromJson(snapshot.data()!) : null;
    } catch (e) {
      log('Log: error to save survey form data -> $e');
      return null;
    }
  }

  Future<List<SurveyModel>> getSurveyInsideWorkerCityWise({
    required String workerId,
    required String cityName,
  }) async {
    try {
      //final querySnap;
      final querySnap =
          await _surveyCollection.doc(workerId).collection(cityName).get();

      return querySnap.docs
          .map((doc) => SurveyModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      log('Log: get error in get survey data $e');
      return [];
    }
  }

  Future<void> deleteSurveyInsideWorkerCityWise(
      {required String workerId,
      required String cityName,
      required String surveyId}) async {
    try {
      if (workerId.isNotEmpty) {
        await _surveyCollection
            .doc(workerId)
            .collection(cityName)
            .doc(surveyId)
            .delete();
      }
    } catch (e) {
      log('Error deleting user: $e');
    }
  }

  Future<int> getNextSurveyIndex({
    required String workerId,
    required String cityName,
  }) async {
    final querySnap =
        await _surveyCollection.doc(workerId).collection(cityName).get();

    return querySnap.docs.length + 1; // next index
  }
}

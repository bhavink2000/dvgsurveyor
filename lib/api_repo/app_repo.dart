import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dvgsurveyor/helper/firebase_const.dart';
import 'package:dvgsurveyor/model/gam_model.dart';
import 'package:dvgsurveyor/model/surveyor_form_model.dart';

class AppRepo {
  AppRepo._();
  static final AppRepo instance = AppRepo._();

  factory AppRepo() => instance;

  CollectionReference<GamModel> get _gamCollection => FirebaseFirestore.instance
      .collection(FirebaseConst.gamNameCollection)
      .withConverter<GamModel>(
        fromFirestore: (snapshot, _) => GamModel.fromFirestore(snapshot),
        toFirestore: (model, _) => model.toFirestore(),
      );

  CollectionReference<SurveyModel> get _surveyCollection =>
      FirebaseFirestore.instance
          .collection(FirebaseConst.surveyCollection)
          .withConverter<SurveyModel>(
            fromFirestore: (snapshot, _) => SurveyModel.fromFirebase(snapshot),
            toFirestore: (model, _) => model.toFirebase(),
          );

  Future<List<GamModel>> getGam() async {
    try {
      final querySnapshot = await _gamCollection.get();

      return querySnapshot.docs
          .map((doc) => doc.data())
          .whereType<GamModel>()
          .toList();
    } catch (e) {
      log('Error in get gam $e');
      return [];
    }
  }

  Future<GamModel?> addUpdateCity({
    required GamModel cityData,
    bool isEdit = false,
    bool isDelete = false,
  }) async {
    try {
      final docRef = _gamCollection.doc(cityData.id);

      // DELETE
      if (isDelete) {
        await docRef.delete();
        return null; // No need to fetch deleted doc
      }

      //  ADD or UPDATE
      final dataToSave = isEdit ? cityData : cityData.copyWith(id: docRef.id);

      await docRef.set(dataToSave);

      final snapshot = await docRef.get();

      return snapshot.exists ? snapshot.data() : null;
    } catch (e) {
      log("Error in addUpdatePropertyType: $e");
      return null;
    }
  }

  Future<List<SurveyModel>> getSurveyDataByCityDateWorker({
    required String userId,
    String? cityName, // optional
    DateTime? startDate, // optional
    DateTime? endDate, // optional
    String? workerId,
  }) async {
    try {
      Query query = _surveyCollection;

      if (userId.isNotEmpty || userId != '') {
        query = query.where('userId', isEqualTo: userId);
      }

      if (cityName != null && cityName.isNotEmpty) {
        query = query.where('gamName', isEqualTo: cityName);
      }

      if (startDate != null) {
        query = query.where('createdAt',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startDate));
      }

      if (endDate != null) {
        // Add 1 day to include the full end date
        final adjustedEnd = endDate.add(const Duration(days: 1));
        query = query.where('createdAt',
            isLessThan: Timestamp.fromDate(adjustedEnd));
      }

      if (workerId != null) {
        query = query.where('userId', isEqualTo: workerId);
      }

      query = query.orderBy('createdAt', descending: true);

      final querySnap = await query.get();

      return querySnap.docs
          .map((doc) => doc.data())
          .whereType<SurveyModel>()
          .toList();
    } catch (e) {
      log('Log: get error in getSurveyData $e');
      return [];
    }
  }
}

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dvgsurveyor/helper/firebase_const.dart';
import 'package:dvgsurveyor/model/gam_model.dart';
import 'package:dvgsurveyor/model/surveyor_form_model.dart';
import 'package:intl/intl.dart';

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

  // CollectionReference<SurveyModel> get _surveyCollection =>
  //     FirebaseFirestore.instance
  //         .collection(FirebaseConst.surveyCollection)
  //         .withConverter<SurveyModel>(
  //           fromFirestore: (snapshot, _) => SurveyModel.fromFirebase(snapshot),
  //           toFirestore: (model, _) => model.toJson(),
  //         );

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

  // Future<List<SurveyModel>> getSurveyDataByCityDateWorker({
  //   required String userId,
  //   String? cityName, // optional
  //   DateTime? startDate, // optional
  //   DateTime? endDate, // optional
  //   String? workerId,
  // }) async {
  //   try {
  //     Query query = _surveyCollection;

  //     if (userId.isNotEmpty || userId != '') {
  //       query = query.where('userId', isEqualTo: userId);
  //     }

  //     if (cityName != null && cityName.isNotEmpty) {
  //       query = query.where('gamName', isEqualTo: cityName);
  //     }

  //     if (startDate != null) {
  //       query = query.where('createdAt',
  //           isGreaterThanOrEqualTo: Timestamp.fromDate(startDate));
  //     }

  //     if (endDate != null) {
  //       // Add 1 day to include the full end date
  //       final adjustedEnd = endDate.add(const Duration(days: 1));
  //       query = query.where('createdAt',
  //           isLessThan: Timestamp.fromDate(adjustedEnd));
  //     }

  //     if (workerId != null) {
  //       query = query.where('userId', isEqualTo: workerId);
  //     }

  //     query = query.orderBy('createdAt', descending: true);

  //     final querySnap = await query.get();

  //     return querySnap.docs
  //         .map((doc) => doc.data())
  //         .whereType<SurveyModel>()
  //         .toList();
  //   } catch (e) {
  //     log('Log: get error in getSurveyData $e');
  //     return [];
  //   }
  // }

  Future<List<SurveyModel>> getSurveyByCityWiseData({
    required String cityName,
  }) async {
    final stopwatch = Stopwatch()..start();
    log('🔹 getCityWiseSurveys started: city="$cityName",');

    try {
      // Fetch all surveys from all subcollections named cityName
      final querySnap =
          await FirebaseFirestore.instance.collectionGroup(cityName).get();

      log('🔹 Raw query returned ${querySnap.docs.length} documents');

      // Convert to SurveyModel
      final allSurveys = querySnap.docs
          .map((doc) => SurveyModel.fromJson(doc.data()))
          .toList();
      log('🔹 Converted to SurveyModel: ${allSurveys.length} items');

      // Local filtering
      final filtered = allSurveys.where((survey) {
        final matchesCity =
            cityName != null ? survey.gamName == cityName : true;
        return matchesCity;
      }).toList();

      log('🔹 After local filtering: ${filtered.length} surveys');

      // Sort by createdAt descending
      filtered.sort(
          (a, b) => b.createdAt?.compareTo(a.createdAt ?? DateTime(0)) ?? 0);

      stopwatch.stop();
      log('🔹 getCityWiseSurveys finished in ${stopwatch.elapsedMilliseconds} ms');

      log('🔹 Final filtered count: ${filtered.length}');

      return filtered;
    } catch (e, s) {
      log('❌ Error in getCityWiseSurveys: $e\nStack: $s');
      return [];
    }
  }

  Future<void> archiveSurveysByCity({
    required String cityName,
    required List<SurveyModel> surveys,
    required String archivedBy,
  }) async {
    final firestore = FirebaseFirestore.instance;

    final formattedDate = DateFormat('ddMMyyyy').format(DateTime.now());
    final archiveDocId = "${cityName.toLowerCase()}$formattedDate";

    final archiveDocRef = firestore
        .collection(FirebaseConst.archiveSurveyCollection)
        .doc(archiveDocId);
    final archiveSurveysCollection = archiveDocRef
        .collection(FirebaseConst.surveyCollection)
        .withConverter<SurveyModel>(
          fromFirestore: (snapshot, _) => SurveyModel.fromFirebase(snapshot),
          toFirestore: (model, _) => model.toJson(),
        );

    try {
      // Step 1: Archive all surveys
      WriteBatch batch = firestore.batch();
      int counter = 0;

      for (final survey in surveys) {
        final archiveDoc = archiveSurveysCollection.doc(survey.id);
        batch.set(archiveDoc, survey);
        counter++;

        // Commit every 450 writes (safe margin under 500)
        if (counter % 450 == 0) {
          await batch.commit();
          batch = firestore.batch();
        }
      }
      await batch.commit();

      // Step 2: Save metadata
      await archiveDocRef.set({
        'archivedBy': archivedBy,
        'archivedOn': FieldValue.serverTimestamp(),
        'totalSurveys': surveys.length,
        'city': cityName,
      });

      // Step 3: Delete original data
      WriteBatch deleteBatch = firestore.batch();
      counter = 0;
      for (final survey in surveys) {
        final originalDoc =
            firestore.collection(FirebaseConst.surveyCollection).doc(survey.id);
        deleteBatch.delete(originalDoc);
        counter++;

        if (counter % 450 == 0) {
          await deleteBatch.commit();
          deleteBatch = firestore.batch();
        }
      }
      await deleteBatch.commit();
    } catch (e, st) {
      log('Error archiving surveys for $cityName: $e\n$st');
      throw Exception('Failed to archive surveys. Please try again later.');
    }
  }

  Future<List<SurveyModel>> getCityWiseSurveys({
    String? cityName,
    String? workerId,
  }) async {
    final stopwatch = Stopwatch()..start();
    log('🔹 getCityWiseSurveys started: city="$cityName", worker="$workerId"');

    try {
      // Fetch all surveys from all subcollections named cityName
      final querySnap = await FirebaseFirestore.instance
          .collectionGroup(cityName ?? '')
          .get();

      log('🔹 Raw query returned ${querySnap.docs.length} documents');

      // Convert to SurveyModel
      final allSurveys = querySnap.docs
          .map((doc) => SurveyModel.fromJson(doc.data()))
          .toList();
      log('🔹 Converted to SurveyModel: ${allSurveys.length} items');

      // Local filtering
      final filtered = allSurveys.where((survey) {
        final matchesWorker =
            workerId != null ? survey.userId == workerId : true;
        final matchesCity =
            cityName != null ? survey.gamName == cityName : true;
        return matchesWorker && matchesCity;
      }).toList();

      log('🔹 After local filtering: ${filtered.length} surveys');

      // Sort by createdAt descending
      filtered.sort(
          (a, b) => b.createdAt?.compareTo(a.createdAt ?? DateTime(0)) ?? 0);

      stopwatch.stop();
      log('🔹 getCityWiseSurveys finished in ${stopwatch.elapsedMilliseconds} ms');

      log('🔹 Final filtered count: ${filtered.length}');

      return filtered;
    } catch (e, s) {
      log('❌ Error in getCityWiseSurveys: $e\nStack: $s');
      return [];
    }
  }
}

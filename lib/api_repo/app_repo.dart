import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dvgsurveyor/helper/firebase_const.dart';
import 'package:dvgsurveyor/model/gam_model.dart';

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
}

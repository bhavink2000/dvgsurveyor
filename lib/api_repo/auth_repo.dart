import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dvgsurveyor/helper/firebase_const.dart';
import 'package:dvgsurveyor/model/user_collection_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepoProvider = Provider<AuthRepo>((ref) {
  return AuthRepo();
});

class AuthRepo {
  AuthRepo();

  CollectionReference<UserCollectionModel> get userCollection =>
      FirebaseFirestore.instance
          .collection(FirebaseConst.userCollection)
          .withConverter<UserCollectionModel>(
            fromFirestore: (snapshot, _) =>
                UserCollectionModel.fromFirestore(snapshot),
            toFirestore: (model, _) => model.toFirestore(),
          );

  Future<UserCollectionModel?> getUserByUsername({
    String? username,
    String? password,
    String? mobileNUmber,
  }) async {
    try {
      final querySnapshot;
      if (mobileNUmber != null) {
        querySnapshot = await userCollection
            .where('mobileNumber', isEqualTo: mobileNUmber)
            .limit(1)
            .get();
      } else {
        querySnapshot = await userCollection
            .where('username', isEqualTo: username)
            .where('password', isEqualTo: password) // fixed here
            .limit(1)
            .get();
      }

      if (querySnapshot.docs.isNotEmpty) {
        final data = querySnapshot.docs.first.data();
        return data; // assuming your model
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching user by username: $e');
      return null;
    }
  }

  Future<UserCollectionModel?> saveUser({
    required UserCollectionModel userDetails,
  }) async {
    try {
      // 1. Set user data to Firestore
      final docRef = userCollection.doc(userDetails.id);
      await docRef.set(userDetails);

      // 2. Get user data back
      final snapshot = await docRef.get();
      if (snapshot.exists) {
        return snapshot.data(); // returns UserCollectionModel
      } else {
        print('User not found');
        return null;
      }
    } catch (e) {
      print('Error saving user: $e');
      return null;
    }
  }

  Future<UserCollectionModel?> getUserId(String userId) async {
    try {
      final docSnapshot = await userCollection.doc(userId).get();
      if (docSnapshot.exists) {
        return docSnapshot.data();
      } else {
        print('User not found');
        return null;
      }
    } catch (e) {
      print('Error fetching user by ID: $e');
      return null;
    }
  }
}

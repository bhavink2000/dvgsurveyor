import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dvgsurveyor/helper/firebase_const.dart';
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

  /// Get user by username+password OR mobile number
  Future<UserCollectionModel?> getUser({
    String? username,
    String? password,
    String? mobileNumber,
  }) async {
    try {
      QuerySnapshot<UserCollectionModel> querySnapshot;

      if (mobileNumber != null) {
        querySnapshot = await _userCollection
            .where('mobileNumber', isEqualTo: mobileNumber)
            .limit(1)
            .get();
      } else {
        querySnapshot = await _userCollection
            .where('username', isEqualTo: username)
            .where('password', isEqualTo: password)
            .limit(1)
            .get();
      }

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data();
      }
    } catch (e) {
      print('Error fetching user: $e');
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
      print('Error saving user: $e');
      return null;
    }
  }
}

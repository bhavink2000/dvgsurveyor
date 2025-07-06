import 'package:get_storage/get_storage.dart';
import 'package:dvgsurveyor/model/user_collection_model.dart';

class SessionManager {
  static final GetStorage _storage = GetStorage();

  static const _userKey = 'user';

  /// Save user session as whole object (JSON)
  static Future<void> saveUser({UserCollectionModel? user}) async {
    await _storage.write(_userKey, user?.toJson());
  }

  /// Get user session
  static UserCollectionModel? getUser() {
    final userJson = _storage.read<Map<String, dynamic>>(_userKey);
    if (userJson != null) {
      return UserCollectionModel.fromJson(userJson);
    }
    return null;
  }

  /// Check login status
  static bool isLoggedIn() {
    return _storage.hasData(_userKey);
  }

  /// Clear user session (logout)
  static Future<void> clearSession() async {
    await _storage.remove(_userKey);
  }
}

import 'package:dvgsurveyor/model/user_collection_model.dart';
import 'package:dvgsurveyor/session_manager/session_manger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appDrawerController =
    ChangeNotifierProvider((ref) => AppDrawerController());

class AppDrawerController extends ChangeNotifier {
  String userName = '';

  UserCollectionModel? userData;
  bool? isLoading = false;

  AppDrawerController() {
    loadUserName();
  }

  Future<void> loadUserName() async {
    userName = await SessionManager.getUsername() ?? '';
    notifyListeners();
  }

  void logout() {
    // Add your FirebaseAuth logout or session clear here
    debugPrint("User logged out");
  }
}

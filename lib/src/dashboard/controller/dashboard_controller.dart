import 'package:dvgsurveyor/session_manager/session_manger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardController =
    ChangeNotifierProvider((ref) => DashboardController());

class DashboardController extends ChangeNotifier {
  String userName = '';

  void getUserDataFromSesstion() async {
    userName = await SessionManager.getUsername() ?? '';
    notifyListeners();
  }
}

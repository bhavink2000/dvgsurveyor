import 'package:dvgsurveyor/session_manager/session_manger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardController = Provider((ref) => DashboardController());

class DashboardController {
  String userName = '';
  
  void getUserDataFromSesstion() async {
    userName = await SessionManager.getUsername() ?? '';
  }
}

import 'package:dvgsurveyor/helper/app_colors.dart';
import 'package:get/get.dart';

class AppSnackbar {
  static void showSnackbar({
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 2),
  }) {
    Get.snackbar(
      title ?? 'Success', // Title (optional, leave empty)
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.tealDark,
      colorText: AppColors.offWhite,
      borderRadius: 8,
      duration: duration,
    );
  }

  static void showErrorSnackbar(
      {required String message,
      Duration duration = const Duration(seconds: 2)}) {
    Get.snackbar(
      'Error!',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.coralAccent,
      colorText: AppColors.offWhite,
      borderRadius: 8,
      duration: duration,
    );
  }
}

import 'package:dvgsurveyor/src/excel_data_screen/controller/excel_pik_data_controller.dart';
import 'package:get/get.dart';

class ExcelPikDataBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExcelPikDataController>(() => ExcelPikDataController());
  }
}

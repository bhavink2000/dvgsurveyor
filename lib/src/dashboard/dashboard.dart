// dashboard_screen.dart
import 'package:dvgsurveyor/src/dashboard/controller/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardScreen extends GetWidget<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Dashboard Screen', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

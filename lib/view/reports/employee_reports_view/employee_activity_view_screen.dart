import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class EmployeeActivityReportWindow extends StatefulWidget {
  const EmployeeActivityReportWindow({super.key});

  @override
  State<EmployeeActivityReportWindow> createState() => _EmployeeActivityReportWindowState();
}

class _EmployeeActivityReportWindowState extends State<EmployeeActivityReportWindow> {
  bool isFullScreen = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: AnimatedContainer(duration: Duration(milliseconds: 300),
          width: isFullScreen ? Get.width : Get.width * 0.85,
          height: isFullScreen ? Get.width : Get.width * 0.85,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: isFullScreen ? BorderRadius.zero : BorderRadius.circular(12),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 15)],
          ),
          child: Column(
            children: [

            ],
          ),
        ),
      ),
    );
  }
}

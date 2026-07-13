import 'package:dashboard_new1/component/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Isko add krein date/time format ke liye

import '../../component/textStyle.dart';
import 'controller/setting_controller.dart';

class WallboardScreen extends StatefulWidget {
  const WallboardScreen({super.key});

  @override
  State<WallboardScreen> createState() => _WallboardScreenState();
}

class _WallboardScreenState extends State<WallboardScreen> {
  final SettingController controller = Get.isRegistered<SettingController>()
      ? Get.find<SettingController>()
      : Get.put(SettingController());

  Stream<DateTime> _timeStream() {
    return Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(
        initState: (v) {},
        builder: (controller) {
          return LayoutBuilder(builder: (context, constraints) {
            final double maxWidth = constraints.maxWidth;
            final bool isMobile = maxWidth < 600;
            final bool isTablet = maxWidth >= 600 && maxWidth < 1024;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Container(
                    width: Get.width,
                    padding: const EdgeInsets.all(16.0),
                    color: DynamicColors.gryClr.withOpacity(0.5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Image(
                              image: AssetImage('assets/logo.jpeg'),
                              width: 70,
                              height: 70,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "NEXUS",
                                  style: mozillaTextSemiBoldText(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border.all(
                                        color: Colors.purple, width: 1.5),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.computer,
                                          size: 16, color: Colors.purple),
                                      const SizedBox(width: 6),
                                      Text(
                                        "WALLBOARD",
                                        style: mozillaTextSemiBoldText(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12)
                                            .copyWith(color: Colors.purple),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              "WALLBOARD",
                              style: mozillaTextSemiBoldText(
                                  fontWeight: FontWeight.w800, fontSize: 22),
                            ),
                          ),
                        ),
                        StreamBuilder<DateTime>(
                          stream: _timeStream(),
                          builder: (context, snapshot) {
                            final now = snapshot.data ?? DateTime.now();
                            final formattedDate =
                                DateFormat('dd MMM yyyy').format(now);
                            final formattedTime =
                                DateFormat('HH:mm:ss').format(now);

                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  formattedDate,
                                  style: mozillaTextSemiBoldText(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                                SizedBox(width: 2),
                                Text(
                                  formattedTime,
                                  style: mozillaTextSemiBoldText(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14)
                                      .copyWith(color: Colors.black),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          height: 400,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: DynamicColors.gryClr.withOpacity(0.3)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                color: DynamicColors.gryClr.withOpacity(0.5),
                                child: Row(
                                  children: [
                                    const Icon(Icons.event_available_rounded,
                                        color: Colors.blueAccent, size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      "BOOKING OVERVIEW",
                                      style: mozillaTextSemiBoldText(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                              const Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Center(
                                      child: Text("Horizontal Content Area")),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        width: isMobile ? 100 : 400,
                        height: 800,
                        decoration: BoxDecoration(
                          color: DynamicColors.gryClr.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(child: Text("Left Sidebar")),
                      ),
                    ],
                  )
                ],
              ),
            );
          });
        });
  }
}

import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/lacations_controller.dart';

class LocalizationScreen extends StatelessWidget {
  LocalizationScreen({super.key});

  LocationController controller = Get.isRegistered<LocationController>()
      ? Get.find<LocationController>()
      : Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        double tableWidthFactor = screenWidth < 600
            ? 0.95
            : screenWidth < 1000
                ? 0.7
                : 0.5;
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "LOCALIZATION",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  CustomButton(
                    width: 30,
                    onTap: () => _showAddDialog(context),
                    height: 30,
                    verticalPadding: 0.0,
                    widget: Icon(
                      Icons.add,
                      color: DynamicColors.whiteClr,
                    ),
                    style: mozillaTextSemiBoldText(
                      fontSize: 12,
                      color: DynamicColors.whiteClr,
                    ),
                    borderRadius: 4,
                  ),

                  // IconButton(
                  //   onPressed: () => _showAddDialog(context),
                  //   icon: const Icon(
                  //     Icons.add,
                  //     color: Colors.white,
                  //     size: 18,
                  //   ),
                  //   style: IconButton.styleFrom(
                  //     backgroundColor: DynamicColors.primaryClr,
                  //     padding: const EdgeInsets.all(4),
                  //     minimumSize: const Size(28, 28),
                  //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(6),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            // Table
            GetBuilder<LocationController>(builder: (controller) {
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: FractionallySizedBox(
                    widthFactor: tableWidthFactor, // responsive width
                    child: Table(
                      border: const TableBorder(
                        horizontalInside:
                            BorderSide(width: 0.5, color: Colors.grey),
                        verticalInside:
                            BorderSide(width: 0.5, color: Colors.grey),
                        top: BorderSide(width: 0.5, color: Colors.grey),
                        bottom: BorderSide(width: 0.5, color: Colors.grey),
                        left: BorderSide(width: 0.5, color: Colors.grey),
                        right: BorderSide(width: 0.5, color: Colors.grey),
                      ),
                      columnWidths: const {
                        0: FlexColumnWidth(3),
                        1: FlexColumnWidth(1),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(color: Color(0xFFE0E0E0)),
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 20),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "POSTCODE",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 30),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "ACTIONS",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Data rows
                        ...controller.postcodes.asMap().entries.map((entry) {
                          final postcode = entry.value;

                          return TableRow(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 9, horizontal: 20),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    postcode.code,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    splashRadius: 20,
                                    onPressed: () =>
                                        controller.removePostcode(postcode),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }

  void _showAddDialog(BuildContext context) {
    final TextEditingController textController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        title: const Text(
          "POSTCODE",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter Postcode",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "CLOSE",
              style: TextStyle(color: Colors.black87),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            onPressed: () {
              if (textController.text.isNotEmpty) {
                // Provider.of<PostcodeController>(context, listen: false)
                //     .addPostcode(textController.text);
                Navigator.pop(context);
              }
            },
            child: const Text(
              "SAVE",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

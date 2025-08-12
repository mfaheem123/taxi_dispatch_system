


import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/view/dashboard_view/widgets/pickup_widget.dart';
import 'package:dashboard_new1/view/dashboard_view/widgets/time_picker_widget.dart';
import 'package:dashboard_new1/view/dashboard_view/widgets/user_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../component/dropdown_button.dart';
import '../../component/textStyle.dart';
import '../../component/text_field.dart';
import '../../component/text_widget.dart';
import 'Controller/dashboard_controller.dart';
import 'dashboard/shortcut_key_widget.dart';

class CreateBooking extends StatefulWidget {
  const CreateBooking({super.key});

  @override
  State<CreateBooking> createState() => _CreateBookingState();
}

class _CreateBookingState extends State<CreateBooking> {

  String selectedMenu = "";
  String selectedDropdownItem = "";
  DateTime selected = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!Get.isRegistered<DashboardController>()) {
      Get.put(DashboardController());
      print("Controller initialized ✅");
    } else {
      print("Controller already exists, not re-initializing ♻️");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    // Controller initialize only if not already put
    if (!Get.isRegistered<DashboardController>()) {
      Get.put(DashboardController());
    }

    return Scaffold(
      backgroundColor: DynamicColors.whiteClr,
      body: GetBuilder<DashboardController>(
        builder: (controller) {
          return LayoutBuilder(
            builder: (context, constraints) {
              bool isMobile = constraints.maxWidth < 600;
              bool isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 1024;
              bool isWeb = constraints.maxWidth >= 1024;

              double pickupWidth = isMobile
                  ? constraints.maxWidth * 0.9
                  : isTablet
                  ? constraints.maxWidth / 2.5
                  : constraints.maxWidth / 3.5;

              double notesWidth = isMobile
                  ? constraints.maxWidth * 0.9
                  : isTablet
                  ? constraints.maxWidth / 4
                  : constraints.maxWidth / 8;

              return Center(
                child: Container(
                  width: Get.width/1.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: DynamicColors.textClr),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      // Shortcut Keys Row
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ShortcutKeyWidget(keyss: "F1", valuess: "BASE ADDRESS"),
                              const SizedBox(width: 10),
                              ShortcutKeyWidget(keyss: "F2", valuess: "BOOKING FORM"),
                              const SizedBox(width: 10),
                              ShortcutKeyWidget(keyss: "F6", valuess: "QUOTATION"),
                              const SizedBox(width: 10),
                              // Add more shortcut buttons here if needed
                            ],
                          ),
                        ),
                      ),

                      // Booking Title
                      // Top Row aligned with fields
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: DynamicColors.gryClr
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center, // ✅ Vertically center align
                          children: [
                            Text(
                              AppText.booking,
                              style: mozillaTextSemiBoldText(fontSize: 17),
                            ),
                            Container(
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                color: DynamicColors.whiteClr
                              ),// ✅ same as your text field height
                              child: CustomDropdownButton(
                                itemList: ['DEMO COMPANY'],
                                hintText: "DEMO COMPANY",
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      ///todo pickup fields widget
                      // Fields Row / Column Responsive
                      PickupWidget(),
                      ///todo pickup fields widget
                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
                      ///todo pick and drop widget
                      UserInfoWidget(),
                      ///todo pick and drop widget
                      KeyboardDatePicker(
                        initialDate: selected,
                        onChanged: (dt) {
                          // called whenever value changes
                          print('changed: $dt');
                        },
                        onSubmitted: (dt) {
                          print('submitted: $dt');
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget buildMenuTab(IconData icon, String label, String menuKey,
      List<String> items, GlobalKey key) {
    return GestureDetector(
      key: key,
      onTap: () async {
        setState(() {
          selectedMenu = menuKey;
        });

        final RenderBox renderBox =
        key.currentContext!.findRenderObject() as RenderBox;
        final Offset offset = renderBox.localToGlobal(Offset.zero);
        final Size size = renderBox.size;

        final selected = await showMenu<String>(
          context: context,
          position: RelativeRect.fromLTRB(
            offset.dx,
            offset.dy + size.height,
            offset.dx + size.width,
            offset.dy,
          ),
          items: items
              .map((e) => PopupMenuItem<String>(value: e, child: Text(e)))
              .toList(),
          elevation: 8.0,
        );

        if (selected != null) {
          setState(() {
            selectedDropdownItem = selected;
          });
          // if (onMenuSelect != null) {
          //   onMenuSelect!(selected);
          // }
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        decoration: BoxDecoration(
          // color: selectedMenu == menuKey
          //     ? Colors.cyanAccent.shade400
          //     : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: DynamicColors.textClr,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

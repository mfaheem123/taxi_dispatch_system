import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../alert/lost_property_booking_alert.dart';
import '../../component/datatable_widget.dart';
import '../../component/textStyle.dart';
import '../../component/text_field.dart';
import '../../component/text_widget.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';
import '../dashboard_view/booking_table.dart';
import '../dashboard_view/widgets/time_picker_widget.dart';
import '../dashboard_view/widgets/user_info_widget.dart';
import 'controller/customer_controller.dart';

class LostPropertyScreen extends StatefulWidget {
  const LostPropertyScreen({super.key});
  @override
  State<LostPropertyScreen> createState() => _LostPropertyScreenState();
}

class _LostPropertyScreenState extends State<LostPropertyScreen> {
  CustomerController controller = Get.isRegistered<CustomerController>()
      ? Get.find<CustomerController>()
      : Get.put(CustomerController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "lostPropertyScreen";
    if (!controller.lostPropertyValue.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.refreshFields();
      });
    }
    // controller.lostPropertyValue(false);
  }

  int selectedRowIndex = 0;
  final int totalRows = 1;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    return GetBuilder<CustomerController>(builder: (controller) {
      final selectedBooking = controller.selectedBookingForLostProperty;

      String formattedDate = "-";
      if (selectedBooking?.pickupDate != null && selectedBooking.pickupDate.toString().isNotEmpty) {
        try {
          DateTime parsedDate = DateFormat("yyyy-M-d").parse(selectedBooking.pickupDate.toString());
          formattedDate = DateFormat("yyyy-MM-dd").format(parsedDate);
        } catch (_) {
          formattedDate = selectedBooking.pickupDate.toString();
        }
      }

      String formattedTime = "-";
      if (selectedBooking?.pickupTime != null && selectedBooking.pickupTime.toString().isNotEmpty) {
        try {
          formattedTime = selectedBooking.pickupTime.toString().split('.')[0].substring(0, 5);
        } catch (_) {
          formattedTime = selectedBooking.pickupTime.toString();
        }
      }
      return LayoutBuilder(builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final bool isMobile = maxWidth < 600;
        final bool isTablet = maxWidth >= 600 && maxWidth < 1024;
        final bool isLaptop = maxWidth >= 1024 && maxWidth < 1400;
        double mainContainerWidth;
        double fieldWidth;

        if (isMobile) {
          mainContainerWidth = maxWidth;
          fieldWidth = maxWidth;
        } else if (isTablet) {
          mainContainerWidth = (maxWidth - 20) / 2;
          fieldWidth = (mainContainerWidth - 40) / 2;
        } else if (isLaptop) {
          mainContainerWidth = (maxWidth - 25) / 2;
          fieldWidth = (mainContainerWidth - 50) / 2;
        } else {
          mainContainerWidth = (maxWidth - 30) / 2;
          fieldWidth = (mainContainerWidth - 60) / 2;
        }

        return Stack(
          children: [
            SingleChildScrollView(
                child: Column(
              children: [
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    Container(
                      width: mainContainerWidth,
                      constraints: const BoxConstraints(minHeight: 200),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: DynamicColors.gryClr, width: 1.2)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            color: DynamicColors.secondaryClr,
                            padding: const EdgeInsets.all(12),
                            child: Center(
                                child: Text(AppText.lostProperty,
                                    style: mozillaTextSemiBoldText(
                                        fontWeight: FontWeight.w900))),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Wrap(
                              runSpacing: 20,
                              spacing: 15,
                              alignment: WrapAlignment.start,
                              children: [
                                labeledField(
                                  context: context,
                                  isMobile: isMobile,
                                  label: AppText.reportDate,
                                  width: fieldWidth,
                                  column: true,
                                  child: SizedBox(
                                    height: 32,
                                    child: KeyboardDatePicker(
                                      key: ValueKey(controller.reportDateController),
                                      initialDate: controller
                                                  .reportDateController !=""
                                          ? DateTime.parse(
                                              controller.reportDateController)
                                          : DateTime.now(),
                                      onChanged: (date) {
                                        controller.reportDateController = date
                                            .toIso8601String()
                                            .split("T")
                                            .first;
                                        controller.update();
                                      },
                                      onSubmitted: (date) {
                                        controller.reportDateController = date
                                            .toIso8601String()
                                            .split("T")
                                            .first;
                                        controller.update();
                                      },
                                    ),
                                  ),
                                ),
                                // SizedBox(width: fieldWidth/2),
                                labeledField(
                                  context: context,
                                  isMobile: isMobile,
                                  label: AppText.foundDate,
                                  width: fieldWidth,
                                  column: true,
                                  child: SizedBox(
                                    height: 32,
                                    child: KeyboardDatePicker(
                                      key: ValueKey(controller.lostDateController + (controller.selectedBookingForLostProperty?.pickupDate ?? "")),
                                      initialDate: () {
                                        final bookingDate = controller.selectedBookingForLostProperty?.pickupDate;
                                        if (bookingDate != null && bookingDate.isNotEmpty) {
                                          try {
                                            return DateTime.parse(bookingDate);
                                          } catch (e) {
                                            // Fallback
                                          }
                                        }
                                        return controller.lostDateController != ""
                                            ? DateTime.parse(controller.lostDateController)
                                            : DateTime.now();
                                      }(),
                                      onChanged: (date) {
                                        controller.lostDateController = date
                                            .toIso8601String()
                                            .split("T")
                                            .first;
                                        controller.update();
                                      },
                                      onSubmitted: (date) {
                                        controller.lostDateController = date
                                            .toIso8601String()
                                            .split("T")
                                            .first;
                                        controller.update();
                                      },
                                    ),
                                  ),
                                ),
                                CustomTextField(
                                  borderRadius: 4,
                                  controller:
                                      controller.detailOfPropertyController,
                                  width: fieldWidth,
                                  hintText: AppText.detailOfProperty,
                                  columnText: true,
                                  contentPadding:
                                      EdgeInsets.only(left: 10, top: 20),
                                  maxLines: 6,
                                  height: 100,
                                  inputFormatters: [
                                    UpperCaseTextFormatter(),
                                  ],
                                ),
                                CustomTextField(
                                  borderRadius: 4,
                                  controller:
                                      controller.methodOfDespositionController,
                                  width: fieldWidth,
                                  hintText: AppText.methodOfDesposition,
                                  columnText: true,
                                  contentPadding:
                                      EdgeInsets.only(left: 10, top: 20),
                                  maxLines: 6,
                                  height: 100,
                                  inputFormatters: [
                                    UpperCaseTextFormatter(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // const SizedBox(height: 10),
                        ],
                      ),
                    ),
                    Container(
                      width: mainContainerWidth,
                      constraints: const BoxConstraints(minHeight: 280),
                      decoration: BoxDecoration(
                          border: Border.all(color: DynamicColors.gryClr)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            color: DynamicColors.secondaryClr,
                            padding: const EdgeInsets.all(12),
                            child: Center(
                                child: Text(AppText.customer,
                                    style: mozillaTextSemiBoldText(
                                        fontWeight: FontWeight.w900))),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Wrap(
                              runSpacing: 20,
                              spacing: 15,
                              children: [
                                CustomTextField(
                                  borderRadius: 4,
                                  controller: controller.propertyNameController,
                                  width: fieldWidth,
                                  hintText: AppText.name,
                                  columnText: true,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                                    UpperCaseTextFormatter(),
                                  ],
                                  suffixIcon: (controller
                                                  .lostPropertyUpdateId.value == null ||
                                          controller
                                                  .lostPropertyUpdateId.value ==
                                              0)
                                      ? GestureDetector(
                                          onTap: () async {
                                            // GestureDetector(
                                            //   onTap: () async {
                                            if (controller.propertyNameController.text
                                                .isNotEmpty) {
                                              var result = await Get.dialog(
                                                LostPropertyBookingAlert(
                                                    searchQuery: controller
                                                        .propertyNameController.text),
                                              );
                                              if (result != null) {
                                                controller
                                                        .selectedBookingForLostProperty =
                                                    result;
                                                controller.updateBookingId = int.tryParse(result.id.toString());
                                                controller.updateCustomerId = int.tryParse(result.customerId.toString());
                                                if (result.pickupDate != null && result.pickupDate.isNotEmpty) {
                                                  controller.lostDateController = result.pickupDate;
                                                }
                                                controller.propertyMobileController
                                                    .text = result.mobile ?? "";
                                                controller.update();
                                              }
                                            } else {
                                              BotToast.showText(
                                                  text:
                                                      "PLEASE ENTER NAME FIRST!");
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade300,
                                              border: Border.all(
                                                  color: DynamicColors.gryClr),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: const Icon(Icons.search,
                                                size: 25, color: Colors.black),
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KeyboardListener(
                                      focusNode: FocusNode(),
                                      onKeyEvent: (event) {
                                        if (controller.getPhoneNumbersModel
                                                ?.customer !=
                                            null) {
                                          int listLength = controller
                                              .getPhoneNumbersModel!
                                              .customer!
                                              .length;
                                          if (event is KeyDownEvent) {
                                            if (event.logicalKey ==
                                                LogicalKeyboardKey.arrowDown) {
                                              controller.selectedIndex =
                                                  (controller.selectedIndex +
                                                          1) %
                                                      listLength;
                                              controller.scrollToIndex(
                                                  controller.selectedIndex);
                                              controller.update();
                                            } else if (event.logicalKey ==
                                                LogicalKeyboardKey.arrowUp) {
                                              controller.selectedIndex =
                                                  (controller.selectedIndex -
                                                          1 +
                                                          listLength) %
                                                      listLength;
                                              controller.scrollToIndex(
                                                  controller.selectedIndex);
                                              controller.update();
                                            } else if (event.logicalKey ==
                                                    LogicalKeyboardKey.enter &&
                                                controller.selectedIndex !=
                                                    -1) {
                                              var selectedUser = controller
                                                      .getPhoneNumbersModel!
                                                      .customer![
                                                  controller.selectedIndex];
                                              controller.propertyNameController.text =
                                              (selectedUser.name ?? "").toUpperCase();
                                              controller.propertyMobileController.text =
                                                  selectedUser.mobile ?? "";
                                              controller
                                                      .propertyAddressController.text =
                                              (selectedUser.address1 ?? "").toUpperCase();
                                              controller.getPhoneNumbersModel =
                                                  null;
                                              controller.selectedIndex = -1;
                                              controller.update();
                                            }
                                          }
                                        }
                                      },
                                      child: CustomTextField(
                                        borderRadius: 4,
                                        controller: controller.propertyMobileController,
                                        width: fieldWidth,
                                        hintText: AppText.mobileNo,
                                        columnText: true,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                        ],
                                        onChanged: (val) {
                                          controller.selectedIndex = -1;
                                          if (val.isNotEmpty) {
                                            controller.getCustomerNumbers(val);
                                          } else {
                                            controller.getPhoneNumbersModel =
                                                null;
                                            controller.update();
                                          }
                                        },
                                        suffixIcon: GestureDetector(
                                          onTap: () async {
                                            if (controller.propertyMobileController.text
                                                .isNotEmpty) {
                                              var result = await Get.dialog(
                                                LostPropertyBookingAlert(
                                                    searchQuery: controller
                                                        .propertyMobileController.text),
                                              );
                                              if (result != null) {
                                                controller
                                                        .selectedBookingForLostProperty =
                                                    result;
                                                // controller.updateBookingId = result.id;
                                                // controller.updateCustomerId = result.customerId;
                                                controller.updateBookingId = int.tryParse(result.id.toString());
                                                controller.updateCustomerId = int.tryParse(result.customerId.toString());
                                                if (result.pickupDate != null && result.pickupDate.isNotEmpty) {
                                                  controller.lostDateController = result.pickupDate;
                                                }
                                                controller.update();
                                              }
                                            } else {
                                              BotToast.showText(
                                                  text:
                                                      "PLEASE ENTER MOBILE FIRST!");
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade300,
                                              border: Border.all(
                                                  color: DynamicColors.gryClr),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: const Icon(Icons.search,
                                                size: 25, color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                CustomTextField(
                                  borderRadius: 4,
                                  controller: controller.propertyAddressController,
                                  width: fieldWidth,
                                  hintText: AppText.address,
                                  columnText: true,
                                  contentPadding:
                                      EdgeInsets.only(left: 10, top: 20),
                                  maxLines: 6,
                                  height: 100,
                                  inputFormatters: [
                                    UpperCaseTextFormatter(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: DatatableWidget(
                        columns: [
                          buildHeaderWithSearch(
                              title: "REF #", removeSearching: true),
                          buildHeaderWithSearch(
                              title: "DATETIME", removeSearching: true),
                          buildHeaderWithSearch(
                              title: "VEHICLE", removeSearching: true),
                          buildHeaderWithSearch(
                              title: "PICKUP", removeSearching: true),
                          buildHeaderWithSearch(
                              title: "DROPOFF", removeSearching: true),
                        ],
                        rows: controller.selectedBookingForLostProperty == null
                            ? []
                            : [
                                DataRow(
                                  cells: [
                                    DataCell(Center(
                                        child: Text((controller
                                                .selectedBookingForLostProperty
                                                .referenceNumber ??
                                            "-").toUpperCase()))),
                                    DataCell(Center(
                                        child: Text(
                                            "$formattedDate $formattedTime".toUpperCase()))),
                                    DataCell(Center(
                                        child: Text((controller
                                                .selectedBookingForLostProperty
                                                .vehicleType
                                                ?.name ??
                                            "-").toUpperCase()))),
                                    DataCell(Center(
                                        child: Text((controller
                                                .selectedBookingForLostProperty
                                                .pickup ??
                                            "-").toUpperCase()))),
                                    DataCell(Center(
                                        child: Text((controller
                                                .selectedBookingForLostProperty
                                                .dropoff ??
                                            "-").toUpperCase()))),
                                  ],
                                ),
                              ]),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  color: DynamicColors.secondaryClr,
                  padding: const EdgeInsets.all(12),
                  child: Center(
                      child: Text(AppText.enquiry,
                          style: mozillaTextSemiBoldText(
                              fontWeight: FontWeight.w900))),
                ),
                Container(
                  // width: fieldWidth * 2.0,
                  // padding: EdgeInsets.symmetric(vertical: 10),
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: DynamicColors.gryClr, width: 1.2)),
                  child: Wrap(
                    spacing: 30,
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: [
                      Column(
                        children: [
                          CustomTextField(
                            borderRadius: 4,
                            controller: controller.checkedByController,
                            width: fieldWidth,
                            hintText: AppText.checkedBy,
                            columnText: true,
                            inputFormatters: [
                              UpperCaseTextFormatter(),
                            ],
                          ),
                          SizedBox(height: 25),
                          CustomTextField(
                            borderRadius: 4,
                            controller: controller.enquiryController,
                            width: fieldWidth,
                            hintText: AppText.enquiry,
                            columnText: true,
                            contentPadding: EdgeInsets.only(left: 10, top: 20),
                            maxLines: 6,
                            height: 100,
                            inputFormatters: [
                              UpperCaseTextFormatter(),
                            ],
                          ),
                        ],
                      ),
                      CustomTextField(
                        borderRadius: 4,
                        controller: controller.resultController,
                        width: fieldWidth,
                        hintText: AppText.result,
                        columnText: true,
                        contentPadding: EdgeInsets.only(left: 10, top: 20),
                        maxLines: 12,
                        height: 170,
                        inputFormatters: [
                          UpperCaseTextFormatter(),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              CustomButton(
                  onTap: () {
                    controller.saveLostProperty();
                  },
                  borderRadius: 4,
                  verticalPadding: 0.0,
                  fontSize: 17,
                  height: 30,
                  width: fieldWidth * 0.9,
                btnText: (controller.lostPropertyValue.value || controller.lostPropertyUpdateId.value != 0)
                    ? "UPDATE"
                    : AppText.save,
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            )),
            if (controller.getPhoneNumbersModel?.customer != null &&
                controller.getPhoneNumbersModel!.customer!.isNotEmpty &&
                controller.propertyMobileController.text.isNotEmpty)
              Positioned(
                // top: 120,
                top: isMobile ? 250 : (isTablet ? 400 : 120),
                // left: (fieldWidth * 2) + (fieldWidth * 0.92) + 50,
                left: isMobile
                    ? 15
                    : isTablet
                    ? (mainContainerWidth + 30)
                    : (mainContainerWidth + fieldWidth + 50),
                        // ? (fieldWidth * 1.02)
                        // : (fieldWidth * 2) + (fieldWidth * 0.92) + 50,
                child: Material(
                  elevation: 15,
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade200,
                  child: Container(
                    width: fieldWidth,
                    constraints: const BoxConstraints(maxHeight: 300),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200, width: 2),
                    ),
                    child: ListView.builder(
                      controller: controller.listScrollController,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount:
                          controller.getPhoneNumbersModel!.customer!.length,
                      itemBuilder: (context, index) {
                        var user =
                            controller.getPhoneNumbersModel!.customer![index];
                        bool isSelected = controller.selectedIndex == index;

                        return InkWell(
                          onTap: () {
                            controller.propertyNameController.text = (user.name ?? "").toUpperCase();
                            controller.propertyMobileController.text =
                                user.mobile ?? "";
                            controller.propertyAddressController.text =
                            (user.address1 ?? "").toUpperCase();

                            controller.getPhoneNumbersModel = null;
                            controller.selectedIndex = -1;
                            controller.update();

                            FocusScope.of(context).unfocus();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            color: isSelected
                                ? Colors.blue.withOpacity(0.15)
                                : Colors.transparent,
                            child: Text(
                              "${user.name?.toUpperCase() ?? ""}  ${user.mobile ?? ""}",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
          ],
        );
      });
    });
  }
}

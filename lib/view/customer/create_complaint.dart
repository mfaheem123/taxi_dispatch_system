import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/alert/f4_get_booking.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../Model/driver_models/driver_model.dart' as hide;
import 'package:dashboard_new1/view/customer/controller/get_driver_dropdown.dart';
import '../../alert/back_slash_alert.dart';
import '../../alert/customer_complaint_alert.dart';
import '../../alert/f3.alert.dart';
import '../../alert/f4_alert.dart' show showDriverEarningsAlert;
import '../../component/color.dart';
import '../../component/customButton.dart';
import '../../component/datatable_widget.dart';
import '../../component/dropdown_button.dart';
import '../../component/textStyle.dart';
import '../../component/text_field.dart';
import '../../component/text_widget.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';
import '../dashboard_view/booking_table.dart';
import '../dashboard_view/widgets/time_picker_widget.dart';
import '../dashboard_view/widgets/user_info_widget.dart';
import 'controller/customer_controller.dart';

class CreateComplaint extends StatefulWidget {
  const CreateComplaint({super.key});

  @override
  State<CreateComplaint> createState() => _CreateComplaintState();
}

class _CreateComplaintState extends State<CreateComplaint> {
  CustomerController controller = Get.isRegistered<CustomerController>()
      ? Get.find<CustomerController>()
      : Get.put(CustomerController());
  DateTime safeParseDate(String date) {
    try {
      List<String> parts = date.split('-');

      if (parts.length == 3) {
        return DateTime.parse(
          "${parts[0]}-${parts[1].padLeft(2, '0')}-${parts[2].padLeft(2, '0')}",
        );
      }

      return DateTime.now();
    } catch (e) {
      return DateTime.now();
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    shortCutKeyValue.value = "createComplaint";
    controller.getDriversDropdown(); //  add this
  }

  int selectedRowIndex = 0; // currently selected row
  final int totalRows = 1; // total rows (dynamic list ke hisaab se change hoga)

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    return GetBuilder<CustomerController>(builder: (controller) {
      return LayoutBuilder(builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final bool isMobile = maxWidth < 600;
        final bool isTablet = maxWidth >= 600 && maxWidth < 1024;

        // Instead of fixed width, we calculate flexible field widths
        final double fieldWidth = isMobile
            ? maxWidth // full width
            : isTablet
                ? maxWidth / 2
                : maxWidth / 4;
        return Stack(children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Wrap(
                  children: [
                    Container(
                      //padding:  const EdgeInsets.only(left: 10),
                      width: fieldWidth * 2.0,
                      decoration: BoxDecoration(
                          border: Border.all(color: DynamicColors.gryClr)),
                      child: Wrap(
                        runSpacing: 20,
                        spacing: fieldWidth / 15,
                        children: [
                          Container(
                            //margin: EdgeInsets.only(top:10),
                            color: DynamicColors.secondaryClr,
                            padding: const EdgeInsets.all(17),
                            child: Center(
                                child: Text(AppText.customer,
                                    style: titleDesign())),
                          ),
                          //complaint date
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: labeledField(
                              context: context,
                              isMobile: isMobile,
                              label: AppText.complainDate,
                              width: fieldWidth / 1.5,
                              column: true,
                              child: SizedBox(
                                height: 30,
                                child: KeyboardDatePicker(
                                  key: ValueKey(
                                      controller.complainDateController.text),
                                  initialDate: controller.complainDateController
                                          .text.isNotEmpty
                                      ? safeParseDate(controller
                                          .complainDateController.text)
                                      : DateTime.now(),
                                  onChanged: (date) {
                                    controller.complainDateController.text =
                                        date.toIso8601String().split("T").first;

                                    controller.update();
                                  },
                                  onSubmitted: (date) {
                                    controller.complainDateController.text =
                                        date.toIso8601String().split("T").first;

                                    controller.update();
                                  },
                                ),
                              ),
                            ),
                          ),
                          // incident date
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: labeledField(
                              context: context,
                              isMobile: isMobile,
                              label: AppText.incidentDate,
                              width: fieldWidth / 1.5,
                              column: true,
                              child: SizedBox(
                                  height: 30,
                                  child: KeyboardDatePicker(
                                    key: ValueKey(
                                        controller.incidentedController.text),
                                    initialDate: controller.incidentedController
                                            .text.isNotEmpty
                                        ? safeParseDate(controller
                                            .incidentedController.text)
                                        : DateTime.now(),
                                    onChanged: (date) {
                                      controller.incidentedController.text =
                                          date
                                              .toIso8601String()
                                              .split("T")
                                              .first;

                                      controller.update();
                                    },
                                    onSubmitted: (date) {
                                      controller.incidentedController.text =
                                          date
                                              .toIso8601String()
                                              .split("T")
                                              .first;

                                      controller.update();
                                    },
                                  )),
                            ),
                          ),
                          //name
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: CustomTextField(
                              borderRadius: 4,
                              controller: controller.customerNameController,
                              textCapitalization: TextCapitalization.characters,
                              width: fieldWidth / 1.5,
                              hintText: AppText.name,
                              columnText: true,
                              readOnly: true,
                            ),
                          ),
                          // phone number field
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                KeyboardListener(
                                  focusNode: controller.complaintFocusNode, // Controller me FocusNode bana lo
                                  autofocus: true,
                                  onKeyEvent: (event) {
                                    if (controller.complaintPhoneNumbersModel?.customer == null ||
                                        controller.complaintPhoneNumbersModel!.customer!.isEmpty) {
                                      return;
                                    }

                                    int listLength =
                                        controller.complaintPhoneNumbersModel!.customer!.length;

                                    if (event is KeyDownEvent) {
                                      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                                        if (controller.complaintSelectedIndex < listLength - 1) {
                                          controller.complaintSelectedIndex++;
                                        } else {
                                          controller.complaintSelectedIndex = 0;
                                        }

                                        controller.scrollToIndex(controller.complaintSelectedIndex);
                                        controller.update();
                                      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                                        if (controller.complaintSelectedIndex > 0) {
                                          controller.complaintSelectedIndex--;
                                        } else {
                                          controller.complaintSelectedIndex = listLength - 1;
                                        }

                                        controller.scrollToIndex(controller.complaintSelectedIndex);
                                        controller.update();
                                      } else if (event.logicalKey == LogicalKeyboardKey.enter &&
                                          controller.complaintSelectedIndex != -1) {
                                        var selectedUser = controller
                                            .complaintPhoneNumbersModel!
                                            .customer![controller.complaintSelectedIndex];

                                        controller.customerNameController.text =
                                            (selectedUser.name ?? "").toUpperCase();

                                        controller.customerMobileController.text =
                                            selectedUser.mobile ?? "";

                                        controller.address1Controller.text =
                                            (selectedUser.address1 ?? "").toUpperCase();

                                        controller.complaintPhoneNumbersModel = null;
                                        controller.complaintSelectedIndex = -1;
                                        controller.update();

                                        FocusScope.of(context).unfocus();
                                      }
                                    }
                                  },
                                  child: CustomTextField(
                                    borderRadius: 4,
                                    controller: controller.customerMobileController,
                                    width: fieldWidth / 1.5,
                                    hintText: AppText.mobileNo,
                                    columnText: true,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    onChanged: (val) {
                                      controller.complaintSelectedIndex = -1;

                                      if (val.isNotEmpty) {
                                        controller.getComplaintCustomerNumbers(val);
                                      } else {
                                        controller.complaintPhoneNumbersModel = null;
                                        controller.update();
                                      }
                                    },
                                    suffixIcon: GestureDetector(
                                      onTap: () async {
                                        if (controller.customerMobileController.text.isNotEmpty) {
                                          var result = await Get.dialog(
                                            ComplaintBookingAlert(
                                              searchQuery: controller.customerMobileController.text,
                                            ),
                                          );

                                          if (result != null) {
                                            controller.selectedBookingForComplaint = result;
                                            controller.fillComplaintFromBooking(result);
                                            controller.update();
                                          }
                                        } else {
                                          BotToast.showText(
                                            text: "Please enter mobile first!",
                                          );
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          border: Border.all(color: DynamicColors.gryClr),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: const Icon(
                                          Icons.search,
                                          size: 25,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // KeyboardListener(
                                //   focusNode: FocusNode(),
                                //   onKeyEvent: (event) {
                                //     if (controller.complaintPhoneNumbersModel
                                //             ?.customer !=
                                //         null) {
                                //       int listLength = controller
                                //           .complaintPhoneNumbersModel!
                                //           .customer!
                                //           .length;
                                //
                                //       if (event is KeyDownEvent) {
                                //         if (event.logicalKey ==
                                //             LogicalKeyboardKey.arrowDown) {
                                //           controller.selectedIndex =
                                //               (controller.selectedIndex + 1) %
                                //                   listLength;
                                //           controller.scrollToIndex(
                                //               controller.selectedIndex);
                                //           controller.update();
                                //         } else if (event.logicalKey ==
                                //             LogicalKeyboardKey.arrowUp) {
                                //           controller.selectedIndex =
                                //               (controller.selectedIndex -
                                //                       1 +
                                //                       listLength) %
                                //                   listLength;
                                //           controller.scrollToIndex(
                                //               controller.selectedIndex);
                                //           controller.update();
                                //         } else if (event.logicalKey ==
                                //                 LogicalKeyboardKey.enter &&
                                //             controller.selectedIndex != -1) {
                                //           var selectedUser = controller
                                //                   .getPhoneNumbersModel!
                                //                   .customer![
                                //               controller.selectedIndex];
                                //
                                //           controller
                                //                   .customerNameController.text =
                                //               (selectedUser.name ?? "")
                                //                   .toUpperCase();
                                //           controller.customerNameController
                                //               .text = selectedUser.mobile ?? "";
                                //           controller.address1Controller.text =
                                //               (selectedUser.address1 ?? "")
                                //                   .toUpperCase();
                                //
                                //           controller
                                //                   .complaintPhoneNumbersModel =
                                //               null;
                                //           controller.selectedIndex = -1;
                                //           controller.update();
                                //         }
                                //       }
                                //     }
                                //   },
                                //   child: CustomTextField(
                                //     borderRadius: 4,
                                //     controller:
                                //         controller.customerMobileController,
                                //     width: fieldWidth / 1.5,
                                //     hintText: AppText.mobileNo,
                                //     columnText: true,
                                //     inputFormatters: [
                                //       FilteringTextInputFormatter.digitsOnly,
                                //     ],
                                //     onChanged: (val) {
                                //       controller.complaintSelectedIndex = -1;
                                //
                                //       if (val.isNotEmpty) {
                                //         controller
                                //             .getComplaintCustomerNumbers(val);
                                //       } else {
                                //         controller.complaintPhoneNumbersModel =
                                //             null;
                                //         controller.update();
                                //       }
                                //     },
                                //     suffixIcon: GestureDetector(
                                //       onTap: () async {
                                //         if (controller.customerMobileController
                                //             .text.isNotEmpty) {
                                //           var result = await Get.dialog(
                                //             ComplaintBookingAlert(
                                //               searchQuery: controller
                                //                   .customerMobileController
                                //                   .text,
                                //             ),
                                //           );
                                //
                                //           if (result != null) {
                                //             controller
                                //                     .selectedBookingForComplaint =
                                //                 result;
                                //
                                //             controller.update();
                                //           }
                                //           if (result != null) {
                                //             controller.fillComplaintFromBooking(
                                //                 result);
                                //           }
                                //         } else {
                                //           BotToast.showText(
                                //             text: "Please enter mobile first!",
                                //           );
                                //         }
                                //       },
                                //       child: Container(
                                //         decoration: BoxDecoration(
                                //           color: Colors.grey.shade300,
                                //           border: Border.all(
                                //               color: DynamicColors.gryClr),
                                //           borderRadius:
                                //               BorderRadius.circular(4),
                                //         ),
                                //         child: const Icon(
                                //           Icons.search,
                                //           size: 25,
                                //           color: Colors.black,
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // ),

                                if (controller
                                            .complaintPhoneNumbersModel?.customer !=
                                        null &&
                                    controller.complaintPhoneNumbersModel!
                                        .customer!.isNotEmpty &&
                                    controller.customerMobileController.text
                                        .isNotEmpty)
                                  Container(
                                    width: fieldWidth / 1.5,
                                    constraints:
                                        const BoxConstraints(maxHeight: 250),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.blue.shade200,
                                        width: 2,
                                      ),
                                    ),
                                    child: ListView.builder(
                                      controller:
                                          controller.listScrollController,
                                      shrinkWrap: true,
                                      itemCount: controller
                                          .complaintPhoneNumbersModel!
                                          .customer!
                                          .length,
                                      itemBuilder: (context, index) {
                                        var user = controller
                                            .complaintPhoneNumbersModel!
                                            .customer![index];

                                        bool isSelected =
                                            controller.complaintSelectedIndex ==
                                                index;

                                        return InkWell(
                                          onTap: () {
                                            controller.customerNameController
                                                    .text =
                                                (user.name ?? "").toUpperCase();
                                            controller.customerMobileController
                                                .text = user.mobile ?? "";
                                            // controller.address1Controller.text =
                                            //     (user.address1 ?? "").toUpperCase();

                                            controller
                                                    .complaintPhoneNumbersModel =
                                                null;
                                            controller.complaintSelectedIndex =
                                                -1;
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
                                              "${user.name?.toUpperCase() ?? ""} ${user.mobile ?? ""}",
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: fieldWidth * 2.0,
                      decoration: BoxDecoration(
                          border: Border.all(color: DynamicColors.gryClr)),
                      child: Wrap(
                        runSpacing: 25,
                        spacing: fieldWidth /15,
                        children: [
                          Container(
                            color: DynamicColors.secondaryClr,
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Center(child: Text(AppText.booking, style: titleDesign())),
                                Spacer(),
                                Radio(
                                    value: 0,
                                    groupValue: controller.bookingRadio,
                                    onChanged: (v) {
                                      controller.bookingRadio = v!;
                                      controller.update();
                                    }),
                                Text(
                                  AppText.driver,
                                  style: mozillaTextRegularText(fontSize: 11),
                                ),
                                Radio(
                                    value: 1,
                                    groupValue: controller.bookingRadio,
                                    onChanged: (v) {
                                      controller.bookingRadio = v!;
                                      controller.update();
                                    }),
                                Text(
                                  AppText.employee,
                                  style: mozillaTextRegularText(fontSize: 11),
                                ),
                                Radio(
                                    value: 2,
                                    groupValue: controller.bookingRadio,
                                    onChanged: (v) {
                                      controller.bookingRadio = v!;
                                      controller.update();
                                    }),
                                Text(
                                  AppText.account,
                                  style: mozillaTextRegularText(fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                          // ref no
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: CustomTextField(
                              borderRadius: 4,
                              controller: controller.customerRefNoController,
                              textCapitalization: TextCapitalization.characters,
                              width: fieldWidth / 1.5,
                              hintText: AppText.refNo,
                              columnText: true,
                              // suffixIcon: Icon(Icons.search),
                            ),
                          ),
                         // driver dropdown
                          CustomDropdownField<Driver>(
                            text: AppText.driver,
                            width: fieldWidth / 2.5,
                            label: "SELECT DRIVER",
                            items: controller.driverList,
                            itemLabel: (Driver d) => controller.capitalizeWords(d.name ?? ""),
                            value: controller.driverList.firstWhereOrNull(
                                  (e) => e.id.toString() == controller.selectedDriver?.id.toString(),
                            ),
                            onChanged: (Driver? val) {
                              controller.selectedDriver = val;
                              controller.update();
                            },
                          ),
                         //  CustomDropdownField<Driver>(
                         //    text: AppText.driver,
                         //    width: fieldWidth / 2.5,
                         //    label: "SELECT DRIVER",
                         //    items: controller.driverList,
                         //    itemLabel: (Driver d) => d.name ?? "No Name",
                         //    value: controller.driverList.contains(controller.selectedDriver)
                         //        ? controller.selectedDriver
                         //        : null,
                         //    onChanged: (Driver? val) {
                         //      controller.selectedDriver = val;
                         //      controller.update();
                         //    },
                         //  ),
                          // registration No
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: CustomTextField(
                              borderRadius: 4,
                              controller: controller.regController,
                              width: fieldWidth / 2.5,
                              hintText: "REG. #",
                              columnText: true,
                            ),
                          ),
                          //notes
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: CustomTextField(
                              borderRadius: 4,
                              controller: controller.customerNoteController,
                              textCapitalization: TextCapitalization.characters,
                              width: fieldWidth / 1.5,
                              hintText: AppText.note,
                              columnText: true,
                              readOnly: true,
                              contentPadding:
                                  EdgeInsets.only(left: 10, top: 20),
                              maxLines: 6,
                              height: 100,
                            ),
                          ),
                         // complaint
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: CustomTextField(
                              borderRadius: 4,
                              controller: controller.complaintController,
                              textCapitalization: TextCapitalization.characters,
                              width: fieldWidth / 1.15,
                              hintText: AppText.complaint.toString().toUpperCase(),
                              columnText: true,
                              contentPadding:
                                  EdgeInsets.only(left: 10, top: 20),
                              maxLines: 6,
                              height: 100,
                            ),
                          ),
                          //howDealWithController
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                            child: CustomTextField(
                              borderRadius: 4,
                              controller: controller.howDealWithController,
                              textCapitalization: TextCapitalization.characters,
                              width: fieldWidth / 1.5,
                              hintText: AppText.howDealWith,
                              columnText: true,
                            ),
                          ),
                          //result
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4),
                            child: CustomTextField(
                              borderRadius: 4,
                              controller: controller.resultController,
                              textCapitalization: TextCapitalization.characters,
                              width: fieldWidth / 1.5,
                              hintText: AppText.result,
                              columnText: true,
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
                            title: "PICKUP", removeSearching: true),
                        buildHeaderWithSearch(
                            title: "DROPOFF", removeSearching: true),
                      ],
                      totalRow: totalRows,
                      cells: [
                        DataCell(
                          Center(
                            child: Text(
                              controller.pickupAddress.isEmpty
                                  ? "-"
                                  : controller.pickupAddress,
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: Text(
                              controller.dropoffAddress.isEmpty
                                  ? "-"
                                  : controller.dropoffAddress,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                CustomButton(
                  borderRadius: 4,
                  verticalPadding: 0.0,
                  fontSize: 11,
                  height: 35,
                  btnText: controller.complaintValue.value
                      ? "Update"
                      : AppText.save,
                  onTap: () {
                    controller.postComplaint();

                  },
                ),
                SizedBox(
                  height: 10,
                ),
                    ElevatedButton(onPressed: (){showDriverInfoAlert();}, child: Text("F3")),
                ElevatedButton(onPressed: (){showDriverEarningsAlert();}, child: Text("F4")),
                ElevatedButton(onPressed: (){DriverBookingsAlert.show();}, child: Text("F4 get")),
                ElevatedButton(onPressed: (){showSystemShortcutsAlert();}, child: Text("back_slash_alert  ")),
              ]
            ),
          ),
        ]);
      });
    });
  }
}

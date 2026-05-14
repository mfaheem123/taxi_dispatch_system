import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../component/color.dart';
import '../../../component/datatable_widget.dart';
import '../../../component/dropdown_button.dart';
import '../../../component/keyboard_checkBox_widget.dart';
import '../../../component/radio_button_widget.dart';
import '../../../component/text_field.dart';
import '../../customer/model/restricDriver.dart';
import '../../dashboard_view/booking_table.dart';
import '../../dashboard_view/widgets/time_picker_widget.dart';
import '../../dashboard_view/widgets/user_info_widget.dart';
import '../controller/report_controller.dart';

class AllBookingView extends StatefulWidget {
  const AllBookingView({super.key});

  @override
  State<AllBookingView> createState() => _AllBookingViewState();
}

class _AllBookingViewState extends State<AllBookingView> {
  int selectedRowIndex = 0;
  final int totalRows = 5;

  ReportController controller = Get.isRegistered<ReportController>()
      ? Get.find<ReportController>()
      : Get.put(ReportController());

  DateTime fromDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime toDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportController>(initState: (state) {
      controller.selectDriverObject = null;
      controller.getAllDrivers();
      controller.bookingStartTimeController.text = "12:00";
      controller.bookingEndTimeController.text =
          DateFormat('HH:mm').format(DateTime.now());
    }, builder: (controller) {
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

        return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsetsGeometry.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: DynamicColors.gryClr),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            AppText.status,
                            style: mozillaTextRegularText(fontSize: 12),
                          ),
                          StatusRadioGroup(
                            options: [
                              "ALL",
                              "COMPLETED",
                              "INCOMPLETE",
                              "MISSED",
                              "DECLINED",
                              "CANCELLED",
                            ],
                            onChanged: (index, value) {
                              debugPrint(
                                  "Selected index: $index, value: $value");
                              // controller.selectedValue = index;
                            },
                          ),
                          const Spacer(),
                          Wrap(
                            spacing: 12,
                            children: [
                              KeyboardCheckbox(
                                focusNode: controller.ptNode,
                                value: controller.ptValue.value,
                                label: AppText.pt,
                                width: 60,
                                onChanged: (val) {
                                  controller.ptValue.value = val;
                                  controller.update();
                                },
                              ),
                              KeyboardCheckbox(
                                focusNode: controller.cashNode,
                                value: controller.cashValue.value,
                                label: AppText.cash,
                                width: 70,
                                onChanged: (val) {
                                  controller.cashValue.value = val;
                                  controller.update();
                                },
                              ),
                              KeyboardCheckbox(
                                focusNode: controller.creditCardNode,
                                value: controller.creditCardValue.value,
                                label: AppText.creditCard,
                                width: 120,
                                onChanged: (val) {
                                  controller.creditCardValue.value = val;
                                  controller.update();
                                },
                              ),
                              KeyboardCheckbox(
                                focusNode: controller.accountNode,
                                value: controller.accountValue.value,
                                label: AppText.account,
                                width: 100,
                                onChanged: (val) {
                                  controller.accountValue.value = val;
                                  controller.update();
                                },
                              ),
                              KeyboardCheckbox(
                                focusNode: controller.creditCardPaidNode,
                                value: controller.creditCardPaidValue.value,
                                label: AppText.creditCardPaid,
                                width: 160,
                                onChanged: (val) {
                                  controller.creditCardPaidValue.value = val;
                                  controller.update();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Wrap(
                        spacing: 10,
                        runSpacing: 16,
                        children: [
                          labeledField(
                            context: context,
                            isMobile: isMobile,
                            label: "FROM:",
                            column: false,
                            width: fieldWidth / 2.2,
                            child: SizedBox(
                              height: 30,
                              child: KeyboardDatePicker(
                                initialDate: fromDate,
                                onChanged: (date) =>
                                    setState(() => fromDate = date),
                              ),
                            ),
                          ),
                          labeledField(
                            context: context,
                            isMobile: isMobile,
                            label: "",
                            column: false,
                            width: fieldWidth / 2.9,
                            child: CustomTimePicker(
                              controller: controller.bookingStartTimeController,
                              onTimeSelected: (time) => setState(() {}),
                            ),
                          ),
                          // To Date
                          labeledField(
                            context: context,
                            isMobile: isMobile,
                            label: "TO:",
                            column: false,
                            width: fieldWidth / 2.2,
                            child: SizedBox(
                              height: 30,
                              child: KeyboardDatePicker(
                                initialDate: toDate,
                                onChanged: (date) =>
                                    setState(() => toDate = date),
                              ),
                            ),
                          ),

                          // End Time
                          labeledField(
                            context: context,
                            isMobile: isMobile,
                            label: "",
                            column: false,
                            width: fieldWidth / 2.9,
                            child: CustomTimePicker(
                              controller: controller.bookingEndTimeController,
                              onTimeSelected: (time) => setState(() {}),
                            ),
                          ),

                          CustomTextField(
                            borderRadius: 4,
                            controller: controller.customerController,
                            width: fieldWidth / 2.2,
                            hintText: AppText.customer,
                          ),
                          CustomTextField(
                            borderRadius: 4,
                            controller: controller.nameController,
                            width: fieldWidth / 2.2,
                            hintText: AppText.name,
                          ),
                          CustomTextField(
                            borderRadius: 4,
                            controller: controller.phoneController,
                            width: fieldWidth / 2.2,
                            hintText: AppText.tel,
                          ),
                          CustomDropdownField<DriverObject>(
                            label: "SELECT DRIVERS",
                            width: fieldWidth / 2,
                            // height: 35,
                            items: controller.allDriverData?.drivers ?? [],
                            value: controller.allDriverData?.drivers?.any((d) => d.id == controller.selectDriverObject?.id) ?? false
                                ? controller.allDriverData!.drivers!.firstWhere((d) => d.id == controller.selectDriverObject?.id)
                                : null,
                            itemLabel: (driver) =>
                            driver.name ?? "".toUpperCase(),
                            onChanged: (val) {
                              controller.selectDriverObject = val;
                              controller.update();
                            },
                          ),
                          CustomTextField(
                            borderRadius: 4,
                            controller: controller.pickUpController,
                            width: fieldWidth / 1.7,
                            hintText: "PICKUP",
                          ),
                          CustomTextField(
                            borderRadius: 4,
                            controller: controller.dropOffController,
                            width: fieldWidth / 1.7,
                            hintText: "DROPOFF",
                          ),
                          CustomDropdownField<String>(
                            width: fieldWidth / 1.6,
                            label: AppText.selectAccount,
                            items: [
                              "ACCOUNT 1",
                              "ACCOUNT 2",
                              "ACCOUNT 3",
                              "ACCOUNT 4",
                              "ACCOUNT 5",
                            ],
                            value: controller.selectAccount,
                            itemLabel: (val) => val,
                            onChanged: (val) {
                              controller.selectAccount = val!;
                              controller.update();
                            },
                          ),
                          CustomDropdownField<String>(
                            width: fieldWidth / 1.6,
                            label: AppText.selectDepartment,
                            items: [
                              "Department 1",
                              "Department 2",
                              "Department 3",
                              "Department 4",
                              "Department 5",
                            ],
                            value: controller.selectDepartment,
                            itemLabel: (val) => val,
                            onChanged: (val) {
                              controller.selectDepartment = val!;
                              controller.update();
                            },
                          ),
                          CustomTextField(
                            borderRadius: 4,
                            controller: controller.orderNumberController,
                            width: fieldWidth / 1.7,
                            hintText: AppText.orderNumber,
                          ),
                          CustomTextField(
                            borderRadius: 4,
                            controller: controller.bookedByController,
                            width: fieldWidth / 1.7,
                            hintText: AppText.bookedBy,
                          ),
                          CustomDropdownField<String>(
                            width: fieldWidth / 1.5,
                            label: AppText.selectEmployee,
                            items: [
                              "Employee 1",
                              "Employee 2",
                              "Employee 3",
                              "Employee 4",
                              "Employee 5",
                            ],
                            value: controller.selectEmployee,
                            itemLabel: (val) => val, // just show the string
                            onChanged: (val) {
                              controller.selectEmployee = val!;
                              controller.update();
                            },
                          ),
                          CustomDropdownField<String>(
                            // text: AppText.selectSubsidiary,
                            width: fieldWidth / 1.5,
                            label: AppText.selectSubsidiary,
                            items: [
                              "SUBSIDIARY 1",
                              "SUBSIDIARY 2",
                              "SUBSIDIARY 3",
                              "SUBSIDIARY 4",
                              "SUBSIDIARY 5",
                            ],
                            value: controller.selectSubsidiary,
                            itemLabel: (val) => val, // just show the string
                            onChanged: (val) {
                              controller.selectSubsidiary = val!;
                              controller.update();
                            },
                          ),
                          CustomDropdownField<String>(
                            // text: AppText.selectRefNumber,
                            width: fieldWidth / 1.5,
                            label: AppText.selectRefNumber,
                            items: [
                              "REFERENCE NUMBER 1",
                              "REFERENCE NUMBER 2",
                              "REFERENCE NUMBER 3",
                              "REFERENCE NUMBER 4",
                              "REFERENCE NUMBER 5",
                            ],
                            value: controller.selectRefNumber,
                            itemLabel: (val) => val, // just show the string
                            onChanged: (val) {
                              controller.selectRefNumber = val!;
                              controller.update();
                            },
                          ),
                          CustomDropdownField<String>(
                            // text: AppText.selectRefNumber,
                            width: fieldWidth / 1.5,
                            label: AppText.ascending,
                            items: [
                              "ASCENDING 1",
                              "ASCENDING 2",
                              "ASCENDING 3",
                              "ASCENDING 4",
                              "ASCENDING 5",
                            ],
                            value: controller.selectAscending,
                            itemLabel: (val) => val, // just show the string
                            onChanged: (val) {
                              controller.selectAscending = val!;
                              controller.update();
                            },
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          CustomButton(
                            width: 120,
                            height: 30,
                            borderRadius: 4,
                            verticalPadding: 0.0,
                            btnText: AppText.filter,
                            fontSize: 12,
                          ),
                          CustomButton(
                            width: 120,
                            height: 30,
                            borderRadius: 4,
                            verticalPadding: 0.0,
                            btnText: AppText.view,
                            fontSize: 12,
                          ),
                          CustomButton(
                            width: 120,
                            height: 30,
                            borderRadius: 4,
                            verticalPadding: 0.0,
                            btnText: AppText.statistics,
                            fontSize: 12,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),

                SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                width: MediaQuery.of(context)
                    .size
                    .width,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: FittedBox(
                fit: BoxFit.contain,

                child: DatatableWidget(
                        columns: [
                          buildHeaderWithSearch(title: "REF #"),
                          buildHeaderWithSearch(title: "INVOICE #"),
                          buildHeaderWithSearch(title: "DATETIME"),
                          buildHeaderWithSearch(title: "CUSTOMER"),
                          buildHeaderWithSearch(title: "PICKUP"),
                          buildHeaderWithSearch(title: "DROPOFF"),
                          buildHeaderWithSearch(title: "FARE"),
                          buildHeaderWithSearch(title: "ACC FARE"),
                          buildHeaderWithSearch(title: "ACC"),
                          buildHeaderWithSearch(title: "ORDER #"),
                          buildHeaderWithSearch(title: "P/T"),
                          buildHeaderWithSearch(title: "J/T"),
                          buildHeaderWithSearch(title: "DRV"),
                          buildHeaderWithSearch(title: "VEH"),
                          buildHeaderWithSearch(title: "SUBS"),
                          buildHeaderWithSearch(title: "STATUS"),
                          buildHeaderWithSearch(
                              title: "ACTION",removeSearching: true),
                        ],
                        totalRow: totalRows,
                        cells: [
                          const DataCell(Center(child: Text("#PHC VEHICLE"))),
                          const DataCell(Center(child: Text("20/10/2025"))),
                          const DataCell(Center(child: Text("#PHC VEHICLE"))),
                          const DataCell(Center(child: Text("#PHC VEHICLE"))),
                          const DataCell(Center(child: Text("20/10/2025"))),
                          const DataCell(Center(child: Text("#PHC VEHICLE"))),
                          const DataCell(Center(child: Text("#PHC VEHICLE"))),
                          const DataCell(Center(child: Text("20/10/2025"))),
                          const DataCell(Center(child: Text("#PHC VEHICLE"))),
                          const DataCell(Center(child: Text("#PHC VEHICLE"))),
                          const DataCell(Center(child: Text("20/10/2025"))),
                          const DataCell(Center(child: Text("#PHC VEHICLE"))),
                          const DataCell(Center(child: Text("#PHC VEHICLE"))),
                          const DataCell(Center(child: Text("20/10/2025"))),
                          const DataCell(Center(child: Text("#PHC VEHICLE"))),
                          const DataCell(Center(child: Text("#PHC VEHICLE"))),
                          DataCell(
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                        color: Colors.transparent,
                                      ), // border color & thickness
                                    ),
                                    onPressed: () {},
                                    child: Icon(
                                      Icons.edit_calendar,
                                      size: 28,
                                    ),
                                  ),
                                  Text("|"),
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                        color: Colors.transparent,
                                      ), // border color & thickness
                                    ),
                                    onPressed: () {},
                                    child: Icon(
                                      Icons.delete_forever,
                                      size: 28,
                                      color: DynamicColors.redClr,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]),
                  ),
                ),
                )],
            ));
      });
    });
  }
}

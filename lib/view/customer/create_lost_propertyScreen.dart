import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  }

  int selectedRowIndex = 0; // currently selected row
  final int totalRows = 1;  // total rows (dynamic list ke hisaab se change hoga)

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding
        .instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    return GetBuilder<CustomerController>(
        builder: (controller) {

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

            return Column(
              children: [
                Wrap(
                  children: [
                    Container(
                      width: fieldWidth*2.0,
                      decoration: BoxDecoration(
                          border: Border.all(color: DynamicColors.gryClr)
                      ),
                      child: Wrap(
                        runSpacing: 18,
                        spacing: fieldWidth/2,
                        children: [
                          Container(
                            color: DynamicColors.secondaryClr,
                            padding: const EdgeInsets.all(12),
                            child: Center(child: Text(AppText.lostProperty, style: titleDesign())),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: labeledField(
                              context: context,
                              isMobile: isMobile,
                              label: AppText.reportDate,
                              width: fieldWidth/1.5,
                              column: true,
                              child: SizedBox(height: 30, child: KeyboardDatePicker()),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: labeledField(
                              context: context,
                              isMobile: isMobile,
                              label: AppText.foundDate,
                              width: fieldWidth/1.5,
                              column: true,
                              child: SizedBox(height: 30, child: KeyboardDatePicker()),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: CustomTextField(
                              borderRadius: 4,
                              controller: controller.detailOfPropertyController,
                              width: fieldWidth/1.5,
                              hintText: AppText.detailOfProperty,
                              columnText: true,
                              contentPadding: EdgeInsets.only(left: 10,top: 20),
                              maxLines: 6,
                              height: 100,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: CustomTextField(
                              borderRadius: 4,
                              controller: controller.methodOfDespositionController,
                              width: fieldWidth/1.5,
                              hintText: AppText.methodOfDesposition,
                              columnText: true,
                              contentPadding: EdgeInsets.only(left: 10,top: 20),
                              maxLines: 6,
                              height: 100,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: fieldWidth*2.0,
                      decoration: BoxDecoration(
                        border: Border.all(color: DynamicColors.gryClr)
                      ),
                      child: Wrap(
                        runSpacing: 18,
                        spacing: fieldWidth/2,
                        children: [
                          Container(
                            color: DynamicColors.secondaryClr,
                            padding: const EdgeInsets.all(12),
                            child: Center(child: Text(AppText.customer, style: titleDesign())),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: CustomTextField(
                              borderRadius: 4,
                              controller: controller.nameController,
                              width: fieldWidth/1.5,
                              hintText: AppText.name,
                              columnText: true,
                              suffixIcon: Icon(Icons.search),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: CustomTextField(
                              borderRadius: 4,
                              controller: controller.mobileController,
                              width: fieldWidth/1.5,
                              hintText: AppText.mobileNo,
                              columnText: true,
                              suffixIcon: Icon(Icons.search),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: CustomTextField(
                              borderRadius: 4,
                              controller: controller.address1Controller,
                              width: fieldWidth/1.5,
                              hintText: AppText.address,
                              columnText: true,
                              contentPadding: EdgeInsets.only(left: 10,top: 20),
                              maxLines: 6,
                              height: 100,
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
                          buildHeaderWithSearch(title: "REF #",removeSearching: true),
                          buildHeaderWithSearch(title: "DATETIME",removeSearching: true),
                          buildHeaderWithSearch(title: "VEHICLE",removeSearching: true),
                          buildHeaderWithSearch(title: "PICKUP",removeSearching: true),
                          buildHeaderWithSearch(title: "DROPOFF",removeSearching: true),
                        ],
                        totalRow: totalRows,
                        cells: [
                          const DataCell(Center(child: Text("BCB75029"))),
                          const DataCell(Center(child: Text("07-08-25 06:07"))),
                          const DataCell(Center(child: Text("SALOON"))),
                          const DataCell(Center(child: Text("FLAT 10 BLANDFORD COURT 4-6 BRONDESBURY PARK LONDON NW6 7BP"))),
                          const DataCell(Center(child: Text("10 WARRIOR GARDENS ST. LEONARDS-ON-SEA TN37 6EB"))),
                        ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  color: DynamicColors.secondaryClr,
                  padding: const EdgeInsets.all(12),
                  child: Center(child: Text(AppText.enquiry, style: titleDesign())),
                ),
                Container(
                  width: fieldWidth*2.0,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: DynamicColors.gryClr)
                  ),
                  child: Wrap(
                    runSpacing: 18,
                    spacing: fieldWidth/2,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                        child: CustomTextField(
                          borderRadius: 4,
                          controller: controller.checkedByController,
                          width: fieldWidth,
                          hintText: AppText.checkedBy,
                          columnText: true,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: CustomTextField(
                          borderRadius: 4,
                          controller: controller.enquiryController,
                          width: fieldWidth/1.5,
                          hintText: AppText.enquiry,
                          columnText: true,
                          contentPadding: EdgeInsets.only(left: 10,top: 20),
                          maxLines: 6,
                          height: 100,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: CustomTextField(
                          borderRadius: 4,
                          controller: controller.resultController,
                          width: fieldWidth/1.5,
                          hintText: AppText.result,
                          columnText: true,
                          contentPadding: EdgeInsets.only(left: 10,top: 20),
                          maxLines: 6,
                          height: 100,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                CustomButton(
                  borderRadius: 4,
                  verticalPadding: 0.0,
                  fontSize: 11,
                  height: 30,
                  btnText: AppText.save,
                ),

                SizedBox(
                  height: 10,
                ),
              ],
            );
          }
          );
        }
    );
  }
}
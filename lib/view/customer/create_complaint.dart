


import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "createComplaint";
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
                    child: Center(child: Text(AppText.customer, style: titleDesign())),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: labeledField(
                      context: context,
                      isMobile: isMobile,
                      label: AppText.complainDate,
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
                      label: AppText.incidentDate,
                      width: fieldWidth/1.5,
                      column: true,
                      child: SizedBox(height: 30, child: KeyboardDatePicker()),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: CustomTextField(
                      borderRadius: 4,
                      controller: controller.nameController,
                      width: fieldWidth/1.5,
                      hintText: AppText.name,
                      columnText: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: CustomTextField(
                      borderRadius: 4,
                      controller: controller.mobileController,
                      width: fieldWidth/1.5,
                      hintText: AppText.mobile,
                      columnText: true,
                      suffixIcon: Icon(Icons.search),
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
                        spacing: fieldWidth/6,
                        children: [
                          Container(
                        color: DynamicColors.secondaryClr,
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Text(AppText.booking, style: titleDesign()),
                                Spacer(),
                                Radio(value: 0,
                                    groupValue: controller.bookingRadio,
                                    onChanged: (v){

                                      controller.bookingRadio = v!;
                                      controller.update();
                                    }),
                                Text(AppText.driver,style: mozillaTextRegularText(fontSize: 11),),
                                Radio(value: 1,
                                    groupValue: controller.bookingRadio,
                                    onChanged: (v){
                                      controller.bookingRadio = v!;
                                      controller.update();
                                    }),
                                Text(AppText.employee,style: mozillaTextRegularText(fontSize: 11),),
                                Radio(value: 2,
                                    groupValue: controller.bookingRadio,
                                    onChanged: (v){
                                      controller.bookingRadio = v!;
                                      controller.update();
                                    }),
                                Text(AppText.account,style: mozillaTextRegularText(fontSize: 11),),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: CustomTextField(
                              borderRadius: 4,
                              controller: controller.refNoController,
                              width: fieldWidth/1.5,
                              hintText: AppText.refNo,
                              columnText: true,
                              suffixIcon: Icon(Icons.search),
                            ),
                          ),
                          CustomDropdownField<String>(
                            text: AppText.driver,
                            width: fieldWidth/2.5,
                            label: "SELECT DRIVER", items:[
                            "25 GEORGE HAMPTON",
                            "25 GEORGE HAMPTON",
                            "25 GEORGE HAMPTON",
                            "25 GEORGE HAMPTON",
                            "25 GEORGE HAMPTON",
                            "25 GEORGE HAMPTON",],
                            value: controller.selectDriver,
                            itemLabel: (val) => val, // just show the string
                            onChanged: (val) {
                              controller.selectDriver = val;
                              controller.update();
                            },
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: CustomTextField(
                              borderRadius: 4,
                              controller: controller.regController,
                              width: fieldWidth/2.5,
                              hintText: "REG. #",
                              columnText: true,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: CustomTextField(
                              borderRadius: 4,
                              controller: controller.noteController,
                              width: fieldWidth/1.5,
                              hintText: AppText.note,
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
                              controller: controller.complaintController,
                              width: fieldWidth/1.5,
                              hintText: AppText.complaint,
                              columnText: true,
                              contentPadding: EdgeInsets.only(left: 10,top: 20),
                              maxLines: 6,
                              height: 100,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4),
                            child: CustomTextField(
                              borderRadius: 4,
                              controller: controller.howDealWithController,
                              width: fieldWidth/1.4,
                              hintText: AppText.howDealWith,
                              columnText: true,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4),
                            child: CustomTextField(
                              borderRadius: 4,
                              controller: controller.resultController,
                              width: fieldWidth/1.4,
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
                        buildHeaderWithSearch(title: "PICKUP",removeSearching: true),
                        buildHeaderWithSearch(title: "DROPOFF",removeSearching: true),
                      ],
                      totalRow: totalRows,
                      cells: [
                        const DataCell(Text("FLAT 10 BLANDFORD COURT 4-6 BRONDESBURY PARK LONDON NW6 7BP")),
                        const DataCell(Text("10 WARRIOR GARDENS ST. LEONARDS-ON-SEA TN37 6EB")),
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

import 'package:dashboard_new1/component/customButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../alert/restrict_drivers_alert.dart';
import '../../component/color.dart';
import '../../component/datatable_widget.dart';
import '../../component/dropdown_button.dart';
import '../../component/textStyle.dart';
import '../../component/text_field.dart';
import '../../component/text_widget.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';
import '../dashboard_view/booking_table.dart';
import 'controller/customer_controller.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});


  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {


  CustomerController controller = Get.isRegistered<CustomerController>()
      ? Get.find<CustomerController>()
      : Get.put(CustomerController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "customersScreen";
  }

  int selectedRowIndex = 0; // currently selected row
  final int totalRows = 5;  // total rows (dynamic list ke hisaab se change hoga)

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

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    AppText.customer + " (10)",
                    style: mozillaTextSemiBoldText(
                        fontWeight: FontWeight.w800, fontSize: 17),
                  ),
                  SizedBox(
                    width: 60,
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: CustomButton(
                        height: 40,
                        width: 80,
                        verticalPadding: 0.0,
                        borderRadius: 4,
                        widget: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 0.0),
                          child: Icon(
                            Icons.refresh,
                            color: DynamicColors.whiteClr,
                            size: 25,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  CustomTextField(
                    borderRadius: 4,
                    controller: controller.keyWordsController,
                    width: fieldWidth/1.2,
                    hintText: "ENTER KEYWORDS",
                    columnText: true,
                  ),
                  Column(
                    children: [
                      CustomDropdownField<String>(
                        text: "SELECT TYPE",
                        width: fieldWidth/1.5,
                        label: "SELECT TYPE",
                        items:[
                        "MOBILE",
                        "EMAIL",
                        "SMS",],
                        value: controller.selectFilterType,
                        itemLabel: (val) => val, // just show the string
                        onChanged: (val) {
                          controller.selectFilterType = val!;
                          controller.update();
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: Checkbox(
                        value: controller.blackList.value,
                        onChanged: (v){
                          controller.blackList.value = v!;
                          controller.update();
                        }),
                  ),
                  Text(AppText.blackList,
                    style: mozillaTextSemiBoldText(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: DynamicColors.redClr
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  CustomButton(
                    height: 30,
                    verticalPadding: 0.0,
                    width: 100,
                    btnText: AppText.clear,
                    borderRadius: 4,
                    fontSize: 11,
                    btnColor: DynamicColors.redClr,
                  ),
                  CustomButton(
                    height: 30,
                    verticalPadding: 0.0,
                    width: 100,
                    fontSize: 11,
                    btnText: AppText.search,
                    borderRadius: 4,
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
                      buildHeaderWithSearch(title: "NAME"),
                      buildHeaderWithSearch(title: "MOBILE"),
                      buildHeaderWithSearch(title: "TELEPHONE"),
                      buildHeaderWithSearch(title: "EMAIL"),
                      buildHeaderWithSearch(title: "ADDRESS"),
                      buildHeaderWithSearch(title: "ACTIONS",
                          customWidget: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Colors.transparent,), // border color & thickness
                                ),
                                onPressed: () {},
                                child: Icon(Icons.search,
                                  size: 28,
                                ),
                              ),
                              Text("|"),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Colors.transparent,), // border color & thickness
                                ),
                                onPressed: () {},
                                child: Icon(Icons.close,
                                  size: 28,
                                  color: DynamicColors.redClr,
                                ),
                              ),
                            ],
                          )
                      ),
                    ],
                    totalRow: totalRows,
                    cells: [
                      const DataCell(Text("#PHC VEHICLE")),
                      const DataCell(Text("20/10/2025")),
                      const DataCell(Text("#PHC VEHICLE")),
                      const DataCell(Text("PHC VEHICLE")),
                      const DataCell(Text("PHC VEHICLE")),
                      DataCell(
                        Row(
                          children: [
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.transparent,), // border color & thickness
                              ),
                              onPressed: () {},
                              child: Icon(Icons.edit_calendar,
                                size: 28,
                              ),
                            ),
                            Text("|"),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.transparent,), // border color & thickness
                              ),
                              onPressed: () {},
                              child: Icon(Icons.delete_forever,
                                size: 28,
                                color: DynamicColors.redClr,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]
                  ),
                ),
              ),
            ],
          ),
        );
      });
    });
  }
}

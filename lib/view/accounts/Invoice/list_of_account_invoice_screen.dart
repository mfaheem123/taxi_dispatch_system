import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/datatable_widget.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/view/dashboard_view/widgets/time_picker_widget.dart';
import 'package:dashboard_new1/view/dashboard_view/widgets/user_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../dashboard_view/Controller/dashboard_controller.dart';
import '../../dashboard_view/booking_table.dart';
import '../controller/account_controller.dart';

class ListOfAccountInvoiceScreen extends StatefulWidget {
  const ListOfAccountInvoiceScreen({super.key});

  @override
  State<ListOfAccountInvoiceScreen> createState() =>
      _ListOfAccountInvoiceScreenState();
}

class _ListOfAccountInvoiceScreenState
    extends State<ListOfAccountInvoiceScreen> {
  int selectedRowIndex = 0; // currently selected row
  final int totalRows = 5; // total rows (dynamic list ke hisaab se change hoga)

  AccountController controller = Get.isRegistered<AccountController>()
      ? Get.find<AccountController>()
      : Get.put(AccountController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "ListOfAccountInvoiceScreen";
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    return GetBuilder<AccountController>(builder: (controller) {
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

        return Wrap(
          runSpacing: 10,
          spacing: 10,
          children: [
            Container(
              width: Get.width,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              color: DynamicColors.gryClr.withOpacity(0.5),
              child: Row(
                children: [
                  Text(
                    "ACCOUNTS Invoice (0)",
                    style: mozillaTextSemiBoldText(
                        fontWeight: FontWeight.w800, fontSize: 17),
                  ),
                  Spacer(),
                  CustomButton(
                    verticalPadding: 0.0,
                    width: 60,
                    height: 40,
                    borderRadius: 4,
                    btnText: AppText.create,
                    style: mozillaTextRegularText(
                        fontSize: 10, color: DynamicColors.whiteClr),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  CustomButton(
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
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Wrap(
              children: [
                labeledField(
                  context: context,
                  isMobile: isMobile,
                  label: AppText.from,
                  width: fieldWidth / 1.8,
                  child: SizedBox(height: 30, child: KeyboardDatePicker()),
                ),
                labeledField(
                  context: context,
                  isMobile: isMobile,
                  label: AppText.to,
                  width: fieldWidth / 1.8,
                  child: SizedBox(height: 30, child: KeyboardDatePicker()),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: Get.width,
                child: DatatableWidget(
                  columns: [
                    DataColumn(
                      label: Checkbox(
                        value: false, // a bool you keep in state
                        onChanged: (val) {},
                      ),
                    ),
                    buildHeaderWithSearch(title: "REF #"),
                    buildHeaderWithSearch(title: "DATETIME"),
                    buildHeaderWithSearch(title: "PICKUP"),
                    buildHeaderWithSearch(title: "DROPOFF"),
                    buildHeaderWithSearch(title: "VEH"),
                    buildHeaderWithSearch(title: "J/T"),
                    buildHeaderWithSearch(title: "P/T"),
                    buildHeaderWithSearch(title: "FARE"),
                    buildHeaderWithSearch(title: "PC"),
                    buildHeaderWithSearch(title: "WC"),
                    buildHeaderWithSearch(title: "EDC"),
                    buildHeaderWithSearch(title: "M&G"),
                    buildHeaderWithSearch(title: "Cc"),
                    buildHeaderWithSearch(title: "TOTA"),
                    buildHeaderWithSearch(
                        title: "ACTIONS", removeSearching: true),
                  ],
                  totalRow: totalRows,
                  cells: [
                    DataCell(
                      Checkbox(
                        value: false, // ✅ controlled by your state
                        onChanged: (val) {
                          // update your selected index or list here
                        },
                      ),
                    ),
                    const DataCell(Text("SALOON")),
                    const DataCell(Text("NW7")),
                    const DataCell(Text("HEATHROW TERMINAL 2 TW6 1JS")),
                    const DataCell(Text("£55.00")),
                    const DataCell(Text("SALOON")),
                    const DataCell(Text("NW7")),
                    const DataCell(Text("HEATHROW TERMINAL 2 TW6 1JS")),
                    const DataCell(Text("£55.00")),
                    const DataCell(Text("HEATHROW TERMINAL 2 TW6 1JS")),
                    const DataCell(Text("£55.00")),
                    const DataCell(Text("£55.00")),
                    const DataCell(Text("HEATHROW TERMINAL 2 TW6 1JS")),
                    const DataCell(Text("£55.00")),
                    const DataCell(Text("£55.00")),
                    DataCell(
                      Row(
                        children: [
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: Colors.transparent,
                              ), // border color & thickness
                            ),
                            onPressed: () {},
                            child: Icon(
                              Icons.search,
                              size: 28,
                              color: DynamicColors.primaryClr,
                            ),
                          ),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: Colors.transparent,
                              ), // border color & thickness
                            ),
                            onPressed: () {},
                            child: Icon(
                              Icons.clear,
                              size: 28,
                              color: DynamicColors.redClr,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      });
    });
  }
}

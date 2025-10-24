import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/dropdown_button.dart';
import 'package:dashboard_new1/view/accounts/controller/account_controller.dart';
import 'package:dashboard_new1/view/dashboard_view/Controller/dashboard_controller.dart';
import 'package:dashboard_new1/view/dashboard_view/booking_table.dart';
import 'package:dashboard_new1/view/dashboard_view/widgets/time_picker_widget.dart';
import 'package:dashboard_new1/view/dashboard_view/widgets/user_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../component/color.dart';
import '../../../../component/datatable_widget.dart';
import '../../../../component/textStyle.dart';
import '../../../../component/text_field.dart';
import '../../../../component/text_widget.dart';
import '../../../dashboard_view/Controller/dashboard_controller.dart';

class CreateAccountInvoiceScreen extends StatefulWidget {
  const CreateAccountInvoiceScreen({super.key});

  @override
  State<CreateAccountInvoiceScreen> createState() =>
      _CreateAccountInvoiceScreenState();
}

class _CreateAccountInvoiceScreenState
    extends State<CreateAccountInvoiceScreen> {
  int selectedRowIndex = 0; // currently selected row
  final int totalRows = 5; // total rows (dynamic list ke hisaab se change hoga)

  AccountController controller = Get.isRegistered<AccountController>()
      ? Get.find<AccountController>()
      : Get.put(AccountController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "CreateAccountInvoiceScreen";
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
              child: Text(AppText.accountInvoice, style: titleDesign()),
            ),
            SizedBox(
              height: 8,
            ),
            labeledField(
              context: context,
              isMobile: isMobile,
              label: AppText.invoiceDate,
              column: true,
              width: fieldWidth,
              child: SizedBox(height: 30, child: KeyboardDatePicker()),
            ),
            labeledField(
              context: context,
              isMobile: isMobile,
              label: AppText.invoiceDueDate,
              column: true,
              width: fieldWidth,
              child: SizedBox(height: 30, child: KeyboardDatePicker()),
            ),
            Padding(
                padding: EdgeInsets.only(top: 25),
                child: RichText(
                    text: TextSpan(
                        text: 'Invoice',
                        style: mozillaTextSemiBoldText(
                            fontWeight: FontWeight.bold),
                        children: [
                      TextSpan(
                          text: "  INV368",
                          style: mozillaTextRegularText(
                              color: DynamicColors.redClr))
                    ]))),
            CustomDropdownField<String>(
              text: AppText.account,
              width: fieldWidth / 1.5,
              label: AppText.account,
              items: [
                "SELECT ACCOUNT 1",
                "SELECT ACCOUNT 2",
                "SELECT ACCOUNT 3",
                "SELECT ACCOUNT 4",
                "SELECT ACCOUNT 5",
              ],
              value: controller.account,
              itemLabel: (val) => val, // just show the string
              onChanged: (val) {
                controller.account = val!;
                controller.update();
              },
            ),
            CustomDropdownField<String>(
              text: AppText.department,
              width: fieldWidth / 1.5,
              label: AppText.department,
              items: [
                "SELECT DEPARTMENT 1",
                "SELECT DEPARTMENT 2",
                "SELECT DEPARTMENT 3",
                "SELECT DEPARTMENT 4",
                "SELECT DEPARTMENT 5",
              ],
              value: controller.department,
              itemLabel: (val) => val, // just show the string
              onChanged: (val) {
                controller.department = val!;
                controller.update();
              },
            ),
            CustomTextField(
              borderRadius: 4,
              controller: controller.customerTelephoneController,
              width: fieldWidth,
              hintText: AppText.order,
              columnText: true,
              height: 30,
            ),
            CustomDropdownField<String>(
              text: AppText.subsidiary,
              width: fieldWidth / 1.5,
              label: AppText.subsidiary,
              items: [
                "DEMO COMPANY 1",
                "DEMO COMPANY 2",
                "DEMO COMPANY 3",
                "DEMO COMPANY 4",
                "DEMO COMPANY 5",
              ],
              value: controller.subDiary,
              itemLabel: (val) => val, // just show the string
              onChanged: (val) {
                controller.subDiary = val!;
                controller.update();
              },
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 20, right: 15),
              child: Row(
                children: [
                  labeledField(
                    context: context,
                    isMobile: isMobile,
                    label: AppText.from,
                    width: fieldWidth / 1.8,
                    child: SizedBox(height: 30, child: KeyboardDatePicker()),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  labeledField(
                    context: context,
                    isMobile: isMobile,
                    label: AppText.to,
                    width: fieldWidth / 1.8,
                    child: SizedBox(height: 30, child: KeyboardDatePicker()),
                  ),
                  Spacer(),
                  CustomButton(
                    verticalPadding: 0.0,
                    width: 40,
                    height: 30,
                    borderRadius: 4,
                    btnText: AppText.filter,
                    style: mozillaTextRegularText(
                        fontSize: 10, color: DynamicColors.whiteClr),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  CustomButton(
                    verticalPadding: 0.0,
                    width: 40,
                    height: 30,
                    borderRadius: 4,
                    btnText: AppText.save,
                    style: mozillaTextRegularText(
                        fontSize: 10, color: DynamicColors.whiteClr),
                  ),
                ],
              ),
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
                    buildHeaderWithSearch(title: "CUST"),
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
                    const DataCell(Text("CUST")),
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

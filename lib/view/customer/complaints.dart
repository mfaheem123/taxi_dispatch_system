import 'package:dashboard_new1/component/customButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../component/color.dart';
import '../../component/datatable_widget.dart';
import '../../component/networks/api.dart';
import '../../component/textStyle.dart';
import '../../component/text_widget.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';
import '../dashboard_view/booking_table.dart';
import 'controller/customer_controller.dart';

class ComplaintsView extends StatefulWidget {
  const ComplaintsView({super.key});

  @override
  State<ComplaintsView> createState() => _ComplaintsViewState();
}

class _ComplaintsViewState extends State<ComplaintsView> {
  CustomerController controller = Get.isRegistered<CustomerController>()
      ? Get.find<CustomerController>()
      : Get.put(CustomerController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getCustomerComplaints();
    permissions = Api().sp.read('all_permissions') ?? [];
    //shortCutKeyValue.value = "lostProperty";
  }

  int selectedRowIndex = 0; // currently selected row
   final int totalRows = 5; // total rows (dynamic list ke hisaab se change hoga)
  List permissions = [];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width / WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
    return GetBuilder<CustomerController>(
        // initState: (v){
        //   permissions = Api().sp.read('all_permissions') ?? [];
        // },

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

        return SizedBox(
          // width: Get.width/1.6,
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                   "Customer Complaints"+ " (10)",
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                   child:DatatableWidget(
                     columns: [
                       buildHeaderWithSearch(title: "REF #"),
                       buildHeaderWithSearch(title: "COMPLAIN DATE"),
                       buildHeaderWithSearch(title: "NAME"),
                       buildHeaderWithSearch(
                         title: "ACTIONS",
                         customWidget: Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             OutlinedButton(
                               style: OutlinedButton.styleFrom(
                                 side: const BorderSide(color: Colors.transparent),
                               ),
                               onPressed: controller.searchComplaints,
                               child: const Icon(Icons.search, size: 28),
                             ),
                             const Text("|"),
                             OutlinedButton(
                               style: OutlinedButton.styleFrom(
                                 side: const BorderSide(color: Colors.transparent),
                               ),
                               onPressed: controller.clearComplaintsSearch,
                               child: Icon(
                                 Icons.close,
                                 size: 28,
                                 color: DynamicColors.redClr,
                               ),
                             ),
                           ],
                         ),
                       ),
                     ],

                     rows: controller.filteredComplaints.map((complaint) {
                       return DataRow(
                         cells: [

                           DataCell(
                             Center(
                               child: Text(complaint.referenceNumber ?? ""),
                             ),
                           ),

                           DataCell(
                             Center(
                               child: Text(
                                 complaint.complainDate != null
                                     ? "${complaint.complainDate!.day}/${complaint.complainDate!.month}/${complaint.complainDate!.year}"
                                     : "",
                               ),
                             ),
                           ),

                           DataCell(
                             Center(
                               child: Text(
                                 complaint.customer?.name ?? "",
                               ),
                             ),
                           ),

                           DataCell(
                             Center(
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: [

                                   if (permissions.contains('update_complaint'))
                                     OutlinedButton(
                                       style: OutlinedButton.styleFrom(
                                         side: const BorderSide(color: Colors.transparent),
                                       ),
                                       onPressed: () {},
                                       child: const Icon(Icons.edit_calendar, size: 28),
                                     ),

                                   const Text("|"),

                                   if (permissions.contains('delete_complaint'))
                                     OutlinedButton(
                                       style: OutlinedButton.styleFrom(
                                         side: const BorderSide(color: Colors.transparent),
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
                         ],
                       );
                     }).toList(),
                   ),
                  // DatatableWidget(
                  //     columns: [
                  //       buildHeaderWithSearch(title: "REF #"),
                  //       buildHeaderWithSearch(title: "COMPLAIN DATE"),
                  //       buildHeaderWithSearch(title: "NAME"),
                  //       buildHeaderWithSearch(
                  //           title: "ACTIONS",
                  //           customWidget: Row(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: [
                  //               OutlinedButton(
                  //                 style: OutlinedButton.styleFrom(
                  //                   side: BorderSide(
                  //                     color: Colors.transparent,
                  //                   ), // border color & thickness
                  //                 ),
                  //                 onPressed: () {
                  //                    controller.searchComplaints();
                  //                 },
                  //                 child: Icon(
                  //                   Icons.search,
                  //                   size: 28,
                  //                 ),
                  //               ),
                  //               Text("|"),
                  //               OutlinedButton(
                  //                 style: OutlinedButton.styleFrom(
                  //                   side: BorderSide(
                  //                     color: Colors.transparent,
                  //                   ), // border color & thickness
                  //                 ),
                  //                 onPressed: () {
                  //                   controller.clearComplaintsSearch();
                  //                 },
                  //                 child: Icon(
                  //                   Icons.close,
                  //                   size: 28,
                  //                   color: DynamicColors.redClr,
                  //                 ),
                  //               ),
                  //             ],
                  //           )),
                  //     ],
                  //     // totalRow: totalRows,
                  //   totalRow: controller.filteredComplaints.length, // <-- ye add karo
                  //   cells: controller.filteredComplaints.isEmpty
                  //       ? []
                  //       : List.generate(
                  //     controller.filteredComplaints.length,
                  //         (index) {
                  //       final complaint = controller.filteredComplaints[index];
                  //
                  //       return [
                  //         DataCell(
                  //           Center(
                  //             child: Text(
                  //               complaint.referenceNumber ?? "",
                  //             ),
                  //           ),
                  //         ),
                  //
                  //         DataCell(
                  //           Center(
                  //             child: Text(
                  //               complaint.complainDate != null
                  //                   ? "${complaint.complainDate!.day}/${complaint.complainDate!.month}/${complaint.complainDate!.year}"
                  //                   : "",
                  //             ),
                  //           ),
                  //         ),
                  //
                  //         DataCell(
                  //           Center(
                  //             child: Text(
                  //               complaint.customer?.name ?? "",
                  //             ),
                  //           ),
                  //         ),
                  //
                  //         DataCell(
                  //           Center(
                  //             child: Row(
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               children: [
                  //                 if (permissions.contains('update_complaint'))
                  //                   OutlinedButton(
                  //                     style: OutlinedButton.styleFrom(
                  //                       side: const BorderSide(
                  //                         color: Colors.transparent,
                  //                       ),
                  //                     ),
                  //                     onPressed: () {
                  //                       // Edit Complaint
                  //                     },
                  //                     child: const Icon(
                  //                       Icons.edit_calendar,
                  //                       size: 28,
                  //                     ),
                  //                   ),
                  //
                  //                 const Text("|"),
                  //
                  //                 if (permissions.contains('delete_complaint'))
                  //                   OutlinedButton(
                  //                     style: OutlinedButton.styleFrom(
                  //                       side: const BorderSide(
                  //                         color: Colors.transparent,
                  //                       ),
                  //                     ),
                  //                     onPressed: () {
                  //                       // Delete Complaint
                  //                     },
                  //                     child: Icon(
                  //                       Icons.delete_forever,
                  //                       size: 28,
                  //                       color: DynamicColors.redClr,
                  //                     ),
                  //                   ),
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //       ];
                  //     },
                  //   ).expand((e) => e).toList(),
                  // ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        );
      });
    });
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../component/color.dart';
import '../component/customButton.dart';
import '../component/textStyle.dart';
import '../component/text_widget.dart';

class DispatchBooking extends StatefulWidget {
  const DispatchBooking({super.key});

  @override
  State<DispatchBooking> createState() => _DispatchBookingState();
}

class _DispatchBookingState extends State<DispatchBooking> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.only(top: 100, left: 40, right: 40),
      backgroundColor: Colors.transparent,
      child: Align(
        alignment: Alignment.topCenter,
        child: IntrinsicWidth(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "DISPATCH BOOKING (1025)",
                      style: mozillaTextSemiBoldText(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    InkWell(
                      onTap: () => Get.back(),
                      child:
                          const Icon(Icons.close, size: 22, color: Colors.grey),
                    ),
                  ],
                ),

                const Divider(height: 30, thickness: 1),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "SELECT DRIVER TO DISPATCH",
                      style: mozillaTextSemiBoldText(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                    CustomButton(
                      width: 165,
                      height: 35,
                      verticalPadding: 0.0,
                      borderRadius: 4,
                      btnText: "CALCULATE DISTANCE",
                      style: mozillaTextSemiBoldText(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                      onTap: () {
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 15),
                DataTable(
                  headingRowHeight: 45,
                  columnSpacing: 25,
                  headingRowColor: WidgetStateProperty.all(Colors.grey.shade50),
                  border: TableBorder.all(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                  columns: [
                    DataColumn(
                        label: Text("ID",
                            style: mozillaTextSemiBoldText(
                                fontWeight: FontWeight.bold, fontSize: 16))),
                    DataColumn(
                        label: Text("DRIVER NAME",
                            style: mozillaTextSemiBoldText(
                                fontWeight: FontWeight.bold, fontSize: 16))),
                    DataColumn(
                        label: Text("SUBSIDIARY",
                            style: mozillaTextSemiBoldText(
                                fontWeight: FontWeight.bold, fontSize: 16))),
                    DataColumn(
                        label: Text("STATUS",
                            style: mozillaTextSemiBoldText(
                                fontWeight: FontWeight.bold, fontSize: 16))),
                    DataColumn(
                        label: Text("ATTRIBUTES",
                            style: mozillaTextSemiBoldText(
                                fontWeight: FontWeight.bold, fontSize: 16))),
                    DataColumn(
                        label: Text("DISTANCE",
                            style: mozillaTextSemiBoldText(
                                fontWeight: FontWeight.bold, fontSize: 16))),
                    DataColumn(
                        label: Text("ACTION",
                            style: mozillaTextSemiBoldText(
                                fontWeight: FontWeight.bold, fontSize: 16))),
                  ],
                  rows: List.generate(
                      2,
                      (index) => DataRow(
                            cells: [
                              DataCell(Text("29",
                                  style: mozillaTextRegularText(fontSize: 14))),
                              DataCell(Text("NICOLAS GREY",
                                  style: mozillaTextRegularText(fontSize: 14))),
                              DataCell(Text("DEMO COMPANY",
                                  style: mozillaTextRegularText(fontSize: 14))),
                              DataCell(Text("AVAILABLE",
                                  style: mozillaTextRegularText(
                                      fontSize: 14, color: Colors.green))),
                              DataCell(Center(
                                  child: Text("-",
                                      style: mozillaTextRegularText(
                                          fontSize: 14)))),
                              DataCell(Center(
                                  child: Text("-",
                                      style: mozillaTextRegularText(
                                          fontSize: 14)))),
                              DataCell(
                                Center(
                                  child: CustomButton(
                                    width: 80,
                                    height: 28,
                                    verticalPadding: 0.0,
                                    borderRadius: 4,
                                    btnText: "DISPATCH",
                                    style: mozillaTextSemiBoldText(
                                        fontSize: 14, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          )),
                ),

                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButton(
                      width: 80,
                      height: 28,
                      btnText: "CLOSE",
                      btnColor: Colors.grey.shade600,
                      verticalPadding: 0.0,
                      borderRadius: 4,
                      onTap: () => Get.back(),
                      style: mozillaTextSemiBoldText(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

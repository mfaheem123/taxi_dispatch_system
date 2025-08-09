

import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/view/dashboard_view/dashboard/row_button_widget_map.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/textStyle.dart';
import '../Controller/dashboard_controller.dart';

class DriversView extends StatelessWidget {
  const DriversView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GetBuilder<DashboardController>(
      builder: (controller) {
        return SizedBox(
          width: screenWidth * 0.2,
          height: screenHeight * 0.465,
          child: Container(
            // height: screenHeight * 0.6,
            decoration: BoxDecoration(
              // color: Color(0xFFA0DCFF),
              // color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 35,
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                            color: DynamicColors.secondaryClr
                        ),
                        child: Row(
                          children: [
                            Text("Driver".toUpperCase(),
                              style: headingText(
                                  fontSize: 14,
                                  latterSpacing: 1.0,
                                  color: DynamicColors.primaryClr
                              ),
                            ),
                            Spacer(),
                            IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: (){

                                }, icon: Icon(Icons.reset_tv_outlined,
                              size: 17,
                              color: DynamicColors.primaryClr,
                            )),
                            IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: (){

                                }, icon: Icon(Icons.refresh,
                              size: 17,
                              color: DynamicColors.primaryClr,
                            )),
                            IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: (){

                                }, icon: Icon(Icons.visibility_off_sharp,
                              size: 17,
                              color: DynamicColors.primaryClr,
                            )),
                            IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: (){

                                }, icon: Icon(Icons.mail,
                              size: 17,
                              color: DynamicColors.primaryClr,
                            )),
                            IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: (){

                                }, icon: Icon(Icons.send,
                              size: 17,
                              color: DynamicColors.primaryClr,
                            )),
                            IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: (){

                                }, icon: Icon(Icons.share,
                              size: 17,
                              color: DynamicColors.primaryClr,
                            )),
                          ],
                        ),
                      ),
                      Container(
                        width: Get.width,
                        decoration: BoxDecoration(
                            border: Border.all(color: DynamicColors.secondaryClr)
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: RowButtonWidgetMap(
                                color: controller.driverSelectionTab.value == "activeDriver"?
                                DynamicColors.primaryClr:DynamicColors.secondaryClr,
                                onTap: (){
                                  controller.driverSelectionTab.value = "activeDriver";
                                  controller.update();
                                },
                                widget: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 8,
                                      backgroundColor: DynamicColors.greenClr,
                                      //     .value = "MAPS",
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      child: Text("(3)",
                                        style: mozillaTextRegularText(
                                            fontSize: 13,
                                            color:controller.driverSelectionTab.value == "activeDriver"?
                                            DynamicColors.whiteClr:DynamicColors.primaryClr
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                              ),
                            ),
                            Expanded(
                              child: RowButtonWidgetMap(
                                color:controller.driverSelectionTab.value != "activeDriver"?
                                DynamicColors.primaryClr:DynamicColors.secondaryClr,
                                onTap: (){
                                  controller.driverSelectionTab.value = "offlineDriver";
                                  controller.update();
                                },
                                widget: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 8,
                                      backgroundColor: DynamicColors.redClr,
                                      //     .value = "MAPS",
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      child: Text("(0)",
                                        style: mozillaTextRegularText(
                                            fontSize: 13,
                                            color: controller.driverSelectionTab.value != "activeDriver"?
                                            DynamicColors.whiteClr:DynamicColors.primaryClr
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListView.builder(
                          itemCount: 4,
                          shrinkWrap: true,

                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context,index){
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: CustomButton(
                                      height: 30,
                                      borderRadius: 0,
                                      verticalPadding: 0,
                                      btnText: "X1",
                                      style: mozillaTextRegularText(
                                          fontSize: 16,
                                          color: DynamicColors.whiteClr
                                      ),

                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text("SALOON ",
                                      style: mozillaTextRegularText(
                                          fontSize: 13
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                                    child: Icon(Icons.phone_android_rounded),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      "1133Hr 01Min-", // your text
                                      style: mozillaTextRegularText(fontSize: 13),
                                      overflow: TextOverflow.ellipsis, // show "..."
                                      maxLines: 1,                      // only one line
                                    ),
                                  ),
                                  Expanded(
                                    child: CustomButton(
                                      height: 30,
                                      btnColor: DynamicColors.secondaryClr,
                                      borderRadius: 0,
                                      verticalPadding: 0,
                                      btnText: "-",
                                    ),
                                  ),

                                ],
                              ),
                            );
                          }),
                    ],
                  ),
                ),

                ///todo before coding
                /*Expanded(
                  // flex: 3,
                  child: Container(
                    margin:
                    const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.circular(16),
                      border: Border.all(
                          color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 28),
                        Center(
                          child: RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                  fontWeight:
                                  FontWeight.w900,
                                  fontSize: 18),
                              children: [
                                TextSpan(
                                  text: 'DRIVERS ',
                                  style: TextStyle(
                                      color: Colors
                                          .deepPurple),
                                ),
                                TextSpan(
                                  text: '(3)',
                                  style: TextStyle(
                                      color:
                                      Colors.redAccent),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                            height: screenHeight * 0.03125),

                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets
                                    .symmetric(
                                    horizontal: 12,
                                    vertical: 6),
                                decoration: BoxDecoration(
                                  color: Color(0xFF43489A),
                                  borderRadius:
                                  BorderRadius.circular(
                                      20),
                                ),
                                child: Row(
                                  mainAxisSize:
                                  MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      margin: const EdgeInsets
                                          .only(right: 6),
                                      decoration:
                                      const BoxDecoration(
                                        color: Colors.green,
                                        shape:
                                        BoxShape.circle,
                                      ),
                                    ),
                                    const Text(
                                      " Online ",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight:
                                        FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets
                                    .symmetric(
                                    horizontal: 12,
                                    vertical: 6),
                                decoration: BoxDecoration(
                                  color:
                                  Colors.lightBlueAccent,
                                  borderRadius:
                                  BorderRadius.circular(
                                      20),
                                ),
                                child: Row(
                                  mainAxisSize:
                                  MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      margin: const EdgeInsets
                                          .only(right: 6),
                                      decoration:
                                      const BoxDecoration(
                                        color: Colors.yellow,
                                        shape:
                                        BoxShape.circle,
                                      ),
                                    ),
                                    const Text(
                                      " Pending ",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight:
                                        FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            height: screenHeight * 0.0375),

                        // Driver list
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(
                              horizontal: 30),
                          child: ListView.builder(
                              itemCount: 5,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context,index){
                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: const [
                                      CircleAvatar(
                                          radius: 5,
                                          backgroundColor:
                                          Colors.green),
                                      SizedBox(width: 6),
                                      Text("Nadeem",
                                          style: TextStyle(
                                              fontSize: 18)),
                                    ],
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
                       Expanded(
                                        flex: 2,
                                        child: Builder(builder: (context) {
                                          final screenHeight =
                                              MediaQuery.of(context).size.height;
                                          final screenWidth =
                                              MediaQuery.of(context).size.width;
                                          final isMobile = screenWidth < 600;

                                          // Local method: footer button builder
                                          Widget footerButton(
                                              IconData icon, String label) {
                                            return Expanded(
                                              child: ElevatedButton.icon(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                  Color(0xFF43489A),
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(6),
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: isMobile ? 10 : 14,
                                                  ),
                                                  textStyle: TextStyle(
                                                      fontSize:
                                                      isMobile ? 12 : 14),
                                                ),
                                                onPressed: () {},
                                                icon: Icon(icon,
                                                    size: isMobile ? 16 : 20),
                                                label: Text(label),
                                              ),
                                            );
                                          }

                                          return Container(
                                            padding: const EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                              BorderRadius.circular(16),
                                              border: Border.all(
                                                  color: Colors.grey.shade300),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(height: 28),
                                                const Text(
                                                  "PLOTS",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w900,
                                                    color: Color(0xFF43489A),
                                                  ),
                                                ),
                                                SizedBox(
                                                    height:
                                                    screenHeight * 0.0125),

                                                // Plot chips row
                                                Row(
                                                  children: [
                                                    buildChip("LND 4",
                                                        isFirst: true),
                                                    buildChip("HRW1"),
                                                    buildChip("HTH2"),
                                                    buildChip("SW1",
                                                        isLast: true),
                                                  ],
                                                ),
                                                SizedBox(
                                                    height: screenHeight * 0.02),

                                                // Footer buttons row
                                                Row(
                                                  children: [
                                                    footerButton(
                                                        Icons.send, "SMS"),
                                                    const SizedBox(width: 10),
                                                    footerButton(
                                                        Icons.download_sharp,
                                                        "E/APP"),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                      ),*/
                ///todo before coding
              ],
            ),
          ),
        );
      }
    );
  }
}

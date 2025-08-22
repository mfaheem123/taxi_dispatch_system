



import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/component/unique_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:popover/popover.dart';

import '../view/dashboard_view/Controller/dashboard_controller.dart';
import 'color.dart';
import 'keyboard_dropdown_widget.dart';

class RestrictDriversAlert extends StatelessWidget {
  RestrictDriversAlert({super.key});

  List<String> driversList = [
   "25 GEORGE HAMPTON",
   "26 PAUL DOUBLEDAY",
   "27 RICHARD HARDWICK",
   "28 LANRE OKERJO",
   "29 NICOLAS GREY",
   "50 NADEEM",
   "60 EDWARD",
   "TEST TEST DRIVER",
   "X1 ANDRE",
   "SAVE [HOME]",
  ];

  final dashBoardCntrl = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    dashBoardCntrl.shortCutKeyValue.value = "alert";
    return Dialog(
      insetPadding: EdgeInsets.all(20),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
          height: 350,
          width: 450,
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppText.restrictDrivers,
                style: mozillaTextSemiBoldText(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
                ),
                Icon(Icons.close,
                color: DynamicColors.textClr,
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 6,horizontal: 10),
                decoration: BoxDecoration(
                  border: const Border(
                    top: BorderSide(color: Colors.grey),
                    left: BorderSide(color: Colors.grey),
                    bottom: BorderSide(color: Colors.grey),
                    // 👉 right side intentionally remove kiya (no border)
                  ),
                ),
                child: Center(
                  child: Text("#"),
                ),
              ),
                RestrictedDrivers(
                  driversList: driversList,
                ),
                GestureDetector(
                  onTap: (){
                    Get.back();
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 10),
                      decoration: BoxDecoration(
                        border: const Border(
                          top: BorderSide(color: Colors.grey),
                          right: BorderSide(color: Colors.grey),
                          bottom: BorderSide(color: Colors.grey),
                          // 👉 right side intentionally remove kiya (no border)
                        ),
                      ),
                      child: Center(child: Icon(Icons.remove_circle,
                        color: DynamicColors.primaryClr,
                      ))),
                )
              ],
            ),
            SizedBox(
              height: 220,
              child: ListView.builder(
                  itemCount: driversList.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context,index){
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 7,horizontal: 10),
                        decoration: BoxDecoration(
                          border: const Border(
                            top: BorderSide(color: Colors.grey),
                            left: BorderSide(color: Colors.grey),
                            bottom: BorderSide(color: Colors.grey),
                            // 👉 right side intentionally remove kiya (no border)
                          ),
                        ),
                        child: Center(
                          child: Text("${index+1}"),
                        ),
                      ),
                     Container(
                       width: MediaQuery.of(context).size.width / 6,
                       padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 4),
                       decoration: BoxDecoration(
                         border: Border.all(color: Colors.grey),
                         // borderRadius: BorderRadius.circular(8),
                       ),
                       child: Row(
                         children: [
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 5,horizontal: 6),
                              color: DynamicColors.primaryClr,
                              child: Center(
                                child: Text("$index",
                                style: mozillaTextSemiBoldText(
                                  fontSize: 12,
                                  color: DynamicColors.whiteClr
                                ),
                                ),
                              ),
                            ),
                           Padding(
                             padding: const EdgeInsets.only(left: 8.0),
                             child: Text(driversList[index],
                               style: mozillaTextSemiBoldText(
                                   fontSize: 12,
                               ),
                             ),
                           )
                         ],
                       ),
                     ),
                      Container(
                          padding: const EdgeInsets.symmetric(vertical: 6,horizontal: 10),
                          decoration: BoxDecoration(
                            border: const Border(
                              top: BorderSide(color: Colors.grey),
                              right: BorderSide(color: Colors.grey),
                              bottom: BorderSide(color: Colors.grey),
                              // 👉 right side intentionally remove kiya (no border)
                            ),
                          ),
                          child: Center(child: Icon(Icons.delete_forever,
                            color: DynamicColors.primaryClr,
                          )))
                    ],
                  ),
                );
              }),
            )
          ],
        ),
      ),
    );
  }

  customKeyValue({key,value}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(key??AppText.vehicle,
          style: mozillaTextSemiBoldText(
              fontSize: 14,
              color: DynamicColors.textClr.withOpacity(0.7)
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Text(value??"vehicle Value",
            style: mozillaTextSemiBoldText(
                fontSize: 14,
                color: DynamicColors.textClr.withOpacity(0.7)
            ),
          ),
        ),
      ],
    );
  }
}


class RestrictedDrivers extends StatefulWidget {
  RestrictedDrivers({super.key, this.driversList});

  final List<String>? driversList;

  @override
  State<RestrictedDrivers> createState() => _RestrictedDriversState();
}

class _RestrictedDriversState extends State<RestrictedDrivers> {
  final FocusNode _focusNode = FocusNode();
  int _selectedIndex = 0;


  void _showPopover(BuildContext context, List<String> items) {
    showPopover(
      context: context,
      bodyBuilder: (context) {
        return RawKeyboardListener(
          autofocus: true,
          focusNode: FocusNode(),
          onKey: (event) {
            if (event is RawKeyDownEvent) {
              if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                setState(() {
                  _selectedIndex =
                      (_selectedIndex + 1) % items.length; // cycle forward
                });
              } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                setState(() {
                  _selectedIndex =
                      (_selectedIndex - 1 + items.length) % items.length;
                });
              } else if (event.logicalKey == LogicalKeyboardKey.enter) {
                Navigator.pop(context);
                debugPrint("Selected: ${items[_selectedIndex]}");
              }
            }
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: items.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final isSelected = index == _selectedIndex;
              return Container(
                color: isSelected ? DynamicColors.primaryClr.withOpacity(0.2) : null,
                child: ListTile(
                  title: Text(
                    items[index],
                    style: mozillaTextRegularText(fontSize: 12,
                      color: isSelected ? DynamicColors.primaryClr : DynamicColors.textClr,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    debugPrint("Clicked ${items[index]}");
                  },
                ),
              );
            },
          ),
        );
      },
      onPop: () => debugPrint("Popover closed"),
      direction: PopoverDirection.bottom,
      width: 300,
      height: (items.length * 40).toDouble(),
      arrowHeight: 10,
      arrowWidth: 20,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      onKey: (node, event) {
        if (event is RawKeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.enter ||
              event.logicalKey == LogicalKeyboardKey.space) {
            _showPopover(context, widget.driversList ?? []);
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: GestureDetector(
        onTap: () =>
            _showPopover(context, widget.driversList ?? []),
        child: Container(
          width: MediaQuery.of(context).size.width / 6,
          padding: const EdgeInsets.only(top: 6, bottom: 6, left: 3),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            // borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            AppText.selectDriver,
            style: mozillaTextRegularText( fontSize: 13, ),
          ),
        ),
      ),
    );
  }
}

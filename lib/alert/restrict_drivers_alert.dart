



import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/component/unique_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:popover/popover.dart';

import '../component/dropdown_button.dart';
import '../view/customer/model/restricDriver.dart';
import '../view/dashboard_view/Controller/dashboard_controller.dart';
import '../component/color.dart';
import '../component/keyboard_dropdown_widget.dart';

class RestrictDriversAlert extends StatefulWidget {
  RestrictDriversAlert({super.key});

  @override
  State<RestrictDriversAlert> createState() => _RestrictDriversAlertState();
}

class _RestrictDriversAlertState extends State<RestrictDriversAlert> {

  final dashBoardCntrl = Get.find<DashboardController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(dashBoardCntrl.allDriverData == null){
      dashBoardCntrl.getAllDrivers();
    }
  }



  @override
  Widget build(BuildContext context) {
    shortCutKeyValue.value = "alert";
    return Dialog(
      insetPadding: EdgeInsets.all(20),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: GetBuilder<DashboardController>(
        builder: (controller) {
          return Container(
              height: 350,
              width: 450,
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
            child: controller.allDriverData == null?SizedBox.shrink(): Column(
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
                    GestureDetector(
                      onTap: (){
                         Get.back();
                      },
                      child: Icon(Icons.close,
                      color: DynamicColors.textClr,
                      ),
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
                    CustomDropdownField<DriverObject>(
                      label: "SELECT DRIVERS",
                      width: 320,
                      height: 35,
                      items: controller.allDriverData!.drivers,
                      value: controller.selectDriverObject,
                      itemLabel: (driver) =>
                      driver.name,
                      onChanged: (val) {
                        controller.selectDriverObject = val;
                        controller.update();
                      },
                    ),
                    GestureDetector(
                      onTap: (){
                        if(controller.selectDriverObject != null){
                        controller.driversList
                            .add(controller.selectDriverObject!);
                        controller.selectDriverObject = null;
                        controller.update();
                      }
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
                      itemCount: controller.driversList.length,
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
                                 padding: EdgeInsets.only(left: 8.0),
                                 child: Text(controller.driversList[index].name,
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
          );
        }
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
  RestrictedDrivers({super.key, this.driversList,this.titleText,this.border,this.width,this.height,this.padding});

  final List<String>? driversList;
  final BoxBorder? border;
  String? titleText;
  double? width;
  double? height;
  double? padding;

  @override
  State<RestrictedDrivers> createState() => _RestrictedDriversState();
}

class _RestrictedDriversState extends State<RestrictedDrivers> {
  final FocusNode _focusNode = FocusNode();
  int _selectedIndex = 0;
  bool _isFocused = false;


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
                  _selectedIndex = (_selectedIndex + 1) % items.length; // cycle forward
                });
              } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                setState(() {
                  _selectedIndex = (_selectedIndex - 1 + items.length) % items.length;
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
      // height: (items.length * 56).toDouble(),
      arrowHeight: 10,
      arrowWidth: 20,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      onKey: (node, event) {
        if (event is RawKeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.enter ||
              event.logicalKey == LogicalKeyboardKey.space) {
            _showPopover(context, widget. driversList ?? []);
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: GestureDetector(
        onTap: () =>
            _showPopover(context, widget.driversList ?? []),
        child: Container(
          width: widget.width!*1.5/*MediaQuery.of(context).size.width / 6*/,
          height: widget.height,
          padding: EdgeInsets.only(top: 2, bottom: 2, left: 3),
          decoration: BoxDecoration(
            border: Border.all(
              color: _isFocused ? DynamicColors.primaryClr : Colors.grey, // 👈 change color on focus
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: widget.width! /2.5,
                child: Text(
                  widget.titleText??AppText.selectDriver,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: mozillaTextRegularText(fontSize: 12, ),
                ),
              ),
              Icon(Icons.arrow_drop_down)
            ],
          ),
        ),
      ),
    );
  }
}

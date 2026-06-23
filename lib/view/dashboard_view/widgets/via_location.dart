import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/view/dashboard_view/Controller/dashboard_controller.dart';
import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../Model/via_point.dart';
import '../models/all_addresses_model.dart';

class ViaTextEditingControllerClass {
  TextEditingController name = TextEditingController();
  TextEditingController mobile = TextEditingController();
  ViaTextEditingControllerClass(this.name, this.mobile);
}



class ViaLocation extends StatefulWidget {
  const ViaLocation({super.key});

  @override
  State<ViaLocation> createState() => _ViaLocationState();
}

class _ViaLocationState extends State<ViaLocation> {

  final TextEditingController addressController = TextEditingController();

  FocusNode textFieldFocusNode = FocusNode();
  FocusNode searchFocusNode = FocusNode();
  Timer? _debounce;

  final DashboardController _controller = Get.find();

  Future<List<String>> _getNamesRequest(String query) async {
    if (query.isEmpty) return [];

    const duration = Duration(milliseconds: 800);

    // 👇 cancel previous debounce timer
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // 👇 Completer to wait for API completion
    final completer = Completer<List<String>>();
    _controller.selectedTextFieldsValue.value = "VIA";
    _debounce = Timer(duration, () async {
      await _controller.getAddresses(fieldsName: "VIA", searchingText: query);

      // ✅ Prepare list after data fetched
      final list = _controller.allAddressesData
          .map((m) => "${m.name ?? ''} ${m.postcode ?? ''}")
          .toList();

      completer.complete(list); // mark as finished
    });

    // ✅ Wait until completer completes
    return completer.future;
  }


  Future<List<AllAddressesModel>> _getFakeRequestData(String query) async {
    _controller.onChangeHandler(fieldName: "VIA",searchingText: query);
    return await Future.delayed(const Duration(seconds: 1), () async {
      return _controller.allAddressesData.where((e) => e.name!.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Dialog(
      insetPadding: EdgeInsets.all(20),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: GetBuilder<DashboardController>(
        builder: (controller) {
          return SizedBox(
            height: 400,
            width: 650,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "VIA POINT(S)",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                controller.viaMilsCondition = false;
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text(
                                    "#",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 22),
                                  ),
                                ),

                                SizedBox(width: 12),

                                RawKeyboardListener(
                                  focusNode: controller.searchingAddressViaFocusNode,

                                  onKey: (event) {
                                    if (event is RawKeyDownEvent) {
                                      if (event.logicalKey ==
                                          LogicalKeyboardKey.arrowDown &&
                                          controller.highlightedIndex.value <
                                              controller.suggestions.length -
                                                  1) {
                                        controller.highlightedIndex.value++;
                                      } else if (event.logicalKey ==
                                          LogicalKeyboardKey.arrowUp &&
                                          controller.highlightedIndex.value >
                                              0) {
                                        controller.highlightedIndex.value--;
                                      } else if (event.logicalKey ==
                                          LogicalKeyboardKey.enter) {
                                        final selected = controller.suggestions[controller.highlightedIndex.value].name;
                                        controller.selectSuggestion(selected);
                                      }else if(event.logicalKey == LogicalKeyboardKey.arrowDown || event.logicalKey == LogicalKeyboardKey.arrowUp || event.logicalKey == LogicalKeyboardKey.tab){
                                        FocusScope.of(Get.context!).requestFocus(controller.viaFocusNode);
                                      }
                                      // }else if(event.logicalKey == LogicalKeyboardKey.tab){
                                      //   FocusScope.of(Get.context!).requestFocus(controller.suggestionFocusNode);
                                      // }
                                    }
                                  },

                                  child: SizedBox(
                                    width: Get.width/4,
                                    child: TextField(
                                        focusNode: controller.viaFieldFocusNode,
                                        controller: addressController,
                                        onTap: (){
                                          print("hubaib");
                                          print(controller.selectedTextFieldsValue.value);
                                          print('Khan');
                                          if(controller.selectedTextFieldsValue.value != "via"){
                                            controller.selectedTextFieldsValue.value = "via";
                                          }
                                        },
                                        onChanged: (v){
                                          controller.onChangeHandler(
                                              fieldName:
                                              "via",
                                              searchingText: v);
                                        },

                                        decoration: InputDecoration(
                                          hintText: "Search Address",
                                          border: OutlineInputBorder(),
                                          isDense: true,
                                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                        )),
                                  ),
                                ),

                                SizedBox(width: 12),

                                SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // 1. Identify which type the user is trying to add
                                      bool isViaWithReturn = !controller.viaSelectionOneWay.value;
                                      String currentTypeName = isViaWithReturn ? 'via with return' : 'via';

                                        // 2. Count existing points of that specific type
                                      int currentTypeCount = controller.viaPoints.where((p) => p.withReturnWay == currentTypeName).length;

                                        // 3. Check against the limit (6 for each type)
                                      if (currentTypeCount < 6) {
                                        controller.polylinePoints.add(
                                          LatLng(controller.selectedModel!.lat!, controller.selectedModel!.lon!),
                                        );
                                        controller.viaPoints.add(ViaPoint(
                                          withReturnWay: currentTypeName,
                                          // name: currentTypeName,
                                          address: controller.selectedModel!.name!,
                                          lat: controller.selectedModel!.lat!,
                                          lng: controller.selectedModel!.lon!,
                                        ));

                                        addressController.clear();
                                        controller.viaTextEditingController.add(
                                            ViaTextEditingControllerClass(TextEditingController(), TextEditingController())
                                        );
                                        controller.update();
                                      } else {
                                        // Show a specific error message based on which limit was hit
                                        BotToast.showText(text: "Maximum 6 of '$currentTypeName' allowed");
                                      }

                                    //   if(controller.viaPoints.length <6){
                                    //   controller.polylinePoints.add(
                                    //     LatLng(controller.selectedModel!.lat!,
                                    //         controller.selectedModel!.lon!),
                                    //   );
                                    //   controller.viaPoints.add(ViaPoint(
                                    //     name: controller.viaSelectionOneWay.value? "via": 'via with return',
                                    //       address: controller.selectedModel!.name!,
                                    //       lat: controller.selectedModel!.lat!,
                                    //       lng: controller.selectedModel!.lon!));
                                    //   addressController.clear();
                                    //   controller.viaTextEditingController.add(ViaTextEditingControllerClass(TextEditingController(),TextEditingController()));
                                    //   controller.update();
                                    // }else{
                                    //     BotToast.showText(text: "Only Five VIA Allow");
                                    //   }
                                  },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    child: Icon(Icons.add, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),


                        SizedBox(height: 16),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                                width: controller.jourValue != 'W/R'?600: 280,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [


                                  Visibility(
                                    visible: controller.jourValue != 'W/R'?false:true,
                                    child: Row(
                                      children: [
                                        Text("O/W"),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        SizedBox(
                                          width: 70,
                                          height: 25,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              controller.viaSelectionOneWay.value = !controller.viaSelectionOneWay.value;
                                              controller.update();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: controller.viaSelectionOneWay.value?DynamicColors.primaryClr :
                                              DynamicColors.primaryClr.withOpacity(0.2),
                                              padding: EdgeInsets.zero,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                            ),
                                            child: Text("O/W",
                                              style: TextStyle(
                                                  color: DynamicColors.whiteClr
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  ListView.builder(
                                      itemCount: controller.viaPoints.length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        final point = controller.viaPoints[index];
                                        return point.withReturnWay =="via"? Padding(
                                          padding: EdgeInsets.symmetric(vertical: 10),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${index + 1}',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                              SizedBox(width: 12),
                                              Expanded(
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 35,
                                                        child: TextField(
                                                          style: TextStyle(fontSize: 13),
                                                          readOnly: true,
                                                          controller: TextEditingController(text: point.address),
                                                          decoration: InputDecoration(
                                                            contentPadding: EdgeInsets.zero,
                                                            border: OutlineInputBorder(),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 10),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                              child: SizedBox(
                                                                height: 35,
                                                                child: TextField(
                                                                  style: TextStyle(fontSize: 13),
                                                                  controller: controller.viaTextEditingController[index].name,
                                                                  // onChanged: (val){
                                                                  //   controller.viaPoints[index].name!.text = val;
                                                                  //   controller.update();
                                                                  // },
                                                                  decoration: InputDecoration(
                                                                    contentPadding: EdgeInsets.zero,
                                                                    hintText: "Name",
                                                                    border: OutlineInputBorder(),
                                                                  ),
                                                                ),
                                                              )),
                                                          SizedBox(width: 8),
                                                          Expanded(
                                                              child: SizedBox(
                                                                height: 35,
                                                                child: TextField(

                                                                  style: TextStyle(fontSize: 13),
                                                                  controller: controller.viaTextEditingController[index].mobile,
                                                                  // onChanged: (val) {
                                                                  //   controller.viaPoints[index].mobile!.text = val;
                                                                  //   controller.update();
                                                                  // },
                                                                  decoration: InputDecoration(

                                                                    contentPadding: EdgeInsets.zero,
                                                                    hintText: "Mobile",
                                                                    border: OutlineInputBorder(),
                                                                  ),
                                                                ),
                                                              )),
                                                        ],
                                                      ),
                                                    ],
                                                  )),


                                              Padding(
                                                padding: const EdgeInsets.only(left: 12.0, top: 8), // Add spacing from left
                                                child: SizedBox(
                                                  width: 30,
                                                  height: 30,
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        controller.viaPoints.removeAt(index);
                                                        controller.update();
                                                      });

                                                    },
                                                    // onPressed: () async {
                                                    //
                                                    //   controller.viaPoints.removeAt(index);
                                                    //
                                                    //   controller.tempStoreViaMils = "0";
                                                    //
                                                    //   controller.viaMilsCondition = true;
                                                    //
                                                    //   await controller.fetchRouteFromOSRM();
                                                    //
                                                    //   controller.update();
                                                    // },
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: Colors.red,
                                                      padding: EdgeInsets.zero,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(4),
                                                      ),
                                                    ),
                                                    child: Icon(Icons.delete, color: Colors.white, size: 20),
                                                  ),
                                                ),
                                              ),

                                              // SizedBox(
                                              //   width: 30,
                                              //   height: 30,
                                              //   child: ElevatedButton(
                                              //     onPressed: () {
                                              //       setState(() {
                                              //         viaPoints.removeAt(index);
                                              //       });
                                              //     },
                                              //     style: ElevatedButton.styleFrom(
                                              //         backgroundColor: Colors.red,
                                              //         padding: EdgeInsets.zero,
                                              //         shape: RoundedRectangleBorder(
                                              //           borderRadius: BorderRadius.circular(4),
                                              //         )),
                                              //     child: Icon(Icons.delete,
                                              //         color: Colors.white, size: 20),
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ):SizedBox.shrink();
                                      }),
                                ],
                              ),
                            ),

                            Visibility(
                              visible: // BUSINESS RULE CHECK: Jab tak dono controller text empty na hon tab tak return logic true rahega
                             controller.pickupTwoWayController.text.isNotEmpty &&
                            controller.jourValue == 'W/R'  ?true:false,
                              child: SizedBox(
                                width: 280,
                                child: Column(

                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                   Row(
                                     children: [
                                       Text("R/N"),
                                       SizedBox(
                                         width: 10,
                                       ),
                                       SizedBox(
                                         width: 70,
                                         height: 25,
                                         child: ElevatedButton(
                                           onPressed: () {
                                             controller.viaSelectionOneWay.value = !controller.viaSelectionOneWay.value;
                                             controller.update();
                                           },
                                           style: ElevatedButton.styleFrom(
                                             backgroundColor: controller.viaSelectionOneWay.value
                                                 ?
                                             DynamicColors.primaryClr.withOpacity(0.2):DynamicColors.primaryClr,
                                             padding: EdgeInsets.zero,
                                             shape: RoundedRectangleBorder(
                                               borderRadius: BorderRadius.circular(4),
                                             ),
                                           ),
                                           child: Text("R/N",
                                           style: TextStyle(
                                             color: DynamicColors.whiteClr
                                           ),
                                           ),
                                         ),
                                       ),
                                     ],
                                   ),

                                    ListView.builder(
                                        itemCount: controller.viaPoints.length,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          final point = controller.viaPoints[index];
                                          return point.withReturnWay =="via"?SizedBox.shrink():  Padding(
                                            padding: EdgeInsets.symmetric(vertical: 10),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${index + 1}',

                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                                SizedBox(width: 12),
                                                Expanded(
                                                    child: Column(

                                                      children: [
                                                        SizedBox(
                                                          height: 35,
                                                          child: TextField(
                                                            readOnly: true,
                                                            style: TextStyle(fontSize: 13),
                                                            controller: TextEditingController(text: point.address),
                                                            decoration: InputDecoration(
                                                              contentPadding: EdgeInsets.zero,
                                                              border: OutlineInputBorder(),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 10),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child: SizedBox(
                                                                  height: 35,

                                                                  child: TextField(
                                                                    style: TextStyle(fontSize: 13),
                                                                    controller: controller.viaTextEditingController[index].name,
                                                                    // onChanged: (val){
                                                                    //   controller.viaPoints[index].name!.text = val;
                                                                    //   controller.update();
                                                                    // },
                                                                    decoration: InputDecoration(

                                                                      contentPadding: EdgeInsets.zero,
                                                                      hintText: "Name",
                                                                      border: OutlineInputBorder(),
                                                                    ),
                                                                  ),
                                                                )),
                                                            SizedBox(width: 8),
                                                            Expanded(
                                                                child: SizedBox(
                                                                  height: 35,
                                                                  child: TextField(
                                                                    style: TextStyle(fontSize: 13),
                                                                    controller: controller.viaTextEditingController[index].mobile,
                                                                    // onChanged: (val) {
                                                                    //   controller.viaPoints[index].mobile!.text = val;
                                                                    //   controller.update();
                                                                    // },
                                                                    decoration: InputDecoration(

                                                                      contentPadding: EdgeInsets.zero,
                                                                      hintText: "Mobile",
                                                                      border: OutlineInputBorder(),
                                                                    ),
                                                                  ),
                                                                )),
                                                          ],
                                                        ),
                                                      ],
                                                    )),

                                                Padding(
                                                  padding: const EdgeInsets.only(left: 12.0, top: 8), // Add spacing from left
                                                  child: SizedBox(
                                                    width: 30,
                                                    height: 30,
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          controller.viaPoints.removeAt(index);
                                                          controller.update();
                                                        });
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.red,
                                                        padding: EdgeInsets.zero,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(4),
                                                        ),
                                                      ),
                                                      child: Icon(Icons.delete, color: Colors.white, size: 20),
                                                    ),
                                                  ),
                                                ),

                                                // SizedBox(
                                                //   width: 30,
                                                //   height: 30,
                                                //   child: ElevatedButton(
                                                //     onPressed: () {
                                                //       setState(() {
                                                //         viaPoints.removeAt(index);
                                                //       });
                                                //     },
                                                //     style: ElevatedButton.styleFrom(
                                                //         backgroundColor: Colors.red,
                                                //         padding: EdgeInsets.zero,
                                                //         shape: RoundedRectangleBorder(
                                                //           borderRadius: BorderRadius.circular(4),
                                                //         )),
                                                //     child: Icon(Icons.delete,
                                                //         color: Colors.white, size: 20),
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          );
                                        }),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding:
                                    EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)),
                              ),
                              onPressed: () {
                                controller.viaMilsCondition = false;
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Cancel",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),

                            SizedBox(width: 10),

                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding:
                                    EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)),
                              ),

                              onPressed: () {

                                controller.viaMilsCondition = true;
                                int len = controller.viaPoints.length;

                                for (int a = 0; a < len && a < controller.viaTextEditingController.length; a++) {
                                  controller.viaPoints[a].name = controller.viaTextEditingController[a].name.text;
                                  controller.viaPoints[a].mobile = controller.viaTextEditingController[a].mobile.text;
                                }
                                controller.fetchRouteFromOSRM();
                                Navigator.pop(context);
                              },
                              child: Text(
                                " Save ",
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),

                  Obx(() {
                    // controller.selectedTextFieldsValue.value = "VIA";
                    if (controller.selectedTextFieldsValue.value !=
                        "via") {
                      return SizedBox.shrink();
                    }
                    if (controller.allAddressesData.isEmpty) {
                      return SizedBox.shrink();
                    }
                    final GlobalKey<State<StatefulWidget>>? activeKey =
                        controller.activeFieldKey.value;
                    final RenderBox? fieldBox =
                    activeKey?.currentContext?.findRenderObject()
                    as RenderBox?;
                    final RenderBox? stackBox = controller
                        .stackKey.currentContext
                        ?.findRenderObject() as RenderBox?;

                    double top = 0.0;
                    double left = 0.0;
                    double width = Get.width/4;

                    if (fieldBox != null && stackBox != null) {
                      final Offset localOffset = fieldBox.localToGlobal(
                          Offset.zero,
                          ancestor: stackBox);
                      final double fieldHeight = fieldBox.size.height;
                      width = fieldBox.size.width;
                      top = localOffset.dy + fieldHeight;
                      left = localOffset.dx;
                    }
                    // ensure RawKeyboardListener gets focus when suggestions appear
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (controller.allAddressesData.isNotEmpty &&
                          !controller.viaFocusNode.hasFocus) {
                        // FocusScope.of(context).requestFocus(controller.pickupTextFieldFocusNode);
                      }
                    });

                    return Positioned(
                      top: 100,
                      // top: top,
                      left: left,
                      width: Get.width/4,
                      child: RawKeyboardListener(
                        focusNode: controller.viaFocusNode,
                        autofocus: true,
                        onKey: (RawKeyEvent event) {
                          if (event is RawKeyDownEvent) {
                            if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                              controller.moveHighlightDown(viaConditionValue: false);
                              return;
                            } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                              controller.moveHighlightUp(viaConditionValue: false);
                              return;
                            }else if (event.logicalKey == LogicalKeyboardKey.enter){
                              controller.selectedModel = controller.allAddressesData[controller.suggestionSelectedIndex.value];
                              addressController.text = "${controller.allAddressesData[controller.suggestionSelectedIndex.value].name} ${controller.allAddressesData[controller.suggestionSelectedIndex.value].postcode}";
                              controller.allAddressesData.clear();
                              controller.update();
                              print("enter press");
                            }
                            // Enter intentionally ignored so it does not select anything
                          }
                        },

                        child: Container(
                          height: screenHeight * 0.3,
                          // height: screenHeight * 0.3,
                          width: Get.width/4,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF0F2),
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5,
                                  offset: Offset(0, 2)),
                            ],
                          ),

                          // Rebuild list when highlightedIndex or data changes
                          child: Obx(() => ListView.builder(
                            key: controller.suggestionListKey,
                            controller: controller.suggestionScrollController,
                            // key: controller.suggestionListKeyVia,
                            // controller: controller.viaSuggestionScrollController,
                            itemCount: controller.allAddressesData.length,
                            padding: EdgeInsets.only(top: 15),
                            itemBuilder: (context, index) {
                              final item = controller.allAddressesData[index];
                              print("via via via");
                              print(controller.highlightedIndex.value);
                              print(index);
                              print("via via via");

                              return Obx(
                                    () {
                                      final isHighlighted = controller.highlightedIndex.value == index;
                                  return Container(
                                    key: controller.suggestionItemKeys[index],
                                    // key: ValueKey('suggestion_item_$index'),
                                    color: isHighlighted ? const Color(0xffA0DCFF) : Colors.transparent,
                                    child: ListTile(
                                      dense: true,
                                      visualDensity:
                                      VisualDensity.compact,
                                      // Animated text style so color/weight changes step-by-step
                                      title: AnimatedDefaultTextStyle(
                                        duration: const Duration(
                                            milliseconds: 120),
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: isHighlighted
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: isHighlighted
                                              ? Colors.blue
                                              : Colors.black,
                                        ),
                                        child: Text(
                                            "${item.name} ${item.postcode}"),
                                      ),
                                      onTap: (){
                                        controller.selectedModel = item;
                                        addressController.text = "${item.name} ${item.postcode}";
                                        controller.allAddressesData.clear();
                                        controller.update();
                                        /*=>
                                          controller.tapSelect(index),*/
                                      }
                                    ),
                                  );
                                },
                              );
                            },
                          )),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}

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

  // CHANGE INFO: Dialog ke persistent scrollbar ko properly render aur manage karne ke liye explicit controller banaya gaya hai.
  final ScrollController _viaDialogScrollController = ScrollController();

  Future<List<String>> _getNamesRequest(String query) async {
    if (query.isEmpty) return [];
    const duration = Duration(milliseconds: 800);

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    final completer = Completer<List<String>>();
    _controller.selectedTextFieldsValue.value = "VIA";
    _debounce = Timer(duration, () async {
      await _controller.getAddresses(fieldsName: "VIA", searchingText: query);

      final list = _controller.allAddressesData
          .map((m) => "${m.name ?? ''} ${m.postcode ?? ''}")
          .toList();

      completer.complete(list);
    });
    return completer.future;
  }

  Future<List<AllAddressesModel>> _getFakeRequestData(String query) async {
    _controller.onChangeHandler(fieldName: "VIA",searchingText: query);
    return await Future.delayed(const Duration(seconds: 1), () async {
      return _controller.allAddressesData.where((e) => e.name!.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  void dispose() {
    // CHANGE INFO: Memory leaks se bachne ke liye _viaDialogScrollController ko dispose routine me add kiya gaya hai.
    _viaDialogScrollController.dispose();
    super.dispose();
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
                    // CHANGE INFO: Pure Dialog wrapper me se 'SingleChildScrollView' ko hata kar yahan static Column lagaya taake header aur search input fields upar hi fix rahein aur look clean ho jaye.
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // --- FIXED HEADER SECTION ---
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

                        // --- FIXED INPUT & ADD BUTTON SECTION ---
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
                                }
                              },

                              child: SizedBox(
                                width: Get.width/4,
                                child: TextField(
                                    focusNode: controller.viaFieldFocusNode,
                                    controller: addressController,
                                    onTap: (){
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
                                  bool isViaWithReturn = !controller.viaSelectionOneWay.value;
                                  String currentTypeName = isViaWithReturn ? 'via with return' : 'via';

                                  int currentTypeCount = controller.viaPoints.where((p) => p.withReturnWay == currentTypeName).length;

                                  if (currentTypeCount < 6) {
                                    controller.polylinePoints.add(
                                      LatLng(controller.selectedModel!.lat!, controller.selectedModel!.lon!),
                                    );
                                    controller.viaPoints.add(ViaPoint(
                                      withReturnWay: currentTypeName,
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
                                    BotToast.showText(text: "Maximum 6 of '$currentTypeName' allowed");
                                  }
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

                        // --- SCROLLABLE CONTAINER AREA WITH VISIBLE DESKTOP SCROLLBAR ---
                        // CHANGE INFO: 'Expanded' widget ka use kar ke central space ko dynamic kiya aur andeone content par modern desktop style Custom Theme and Scrollbar implement kiya.
                        Expanded(
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              scrollbarTheme: ScrollbarThemeData(
                                thumbColor: MaterialStateProperty.all(Colors.grey[400]), // Modern grey color for the handler
                                trackColor: MaterialStateProperty.all(Colors.grey[100]), // Visible light track line background
                                trackBorderColor: MaterialStateProperty.all(Colors.transparent),
                                radius: Radius.circular(8), // Perfectly circular track border edges
                                thickness: MaterialStateProperty.all(8), // Standard prominent thickness level for clear desktop visibility
                              ),
                            ),
                            child: Scrollbar(
                              controller: _viaDialogScrollController,
                              thumbVisibility: true, // Permanent visibility constraint applied
                              trackVisibility: true, // Show navigation path line
                              interactive: true,   // Allow direct mouse drag interaction
                              child: SingleChildScrollView(
                                controller: _viaDialogScrollController,
                                padding: EdgeInsets.only(right: 14), // CHANGE INFO: Right padding barhai taake dynamic textfields scroller thumb ke piche hide na hon
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // --- LEFT COLUMN (O/W) ---
                                    SizedBox(
                                      // CHANGE INFO: Width ko slightly modify kiya (600->580, 280->265) taake newly embedded right scrollbar layout ko overlap na kare aur padding balanced rhey.
                                      width: controller.jourValue != 'W/R'? 580 : 265,
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
                                                        padding: const EdgeInsets.only(left: 12.0, top: 8),
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
                                                    ],
                                                  ),
                                                ):SizedBox.shrink();
                                              }),
                                        ],
                                      ),
                                    ),

                                    // --- RIGHT COLUMN (R/N) ---
                                    Visibility(
                                      visible: controller.pickupTwoWayController.text.isNotEmpty &&
                                          controller.jourValue == 'W/R'  ?true:false,
                                      child: SizedBox(
                                        // CHANGE INFO: Width adjust ki taake space management dynamic rhey.
                                        width: 265,
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
                                                          padding: const EdgeInsets.only(left: 12.0, top: 8),
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
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        // --- FIXED ACTION BUTTONS ---
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

                    // --- SUGGESTION OVERLAY BOX (UNCHANGED ORIGINAL LOGIC) ---
                    Obx(() {
                      if (controller.selectedTextFieldsValue.value != "via") {
                        return SizedBox.shrink();
                      }
                      if (controller.allAddressesData.isEmpty) {
                        return SizedBox.shrink();
                      }
                      final GlobalKey<State<StatefulWidget>>? activeKey = controller.activeFieldKey.value;
                      final RenderBox? fieldBox = activeKey?.currentContext?.findRenderObject() as RenderBox?;
                      final RenderBox? stackBox = controller.stackKey.currentContext?.findRenderObject() as RenderBox?;
                      double top = 0.0;
                      double left = 0.0;
                      double width = Get.width/4;
                      if (fieldBox != null && stackBox != null) {
                        final Offset localOffset = fieldBox.localToGlobal(Offset.zero, ancestor: stackBox);
                        final double fieldHeight = fieldBox.size.height;
                        width = fieldBox.size.width;
                        top = localOffset.dy + fieldHeight;
                        left = localOffset.dx;
                      }
                      WidgetsBinding.instance.addPostFrameCallback((_) {});
                      return Positioned(
                        top: 100,
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
                              } else if (event.logicalKey == LogicalKeyboardKey.enter){
                                controller.selectedModel = controller.allAddressesData[controller.suggestionSelectedIndex.value];
                                addressController.text = "${controller.allAddressesData[controller.suggestionSelectedIndex.value].name} ${controller.allAddressesData[controller.suggestionSelectedIndex.value].postcode}";
                                controller.allAddressesData.clear();
                                controller.update();
                                print("enter press");
                              }
                            }
                          },
                          child: Container(
                            height: screenHeight * 0.3,
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
                            child: Obx(() => ListView.builder(
                              key: controller.suggestionListKey,
                              controller: controller.suggestionScrollController,
                              itemCount: controller.allAddressesData.length,
                              padding: EdgeInsets.only(top: 15),
                              itemBuilder: (context, index) {
                                final item = controller.allAddressesData[index];
                                return Obx(
                                      () {
                                    final isHighlighted = controller.highlightedIndex.value == index;
                                    return Container(
                                      key: controller.suggestionItemKeys[index],
                                      color: isHighlighted ? const Color(0xffA0DCFF) : Colors.transparent,
                                      child: ListTile(
                                          dense: true,
                                          visualDensity: VisualDensity.compact,
                                          title: AnimatedDefaultTextStyle(
                                            duration: const Duration(milliseconds: 120),
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                                              color: isHighlighted ? Colors.blue : Colors.black,
                                            ),
                                            child: Text("${item.name} ${item.postcode}"),
                                          ),
                                          onTap: (){
                                            controller.selectedModel = item;
                                            addressController.text = "${item.name} ${item.postcode}";
                                            controller.allAddressesData.clear();
                                            controller.update();
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
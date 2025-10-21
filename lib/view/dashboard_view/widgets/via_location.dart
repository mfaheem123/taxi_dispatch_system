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

class Job {
  final String name;
  final IconData icon;
  const Job(this.name, this.icon);

  @override
  String toString() => name;
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


  // dataAssign() async{
  //   await Future.delayed(Duration(milliseconds: 400));
  //   final filtered = _controller.allAddressesData.where((m) => (m.name ?? '').toLowerCase().contains(query.toLowerCase()))
  //       .toList();
  //
  //   return _controller.allAddressesData.map((m) => m.name ?? '').toList();
  // }

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
            width: 600,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Stack(
                  children: [
                    Column(
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
                              onPressed: () => Navigator.pop(context),
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
                                // Expanded(
                                //   child: DropdownFlutter<String>.searchRequest(
                                //     futureRequest: _getNamesRequest,
                                //     hintText: 'Search location',
                                //     items: controller.allAddressesData.map((m) => m.name ?? '').toList(),
                                //     onChanged: (selectedName) {
                                //       print(selectedName);
                                //       // find original model (simple loop avoids firstWhere/orElse issues)
                                //       for (final m in controller.allAddressesData) {
                                //         if ("${m.name!} ${m.postcode!}"  == selectedName) {
                                //           controller.selectedModel = m;
                                //           break;
                                //         }
                                //       }
                                //       if (controller.selectedModel != null) {
                                //         print('Selected model: ${controller.selectedModel!.name}');
                                //         // use selectedModel (lat/lon, postcode, etc.)
                                //       }
                                //     },
                                //     decoration: CustomDropdownDecoration(
                                //       closedBorder: Border.all(color: Colors.grey),
                                //       closedBorderRadius: BorderRadius.circular(8),
                                //     ),
                                //     closedHeaderPadding: EdgeInsets.all(6),
                                //   ),
                                // ),

                                RawKeyboardListener(
                                  focusNode: controller
                                      .searchingAddressViaFocusNode,
                                  onKey: (event) {
                                    if (event is RawKeyDownEvent) {
                                      if (event.logicalKey ==
                                          LogicalKeyboardKey
                                              .arrowDown &&
                                          controller.highlightedIndex
                                              .value <
                                              controller.suggestions
                                                  .length -
                                                  1) {
                                        controller
                                            .highlightedIndex.value++;
                                        FocusScope.of(Get.context!).requestFocus(controller.viaFocusNode);
                                      } else if (event.logicalKey ==
                                          LogicalKeyboardKey
                                              .arrowUp &&
                                          controller.highlightedIndex
                                              .value >
                                              0) {
                                        FocusScope.of(Get.context!).requestFocus(controller.viaFocusNode);
                                        controller
                                            .highlightedIndex.value--;
                                      } else if (event.logicalKey ==
                                          LogicalKeyboardKey.enter) {
                                        final selected = controller
                                            .suggestions[controller.highlightedIndex.value].name;
                                        controller.selectSuggestion(
                                            selected);
                                      }else if(event.logicalKey == LogicalKeyboardKey.arrowDown || event.logicalKey == LogicalKeyboardKey.arrowUp || event.logicalKey == LogicalKeyboardKey.tab){
                                        FocusScope.of(Get.context!).requestFocus(controller.viaFocusNode);
                                        // FocusScope.of(Get.context!).requestFocus(controller.suggestionFocusNode);
                                      }
                                    }
                                  },
                                  child: SizedBox(
                                    width: Get.width/4,
                                    child: TextField(
                                        focusNode: controller.viaFieldFocusNode,
                                        controller: addressController,
                                        onTap: (){
                                          _controller.selectedTextFieldsValue.value = "VIA";
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
                                      if(controller.viaPoints.length <6){
                                      controller.polylinePoints.add(
                                        LatLng(controller.selectedModel!.lat!,
                                            controller.selectedModel!.lon!),
                                      );
                                      controller.viaPoints.add(ViaPoint(
                                          address: controller.selectedModel!.name!,
                                          lat: controller.selectedModel!.lat!,
                                          lng: controller.selectedModel!.lon!));
                                      controller.update();
                                    }else{
                                        BotToast.showText(text: "Only Five VIA Allow");
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
                        ListView.builder(
                            itemCount: controller.viaPoints.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final point = controller.viaPoints[index];
                              return Padding(
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
                                        TextField(
                                          readOnly: true,
                                          controller: TextEditingController(text: point.address),
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Expanded(
                                                child: TextField(
                                              onChanged: (val){
                                                point.name!.text = val;
                                                controller.update();
                                              },
                                              decoration: InputDecoration(
                                                hintText: "Name",
                                                border: OutlineInputBorder(),
                                              ),
                                            )),
                                            SizedBox(width: 8),
                                            Expanded(
                                                child: TextField(
                                              onChanged: (val) {
                                                point.mobile!.text = val;
                                                controller.update();
                                              },
                                              decoration: InputDecoration(
                                                hintText: "Mobile",
                                                border: OutlineInputBorder(),
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
                              onPressed: () => Navigator.pop(context),
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
                                controller.fetchRouteFromOSRM();
                                // for (var point in controller.viaPoints) {
                                //   print(
                                //       "${point.address} - ${point.name} - ${point.mobile}");
                                // }
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
                    Obx(() {
                      if (controller.selectedTextFieldsValue.value !=
                          "VIA") return SizedBox();
                      if (controller.allAddressesData.isEmpty)
                        return const SizedBox();
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

                      print(controller.selectedTextFieldsValue.value);
                      print(controller.selectedTextFieldsValue.value);
                      print(controller.selectedTextFieldsValue.value);
                      print(controller.selectedTextFieldsValue.value);
                      // ensure RawKeyboardListener gets focus when suggestions appear
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (controller.allAddressesData.isNotEmpty &&
                            !controller.suggestionFocusNode.hasFocus) {
                          // FocusScope.of(Get.context!).requestFocus(controller.suggestionFocusNode);
                          // FocusScope.of(context).requestFocus(controller.pickupTextFieldFocusNode);
                        }
                      });

                      return Positioned(
                        top: top,
                        left: left,
                        width: Get.width/4,
                        child: RawKeyboardListener(
                          focusNode: controller.viaFocusNode,
                          autofocus: true,
                          onKey: (RawKeyEvent event) {
                            if (event is RawKeyDownEvent) {
                              if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                                controller.moveHighlightDown();
                                return;
                              } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                                controller.moveHighlightUp();
                                return;
                              }
                              // Enter intentionally ignored so it does not select anything
                            }
                          },
                          child: Container(
                            height: screenHeight * 0.3,
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
                              controller: controller.viaSuggestionScrollController,
                              itemCount: controller.allAddressesData.length,
                              padding: EdgeInsets.only(top: 15),
                              itemBuilder: (context, index) {
                                final item = controller.allAddressesData[index];
                                final isHighlighted = controller.highlightedIndex.value == index;

                                print("controller.highlightedIndex.value");
                                print(controller.highlightedIndex.value);
                                print(index);
                                print("controller.highlightedIndex.value");

                                return Obx(
                                      () {
                                    final isHighlighted = controller.highlightedIndex.value == index;
                                    return Container(
                                      key: controller.suggestionItemKeys[index],
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
                                        onTap: () =>
                                            controller.tapSelect(index),
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
            ),
          );
        }
      ),
    );
  }
}

import 'package:dashboard_new1/component/escape_dismissible.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/component/unique_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:popover/popover.dart';
import '../component/alert_close_button.dart';
import '../component/dropdown_button.dart';
import '../view/customer/model/restricDriver.dart';
import '../view/dashboard_view/Controller/dashboard_controller.dart';
import '../component/color.dart';
import '../component/keyboard_dropdown_widget.dart';

class RestrictDriversAlert extends StatefulWidget {
  RestrictDriversAlert({super.key, this.formController});

  /// Which booking form opened this dialog.
  ///
  /// Left null on the dashboard, where the bare `Get.find` below resolves the
  /// permanent controller exactly as it always did. The edit screen passes its
  /// own tagged instance in: a dialog is pushed on a route of its own, so it
  /// sits outside the [BookingFormScope] the rest of that screen is wrapped in
  /// and cannot look the controller up from context.
  final DashboardController? formController;

  @override
  State<RestrictDriversAlert> createState() => _RestrictDriversAlertState();
}

class _RestrictDriversAlertState extends State<RestrictDriversAlert> {
  /// The form that opened this dialog — the edit screen's private instance
  /// when it passed one, the dashboard's permanent controller otherwise.
  late final DashboardController dashBoardCntrl =
      widget.formController ?? Get.find<DashboardController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (dashBoardCntrl.allDriverData == null) {
      dashBoardCntrl.getAllDrivers();
    }
  }

  @override
  Widget build(BuildContext context) {
    shortCutKeyValue.value = "alert";
    // Escape closes the alert: see EscapeDismissible for why the framework's
    // own Escape-to-dismiss never reached these dialogs.
    return EscapeDismissible(
      child: Dialog(
        insetPadding: EdgeInsets.all(20),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: GetBuilder<DashboardController>(
            // Follows whichever form opened the dialog.
            tag: dashBoardCntrl.formTag,
            builder: (controller) {
              return SizedBox(
                width: 450,
                // child: controller.allDriverData == null?SizedBox.shrink(): Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          color: DynamicColors.gryClr.withOpacity(0.5),
                          child: Row(
                            children: [
                              // Icon(Icons., color: DynamicColors.primaryClr, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                AppText.restrictDrivers,
                                style: mozillaTextSemiBoldText(fontWeight: FontWeight.w700, fontSize: 18),
                              ),
                              const Spacer(),
                              FocusTraversalOrder(
                                order: const NumericFocusOrder(999),
                                child: const AlertCloseButton(),
                              ),
                            ],
                          )),

                      SizedBox(height: 15),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //   Container(
                      //     padding: const EdgeInsets.symmetric(vertical: 6,horizontal: 10),
                      //     decoration: BoxDecoration(
                      //       border: const Border(
                      //         top: BorderSide(color: Colors.grey),
                      //         left: BorderSide(color: Colors.grey),
                      //         bottom: BorderSide(color: Colors.grey),
                      //         // 👉 right side intentionally remove kiya (no border)
                      //       ),
                      //     ),
                      //     child: Center(
                      //       child: Text("#"),
                      //     ),
                      //   ),
                      Flexible(
                          child: controller.allDriverData == null
                              ? const SizedBox.shrink()
                              : SingleChildScrollView(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // --- SELECT DRIVER TO RESTRICT SECTION ---
                                        Text(
                                          "SELECT DRIVER TO RESTRICT",
                                          style: mozillaTextSemiBoldText(
                                            fontWeight: FontWeight.bold, fontSize: 13, color: const Color(0xFF374151),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF9FAFB),
                                            border: Border.all(color: const Color(0xFFE5E7EB)),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: SizedBox(
                                                  height: 38,
                                                  child: CustomDropdownField<
                                                      DriverObject>(
                                                    label: "SELECT DRIVERS",
                                                    width: 320,
                                                    height: 35,
                                                    items: controller.allDriverData!.drivers!,
                                                    value: controller.selectDriverObject,
                                                    itemLabel: (driver) => "${driver.username} ${driver.name}".toUpperCase(),
                                                    onChanged: (val) {
                                                      controller.selectDriverObject = val;
                                                      controller.update();
                                                    },
                                                  ),
                                                ),
                                              ),
                                              // GestureDetector(
                                              //   onTap: (){
                                              //     if(controller.selectDriverObject != null){
                                              //     controller.driversList
                                              //         .add(controller.selectDriverObject!);
                                              //     controller.selectDriverObject = null;
                                              //     controller.update();
                                              //   }
                                              // },
                                              //   child: Container(
                                              //       padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 10),
                                              //       decoration: BoxDecoration(
                                              //         border: const Border(
                                              //           top: BorderSide(color: Colors.grey),
                                              //           right: BorderSide(color: Colors.grey),
                                              //           bottom: BorderSide(color: Colors.grey),
                                              //           // 👉 right side intentionally remove kiya (no border)
                                              //         ),
                                              //       ),
                                              //       child: Center(child: Icon(Icons.remove_circle,
                                              //         color: DynamicColors.primaryClr,
                                              //       ))),
                                              // )
                                              const SizedBox(width: 10),
                                              Focus(
                                                onKeyEvent: (node, event) {
                                                  if (event is KeyDownEvent &&
                                                      (event.logicalKey == LogicalKeyboardKey.enter ||
                                                          event.logicalKey == LogicalKeyboardKey.space)) {
                                                    if (controller.selectDriverObject != null) {
                                                      final isAlreadyAdded = controller.driversList.any(
                                                            (driver) => driver.id == controller.selectDriverObject!.id, // ya driver.username
                                                      );

                                                      if (!isAlreadyAdded) {
                                                        controller.driversList.add(controller.selectDriverObject!);
                                                        controller.selectDriverObject = null;
                                                        controller.update();
                                                      }
                                                    }
                                                    return KeyEventResult.handled;
                                                  }
                                                  return KeyEventResult.ignored;
                                                },
                                                child: Builder(
                                                  builder: (context) {
                                                    final isFocused =
                                                        Focus.of(context).hasFocus;
                                                    return GestureDetector(
                                                      onTap: () {
                                                        if (controller.selectDriverObject != null) {
                                                          final isAlreadyAdded = controller.driversList.any(
                                                                (driver) => driver.id == controller.selectDriverObject!.id, // ya driver.username
                                                          );

                                                          if (!isAlreadyAdded) {
                                                            controller.driversList.add(controller.selectDriverObject!);
                                                            controller.selectDriverObject = null;
                                                            controller.update();
                                                          }
                                                        }
                                                      },
                                                      child: Container(
                                                        height: 35,
                                                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                                        decoration: BoxDecoration(
                                                          color: DynamicColors.primaryClr,
                                                          borderRadius: BorderRadius.circular(4)
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            const Icon(Icons.add_circle, color: Colors.white, size: 16,
                                                            ),
                                                            const SizedBox(width: 6),
                                                            Text(
                                                              "RESTRICT",
                                                              style: mozillaTextSemiBoldText(
                                                                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        const SizedBox(height: 24),
                                        Text(
                                          "CURRENTLY RESTRICTED DRIVERS",
                                          style: mozillaTextSemiBoldText(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            color: const Color(0xFF374151),
                                          ),
                                        ),
                                        const SizedBox(height: 8),

                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(color: const Color(0xFFE5E7EB)),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Column(
                                            children: [
                                              // TABLE HEADER BAR
                                              Container(
                                                height: 40,
                                                color: const Color(0xFFEEF2F6),
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 45,
                                                      child: Center(
                                                        child: Text(
                                                          "#",
                                                          style: mozillaTextSemiBoldText(fontWeight: FontWeight.bold, fontSize: 13),
                                                        ),
                                                      ),
                                                    ),
                                                    const VerticalDivider(
                                                        width: 1,
                                                        color: Color(0xFFE5E7EB)),
                                                    Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 12.0),
                                                        child: Text(
                                                          "DRIVER NAME",
                                                          style: mozillaTextSemiBoldText(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const VerticalDivider(width: 1, color: Color(0xFFE5E7EB)),
                                                    const SizedBox(
                                                      width: 50,
                                                      child: Center(
                                                        child: Icon(Icons.settings, size: 16, color: Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              SizedBox(
                                                // height: 220,
                                                child: ListView.separated(
                                                    itemCount: controller.driversList.length,
                                                    scrollDirection: Axis.vertical,
                                                    shrinkWrap: true,
                                                    physics: AlwaysScrollableScrollPhysics(),
                                                    separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFE5E7EB)),
                                                    itemBuilder: (context, index) {
                                                      final driver = controller.driversList[index];
                                                      return Container(
                                                        // padding: const EdgeInsets.symmetric(vertical: 3.0),
                                                        color: Colors.white,
                                                        child: Row(
                                                          // mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            // Container(
                                                            //   padding: const EdgeInsets.symmetric(vertical: 7,horizontal: 10),
                                                            //   decoration: BoxDecoration(
                                                            //     border: const Border(
                                                            //       top: BorderSide(color: Colors.grey),
                                                            //       left: BorderSide(color: Colors.grey),
                                                            //       bottom: BorderSide(color: Colors.grey),
                                                            //       // 👉 right side intentionally remove kiya (no border)
                                                            //     ),
                                                            //   ),
                                                            SizedBox(
                                                              width: 45,
                                                              child: Center(child: Text("${index + 1}"),
                                                              ),
                                                            ),
                                                            Container(width: 1, height: 48, color: const Color(0xFFE5E7EB)),
                                                            Expanded(
                                                              child: Padding(
                                                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                                                child: Row(
                                                                  children: [
                                                                    // Driver Username Tag (Green Box)
                                                                    Container(
                                                                      width: 110,
                                                                      height: 32,
                                                                      decoration: BoxDecoration(
                                                                        color: DynamicColors.primaryClr,
                                                                        borderRadius: BorderRadius.circular(2),
                                                                      ),
                                                                      child: Center(
                                                                        child: Text(
                                                                          driver.username ?? "${index + 1}",
                                                                          style: mozillaTextSemiBoldText(
                                                                            fontSize: 12,
                                                                            color: Colors.white,
                                                                            fontWeight: FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(width: 12),

                                                                    Expanded(
                                                                      child: Text(
                                                                        (driver.name ?? "").toUpperCase(),
                                                                        maxLines: 1,
                                                                        overflow: TextOverflow.ellipsis,
                                                                        style: mozillaTextSemiBoldText(
                                                                          fontSize: 12,
                                                                          color: const Color(0xFF1F2937),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Container(width: 1, height: 48, color: const Color(0xFFE5E7EB)),
                                                            Focus(
                                                              onKeyEvent: (node, event) {
                                                                if (event is KeyDownEvent &&
                                                                    (event.logicalKey ==LogicalKeyboardKey.enter ||
                                                                        event.logicalKey ==
                                                                            LogicalKeyboardKey.space)) {
                                                                  controller.driversList.removeAt(index);
                                                                  controller.update();
                                                                  return KeyEventResult.handled;
                                                                }
                                                                return KeyEventResult.ignored;
                                                              },
                                                              child: Builder(
                                                                builder: (context) {
                                                                  final isFocused = Focus.of(context).hasFocus;
                                                                  return GestureDetector(
                                                                    onTap: () {
                                                                      controller.driversList.removeAt(index);
                                                                      controller.update();
                                                                    },
                                                                    child: Container(
                                                                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                                                                      decoration: BoxDecoration(
                                                                        color: isFocused
                                                                            ? DynamicColors.primaryClr.withOpacity(0.15)
                                                                            : Colors.transparent,
                                                                      ),
                                                                      child: Center(
                                                                        child: Icon(
                                                                          Icons.delete_forever,
                                                                          color: DynamicColors.redClr,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                    }),
                                              ),
                                            ],
                                          ),
                                        )
                                      ]),
                                )),
                      SizedBox(height: 20),
                    ]),
              );
            }),
      ),
    );
  }

  customKeyValue({key, value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          key ?? AppText.vehicle,
          style: mozillaTextSemiBoldText(
              fontSize: 14, color: DynamicColors.textClr.withOpacity(0.7)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Text(
            value ?? "vehicle Value",
            style: mozillaTextSemiBoldText(
                fontSize: 14, color: DynamicColors.textClr.withOpacity(0.7)),
          ),
        ),
      ],
    );
  }
}

class RestrictedDrivers extends StatefulWidget {
  RestrictedDrivers(
      {super.key,
      this.driversList,
      this.titleText,
      this.border,
      this.width,
      this.height,
      this.padding});

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
                color: isSelected
                    ? DynamicColors.primaryClr.withOpacity(0.2)
                    : null,
                child: ListTile(
                  title: Text(
                    items[index],
                    style: mozillaTextRegularText(
                      fontSize: 12,
                      color: isSelected
                          ? DynamicColors.primaryClr
                          : DynamicColors.textClr,
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
            _showPopover(context, widget.driversList ?? []);
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: GestureDetector(
        onTap: () => _showPopover(context, widget.driversList ?? []),
        child: Container(
          width: widget.width! * 1.5 /*MediaQuery.of(context).size.width / 6*/,
          height: widget.height,
          padding: EdgeInsets.only(top: 2, bottom: 2, left: 3),
          decoration: BoxDecoration(
            border: Border.all(
              color: _isFocused
                  ? DynamicColors.primaryClr
                  : Colors.grey, // 👈 change color on focus
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: widget.width! / 2.5,
                child: Text(
                  widget.titleText ?? AppText.selectDriver,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: mozillaTextRegularText(
                    fontSize: 12,
                  ),
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

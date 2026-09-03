import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/view/page_scroller.dart';
import 'package:dashboard_new1/view/vehicles_view/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../component/color_picker_widget.dart';
import '../../component/textStyle.dart';
import '../../component/text_field.dart';
import '../booking_view/reusable_widget.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';

class CreateVehicleTypes extends StatefulWidget {
  const CreateVehicleTypes({super.key});

  @override
  State<CreateVehicleTypes> createState() => _CreateVehicleTypesState();
}

class _CreateVehicleTypesState extends State<CreateVehicleTypes> {
  int selectedRowIndex = 0; // currently selected row
  final int totalRows = 5; // total rows (dynamic list ke hisaab se change hoga)

  VehicleController controller = Get.isRegistered<VehicleController>()
      ? Get.find<VehicleController>()
      : Get.put(VehicleController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "vehicleTypes";
    if(controller.singleVehicle == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.clearForm();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width /
    WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    return PageScrollWrapper(
      child: GetBuilder<VehicleController>(builder: (controller) {
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

          return Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Wrap(
                runSpacing: 16,
                spacing: 10,
                children: [
                  Focus(
                    onKeyEvent: (node, event) {
                      if (event is KeyDownEvent &&
                          (event.logicalKey == LogicalKeyboardKey.enter ||
                           event.logicalKey == LogicalKeyboardKey.space)) {
                        if (controller.profileImg != null ||
                            controller.singleVehicle?.image != null) {
                          // Image maujood hai — remove karo
                          controller.profileImg = null;
                          if (controller.singleVehicle != null) {
                            controller.singleVehicle!.image = null;
                          }
                          controller.update();
                        } else {
                          // Image nahi — picker kholo
                          controller.pickImage();
                        }
                        return KeyEventResult.handled;
                      }
                      return KeyEventResult.ignored;
                    },
                    child: Builder(
                      builder: (context) {
                        final focused = Focus.of(context).hasFocus;
                        return Stack(
                          alignment: Alignment.topRight,
                          children: [
                            InkWell(
                              focusColor: Colors.transparent,
                              onTap: () {
                                if (controller.profileImg == null &&
                                    controller.singleVehicle?.image == null) {
                                  controller.pickImage();
                                }
                              },
                              child: Container(
                                height: isMobile ? 200 : 400,
                                width: fieldWidth,
                                margin: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: focused ? DynamicColors.primaryClr : Colors.grey,
                                    width: focused ? 2.5 : 1,
                                  ),
                                  image: controller.profileImg != null
                                      ? DecorationImage(
                                          image: MemoryImage(controller.profileImg!.bytes),
                                          fit: BoxFit.fill,
                                        )
                                      : (controller.singleVehicle?.image != null
                                          ? DecorationImage(
                                              image: NetworkImage(controller.singleVehicle!.image!),
                                              fit: BoxFit.fill,
                                            )
                                          : null),
                                ),
                                child: (controller.profileImg == null &&
                                        controller.singleVehicle?.image == null)
                                    ? Center(
                                        child: Text(
                                          "UPLOAD IMAGE",
                                          style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                            color: focused
                                                ? DynamicColors.primaryClr
                                                : Colors.black,
                                          ),
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                            // X button — InkWell ke bahar
                            if (controller.profileImg != null ||
                                controller.singleVehicle?.image != null)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    controller.profileImg = null;
                                    if (controller.singleVehicle != null) {
                                      controller.singleVehicle!.image = null;
                                    }
                                    controller.update();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    margin: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.7),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.close_rounded,
                                      color: DynamicColors.redClr,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: fieldWidth * 2.7,
                    child: FocusTraversalGroup(
                      policy: OrderedTraversalPolicy(),
                      child: Column(
                        children: [
                          Container(
                            // height: screenHeight / 20,
                            width: Get.width,
                            color: DynamicColors.gryClr,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 18.0, vertical: 12),
                              child: Text(
                                AppText.vehicleType,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FocusTraversalOrder(
                            order: NumericFocusOrder(1),
                            child: customWidget(
                              value: controller.defaultVehicleValue.value,
                              onChanged: (v) {
                                controller.defaultVehicleValue.value = v!;
                                controller.update();
                              },
                              text: AppText.defaultVehicle,
                              width: 140,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Wrap(
                            runSpacing: 16,
                            spacing: 10,
                            children: [
                              FocusTraversalOrder(
                                order: NumericFocusOrder(2),
                                child: CustomTextField(
                                  borderRadius: 4,
                                  controller: controller.vehicleTypeController,
                                  width: fieldWidth / 2,
                                  hintText: AppText.vehicleType,
                                  columnText: true,
                                  height: 35,
                                  inputFormatters: [
                                    UpperCaseTextFormatter()
                                  ],
                                ),
                              ),
                              FocusTraversalOrder(
                                order: NumericFocusOrder(3),
                                child: CustomTextField(
                                  inputFormatters:  [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  borderRadius: 4,
                                  controller: controller.passengersController,
                                  width: fieldWidth / 2,
                                  hintText: AppText.passengers,
                                  columnText: true,
                                  height: 35,
                                ),
                              ),
                              FocusTraversalOrder(
                                order: NumericFocusOrder(4),
                                child: CustomTextField(
                                  inputFormatters:  [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  borderRadius: 4,
                                  controller: controller.luggagesController,
                                  width: fieldWidth / 2,
                                  hintText: AppText.luggages,
                                  columnText: true,
                                  height: 35,
                                ),
                              ),
                              FocusTraversalOrder(
                                order: NumericFocusOrder(5),
                                child: CustomTextField(
                                  inputFormatters:  [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  borderRadius: 4,
                                  controller: controller.handLuggagesController,
                                  width: fieldWidth / 2,
                                  hintText: AppText.handLuggages,
                                  columnText: true,
                                  height: 35,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FocusTraversalOrder(
                                    order: NumericFocusOrder(6),
                                    child: customWidget(
                                      value: controller.minimumMilesValue.value,
                                      onChanged: (v) {
                                        controller.minimumMilesValue.value = v!;
                                        controller.update();
                                      },
                                      text: AppText.minimumMiles,
                                      width: 140,
                                    ),
                                  ),
                                  FocusTraversalOrder(
                                    order: NumericFocusOrder(7),
                                    child: CustomTextField(
                                      inputFormatters:  [
                                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                                      ],
                                      borderRadius: 4,
                                      controller: controller.minimumMilesController,
                                      width: fieldWidth / 2,
                                      hintText: "",
                                      readOnly: !controller.minimumMilesValue.value,
                                      columnText: false,
                                      height: 35,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FocusTraversalOrder(
                                    order: NumericFocusOrder(8),
                                    child: customWidget(
                                      value: controller.minimumFaresValue.value,
                                      onChanged: (v) {
                                        controller.minimumFaresValue.value = v!;
                                        controller.update();
                                      },
                                      text: AppText.minimumFares,
                                      width: 140,
                                    ),
                                  ),
                                  FocusTraversalOrder(
                                    order: NumericFocusOrder(9),
                                    child: CustomTextField(
                                      inputFormatters:  [
                                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                                      ],
                                      borderRadius: 4,
                                      controller: controller.minimumFaresController,
                                      width: fieldWidth / 2,
                                      hintText: "",
                                      readOnly: !controller.minimumMilesValue.value,
                                      columnText: false,
                                      height: 35,
                                    ),
                                  ),
                                ],
                              ),
                              FocusTraversalOrder(
                                order: NumericFocusOrder(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(AppText.backgroundClr,
                                        style: mozillaTextSemiBoldText(
                                            context: context, fontSize: 13)),
                                    ColorPickerWidget(
                                      width: fieldWidth / 2,
                                      pickerColor: controller.pickerColor,
                                      onColorChanged: (color) {
                                        setState(() {
                                          controller.pickerColor =
                                              color; // live preview
                                        });
                                      },
                                      onColorSelected: (color) {
                                        setState(() {
                                          controller.pickerColor =
                                              color; // final selected
                                        });
                                      },
                                      borderColor: DynamicColors.gryClr,
                                    ),
                                  ],
                                ),
                              ),
                              FocusTraversalOrder(
                                order: NumericFocusOrder(11),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(AppText.foregroundClr,
                                        style: mozillaTextSemiBoldText(
                                            context: context, fontSize: 13)),
                                    ColorPickerWidget(
                                      width: fieldWidth / 2,
                                      pickerColor: controller.foregroundColor,
                                      onColorChanged: (color) {
                                        setState(() {
                                          controller.foregroundColor =
                                              color; // live preview
                                        });
                                      },
                                      onColorSelected: (color) {
                                        setState(() {
                                          controller.foregroundColor =
                                              color; // final selected
                                        });
                                      },
                                      borderColor: DynamicColors.gryClr,
                                    ),
                                  ],
                                ),
                              ),
                              FocusTraversalOrder(
                                order: NumericFocusOrder(12),
                                child: CustomTextField(
                                  borderRadius: 4,
                                  controller:
                                      controller.driverWaitingChargesController,
                                  inputFormatters:  [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  width: fieldWidth / 2,
                                  hintText: AppText.driverWaitingCharges,
                                  columnText: true,
                                  height: 35,
                                ),
                              ),
                              FocusTraversalOrder(
                                order: NumericFocusOrder(13),
                                child: CustomTextField(
                                  borderRadius: 4,
                                  inputFormatters:  [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  controller:
                                      controller.accountWaitingChargesController,
                                  width: fieldWidth / 2,
                                  hintText: AppText.accountWaitingCharges,
                                  columnText: true,
                                  height: 35,
                                ),
                              ),
                              FocusTraversalOrder(
                                order: NumericFocusOrder(14),
                                child: CustomTextField(
                                  inputFormatters:  [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  borderRadius: 4,
                                  controller: controller.waitingTimeController,
                                  width: fieldWidth / 2,
                                  hintText: AppText.waitingTime,
                                  columnText: true,
                                  height: 35,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          FocusTraversalOrder(
                            order: NumericFocusOrder(15),
                            child: CustomButton(
                              onTap: () {
                                controller.createVehicleType();
                              },
                              height: 30,
                              width: fieldWidth,
                              btnText:
                              controller.singleVehicle == null?
                              AppText.save: "UPDATE",
                              fontSize: 11,
                              verticalPadding: 0.0,
                              borderRadius: 4,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
      }),
    );
  }
}

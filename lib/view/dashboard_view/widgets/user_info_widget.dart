


import 'package:dashboard_new1/view/dashboard_view/Controller/dashboard_controller.dart';
import 'package:dashboard_new1/view/dashboard_view/widgets/time_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../alert/restrict_drivers_alert.dart';
import '../../../component/calender.dart';
import '../../../component/color.dart';
import '../../../component/dropdown_button.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_field.dart';
import '../../../component/text_widget.dart';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

// ===== Keyboard activatable wrapper: Enter/Space => onActivate() =====
class KbdActivatable extends StatelessWidget {
  final FocusNode focusNode;
  final VoidCallback onActivate;
  final Widget child;

  const KbdActivatable({
    super.key,
    required this.focusNode,
    required this.onActivate,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: focusNode,
      child: Shortcuts(
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.enter): ActivateIntent(),
          LogicalKeySet(LogicalKeyboardKey.space): ActivateIntent(),
        },
        child: Actions(
          actions: {
            ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) {
              onActivate();
              return null;
            }),
          },
          child: GestureDetector(
            onTap: onActivate,
            behavior: HitTestBehavior.opaque,
            child: child,
          ),
        ),
      ),
    );
  }
}


// ================== YOUR WIDGET (with keyboard support) ==================
class UserInfoWidget extends StatefulWidget {
  const
  UserInfoWidget({super.key});

  @override
  State<UserInfoWidget> createState() => _UserInfoWidgetState();
}

class _UserInfoWidgetState extends State<UserInfoWidget> {
  // Text controllers (stable, not recreated every build)
  final nameCtl = TextEditingController();
  final emailCtl = TextEditingController();
  final mobileCtl = TextEditingController();
  final telCtl = TextEditingController();
  final leadCtl = TextEditingController();
  final fareCtl = TextEditingController();
  final accCtl = TextEditingController();


  // FocusNodes for keyboard-activatable non-text widgets
  final FocusNode jourFN = FocusNode();
  final FocusNode drvFN = FocusNode();
  final FocusNode payFN = FocusNode();
  final FocusNode calendarFN = FocusNode();

  @override
  void dispose() {
    nameCtl.dispose();
    emailCtl.dispose();
    mobileCtl.dispose();
    telCtl.dispose();
    leadCtl.dispose();
    fareCtl.dispose();
    accCtl.dispose();
    jourFN.dispose();
    drvFN.dispose();
    payFN.dispose();
    calendarFN.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(), // Tab/Shift+Tab follow our numeric orders
      child: GetBuilder<DashboardController>(
        builder: (controller) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final bool isMobile = constraints.maxWidth < 600;
              final bool isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 1024;

              final double fieldWidth = isMobile
                  ? constraints.maxWidth * 0.9
                  : isTablet
                  ? 150
                  : 150;

              return Column(
                children: [

                  SizedBox(height: screenHeight * 0.019),
                  // ================= Row 1: Name, Email, Mobile, Tel =================
                  SingleChildScrollView(
                    scrollDirection: isMobile ? Axis.vertical : Axis.horizontal,
                    child: Flex(
                      direction: isMobile ? Axis.vertical : Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FocusTraversalOrder(
                          order: const NumericFocusOrder(1),
                          child: labeledTextField(context, isMobile, AppText.name, nameCtl,
                              width: fieldWidth,
                              textInputAction: TextInputAction.next),
                        ),
                        const SizedBox(width: 12),
                        // _gap(isMobile),
                        FocusTraversalOrder(
                          order: const NumericFocusOrder(2),
                          child: labeledTextField(context, isMobile, AppText.email, emailCtl,
                              width: fieldWidth,
                              textInputAction: TextInputAction.next),
                        ),
                        const SizedBox(width: 12),
                        // _gap(isMobile),
                        FocusTraversalOrder(
                          order: const NumericFocusOrder(3),
                          child: labeledTextField(context, isMobile, AppText.mobile, mobileCtl,
                              width: fieldWidth,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.phone,
                              formatDigitsOnly: false),
                        ),
                        const SizedBox(width: 12),
                        // _gap(isMobile),
                        FocusTraversalOrder(
                          order: const NumericFocusOrder(4),
                          child: labeledTextField(context, isMobile, AppText.tel, telCtl,
                              width: fieldWidth,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.phone,
                              formatDigitsOnly: false),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.019),

                  // ============== Row 2: Date, Time, Lead (mins), Journey dropdown ==============
                  SingleChildScrollView(
                    scrollDirection: isMobile ? Axis.vertical : Axis.horizontal,
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        // (5) Date
                        FocusTraversalOrder(
                          order: const NumericFocusOrder(5),
                          child: labeledField(
                            context: context,
                            isMobile: isMobile,
                            label: AppText.date,
                            width: fieldWidth,
                            child: SizedBox(height: 30, child: KeyboardDatePicker()),
                          ),
                        ),
                        // (6) Time
                        FocusTraversalOrder(
                          order: const NumericFocusOrder(6),
                          child: labeledField(
                            context: context,
                            isMobile: isMobile,
                            label: AppText.time,
                            width: fieldWidth,
                            child: SizedBox(height: 30, child: CustomTimePicker()),
                          ),
                        ),
                        // (7) Lead (mins)
                        FocusTraversalOrder(
                          order: const NumericFocusOrder(7),
                          child: labeledField(
                            context: context,
                            isMobile: isMobile,
                            label: AppText.lead,
                            width: fieldWidth,
                            child: SizedBox(
                              height: 30,
                              child: CustomTextField(
                                hintText: "MINS",
                                controller: leadCtl,
                                borderRadius: 4,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                              ),
                            ),
                          ),
                        ),

                        // (8) Journey dropdown (O/W, R/N, W/R)
                        FocusTraversalOrder(
                          order: const NumericFocusOrder(8),
                          child: RestrictedDrivers(
                            width: fieldWidth,
                            height: 30,
                            padding: 0.0,
                            titleText: "SELECT PLOT",
                            driversList: [
                              'DEMO COMPANY 01', 'DEMO COMPANY 02'
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.019),

                  // ============== Row 3: Driver, Fare, Account, Pay, Calendar Icon ==============
                  SingleChildScrollView(
                    scrollDirection: isMobile ? Axis.vertical : Axis.horizontal,
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        // (9) Driver dropdown
                        FocusTraversalOrder(
                          order: const NumericFocusOrder(9),
                          child: labeledField(
                            context: context,
                            isMobile: isMobile,
                            label: AppText.drv,
                            width: fieldWidth,
                            child: Container(
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: DynamicColors.primaryClr, width: 1.2),
                              ),
                              child: // (8) Journey dropdown (O/W, R/N, W/R)
                              RestrictedDrivers(
                                width: fieldWidth,
                                height: 30,
                                padding: 0.0,
                                titleText: controller.drvValue,
                                driversList: [
                                  "25 GEORGE HAMPTON",
                                  "26 PAUL DOUBLEDAY",
                                  "27 RICHARD HARDWICK",
                                  "28 LANRE OKERJO",
                                ],
                              ),
                            ),
                          ),
                        ),

                        // (10) Fare (Slugg)
                        FocusTraversalOrder(
                          order: const NumericFocusOrder(10),
                          child: labeledField(
                            context: context,
                            isMobile: isMobile,
                            label: AppText.fare,
                            width: fieldWidth,
                            child: SizedBox(
                              height: 30,
                              child: CustomTextField(
                                hintText: "Slugg",
                                controller: fareCtl,
                                borderRadius: 6,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(6),
                                ],
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                              ),
                            ),
                          ),
                        ),

                        // (11) Account
                        FocusTraversalOrder(
                          order: const NumericFocusOrder(11),
                          child: labeledField(
                            context: context,
                            isMobile: isMobile,
                            label: AppText.acc,
                            width: fieldWidth,
                            child: SizedBox(
                              height: 30,
                              child: CustomTextField(
                                hintText: "SELECT ACCOUNT",
                                controller: accCtl,
                                borderRadius: 6,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(6),
                                ],
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                              ),
                            ),
                          ),
                        ),

                        // (12) Pay dropdown
                        FocusTraversalOrder(
                          order: const NumericFocusOrder(12),
                          child: labeledField(
                            context: context,
                            isMobile: isMobile,
                            label: AppText.pay,
                            width: fieldWidth,
                            child: Container(
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: DynamicColors.primaryClr),
                              ),
                              child:
                              RestrictedDrivers(
                                width: fieldWidth,
                                height: 30,
                                padding: 0.0,
                                titleText: controller.payValue,
                                driversList: [
                                  "CASH", "CREDIT CARD", "ACCOUNT", "CREDIT CARD PAID"
                                ],
                              ),
                            ),
                          ),
                        ),

                        // (13) Calendar icon (keyboard clickable)
                        FocusTraversalOrder(
                          order: const NumericFocusOrder(13),
                          child: SizedBox(
                            height: 33,
                            child: KbdActivatable(
                              focusNode: calendarFN,
                              onActivate: () {
                                // TODO: open your calendar modal/sheet
                                // For demo:
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Calendar icon activated")),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(Icons.calculate, size: 20),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  // ===== Helpers to keep your look & feel the same =====

}


Widget labeledField({
  required BuildContext context,
  required bool isMobile,
  required String label,
  required Widget child,
  required double width,
   double? heights,
  bool column = false,
}) {
  return SizedBox(
    height: column == true ? null : heights??30,
    child: column == true? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: mozillaTextSemiBoldText(context: context, fontSize: 13)),
        const SizedBox(width: 10),
        if (isMobile)
          Expanded(child: child)
        else
          SizedBox(width: width, child: child),
      ],
    ): Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: mozillaTextSemiBoldText(context: context, fontSize: 13)),
        const SizedBox(width: 10),
        if (isMobile)
          Expanded(child: child)
        else
          SizedBox(width: width, child: child),
      ],
    ),
  );
}


Widget labeledTextField(
    BuildContext context,
    bool isMobile,
    String label,
    TextEditingController controller, {
      required double width,
      TextInputType? keyboardType,
      bool formatDigitsOnly = false,
      TextInputAction textInputAction = TextInputAction.next,
      bool column = false,
      Widget? child,
      String? hintTex,
      readOnly = false,
      Color? borderColor,
      borderWidth = 2,
      final GestureTapCallback? onTap,
      final ValueChanged<String>? onChanged,


    }) {

  return SizedBox(
    height: column == true ? null : 30,
    child: column == true
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
            mozillaTextSemiBoldText(context: context, fontSize: 13)),
        const SizedBox(height: 5),

        if (isMobile)
          Expanded(
            child: CustomTextField(
              controller: controller,
              borderRadius: 4,
              hintText: hintTex,
              onTap: onTap,
              onChanged: onChanged,
              keyboardType: keyboardType,
              inputFormatters: formatDigitsOnly
                  ? [FilteringTextInputFormatter.digitsOnly]
                  : null,
              textInputAction: textInputAction,
              readOnly: readOnly,
              borderColor: borderColor,
              borderWidth: borderWidth,       // << ADDED
              onSubmitted: (_) =>
                  FocusScope.of(context).nextFocus(),
            ),
          )
        else
          SizedBox(
            width: width,
            child: CustomTextField(
              controller: controller,
              borderRadius: 4,
              keyboardType: keyboardType,
              inputFormatters: formatDigitsOnly
                  ? [FilteringTextInputFormatter.digitsOnly]
                  : null,
              textInputAction: textInputAction,
              readOnly: readOnly,
              borderColor: borderColor,
              borderWidth: borderWidth,
              onChanged: onChanged,          // << ADDED
              onSubmitted: (_) =>
                  FocusScope.of(context).nextFocus(),
            ),
          ),
      ],
    )
        : Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label,
            style:
            mozillaTextSemiBoldText(context: context, fontSize: 13)),
        const SizedBox(width: 12),

        if (isMobile)
          Expanded(
            child: CustomTextField(
              controller: controller,
              borderRadius: 4,
              keyboardType: keyboardType,
              inputFormatters: formatDigitsOnly
                  ? [FilteringTextInputFormatter.digitsOnly]
                  : null,
              textInputAction: textInputAction,
              readOnly: readOnly,
              borderColor: borderColor,
              borderWidth: borderWidth,
              onChanged: onChanged,          // << ADDED
              onSubmitted: (_) =>
                  FocusScope.of(context).nextFocus(),
            ),
          )
        else
          SizedBox(
            width: width,
            child: CustomTextField(
              controller: controller,
              borderRadius: 4,
              keyboardType: keyboardType,
              inputFormatters: formatDigitsOnly
                  ? [FilteringTextInputFormatter.digitsOnly]
                  : null,
              textInputAction: textInputAction,
              readOnly: readOnly,
              borderColor: borderColor,
              borderWidth: borderWidth,
              onChanged: onChanged,          // << ADDED
              onSubmitted: (_) =>
                  FocusScope.of(context).nextFocus(),
            ),
          ),
      ],
    ),
  );
}

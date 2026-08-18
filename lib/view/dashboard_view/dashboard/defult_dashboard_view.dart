import 'dart:async';
import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/view/dashboard_view/dashboard/dashboard_shortcuts.dart';
import 'package:dashboard_new1/view/dashboard_view/dashboard/shortcut_key_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../alert/child_seats_alert.dart';
import '../../../alert/extra_fares_alert.dart';
import '../../../alert/extra_info_alert.dart';
import '../../../alert/restrict_drivers_alert.dart';
import '../../../component/color.dart';
import '../../../component/dropdown_button.dart' show CustomDropdownField;
import '../../../component/suggestion_widget/suggestion_controller.dart';
import '../../../component/suggestion_widget/suggestion_view.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_field.dart';
import '../../../component/text_widget.dart';
import '../../../component/time_duration_method.dart';
import '../../auth/dashboard_form_widget.dart';
import '../../cli_Screen.dart';
import '../../locations_view/Model/location_types_zoneModel.dart';
import '../../locations_view/controller/locations_controller.dart';
import '../Controller/dashboard_controller.dart';
import '../booking_table.dart';
import 'drivers.dart';
import 'map_view_widget.dart';
import 'package:flutter/material.dart' as material;


double containerFormHeight = 0;

class ByDefaultDashboard extends StatefulWidget {
  ByDefaultDashboard({
    super.key,
    this.onTap,
  });

  final GestureTapCallback? onTap;

  @override
  State<ByDefaultDashboard> createState() => _ByDefaultDashboardState();
}

class _ByDefaultDashboardState extends State<ByDefaultDashboard> {
  FocusNode _focusNode = FocusNode();
  final FocusNode swap1FN = FocusNode();
  final FocusNode swap1FNTwoWay = FocusNode();
  final FocusNode clearPic = FocusNode();
  final FocusNode clearPicTwo = FocusNode();
  final FocusNode clearDrop = FocusNode();
  final FocusNode swap2FN = FocusNode();
  final FocusNode swap2FNTwoWay = FocusNode();
  final FocusNode calendarFN = FocusNode();
  final FocusNode checkboxFocus = FocusNode();
  final FocusNode checkboxFocusReturn = FocusNode();
  final FocusNode emailFocus = FocusNode();

  Timer? _debounce;

  final LocationController _controller = Get.isRegistered<LocationController>()
      ? Get.find<LocationController>()
      : Get.put(LocationController());
  DashboardController controller = Get.find();

  SuggestionController suggestion_controller =
  Get.isRegistered<SuggestionController>()
      ? Get.find<SuggestionController>()
      : Get.put(SuggestionController());

  @override
  void initState() {
    // TODO: implement initState
    controller = Get.isRegistered<DashboardController>()
        ? Get.find<DashboardController>()
        : Get.put(DashboardController());
    super.initState();
    if (controller.dashboardAllData == null) {
      controller.dashboardData();
    }
  }

  final GlobalKey _containerKey = GlobalKey();

  final GlobalKey _bookingFormKey = GlobalKey();
  double? _bookingFormHeight;

  void _measureBookingForm() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final ctx = _bookingFormKey.currentContext;
      // Element may be null (not built) or inactive (built earlier, now
      // removed from the tree — e.g. while bookingTable is shown). Either
      // way it has no render object, so bail before findRenderObject().
      if (ctx == null || !ctx.mounted) return;
      final box = ctx.findRenderObject() as RenderBox?;
      if (box == null || !box.hasSize) return;
      final h = box.size.height;
      if (h > 0 && h != _bookingFormHeight) {
        setState(() => _bookingFormHeight = h);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final isDesktop = w >= 1024;
    final isTablet  = w >= 640 && w < 1024;
    _measureBookingForm();

    // Wraps the whole screen (booking form, drivers panel, map, booking table
    // and everything else) so the F1-F12 / "/" shortcuts fire wherever focus
    // happens to be — key events only travel up from the focused node, so the
    // bindings have to sit above every widget on this screen. Kept OUTSIDE the
    // GetBuilder so its focus node survives the loading -> loaded rebuild.
    return DashboardShortcuts(
      child: GetBuilder<DashboardController>(initState: (v) {

      controller.seeZoneOnMapp();
      // controller.getMobileNumberWithName();
      if (_controller.locationtypezoneModel == null) {
        _controller.getLocationTypeZone();
      }
    }, builder: (controller) {
      if (controller.dashboardAllData == null) {
        return material.Center(child: CircularProgressIndicator());
      }

      final bookingForm = KeyedSubtree(
        key: _bookingFormKey,
        child: BookingFormScreen(),
      );

// Height used by the side panels. On the very first frame the booking
// form hasn't been measured yet (_bookingFormHeight == null), so fall
// back to a sensible height — otherwise the SizedBox imposes no vertical
// constraint and MapViewWidget's inner Stack crashes with "size: MISSING".
      final sidePanelHeight = _bookingFormHeight ?? screenHeight * 0.6;

// On iPad / mobile (anything narrower than a desktop) the three
// panels stack vertically instead of sitting side-by-side.
      final topSection = isDesktop
          ? Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 5, child: bookingForm),
          Expanded(
            flex: 2,
            child: SizedBox(
              height: sidePanelHeight,
              child: DriversView(),
            ),
          ),
          Expanded(
            flex: 3,
            child: SizedBox(
              height: sidePanelHeight,
              child: MapViewWidget(),
            ),
          ),
        ],
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          bookingForm,
          const SizedBox(height: 12),
          SizedBox(
            height: screenHeight * 0.6,
            child: DriversView(),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: screenHeight * 0.6,
            child: MapViewWidget(),
          ),
        ],
      );

      final bookingTable = Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BookingTable(),
        ),
      );

      final body = Column(
        children: [
          topSection,
          // Booking table is hidden in the stacked (iPad / mobile) layout.
          if (isDesktop) bookingTable,
        ],
      );
      // The stacked layout is taller than the screen, so make it scrollable.
      return Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: DynamicColors.secondaryClr),

            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShortcutKeyWidget(),
                ShortcutKeyWidget(
                    keyss: "F2",
                    valuess: "BOOKING FORM"),
                ShortcutKeyWidget(
                    keyss: "F3",
                    valuess: "DRIVER VEHICLE"),
                ShortcutKeyWidget(
                    keyss: "F4",
                    valuess: "DRIVER EARNING"),
                ShortcutKeyWidget(
                    keyss: "F6", valuess: "QUOTATION"),
                ShortcutKeyWidget(
                    keyss: "/", valuess: "SHORTCUTS"),
                // width >= 1900
                //     ? Spacer()
                //     : SizedBox.shrink(),
                const Spacer(),
                Padding(
                  padding:
                  const EdgeInsets.only(right: 6.0),
                  child: CustomButton(
                    width: 135,
                    height: 35,
                    borderRadius: 6,
                    verticalPadding: 0,
                    style: mozillaTextSemiBoldText(
                        fontSize: 11,
                        color: DynamicColors.whiteClr),
                    onTap: () {
                    setState(() {
                      controller.hideDashBoard.value =
                      !controller.hideDashBoard.value;
                    });
                    },
                    btnText:
                    controller.hideDashBoard.value
                        ? "HIDE DASHBOARD[F12]"
                        : "SHOW DASHBOARD[F12]",
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            child: controller.hideDashBoard.value
                ? (isDesktop ? body : SingleChildScrollView(child: body))
                : bookingTable,
          ),
        ],
      );
    }),
    );
  }

  Widget buildChip(String label, {bool isFirst = false, bool isLast = false}) {
    return Expanded(
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          border: Border.all(color: Colors.blue.shade300),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
import 'dart:async';
import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/customButton.dart';
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
import '../models/account_darshboard_model.dart';
import '../models/dashboard_model.dart';
import '../widgets/fare_configuration.dart';
import '../widgets/pickup_widget.dart';
import '../widgets/quotation_widget.dart';
import '../widgets/time_picker_widget.dart';
import '../widgets/user_info_widget.dart' hide KbdActivatable;
import 'F8_widget_alert.dart';
import 'F9_widget_alert.dart';
import 'booking_form_widget.dart';
import 'custom_booking_widget/custom_deshboard_ipad_widget.dart';
import 'drivers.dart';
import 'form_short_cut_key.dart';
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
  final List<FocusNode> _focusNodes =
  List.generate(4, (index) => FocusNode()); // 4 icons

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
      final ctx = _bookingFormKey.currentContext;
      if (ctx == null) return;
      final box = ctx.findRenderObject() as RenderBox?;
      final h = box?.size.height;
      if (h != null && h > 0 && h != _bookingFormHeight && mounted) {
        setState(() => _bookingFormHeight = h);
      }
    });
   }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding
        .instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
    final w = MediaQuery.of(context).size.width;
    final isDesktop = w >= 1024;
    final isTablet  = w >= 640 && w < 1024;
    _measureBookingForm();

    return GetBuilder<DashboardController>(initState: (v) {

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
                    height: _bookingFormHeight,
                    child: DriversView(),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: _bookingFormHeight,
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
      return SafeArea(
        child: isDesktop ? body : SingleChildScrollView(child: body),
      );
    });
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
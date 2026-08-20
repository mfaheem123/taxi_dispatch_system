import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/routes/app_pages.dart';
import 'package:dashboard_new1/view/accounts/Invoice/create_customer_invoice.dart';
import 'package:dashboard_new1/view/accounts/Invoice/list_of_account_invoice_screen.dart';
import 'package:dashboard_new1/view/accounts/Invoice/create_account_invoice_screen.dart';
import 'package:dashboard_new1/view/accounts/create_escort_screen.dart';
import 'package:dashboard_new1/view/accounts/list_escorte_screen.dart';
import 'package:dashboard_new1/view/administration/User/create_subsiDiary.dart';
import 'package:dashboard_new1/view/administration/User/subsi_diaries_screen.dart';
import 'package:dashboard_new1/view/authorization/authorization_Screen.dart';
import 'package:dashboard_new1/view/booking_view/trash_booking.dart';
import 'package:dashboard_new1/view/main_appbar/slash_shortcut_key_alert.dart';
import 'package:dashboard_new1/view/setting/booking_clearing_utility_screen.dart';
import 'package:dashboard_new1/view/setting/chat_with_driver_passenger.dart';
import 'package:dashboard_new1/view/setting/document_number_screen.dart';
import 'package:dashboard_new1/view/setting/company_information_screen.dart';
import 'package:dashboard_new1/view/setting/voipSetting_Screen.dart';
import 'package:dashboard_new1/view/vehicles_view/create_vehicle_types.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../alert/back_slash_alert.dart';
import '../../alert/cli_extention_alert.dart';
import '../../component/color.dart';
import '../../component/networks/api.dart';
import '../../tabbarview.dart';
import '../accounts/Invoice/list_customer_invoices.dart';
import '../accounts/account/account_view.dart';
import '../accounts/account/create_escopt.dart';
import '../accounts/controller/account_controller.dart';
import '../accounts/list_of_accountScreen.dart';
import '../administration/User/create_userScreen.dart';
import '../administration/User/user_listScreen.dart';
import '../administration/controller/administration_controller.dart';
import '../administration/model/user_model.dart';
import '../auth/Controller/auth_controller.dart';
import '../booking_view/app_booking.dart';
import '../booking_view/complete_bookingview.dart';
import '../booking_view/create_new_booking_form.dart';
import '../booking_view/multi_booking.dart';
import '../booking_view/pending_booking.dart';
import '../booking_view/pre_booking.dart';
import '../booking_view/web_booking.dart';
import '../customer/add_customerScreen.dart';
import '../customer/complaints.dart';
import '../customer/controller/customer_controller.dart';
import '../customer/create_complaint.dart';
import '../customer/create_lost_propertyScreen.dart';
import '../customer/customers_screen.dart';
import '../customer/lost_property.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';
import 'package:nested_menu_bar/nested_menu_bar.dart';
import '../dashboard_view/dashboard/defult_dashboard_view.dart';
import '../drivers_view/driver/bulk_driver_commission/bulk_driver_commission.dart';
import '../drivers_view/driver/bulk_driver_commission/bulk_driver_rent.dart';
import '../drivers_view/driver/create_driver_form/driver_form.dart';
import '../drivers_view/driver/driver_app_features/driver_app_feature_screen.dart';
import '../drivers_view/driver/driver_commission/create_driver_rent.dart';
import '../drivers_view/driver/driver_commission/list_driver_commission.dart';
import '../drivers_view/driver/driver_commission/list_driver_rent.dart';
import '../drivers_view/driver/driver_commission/create_driver_commission.dart';
import '../drivers_view/driver/driver_commission_pay/driver_commission_pay.dart';
import '../drivers_view/driver/driver_rent_pay/driver_rent_pay.dart';
import '../drivers_view/driver/driver_sin_bin_setting/driver_sin_bin_setting.dart';
import '../drivers_view/driver/drivers_list/driver_list_screen.dart';
import '../drivers_view/driver/login_drivers/login_drivers_screen.dart';
import '../fare_view/airport_charges/airport_charges.dart';
import '../fare_view/fare_by_vehicle/fare_by_vehicle.dart';
import '../fare_view/fare_charges/fare_charges.dart';
import '../fare_view/fare_configuration_day/fare_configuration_day.dart';
import '../fare_view/fare_increment/fare_increment.dart';
import '../fare_view/fare_meter/fare_meter.dart';
import '../fare_view/plot_fare/create_fixed_fare_setting.dart';
import '../fare_view/plot_fare/plot_fare.dart';
import '../locations_view/controller/locations_controller.dart';
import '../locations_view/location/localization_screen.dart';
import '../locations_view/location/location_formScreen.dart';
import '../locations_view/location/location_listScreen.dart';
import '../locations_view/location/zone_listScreen.dart';
import '../locations_view/location/zone_screen.dart';
import 'dart:html' as html;
import '../reports/driver_booking_view/all_booking_view.dart';
import '../reports/driver_booking_view/report_transfered_booking.dart';
import '../reports/driver_reports_view/driver_login_screen.dart';
import '../reports/driver_reports_view/driver_logs_screen.dart';
import '../reports/driver_reports_view/earning_and_info_screen/earning_and_info_screen.dart';
import '../reports/driver_reports_view/report_feedback.dart';
import '../reports/driver_reports_view/statistics_screen.dart';
import '../reports/employee_reports_view/activity_screen.dart';
import '../reports/income_report_view/company_income_screen.dart';
import '../reports/income_report_view/creidit_card_payments.dart';
import '../reports/income_report_view/income_screen.dart';
import '../reports/pco_view/pco_screen.dart';
import '../setting/call_recordings.dart';
import '../setting/company_configuration_view/company_configuration_view.dart';
import '../setting/email_tracking.dart';
import '../setting/location_type_shortcuts.dart';
import '../setting/payment_types_color.dart';
import '../setting/sms_tracking.dart';
import '../setting/template_settings.dart';
import '../setting/wallboard_screen.dart';
import '../vehicles_view/controller/controller.dart';
import '../vehicles_view/create_company_vehicle.dart';
import '../vehicles_view/list_vehicle_type.dart';
import '../vehicles_view/company_vehiclesScreen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final List<NestedMenuItem> hoverMenu;


  // AuthController ko yahan register karein taake error na aaye
  final AuthController authController = Get.isRegistered<AuthController>()
      ? Get.find<AuthController>()
      : Get.put(AuthController());

  /// Scrolls the shell body, which is the scroll view every page is hosted in
  /// — a page's own SingleChildScrollView sits inside this one, gets unbounded
  /// height, and so never scrolls on its own.
  final ScrollController _bodyScrollController = ScrollController();

  /// Pixels moved per arrow key press / repeat.
  static const double _arrowScrollStep = 60;

  /// How long after a tap / a traversal key a focus change still counts as the
  /// user's doing.
  static const Duration _userIntentWindow = Duration(milliseconds: 400);

  /// Where and when the user last pressed a pointer down anywhere in the shell.
  Offset? _lastPointerDownPosition;
  DateTime _lastPointerDownAt = DateTime.fromMillisecondsSinceEpoch(0);

  /// When the user last pressed a key that moves the focus (Tab / Enter).
  DateTime _lastTraversalKeyAt = DateTime.fromMillisecondsSinceEpoch(0);

  /// Whether the widget holding the primary focus got it because the user asked
  /// for it — tapped it, or moved into it from the keyboard — and not because it
  /// autofocused itself while the page was building.
  bool _focusIsUserDriven = false;

  /// The page [_focusIsUserDriven] was decided on. Switching pages voids the
  /// verdict: the new page autofocuses its own widgets, which is never the user
  /// reaching for a field.
  Object? _focusPage;

  @override
  void initState() {
    super.initState();
    authController.checkUserStatus();
    RawKeyboard.instance.addListener(_handleKey);
    FocusManager.instance.addListener(_handleFocusChanged);
    hoverMenu = _makeMenus(context);
    controller.inItStateOFController();
  }

  @override
  void dispose() {
    RawKeyboard.instance.removeListener(_handleKey);
    FocusManager.instance.removeListener(_handleFocusChanged);
    _bodyScrollController.dispose();
    super.dispose();
  }

  /// Records, every time the focus moves, whether the user is the one who moved
  /// it. Reading this back later is what keeps an `autofocus: true` widget from
  /// silently claiming the arrow keys.
  void _handleFocusChanged() {
    final now = DateTime.now();
    _focusPage = controller.currentPage.value;
    _focusIsUserDriven = _tapLandedOnFocusedWidget(now) ||
        now.difference(_lastTraversalKeyAt) < _userIntentWindow;
  }

  /// Whether the user's last tap landed on the widget that just took the focus.
  /// A tap anywhere else — a menu, a page chip, a button that moved the focus on
  /// its own — is not the user reaching for that widget.
  bool _tapLandedOnFocusedWidget(DateTime now) {
    final at = _lastPointerDownPosition;
    if (at == null || now.difference(_lastPointerDownAt) >= _userIntentWindow) {
      return false;
    }
    final renderObject =
        FocusManager.instance.primaryFocus?.context?.findRenderObject();
    if (renderObject is! RenderBox ||
        !renderObject.hasSize ||
        !renderObject.attached) {
      return false;
    }
    return renderObject.size.contains(renderObject.globalToLocal(at));
  }

  /// Typing counts as being in the focused field, even when the field
  /// autofocused itself and the user never tapped it.
  void _markFocusUserDriven() {
    _focusIsUserDriven = true;
    _focusPage = controller.currentPage.value;
  }

  /// Moves the body by [delta] pixels, clamped to the scroll extent.
  /// [animate] is off while a key repeats so held arrows scroll smoothly
  /// instead of restarting a 120ms animation on every repeat.
  void _scrollBody(double delta, {required bool animate}) {
    if (!_bodyScrollController.hasClients) return;
    final position = _bodyScrollController.position;
    final target = (position.pixels + delta)
        .clamp(position.minScrollExtent, position.maxScrollExtent);
    if (target == position.pixels) return;
    if (animate) {
      _bodyScrollController.animateTo(
        target,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
      );
    } else {
      _bodyScrollController.jumpTo(target);
    }
  }

  /// Pages the arrow keys may scroll — the BOOKINGS list screens, which are all
  /// a plain table in the shell's scroll view.
  ///
  /// Everything else is left alone on purpose: the dashboard table, the address
  /// suggestion lists and the keyboard dropdowns drive their own selection with
  /// the arrow keys, and this listener cannot see that they already handled the
  /// event.
  static const Set<Type> _arrowScrollPages = {
    CompleteBookingsScreen,
    PendingBooking,
    PreBooking,
    WebBooking,
    AppBooking,
    MultiBooking,
    TrashBooking,
    CustomersScreen,
    LostProperty,
    ComplaintsView,
    LostPropertyScreen,
    CustomerFormScreen,
    CreateComplaint,
    FareConfigurationDay,
    CreateFixedFareSetting,
    PlotFare,
    FareByVehicle,
    AirportCharges,
    FareIncrement,
    FareMeter,
    FareCharges,
    DriverForm,
    DriverListScreen,
    LoginDriversScreen,
    ListDriverCommission,
    DriverCommission,
    BulkDriverCommission,
    DriverCommissionPay,
    CreateDriverRent,
    DriverRent,
    BulkDriverRent,
    DriverRentPay,
    DriverAppFeatureScreen,
    DriverSinBinSetting,
    AccountView,
    ListOfAccountScreen,
    CreateEscortScreen,
    ESCORTScreen,
    CreateCustomerInvoice,
    InvoiceList,
    CreateAccountInvoiceScreen,
    ListOfAccountInvoiceScreen,
    LocationForm,
    LocationListScreen,
    ZoneScreen,
    ZoneListScreen,
    LocalizationScreen,
    CreateVehicleTypes,
    ListVehicleType,
    CreateCompanyVehicle,
    CompanyVehiclesScreen,
    CreateUserScreen,
    UserListscreen,
    CreateSubsiDiary,
    SubsiDiariesScreen,
    AuthorizationScreen,
    DriverLoginScreen,
    DriverLogsScreen,
    EarningAndInfoScreen,
    ReportFeedback,
    StatisticsScreen,
    AllBookingView,
    ReportTransferedBooking,
    ActivityScreen,
    IncomeScreen,
    CompanyIncomeScreen,
    CreiditCardPayments,
    PcoScreen,
    ComapanyInformationScreen,
    CompanyConfigurationView,
    PaymentTypeDialog,
    DocumentNumberScreen,
    TemplateSettings,
    BookingClearingUtilityScreen,
    LocationTypeShortcuts,
    VoipSettingsScreen,
    SmsSettingsScreen,
    EmailTrackingScreen,
    CallRecordingScreen,
    BackSlashAlert,
    ChatWithDriverAndPassenger,
    WallboardScreen,


  };

  /// Whether arrow up / down should scroll the page right now.
  bool get _arrowKeysScrollBody {
    if (!_arrowScrollPages.contains(controller.currentPage.value.runtimeType)) {
      return false;
    }

    if (shortCutKeyValue.value == "alert") {
      return false;
    }

    // Koi bhi field focused ho to scroll nahi karna — woh field khud arrow
    // keys use kar raha hota hai.
    return !_isFieldFocused;
  }

  /// Whether the user is currently inside a field — a text field, a keyboard
  /// dropdown, a checkbox, a date picker, a suggestion list, anything that took
  /// focus from its own onTap. Those widgets drive themselves with the arrow
  /// keys, so the shell must keep its hands off the scroll view until the field
  /// is unfocused again.
  bool get _isFieldFocused {
    // `KeyboardDatePicker.isAnyDatePickerFocused` ki zaroorat nahi rahi: woh
    // picker khud `autofocus: true` hai aur 40+ screens par baitha hai, to us
    // flag se un tamam pages ka scroll band ho jata tha. Picker ka apna focus
    // node primary focus hota hai, so neeche wali general jaanch use bhi cover
    // kar leti hai.
    final focus = FocusManager.instance.primaryFocus;
    // A scope node means the focus never landed on a widget — nothing to guard.
    if (focus == null || focus is FocusScopeNode) return false;

    final focusContext = focus.context;
    if (focusContext == null) return false;

    // A text field is a field whatever it measures. Everything else has to be
    // field-sized first: plenty of pages wrap their whole body in
    // `RawKeyboardListener(autofocus: true, focusNode: FocusNode())` only to
    // catch shortcuts (DriverListScreen, LocationListScreen, ListOfAccountScreen,
    // …) and that node holds the primary focus for as long as the page is open.
    // Such a catcher wraps the page, so it is at least as tall as the visible
    // area, which no real field ever is.
    if (focusContext.findAncestorStateOfType<EditableTextState>() == null) {
      final renderObject = focusContext.findRenderObject();
      if (renderObject is! RenderBox || !renderObject.hasSize) return false;
      if (renderObject.size.height >= _viewportHeight) return false;
    }

    // A field only owns the arrow keys once the user is actually in it — tapped
    // it, tabbed into it, or is typing in it. Half of these widgets autofocus
    // themselves as the page builds (calender.dart, radio_button_widget.dart,
    // KeyboardDatePicker, the search boxes, the suggestion overlays), and a
    // widget grabbing the focus by itself must not cost the user page scrolling.
    return _focusIsUserDriven &&
        identical(_focusPage, controller.currentPage.value);
  }

  /// Height of the shell's visible area — the yardstick a focused node is
  /// measured against in [_isFieldFocused].
  double get _viewportHeight => _bodyScrollController.hasClients
      ? _bodyScrollController.position.viewportDimension
      : MediaQuery.of(context).size.height;

  void message(context, String text) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final snackBar = SnackBar(
      content: Text(text),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // List<SelectedDropdown> selectedMenuItems = [];

  DashboardController controller = Get.isRegistered<DashboardController>()
      ? Get.find<DashboardController>()
      : Get.put(DashboardController());

  void _handleKey(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      print(event);

      // Tab aur Enter se user khud focus aage barhata hai — jo field un se
      // focus hoti hai woh arrow keys ki haqdaar hai.
      if (event.logicalKey == LogicalKeyboardKey.tab ||
          event.logicalKey == LogicalKeyboardKey.enter ||
          event.logicalKey == LogicalKeyboardKey.numpadEnter) {
        _lastTraversalKeyAt = DateTime.now();
      }

      // Field mein type karna bhi user ka usi field mein hona hai.
      final character = event.character;
      if ((character != null && character.isNotEmpty) ||
          event.logicalKey == LogicalKeyboardKey.backspace ||
          event.logicalKey == LogicalKeyboardKey.delete) {
        _markFocusUserDriven();
      }

      if (event.logicalKey == LogicalKeyboardKey.arrowDown ||
          event.logicalKey == LogicalKeyboardKey.arrowUp) {
        if (_arrowKeysScrollBody) {
          _scrollBody(
            event.logicalKey == LogicalKeyboardKey.arrowDown
                ? _arrowScrollStep
                : -_arrowScrollStep,
            animate: !event.repeat,
          );
        }
        return;
      }

      if (event.logicalKey.keyLabel == "F#") {
        shortCutKeyValue.value = "alert";
      }
      if (event.logicalKey.keyLabel == "/") {
        // DashboardSlashAlert.show();
      }
      if (event.logicalKey.keyLabel == "Escape") {
        if (shortCutKeyValue.value == "alert") {
          shortCutKeyValue.value = "shortCutKey";
        } else if (_isFieldFocused) {
          // Escape se field chhoot jati hai, taake arrow keys wapas page ko
          // scroll karne lagen.
          FocusManager.instance.primaryFocus?.unfocus();
        }
      } else if (event.logicalKey.keyLabel == "F2") {
        final newTabUrl = Uri.base.origin + /*'/#' +*/ Routes.createBooking;
        html.window.open(newTabUrl, '_blank');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double itemHeight = 35; // approx height of one chip
    double runSpacing = 6;

    return PopScope(
      canPop: false,
      // Har tap yahan note hota hai, taake baad mein pata chale k focus user ne
      // di hai ya widget ne khud le li. See [_handleFocusChanged].
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (event) {
          _lastPointerDownPosition = event.position;
          _lastPointerDownAt = DateTime.now();
        },
        child: Scaffold(
        backgroundColor: DynamicColors.whiteClr,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight * 2.3),
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              NestedMenuBar(
                menuBarPadding: 0.0,
                menus: hoverMenu,
                popUpMenuItemBorderRadius: 8,
                menuBarDecoration: BoxDecoration(
                  color: DynamicColors.primaryClr,
                ),
                menuBarItemHoverColor: Colors.white,
                menuBarItemColor: Colors.white,
                popUpDecoration: BoxDecoration(
                  color: Colors.white,
                  // border: Border.all(color: DynamicColors.gryClr,width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                popUpPadding: 3,
                popUpMenuItemHoverForegroundColor: Colors.white,
                popUpMenuItemForegroundColor: Colors.black,
                popUpMenuItemBackgroundColor: Colors.white,
                popUpMenuItemHoverBackgroundColor: Colors.black,
              ),
              // Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      ExtensionAlert.show();
                    },
                    child: Icon(
                      Icons.headset_mic_outlined,
                      size: 24,
                      color: DynamicColors.whiteClr,
                    ),
                  ),
                  SizedBox(
                    width: 9,
                  ),
                  Icon(
                    Icons.notifications,
                    size: 24,
                    color: DynamicColors.whiteClr,
                  ),
                  SizedBox(
                    width: 9,
                  ),
                  GestureDetector(
                  onTap: () async{
                    await authController.logout();
                    controller.selectedMenuItems.clear();
                    controller.currentPage.value = ByDefaultDashboard();
                  },
                    child: Icon(
                      Icons.power_settings_new,
                      size: 24,
                      color: DynamicColors.whiteClr,
                    ),
                  ),
                  SizedBox(
                    width: 9,
                  ),
                ],
              )
            ],
          ),
        ),
        body: GetBuilder<DashboardController>(builder: (controller) {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SingleChildScrollView(
                controller: _bodyScrollController,
                child: Column(
                  children: [
                    Container(
                      width: Get.width,
                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                      color: Colors.grey.shade300,
                      child: Wrap(spacing: 6, runSpacing: 6, children: [
                        GestureDetector(
                          onTap: () {
                            int index = controller.selectedMenuItems.indexWhere(
                                (element) => element.selectedItem == true);
                            if (index != -1) {
                              controller.selectedMenuItems[index].selectedItem =
                                  false;
                            }
                            controller.currentPage.value = ByDefaultDashboard();
                            controller.update();
                          },
                          child: Container(
                            padding:
                                EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: DynamicColors.primaryClr,
                              border: Border.all(color: DynamicColors.textClr),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              Icons.home,
                              color: DynamicColors.whiteClr,
                            ),
                          ),
                        ),
                        ...controller.selectedMenuItems.map((item) {
                          return GestureDetector(
                            onTap: () {
                              int index = controller.selectedMenuItems.indexWhere(
                                  (element) => element.selectedItem == true);
                              if (index != -1) {
                                controller.selectedMenuItems[index].selectedItem =
                                    false;
                              }
                              item.selectedItem = true;
                              if (item.category != null) {
                                controller.currentPage.value = item.category;
                              }
                              controller.update();
                            },
                            child: Chip(
                              label: Text(
                                item.title!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: DynamicColors.textClr,
                                ),
                              ),
                              backgroundColor: item.selectedItem == true
                                  ? DynamicColors.whiteClr
                                  : DynamicColors.gryClr,
                              deleteIcon: Icon(
                                Icons.close,
                                color: DynamicColors.textClr,
                                size: 18,
                              ),
                              onDeleted: () {
                                if (item.selectedItem == true &&
                                    controller.selectedMenuItems.length > 1) {
                                  int index = controller.selectedMenuItems
                                      .indexWhere(
                                          (item) => item.selectedItem == true);
                                  if (index != -1) {
                                    controller.selectedMenuItems[index]
                                        .selectedItem = false;
                                  }
                                  controller.selectedMenuItems.remove(item);
                                  controller.selectedMenuItems.last.selectedItem =
                                      true;
                                  controller.currentPage.value =
                                      controller.selectedMenuItems.last.category;
                                } else {
                                  controller.selectedMenuItems.remove(item);
                                  controller.currentPage.value =
                                      ByDefaultDashboard();
                                }
      
                                controller.update(); // if using GetX
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          );
                        }).toList(),
                      ]),
                    ),
                    // controller.currentPage.value ?? CreateEscortScreen(),
                    Obx(() =>
                        controller.currentPage.value ?? ByDefaultDashboard())
                  ],
                ),
              ),
            ],
          );
        }),

        bottomNavigationBar: GetBuilder<AuthController>(
          builder: (auth) {
            return Container(
              width: double.infinity, // Kisi bhi screen par full width le ga
              height: 60,
              color: DynamicColors.whiteClr,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Content ko corners me push karega
                children: [

                  //  Username & Shortcuts
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Username
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F2EF),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFC4D9D4), width: 1),
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 5,
                              backgroundColor: Color(0xff424899),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              Employee.selectedEmployee?.username?.toUpperCase() ?? "GUEST",
                              style: mozillaTextRegularText(
                                  color: const Color(0xFF4A4A4A),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Shortcuts
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 3.0),
                      //   child: SizedBox(
                      //     height: kToolbarHeight,
                      //     child: Row(
                      //       children: [
                      //         Text(
                      //           "PRESS",
                      //           style: mozillaTextRegularText(color: DynamicColors.textClr, fontSize: 14),
                      //         ),
                      //         Padding(
                      //           padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      //           child: Container(
                      //             padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      //             decoration: BoxDecoration(
                      //                 color: DynamicColors.textClr,
                      //                 borderRadius: BorderRadius.circular(4)),
                      //             child: Text(
                      //               "/",
                      //               style: mozillaTextRegularText(color: DynamicColors.whiteClr, fontSize: 14),
                      //             ),
                      //           ),
                      //         ),
                      //         Text(
                      //           "SHORTCUTS",
                      //           style: mozillaTextRegularText(color: DynamicColors.textClr, fontSize: 14),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  const Spacer(),
                  // ================= CENTER: Nexus Text =================
                  Text(
                    "NEXUS © 2026",
                    style: mozillaTextRegularText(color: Colors.grey, fontSize: 12),
                  ),
                  const Spacer(),

                  //  Date, Time & Extension
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Date
                      Text(
                        DateFormat("EEE, MMM dd yyyy").format(DateTime.now()).toUpperCase(),
                        style: mozillaTextRegularText(
                            color: const Color(0xFF4A4A4A),
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 12),
                      const Text("|", style: TextStyle(color: Colors.grey, fontSize: 16)),
                      const SizedBox(width: 12),
                      // Time
                      Text(
                        DateFormat("hh:mm:ss a").format(DateTime.now()),
                        style: mozillaTextRegularText(
                            color: const Color(0xFF4A4A4A),
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 16), // Thoda gap extension se pehle
                      // Extension Number
                      GestureDetector(
                        onTap: () {
                          ExtensionAlert.show();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const Text(
                                "# ",
                                style: TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                              Text(
                                Employee.selectedEmployee?.extensionNumber ?? "---",
                                style: mozillaTextRegularText(
                                    color: const Color(0xff424899),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            );
          },
        ),
        ),
      ),
    );
  }

  List<NestedMenuItem> _makeMenus(BuildContext context) {
    return [
      NestedMenuItem(
        title: "NEXUS",
      ),
      /* NestedMenuItem(title: "App Development",onTap: () => message(context, "App Development"),
          children: [
            NestedMenuItem(title: "Mobile App Development",
              onTap: () => message(context, "Mobile App Development"),
              children: [
                NestedMenuItem(title: "Native App Development",onTap: () => message(context, "Native App Development"),
                    children: [
                      NestedMenuItem(title: "Android App Development",onTap: () => message(context, "Android App Development"),),
                      NestedMenuItem(title: "iOS App Development",onTap: () => message(context, "iOS App Development"),),]),
                NestedMenuItem(title: "Cross Platform Development",onTap: () => message(context, "Cross Platform Development"),
                  children: [
                    NestedMenuItem(title: "Flutter App Development",onTap: () => message(context, "Flutter App Development"),),
                    NestedMenuItem(title: "React Native App Development",onTap: () => message(context, "React Native App Development"),),],),],),
            NestedMenuItem(title: "Web App Development",onTap: () => message(context, "Web App Development"),),
          ]
      ),*/
      NestedMenuItem(title: "BOOKINGS", children: [
        NestedMenuItem(
          title: "CREATE BOOKINGS",
          onTap: () {
           if(controller.selectedMenuItems.length <20){
            List permissions = [];
            permissions = Api().sp.read('all_permissions') ?? [];
            // setState(() {
            //   if(permissions.contains('create_booking_route')){
            //     final newTabUrl = Uri.base.origin + Routes.createBooking;
            //     html.window.open(newTabUrl, '_blank');
            //   }
            // });
           }else{
             BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
           }

            Get.to(CreateNewBookingForm());
            // Get.toNamed(Routes.createBooking);
          },
        ),
        NestedMenuItem(
          title: "COMPLETE BOOKINGS",
          onTap: () {
            if(controller.selectedMenuItems.length <20){
            setState(() {
              controller.currentPage.value = CompleteBookingsScreen();
              controller.menuBarRefresh(
                  title: "COMPLETE BOOKINGS",
                  pageName: CompleteBookingsScreen());
            });
           }else{
             BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
           }
          },
        ),
        NestedMenuItem(
          title: "PENDING BOOKINGS",
          onTap: () {
            if(controller.selectedMenuItems.length <20){
            setState(() {
              controller.currentPage.value = PendingBooking();
              controller.menuBarRefresh(
                  title: "PENDING BOOKINGS", pageName: PendingBooking());
            });
            }else{
              BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
            }
          },
        ),
        NestedMenuItem(
          title: "PRE BOOKINGS",
          onTap: () {
            if(controller.selectedMenuItems.length <20){
            setState(() {
              controller.currentPage.value = PreBooking();
              controller.menuBarRefresh(
                  title: "PRE BOOKINGS", pageName: PreBooking());
            });
            }else{
              BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
            }
          },
        ),
        NestedMenuItem(
          title: "WEB BOOKINGS",
          onTap: () {
            if(controller.selectedMenuItems.length <20){
            setState(() {
              controller.currentPage.value = WebBooking();
              controller.menuBarRefresh(
                  title: "WEB BOOKINGS", pageName: WebBooking());
            });
            }else{
              BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
            }
          },
        ),
        NestedMenuItem(
          title: "APP BOOKINGS",
          onTap: () {
            if(controller.selectedMenuItems.length <20){
            setState(() {
              controller.currentPage.value = AppBooking();
              controller.menuBarRefresh(
                  title: "APP BOOKINGS", pageName: AppBooking());
            });
            }else{
              BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
            }
          },
        ),
        NestedMenuItem(
          title: "MULTI BOOKINGS",
          onTap: () {
            if(controller.selectedMenuItems.length <20){
            setState(() {
              controller.currentPage.value = MultiBooking();
              controller.menuBarRefresh(
                  title: "MULTI BOOKINGS", pageName: MultiBooking());
            });
            }else{
              BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
            }
          },
        ),
        NestedMenuItem(
          title: "TRASH BOOKINGS",
          onTap: () {
            if(controller.selectedMenuItems.length <20){
            List permissions = [];
            permissions = Api().sp.read('all_permissions') ?? [];
            setState(() {
              if(permissions.contains('read_trash_booking')){
                controller.currentPage.value = TrashBooking();
                controller.menuBarRefresh(
                    title: "TRASH BOOKINGS", pageName: TrashBooking());
              }
            });
            }else{
              BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
            }
          },
        ),
      ]),
      NestedMenuItem(title: "CUSTOMERS", children: [
        NestedMenuItem(
          title: "ADD CUSTOMER",
          onTap: () {

            if(controller.selectedMenuItems.length <20){
            List permissions = [];
            permissions = Api().sp.read('all_permissions') ?? [];
            setState(() {
              if(permissions.contains('create_customer')){
                if (Get.isRegistered<CustomerController>()) {
                  Get.find<CustomerController>().clearForm();
                }
                controller.currentPage.value = CustomerFormScreen();
                controller.menuBarRefresh(
                    title: "ADD CUSTOMER", pageName: CustomerFormScreen());
              }
            });
            }else{
              BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
            }
          },
        ),
        NestedMenuItem(
          title: "CUSTOMERS",
          onTap: () {
            if(controller.selectedMenuItems.length <20){
            List permissions = [];
            permissions = Api().sp.read('all_permissions') ?? [];
            setState(() {
              if(permissions.contains('read_customer')){
                controller.currentPage.value = CustomersScreen();
                controller.menuBarRefresh(
                    title: "CUSTOMERS", pageName: CustomersScreen());
              }
            });
            }else{
              BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
            }
          },
        ),
        NestedMenuItem(
          title: "CREATE LOST PROPERTY",
          onTap: () {

            if(controller.selectedMenuItems.length <20){
            List permissions = [];
            permissions = Api().sp.read('all_permissions') ?? [];
            setState(() {
              if(permissions.contains('create_lost_property')){
                if (Get.isRegistered<CustomerController>()) {
                  Get.find<CustomerController>().refreshFields();
                }
                controller.currentPage.value = LostPropertyScreen();
                controller.menuBarRefresh(
                    title: "CREATE LOST PROPERTY",
                    pageName: LostPropertyScreen());
              }
            });
            }else{
              BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
            }
          },
        ),
        NestedMenuItem(
          title: "LOST PROPERTY",
          onTap: () {

            if(controller.selectedMenuItems.length <20){
            List permissions = [];
            permissions = Api().sp.read('all_permissions') ?? [];
            setState(() {
              if(permissions.contains('read_lost_property')){
                controller.currentPage.value = LostProperty();
                controller.menuBarRefresh(
                    title: "LOST PROPERTY", pageName: LostProperty());
              }
            });
            }else{
              BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
            }
          },
        ),
        NestedMenuItem(
          title: "CREATE COMPLAINT",
          onTap: () {

            if(controller.selectedMenuItems.length <20){
            List permissions = [];
            permissions = Api().sp.read('all_permissions') ?? [];
            setState(() {
              if(permissions.contains('create_complaint')){
                if (Get.isRegistered<CustomerController>()) {
                  Get.find<CustomerController>().clearComplaintForm();
                }
                controller.currentPage.value = CreateComplaint();
                controller.menuBarRefresh(
                    title: "CREATE COMPLAINT", pageName: CreateComplaint());
              }
            });
            }else{
              BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
            }
          },
        ),
        NestedMenuItem(
          title: "COMPLAINTS",
          onTap: () {
            if(controller.selectedMenuItems.length <20){
            List permissions = [];
            permissions = Api().sp.read('all_permissions') ?? [];
            setState(() {
              if(permissions.contains('read_complaint')){
                controller.currentPage.value = ComplaintsView();
                controller.menuBarRefresh(
                    title: "COMPLAINTS", pageName: ComplaintsView());
              }
            });
            }else{
              BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
            }
          },
        ),
      ]),
      NestedMenuItem(title: "FARES", children: [
        NestedMenuItem(
            title: "CREATE FARE SETTINGS",
            onTap: () {
              if(controller.selectedMenuItems.length <20){
              setState(() {
                controller.currentPage.value = FareConfigurationDay();
                controller.menuBarRefresh(
                    title: "CREATE FARE SETTINGS",
                    pageName: FareConfigurationDay());
              });
              }else{
                BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
              }
            }),
        NestedMenuItem(
            title: "CREATE FIXED FARE SETTINGS",
            onTap: () {
              if(controller.selectedMenuItems.length <20){
              setState(() {
                controller.currentPage.value = CreateFixedFareSetting();
                controller.menuBarRefresh(
                    title: "CREATE FIXED FARE SETTINGS",
                    pageName: CreateFixedFareSetting());
              });
              }else{
                BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
              }
            }),
        NestedMenuItem(
          title: "CREATE PLOT FARE",
          onTap: () {
            if(controller.selectedMenuItems.length <20){
            setState(() {
              controller.currentPage.value = PlotFare();
              controller.menuBarRefresh(
                  title: "CREATE PLOT FARE", pageName: PlotFare());
            });
            }else{
              BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
            }
          },
        ),
        NestedMenuItem(
            title: "CREATE FARE BY VEHICLE SETTINGS",
            onTap: () {
              if(controller.selectedMenuItems.length <20){
              setState(() {
                controller.currentPage.value = FareByVehicle();
                controller.menuBarRefresh(
                    title: "CREATE FARE BY VEHICLE SETTINGS",
                    pageName: FareByVehicle());
              });
              }else{
                BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
              }
            }),
        NestedMenuItem(
          title: "AIRPORT CHARGES",
          onTap: () {
            if(controller.selectedMenuItems.length <20){
            setState(() {
              controller.currentPage.value = AirportCharges();
              controller.menuBarRefresh(
                  title: "AIRPORT CHARGES", pageName: AirportCharges());
            });
            }else{
              BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
            }
          },
        ),
        NestedMenuItem(
          title: "FARE INCREMENT",
          onTap: () {
            if(controller.selectedMenuItems.length <20){
            setState(() {
              controller.currentPage.value = FareIncrement();
              controller.menuBarRefresh(
                  title: "FARE INCREMENT", pageName: FareIncrement());
            });
            }else{
              BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
            }
          },
        ),
        NestedMenuItem(
          title: "SUR CHARGES",
          onTap: () {
            if(controller.selectedMenuItems.length <20){
            setState(() {
              controller.currentPage.value = FareCharges();
              controller.menuBarRefresh(
                  title: "SUR CHARGES", pageName: FareCharges());
            });
            }else{
              BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
            }
          },
        ),
        NestedMenuItem(
          title: "FARE METER",
          onTap: () {
            if(controller.selectedMenuItems.length <20){
            setState(() {
              controller.currentPage.value = FareMeter();
              controller.menuBarRefresh(
                  title: "FARE METER", pageName: FareMeter());
            });
            }else{
              BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
            }
          },
        ),
      ]),
      NestedMenuItem(title: "LOCATIONS", children: [
        NestedMenuItem(
          title: "CREATE LOCATIONS",
          onTap: () {
            if(controller.selectedMenuItems.length <20){
            List permissions = [];
            permissions = Api().sp.read('all_permissions') ?? [];
            setState(() {
              if(permissions.contains('create_location')){
                if (Get.isRegistered<LocationController>()) {
                  Get.find<LocationController>().clearLocationForm();
                }
                controller.currentPage.value = LocationForm();
                controller.menuBarRefresh(
                    title: "CREATE LOCATIONS", pageName: LocationForm());
              }
            });
            }else{
              BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
            }
          },
        ),
        NestedMenuItem(
          title: "LIST OF LOCATIONS",
          onTap: () {
            if(controller.selectedMenuItems.length <20){
            List permissions = [];
            permissions = Api().sp.read('all_permissions') ?? [];
            setState(() {
              if(permissions.contains('read_location')){
                controller.currentPage.value = LocationListScreen();
                controller.menuBarRefresh(
                    title: "LIST OF LOCATIONS", pageName: LocationListScreen());
              }
            });
            }else{
              BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
            }
          },
        ),
        NestedMenuItem(
          title: "CREATE ZONE",
          onTap: () {
            if(controller.selectedMenuItems.length <20){
            List permissions = [];
            permissions = Api().sp.read('all_permissions') ?? [];
            setState(() {
              if(permissions.contains('create_zone')){
                controller.currentPage.value = ZoneScreen();
                controller.menuBarRefresh(
                    title: "CREATE ZONE", pageName: ZoneScreen());
              }
            });
            }else{
              BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
            }
          },
        ),
        NestedMenuItem(
          title: "LIST OF ZONES",
          onTap: () {
            if(controller.selectedMenuItems.length <20){
            List permissions = [];
            permissions = Api().sp.read('all_permissions') ?? [];
            setState(() {
              if(permissions.contains('read_zone')){
                controller.currentPage.value = ZoneListScreen();
              controller.menuBarRefresh(
                  title: "LIST OF ZONES", pageName: ZoneListScreen());
              }
            });
            }else{
              BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
            }
          },
        ),
        NestedMenuItem(
          title: "LOCALIZATION",
          onTap: () {
            if(controller.selectedMenuItems.length <20){
            setState(() {
              controller.currentPage.value = LocalizationScreen();
              controller.menuBarRefresh(
                  title: "LOCALIZATION", pageName: LocalizationScreen());
            });
            }else{
              BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
            }
          },
        ),
        /*      NestedMenuItem(
          title: "PLOTTING",
          onTap: () {
            setState(() {
              controller.currentPage.value = ManagePostcodes();
              controller.menuBarRefresh(title: "PLOTTING", pageName: ManagePostcodes());
            });
          },
        ),*/
      ]),
      NestedMenuItem(title: "DRIVERS", children: [
        NestedMenuItem(
          title: "DRIVER",
          /*onTap: () {
              setState(() {
                controller.currentPage.value = CreateDriverRent();
              });
            },*/
          children: [
            NestedMenuItem(
              title: "ADD DRIVER",
              onTap: () {

                if(controller.selectedMenuItems.length <20){
                List permissions = [];
                permissions = Api().sp.read('all_permissions') ?? [];
                setState(() {
                  if(permissions.contains('create_driver')){
                    controller.currentPage.value = DriverForm();
                    controller.menuBarRefresh(
                        title: "ADD DRIVER", pageName: DriverForm());
                  }
                });
                }else{
                  BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
                }
              },
            ),
            NestedMenuItem(
              title: "DRIVERS",
              onTap: () {
                if(controller.selectedMenuItems.length <20){
                List permissions = [];
                permissions = Api().sp.read('all_permissions') ?? [];
                setState(() {
                  if(permissions.contains('read_driver')){
                    controller.currentPage.value = DriverListScreen();
                    controller.menuBarRefresh(
                        title: "DRIVERS", pageName: DriverListScreen());
                  }
                });
                }else{
                  BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
                }
              },
            ),
            NestedMenuItem(
              title: "LIST OF LOGGED IN/OUT DRIVERS",
              onTap: () {
               if(controller.selectedMenuItems.length <20){
                setState(() {
                  controller.currentPage.value = LoginDriversScreen();
                  controller.menuBarRefresh(
                      title: "LIST OF LOGGED IN/OUT DRIVERS",
                      pageName: LoginDriversScreen());
                });
               }else{
                 BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
               }
              },
            ),
          ],
        ),
        NestedMenuItem(
          title: "DRIVER COMMISSION",
          children: [
            NestedMenuItem(
              title: "CREATE DRIVER COMMISSION",
              onTap: () {
                if(controller.selectedMenuItems.length <20){
                List permissions = [];
                permissions = Api().sp.read('all_permissions') ?? [];
                setState(() {
                  if(permissions.contains('create_driver_commission')){
                    controller.currentPage.value = ListDriverCommission();
                    controller.menuBarRefresh(
                        title: "CREATE DRIVER COMMISSION",
                        pageName: ListDriverCommission());
                  }
                });
                }else{
                  BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
                }
              },
            ),
            NestedMenuItem(
              title: "DRIVER COMMISSIONS",
              onTap: () {

               if(controller.selectedMenuItems.length <20){
                List permissions = [];
                permissions = Api().sp.read('all_permissions') ?? [];
                setState(() {
                  if(permissions.contains('read_driver_commission')){
                    controller.currentPage.value = DriverCommission();
                    controller.menuBarRefresh(
                        title: "DRIVER COMMISSIONS",
                        pageName: DriverCommission());
                  }
                });
               }else{
                 BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
               }
              },
            ),
            NestedMenuItem(
              title: "BULK DRIVER COMMISSION",
              onTap: () {
               if(controller.selectedMenuItems.length <20){
                setState(() {
                  controller.currentPage.value = BulkDriverCommission();
                  controller.menuBarRefresh(
                      title: "BULK DRIVER COMMISSION",
                      pageName: BulkDriverCommission());
                });
               }else{
                 BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
               }
              },
            ),
            NestedMenuItem(
              title: "DRIVER COMMISSION PAY",
              onTap: () {
               if(controller.selectedMenuItems.length <20){
                setState(() {
                  controller.currentPage.value = DriverCommissionPay();
                  controller.menuBarRefresh(
                      title: "DRIVER COMMISSION PAY",
                      pageName: DriverCommissionPay());
                });
               }else{
                 BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
               }
              },
            ),
          ],
        ),
        NestedMenuItem(
          title: "DRIVER RENT",
          children: [
            NestedMenuItem(
              title: "CREATE DRIVER RENT",
              onTap: () {
               if(controller.selectedMenuItems.length <20){
                setState(() {
                  controller.currentPage.value = CreateDriverRent();
                  controller.menuBarRefresh(
                      title: "CREATE DRIVER RENT",
                      pageName: CreateDriverRent());
                });
               }else{
                 BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
               }
              },
            ),
            NestedMenuItem(
              title: "DRIVER RENT",
              onTap: () {
                if(controller.selectedMenuItems.length <20){
                setState(() {
                  controller.currentPage.value = DriverRent();
                  controller.menuBarRefresh(
                      title: "DRIVER RENT", pageName: DriverRent());
                });
                }else{
                  BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
                }
              },
            ),
            NestedMenuItem(
              title: "BULK DRIVER RENT",
              onTap: () {
               if(controller.selectedMenuItems.length <20){
                setState(() {
                  controller.currentPage.value = BulkDriverRent();
                  controller.menuBarRefresh(
                      title: "BULK DRIVER RENT", pageName: BulkDriverRent());
                });
               }else{
                 BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
               }
              },
            ),
            NestedMenuItem(
              title: "DRIVER RENT PAY",
              onTap: () {
                if(controller.selectedMenuItems.length <20){
                setState(() {
                  controller.currentPage.value = DriverRentPay();
                  controller.menuBarRefresh(
                      title: "DRIVER RENT PAY", pageName: DriverRentPay());
                });
                }else{
                  BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
                }
              },
            ),
          ],
        ),
        NestedMenuItem(
            title: "DRIVER APP FEATURES",
            onTap: () {
              if(controller.selectedMenuItems.length <20){
              List permissions = [];
              permissions = Api().sp.read('all_permissions') ?? [];
              setState(() {
                if(permissions.contains('read_app_feature')){
                  controller.currentPage.value = DriverAppFeatureScreen();
                  controller.menuBarRefresh(
                      title: "DRIVER APP FEATURES",
                      pageName: DriverAppFeatureScreen());
                }
              });
              }else{
                BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
              }
            }),
        NestedMenuItem(
            title: "DRIVER SIN BIN SETTINGS",
            onTap: () {
              if(controller.selectedMenuItems.length <20){
              setState(() {
                controller.currentPage.value = DriverSinBinSetting();
                controller.menuBarRefresh(
                    title: "DRIVER SIN BIN SETTINGS",
                    pageName: DriverSinBinSetting());
              });
              }else{
                BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
              }
            }),
      ]),
      NestedMenuItem(title: "ACCOUNTS", children: [
        NestedMenuItem(
          title: "CREATE ACCOUNT",
          onTap: () {
            if(controller.selectedMenuItems.length <20){
            List permissions = [];
            permissions = Api().sp.read('all_permissions') ?? [];
            setState(() {
              if(permissions.contains('create_account')){
                if (Get.isRegistered<AccountController>()) {
                  Get.find<AccountController>().clearAccountForm();
                }
                controller.currentPage.value = AccountView();
                controller.menuBarRefresh(
                    title: "CREATE ACCOUNT", pageName: AccountView());
              }
            });
            }else{
              BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
            }
          },
        ),
        NestedMenuItem(
          title: "LIST OF ACCOUNTS",
          onTap: () {
            if(controller.selectedMenuItems.length <20){
            List permissions = [];
            permissions = Api().sp.read('all_permissions') ?? [];
            setState(() {
              if(permissions.contains('read_account')){
                controller.currentPage.value = ListOfAccountScreen();
                controller.menuBarRefresh(
                    title: "LIST OF ACCOUNTS", pageName: ListOfAccountScreen());
              }
            });
            }else{
              BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
            }
          },
        ),
        NestedMenuItem(
          title: "CREATE ESCORT",
          onTap: () {
            if(controller.selectedMenuItems.length <20){
            List permissions = [];
            permissions = Api().sp.read('all_permissions') ?? [];
            setState(() {
              if(permissions.contains('create_escort')){
                if (Get.isRegistered<AccountController>()) {
                  Get.find<AccountController>().clearEscortFields();
                }
                controller.currentPage.value = CreateEscortScreen();
                controller.menuBarRefresh(
                    title: "CREATE ESCORT", pageName: CreateEscortScreen());
              }
            });
            }else{
              BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
            }


            ///------------------------------------------------------------------------------------------------------------------
          },
        ),
        // CreateEscortScreen
        NestedMenuItem(
          title: "ESCORT LIST ",
          onTap: () {
            if(controller.selectedMenuItems.length <20){
            List permissions = [];
            permissions = Api().sp.read('all_permissions') ?? [];
            setState(() {
              if(permissions.contains('read_escort')){
                controller.currentPage.value = ESCORTScreen();
              controller.menuBarRefresh(
                  title: "ESCORT LIST", pageName: ESCORTScreen());
              }
            });
            }else{
              BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
            }
          },
        ),
        NestedMenuItem(
          title: "CREATE CUSTOMER INVOICE",
          onTap: () {
            if(controller.selectedMenuItems.length <20){
            List permissions = [];
            permissions = Api().sp.read('all_permissions') ?? [];
            setState(() {
              if(permissions.contains('read_customer_invoice')){
                controller.currentPage.value = CreateCustomerInvoice();
                controller.menuBarRefresh(
                    title: "CREATE CUSTOMER INVOICE",
                    pageName: CreateCustomerInvoice());
              }
            });
            }else{
              BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
            }
          },
        ),
        NestedMenuItem(
          title: "LIST OF CUSTOMER INVOICES",
          onTap: () {
            if(controller.selectedMenuItems.length <20){
            setState(() {
              controller.currentPage.value = InvoiceList();
              controller.menuBarRefresh(
                  title: "LIST OF CUSTOMER INVOICES", pageName: InvoiceList());
            });
            }else{
              BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
            }
          },
        ),
        NestedMenuItem(
          title: "CREATE ACCOUNT INVOICE",
          onTap: () {
            if(controller.selectedMenuItems.length <20){
            List permissions = [];
            permissions = Api().sp.read('all_permissions') ?? [];
            setState(() {
              if(permissions.contains('create_account_invoice')){
                controller.currentPage.value = CreateAccountInvoiceScreen();
                controller.menuBarRefresh(
                    title: "CREATE ACCOUNT INVOICE",
                    pageName: CreateAccountInvoiceScreen());
              }
            });
            }else{
              BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
            }
          },
        ),
        // ListOfAccountInvoiceScreen
        NestedMenuItem(
          title: "LIST OF ACCOUNT INVOICES",
          onTap: () {
            if(controller.selectedMenuItems.length <20){
            List permissions = [];
            permissions = Api().sp.read('all_permissions') ?? [];
            setState(() {
              if(permissions.contains('read_account_invoice')){
                controller.currentPage.value = ListOfAccountInvoiceScreen();
                controller.menuBarRefresh(
                    title: "LIST OF ACCOUNT INVOICES",
                    pageName: ListOfAccountInvoiceScreen());
              }
            });
            }else{
              BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
            }
          },
        ),
      ]),
      NestedMenuItem(title: "VEHICLES", children: [
        NestedMenuItem(
          title: "CREATE VEHICLE TYPE",
          onTap: () {
            if(controller.selectedMenuItems.length <20){
            List permissions = [];
            permissions = Api().sp.read('all_permissions') ?? [];
            setState(() {
              if(permissions.contains('create_vehicle_type')){
                if (Get.isRegistered<VehicleController>()) {
                  Get.find<VehicleController>().clearForm();
                }
                controller.currentPage.value = CreateVehicleTypes();
                controller.menuBarRefresh(
                    title: "CREATE VEHICLE TYPE", pageName: CreateVehicleTypes());
              }
            });
            }else{
              BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
            }
          },
        ),
        NestedMenuItem(
          title: "VEHICLE TYPE",
          onTap: () {
           if(controller.selectedMenuItems.length <20){

            List permissions = [];
            permissions = Api().sp.read('all_permissions') ?? [];
            setState(() {
              if(permissions.contains('read_vehicle_type')){
                controller.currentPage.value = ListVehicleType();
                controller.menuBarRefresh(
                    title: "VEHICLE TYPE", pageName: ListVehicleType());
              }
            });
           }else{
             BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
           }
          },
        ),
        NestedMenuItem(
          title: "CREATE COMPANY VEHICLE",
          onTap: () {
           if(controller.selectedMenuItems.length <20){
            List permissions = [];
            permissions = Api().sp.read('all_permissions') ?? [];
            setState(() {
              if(permissions.contains('create_company_vehicle')){
                if (Get.isRegistered<VehicleController>()) {
                  Get.find<VehicleController>().clearCompanyVehicleForm();
                }
                controller.currentPage.value = CreateCompanyVehicle();
                controller.menuBarRefresh(
                    title: "CREATE COMPANY VEHICLE",
                    pageName: CreateCompanyVehicle());
              }
            });
           }else{
             BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
           }
          },
        ),
        /* NestedMenuItem(
          title: "LIST COMPANY VEHICLE",
          onTap: () {
            setState(() {
              controller.currentPage.value = CompanyVehicleForm();
              controller.menuBarRefresh(title: "LIST COMPANY VEHICLE", pageName: CompanyVehicleForm());
            });
          },
        ),*/
        NestedMenuItem(
          title: "COMPANY VEHICLES LIST",
          onTap: () {
            if(controller.selectedMenuItems.length <20){
            List permissions = [];
            permissions = Api().sp.read('all_permissions') ?? [];
            setState(() {
              if(permissions.contains('read_company_vehicle')){
                controller.currentPage.value = CompanyVehiclesScreen();
                controller.menuBarRefresh(
                    title: "COMPANY VEHICLES LIST",
                    pageName: CompanyVehiclesScreen());
              }
            });
            }else{
              BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
            }
          },
        ),
      ]),
      NestedMenuItem(title: "ADMINISTRATIONS", children: [
        NestedMenuItem(title: "USERS LIST", children: [
          NestedMenuItem(
            title: "CREATE USER",
            onTap: () {
              if(controller.selectedMenuItems.length <20){
              List permissions = [];
              permissions = Api().sp.read('all_permissions') ?? [];
              print(permissions);
              setState(() {
                if(permissions.contains('create_user')){
                  if (Get.isRegistered<AdministrationController>()) {
                    Get.find<AdministrationController>().clearUserForm();
                  }
                  controller.currentPage.value = CreateUserScreen();
                  controller.menuBarRefresh(
                      title: "CREATE USER", pageName: CreateUserScreen());
                }
              });
              }else{
                BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
              }
            },
          ),
          NestedMenuItem(
            title: "USERS",
            onTap: () {
              if(controller.selectedMenuItems.length <20){
              List permissions = [];
              permissions = Api().sp.read('all_permissions') ?? [];
              print(permissions);
              setState(() {
                if(permissions.contains('read_company_information')){

                  controller.currentPage.value = UserListscreen();
                  controller.menuBarRefresh(
                      title: "USERS", pageName: UserListscreen());
                }
              });
              }else{
                BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
              }
            },
          ),
          // CreateSubsiDiary
          NestedMenuItem(
            title: "CREATE SUBSIDIARY",
            onTap: () {
             if(controller.selectedMenuItems.length <20){
              List permissions = [];
              permissions = Api().sp.read('all_permissions') ?? [];
              setState(() {
                if(permissions.contains('create_subsidiary')){
                  if (Get.isRegistered<AdministrationController>()) {
                    Get.find<AdministrationController>().clearSubsidiaryForm();
                  }
                  controller.currentPage.value = CreateSubsiDiary();
                  controller.menuBarRefresh(
                      title: "CREATE SUBSIDIARY", pageName: CreateSubsiDiary());
                }
              });
             }else{
               BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
             }
            },
          ),
          // SubsiDiariesScreen
          NestedMenuItem(
            title: "SUBSIDIARIES",
            onTap: () {
              if(controller.selectedMenuItems.length <20){
              List permissions = [];
              permissions = Api().sp.read('all_permissions') ?? [];
              setState(() {
                if(permissions.contains('read_subsidiary')){
                  controller.currentPage.value = SubsiDiariesScreen();
                  controller.menuBarRefresh(
                      title: "SUBSIDIARIES", pageName: SubsiDiariesScreen());
                }
              });
              }else{
                BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
              }
            },
          ),
          NestedMenuItem(
            title: "AUTHORIZATION",
            onTap: () {
              if(controller.selectedMenuItems.length <20){
              if(Api().sp.read('userRole') == "super admin"){
                setState(() {
                  controller.currentPage.value = AuthorizationScreen();
                  controller.menuBarRefresh(
                      title: "AUTHORIZATION", pageName: AuthorizationScreen());
                });
              }else{
                BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
              }
              }
            },
          ),
        ]),
        // NestedMenuItem(
        //   title: "SUBSIDIARY",
        //   onTap: () => message(context, "DevOps"),
        // ),
      ]),
      NestedMenuItem(title: "REPORTS", children: [
        NestedMenuItem(
            title: "DRIVER",
            // onTap: () => message(context, "DevOps"),
            children: [
              NestedMenuItem(
                  title: "LOGIN",
                  onTap: () {
                    if(controller.selectedMenuItems.length <20){
                    setState(() {
                      controller.currentPage.value = DriverLoginScreen();
                      controller.menuBarRefresh(
                          title: "LOGIN", pageName: DriverLoginScreen());
                    });
                    }else{
                      BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
                    }
                  }),
              NestedMenuItem(
                  title: "LOG",
                  onTap: () {
                    if(controller.selectedMenuItems.length <20){
                    setState(() {
                      controller.currentPage.value = DriverLogsScreen();
                      controller.menuBarRefresh(
                          title: "LOG", pageName: DriverLogsScreen());
                    });
                    }else{
                      BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
                    }
                  }),
              NestedMenuItem(
                  title: "EARNINGS & INFO",
                  onTap: () {
                    if(controller.selectedMenuItems.length <20){
                    setState(() {
                      controller.currentPage.value = EarningAndInfoScreen();
                      controller.menuBarRefresh(
                          title: "EARNINGS & INFO",
                          pageName: EarningAndInfoScreen());
                    });
                    }else{
                      BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
                    }
                  }),
              NestedMenuItem(
                  title: "FEEDBACK",
                  onTap: () {
                    if(controller.selectedMenuItems.length <20){
                    setState(() {
                      controller.currentPage.value = ReportFeedback();
                      controller.menuBarRefresh(
                          title: "FEEDBACK", pageName: ReportFeedback());
                    });
                    }else{
                      BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
                    }
                  }),
              NestedMenuItem(
                  title: "STATISTICS",
                  onTap: () {
                    if(controller.selectedMenuItems.length <20){
                    setState(() {
                      controller.currentPage.value = StatisticsScreen();
                      controller.menuBarRefresh(
                          title: "STATISTICS", pageName: StatisticsScreen());
                    });
                    }else{
                      BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
                    }
                  }),
            ]),
        NestedMenuItem(title: "BOOKINGS", children: [
          NestedMenuItem(
            title: "ALL BOOKINGS",
            onTap: () {
              if(controller.selectedMenuItems.length <20){
              setState(() {
                controller.currentPage.value = AllBookingView();
                controller.menuBarRefresh(
                    title: "ALL BOOKINGS", pageName: AllBookingView());
              });
              }else{
                BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
              }
            },
          ),
          NestedMenuItem(
            title: "TRANSFERED BOOKINGS",
            onTap: () {
              if(controller.selectedMenuItems.length <20){
              setState(() {
                controller.currentPage.value = ReportTransferedBooking();
                controller.menuBarRefresh(
                    title: "TRANSFERED BOOKINGS",
                    pageName: ReportTransferedBooking());
              });
              }else{
                BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
              }
            },
          ),
        ]),
        NestedMenuItem(title: "EMPLOYEE", children: [
          NestedMenuItem(
            title: "ACTIVITY",
            onTap: () {
              if(controller.selectedMenuItems.length <20){
              setState(() {
                controller.currentPage.value = ActivityScreen();
                controller.menuBarRefresh(
                    title: "ACTIVITY", pageName: ActivityScreen());
              });
              }else{
                BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
              }
            },
          ),
        ]),
        NestedMenuItem(title: "INCOME", children: [
          NestedMenuItem(
            title: "INCOME",
            onTap: () {
              if(controller.selectedMenuItems.length <20){
              setState(() {
                controller.currentPage.value = IncomeScreen();
                controller.menuBarRefresh(
                    title: "INCOME", pageName: IncomeScreen());
              });
              }else{
                BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
              }
            },
          ),
          NestedMenuItem(
            title: "COMPANY INCOME",
            onTap: () {
              if(controller.selectedMenuItems.length <20){
              setState(() {
                controller.currentPage.value = CompanyIncomeScreen();
                controller.menuBarRefresh(
                    title: "COMPANY INCOME", pageName: CompanyIncomeScreen());
              });
              }else{
                BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
              }
            },
          ),
          NestedMenuItem(
            title: "CREDIT CARD PAYMENTS",
            onTap: () {
              if(controller.selectedMenuItems.length <20){
              setState(() {
                controller.currentPage.value = CreiditCardPayments();
                controller.menuBarRefresh(
                    title: "CREDIT CARD PAYMENTS",
                    pageName: CreiditCardPayments());
              });
              }else{
                BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
              }
            },
          ),
        ]),
        NestedMenuItem(
          title: "PCO",
          onTap: () {
           if(controller.selectedMenuItems.length <20){
            setState(() {
              controller.currentPage.value = PcoScreen();
              controller.menuBarRefresh(title: "PCO", pageName: PcoScreen());
            });
           }else{
             BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
           }
          },
        ),
      ]),
      NestedMenuItem(title: "SETTINGS", children: [
        NestedMenuItem(
          title: "COMPANY INFORMATION",
          onTap: () {
            if(controller.selectedMenuItems.length <20){
            List permissions = [];
            permissions = Api().sp.read('all_permissions') ?? [];
            print(permissions);
            setState(() {
              if(permissions.contains('read_company_information')){
                controller.currentPage.value = ComapanyInformationScreen();
                controller.menuBarRefresh(
                    title: "COMPANY INFORMATION",
                    pageName: ComapanyInformationScreen());  }
            });
            }else{
              BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
            }
          },
        ),
        NestedMenuItem(
          title: "COMPANY CONFIGURATION",
          onTap: () {
            if(controller.selectedMenuItems.length <20){
            List permissions = [];
            permissions = Api().sp.read('all_permissions') ?? [];
            print(permissions);
            setState(() {
              if(permissions.contains('read_company_configuration')){

                controller.currentPage.value = CompanyConfigurationView();
                controller.menuBarRefresh(
                    title: "COMPANY CONFIGURATION",
                    pageName: CompanyConfigurationView());
              }
            });
            }else{
              BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
            }
          },
        ),

        NestedMenuItem(
          title: "PAYMENT TYPES COLOR CODE",
          onTap: () {
            if (controller.selectedMenuItems.length < 20) {
              controller.menuBarRefresh(
                title: "PAYMENT TYPES COLOR CODE",
                pageName: controller.currentPage.value,
              );
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return const PaymentTypeDialog();
                },
              );
            }
            else {
              BotToast.showText(
                  text: "Maintain at least 20 pages open simultaneously.");
            }
          }
        ),
        // DocumentNumberScreen
        NestedMenuItem(
          title: "DOCUMENT NUMBER",
          onTap: () {
            if(controller.selectedMenuItems.length <20){
            List permissions = [];
            permissions = Api().sp.read('all_permissions') ?? [];
            setState(() {
              if(permissions.contains('read_document_number')){
                controller.currentPage.value = DocumentNumberScreen();
                controller.menuBarRefresh(
                    title: "DOCUMENT NUMBER", pageName: DocumentNumberScreen());
              }
            });
            }else{
              BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
            }
          },
        ),
        NestedMenuItem(
          title: "TEMPLATE SETTINGS",
          onTap: () {
            if(controller.selectedMenuItems.length <20){
            List permissions = [];
            permissions = Api().sp.read('all_permissions') ?? [];
            print(permissions);
            setState(() {
              if(permissions.contains('read_template')){
                controller.currentPage.value = TemplateSettings();
                controller.menuBarRefresh(
                    title: "TEMPLATE SETTINGS", pageName: TemplateSettings());
              }
            });
            }else{
              BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
            }
          },
        ),
        NestedMenuItem(
          title: "CLEAR BOOKINGS",
          onTap: () {
           if(controller.selectedMenuItems.length <20){
            setState(() {
              controller.currentPage.value = BookingClearingUtilityScreen();
              controller.menuBarRefresh(
                  title: "CLEAR BOOKINGS",
                  pageName: BookingClearingUtilityScreen());
            });
           }else{
             BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
           }
          },
        ),
        NestedMenuItem(
          title: "LOCATION TYPE SHORTCUTS",
          onTap: () {
           if(controller.selectedMenuItems.length <20){
            setState(() {
              controller.currentPage.value = LocationTypeShortcuts();
              controller.menuBarRefresh(
                  title: "LOCATION TYPE SHORTCUTS",
                  pageName: LocationTypeShortcuts());
            });
           }else{
             BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
           }
          },
        ),
        NestedMenuItem(
          title: "VOIP SETTINGS",
          onTap: () {
            if(controller.selectedMenuItems.length <20){
            List permissions = [];
            permissions = Api().sp.read('all_permissions') ?? [];
            print(permissions);
            setState(() {
              if(permissions.contains('read_voip_settings')){
                controller.currentPage.value = VoipSettingsScreen();
                controller.menuBarRefresh(
                    title: "VOIP SETTINGS", pageName: VoipSettingsScreen());
              }
            });
            }else{
              BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
            }
          },
        ),
        // NestedMenuItem(
        //   title: "GENERAL SMS CONFIG",
        //   onTap: () => message(context, "DevOps"),
        // ),
        // NestedMenuItem(
        //   title: "SMS SETTINGS",
        //   onTap: () {
        //     setState(() {
        //       controller.currentPage.value = TemplateSettings();
        //       controller.menuBarRefresh(
        //           title: "SMS SETTINGS", pageName: TemplateSettings());
        //     });
        //   },
        // ),

        NestedMenuItem(
          title: "SMS TRACKING",
          onTap: () {
            if(controller.selectedMenuItems.length <20){
            setState(() {
              controller.currentPage.value = SmsSettingsScreen();
              controller.menuBarRefresh(
                  title: "SMS TRACKING", pageName: SmsSettingsScreen());
            });
            }else{
              BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
            }
          },
        ),

        NestedMenuItem(
          title: "EMAIL TRACKING",
          onTap: () {
            if(controller.selectedMenuItems.length <20){
            setState(() {
              controller.currentPage.value = EmailTrackingScreen();
              controller.menuBarRefresh(
                  title: "EMAIL TRACKING", pageName: EmailTrackingScreen());
            });
            }else{
              BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
            }
          },
        ),
        NestedMenuItem(
          title: "CALL RECORDINGS",
          onTap: () {
            if(controller.selectedMenuItems.length <20){
            setState(() {
              controller.currentPage.value = CallRecordingScreen();
              controller.menuBarRefresh(
                  title: "CALL RECORDINGS", pageName: CallRecordingScreen());
            });
            }else{
              BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
            }
          },
        ),
        // NestedMenuItem(
        //   title: "RELEASE NOTES",
        //   onTap: () {
        //     controller.menuBarRefresh(
        //       title: "RELEASE NOTES",
        //       pageName: controller.currentPage.value,
        //     );
        //     showDialog(
        //       context: context,
        //       barrierDismissible: true,
        //       builder: (BuildContext context) {
        //         return const ReleaseNotesDialog();
        //       },
        //     );
        //   },
        // ),
        NestedMenuItem(
          title: "HELP",
          onTap: () {
            if(controller.selectedMenuItems.length <20){
            controller.menuBarRefresh(
              title: "HELP",
              pageName: controller.currentPage.value,
            );
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return const BackSlashAlert();
              });
            }else{
              BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
            }
          },
        ),

        NestedMenuItem(
          title: "CHAT WITH DRIVER AND PASSENGER",
          onTap: () {
            if(controller.selectedMenuItems.length <20){
            setState(() {
              controller.currentPage.value = ChatWithDriverAndPassenger();
              controller.menuBarRefresh(
                  title: "CHAT WITH DRIVER AND PASSENGER",
                  pageName: ChatWithDriverAndPassenger());
            });
            }else{
              BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
            }
          },
        ),
        NestedMenuItem(
          title: "WALLBOARD",
          onTap: () {
            if(controller.selectedMenuItems.length <20){
              setState(() {
                controller.currentPage.value = WallboardScreen();
                controller.menuBarRefresh(
                    title: "WALLBOARD",
                    pageName: WallboardScreen());
              });
            }else{
              BotToast.showText(text: "Maintain at least 20 pages open simultaneously.");
            }
          },
        ),
        // NestedMenuItem(
        //   title: "PERMISSION SETTINGS",
        //   onTap: () => message(context, "DevOps"),
        // ),
      ]),
      // NestedMenuItem(title: "SETTINGS", children: [
      //   NestedMenuItem(title: "", icon: Icons.menu, onTap: () {}, children: [
      //     NestedMenuItem(icon: Icons.email, title: "", onTap: () {}),
      //     NestedMenuItem(icon: Icons.notifications, title: "", onTap: () {}),
      //     NestedMenuItem(
      //         icon: Icons.power_settings_new, title: "", onTap: () {}),
      //   ]),
      // ]),
    ];
  }
}

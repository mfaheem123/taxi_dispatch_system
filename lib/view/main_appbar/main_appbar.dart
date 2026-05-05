import 'dart:io';

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
import '../../alert/cli_extention_alert.dart';
import '../../component/color.dart';
import '../../component/networks/api.dart';
import '../../tabbarview.dart';
import '../accounts/Invoice/list_customer_invoices.dart';
import '../accounts/account/account_view.dart';
import '../accounts/account/create_escopt.dart';
import '../accounts/list_of_accountScreen.dart';
import '../administration/User/create_userScreen.dart';
import '../administration/User/user_listScreen.dart';
import '../administration/model/user_model.dart';
import '../auth/Controller/auth_controller.dart';
import '../booking_view/app_booking.dart';
import '../booking_view/complete_bookingview.dart';
import '../booking_view/multi_booking.dart';
import '../booking_view/pending_booking.dart';
import '../booking_view/pre_booking.dart';
import '../booking_view/web_booking.dart';
import '../customer/add_customerScreen.dart';
import '../customer/complaints.dart';
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
import '../setting/company_configuration_view/company_configuration_view.dart';
import '../setting/location_type_shortcuts.dart';
import '../setting/template_settings.dart';
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

  @override
  void initState() {
    super.initState();
    authController.checkUserStatus();
    RawKeyboard.instance.addListener(_handleKey);
    hoverMenu = _makeMenus(context);

  }

  @override
  void dispose() {
    RawKeyboard.instance.removeListener(_handleKey);
    super.dispose();
  }

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

      if (event.logicalKey.keyLabel == "F#") {
        shortCutKeyValue.value = "alert";
      }
      if (event.logicalKey.keyLabel == "/") {
        // DashboardSlashAlert.show();
      }
      if (event.logicalKey.keyLabel == "Escape" &&
          shortCutKeyValue.value == "alert") {
        shortCutKeyValue.value = "shortCutKey";
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

    return Scaffold(
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
                onTap: () {
                  authController.logout();
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
            return
              // (controller.currentPage.value == null ||  controller.currentPage.value.runtimeType == ByDefaultDashboard) ?
              Container(
              width: Get.width,
              height: 60,
              color: DynamicColors.whiteClr,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                      //  Username
                      Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F2EF),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: const Color(0xFFC4D9D4),
                              width: 1),
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 5,
                              backgroundColor:
                                  Color(0xff424899), // Bright green dot
                            ),
                            const SizedBox(width: 10),
                            Text(
                              // username
                              Employee.selectedEmployee?.username?.toUpperCase() ??
                                  "GUEST",
                              style: mozillaTextRegularText(
                                  color: const Color(0xFF4A4A4A), // Dark grey text
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3.0),
                        child: SizedBox(
                          height: kToolbarHeight,
                          width: 165,
                          child: Row(
                            children: [
                              Text(
                                "PRESS",
                                style: mozillaTextRegularText(
                                    color: DynamicColors.textClr, fontSize: 14),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 9, vertical: 4),
                                  decoration: BoxDecoration(
                                      color: DynamicColors.textClr,
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Text(
                                    "/",
                                    style: mozillaTextRegularText(
                                        color: DynamicColors.whiteClr,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                              Text(
                                "SHORTCUTS",
                                style: mozillaTextRegularText(
                                    color: DynamicColors.textClr, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(width: screenWidth * 0.31),
                      // 4. Copyright Text
                      Text(
                        "NEXUS © 2026",
                        style: mozillaTextRegularText(
                            color: Colors.grey, fontSize: 12),
                      ),
                      SizedBox(width: screenWidth * 0.3),

                      // 3. Date & Time
                      Text(
                        DateFormat("EEE, MMM dd yyyy")
                            .format(DateTime.now())
                            .toUpperCase(),
                        style: mozillaTextRegularText(
                            color: const Color(0xFF4A4A4A),
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 12),
                      const Text("|",
                          style: TextStyle(color: Colors.grey, fontSize: 16)),
                      // Separator
                      const SizedBox(width: 12),
                      Text(
                        DateFormat("hh:mm:ss a").format(DateTime.now()),
                        style: mozillaTextRegularText(
                            color: const Color(0xFF4A4A4A),
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),

                      // 6. Extension Number
                      GestureDetector(
                        onTap: () {
                          ExtensionAlert.show();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
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
                );
              // : const SizedBox.shrink();
        }
      ),
    );
  }

  List<NestedMenuItem> _makeMenus(BuildContext context) {
    return [
      NestedMenuItem(
        title: "NEXUS",
      ),
      NestedMenuItem(title: "BOOKINGS", children: [
        NestedMenuItem(
          title: "CREATE BOOKINGS",
          onTap: () {
            final newTabUrl = Uri.base.origin + Routes.createBooking;
            html.window.open(newTabUrl, '_blank');
            // Get.toNamed(Routes.createBooking);
          },
        ),
        NestedMenuItem(
          title: "COMPLETE BOOKINGS",
          onTap: () {
            setState(() {
              controller.currentPage.value = CompleteBookingsScreen();
              controller.menuBarRefresh(
                  title: "COMPLETE BOOKINGS",
                  pageName: CompleteBookingsScreen());
            });
          },
        ),
        NestedMenuItem(
          title: "PENDING BOOKINGS",
          onTap: () {
            setState(() {
              controller.currentPage.value = PendingBooking();
              controller.menuBarRefresh(
                  title: "PENDING BOOKINGS", pageName: PendingBooking());
            });
          },
        ),
        NestedMenuItem(
          title: "PRE BOOKINGS",
          onTap: () {
            setState(() {
              controller.currentPage.value = PreBooking();
              controller.menuBarRefresh(
                  title: "PRE BOOKINGS", pageName: PreBooking());
            });
          },
        ),
        NestedMenuItem(
          title: "WEB BOOKINGS",
          onTap: () {
            setState(() {
              controller.currentPage.value = WebBooking();
              controller.menuBarRefresh(
                  title: "WEB BOOKINGS", pageName: WebBooking());
            });
          },
        ),
        NestedMenuItem(
          title: "APP BOOKINGS",
          onTap: () {
            setState(() {
              controller.currentPage.value = AppBooking();
              controller.menuBarRefresh(
                  title: "APP BOOKINGS", pageName: AppBooking());
            });
          },
        ),
        NestedMenuItem(
          title: "MULTI BOOKINGS",
          onTap: () {
            setState(() {
              controller.currentPage.value = MultiBooking();
              controller.menuBarRefresh(
                  title: "MULTI BOOKINGS", pageName: MultiBooking());
            });
          },
        ),
        NestedMenuItem(
          title: "TRASH BOOKINGS",
          onTap: () {
            setState(() {
              controller.currentPage.value = TrashBooking();
              controller.menuBarRefresh(
                  title: "TRASH BOOKINGS", pageName: TrashBooking());
            });
          },
        ),
      ]),
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
      NestedMenuItem(title: "CUSTOMERS", children: [
        NestedMenuItem(
          title: "ADD CUSTOMER",
          onTap: () {

            List permissions = [];
            permissions = Api().sp.read('all_permissions') ?? [];
            setState(() {
              if(permissions.contains('create_customer')){
                controller.currentPage.value = CustomerFormScreen();
                controller.menuBarRefresh(
                    title: "ADD CUSTOMER", pageName: CustomerFormScreen());
              }
            });
          },
        ),
        NestedMenuItem(
          title: "CUSTOMERS",
          onTap: () {
            List permissions = [];
            permissions = Api().sp.read('all_permissions') ?? [];
            setState(() {
              if(permissions.contains('read_customer')){
                controller.currentPage.value = CustomersScreen();
                controller.menuBarRefresh(
                    title: "CUSTOMERS", pageName: CustomersScreen());
              }
            });
          },
        ),
        NestedMenuItem(
          title: "CREATE LOST PROPERTY",
          onTap: () {

            List permissions = [];
            permissions = Api().sp.read('all_permissions') ?? [];
            setState(() {
              if(permissions.contains('create_lost_property')){
                controller.currentPage.value = LostPropertyScreen();
                controller.menuBarRefresh(
                    title: "CREATE LOST PROPERTY",
                    pageName: LostPropertyScreen());
              }
            });
          },
        ),
        NestedMenuItem(
          title: "LOST PROPERTY",
          onTap: () {

            List permissions = [];
            permissions = Api().sp.read('all_permissions') ?? [];
            setState(() {
              if(permissions.contains('read_lost_property')){
                controller.currentPage.value = LostProperty();
                controller.menuBarRefresh(
                    title: "LOST PROPERTY", pageName: LostProperty());
              }
            });
          },
        ),
        NestedMenuItem(
          title: "CREATE COMPLAINT",
          onTap: () {

            List permissions = [];
            permissions = Api().sp.read('all_permissions') ?? [];
            setState(() {
              if(permissions.contains('create_complaint')){
                controller.currentPage.value = CreateComplaint();
                controller.menuBarRefresh(
                    title: "CREATE COMPLAINT", pageName: CreateComplaint());
              }
            });
          },
        ),
        NestedMenuItem(
          title: "COMPLAINTS",
          onTap: () {
            List permissions = [];
            permissions = Api().sp.read('all_permissions') ?? [];
            setState(() {
              if(permissions.contains('read_complaint')){
                controller.currentPage.value = ComplaintsView();
                controller.menuBarRefresh(
                    title: "COMPLAINTS", pageName: ComplaintsView());
              }
            });
          },
        ),
      ]),
      NestedMenuItem(title: "FARES", children: [
        NestedMenuItem(
            title: "CREATE FARE SETTINGS",
            onTap: () {
              setState(() {
                controller.currentPage.value = FareConfigurationDay();
                controller.menuBarRefresh(
                    title: "CREATE FARE SETTINGS",
                    pageName: FareConfigurationDay());
              });
            }),
        NestedMenuItem(
            title: "CREATE FIXED FARE SETTINGS",
            onTap: () {
              setState(() {
                controller.currentPage.value = CreateFixedFareSetting();
                controller.menuBarRefresh(
                    title: "CREATE FIXED FARE SETTINGS",
                    pageName: CreateFixedFareSetting());
              });
            }),
        NestedMenuItem(
          title: "CREATE PLOT FARE",
          onTap: () {
            setState(() {
              controller.currentPage.value = PlotFare();
              controller.menuBarRefresh(
                  title: "CREATE PLOT FARE", pageName: PlotFare());
            });
          },
        ),
        NestedMenuItem(
            title: "CREATE FARE BY VEHICLE SETTINGS",
            onTap: () {
              setState(() {
                controller.currentPage.value = FareByVehicle();
                controller.menuBarRefresh(
                    title: "CREATE FARE BY VEHICLE SETTINGS",
                    pageName: FareByVehicle());
              });
            }),
        NestedMenuItem(
          title: "AIRPORT CHARGES",
          onTap: () {
            setState(() {
              controller.currentPage.value = AirportCharges();
              controller.menuBarRefresh(
                  title: "AIRPORT CHARGES", pageName: AirportCharges());
            });
          },
        ),
        NestedMenuItem(
          title: "FARE INCREMENT",
          onTap: () {
            setState(() {
              controller.currentPage.value = FareIncrement();
              controller.menuBarRefresh(
                  title: "FARE INCREMENT", pageName: FareIncrement());
            });
          },
        ),
        NestedMenuItem(
          title: "SUR CHARGES",
          onTap: () {
            setState(() {
              controller.currentPage.value = FareCharges();
              controller.menuBarRefresh(
                  title: "SUR CHARGES", pageName: FareCharges());
            });
          },
        ),
        NestedMenuItem(
          title: "FARE METER",
          onTap: () {
            setState(() {
              controller.currentPage.value = FareMeter();
              controller.menuBarRefresh(
                  title: "FARE METER", pageName: FareMeter());
            });
          },
        ),
      ]),
      NestedMenuItem(title: "LOCATIONS", children: [
        NestedMenuItem(
          title: "CREATE LOCATIONS",
          onTap: () {
            setState(() {
              controller.currentPage.value = LocationForm();
              controller.menuBarRefresh(
                  title: "CREATE LOCATIONS", pageName: LocationForm());
            });
          },
        ),
        NestedMenuItem(
          title: "LIST OF LOCATIONS",
          onTap: () {
            setState(() {
              controller.currentPage.value = LocationListScreen();
              controller.menuBarRefresh(
                  title: "LIST OF LOCATIONS", pageName: LocationListScreen());
            });
          },
        ),
        NestedMenuItem(
          title: "CREATE ZONE",
          onTap: () {
            setState(() {
              controller.currentPage.value = ZoneScreen();
              controller.menuBarRefresh(
                  title: "CREATE ZONE", pageName: ZoneScreen());
            });
          },
        ),
        NestedMenuItem(
          title: "LIST OF ZONES",
          onTap: () {
            setState(() {
              controller.currentPage.value = ZoneListScreen();
              controller.menuBarRefresh(
                  title: "LIST OF ZONES", pageName: ZoneListScreen());
            });
          },
        ),
        NestedMenuItem(
          title: "LOCALIZATION",
          onTap: () {
            setState(() {
              controller.currentPage.value = LocalizationScreen();
              controller.menuBarRefresh(
                  title: "LOCALIZATION", pageName: LocalizationScreen());
            });
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

                List permissions = [];
                permissions = Api().sp.read('all_permissions') ?? [];
                setState(() {
                  if(permissions.contains('create_driver')){
                    controller.currentPage.value = DriverForm();
                    controller.menuBarRefresh(
                        title: "ADD DRIVER", pageName: DriverForm());
                  }
                });
              },
            ),
            NestedMenuItem(
              title: "DRIVERS",
              onTap: () {

                List permissions = [];
                permissions = Api().sp.read('all_permissions') ?? [];
                setState(() {
                  if(permissions.contains('read_driver')){
                    controller.currentPage.value = DriverListScreen();
                    controller.menuBarRefresh(
                        title: "DRIVERS", pageName: DriverListScreen());
                  }
                });
              },
            ),
            NestedMenuItem(
              title: "LIST OF LOGGED IN/OUT DRIVERS",
              onTap: () {
                setState(() {
                  controller.currentPage.value = LoginDriversScreen();
                  controller.menuBarRefresh(
                      title: "LIST OF LOGGED IN/OUT DRIVERS",
                      pageName: LoginDriversScreen());
                });
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
              },
            ),
            NestedMenuItem(
              title: "DRIVER COMMISSIONS",
              onTap: () {

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
              },
            ),
            NestedMenuItem(
              title: "BULK DRIVER COMMISSION",
              onTap: () {
                setState(() {
                  controller.currentPage.value = BulkDriverCommission();
                  controller.menuBarRefresh(
                      title: "BULK DRIVER COMMISSION",
                      pageName: BulkDriverCommission());
                });
              },
            ),
            NestedMenuItem(
              title: "DRIVER COMMISSION PAY",
              onTap: () {
                setState(() {
                  controller.currentPage.value = DriverCommissionPay();
                  controller.menuBarRefresh(
                      title: "DRIVER COMMISSION PAY",
                      pageName: DriverCommissionPay());
                });
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
                setState(() {
                  controller.currentPage.value = CreateDriverRent();
                  controller.menuBarRefresh(
                      title: "CREATE DRIVER RENT",
                      pageName: CreateDriverRent());
                });
              },
            ),
            NestedMenuItem(
              title: "DRIVER RENT",
              onTap: () {
                setState(() {
                  controller.currentPage.value = DriverRent();
                  controller.menuBarRefresh(
                      title: "DRIVER RENT", pageName: DriverRent());
                });
              },
            ),
            NestedMenuItem(
              title: "BULK DRIVER RENT",
              onTap: () {
                setState(() {
                  controller.currentPage.value = BulkDriverRent();
                  controller.menuBarRefresh(
                      title: "BULK DRIVER RENT", pageName: BulkDriverRent());
                });
              },
            ),
            NestedMenuItem(
              title: "DRIVER RENT PAY",
              onTap: () {
                setState(() {
                  controller.currentPage.value = DriverRentPay();
                  controller.menuBarRefresh(
                      title: "DRIVER RENT PAY", pageName: DriverRentPay());
                });
              },
            ),
          ],
        ),
        NestedMenuItem(
            title: "DRIVER APP FEATURES",
            onTap: () {
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
            }),
        NestedMenuItem(
            title: "DRIVER SIN BIN SETTINGS",
            onTap: () {
              setState(() {
                controller.currentPage.value = DriverSinBinSetting();
                controller.menuBarRefresh(
                    title: "DRIVER SIN BIN SETTINGS",
                    pageName: DriverSinBinSetting());
              });
            }),
      ]),
      NestedMenuItem(title: "ACCOUNTS", children: [
        NestedMenuItem(
          title: "CREATE ACCOUNT",
          onTap: () {
            List permissions = [];
            permissions = Api().sp.read('all_permissions') ?? [];
            setState(() {
              if(permissions.contains('create_account')){
                controller.currentPage.value = AccountView();
                controller.menuBarRefresh(
                    title: "CREATE ACCOUNT", pageName: AccountView());
              }
            });
          },
        ),
        NestedMenuItem(
          title: "LIST OF ACCOUNTS",
          onTap: () {
            List permissions = [];
            permissions = Api().sp.read('all_permissions') ?? [];
            setState(() {
              if(permissions.contains('read_account')){
                controller.currentPage.value = ListOfAccountScreen();
                controller.menuBarRefresh(
                    title: "LIST OF ACCOUNTS", pageName: ListOfAccountScreen());
              }
            });
          },
        ),
        NestedMenuItem(
          title: "CREATE ESCORT",
          onTap: () {
            List permissions = [];
            permissions = Api().sp.read('all_permissions') ?? [];
            setState(() {
              if(permissions.contains('create_escort')){
                controller.currentPage.value = CreateEscortScreen();
                controller.menuBarRefresh(
                    title: "CREATE ESCORT", pageName: CreateEscortScreen());
              }
            });


            ///------------------------------------------------------------------------------------------------------------------
          },
        ),
        // CreateEscortScreen
        NestedMenuItem(
          title: "ESCORT LIST ",
          onTap: () {
            List permissions = [];
            permissions = Api().sp.read('all_permissions') ?? [];
            setState(() {
              if(permissions.contains('read_escort')){
                controller.currentPage.value = ESCORTScreen();
              controller.menuBarRefresh(
                  title: "ESCORT LIST", pageName: ESCORTScreen());
              }
            });
          },
        ),
        NestedMenuItem(
          title: "CREATE CUSTOMER INVOICE",
          onTap: () {
            setState(() {
              controller.currentPage.value = CreateCustomerinvoice();
              controller.menuBarRefresh(
                  title: "CREATE CUSTOMER INVOICE",
                  pageName: CreateCustomerinvoice());
            });
          },
        ),
        NestedMenuItem(
          title: "LIST OF CUSTOMER INVOICES",
          onTap: () {
            setState(() {
              controller.currentPage.value = InvoiceList();
              controller.menuBarRefresh(
                  title: "LIST OF CUSTOMER INVOICES", pageName: InvoiceList());
            });
          },
        ),
        NestedMenuItem(
          title: "CREATE ACCOUNT INVOICE",
          onTap: () {
            setState(() {
              controller.currentPage.value = CreateAccountInvoiceScreen();
              controller.menuBarRefresh(
                  title: "CREATE ACCOUNT INVOICE",
                  pageName: CreateAccountInvoiceScreen());
            });
          },
        ),
        // ListOfAccountInvoiceScreen
        NestedMenuItem(
          title: "LIST OF ACCOUNT INVOICES",
          onTap: () {
            setState(() {
              controller.currentPage.value = ListOfAccountInvoiceScreen();
              controller.menuBarRefresh(
                  title: "LIST OF ACCOUNT INVOICES",
                  pageName: ListOfAccountInvoiceScreen());
            });
          },
        ),
      ]),
      NestedMenuItem(title: "VEHICLES", children: [
        NestedMenuItem(
          title: "CREATE VEHICLE TYPE",
          onTap: () {

            List permissions = [];
            permissions = Api().sp.read('all_permissions') ?? [];
            setState(() {
              if(permissions.contains('create_vehicle_type')){
                controller.currentPage.value = CreateVehicleTypes();
                controller.menuBarRefresh(
                    title: "CREATE VEHICLE TYPE", pageName: CreateVehicleTypes());
              }
            });
          },
        ),
        NestedMenuItem(
          title: "VEHICLE TYPE",
          onTap: () {


            List permissions = [];
            permissions = Api().sp.read('all_permissions') ?? [];
            setState(() {
              if(permissions.contains('read_vehicle_type')){
                controller.currentPage.value = ListVehicleType();
                controller.menuBarRefresh(
                    title: "VEHICLE TYPE", pageName: ListVehicleType());
              }
            });
          },
        ),
        NestedMenuItem(
          title: "CREATE COMPANY VEHICLE",
          onTap: () {
            List permissions = [];
            permissions = Api().sp.read('all_permissions') ?? [];
            setState(() {
              if(permissions.contains('create_company_vehicle')){
                controller.currentPage.value = CreateCompanyVehicle();
                controller.menuBarRefresh(
                    title: "CREATE COMPANY VEHICLE",
                    pageName: CreateCompanyVehicle());
              }
            });
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
          },
        ),
      ]),
      NestedMenuItem(title: "ADMINISTRATIONS", children: [
        NestedMenuItem(title: "USERS LIST", children: [
          NestedMenuItem(
            title: "CREATE USER",
            onTap: () {

              List permissions = [];
              permissions = Api().sp.read('all_permissions') ?? [];
              print(permissions);
              setState(() {
                if(permissions.contains('create_user')){
                  controller.currentPage.value = CreateUserScreen();
                  controller.menuBarRefresh(
                      title: "CREATE USER", pageName: CreateUserScreen());
                }
              });
            },
          ),
          NestedMenuItem(
            title: "USERS",
            onTap: () {

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

            },
          ),
          // CreateSubsiDiary
          NestedMenuItem(
            title: "CREATE SUBSIDIARY",
            onTap: () {

              List permissions = [];
              permissions = Api().sp.read('all_permissions') ?? [];
              setState(() {
                if(permissions.contains('create_subsidiary')){
                  controller.currentPage.value = CreateSubsiDiary();
                  controller.menuBarRefresh(
                      title: "CREATE SUBSIDIARY", pageName: CreateSubsiDiary());
                }
              });
            },
          ),
          // SubsiDiariesScreen
          NestedMenuItem(
            title: "SUBSIDIARIES",
            onTap: () {

              List permissions = [];
              permissions = Api().sp.read('all_permissions') ?? [];
              setState(() {
                if(permissions.contains('read_subsidiary')){
                  controller.currentPage.value = SubsiDiariesScreen();
                  controller.menuBarRefresh(
                      title: "SUBSIDIARIES", pageName: SubsiDiariesScreen());
                }
              });
            },
          ),
          NestedMenuItem(
            title: "AUTHORIZATION",
            onTap: () {
              setState(() {
                controller.currentPage.value = AuthorizationScreen();
                controller.menuBarRefresh(
                    title: "AUTHORIZATION", pageName: AuthorizationScreen());
              });
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
                    setState(() {
                      controller.currentPage.value = DriverLoginScreen();
                      controller.menuBarRefresh(
                          title: "LOGIN", pageName: DriverLoginScreen());
                    });
                  }),
              NestedMenuItem(
                  title: "LOG",
                  onTap: () {
                    setState(() {
                      controller.currentPage.value = DriverLogsScreen();
                      controller.menuBarRefresh(
                          title: "LOG", pageName: DriverLogsScreen());
                    });
                  }),
              NestedMenuItem(
                  title: "EARNINGS & INFO",
                  onTap: () {
                    setState(() {
                      controller.currentPage.value = EarningAndInfoScreen();
                      controller.menuBarRefresh(
                          title: "EARNINGS & INFO",
                          pageName: EarningAndInfoScreen());
                    });
                  }),
              NestedMenuItem(
                  title: "FEEDBACK",
                  onTap: () {
                    setState(() {
                      controller.currentPage.value = ReportFeedback();
                      controller.menuBarRefresh(
                          title: "FEEDBACK", pageName: ReportFeedback());
                    });
                  }),
              NestedMenuItem(
                  title: "STATISTICS",
                  onTap: () {
                    setState(() {
                      controller.currentPage.value = StatisticsScreen();
                      controller.menuBarRefresh(
                          title: "STATISTICS", pageName: StatisticsScreen());
                    });
                  }),
            ]),
        NestedMenuItem(title: "BOOKINGS", children: [
          NestedMenuItem(
            title: "ALL BOOKINGS",
            onTap: () {
              setState(() {
                controller.currentPage.value = AllBookingView();
                controller.menuBarRefresh(
                    title: "ALL BOOKINGS", pageName: AllBookingView());
              });
            },
          ),
          NestedMenuItem(
            title: "TRANSFERED BOOKINGS",
            onTap: () {
              setState(() {
                controller.currentPage.value = ReportTransferedBooking();
                controller.menuBarRefresh(
                    title: "TRANSFERED BOOKINGS",
                    pageName: ReportTransferedBooking());
              });
            },
          ),
        ]),
        NestedMenuItem(title: "EMPLOYEE", children: [
          NestedMenuItem(
            title: "ACTIVITY",
            onTap: () {
              setState(() {
                controller.currentPage.value = ActivityScreen();
                controller.menuBarRefresh(
                    title: "ACTIVITY", pageName: ActivityScreen());
              });
            },
          ),
        ]),
        NestedMenuItem(title: "INCOME", children: [
          NestedMenuItem(
            title: "INCOME",
            onTap: () {
              setState(() {
                controller.currentPage.value = IncomeScreen();
                controller.menuBarRefresh(
                    title: "INCOME", pageName: IncomeScreen());
              });
            },
          ),
          NestedMenuItem(
            title: "COMPANY INCOME",
            onTap: () {
              setState(() {
                controller.currentPage.value = CompanyIncomeScreen();
                controller.menuBarRefresh(
                    title: "COMPANY INCOME", pageName: CompanyIncomeScreen());
              });
            },
          ),
          NestedMenuItem(
            title: "CREDIT CARD PAYMENTS",
            onTap: () {
              setState(() {
                controller.currentPage.value = CreiditCardPayments();
                controller.menuBarRefresh(
                    title: "CREDIT CARD PAYMENTS",
                    pageName: CreiditCardPayments());
              });
            },
          ),
        ]),
        NestedMenuItem(
          title: "PCO",
          onTap: () {
            setState(() {
              controller.currentPage.value = PcoScreen();
              controller.menuBarRefresh(title: "PCO", pageName: PcoScreen());
            });
          },
        ),
      ]),
      NestedMenuItem(title: "SETTINGS", children: [
        NestedMenuItem(
          title: "COMPANY INFORMATION",
          onTap: () {

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

          },
        ),
        NestedMenuItem(
          title: "COMPANY CONFIGURATION",
          onTap: () {

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
          },
        ),
        // DocumentNumberScreen
        NestedMenuItem(
          title: "DOCUMENT NUMBER",
          onTap: () {
            List permissions = [];
            permissions = Api().sp.read('all_permissions') ?? [];
            setState(() {
              if(permissions.contains('read_document_number')){
                controller.currentPage.value = DocumentNumberScreen();
                controller.menuBarRefresh(
                    title: "DOCUMENT NUMBER", pageName: DocumentNumberScreen());
              }
            });
          },
        ),
        NestedMenuItem(
          title: "TEMPLATE SETTINGS",
          onTap: () {

            List permissions = [];
            permissions = Api().sp.read('all_permissions') ?? [];
            print(permissions);
            setState(() {
              if(permissions.contains('read_template_type')){
                controller.currentPage.value = TemplateSettings();
                controller.menuBarRefresh(
                    title: "TEMPLATE SETTINGS", pageName: TemplateSettings());
              }
            });
          },
        ),
        NestedMenuItem(
          title: "BOOKING CLEARING UTILITY",
          onTap: () {
            setState(() {
              controller.currentPage.value = BookingClearingUtilityScreen();
              controller.menuBarRefresh(
                  title: "BOOKING CLEARING UTILITY",
                  pageName: BookingClearingUtilityScreen());
            });
          },
        ),
        NestedMenuItem(
          title: "LOCATION TYPE SHORTCUTS",
          onTap: () {
            setState(() {
              controller.currentPage.value = LocationTypeShortcuts();
              controller.menuBarRefresh(
                  title: "LOCATION TYPE SHORTCUTS",
                  pageName: LocationTypeShortcuts());
            });
          },
        ),
        NestedMenuItem(
          title: "VOIP SETTINGS",
          onTap: () {

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
          },
        ),
        NestedMenuItem(
          title: "GENERAL SMS CONFIG",
          onTap: () => message(context, "DevOps"),
        ),
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
          title: "CHAT WITH DRIVER AND PASSENGER",
          onTap: () {
            setState(() {
              controller.currentPage.value = ChatWithDriverAndPassenger();
              controller.menuBarRefresh(
                  title: "CHAT WITH DRIVER AND PASSENGER",
                  pageName: ChatWithDriverAndPassenger());
            });
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

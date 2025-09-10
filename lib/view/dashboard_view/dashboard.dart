import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/tabbarview.dart';
import 'package:dashboard_new1/view/Invoice/create_accountinvoice.dart';
import 'package:dashboard_new1/view/locations_view/location/zone_listScreen.dart';
import 'package:dashboard_new1/view/vehicles_view/vehicle/create_vehicleScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../routes/app_pages.dart';
import '../accounts/list_of_accountScreen.dart';
import '../administration/User/create_userScreen.dart';
import '../administration/User/user_listScreen.dart';
import '../drivers_view/driver/bulk_driver_commission/bulk_driver_commission.dart';
import '../drivers_view/driver/bulk_driver_commission/bulk_driver_rent.dart';
import '../drivers_view/driver/create_driver_form/driver_form.dart';
import '../drivers_view/driver/driver_app_features/driver_app_feature_screen.dart';
import '../drivers_view/driver/driver_commission/driver_commission.dart';
import '../drivers_view/driver/driver_commission/create_driver_rent.dart';
import '../drivers_view/driver/driver_commission/driver_rent.dart';
import '../drivers_view/driver/driver_commission/list_driver_commission.dart';
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
import '../locations_view/location/plotting_Screen.dart';
import '../locations_view/location/zone_screen.dart';
import '../vehicles_view/vehicle/company_vehiclesScreen.dart';
import '../vehicles_view/vehicle/create_company_vehicleScreen.dart';
import '../vehicles_view/vehicle/list_vehicle_typeScreen.dart';
import 'Controller/dashboard_controller.dart';
import 'booking_list.dart';
import 'dashboard/F3_alert.dart';
import 'dashboard/defult_dashboard_view.dart';
import 'dart:html' as html;

class DashBoarScreen extends StatefulWidget {
  final void Function(String)? onSelect;

  const DashBoarScreen({super.key, this.onSelect});

  @override
  State<DashBoarScreen> createState() => _DashBoarScreenState();
}

class _DashBoarScreenState extends State<DashBoarScreen> {
  final dashBoardCntrl = Get.find<DashboardController>();
  // final DashboardController locationCtrl = Get.put(DashboardController());
  List<SelectedDropdown> selectedTexts = [];
  // List<String> selectedTexts = [];



  late final List<GlobalKey> menuKeys;

  @override
  void initState() {
    super.initState();
    RawKeyboard.instance.addListener(_handleKey);
    menuKeys = List.generate(menus.length, (_) => GlobalKey());

  }

  @override
  void dispose()
  {
    RawKeyboard.instance.removeListener(_handleKey);
    super.dispose();
  }

  double _getMenuX(int index)
  {
    final renderBox = menuKeys[index].currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final offset = renderBox.localToGlobal(Offset.zero);
      return offset.dx;
    }
    return 0;
  }

  void _handleKey(RawKeyEvent event)
  {
    if (event is RawKeyDownEvent)
    {
      if(event.logicalKey.keyLabel == "F#"){
        shortCutKeyValue.value = "alert";
      }
      if(event.logicalKey.keyLabel == "Escape" &&
          shortCutKeyValue.value == "alert"){
        shortCutKeyValue.value = "shortCutKey";
      }
      else if(event.logicalKey.keyLabel == "F2"){
        final newTabUrl = Uri.base.origin + '/#' + Routes.createBooking;
        html.window.open(newTabUrl, '_blank');
      }
      }
    if (event is RawKeyDownEvent && shortCutKeyValue.value == "shortCutKey")
    {
      if (event.logicalKey == LogicalKeyboardKey.arrowRight)
      {
        setState(() {
          dashBoardCntrl.selectedIndex = (dashBoardCntrl.selectedIndex + 1) % menus.length;
        });
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft)
      {
        setState(() {
          dashBoardCntrl.selectedIndex = (dashBoardCntrl.selectedIndex - 1 + menus.length) % menus.length;
        });
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown)
      {
        if (dashBoardCntrl.isDropdownOpen) {
          setState(() {
            dashBoardCntrl.dropdownIndex = (dashBoardCntrl.dropdownIndex + 1) % menus[dashBoardCntrl.selectedIndex].subItems.length;
          });
        } else {
          setState(() {
            dashBoardCntrl.isDropdownOpen = true;
          });
        }
      }

      else if (event.logicalKey == LogicalKeyboardKey.arrowUp)

      {
        if (dashBoardCntrl.isDropdownOpen) {
          setState(() {
            dashBoardCntrl.dropdownIndex = (dashBoardCntrl.dropdownIndex - 1 + menus[dashBoardCntrl.selectedIndex].subItems.length) %
                menus[dashBoardCntrl.selectedIndex].subItems.length;
          });
        }

      }

      else if (event.logicalKey == LogicalKeyboardKey.enter) {
        if (dashBoardCntrl.isDropdownOpen) {
          String selectedItem = menus[dashBoardCntrl.selectedIndex].subItems[dashBoardCntrl.dropdownIndex];
          widget.onSelect?.call(selectedItem);
          setState(() {
            for (var action in selectedTexts) {
              action.selectedItem = false;
            }
            selectedTexts.add(SelectedDropdown(selectedItem: true,title: selectedItem));
            // selectedTexts.remove(selectedItem);
            // selectedTexts.add(selectedItem);
            dashBoardCntrl.isDropdownOpen = false;
          });
        }

        else
        {
          setState(() {
            dashBoardCntrl.isDropdownOpen = true;
          });
        }

      }
      else if (event.logicalKey == LogicalKeyboardKey.escape)
      {
        setState(() {
          dashBoardCntrl.isDropdownOpen = false;
        });
      } 
    }
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return RawKeyboardListener(
      focusNode: dashBoardCntrl.focusNode,
      autofocus: true,
      onKey: (RawKeyEvent event) {
        if (FocusManager.instance.primaryFocus is EditableTextState) {
          // ✅ Let the textfield work normally
          return;
        }

        if (event is RawKeyDownEvent) {
          final key = event.logicalKey;
          print('Pressed key: ${key.debugName}');

          // Example: block only function keys (F1–F12)
          if (key.debugName?.startsWith("F") == true) {
            // prevent default browser action only for shortcuts
            html.window.onKeyDown.listen((html.KeyboardEvent e) {
              e.preventDefault();
            });
          }

          if (key.debugName == "F3") {
            showShortcutDialog(
              context,
              title: AppText.driverInfo,
              contentWidget: F3AlertWidget(),
            );
          } else if (key.debugName == "F4") {
            showShortcutDialog(
              context,
              title: AppText.driverEarning,
              contentWidget: F4AlertWidget(),
            );
          } else if (key.debugName == "F8") {
            showShortcutDialog(
              context,
              title: AppText.comingSoon,
              contentWidget: ComingSoonWidget(shotCutKey: "F8"),
            );
          } else if (key.debugName == "F9") {
            showShortcutDialog(
              context,
              title: AppText.comingSoon,
              contentWidget: ComingSoonWidget(shotCutKey: "F9"),
            );
          } else if (key.debugName == "F6") {
            showShortcutDialog(
              context,
              title: AppText.comingSoon,
              contentWidget: ComingSoonWidget(shotCutKey: "F6"),
            );
          } else if (key.debugName == "F1") {
            showShortcutDialog(
              context,
              title: AppText.comingSoon,
              contentWidget: ComingSoonWidget(shotCutKey: "F1"),
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: Color(0xFFEEF0F3),
        body: SafeArea(
          child: Stack(
            children: [
              GetBuilder<DashboardController>(
                builder: (controller) {
                  return Column(
                    children: [
                      // Fixed top navigation bar
                      Container(
                        color: const Color(0xFF43489A),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        height: 60,
                        width: Get.width,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              const Text(
                                "NEXUS",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
                              ),

                              const SizedBox(width: 20),

                              for (int i = 0; i < menus.length; i++)
                                Padding(
                                  key: menuKeys[i],
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        shortCutKeyValue.value = 'shortCutKey';
                                        if (dashBoardCntrl.selectedIndex == i) {
                                          dashBoardCntrl.isDropdownOpen = !dashBoardCntrl.isDropdownOpen;
                                        } else {
                                          dashBoardCntrl.selectedIndex = i;
                                          dashBoardCntrl.isDropdownOpen = true;
                                        }
                                      });
                                    },

                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: dashBoardCntrl.selectedIndex == i ? Colors.white24 : Colors.transparent,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(menus[i].icon, color: Colors.white, size: 16),
                                          const SizedBox(width: 5),
                                          Text(
                                            menus[i].label,
                                            style: const TextStyle(color: Colors.white, fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                              SizedBox(
                                width: MediaQuery.of(context).size.width/7.3,
                              ),

                              GestureDetector(
                                onTap: (){
                                  controller.selectionMenuBtn.value = 0;
                                  controller.update();
                                },
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: controller.selectionMenuBtn.value==0? Colors.cyanAccent.shade400:Colors.transparent,
                                  child: Icon(Icons.email,
                                      size: 20,
                                      color: controller.selectionMenuBtn.value==0? DynamicColors.whiteClr:Colors.cyanAccent.shade400),
                                ),
                              ),

                              SizedBox(width: 15),

                              GestureDetector(
                                onTap: (){
                                  controller.selectionMenuBtn.value = 1;
                                  controller.update();
                                },
                                child: CircleAvatar(
                                           radius: 18,
                                    backgroundColor: controller.selectionMenuBtn.value == 1? Colors.cyanAccent.shade400:Colors.transparent,
                                    child: Icon(Icons.notifications,
                                        size: 20,
                                        color: controller.selectionMenuBtn.value==1? DynamicColors.whiteClr:Colors.cyanAccent.shade400),),
                              ),

                              SizedBox(width: 15),

                              GestureDetector(
                                onTap: (){
                                  controller.selectionMenuBtn.value = 2;
                                  controller.update();
                                },
                                child: CircleAvatar(
                                           radius: 18,
                                    backgroundColor: controller.selectionMenuBtn.value==2? Colors.cyanAccent.shade400:Colors.transparent,
                                    child: Icon(Icons.power_settings_new,
                                        size: 20,
                                        color: controller.selectionMenuBtn.value==2? DynamicColors.redClr:Colors.cyanAccent.shade400),),
                              ),

                              SizedBox(width: 15),
                            ],
                          ),
                        ),
                      ),

                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                            Container(
                              width: screenWidth,
                              padding: EdgeInsets.symmetric(vertical: 6,horizontal: 8),
                              color: Colors.grey.shade300,
                              child: Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: [
                                  // Home icon container
                                  Container(
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

                                  // Dynamic selected tabs
                                  ...selectedTexts.map((text) {
                                    return GestureDetector(
                                      onTap: (){
                                        for (var action in selectedTexts) {
                                          action.selectedItem = false;
                                        }
                                        text.selectedItem = true;
                                        controller.update();
                                      },
                                      child: Container(
                                        padding:
                                        EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: text.selectedItem== false?DynamicColors.gryClr :DynamicColors.whiteClr,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(text.title!, style: TextStyle(fontSize: 16)),
                                            SizedBox(width: 5),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  if(selectedTexts.last.title == text.title && selectedTexts.length>1){
                                                    selectedTexts.remove(text);
                                                    selectedTexts.last.selectedItem = true;
                                                  }else{
                                                    selectedTexts.remove(text);
                                                  }

                                                });
                                              },
                                              child: Icon(
                                                Icons.cancel,
                                                color: Color(0xFF43489A),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                            getSelectedWidget(),
                          ],
                        ),
                        ),
                      )
                    // ),
                    ],
                  );
                }
              ),

              // 🔽 Dropdown - Show only if open
              if (dashBoardCntrl.isDropdownOpen && dashBoardCntrl.selectedIndex != null)
                Positioned(
                  top: 50, // navbar height
                  left: _getMenuX(dashBoardCntrl.selectedIndex),
                  child: Column(
                    children: [
                      Material(
                        elevation: 4,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            // maxHeight: 300,
                            minWidth: 160,
                            maxWidth: 300,
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: menus[dashBoardCntrl.selectedIndex].subItems.length,
                            itemBuilder: (context, index) {
                              return Container(
                                color: dashBoardCntrl.dropdownIndex == index ? Colors.blueAccent : Colors.transparent,
                                child: ListTile(
                                  dense: true, // reduces vertical height
                                  visualDensity: VisualDensity(horizontal: 0, vertical: -4), // fine-tune vertical padding
                                  contentPadding: EdgeInsets.only(left: 4),
                                  title: Text(
                                    menus[dashBoardCntrl.selectedIndex].subItems[index],
                                    style: TextStyle(
                                      color: dashBoardCntrl.dropdownIndex == index ? Colors.white : Colors.black,
                                      fontSize: 12
                                    ),
                                  ),
                                  onTap: () {
                                    final selectedItem = menus[dashBoardCntrl.selectedIndex].subItems[index];
                                    widget.onSelect?.call(selectedItem);
                                    setState(() {
                                      for (var action in selectedTexts) {
                                        action.selectedItem = false;
                                      }
                                      selectedTexts.remove(selectedItem);
                                      selectedTexts.add(SelectedDropdown(title: selectedItem,selectedItem: true));
                                      dashBoardCntrl.dropdownIndex = index;
                                      dashBoardCntrl.isDropdownOpen = false;
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );

  }

  Widget getSelectedWidget({GestureTapCallback? onTap}) {
    final selectedItems = selectedTexts.where((e) => e.selectedItem == true).toList();

    if (selectedItems.isEmpty) return FareMeter();
    // if (selectedItems.isEmpty) return ByDefaultDashboard();

    final lastSelected = selectedItems.last; // 👈 sirf last true item

    print(lastSelected.title);
    if (selectedTexts.isEmpty) return FareMeter();

    late Widget child;

    switch (lastSelected.title) {
      case 'LIST OF BOOKINGS':
        child = BookingList();
        break;
      case 'LOCALIZATION':
        return LocalizationScreen();
        case 'CREATE LOCATIONS':
        return LocationForm();
      case 'CREATE USER':
        return CreateUserScreen();
        case 'LIST OF USER':
        return UserListscreen();
        case 'LIST OF ZONES':
        return ZoneListScreen();
        case 'PLOTTING':
        return ManagePostcodes();
        case 'LIST OF LOCATIONS':
        return LocationListScreen();

      case 'CREATE DRIVER':
        child = DriverForm();
        break;
      case 'LIST OF DRIVERS':
        child = DriverListScreen();
        break;
      case 'LIST OF LOGGED IN/OUT DRIVERS':
        child = LoginDriversScreen();
        break;
      case 'DRIVER APP FEATURES':
        return DriverAppFeatureScreen();
      case 'CREATE VEHICLE TYPE':
        return CreateVehicle();
        case 'LIST OF VEHICLE TYPES':
        return VehicleTypeListScreen();
        case 'LIST OF COMPANY VEHICLE':
        return CompanyVehiclesScreen();
        case 'CREATE COMPANY VEHICLE':
        return CompanyVehicleForm();
        case 'LIST OF ACCOUNTS':
        return ListOfAccountScreen();
        case 'CREATE CUSTOMER INVOICE':
        return CustomerPreInvoice();
        child = DriverAppFeatureScreen();
        break;
      case 'CREATE DRIVER COMMISSION':
        child = ListDriverCommission();
        break;
      case 'DRIVER COMMISSIONS':
        child = DriverCommission();
        break;
      case 'BULK DRIVER COMMISSION':
        child = BulkDriverCommission();
        break;
      case 'DRIVER COMMISSION PAY':
        child = DriverCommissionPay();
        break;
      case 'CREATE DRIVER RENT':
        child = CreateDriverRent();
        break;
      case 'DRIVER RENT':
        child = DriverRent();
        break;
      case 'BULK DRIVER RENT':
        child = BulkDriverRent();
        break;
      case 'DRIVER RENT PAY':
        child = DriverRentPay();
        break;
      case 'DRIVER SIN BIN SETTINGS':
        child = DriverSinBinSetting();
        break;
      case 'CREATE PLOT FARE':
        child = PlotFare();
        break;
      case 'CREATE FIXED FARE SETTINGS':
        child = CreateFixedFareSetting();
        break;
      case 'CREATE FARE SETTINGS':
        child = FareConfigurationDay();
        break;
      case 'CREATE FARE BY VEHICLE SETTINGS':
        child = FareByVehicle();
        break;
      case 'AIRPORT CHARGES':
        child = AirportCharges();
        break;
      case 'FARE INCREMENT':
        child = FareIncrement();
        break;
      case 'SUR CHARGES':
        child = FareCharges();
        break;
      case 'FARE METER':
        child = FareMeter();
        break;
      default:
        child = ByDefaultDashboard();
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300), // 👈 smooth transition time
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition( // 👈 fade effect
          opacity: animation,
          child: child,
        );
      },
      child: child,
    );
  }
}


final List<MenuItemData> menus = [
  MenuItemData("BOOKINGS", Icons.book_online, ["CREATE BOOKINGS", "LIST OF BOOKINGS", "LIST OF WEB BOOKINGS", "LIST OF APP BOOKINGS", "LIST OF MULTI BOOKINGS", "LIST OF TRASH BOOKINGS"]),
  MenuItemData("CUSTOMERS", Icons.headset_mic, ["CREATE BOOKINGS", "LIST OF BOOKINGS", "LIST OF WEB BOOKINGS", "LIST OF APP BOOKINGS", "LIST OF MULTI BOOKINGS", "LIST OF TRASH BOOKINGS"]),
  MenuItemData("FARES", Icons.wallet_outlined, ["CREATE FARE SETTINGS", "CREATE FIXED FARE SETTINGS", "CREATE PLOT FARE", "CREATE FARE BY VEHICLE SETTINGS", "AIRPORT CHARGES", "FARE INCREMENT", "SUR CHARGES", "FARE METER"]),
  MenuItemData("LOCATIONS", Icons.location_pin, ["CREATE LOCATIONS", "LIST OF LOCATIONS", "CREATE ZONE", "LIST OF ZONES", "LOCALIZATION", "PLOTTING"]),
  MenuItemData("DRIVERS", Icons.person, ["CREATE DRIVER", "LIST OF DRIVERS", "DRIVER APP FEATURES", "LIST OF LOGGED IN/OUT DRIVERS", "CREATE DRIVER COMMISSION", "CREATE DRIVER RENT", "DRIVER COMMISSIONS", "BULK DRIVER COMMISSION","DRIVER COMMISSION PAY","DRIVER RENT", "BULK DRIVER RENT","DRIVER RENT PAY", "DRIVER SIN BIN SETTINGS"]),
  MenuItemData("ACCOUNTS", Icons.account_circle, ["CREATE ACCOUNT", "LIST OF ACCOUNTS", "CREATE CUSTOMER INVOICE", "LIST OF CUSTOMER INVOICES", "CREATE ACCOUNT INVOICE", "LIST OF ACCOUNT INVOICES"]),
  MenuItemData("VEHICLES", Icons.directions_car, ["CREATE VEHICLE TYPE", "LIST OF VEHICLE TYPES", "CREATE COMPANY VEHICLE", "LIST OF COMPANY VEHICLE"]),
  MenuItemData("INVOICE", Icons.supervised_user_circle, ["CREATE USER", "LIST OF USER", "AUTHORIZATION"]),
  MenuItemData("ADMINSTRATION", Icons.supervised_user_circle, ["CREATE SUBSIDIARY", "LIST OF SUBSIDIARIES"]),
  MenuItemData("REPORTS", Icons.receipt_long, ["DRIVER", "BOOKINGS", "CALL", "INCOME", "PCO"]),
  MenuItemData("SETTINGS", Icons.settings, ["COMPANY INFORMATION", "COMPANY CONFIGURATION", "DOCUMENT NUMBER", "TEMPLATE SETTINGS", "BOOKING CLEARING UTILITY", "LOCATION TYPE SHORTCUTS", "VOIP SETTINGS", "GENERAL SMS CONFIG", "SMS SETTINGS", "CHAT WITH DRIVER AND PASSENGER", "PERMISSION SETTINGS"]),
];




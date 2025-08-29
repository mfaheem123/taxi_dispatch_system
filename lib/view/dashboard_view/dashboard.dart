import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/tabbarview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../component/textStyle.dart';
import '../../routes/app_pages.dart';
import '../drivers_view/driver/bulk_driver_commission/bulk_driver_commission.dart';
import '../drivers_view/driver/create_driver_form/driver_form.dart';
import '../drivers_view/driver/driver_app_features/driver_app_feature_screen.dart';
import '../drivers_view/driver/driver_commission/driver_commission.dart';
import '../drivers_view/driver/driver_commission/list_driver_commission.dart';
import '../drivers_view/driver/drivers_list/driver_list_screen.dart';
import '../drivers_view/driver/login_drivers/login_drivers_screen.dart';
import '../locations_view/location/localization_screen.dart';
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
  List<String> selectedTexts = [];


  
  late final List<GlobalKey> menuKeys;

  @override
  void initState() {
    super.initState();
    RawKeyboard.instance.addListener(_handleKey);
    menuKeys = List.generate(menus.length, (_) => GlobalKey());

  }

  @override
  void dispose() {
    RawKeyboard.instance.removeListener(_handleKey);
    super.dispose();
  }

  double _getMenuX(int index) {
    final renderBox = menuKeys[index].currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final offset = renderBox.localToGlobal(Offset.zero);
      return offset.dx;
    }
    return 0;
  }

  void _handleKey(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
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
    if (event is RawKeyDownEvent && shortCutKeyValue.value == "shortCutKey") {
      if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        setState(() {
          dashBoardCntrl.selectedIndex = (dashBoardCntrl.selectedIndex + 1) % menus.length;
        });
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        setState(() {
          dashBoardCntrl.selectedIndex = (dashBoardCntrl.selectedIndex - 1 + menus.length) % menus.length;
        });
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        if (dashBoardCntrl.isDropdownOpen) {
          setState(() {
            dashBoardCntrl.dropdownIndex = (dashBoardCntrl.dropdownIndex + 1) % menus[dashBoardCntrl.selectedIndex].subItems.length;
          });
        } else {
          setState(() {
            dashBoardCntrl.isDropdownOpen = true;
          });
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        if (dashBoardCntrl.isDropdownOpen) {
          setState(() {
            dashBoardCntrl.dropdownIndex = (dashBoardCntrl.dropdownIndex - 1 + menus[dashBoardCntrl.selectedIndex].subItems.length) %
                menus[dashBoardCntrl.selectedIndex].subItems.length;
          });
        }
      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
        if (dashBoardCntrl.isDropdownOpen) {
          String selectedItem = menus[dashBoardCntrl.selectedIndex].subItems[dashBoardCntrl.dropdownIndex];
          widget.onSelect?.call(selectedItem);
          setState(() {
            selectedTexts.remove(selectedItem);
            selectedTexts.add(selectedItem);
            dashBoardCntrl.isDropdownOpen = false;
          });
        } else {
          setState(() {
            dashBoardCntrl.isDropdownOpen = true;
          });
        }
      } else if (event.logicalKey == LogicalKeyboardKey.escape) {
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
        html.window.onKeyDown.listen((html.KeyboardEvent e) {
          e.preventDefault();
        });
        if (event is RawKeyDownEvent) {
          final key = event.logicalKey;
          print('Pressed key: ${key.debugName}');
          print('Key code: ${event.data}');



          // F3
          if (key.debugName == "F3") {
            showShortcutDialog(
              context,
              title: AppText.driverInfo,
              contentWidget: F3AlertWidget(),
            );
          }else if (key.debugName == "F4") {
            showShortcutDialog(
              context,
              title: AppText.driverEarning,
              contentWidget: F4AlertWidget(),
            );
          }else if (key.debugName == "F8") {
            showShortcutDialog(
              context,
              title: AppText.comingSoon,
              contentWidget: ComingSoonWidget(shotCutKey: "F8",),
            );
          }else if (key.debugName == "F9") {
            showShortcutDialog(
              context,
              title: AppText.comingSoon,
              contentWidget: ComingSoonWidget(shotCutKey: "F9",),
            );
          }else if (key.debugName == "F6") {
            showShortcutDialog(
              context,
              title: AppText.comingSoon,
              contentWidget: ComingSoonWidget(shotCutKey: "F6",),
            );
          }else if (key.debugName == "F1") {
            showShortcutDialog(
              context,
              title: AppText.comingSoon,
              contentWidget: ComingSoonWidget(shotCutKey: "F1",),
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
                                    return Container (
                                      padding:
                                      EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(text, style: TextStyle(fontSize: 16)),
                                          SizedBox(width: 5),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selectedTexts.remove(text);
                                              });
                                            },
                                            child: Icon(
                                              Icons.cancel,
                                              color: Color(0xFF43489A),
                                            ),
                                          ),
                                        ],
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
                            itemBuilder: (context, j) {
                              return Container(
                                color: dashBoardCntrl.dropdownIndex == j ? Colors.blueAccent : Colors.transparent,
                                child: ListTile(
                                  dense: true, // reduces vertical height
                                  visualDensity: VisualDensity(horizontal: 0, vertical: -4), // fine-tune vertical padding
                                  contentPadding: EdgeInsets.only(left: 4),
                                  title: Text(
                                    menus[dashBoardCntrl.selectedIndex].subItems[j],
                                    style: TextStyle(
                                      color: dashBoardCntrl.dropdownIndex == j ? Colors.white : Colors.black,
                                      fontSize: 12
                                    ),
                                  ),
                                  onTap: () {
                                    final selectedItem = menus[dashBoardCntrl.selectedIndex].subItems[j];
                                    widget.onSelect?.call(selectedItem);
                                    setState(() {
                                      selectedTexts.remove(selectedItem);
                                      selectedTexts.add(selectedItem);
                                      dashBoardCntrl.dropdownIndex = j;
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
    print(selectedTexts);
    if (selectedTexts.isEmpty) return BulkDriverCommission();
    // if (selectedTexts.isEmpty) return ByDefaultDashboard();

    switch (selectedTexts.last) {
      case 'LIST OF BOOKINGS':
        return BookingList();
      case 'LOCALIZATION':
        return LocalizationScreen();
      case 'CREATE DRIVER':
        return DriverForm();
      case 'LIST OF DRIVERS':
        return DriverListScreen();
      case 'LIST OF LOGGED IN DRIVERS':
        return LoginDriversScreen();
      case 'DRIVER APP FEATURES':
        return DriverAppFeatureScreen();
      case 'CREATE DRIVER COMMISSION':
        return ListDriverCommission();
      case 'DRIVER COMMISSIONS':
        return DriverCommission();
      case 'BULK DRIVER COMMISSION':
        return BulkDriverCommission();
      default:
        return ByDefaultDashboard();
    }
  }
}


final List<MenuItemData> menus = [
  MenuItemData("BOOKINGS", Icons.book_online, ["CREATE BOOKINGS", "LIST OF BOOKINGS", "LIST OF WEB BOOKINGS", "LIST OF APP BOOKINGS", "LIST OF MULTI BOOKINGS", "LIST OF TRASH BOOKINGS"]),
  MenuItemData("CUSTOMERS", Icons.headset_mic, ["CREATE BOOKINGS", "LIST OF BOOKINGS", "LIST OF WEB BOOKINGS", "LIST OF APP BOOKINGS", "LIST OF MULTI BOOKINGS", "LIST OF TRASH BOOKINGS"]),
  MenuItemData("FARES", Icons.wallet_outlined, ["CREATE FARE SETTINGS", "CREATE FIXED FARE SETTINGS", "CREATE FARE BY VEHICLE SETTINGS"]),
  MenuItemData("LOCATIONS", Icons.location_pin, ["CREATE LOCATIONS", "LIST OF LOCATIONS", "CREATE ZONE", "LIST OF ZONES", "LOCALIZATION", "PLOTTING"]),
  MenuItemData("DRIVERS", Icons.person, ["CREATE DRIVER", "LIST OF DRIVERS", "LIST OF INACTIVE DRIVERS", "DRIVER APP FEATURES", "LIST OF LOGGED OUT DRIVERS", "CREATE DRIVER COMMISSION", "LIST OF DRIVER COMMISSION", "DRIVER COMMISSIONS", "BULK DRIVER COMMISSION"]),
  MenuItemData("ACCOUNTS", Icons.account_circle, ["CREATE ACCOUNT", "LIST OF ACCOUNTS", "CREATE CUSTOMER INVOICE", "LIST OF CUSTOMER INVOICES", "CREATE ACCOUNT INVOICE", "LIST OF ACCOUNT INVOICES"]),
  MenuItemData("VEHICLES", Icons.directions_car, ["CREATE VEHICLE TYPE", "LIST OF VEHICLE TYPES", "CREATE COMPANY VEHICLE", "LIST OF COMPANY VEHICLE"]),
  MenuItemData("USERS", Icons.supervised_user_circle, ["CREATE USER", "LIST OF USER", "AUTHORIZATION"]),
  MenuItemData("SUBSIDIARY", Icons.supervised_user_circle, ["CREATE SUBSIDIARY", "LIST OF SUBSIDIARIES"]),
  MenuItemData("REPORTS", Icons.receipt_long, ["DRIVER", "BOOKINGS", "CALL", "INCOME", "PCO"]),
  MenuItemData("SETTINGS", Icons.settings, ["COMPANY INFORMATION", "COMPANY CONFIGURATION", "DOCUMENT NUMBER", "TEMPLATE SETTINGS", "BOOKING CLEARING UTILITY", "LOCATION TYPE SHORTCUTS", "VOIP SETTINGS", "GENERAL SMS CONFIG", "SMS SETTINGS", "CHAT WITH DRIVER AND PASSENGER", "PERMISSION SETTINGS"]),
];




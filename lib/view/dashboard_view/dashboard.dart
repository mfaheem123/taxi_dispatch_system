import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/tabbarview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../component/textStyle.dart';
import 'Controller/dashboard_controller.dart';
import 'booking_list.dart';
import 'dashboard/F3_alert.dart';
import 'dashboard/defult_dashboard_view.dart';

class DashBoarScreen extends StatefulWidget {
  final void Function(String)? onSelect;

  const DashBoarScreen({super.key, this.onSelect});

  @override
  State<DashBoarScreen> createState() => _DashBoarScreenState();
}

class _DashBoarScreenState extends State<DashBoarScreen> {
  final dashBoardCntrl = Get.find<DashboardController>();
  // final DashboardController locationCtrl = Get.put(DashboardController());
  String? selectedValue;
  String selectedJourneyType = 'Journey Type';
  String selectedVehicleType = 'Saloon';
  String selectedPaymentMethod = 'Cash';
  String selectedAccountType = 'Account';
  String selectedDriver = 'Select Driver';
  List<String> selectedTexts = [];
  bool limitReached = false;

  final List<MenuItemData> menus = [
    MenuItemData("BOOKINGS", Icons.book_online, ["CREATE BOOKINGS", "LIST OF BOOKINGS", "LIST OF WEB BOOKINGS", "LIST OF APP BOOKINGS", "LIST OF MULTI BOOKINGS", "LIST OF TRASH BOOKINGS"]),
    MenuItemData("CUSTOMERS", Icons.headset_mic, ["CREATE BOOKINGS", "LIST OF BOOKINGS", "LIST OF WEB BOOKINGS", "LIST OF APP BOOKINGS", "LIST OF MULTI BOOKINGS", "LIST OF TRASH BOOKINGS"]),
    MenuItemData("FARES", Icons.wallet_outlined, ["CREATE FARE SETTINGS", "CREATE FIXED FARE SETTINGS", "CREATE FARE BY VEHICLE SETTINGS"]),
    MenuItemData("LOCATIONS", Icons.location_pin, ["CREATE LOCATIONS", "LIST OF LOCATIONS", "CREATE ZONE", "LIST OF ZONES", "LOCALIZATION", "PLOTTING"]),
    MenuItemData("DRIVERS", Icons.person, ["CREATE DRIVER", "LIST OF DRIVERS", "LIST OF INACTIVE DRIVERS", "LIST OF LOGGED IN DRIVERS", "LIST OF LOGGED OUT DRIVERS", "CREATE DRIVER COMMISSION", "LIST OF DRIVER COMMISSION"]),
    MenuItemData("ACCOUNTS", Icons.account_circle, ["CREATE ACCOUNT", "LIST OF ACCOUNTS", "CREATE CUSTOMER INVOICE", "LIST OF CUSTOMER INVOICES", "CREATE ACCOUNT INVOICE", "LIST OF ACCOUNT INVOICES"]),
    MenuItemData("VEHICLES", Icons.directions_car, ["CREATE VEHICLE TYPE", "LIST OF VEHICLE TYPES", "CREATE COMPANY VEHICLE", "LIST OF COMPANY VEHICLE"]),
    MenuItemData("USERS", Icons.supervised_user_circle, ["CREATE USER", "LIST OF USER", "AUTHORIZATION"]),
    MenuItemData("SUBSIDIARY", Icons.supervised_user_circle, ["CREATE SUBSIDIARY", "LIST OF SUBSIDIARIES"]),
    MenuItemData("REPORTS", Icons.receipt_long, ["DRIVER", "BOOKINGS", "CALL", "INCOME", "PCO"]),
    MenuItemData("SETTINGS", Icons.settings, ["COMPANY INFORMATION", "COMPANY CONFIGURATION", "DOCUMENT NUMBER", "TEMPLATE SETTINGS", "BOOKING CLEARING UTILITY", "LOCATION TYPE SHORTCUTS", "VOIP SETTINGS", "GENERAL SMS CONFIG", "SMS SETTINGS", "CHAT WITH DRIVER AND PASSENGER", "PERMISSION SETTINGS"]),
  ];

  int selectedIndex = 0;
  int dropdownIndex = 0;
  bool isDropdownOpen = false;


  @override
  void initState() {
    super.initState();
    RawKeyboard.instance.addListener(_handleKey);
  }

  @override
  void dispose() {
    RawKeyboard.instance.removeListener(_handleKey);
    super.dispose();
  }

  void _handleKey(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      // Debug print key pressed
      print("Pressed key: ${event.logicalKey}");
      print("Key label: ${event.logicalKey.keyLabel}");
      if(event.logicalKey.keyLabel == "F#"){
        dashBoardCntrl.shortCutKeyValue.value = "alert";
      }
      if(event.logicalKey.keyLabel == "Escape" &&
          dashBoardCntrl.shortCutKeyValue.value == "alert"){
        dashBoardCntrl.shortCutKeyValue.value = "shortCutKey";
      }
      }
    if (event is RawKeyDownEvent && dashBoardCntrl.shortCutKeyValue.value != "alert") {
      if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        setState(() {
          selectedIndex = (selectedIndex + 1) % menus.length;
        });
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        setState(() {
          selectedIndex = (selectedIndex - 1 + menus.length) % menus.length;
        });
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        if (isDropdownOpen) {
          setState(() {
            dropdownIndex = (dropdownIndex + 1) % menus[selectedIndex].subItems.length;
          });
        } else {
          setState(() {
            isDropdownOpen = true;
          });
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        if (isDropdownOpen) {
          setState(() {
            dropdownIndex = (dropdownIndex - 1 + menus[selectedIndex].subItems.length) %
                menus[selectedIndex].subItems.length;
          });
        }
      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
        if (isDropdownOpen) {
          String selectedItem = menus[selectedIndex].subItems[dropdownIndex];
          widget.onSelect?.call(selectedItem);
          setState(() {
            selectedTexts.remove(selectedItem);
            selectedTexts.add(selectedItem);
            isDropdownOpen = false;
          });
        } else {
          setState(() {
            isDropdownOpen = true;
          });
        }
      } else if (event.logicalKey == LogicalKeyboardKey.escape) {
        setState(() {
          isDropdownOpen = false;
        });
      }
    }
  }
  FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return RawKeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKey: (RawKeyEvent event) {
        if (event is RawKeyDownEvent) {
          final key = event.logicalKey;
          print('Pressed key: ${key.debugName}'); // e.g., "F1"
          print('Key code: ${event.data}'); // e.g., 112 (optional for fine-tuned web detection)
        if(key.debugName == "F3"){
          dashBoardCntrl.shortCutKeyValue.value = "alert";
          // set up the AlertDialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                scrollable: true,

                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppText.driverInfo,
                      style: mozillaTextSemiBoldText(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: DynamicColors.textClr
                      ),
                    ),
                    GestureDetector(
                        onTap: (){
                          dashBoardCntrl.shortCutKeyValue.value = "arrow";
                          Get.back();
                        },
                        child: Icon(Icons.close)),
                  ],
                ),
                content: F3AlertWidget(),
                actions: [
                  // cancelButton,
                  // continueButton,
                ],
              );
            },
          ).then((result) {
            dashBoardCntrl.shortCutKeyValue.value = "shortCutKey";
            print("Alert closed");
            print("Close reason: $result");
            // Yahan aap custom action le sakte ho
          });
        }else if (key.debugName == "F4"){
          dashBoardCntrl.shortCutKeyValue.value = "alert";
          // set up the AlertDialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                scrollable: true,

                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppText.driverEarning,
                    style: mozillaTextSemiBoldText(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: DynamicColors.textClr
                    ),
                    ),
                    GestureDetector(
                        onTap: (){
                          dashBoardCntrl.shortCutKeyValue.value = "arrow";
                          Get.back();
                        },
                        child: Icon(Icons.close)),
                  ],
                ),
                content: F4AlertWidget(),
                actions: [
                  // cancelButton,
                  // continueButton,
                ],
              );
            },
          ).then((result) {
            dashBoardCntrl.shortCutKeyValue.value = "shortCutKey";
            print("Alert closed");
            print("Close reason: $result");
            // Yahan aap custom action le sakte ho
          });
        }
        }
      },
      child: Scaffold(
        backgroundColor: Color(0xFFEEF0F3),
        body: SafeArea(
          child: Stack(
            children: [

              Column(
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
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    if (selectedIndex == i) {
                                      isDropdownOpen = !isDropdownOpen;
                                    } else {
                                      selectedIndex = i;
                                      isDropdownOpen = true;
                                    }
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: selectedIndex == i ? Colors.white24 : Colors.transparent,
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
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.cyanAccent.shade400,
                            child: Icon(Icons.email, color: DynamicColors.whiteClr),
                          ),
                          SizedBox(width: 15),
                          Icon(Icons.notifications, color: Colors.cyanAccent.shade400),
                          SizedBox(width: 15),
                          Icon(Icons.power_settings_new, color: Colors.red),
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
                                return Container(
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
                        getSelectedWidget(

                        ),
                      ],
                    ),
                    ),
                  )
                // ),
                ],
              ),
              // 🔽 Dropdown - Show only if open
              if (isDropdownOpen)
                Column(
                  children: [
                    SizedBox(
                      height: 70,
                    ),
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
                          itemCount: menus[selectedIndex].subItems.length,
                          itemBuilder: (context, j) {
                            return Container(
                              color: dropdownIndex == j ? Colors.blueAccent : Colors.transparent,
                              child: ListTile(
                                title: Text(
                                  menus[selectedIndex].subItems[j],
                                  style: TextStyle(
                                    color: dropdownIndex == j ? Colors.white : Colors.black,
                                  ),
                                ),
                                onTap: () {
                                  final selectedItem = menus[selectedIndex].subItems[j];
                                  widget.onSelect?.call(selectedItem);
                                  setState(() {
                                    selectedTexts.remove(selectedItem);
                                    selectedTexts.add(selectedItem);
                                    dropdownIndex = j;
                                    isDropdownOpen = false;
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
            ],
          ),
        ),
      ),
    );

  }

  Widget getSelectedWidget({GestureTapCallback? onTap}) {
    if (selectedTexts.isEmpty) return ByDefaultDashboard();

    switch (selectedTexts.last) {
      case 'LIST OF BOOKINGS':
        return BookingList();
      case 'Option 2':
        return Text("text 2");
      case 'Option 3':
        return Text("text 3");
      default:
        return ByDefaultDashboard();
    }
  }


}

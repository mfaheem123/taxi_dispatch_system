

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../tabbarview.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';


import 'package:nested_menu_bar/nested_menu_bar.dart';

class MainAppBar extends StatelessWidget {
  MainAppBar({super.key});

  DashboardController controller = Get.isRegistered<DashboardController>()
      ? Get.find<DashboardController>()
      : Get.put(DashboardController());

  late final List<GlobalKey> menuKeys;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (controller) {
        return Container(
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
                        shortCutKeyValue.value = 'shortCutKey';
                        if (controller.selectedIndex == i) {
                          controller.isDropdownOpen = !controller.isDropdownOpen;
                        } else {
                          controller.selectedIndex = i;
                          controller.isDropdownOpen = true;
                        }
                        controller.update();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                        decoration: BoxDecoration(
                          color: controller.selectedIndex == i ? Colors.white24 : Colors.transparent,
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
                SizedBox(width: MediaQuery.of(context).size.width / 7.3),
              ],
            ),
          ),
        );
      }
    );
  }

  final List<MenuItemData> menus = [
    MenuItemData("BOOKINGS", Icons.book_online, ["CREATE BOOKINGS", "LIST OF BOOKINGS", "LIST OF WEB BOOKINGS", "LIST OF APP BOOKINGS", "LIST OF MULTI BOOKINGS", "LIST OF TRASH BOOKINGS"]),
    MenuItemData("CUSTOMERS", Icons.headset_mic, ["CREATE BOOKINGS", "LIST OF BOOKINGS", "LIST OF WEB BOOKINGS", "LIST OF APP BOOKINGS", "LIST OF MULTI BOOKINGS", "LIST OF TRASH BOOKINGS"]),
    MenuItemData("FARES", Icons.wallet_outlined, ["CREATE FARE SETTINGS", "CREATE FIXED FARE SETTINGS", "CREATE FARE BY VEHICLE SETTINGS"]),
    MenuItemData("LOCATIONS", Icons.location_pin, ["CREATE LOCATIONS", "LIST OF LOCATIONS", "CREATE ZONE", "LIST OF ZONES", "LOCALIZATION", "PLOTTING"]),
    MenuItemData("DRIVERS", Icons.person, ["CREATE DRIVER", "LIST OF DRIVERS", "LIST OF INACTIVE DRIVERS", "LIST OF LOGGED IN DRIVERS", "DRIVER APP FEATURES", "LIST OF LOGGED OUT DRIVERS", "CREATE DRIVER COMMISSION", "LIST OF DRIVER COMMISSION"]),
    MenuItemData("ACCOUNTS", Icons.account_circle, ["CREATE ACCOUNT", "LIST OF ACCOUNTS", "CREATE CUSTOMER INVOICE", "LIST OF CUSTOMER INVOICES", "CREATE ACCOUNT INVOICE", "LIST OF ACCOUNT INVOICES"]),
    MenuItemData("VEHICLES", Icons.directions_car, ["CREATE VEHICLE TYPE", "LIST OF VEHICLE TYPES", "CREATE COMPANY VEHICLE", "LIST OF COMPANY VEHICLE"]),
    MenuItemData("USERS", Icons.supervised_user_circle, ["CREATE USER", "LIST OF USER", "AUTHORIZATION"]),
    MenuItemData("SUBSIDIARY", Icons.supervised_user_circle, ["CREATE SUBSIDIARY", "LIST OF SUBSIDIARIES"]),
    MenuItemData("REPORTS", Icons.receipt_long, ["DRIVER", "BOOKINGS", "CALL", "INCOME", "PCO"]),
    MenuItemData("SETTINGS", Icons.settings, ["COMPANY INFORMATION", "COMPANY CONFIGURATION", "DOCUMENT NUMBER", "TEMPLATE SETTINGS", "BOOKING CLEARING UTILITY", "LOCATION TYPE SHORTCUTS", "VOIP SETTINGS", "GENERAL SMS CONFIG", "SMS SETTINGS", "CHAT WITH DRIVER AND PASSENGER", "PERMISSION SETTINGS"]),
  ];
}



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final List<NestedMenuItem> hoverMenu;
  @override
  void initState() {
    super.initState();
    hoverMenu = _makeMenus(context);
  }

  void message(context, String text) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final snackBar = SnackBar(
      content: Text(text),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              NestedMenuBar(
                menuBarPadding: 0.0,
                menus: hoverMenu,
                popUpMenuItemBorderRadius: 8,
                menuBarDecoration: BoxDecoration(
                  color: Colors.black,
                ),
                menuBarItemHoverColor: Colors.white,
                menuBarItemColor: Colors.grey,
                popUpDecoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: Colors.grey,width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                popUpPadding: 3,
                popUpMenuItemHoverForegroundColor:  Colors.white,
                popUpMenuItemForegroundColor: Colors.grey,
                popUpMenuItemBackgroundColor: Colors.black,
                popUpMenuItemHoverBackgroundColor: Colors.grey,
              ),
              Text("Content goes here")
            ],
          ),
        )
    );
  }

  List<NestedMenuItem> _makeMenus(BuildContext context) {
    return [
      NestedMenuItem(
          title: "BOOKINGS",
          children: [
            NestedMenuItem(title: "CREATE BOOKINGS",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "LIST OF BOOKINGS",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "LIST OF WEB BOOKINGS",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "LIST OF APP BOOKINGS",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "LIST OF MULTI BOOKINGS",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "LIST OF TRASH BOOKINGS",onTap: () => message(context, "DevOps"),),
            // NestedMenuItem(title: "App Development",onTap: () => message(context, "App Development"),
            //     children: [
            //       NestedMenuItem(title: "Mobile App Development",
            //         onTap: () => message(context, "Mobile App Development"),
            //         children: [
            //           NestedMenuItem(title: "Native App Development",onTap: () => message(context, "Native App Development"),
            //               children: [
            //                 NestedMenuItem(title: "Android App Development",onTap: () => message(context, "Android App Development"),),
            //                 NestedMenuItem(title: "iOS App Development",onTap: () => message(context, "iOS App Development"),),]),
            //           NestedMenuItem(title: "Cross Platform Development",onTap: () => message(context, "Cross Platform Development"),
            //             children: [
            //               NestedMenuItem(title: "Flutter App Development",onTap: () => message(context, "Flutter App Development"),),
            //               NestedMenuItem(title: "React Native App Development",onTap: () => message(context, "React Native App Development"),),],),],),
            //       NestedMenuItem(title: "Web App Development",onTap: () => message(context, "Web App Development"),),
            //     ]
            // ),
          ]
      ),
      NestedMenuItem(
          title: "CUSTOMERS",
          children: [
            NestedMenuItem(title: "CREATE BOOKINGS",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "LIST OF BOOKINGS",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "LIST OF WEB BOOKINGS",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "LIST OF APP BOOKINGS",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "LIST OF MULTI BOOKINGS",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "LIST OF TRASH BOOKINGS",onTap: () => message(context, "DevOps"),),
          ]
      ),
      NestedMenuItem(
          title: "FARES",
          children: [
            NestedMenuItem(title: "CREATE FARE SETTINGS",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "CREATE FIXED FARE SETTINGS",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "CREATE FARE BY VEHICLE SETTINGS",onTap: () => message(context, "DevOps"),),
          ]
      ),
      NestedMenuItem(
          title: "LOCATIONS",
          children: [
            NestedMenuItem(title: "CREATE LOCATIONS",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "LIST OF LOCATIONS",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "CREATE ZONE",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "LIST OF ZONES",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "LOCALIZATION",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "PLOTTING",onTap: () => message(context, "DevOps"),),
          ]
      ),
      NestedMenuItem(
          title: "DRIVERS",
          children: [
            NestedMenuItem(title: "CREATE DRIVER",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "LIST OF DRIVERS",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "LIST OF INACTIVE DRIVERS",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "LIST OF LOGGED IN DRIVERS",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "DRIVER APP FEATURES",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "LIST OF LOGGED OUT DRIVERS",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "CREATE DRIVER COMMISSION",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "LIST OF DRIVER COMMISSION",onTap: () => message(context, "DevOps"),),
          ]
      ),
      NestedMenuItem(
          title: "ACCOUNTS",
          children: [
            NestedMenuItem(title: "CREATE ACCOUNT",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "LIST OF ACCOUNTS",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "CREATE CUSTOMER INVOICE",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "LIST OF CUSTOMER INVOICES",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "CREATE ACCOUNT INVOICE",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "LIST OF ACCOUNT INVOICES",onTap: () => message(context, "DevOps"),),
          ]
      ),
      NestedMenuItem(
          title: "VEHICLES",
          children: [
            NestedMenuItem(title: "CREATE VEHICLE TYPE",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "LIST OF VEHICLE TYPES",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "CREATE COMPANY VEHICLE",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "LIST OF COMPANY VEHICLE",onTap: () => message(context, "DevOps"),),
          ]
      ),
      NestedMenuItem(
          title: "USERS",
          children: [
            NestedMenuItem(title: "CREATE USER",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "LIST OF USER",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "AUTHORIZATION",onTap: () => message(context, "DevOps"),),
          ]
      ),
      NestedMenuItem(
          title: "SUBSIDIARY",
          children: [
            NestedMenuItem(title: "CREATE SUBSIDIARY",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "LIST OF SUBSIDIARIES",onTap: () => message(context, "DevOps"),),
          ]
      ),
      NestedMenuItem(
          title: "REPORTS",
          children: [
            NestedMenuItem(title: "DRIVER",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "BOOKINGS",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "CALL",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "INCOME",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "PCO",onTap: () => message(context, "DevOps"),),
          ]
      ),
      NestedMenuItem(
          title: "SETTINGS",
          children: [
            NestedMenuItem(title: "COMPANY INFORMATION",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "COMPANY CONFIGURATION",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "DOCUMENT NUMBER",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "TEMPLATE SETTINGS",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "BOOKING CLEARING UTILITY",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "LOCATION TYPE SHORTCUTS",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "VOIP SETTINGS",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "GENERAL SMS CONFIG",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "SMS SETTINGS",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "CHAT WITH DRIVER AND PASSENGER",onTap: () => message(context, "DevOps"),),
            NestedMenuItem(title: "PERMISSION SETTINGS",onTap: () => message(context, "DevOps"),),
          ]
      ),
    ];
  }

}
import 'package:dashboard_new1/component/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../component/textStyle.dart';
import 'controller/authorization_controller.dart';

class AuthorizationScreen extends StatefulWidget {
  const AuthorizationScreen({super.key});

  @override
  State<AuthorizationScreen> createState() => _AuthorizationScreenState();
}

class _AuthorizationScreenState extends State<AuthorizationScreen> {
  AuthorizationController controller =
      Get.isRegistered<AuthorizationController>()
          ? Get.find<AuthorizationController>()
          : Get.put(AuthorizationController());

  String selectedMenu = "FARE";

  // Menu items
  final List<String> menuItems = [
    "SETTINGS",
    "SUBSIDIARY",
    "EMPLOYEE",
    "VEHICLE",
    "CUSTOMER",
    "DRIVER",
    "ACCOUNT",
    "FARE",
    "LOCATION",
    "BOOKING",
    "INVOICE",
  ];

  final Map<String, List<Map<String, List<String>>>> permissions = {
    "SETTINGS": [
      {
        "COMPANY SETTINGS": [
          "UPDATE COMPANY INFORMATION",
          "READ COMPANY INFORMATIONS",
          "UPDATE COMPANY CONFIGURATION",
          "READ COMPANY CONFIGURATIONS",
          "CREATE USER",
          "READ VOIP SETTINGS",
          "CREATE SMS TEMPLATE",
        ]
      },
      {
        "TEMPLATE": [
          "CREATE TEMPLATE",
          // "READ TEMPLATES",
          "READ TEMPLATE",
          "UPDATE TEMPLATE",
          "DELETE TEMPLATE",
        ],
      },
      {
        "TEMPLATE TYPE": [
          "CREATE TEMPLATE TYPE",
          // "READ TEMPLATE TYPES",
          "READ TEMPLATE TYPE",
          "UPDATE TEMPLATE TYPE",
          "DELETE TEMPLATE TYPE",
        ],
      },
      {
        "DOCUMENT NUMBER": [
          "CREATE DOCUMENT NUMBER",
          // "READ DOCUMENT NUMBERS",
          "READ DOCUMENT NUMBER",
          "UPDATE DOCUMENT NUMBER",
          "DELETE DOCUMENT NUMBER",
        ],
      },
      {
        "FEEDBACK": [
          "CREATE FEEDBACK",
          // "READ FEEDBACKS",
          "READ FEEDBACK",
          "UPDATE FEEDBACK",
          "DELETE FEEDBACK",
        ],
      },
      {
        "MESSAGE": [
          "CREATE MESSAGE",
          // "READ MESSAGES",
          "READ MESSAGE",
          "UPDATE MESSAGE",
          "DELETE MESSAGE",
        ],
      },
      {
        "NOTIFICATION": [
          "CREATE NOTIFICATION",
          // "READ NOTIFICATIONS",
          "READ NOTIFICATION",
          "UPDATE NOTIFICATION",
          "DELETE NOTIFICATION",
        ],
      },
      {
        "AUDIT": [
          "CREATE AUDIT",
          // "READ AUDITS",
          "READ AUDIT",
          "UPDATE AUDIT",
          "DELETE AUDIT",
        ],
      },
    ],
    "SUBSIDIARY": [
      {
        "SUBSIDIARY": [
          "CREATE SUBSIDIARY",
          "READ SUBSIDIARY",
          // "READ SUBSIDIARIES",
          "UPDATE SUBSIDIARY",
          "DELETE SUBSIDIARY",
        ],
      },
    ],
    "EMPLOYEE": [
      {
        "EMPLOYEE": [
          "CREATE EMPLOYEE",
          "READ EMPLOYEE",
          // "READ EMPLOYEES",
          "UPDATE EMPLOYEE",
          "DELETE EMPLOYEE",
        ]
      },
      {
        "ROLE": [
          "READ ROLE",
          // "READ ROLES",
          "UPDATE ROLE",
        ],
      },
      {
        "EMPLOYEE SHIFT HISTORY": [
          "CREATE EMPLOYEE SHIFT HISTORY",
          "READ EMPLOYEE SHIFT HISTORY",
          "UPDATE EMPLOYEE SHIFT HISTORY",
        ],
      },
    ],
    "VEHICLE": [
      {
        "VEHICLE TYPE": [
          "CREATE VEHICLE TYPE",
          "READ VEHICLE TYPE",
          // "READ VEHICLE TYPES",
          "UPDATE VEHICLE TYPE",
          "DELETE VEHICLE TYPE",
        ]
      },
      {
        "COMPANY VEHICLE": [
          "CREATE COMPANY VEHICLE",
          "READ COMPANY VEHICLE",
          // "READ COMPANY VEHICLES",
          "UPDATE COMPANY VEHICLE",
          "DELETE COMPANY VEHICLE",
        ],
      },
      {
        "VEHICLE": [
          "CREATE VEHICLE",
          "READ VEHICLE",
          // "READ VEHICLES",
          "UPDATE VEHICLE",
          "DELETE VEHICLE",
        ],
      },
      {
        "END VEHICLE": [
          "CREATE END VEHICLE",
        ],
      },
    ],
    "CUSTOMER": [
      {
        "CUSTOMER": [
          "CREATE CUSTOMER",
          "READ CUSTOMER",
          // "READ CUSTOMERS",
          "UPDATE CUSTOMER",
          "DELETE CUSTOMER",
        ]
      },
      {
        "LOST PROPERTY": [
          "CREATE LOST PROPERTY",
          "READ LOST PROPERTY",
          // "READ LOST PROPERTIES",
          "UPDATE LOST PROPERTY",
          "DELETE LOST PROPERTY",
        ],
      },
      {
        "COMPLAINT": [
          "CREATE COMPLAINT",
          "READ COMPLAINT",
          // "READ COMPLAINTS",
          "UPDATE COMPLAINT",
          "DELETE COMPLAINT",
        ],
      },
    ],
    "DRIVER": [
      {
        "DRIVER": [
          "CREATE DRIVER",
          "READ DRIVER",
          // "READ DRIVERS",
          "UPDATE DRIVER",
          "DELETE DRIVER",
          "UPDATE DRIVER ZONE",
          "CREATE END DRIVER",
        ]
      },
      {
        "DRIVER SHIFT": [
          "CREATE DRIVER SHIFT",
          "READ DRIVER SHIFT",
          // "READ DRIVER SHIFTS",
          "UPDATE DRIVER SHIFT",
          "DELETE DRIVER SHIFT",
        ],
      },
      {
        "DRIVER AVAILABILITY": [
          "CREATE DRIVER AVAILABILITY",
          "READ DRIVER AVAILABILITY",
          // "READ DRIVER AVAILABILITIES",
          "UPDATE DRIVER AVAILABILITY",
          "DELETE DRIVER AVAILABILITY",
        ],
      },
      {
        "DRIVER BOOKING": [
          "CREATE DRIVER BOOKING",
          "READ DRIVER BOOKING",
          // "READ DRIVER BOOKINGS",
          "UPDATE DRIVER BOOKING",
          "DELETE DRIVER BOOKING",
        ],
      },
      {
        "DRIVER COMMISSION": [
          "CREATE DRIVER COMMISSION",
          "READ DRIVER COMMISSION",
          // "READ DRIVER COMMISSIONS",
          "UPDATE DRIVER COMMISSION",
          "DELETE DRIVER COMMISSION",
        ],
      },
      {
        "DRIVER COMMISSION ACCOUNT": [
          "CREATE DRIVER COMMISSION ACCOUNT",
          "READ DRIVER COMMISSION ACCOUNT",
          // "READ DRIVER COMMISSION ACCOUNTS",
          "UPDATE DRIVER COMMISSION ACCOUNT",
          "DELETE DRIVER COMMISSION ACCOUNT",
        ],
      },
      {
        "DRIVER COMMISSION LINEITEM": [
          "CREATE DRIVER COMMISSION LINEITEM",
          "READ DRIVER COMMISSION LINEITEM",
          // "READ DRIVER COMMISSION LINEITEMS",
          "UPDATE DRIVER COMMISSION LINEITEM",
          "DELETE DRIVER COMMISSION LINEITEM",
        ],
      },
      {
        "DRIVER SHIFT HISTORY": [
          "CREATE DRIVER SHIFT HISTORY",
          "READ DRIVER SHIFT HISTORY",
          // "READ DRIVER SHIFT HISTORIES",
          "UPDATE DRIVER SHIFT HISTORY",
          "DELETE DRIVER SHIFT HISTORY",
        ],
      },
    ],
    "ACCOUNT": [
      {
        "ACCOUNT": [
          "CREATE ACCOUNT",
          "READ ACCOUNT",
          // "READ ACCOUNTS",
          "UPDATE ACCOUNT",
          "DELETE ACCOUNT",
        ],
      },
      {
        "ACCOUNT WEB LOGIN": [
          "CREATE ACCOUNT WEB LOGIN",
          "READ ACCOUNT WEB LOGIN",
          // "READ ACCOUNT WEB LOGINS",
          "UPDATE ACCOUNT WEB LOGIN",
          "DELETE ACCOUNT WEB LOGIN",
        ],
      },
      {
        "ACCOUNT ORDER NUMBER": [
          "CREATE ACCOUNT ORDER NUMBER",
          "READ ACCOUNT ORDER NUMBER",
          // "READ ACCOUNT ORDER NUMBERS",
          "UPDATE ACCOUNT ORDER NUMBER",
          "DELETE ACCOUNT ORDER NUMBER"
        ],
      },
      {
        "ACCOUNT DEPARTMENT": [
          "CREATE ACCOUNT DEPARTMENT",
          "READ ACCOUNT DEPARTMENT",
          // "READ ACCOUNT DEPARTMENTS",
          "UPDATE ACCOUNT DEPARTMENT",
          "DELETE ACCOUNT DEPARTMENT",
        ],
      },
      {
        "ACCOUNT CONTACT": [
          "CREATE ACCOUNT CONTACT",
          "READ ACCOUNT CONTACT",
          // "READ ACCOUNT CONTACTS",
          "UPDATE ACCOUNT CONTACT",
          "DELETE ACCOUNT CONTACT",
        ],
      },
      {
        "ACCOUNT COMPANY ADDRESS": [
          "CREATE ACCOUNT COMPANY ADDRESS",
          "READ ACCOUNT COMPANY ADDRESS",
          // "READ ACCOUNT COMPANY ADDRESSES",
          "UPDATE ACCOUNT COMPANY ADDRESS",
          "DELETE ACCOUNT COMPANY ADDRESS",
        ],
      },
    ],
    "FARE": [
      {
        "FARE CONFIGURATION": [
          "CREATE FARE CONFIGURATION",
          "READ FARE CONFIGURATION",
          // "READ FARE CONFIGURATIONS",
          "UPDATE FARE CONFIGURATION",
          "DELETE FARE CONFIGURATION",
        ]
      },
      {
        "FIXED FARE": [
          "CREATE FIXED FARE",
          "READ FIXED FARE",
          // "READ FIXED FARES",
          "UPDATE FIXED FARE",
          "DELETE FIXED FARE"
        ]
      },
      {
        "FARE BY VEHICLE": [
          "CREATE FARE BY VEHICLE",
          "READ FARE BY VEHICLE",
          // "READ FARE BY VEHICLES",
          "UPDATE FARE BY VEHICLE",
          "DELETE FARE BY VEHICLE",
        ]
      },
      {
        "FARE CONFIGURATION MILEAGE": [
          "CREATE FARE CONFIGURATION MILEAGE",
          "READ FARE CONFIGURATION MILEAGE",
          // "READ FARE CONFIGURATION MILEAGES",
          "UPDATE FARE CONFIGURATION MILEAGE",
          "DELETE FARE CONFIGURATION MILEAGE",
        ]
      },
    ],
    "LOCATION": [
      {
        "LOCATION TYPE": [
          "CREATE LOCATION TYPE",
          "READ LOCATION TYPE",
          // "READ LOCATION TYPES",
          "UPDATE LOCATION TYPE",
          "DELETE LOCATION TYPE",
        ],
      },
      {
        "LOCATION": [
          "CREATE LOCATION",
          "READ LOCATION",
          // "READ LOCATIONS",
          "UPDATE LOCATION",
          "DELETE LOCATION",
        ],
      },
      {
        "LOCALIZATION DETAIL": [
          "CREATE LOCALIZATION DETAIL",
          "READ LOCALIZATION DETAIL",
          // "READ LOCALIZATION DETAILS",
          "UPDATE LOCALIZATION DETAIL",
          "DELETE LOCALIZATION DETAIL",
        ],
      },
      {
        "MAIN DATA": [
          "CREATE MAIN DATA",
          "READ MAIN DATA",
          // "READ MAIN DATAS",
          "UPDATE MAIN DATA",
          "DELETE MAIN DATA",
        ],
      },
      {
        "DETAIL DATAS": [
          "CREATE DETAIL DATA",
          "READ DETAIL DATA",
          // "READ DETAIL DATAS",
          "UPDATE DETAIL DATA",
          "DELETE DETAIL DATA",
        ],
      },
      {
        "ZONE": [
          "CREATE ZONE",
          "READ ZONE",
          // "READ ZONES",
          "UPDATE ZONE",
          "DELETE ZONE",
        ],
      },
    ],
    "BOOKING": [
      {
        "JOURNEY TYPE": [
          "CREATE JOURNEY TYPE",
          "READ JOURNEY TYPE",
          // "READ JOURNEY TYPES",
          "UPDATE JOURNEY TYPE",
          "DELETE JOURNEY TYPE",
        ],
      },
      {
        "PAYMENT TYPE": [
          "CREATE PAYMENT TYPE",
          "READ PAYMENT TYPE",
          // "READ PAYMENT TYPES",
          "UPDATE PAYMENT TYPE",
          "DELETE PAYMENT TYPE",
        ],
      },
      {
        "BOOKING": [
          "CREATE BOOKING",
          "READ BOOKING",
          // "READ BOOKINGS",
          "UPDATE BOOKING",
          "DELETE BOOKING",
        ],
      },
      {
        "BOOKING ROUTE": [
          "CREATE BOOKING ROUTE",
          "READ BOOKING ROUTE",
          // "READ BOOKING ROUTES",
          "UPDATE BOOKING ROUTE",
          "DELETE BOOKING ROUTE",
        ],
      },
      {
        "TRASH BOOKING": [
          "CREATE TRASH BOOKING",
          "READ TRASH BOOKING",
          // "READ TRASH BOOKINGS",
          "UPDATE TRASH BOOKING",
          "DELETE TRASH BOOKING",
        ],
      },
      {
        "BOOKING AUDIT": [
          "CREATE BOOKING AUDIT",
          "READ BOOKING AUDIT",
          // "READ BOOKING AUDITS",
          "UPDATE BOOKING AUDIT",
          "DELETE BOOKING AUDIT",
        ],
      },
    ],
    "INVOICE": [
      {
        "CUSTOMER INVOICE": [
          "CREATE CUSTOMER INVOICE",
          "READ CUSTOMER INVOICE",
          // "READ CUSTOMER INVOICES",
          "UPDATE CUSTOMER INVOICE",
          "DELETE CUSTOMER INVOICE",
        ],
      },
      {
        "CUSTOMER INVOICE LINEITEM": [
          "CREATE CUSTOMER INVOICE LINEITEM",
          "READ CUSTOMER INVOICE LINEITEM",
          // "READ CUSTOMER INVOICE LINEITEMS",
          "UPDATE CUSTOMER INVOICE LINEITEM",
          "DELETE CUSTOMER INVOICE LINEITEM",
        ],
      },
      {
        "ACCOUNT INVOICE": [
          "CREATE ACCOUNT INVOICE",
          "READ ACCOUNT INVOICE",
          // "READ ACCOUNT INVOICES",
          "UPDATE ACCOUNT INVOICE",
          "DELETE ACCOUNT INVOICE",
        ],
      },
      {
        "ACCOUNT INVOICE LINEITEM": [
          "CREATE ACCOUNT INVOICE LINEITEM",
          "READ ACCOUNT INVOICE LINEITEM",
          // "READ ACCOUNT INVOICE LINEITEMS",
          "UPDATE ACCOUNT INVOICE LINEITEM",
          "DELETE ACCOUNT INVOICE LINEITEM",
        ],
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return GetBuilder<AuthorizationController>(builder: (controller) {
      return Container(
        width: w,
        height: h,
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // SizedBox(
                //   width: 250,
                //   child: DropdownButtonFormField<String>(
                //     decoration: const InputDecoration(
                //         border: OutlineInputBorder(),
                //         labelText: "Select Role"),
                //     items: const [
                //       DropdownMenuItem(
                //           value: "admin", child: Text("Admin")),
                //       DropdownMenuItem(value: "user", child: Text("User")),
                //     ],
                //     onChanged: (value) {},
                //   ),
                // ),

                SizedBox(
                  width: 250,
                  child: controller.rolesLoader
                      ? const Center(child: CircularProgressIndicator())
                      : DropdownButtonFormField<int>(
                          value: controller.selectedRoleId,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "SELECT ROLE"),
                          items: controller.getRoleModel?.roles?.map((role) {
                                return DropdownMenuItem<int>(
                                  value: role.id,
                                  child: Text((role.name ?? "").toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 17,
                                      )),
                                );
                              }).toList() ??
                              [],
                          onChanged: (value) {
                            controller.selectedRoleId = value;
                            controller.fetchPermissions(value!);
                            controller.update();
                            print("Selected Role ID: $value");
                          },
                        ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "AUTHORIZATION",
                      style: mozillaTextSemiBoldText(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                // ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: DynamicColors.primaryClr,
                //     padding: const EdgeInsets.symmetric(
                //         horizontal: 30, vertical: 16),
                //   ),
                //   onPressed: () {},
                //   child: const Text("SAVE",
                //       style: TextStyle(color: Colors.white, fontSize: 16)),
                // ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DynamicColors.primaryClr,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 16),
                  ),
                  onPressed: (controller.rolesLoader || controller.saveLoader)
                      ? null
                      : () => controller.savePermissions(),
                  child: controller.saveLoader
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Text(
                    "SAVE",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Sidebar

                  Container(
                    width: 200,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: ListView(
                      children: menuItems
                          .map((item) => _menuItem(item,
                                  selected: item == selectedMenu, onTap: () {
                                setState(() {
                                  selectedMenu = item;
                                });
                              }))
                          .toList(),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Right Side Permission Panels
                  // Expanded(
                  //   child: permissions[selectedMenu] == null
                  //       ? const Center(child: Text("No Permissions Configured"))
                  //       : GridView.count(
                  //           crossAxisCount: w > 1200 ? 4 : 2,
                  //           crossAxisSpacing: 16,
                  //           mainAxisSpacing: 16,
                  //           children: permissions[selectedMenu]!
                  //               .map((card) => _permissionCard(
                  //                   card.keys.first, card.values.first))
                  //               .toList(),
                  //         ),
                  // )
                  // Right Side Permission Panels
                  // Expanded(
                  //   child: permissions[selectedMenu] == null
                  //       ? const Center(child: Text("No Permissions Configured"))
                  //       : GridView.builder(
                  //     // Logic: Agar cards 3 ya 6 hain to 3 dikhao, warna 4 dikhao
                  //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //       crossAxisCount: (permissions[selectedMenu]!.length == 3 || permissions[selectedMenu]!.length == 6) ? 3 : 4,
                  //       crossAxisSpacing: 16,
                  //       mainAxisSpacing: 16,
                  //       childAspectRatio: 0.9, // Isse aap height control kar sakte hain (increase/decrease)
                  //     ),
                  //     itemCount: permissions[selectedMenu]!.length,
                  //     itemBuilder: (context, index) {
                  //       final card = permissions[selectedMenu]![index];
                  //       return _permissionCard(card.keys.first, card.values.first);
                  //     },
                  //   ),
                  // )

                  Expanded(
                    child: permissions[selectedMenu] == null
                        ? const Center(child: Text("NO PERMISSIONS CONFIGURED"))
                        : LayoutBuilder(
                            builder: (context, constraints) {
                              int crossAxisCount =
                                  (permissions[selectedMenu]!.length == 3 ||
                                          permissions[selectedMenu]!.length ==
                                              6)
                                      ? 3
                                      : 4;

                              double cardWidth = (constraints.maxWidth -
                                      (crossAxisCount - 1) * 16) /
                                  crossAxisCount;
                              double fixedHeight = 500;
                              double dynamicAspectRatio =
                                  cardWidth / fixedHeight;

                              return GridView.builder(
                                padding: const EdgeInsets.only(bottom: 20),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: dynamicAspectRatio,
                                ),
                                itemCount: permissions[selectedMenu]!.length,
                                itemBuilder: (context, index) {
                                  final card =
                                      permissions[selectedMenu]![index];
                                  return _permissionCard(
                                      card.keys.first, card.values.first);
                                },
                              );
                            },
                          ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  // Sidebar Menu
  Widget _menuItem(String title,
      {bool selected = false, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: selected ? DynamicColors.primaryClr : Colors.transparent,
        borderRadius: BorderRadius.circular(30),
      ),
      child: ListTile(
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: selected ? Colors.white : DynamicColors.primaryClr,
              fontWeight: FontWeight.bold),
        ),
        onTap: onTap,
      ),
    );
  }

  // Permission Panel
  Widget _permissionCard(String title, List<String> options) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const Divider(),
          ...options.map((opt) {
            String key = _convertToApiKey(opt);
            // Map<String, dynamic> fullPermissions = controller.getAuthorizationByRoleIdModel?.permissions?.toJson() ?? {};
            bool isActive = controller.localPermissions[key] ?? false;
            // print("UI Check -> Key: $key | IsActive: $isActive");

            return Row(
              children: [
                Switch(
                    value: isActive,
                    onChanged: (val) {
                      controller.togglePermission(key, val);
                    }),
                Expanded(
                  child: Text(
                    opt,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  String _convertToApiKey(String text) {
    return text.toLowerCase().trim().replaceAll(" ", "_");
  }
}

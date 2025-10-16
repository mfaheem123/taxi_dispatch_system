import 'package:dashboard_new1/component/color.dart';
import 'package:flutter/material.dart';

class AuthorizationScreen extends StatefulWidget {
  const AuthorizationScreen({super.key});

  @override
  State<AuthorizationScreen> createState() => _AuthorizationScreenState();
}

class _AuthorizationScreenState extends State<AuthorizationScreen> {
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

  // Permissions data for each menu
  final Map<String, List<Map<String, List<String>>>> permissions = {
    "FARE": [
      {
        "FARE CONFIGURATION": [
          "Create Fare Configuration",
          "Read Fare Configuration",
          "Read Fare Configurations",
          "Update Fare Configuration",
        ]
      },
      {
        "FIXED FARE": [
          "Create Fixed Fare",
          "Read Fixed Fare",
          "Read Fixed Fares",
          "Update Fixed Fare",
        ]
      },
      {
        "FARE BY VEHICLE": [
          "Create Fare By Vehicle",
          "Read Fare By Vehicle",
          "Read Fare By Vehicles",
          "Update Fare By Vehicle",
        ]
      },
      {
        "FARE CONFIGURATION MILEAGE": [
          "Create Fare Configuration Mileage",
          "Read Fare Configuration Mileage",
          "Read Fare Configuration Mileages",
          "Update Fare Configuration Mileage",
        ]
      },
    ],
    "EMPLOYEE": [
      {
        "EMPLOYEE MANAGEMENT": [
          "Create Employee",
          "Read Employee",
          "Read Employees",
          "Update Employee",
        ]
      },
    ],
    "VEHICLE": [
      {
        "VEHICLE MANAGEMENT": [
          "Create Vehicle",
          "Read Vehicle",
          "Read Vehicles",
          "Update Vehicle",
        ]
      },
    ],
    "CUSTOMER": [
      {
        "CUSTOMER MANAGEMENT": [
          "Create Customer",
          "Read Customer",
          "Read Customers",
          "Update Customer",
        ]
      },
    ],
    "DRIVER": [
      {
        "DRIVER MANAGEMENT": [
          "Create Driver",
          "Read Driver",
          "Read Drivers",
          "Update Driver",
        ]
      },
    ],
    // baki ke liye tum apne cards add kar lena
  };

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

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
              SizedBox(
                width: 250,
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Select Role"),
                  items: const [
                    DropdownMenuItem(value: "admin", child: Text("Admin")),
                    DropdownMenuItem(value: "user", child: Text("User")),
                  ],
                  onChanged: (value) {},
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: DynamicColors.primaryClr,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                ),
                onPressed: () {},
                child: const Text("SAVE",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
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
                Expanded(
                  child: permissions[selectedMenu] == null
                      ? const Center(
                          child: Text("No Permissions Configured"),
                        )
                      : GridView.count(
                          crossAxisCount: w > 1200 ? 4 : 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          children: permissions[selectedMenu]!
                              .map((card) => _permissionCard(
                                  card.keys.first, card.values.first))
                              .toList(),
                        ),
                )
              ],
            ),
          ),
        ],
      ),
    );
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const Divider(),
          ...options.map((opt) => Row(
                children: [
                  Switch(value: false, onChanged: (val) {}),
                  Expanded(
                      child: Text(opt, style: const TextStyle(fontSize: 13))),
                ],
              )),
        ],
      ),
    );
  }
}

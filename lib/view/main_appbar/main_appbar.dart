import 'package:dashboard_new1/component/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../component/color.dart';
import '../../tabbarview.dart';
import '../accounts/Invoice/invoice_list.dart';
import '../accounts/account/account_view.dart';
import '../accounts/account/create_escopt.dart';
import '../accounts/list_of_accountScreen.dart';
import '../administration/User/create_userScreen.dart';
import '../administration/User/user_listScreen.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';

import 'package:nested_menu_bar/nested_menu_bar.dart';

import '../dashboard_view/dashboard/defult_dashboard_view.dart';
import '../drivers_view/driver/bulk_driver_commission/bulk_driver_commission.dart';
import '../drivers_view/driver/bulk_driver_commission/bulk_driver_rent.dart';
import '../drivers_view/driver/driver_app_features/driver_app_feature_screen.dart';
import '../drivers_view/driver/driver_commission/create_driver_rent.dart';
import '../drivers_view/driver/driver_commission/driver_commission.dart';
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
import '../locations_view/location/zone_listScreen.dart';
import '../locations_view/location/zone_screen.dart';
import '../setting/template_settings.dart';

class MainAppBar extends StatelessWidget {
  MainAppBar({super.key});

  DashboardController controller = Get.isRegistered<DashboardController>()
      ? Get.find<DashboardController>()
      : Get.put(DashboardController());

  late final List<GlobalKey> menuKeys;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(builder: (controller) {
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
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 3),
                      decoration: BoxDecoration(
                        color: controller.selectedIndex == i
                            ? Colors.white24
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(menus[i].icon, color: Colors.white, size: 16),
                          const SizedBox(width: 5),
                          Text(
                            menus[i].label,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
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
    });
  }

  final List<MenuItemData> menus = [
    MenuItemData("BOOKINGS", Icons.book_online, [
      "CREATE BOOKINGS",
      "LIST OF BOOKINGS",
      "LIST OF WEB BOOKINGS",
      "LIST OF APP BOOKINGS",
      "LIST OF MULTI BOOKINGS",
      "LIST OF TRASH BOOKINGS"
    ]),
    MenuItemData("CUSTOMERS", Icons.headset_mic, [
      "CREATE BOOKINGS",
      "LIST OF BOOKINGS",
      "LIST OF WEB BOOKINGS",
      "LIST OF APP BOOKINGS",
      "LIST OF MULTI BOOKINGS",
      "LIST OF TRASH BOOKINGS"
    ]),
    MenuItemData("FARES", Icons.wallet_outlined, [
      "CREATE FARE SETTINGS",
      "CREATE FIXED FARE SETTINGS",
      "CREATE FARE BY VEHICLE SETTINGS"
    ]),
    MenuItemData("LOCATIONS", Icons.location_pin, [
      "CREATE LOCATIONS",
      "LIST OF LOCATIONS",
      "CREATE ZONE",
      "LIST OF ZONES",
      "LOCALIZATION",
      "PLOTTING"
    ]),
    MenuItemData("DRIVERS", Icons.person, [
      "CREATE DRIVER",
      "LIST OF DRIVERS",
      "LIST OF INACTIVE DRIVERS",
      "LIST OF LOGGED IN DRIVERS",
      "DRIVER APP FEATURES",
      "LIST OF LOGGED OUT DRIVERS",
      "CREATE DRIVER COMMISSION",
      "LIST OF DRIVER COMMISSION"
    ]),
    MenuItemData("ACCOUNTS", Icons.account_circle, [
      "CREATE ACCOUNT",
      "LIST OF ACCOUNTS",
      "CREATE CUSTOMER INVOICE",
      "LIST OF CUSTOMER INVOICES",
      "CREATE ACCOUNT INVOICE",
      "LIST OF ACCOUNT INVOICES"
    ]),
    MenuItemData("VEHICLES", Icons.directions_car, [
      "CREATE VEHICLE TYPE",
      "LIST OF VEHICLE TYPES",
      "CREATE COMPANY VEHICLE",
      "LIST OF COMPANY VEHICLE"
    ]),
    MenuItemData("USERS", Icons.supervised_user_circle,
        ["CREATE USER", "LIST OF USER", "AUTHORIZATION"]),
    MenuItemData("SUBSIDIARY", Icons.supervised_user_circle,
        ["CREATE SUBSIDIARY", "LIST OF SUBSIDIARIES"]),
    MenuItemData("REPORTS", Icons.receipt_long,
        ["DRIVER", "BOOKINGS", "CALL", "INCOME", "PCO"]),
    MenuItemData("SETTINGS", Icons.settings, [
      "COMPANY INFORMATION",
      "COMPANY CONFIGURATION",
      "DOCUMENT NUMBER",
      "TEMPLATE SETTINGS",
      "BOOKING CLEARING UTILITY",
      "LOCATION TYPE SHORTCUTS",
      "VOIP SETTINGS",
      "GENERAL SMS CONFIG",
      "SMS SETTINGS",
      "CHAT WITH DRIVER AND PASSENGER",
      "PERMISSION SETTINGS"
    ]),
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

  Widget? _currentPage;

  // List<SelectedDropdown> selectedMenuItems = [];

  DashboardController controller = Get.isRegistered<DashboardController>()
      ? Get.find<DashboardController>()
      : Get.put(DashboardController());


  @override
  Widget build(BuildContext context) {
    double itemHeight = 35; // approx height of one chip
    double runSpacing = 6;

    return Scaffold(
      backgroundColor: DynamicColors.whiteClr,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight * 2.3),
        child: NestedMenuBar(
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
            // border: Border.all(color: Colors.grey,width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          popUpPadding: 3,
          popUpMenuItemHoverForegroundColor: Colors.white,
          popUpMenuItemForegroundColor: Colors.black,
          popUpMenuItemBackgroundColor: Colors.white,
          popUpMenuItemHoverBackgroundColor: Colors.black,
        ),
      ),
      body: GetBuilder<DashboardController>(
          builder: (controller) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: Get.width,
                    padding: EdgeInsets.symmetric(vertical: 6,horizontal: 8),
                    color: Colors.grey.shade300,
                    child: Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children:
                        [
                          GestureDetector(
                            onTap: (){
                              int index = controller.selectedMenuItems.indexWhere((element) => element.selectedItem == true);
                              if (index != -1) {
                                controller.selectedMenuItems[index].selectedItem = false;
                              }
                              _currentPage = ByDefaultDashboard();
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
                              onTap: (){
                                int index = controller.selectedMenuItems.indexWhere((element) => element.selectedItem == true);
                                if (index != -1) {
                                  controller.selectedMenuItems[index].selectedItem = false;
                                }
                                item.selectedItem = true;
                                if(item.category != null){
                                  _currentPage = item.category;
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
                                  if(item.selectedItem == true && controller.selectedMenuItems.length >1){
                                    int index = controller.selectedMenuItems.indexWhere((item) => item.selectedItem == true);
                                    if (index != -1) {
                                      controller.selectedMenuItems[index].selectedItem = false;
                                    }
                                    controller.selectedMenuItems.remove(item);
                                    controller.selectedMenuItems.last.selectedItem = true;
                                  }else{
                                    controller.selectedMenuItems.remove(item);
                                    _currentPage = ByDefaultDashboard();
                                  }

                                  controller.update(); // if using GetX
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            );
                          }).toList(),
                        ]


                    ),
                  ),
                  _currentPage ?? TemplateSettings(),
                  // _currentPage ?? ByDefaultDashboard(),
                ],
              ),
            );
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
            setState(() {
              int index = controller.selectedMenuItems.indexWhere((item) => item.selectedItem == true);
              if (index != -1) {
                controller.selectedMenuItems[index].selectedItem = false;
              }
              controller.selectedMenuItems.add(SelectedDropdown(
                title: "CREATE BOOKINGS",
                selectedItem: true,
              )
              );
            });
          },
        ),
        NestedMenuItem(
            title: "LIST OF BOOKINGS",
            onTap: () {
              setState(() {
                int index = controller.selectedMenuItems.indexWhere((item) => item.selectedItem == true);
                if (index != -1) {
                  controller.selectedMenuItems[index].selectedItem = false;
                }
                controller.selectedMenuItems.add(SelectedDropdown(
                  title: "LIST OF BOOKINGS",
                  selectedItem: true,
                ));
              });
            }),
        NestedMenuItem(
            title: "LIST OF WEB BOOKINGS",
            onTap: () {
              setState(() {
                int index = controller.selectedMenuItems.indexWhere((item) => item.selectedItem == true);
                if (index != -1) {
                  controller.selectedMenuItems[index].selectedItem = false;
                }
                controller.selectedMenuItems.add(SelectedDropdown(
                  title: "LIST OF WEB BOOKINGS",
                  selectedItem: true,
                ));
              });
            }),
        NestedMenuItem(
            title: "LIST OF APP BOOKINGS",
            onTap: () {
              setState(() {
                int index = controller.selectedMenuItems.indexWhere((item) => item.selectedItem == true);
                if (index != -1) {
                  controller.selectedMenuItems[index].selectedItem = false;
                }
                controller.selectedMenuItems.add(SelectedDropdown(
                  title: "LIST OF APP BOOKINGS",
                  selectedItem: true,
                ));
              });
            }),
        NestedMenuItem(
            title: "LIST OF MULTI BOOKINGS",
            onTap: () {
              setState(() {

                int index = controller.selectedMenuItems.indexWhere((item) => item.selectedItem == true);
                if (index != -1) {
                  controller.selectedMenuItems[index].selectedItem = false;
                }
                controller.selectedMenuItems.add(SelectedDropdown(
                  title: "LIST OF MULTI BOOKINGS",
                  selectedItem: true,
                ));
              });
            }),
        NestedMenuItem(
            title: "LIST OF TRASH BOOKINGS",
            onTap: () {
              setState(() {
                int index = controller.selectedMenuItems.indexWhere((item) => item.selectedItem == true);
                if (index != -1) {
                  controller.selectedMenuItems[index].selectedItem = false;
                }
                controller.selectedMenuItems.add(SelectedDropdown(
                  title: "LIST OF TRASH BOOKINGS",
                  selectedItem: true,
                ));
              });
            }),
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
          title: "CREATE BOOKINGS",
          onTap: () => message(context, "DevOps"),
        ),
        NestedMenuItem(
          title: "LIST OF BOOKINGS",
          onTap: () => message(context, "DevOps"),
        ),
        NestedMenuItem(
          title: "LIST OF WEB BOOKINGS",
          onTap: () => message(context, "DevOps"),
        ),
        NestedMenuItem(
          title: "LIST OF APP BOOKINGS",
          onTap: () => message(context, "DevOps"),
        ),
        NestedMenuItem(
          title: "LIST OF MULTI BOOKINGS",
          onTap: () => message(context, "DevOps"),
        ),
        NestedMenuItem(
          title: "LIST OF TRASH BOOKINGS",
          onTap: () => message(context, "DevOps"),
        ),
      ]),
      NestedMenuItem(title: "FARES", children: [
        NestedMenuItem(
            title: "CREATE FARE SETTINGS",
            onTap: () {
              setState(() {
                _currentPage = FareConfigurationDay();
                controller.menuBarRefresh(title: "CREATE FARE SETTINGS", pageName: FareConfigurationDay());
              });
            }),
        NestedMenuItem(
            title: "CREATE FIXED FARE SETTINGS",
            onTap: () {
              setState(() {
                _currentPage = CreateFixedFareSetting();
                controller.menuBarRefresh(title: "CREATE FIXED FARE SETTINGS", pageName: CreateFixedFareSetting());
              });
            }),
        NestedMenuItem(
          title: "CREATE PLOT FARE",
          onTap: () {
            setState(() {
              _currentPage = PlotFare();
              controller.menuBarRefresh(title: "CREATE PLOT FARE", pageName: PlotFare());
            });
          },
        ),
        NestedMenuItem(
            title: "CREATE FARE BY VEHICLE SETTINGS",
            onTap: () {
              setState(() {
                _currentPage = FareByVehicle();
                controller.menuBarRefresh(title: "CREATE FARE BY VEHICLE SETTINGS", pageName: FareByVehicle());
              });
            }),
        NestedMenuItem(
          title: "AIRPORT CHARGES",
          onTap: () {
            setState(() {
              _currentPage = AirportCharges();
              controller.menuBarRefresh(title: "AIRPORT CHARGES", pageName: AirportCharges());
            });
          },
        ),
        NestedMenuItem(
          title: "FARE INCREMENT",
          onTap: () {
            setState(() {
              _currentPage = FareIncrement();
              controller.menuBarRefresh(title: "FARE INCREMENT", pageName: FareIncrement());
            });
          },
        ),
        NestedMenuItem(
          title: "SUR CHARGES",
          onTap: () {
            setState(() {
              _currentPage = FareCharges();
              controller.menuBarRefresh(title: "SUR CHARGES", pageName: FareCharges());
            });
          },
        ),
        NestedMenuItem(
          title: "FARE METER",
          onTap: () {
            setState(() {
              _currentPage = FareMeter();
              controller.menuBarRefresh(title: "FARE METER", pageName: FareMeter());
            });
          },
        ),
      ]),
      NestedMenuItem(title: "LOCATIONS", children: [
        NestedMenuItem(
          title: "CREATE LOCATIONS",
          onTap: () {
            setState(() {
              _currentPage = LocationForm();
              controller.menuBarRefresh(title: "CREATE LOCATIONS", pageName: LocationForm());
            });
          },
        ),
        NestedMenuItem(
          title: "LIST OF LOCATIONS",
          onTap: () {
            setState(() {
              _currentPage = LocationListScreen();
              controller.menuBarRefresh(title: "LIST OF LOCATIONS", pageName: LocationListScreen());
            });
          },
        ),
        NestedMenuItem(
          title: "CREATE ZONE",
          onTap: () {
            setState(() {
              _currentPage = ZoneScreen();
              controller.menuBarRefresh(title: "CREATE ZONE", pageName: ZoneScreen());
            });
          },
        ),
        NestedMenuItem(
          title: "LIST OF ZONES",
          onTap: () {
            setState(() {
              _currentPage = ZoneListScreen();
              controller.menuBarRefresh(title: "LIST OF ZONES", pageName: ZoneListScreen());
            });
          },
        ),
        NestedMenuItem(
          title: "LOCALIZATION",
          onTap: () {
            setState(() {
              _currentPage = LocalizationScreen();
              controller.menuBarRefresh(title: "LOCALIZATION", pageName: LocalizationScreen());
            });
          },
        ),
  /*      NestedMenuItem(
          title: "PLOTTING",
          onTap: () {
            setState(() {
              _currentPage = ManagePostcodes();
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
                _currentPage = CreateDriverRent();
              });
            },*/
          children: [
            NestedMenuItem(
              title: "ADD DRIVER",
              onTap: () {
                setState(() {
                  _currentPage = CreateDriverRent();
                  controller.menuBarRefresh(title: "ADD DRIVER", pageName: CreateDriverRent());
                });
              },
            ),
            NestedMenuItem(
              title: "DRIVERS",
              onTap: () {
                setState(() {
                  _currentPage = DriverListScreen();
                  controller.menuBarRefresh(title: "DRIVERS", pageName: DriverListScreen());
                });
              },
            ),
            NestedMenuItem(
              title: "LIST OF LOGGED IN/OUT DRIVERS",
              onTap: () {
                setState(() {
                  _currentPage = LoginDriversScreen();
                  controller.menuBarRefresh(title: "LIST OF LOGGED IN/OUT DRIVERS", pageName: LoginDriversScreen());
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
                setState(() {
                  _currentPage = ListDriverCommission();
                  controller.menuBarRefresh(title: "CREATE DRIVER COMMISSION", pageName: ListDriverCommission());
                });
              },
            ),
            NestedMenuItem(
              title: "DRIVER COMMISSIONS",
              onTap: () {
                setState(() {
                  _currentPage = DriverCommission();
                  controller.menuBarRefresh(title: "DRIVER COMMISSIONS", pageName: DriverCommission());
                });
              },
            ),
            NestedMenuItem(
              title: "BULK DRIVER COMMISSION",
              onTap: () {
                setState(() {
                  _currentPage = BulkDriverCommission();
                  controller.menuBarRefresh(title: "BULK DRIVER COMMISSION", pageName: BulkDriverCommission());
                });
              },
            ),
            NestedMenuItem(
              title: "DRIVER COMMISSION PAY",
              onTap: () {
                setState(() {
                  _currentPage = DriverCommissionPay();
                  controller.menuBarRefresh(title: "DRIVER COMMISSION PAY", pageName: DriverCommissionPay());
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
                  _currentPage = CreateDriverRent();
                  controller.menuBarRefresh(title: "CREATE DRIVER RENT", pageName: CreateDriverRent());
                });
              },
            ),
            NestedMenuItem(
              title: "DRIVER RENT",
              onTap: () {
                setState(() {
                  _currentPage = DriverRent();
                  controller.menuBarRefresh(title: "DRIVER RENT", pageName: DriverRent());
                });
              },
            ),
            NestedMenuItem(
              title: "BULK DRIVER RENT",
              onTap: () {
                setState(() {
                  _currentPage = BulkDriverRent();
                  controller.menuBarRefresh(title: "BULK DRIVER RENT", pageName: BulkDriverRent());
                });
              },
            ),
            NestedMenuItem(
              title: "DRIVER RENT PAY",
              onTap: () {
                setState(() {
                  _currentPage = DriverRentPay();
                  controller.menuBarRefresh(title: "DRIVER RENT PAY", pageName: DriverRentPay());
                });
              },
            ),
          ],
        ),
        NestedMenuItem(
            title: "DRIVER APP FEATURES",
            onTap: () {
              setState(() {
                _currentPage = DriverAppFeatureScreen();
                controller.menuBarRefresh(title: "DRIVER APP FEATURES", pageName: DriverAppFeatureScreen());
              });
            }),
        NestedMenuItem(
            title: "DRIVER SIN BIN SETTINGS",
            onTap: () {
              setState(() {
                _currentPage = DriverSinBinSetting();
                controller.menuBarRefresh(title: "DRIVER SIN BIN SETTINGS", pageName: DriverSinBinSetting());
              });
            }),
      ]),

      NestedMenuItem(title: "ACCOUNTS", children: [
        NestedMenuItem(
          title: "CREATE ACCOUNT",
          onTap: () {
            setState(() {
              _currentPage = AccountView();
              controller.menuBarRefresh(title: "LIST OF ACCOUNTS", pageName: AccountView());
            });
          },
        ),
        NestedMenuItem(
          title: "LIST OF ACCOUNTS",
          onTap: () {
            setState(() {
              _currentPage = ListOfAccountScreen();
              controller.menuBarRefresh(title: "LIST OF ACCOUNTS", pageName: ListOfAccountScreen());
            });
          },
        ),
        NestedMenuItem(
          title: "ESCORT",
          onTap: () {
            _currentPage = CreateEscopt();
            controller.menuBarRefresh(title: "ESCORT", pageName: CreateEscopt());
          },
        ),
        NestedMenuItem(
          title: "CREATE CUSTOMER INVOICE",
          onTap: () => message(context, "DevOps"),
        ),
        NestedMenuItem(
          title: "LIST OF CUSTOMER INVOICES",
          onTap: () {
            setState(() {
              _currentPage = InvoiceList();
              controller.menuBarRefresh(title: "LIST OF ACCOUNTS", pageName: InvoiceList());
            });
          },
        ),
        NestedMenuItem(
          title: "CREATE ACCOUNT INVOICE",
          onTap: () => message(context, "DevOps"),
        ),
        NestedMenuItem(
          title: "LIST OF ACCOUNT INVOICES",
          onTap: () => message(context, "DevOps"),
        ),
      ]),
      NestedMenuItem(title: "VEHICLES", children: [
        NestedMenuItem(
          title: "CREATE VEHICLE TYPE",
          onTap: () => message(context, "DevOps"),
        ),
        NestedMenuItem(
          title: "LIST OF VEHICLE TYPES",
          onTap: () => message(context, "DevOps"),
        ),
        NestedMenuItem(
          title: "CREATE COMPANY VEHICLE",
          onTap: () => message(context, "DevOps"),
        ),
        NestedMenuItem(
          title: "LIST OF COMPANY VEHICLE",
          onTap: () => message(context, "DevOps"),
        ),
      ]),
      NestedMenuItem(title: "ADMINISTRATIONS", children: [
        NestedMenuItem(
            title: "USERS",
            children: [
              NestedMenuItem(
                title: "CREATE USER",
                onTap: () {
                  setState(() {
                    _currentPage = CreateUserScreen();
                    controller.menuBarRefresh(title: "CREATE USER", pageName: CreateUserScreen());
                  });
                },
              ),
              NestedMenuItem(
                title: "USERS",
                onTap: () {
                  setState(() {
                    _currentPage = UserListscreen();
                    controller.menuBarRefresh(title: "CREATE USER", pageName: UserListscreen());
                  });
                },
              ),
              NestedMenuItem(
                title: "CREATE SUBSIDIARY",
                onTap: () => message(context, "DevOps"),
              ),
              NestedMenuItem(
                title: "SUBSIDIARIES",
                onTap: () => message(context, "DevOps"),
              ),
              NestedMenuItem(
                title: "AUTHORIZATION",
                onTap: () => message(context, "DevOps"),
              ),
            ]
        ),
        NestedMenuItem(
          title: "SUBSIDIARY",
          onTap: () => message(context, "DevOps"),
        ),
      ]),
      NestedMenuItem(title: "REPORTS", children: [
        NestedMenuItem(
          title: "DRIVER",
          onTap: () => message(context, "DevOps"),
        ),
        NestedMenuItem(
          title: "BOOKINGS",
          onTap: () => message(context, "DevOps"),
        ),
        NestedMenuItem(
          title: "CALL",
          onTap: () => message(context, "DevOps"),
        ),
        NestedMenuItem(
          title: "INCOME",
          onTap: () => message(context, "DevOps"),
        ),
        NestedMenuItem(
          title: "PCO",
          onTap: () => message(context, "DevOps"),
        ),
      ]),
      NestedMenuItem(title: "SETTINGS", children: [
        NestedMenuItem(
          title: "COMPANY INFORMATION",
          onTap: () => message(context, "DevOps"),
        ),
        NestedMenuItem(
          title: "COMPANY CONFIGURATION",
          onTap: () => message(context, "DevOps"),
        ),
        NestedMenuItem(
          title: "DOCUMENT NUMBER",
          onTap: () => message(context, "DevOps"),
        ),
        NestedMenuItem(
          title: "TEMPLATE SETTINGS",
          onTap: () => message(context, "DevOps"),
        ),
        NestedMenuItem(
          title: "BOOKING CLEARING UTILITY",
          onTap: () => message(context, "DevOps"),
        ),
        NestedMenuItem(
          title: "LOCATION TYPE SHORTCUTS",
          onTap: () => message(context, "DevOps"),
        ),
        NestedMenuItem(
          title: "VOIP SETTINGS",
          onTap: () => message(context, "DevOps"),
        ),
        NestedMenuItem(
          title: "GENERAL SMS CONFIG",
          onTap: () => message(context, "DevOps"),
        ),
        NestedMenuItem(
          title: "SMS SETTINGS",
          onTap: () => message(context, "DevOps"),
        ),
        NestedMenuItem(
          title: "CHAT WITH DRIVER AND PASSENGER",
          onTap: () => message(context, "DevOps"),
        ),
        NestedMenuItem(
          title: "PERMISSION SETTINGS",
          onTap: () => message(context, "DevOps"),
        ),
      ]),
    ];
  }
}
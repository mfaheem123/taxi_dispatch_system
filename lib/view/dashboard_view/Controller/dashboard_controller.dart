import 'dart:async';
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/networks/api.dart';
import 'package:dashboard_new1/view/dashboard_view/models/dashboard_model.dart';
import 'package:dashboard_new1/view/dashboard_view/models/getMobileNumberWithNameModel.dart';
import 'package:dashboard_new1/view/dashboard_view/models/seeZoneOnMap.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import '../../../Model/via_point.dart';
import '../../../alert/child_seats_alert.dart';
import '../../../alert/restrict_drivers_alert.dart';
import '../../../component/marker_class.dart';
import '../../../component/networks/Url.dart';
import '../../../component/suggestion_widget/suggestion_controller.dart';
import '../../../component/time_duration_method.dart';
import '../../../tabbarview.dart';
import '../../cli_Screen.dart';
import '../../locations_view/Model/location_types_zoneModel.dart';
import '../../locations_view/controller/locations_controller.dart';
import '../../setting/company_configuration_view/alert_createbooking.dart';
import '../models/account_darshboard_model.dart';
import '../models/all_addresses_model.dart';
import 'package:dashboard_new1/view/customer/model/restricDriver.dart';
import '../models/dashboard_table_model.dart' hide Employee;
import '../models/tracking_drivers_model.dart';
import '../models/users_phone_numbers_model.dart';
import '../widgets/fare_configuration.dart';
import '../widgets/via_location.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../administration/model/user_model.dart';
import 'driver_activity_model.dart';

RxString shortCutKeyValue = 'shortCutKey'.obs;

class DashboardController extends GetxController {
  WebSocketChannel? _channel;
  bool isConnected = false;
  Timer? _bookingCountTimer;

// Global company ID access karne ke liye Api singleton ka use karenge
  final String _companyId = Api.singleton.globalCompanyId;
  final Set<String> _playedBookingIds = {};
  final FocusNode driverPanelFocusNode = FocusNode(debugLabel: 'DriverPanel');
  int selectedMapButtonIndex = -1;
  bool Function()? focusFirstTableRow;

  // Helper method jo URL me company_id attach karega agar sendCompanyId true ho
  String _buildSocketUrl(String endpoint, {bool sendCompanyId = false}) {
    String finalUrl = "$socketUrl$endpoint";
    if (sendCompanyId) {
      // Agar pehle se URL me "?" hai to "&" lagayenge, warna "?" lagayenge
      finalUrl += finalUrl.contains('?') ? "&" : "?";
      finalUrl += "company_id=$_companyId";
    }
    return finalUrl;
  }
  // 1. Connect To CLI
  void connectToCli(String extension, {bool sendCompanyId = false}) {
    final String path = "/cli?extension=$extension";
    final url = Uri.parse(_buildSocketUrl(path, sendCompanyId: sendCompanyId));

    try {
      _channel = WebSocketChannel.connect(url);

      _channel!.stream.listen(
            (message) {
          final data = jsonDecode(message);

          if (data['event'] == "CLI_OPEN") {
            print(data['data']);
            print(data['data']['callerId']);
            Get.to(() => ResponsivePassengerScreen(
              extensionNumber: data['data']['callerId'],
            ))?.then((value) {
              connectToCli("200", sendCompanyId: sendCompanyId);
            });
          }
        },
        onError: (error) => print("Connection Error: $error"),
        onDone: () => print("Connection Closed"),
      );
    } catch (e) {
      print("Error: $e");
    }
  }

  List<DashboardDriverObject> onlineDriversList = [];

  // 2. Connect To Driver Login
  void connectToDriverLogin({bool sendCompanyId = false}) {
    final url = Uri.parse(_buildSocketUrl("/driver-login", sendCompanyId: sendCompanyId));
    try {
      _channel = WebSocketChannel.connect(url);

      _channel!.stream.listen(
            (message) {
          final data = jsonDecode(message);

          print(data['event']);
          if (data['event'] == "DRIVER_LOGIN") {
            final driver = DashboardDriverObject.fromJson(
              Map<String, dynamic>.from(data['data']),
            );
            dashboardAllData!.drivers!.add(driver);
            onlineDriversList.add(driver);
            update();
          } else if (data['event'] == "DRIVER_BREAK_STATUS_UPDATE") {
            final driverData = data['data'];

            int index = onlineDriversList.indexWhere(
                  (e) => e.id.toString() == driverData['id'].toString(),
            );

            if (index != -1) {
              onlineDriversList[index].driverStatus =
              driverData['driver_status'];

              onlineDriversList[index].bookingStatus =
              driverData['booking_status'];

              update();
            }
          } else if (data['event'] != "DRIVER_LIST") {
            int index = onlineDriversList.indexWhere(
                  (test) =>
              test.id.toString() == data['data']['driverId'].toString(),
            );

            print(dashboardAllData!.drivers!);

            int idd = dashboardAllData!.drivers!.indexWhere(
                  (test) =>
              test.id.toString() == data['data']['driverId'].toString(),
            );

            print(dashboardAllData!.drivers!);

            if (index >= 0) {
              dashboardAllData!.drivers!.removeAt(idd);
              onlineDriversList.removeAt(index);
              selectDriverValue = null;
            }
            update();
          }
        },
        onError: (error) => print("Connection Error: $error"),
        onDone: () {
          connectToDriverLogin(sendCompanyId: sendCompanyId);
          print("🔌 Socket Disconnected");
          print("Close Code: ${_channel?.closeCode}");
          print("Close Reason: ${_channel?.closeReason}");
        },
      );
    } catch (e) {
      print("Error: $e");
    }
  }

  List<DashboardDriverObject> busyDriversList = [];

  // 3. Connect To Busy Driver
  void connectToBusyDriver({bool sendCompanyId = false}) {
    final url = Uri.parse(_buildSocketUrl("/driver-busy", sendCompanyId: sendCompanyId));
    try {
      _channel = WebSocketChannel.connect(url);

      _channel!.stream.listen(
            (message) {
          final data = jsonDecode(message);
          print("EVENT => ${data['event']}");
          print("DATA => ${data['data']}");

          if (data['event'] == "DRIVER_BOOKING_STATUS_WEB_UPDATE") {
            // The payload may carry the driver id under any of these keys, and
            // as a String or an int. Compare as String like every other handler
            // here does - a raw `==` silently misses when the types differ, so
            // the status change (Arrived / On Route / STC) never lands and the
            // row keeps the colour it got when the job was Accepted.
            final driverId = (data['data']['id'] ??
                data['data']['driver_id'] ??
                data['data']['driverId'])
                ?.toString();

            final newBookingStatus = data['data']['booking_status'];
            final newDriverStatus = data['data']['driver_status'];

            final onlineIndex = driverId == null
                ? -1
                : onlineDriversList.indexWhere(
                  (e) => e.id.toString() == driverId,
            );

            if (onlineIndex != -1) {
              onlineDriversList[onlineIndex].bookingStatus = newBookingStatus;
              onlineDriversList[onlineIndex].driverStatus = newDriverStatus;
            }

            final busyIndex = driverId == null
                ? -1
                : busyDriversList.indexWhere(
                  (e) => e.id.toString() == driverId,
            );

            if (busyIndex != -1) {
              busyDriversList[busyIndex].bookingStatus = newBookingStatus;
              busyDriversList[busyIndex].driverStatus = newDriverStatus;
            }

            // Keep the master list in sync too, so a rebuild sourced from it
            // doesn't hand back a stale booking status.
            final allIndex = driverId == null
                ? -1
                : (dashboardAllData?.drivers ?? []).indexWhere(
                  (e) => e.id.toString() == driverId,
            );

            if (allIndex != -1) {
              dashboardAllData!.drivers![allIndex].bookingStatus =
                  newBookingStatus;
              dashboardAllData!.drivers![allIndex].driverStatus =
                  newDriverStatus;
            }

            if (onlineIndex == -1 && busyIndex == -1) {
              print(
                  "BOOKING_STATUS_UPDATE: no driver matched id=$driverId (status=$newBookingStatus)");
            }

            update();
          } else if (data['event'] == "BUSY_DRIVER_UPDATE") {
            if (onlineDriversList.any(
                  (e) => e.id.toString() == data['data']['id'].toString(),
            )) {
              onlineDriversList.removeWhere(
                    (e) => e.id.toString() == data['data']['id'].toString(),
              );
            }

            if (dashboardAllData!.drivers!.any(
                  (e) => e.id.toString() == data['data']['id'].toString(),
            )) {
              dashboardAllData!.drivers!.removeWhere(
                    (e) => e.id.toString() == data['data']['id'].toString(),
              );

              selectDriverValue = null;
            }

            final driver = DashboardDriverObject.fromJson(
              Map<String, dynamic>.from(data['data']),
            );

            busyDriversList.add(driver);
            update();
          } else {
            busyDriversList.removeWhere(
                  (e) => e.id.toString() == data['data']['id'].toString(),
            );

            update();
          }
        },
        onError: (error) => print("Connection Error: $error"),
        onDone: () {
          connectToBusyDriver(sendCompanyId: sendCompanyId);
          print("🔌 Socket Disconnected");
        },
      );
    } catch (e) {
      print("Error: $e");
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> get all online drivers
  RxInt timerTick = 0.obs;
  Timer? timer;

  getAllOnlineDrivers() async {
    var response = await Api().get("drivers/login-busy",sendCompanyId: true,);
    if (response.statusCode == 200) {
      print(response.data);
      if (response.data['login_drivers'].isNotEmpty) {
        response.data['login_drivers'].forEach((element) {
          onlineDriversList.insert(
              0,
              DashboardDriverObject(
                id: element['id'],
                name: element['name'],
                username: element['username'],
                vehicleType: element['vehicle_type'],
                zone: element['zone'],
                latitude: element['latitude'],
                longitude: element['longitude'],
                bookingStatus: element['booking_status'],
                sessionStatus: element['session_status'],
                driverStatus: element['driver_status'],
                lastLoginAt: element['last_login_at'] != null
                    ? DateTime.parse(element['last_login_at']).toLocal()
                    : null,
              ));
        });
      }

      if (response.data['busy_drivers'].isNotEmpty) {
        response.data['busy_drivers'].forEach((element) {
          busyDriversList.insert(
              0,
              DashboardDriverObject(
                id: element['id'],
                name: element['name'],
                username: element['username'],
                vehicleType: element['vehicle_type'],
                zone: element['zone'],
                latitude: element['latitude'],
                longitude: element['longitude'],
                bookingStatus: element['booking_status'],
                sessionStatus: element['session_status'],
                driverStatus: element['driver_status'],
                lastLoginAt: element['last_login_at'] != null
                    ? DateTime.parse(element['last_login_at']).toLocal()
                    : null,
              ));
        });
      }
      timer = Timer.periodic(Duration(seconds: 5), (_) {
        timerTick.value++; // trigger UI update
        update();
      });
      update();
    }
  }

  ///===========================================================>See Zone On Map

  SeeZoneOnMapModel? seeZoneOnMapModel;

  RxBool seeZoneOnMappLoader = false.obs;

  seeZoneOnMapp() async {
    seeZoneOnMappLoader(true);

    var response = await Api().get("zones/get", sendCompanyId: true);

    if (response.statusCode == 200) {
      seeZoneOnMapModel = SeeZoneOnMapModel.fromJson(response.data);
      seeZoneOnMappLoader(false);
      update();
    } else {
      print("Error in Location List");
    }
  }

  ///===========================================================>See Zone On Map

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo drivers tracking functionality

  GetAllLabelsFromWidowModel? onlineBusyDriversList;
  RxBool showDataLoader = false.obs;

  getAllDriversTracking() async {
    showDataLoader(true);
    var response = await Api().get("drivers/tracking-drivers", sendCompanyId: true,);
    if (response.statusCode == 200) {
      onlineBusyDriversList =
          GetAllLabelsFromWidowModel.fromJson(response.data);
      showDataLoader(false);
      // onlineBusyDriversList!.trackingDrivers!.add(TrackingDriverObject(
      //     id: 172,
      //     username: "hubaib",
      //     name: "hubaib",
      //     zone: null,
      //     latitude:   "24.909889",
      //     longitude: "67.106173",
      //     bookingStatus: "Available",
      //     sessionStatus: "logged_in",
      //     driverStatus: "Available",
      //     lastLoginAt: null,
      //     vehicleType: "SALOON"
      //     ));
      // onlineBusyDriversList!.trackingDrivers!.add(TrackingDriverObject(
      //     id: 168,
      //     username: "Testing2",
      //     name: "Testing2",
      //     zone: null,
      //     latitude: "24.9109147",
      //     longitude: "67.1059215",
      //     bookingStatus: "Available",
      //     sessionStatus: "logged_in",
      //     driverStatus: "Available",
      //     lastLoginAt: null,
      //     vehicleType: "SALOON"
      // ));
      // onlineBusyDriversList!.trackingDrivers!.add(TrackingDriverObject(
      //     id: 169,
      //     username: "Testing3",
      //     name: "Testing3",
      //     zone: null,
      //     latitude: "24.9115094",
      //     longitude: "67.105151",
      //     bookingStatus: "Available",
      //     sessionStatus: "logged_in",
      //     driverStatus: "Available",
      //     lastLoginAt: null,
      //     vehicleType: "SALOON"
      // ));
      // onlineBusyDriversList!.trackingDrivers!.add(TrackingDriverObject(
      //     id: 170,
      //     username: "Testing4",
      //     name: "Testing4",
      //     zone: null,
      //     latitude: "68.860547",
      //     longitude: "65.007114",
      //     bookingStatus: "Available",
      //     sessionStatus: "logged_in",
      //     driverStatus: "Available",
      //     lastLoginAt: null,
      //     vehicleType: "SALOON"
      // ));
      // onlineBusyDriversList!.trackingDrivers!.add(TrackingDriverObject(
      //     id: 170,
      //     username: "Testing5",
      //     name: "Testing5",
      //     zone: null,
      //     latitude: "24.9120991",
      //     longitude: "67.1043783",
      //     bookingStatus: "Available",
      //     sessionStatus: "logged_in",
      //     driverStatus: "Available",
      //     lastLoginAt: null,
      //     vehicleType: "SALOON"
      // ));

      update();
    }
  }

  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo drivers tracking functionality

  ///Todo menu bar functionality
  // Widget? currentPage;

  final Rx<Widget?> currentPage = Rx<Widget?>(null);

  List<SelectedDropdown> selectedMenuItems = [];

  ///refresh function for menu bar
  ///
  /// The chip strip is a tab bar, so a page that is already open is NOT added
  /// to [selectedMenuItems] a second time — re-picking a menu entry used to
  /// push another chip for the same page every single time. The chip that is
  /// already there is selected and shown instead.
  menuBarRefresh({title, pageName}) {
    // if(selectedMenuItems.length < 3){
    final show = openMenuPage(selectedMenuItems, title: title, page: pageName);
    if (show != null) {
      currentPage.value = show;
    }
    // }else{
    //   Get.snackbar("", "You can select maximum 4 menu items",);
    // }
    update();
  }

  ///Todo menu bar functionality

  ///Todo booking form data
  /// String
  String selectedJourneyType = 'Journey Type';
  String selectedVehicleType = 'Saloon';
  String selectedAccountType = 'Account';
  String selectedPaymentMethod = 'Cash';
  String selectedDriver = 'Select Driver';
  String selectedDepartmentType = 'SELECT DEPARTMENT';
  String selectedReturnVehicleType = 'SELECT R/VEHICLE';
  String selectedReturnDriver = 'SELECT R/DRIVER';

  String? source;

  // Start with shortcut mode that allows navigation; set to "alert" only when showing a modal

  // Dropdown selections
  String? jourValue; // O/W, R/N, W/R
  String? drvValue; // driver list
  String? payValue; // Cash, Credit Card, ...

  bool get isOneWayJourney => jourValue == null || jourValue == 'O/W';
  ///bool

  RxBool isHovered = false.obs;
  RxBool isHoveredF8 = false.obs;
  RxBool isHoveredF9 = false.obs;
  RxBool isHoveredVLA = false.obs;
  bool isDropdownOpen = false;

  /// Current wall-clock time as the 24h `HH:mm` string TimePickerField expects.
  /// Static so it can be used from field initializers.
  static String get nowHHmm => DateFormat('HH:mm').format(DateTime.now());

  ///text editing controllers
  final pickupController = TextEditingController();
  final pickupTwoWayController = TextEditingController();
  final selectAirportControllerReturn = TextEditingController();
  final dropOffController = TextEditingController();
  final dropOffTwoWayController = TextEditingController();
  final selectAirportController = TextEditingController();
  // final selectReturnAirportController = TextEditingController();
  final arrivalTimeController = TextEditingController(text: nowHHmm);
  final arrivalReturnTimeController = TextEditingController(text: nowHHmm);
  final switchController = ValueNotifier<bool>(false);
  RxBool smsCheckbox = true.obs;
  RxBool addReturnFare = true.obs;
  RxBool emailCheckbox = false.obs;
  RxBool hideDashBoard = true.obs;

  /// Set by the booking form (BookingFormScreen) while it is mounted, cleared
  /// on dispose. The F2 shortcut lives on the dashboard shell — outside the
  /// form — so this is how it puts the caret in the form's first field.
  VoidCallback? focusBookingFormFirstField;

  /// unique keys
  final GlobalKey bookingKey = GlobalKey();
  final GlobalKey bookingDropKey = GlobalKey();
  final GlobalKey jourKey = GlobalKey();
  final GlobalKey accKey = GlobalKey();
  final GlobalKey payKey = GlobalKey();
  String? vehKey;
  final GlobalKey dRVKey = GlobalKey();
  // Backs the dashboard-wide RawKeyboardListener (F1-F9 shortcuts) in
  // dashboard.dart, so it wraps the entire screen and shows nothing when
  // focused. skipTraversal keeps Tab from landing on it — otherwise a Tab press
  // can leave no visible focus anywhere on the dashboard. The shortcuts still
  // fire: RawKeyboardListener checks hasFocus, which is true whenever focus is
  // on this node OR any descendant.
  FocusNode focusNode = FocusNode(skipTraversal: true);

  /// RxInt
  int selectedIndex = 0;
  int dropdownIndex = 0;
  RxInt selectionMenuBtn = 0.obs;

  ///Todo booking form data


  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo alert controllers data

  final noOfChildren = TextEditingController();
  final childAge = TextEditingController();
  final parkingChargesController = TextEditingController();
  final congestionChargesController = TextEditingController();
  final meetGreetController = TextEditingController();
  final waitingChargesController = TextEditingController();
  final extraDropChargesController = TextEditingController();
  final creditCardChargesController = TextEditingController();
  final companyPriceController = TextEditingController();
  final returnCompanyPriceController = TextEditingController();
  final specialRequirementsController = TextEditingController();
  final specialRequirementsReturnController = TextEditingController();
  final controllerNoteController = TextEditingController();
  final controllerNoteReturnController = TextEditingController();
  final sendEmailController = TextEditingController();
  final emailToController = TextEditingController();
  final mobileNoController = TextEditingController();
  final subjectController = TextEditingController();
  final typeEmailController = TextEditingController();
  final smsToController = TextEditingController();
  final typeYourMessageController = TextEditingController();
  Timer? dashboardTimer;

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo alert controllers data

  @override
  void onInit() {
    super.onInit();
  }

  inItStateOFController() async {
    mapController = MapController(); // ✅ Initialize here
    Future.delayed(Duration(seconds: 1), () {
      String myExtension = Employee.selectedEmployee?.extensionNumber ?? "200";
      print("Connecting to CLI with Extension: $myExtension");
      connectToCli(myExtension, sendCompanyId: true);
    });
    connectToDriverLogin(sendCompanyId: true);
    connectToBusyDriver(sendCompanyId: true);
    getAllDrivers();
    getAllOnlineDrivers();
    // startAutoRefresh(selectedTabId);

    // Add listeners to text controllers to detect focus and assign activeFieldKey
    pickupController.addListener(() {
      if (pickupController.selection.baseOffset != -1) {
        activeFieldKey.value = pickupFieldKey;
        inputText.value = pickupController.text;
        onInputChanged(pickupController.text);
      }
    });

    dropOffController.addListener(() {
      if (dropOffController.selection.baseOffset != -1) {
        activeFieldKey.value = dropOffFieldKey;
        inputText.value = dropOffController.text;
        onInputChanged(dropOffController.text);
      }
    });

    viaLocation1Controller.addListener(() {
      if (viaLocation1Controller.selection.baseOffset != -1) {
        activeFieldKey.value = via1FieldKey;
        inputText.value = viaLocation1Controller.text;
        onInputChanged(viaLocation1Controller.text);
      }
    });

    viaLocation2Controller.addListener(() {
      if (viaLocation2Controller.selection.baseOffset != -1) {
        activeFieldKey.value = via2FieldKey;
        inputText.value = viaLocation2Controller.text;
        onInputChanged(viaLocation2Controller.text);
      }
    });
  }

  var selectedBookingTab = 'TODAY BOOKINGS'.obs;

  RxString selectedTab = 'MAPS'.obs;
  RxString driverSelectionTab = 'activeDriver'.obs;
  var miles = '00.0'.obs;
  var duration = '00.0'.obs;
  List<AllAddressesModel> suggestions = <AllAddressesModel>[].obs;
  var inputText = ''.obs;
  final highlightedIndex = 0.obs;
  int selectedDriverIndex = 0;
  final pickupFieldKey = GlobalKey();
  final pickupTwoWayFieldKey = GlobalKey();
  final dropOffFieldKey = GlobalKey();
  final dropOffTwoFieldKey = GlobalKey();
  final via1FieldKey = GlobalKey();
  final via2FieldKey = GlobalKey();
  final stackKey = GlobalKey();
  final pickupFocusNode = FocusNode();
  final dropoffFocusNode = FocusNode();
  final via1FocusNode = FocusNode();
  final via2FocusNode = FocusNode();

  // final suggestionFocusNode = FocusNode();
  // final keyboardFocusNode = FocusNode();

  final FocusNode pickupKeyboardFocusNode = FocusNode();
  final FocusNode pickupTwoWayKeyboardFocusNode = FocusNode();
  final FocusNode dropOffKeyboardFocusNode = FocusNode();
  final FocusNode dropOffTwoDayKeyboardFocusNode = FocusNode();
  final FocusNode via1KeyboardFocusNode = FocusNode();
  final FocusNode via2KeyboardFocusNode = FocusNode();
  final FocusNode searchingAddressViaFocusNode = FocusNode();
  final FocusNode phoneKeyboardFocusNode = FocusNode();
  final FocusNode pickupTextFieldFocusNode = FocusNode();
  final FocusNode pickupTwoTextFieldFocusNode = FocusNode();
  final FocusNode dropOffTextFieldFocusNode = FocusNode();
  final FocusNode dropOffTwoWayTextFieldFocusNode = FocusNode();
  final FocusNode via1TextFieldFocusNode = FocusNode();
  final FocusNode via2TextFieldFocusNode = FocusNode();
  final FocusNode viaFieldFocusNode = FocusNode();

  final referenceNumberController = TextEditingController(text: 'NTG54851');
  final dateController = TextEditingController(
    text: DateFormat('EEE d-M-yyyy').format(DateTime.now()),
  );

  final timeController = TextEditingController(
    text: DateFormat('HH:mm').format(DateTime.now()),
  );

  final selectedDate = ''.obs;
  final selectedTime = ''.obs;

  final activeFieldKey = Rx<GlobalKey?>(null);

  // final pickupController = TextEditingController();
  // final dropOffController = TextEditingController();
  final viaLocation1Controller = TextEditingController();
  final viaLocation2Controller = TextEditingController();

  void onInputChanged(String value) {
    inputText.value = value;
    if (value.isEmpty) {
      suggestions.clear();
    } else {
      suggestions = allAddressesData
          .where((loc) => loc.name!.toUpperCase().contains(value.toLowerCase()))
          .toList();
      highlightedIndex.value = 0;
    }
  }

  void selectSuggestion(String? value, {twoWayPickup}) {
    if (activeFieldKey.value == pickupFieldKey) {
      pickupController.text = value!;
      pickupController.selection =
          TextSelection.collapsed(offset: value.length);
    } else if (activeFieldKey.value == dropOffFieldKey) {
      dropOffController.text = value!;
      dropOffController.selection =
          TextSelection.collapsed(offset: value.length);
    } else if (activeFieldKey.value == via1FieldKey) {
      viaLocation1Controller.text = value!;
      viaLocation1Controller.selection =
          TextSelection.collapsed(offset: value.length);
    } else if (activeFieldKey.value == via2FieldKey) {
      viaLocation2Controller.text = value!;
      viaLocation2Controller.selection =
          TextSelection.collapsed(offset: value.length);
    } else if (activeFieldKey.value == pickupTwoWayFieldKey) {
      pickupTwoWayController.text = value!;
      pickupTwoWayController.selection =
          TextSelection.collapsed(offset: value.length);
    } else if (activeFieldKey.value == dropOffTwoFieldKey) {
      dropOffTwoWayController.text = value!;
      dropOffTwoWayController.selection =
          TextSelection.collapsed(offset: value.length);
    }

    inputText.value = value!;
    suggestions.clear();
  }

  Timer? _debounce;

  RxString selectedTextFieldsValue = "".obs;
  RxBool dropDownShow = false.obs;

  Future<void> onChangeHandler(
      {required String fieldName, required String searchingText}) async {
    const duration = Duration(milliseconds: 800); // 800ms ka delay
    selectedTextFieldsValue.value = fieldName;
    //  Agar pehle se koi timer chal raha ho to usse cancel karo
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    //  Naya timer start karo
    _debounce = Timer(duration, () {
      _stopTyping(fieldName: fieldName, searchingText: searchingText);
    });
  }

  void _stopTyping({required String fieldName, required String searchingText}) {
    //  Yahan API call ya search function call karna hai
    getAddresses(fieldsName: fieldName, searchingText: searchingText);
  }

  @override
  void dispose() {
    _debounce?.cancel();

    super.dispose();
  }


  void updateZoom(bool zoomIn) {
    double currentZoom = mapController.camera.zoom;
    double newZoom = zoomIn ? currentZoom + 1 : currentZoom - 1;

    if (newZoom >= 3.0 && newZoom <= 18.0) {
      mapController.move(mapController.camera.center, newZoom);
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> searching all locations hit
  void swapPickupDropMarkers() {
    // Dono indexes ko alag-alag find karein
    final pickupIndex = polyLineMarkerInfo.indexWhere((e) => e.markerType == "PICKUP LOCATION");
    final dropIndex = polyLineMarkerInfo.indexWhere((e) => e.markerType == "DROP LOCATION");

    // CASE 1: Agar dono markers maujood hain (Normal Swap)
    if (pickupIndex != -1 && dropIndex != -1) {
      final temp = polyLineMarkerInfo[pickupIndex];
      polyLineMarkerInfo[pickupIndex] = polyLineMarkerInfo[dropIndex];
      polyLineMarkerInfo[dropIndex] = temp;

      polyLineMarkerInfo[pickupIndex].markerType = "PICKUP LOCATION";
      polyLineMarkerInfo[dropIndex].markerType = "DROP LOCATION";
    }
    // CASE 2: Agar sirf Pickup maujood hai aur Dropoff khali hai (Move Pickup to Dropoff)
    else if (pickupIndex != -1 && dropIndex == -1) {
      polyLineMarkerInfo[pickupIndex].markerType = "DROP LOCATION";
    }
    // CASE 3: Agar sirf Dropoff maujood hai aur Pickup khali hai (Move Dropoff to Pickup)
    else if (dropIndex != -1 && pickupIndex == -1) {
      polyLineMarkerInfo[dropIndex].markerType = "PICKUP LOCATION";
    }
  }

  void swapReturnPickupDropMarkers() {
    final returnPickupIndex = polyLineMarkerInfo.indexWhere(
          (e) => e.markerType == "PICKUP TWO WAY LOCATION",
    );

    final returnDropIndex = polyLineMarkerInfo.indexWhere(
          (e) => e.markerType == "DROP TWO WAY LOCATION",
    );

    // CASE 1: Agar dono return markers list me maujood hain (Normal Swap)
    if (returnPickupIndex != -1 && returnDropIndex != -1) {
      final temp = polyLineMarkerInfo[returnPickupIndex];
      polyLineMarkerInfo[returnPickupIndex] = polyLineMarkerInfo[returnDropIndex];
      polyLineMarkerInfo[returnDropIndex] = temp;

      polyLineMarkerInfo[returnPickupIndex].markerType = "PICKUP TWO WAY LOCATION";
      polyLineMarkerInfo[returnDropIndex].markerType = "DROP TWO WAY LOCATION";
    }
    // CASE 2: Agar sirf Return Pickup hai aur Return Drop khali hai (Move Pickup to Drop)
    else if (returnPickupIndex != -1 && returnDropIndex == -1) {
      polyLineMarkerInfo[returnPickupIndex].markerType = "DROP TWO WAY LOCATION";
    }
    // CASE 3: Agar sirf Return Drop hai aur Return Pickup khali hai (Move Drop to Pickup)
    else if (returnDropIndex != -1 && returnPickupIndex == -1) {
      polyLineMarkerInfo[returnDropIndex].markerType = "PICKUP TWO WAY LOCATION";
    }
  }
  var isAirportResponse = false.obs;
  var isAirportResponseReturn = false.obs;
  List<AllAddressesModel> allAddressesData = <AllAddressesModel>[].obs;

  getAddresses({fieldsName, searchingText}) async {
    var response = await Api().get(
        "services/search?search=${searchingText.toString().toUpperCase()}",
        auth: true);
    if (response.statusCode == 200) {
      // source "airport"
      if (response.data['source'] == "airport" &&
          selectedTextFieldsValue.value == "PICKUP LOCATION") {
        isAirportResponse.value = true;
      } else if (response.data['source'] != "airport" &&
          selectedTextFieldsValue.value == "PICKUP LOCATION") {
        isAirportResponse.value = false;
      }
      if (response.data['source'] == "airport" &&
          selectedTextFieldsValue.value == "PICKUP TWO WAY LOCATION") {
        isAirportResponseReturn.value = true;
      } else if (response.data['source'] != "airport" &&
          selectedTextFieldsValue.value == "PICKUP TWO WAY LOCATION") {
        isAirportResponseReturn.value = false;
      }

      if (response.data.isNotEmpty) {
        allAddressesData.clear();
        allAddressesData.addAll((response.data['result'] as List)
            .map((e) => AllAddressesModel.fromJson(e))
            .toList());
        updateKeys();
        inputText.value = searchingText;
        if (searchingText.isEmpty) {
          suggestions.clear();
        } else {
          suggestions = allAddressesData
              .where((loc) =>
                  loc.name!.toUpperCase().contains(searchingText.toLowerCase()))
              .toList();
          highlightedIndex.value = 0;
        }
        print("searching result list ${allAddressesData.length}");
        update();
      } else {
        openStreetMapApi(searchingText: searchingText.toString().toUpperCase());
      }
    }
  }

  openStreetMapApi({searchingText}) async {
    var dio = Dio();
    var response = await dio.request(
      'https://api.postcodes.io/postcodes/$searchingText',
      options: Options(
        method: 'GET',
      ),
    );

    if (response.statusCode == 200) {
      allAddressesData.clear();
      pickLocationAddress(response.data['result']['latitude'],
          response.data['result']['longitude']);
    }
  }

  pickLocationAddress(lat, lng) async {
    var dio = Dio();
    var response = await dio.request(
      'https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$lng&format=json&addressdetails=1',
      options: Options(
        method: 'GET',
      ),
    );
    if (response.statusCode == 200) {
      final addressObject = [
        {
          "name": response.data['display_name'], // e.g. Brondesbury Park, Brent
          "postcode": response.data['address']
              ['postcode'], // e.g. Brondesbury Park, Brent
          "lat": double.parse(response.data['lat']), // 51.542059
          "lon": double.parse(response.data['lon']), // -0.212545
        }
      ];

      allAddressesData.addAll(
        (addressObject as List)
            .map((e) => AllAddressesModel.fromJson(e))
            .toList(),
      );
      updateKeys();
      update();
    }
  }


  swapeToChangeReturnLocation() async{
    String tempPic = pickupTwoWayController.text;
    String tempDrop = dropOffTwoWayController.text;
    pickupTwoWayController.text = tempDrop;
    dropOffTwoWayController.text = tempPic;
    dropDownShow.value = false;
    swapReturnPickupDropMarkers();
    await fetchRouteFromOSRM();
    update();
  }

  swapeToChangeLocation() async{
    String tempPic = pickupController.text;
    String tempDrop = dropOffController.text;
    pickupController.text = tempDrop;
    dropOffController.text = tempPic;
    dropDownShow.value = false;
    swapPickupDropMarkers();
    await fetchRouteFromOSRM();
    update();
  }


  AllAddressesModel? selectedModel;
  late final MapController mapController;
  MapController? mapTrackingController;
  final List<ViaPoint> viaPoints = [];
  List<ViaTextEditingControllerClass> viaTextEditingController = [];

  final List<LatLng> polylinePoints = [];
  List<ViaPoint> polyLineMarkerInfo = [];
  List<LatLng> polylinePointsCoordinate = [];
  List<Polyline> polylines = [];
  List<CustomMarker> markers = [];

  RxString totalDistance = "0".obs;
  RxString tempStoreTotalDistance = "0".obs;
  RxString totalTimeDuration = "0 min".obs;
  RxString fixedFare = "0".obs;
  String? returnFareValue;
  RxBool viaSelectionOneWay = true.obs;

  LatLngBounds calculateBounds(List<LatLng> points) {
    assert(points.isNotEmpty);

    // single point -> degenerate bounds
    if (points.length == 1) {
      return LatLngBounds.fromPoints([points.first, points.first]);
    }

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (var p in points) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }

    final sw = LatLng(minLat, minLng);
    final ne = LatLng(maxLat, maxLng);

    // use fromPoints to avoid constructor signature mismatch
    return LatLngBounds.fromPoints([sw, ne]);
  }

  /// Everything the map should keep in frame for the booking being typed:
  /// pickup, drop, both return-leg ends and every via. Rebuilt by
  /// [fetchRouteFromOSRM].
  ///
  /// Kept on the controller so the map can replay the fit from `onMapReady` —
  /// a fit asked for while no FlutterMap is attached (PLOT tab open, or the
  /// first address picked before the map's first frame) has nowhere to land.
  List<LatLng> mapFocusPoints = [];

  /// Frames [points] — the current journey by default — in the map viewport.
  ///
  /// A single point cannot produce bounds, so it is centred instead; two or
  /// more zoom OUT until the whole journey is on screen at once.
  void focusMapOnJourney({List<LatLng>? points, double singlePointZoom = 14}) {
    final pts = points ?? mapFocusPoints;
    if (pts.isEmpty) return;
    try {
      if (pts.length == 1) {
        mapController.move(pts.first, singlePointZoom);
        return;
      }
      mapController.fitCamera(
        CameraFit.coordinates(
          coordinates: pts,
          padding: const EdgeInsets.all(60),
          // Two addresses on the same street would otherwise fit at street
          // level, which reads as a broken map rather than as a short journey.
          maxZoom: 15,
        ),
      );
    } catch (_) {
      // MapController throws until a FlutterMap is attached to it. onMapReady
      // replays this from [mapFocusPoints] as soon as one is.
    }
  }

  String? tempStoreMils;
  String? tempStoreReturnMils;
  String? tempStoreViaMils;
  bool viaMilsCondition = false;
  String? oneWayMiles;
  String? viaMiles;
  String? returnMiles;


  void clearViaIfNoPickupAndDrop() {

    final bool hasPickup = pickupController.text.trim().isNotEmpty;
    final bool hasDrop = dropOffController.text.trim().isNotEmpty;

    // Dono empty hon tab hi Via remove hon
    if (!hasPickup && !hasDrop) {

      // Sirf One-Way Via remove hon
      viaPoints.removeWhere((e) => e.withReturnWay == "via");

      // Unke controllers bhi remove karo
      for (int i = viaTextEditingController.length - 1; i >= 0; i--) {
        if (i < viaPoints.length) continue;
        viaTextEditingController.removeAt(i);
      }

      fetchRouteFromOSRM();
      update();
    }
  }
  void clearReturnViaIfNoPickupAndDrop() {

    final bool hasReturnPickup =
        pickupTwoWayController.text.trim().isNotEmpty;

    final bool hasReturnDrop =
        dropOffTwoWayController.text.trim().isNotEmpty;

    // Dono empty hon tab hi Return Via remove hon
    if (!hasReturnPickup && !hasReturnDrop) {

      // Sirf Return Via remove hon
      viaPoints.removeWhere((e) => e.withReturnWay != "via");

      // Route dobara generate karo
      fetchRouteFromOSRM();

      update();
    }
  }
  // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
// BUSINESS RULE IMPLEMENTATION: DETACHED OUTBOUND & RETURN SEGMENT ROUTES WITH SEQUENTIAL VIAS
/// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<void> fetchRouteFromOSRM() async {
    markers.clear();
    polylines.clear();
    polylinePointsCoordinate.clear();

    // Sequential coordinates lists banayi hain taake path sahi chain me bne
    List<LatLng> outboundSequence = [];
    List<LatLng> returnSequence = [];
    List<LatLng> totalMapLayoutFocusPoints = [];

    LatLng? outboundPickup;
    LatLng? outboundDropOff;
    LatLng? returnPickup;
    LatLng? returnDropOff;

    // 1. Map Layers se coordinates extract aur markers set karein
    if (polyLineMarkerInfo.isNotEmpty) {
      for (var item in polyLineMarkerInfo) {
        final p = LatLng(item.lat, item.lng);
        if (item.markerType == "PICKUP LOCATION" || item.markerType == "Create Booking PICKUP") {
          outboundPickup = p;
          totalMapLayoutFocusPoints.add(p);
          markers.add(CustomMarker(
            type: "pickup",
            point: p,
            child: Tooltip(
              message: pickupController.text,
              waitDuration: Duration.zero,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.location_pin, color: DynamicColors.greenClr, size: 30),
                  const Positioned(
                    top: 3,
                    child: Text(
                      "A",
                      style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            width: 30,
            height: 30,
          ));
        } else if (item.markerType == "DROP LOCATION" || item.markerType == "Create Booking DROP LOCATION") {
          outboundDropOff = p;
          totalMapLayoutFocusPoints.add(p);
          markers.add(CustomMarker(
            type: "dropOff",
            point: p,
            child: Tooltip(
              message: dropOffController.text, // 👈 Hover par Dropoff TextField ka text dikhega
              waitDuration: Duration.zero,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.location_pin, color: DynamicColors.greenClr, size: 30),
                  const Positioned(
                    top: 3,
                    child: Text(
                      "B",
                      style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            width: 30,
            height: 30,
          ));
        } else if (item.markerType == "PICKUP TWO WAY LOCATION") {
          returnPickup = p;
          totalMapLayoutFocusPoints.add(p);
          markers.add(CustomMarker(
            type: "pickup two way",
            point: p,
            child: Tooltip(
              message: pickupTwoWayController.text,
              waitDuration: Duration.zero,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.location_pin, color: Colors.red, size: 30),
                  const Positioned(
                    top: 3,
                    child: Text(
                      "C",
                      style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            width: 30,
            height: 30,
          ));
        } else if (item.markerType == "DROP TWO WAY LOCATION") {
          returnDropOff = p;
          totalMapLayoutFocusPoints.add(p);
          markers.add(CustomMarker(
            type: "dropOff two way",
            point: p,
            child: Tooltip(
              message: dropOffTwoWayController.text,
              waitDuration: Duration.zero,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.location_pin, color: DynamicColors.redClr, size: 30),
                  const Positioned(
                    top: 3,
                    child: Text(
                      "D",
                      style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            width: 30,
            height: 30,
          ));
        }
      }
    }

    ///  (A -> VIA -> B)
    if (outboundPickup != null) {
      outboundSequence.add(outboundPickup);
    }
    int outboundViaCount = 1;
    for (var item in viaPoints) {
      if (item.withReturnWay == "via") {
        final p = LatLng(item.lat, item.lng);
        outboundSequence.add(p);
        totalMapLayoutFocusPoints.add(p);
        markers.add(CustomMarker(
            withReturnType: "via",
            child: Tooltip(
              message: item.address ?? "Via Point",
              waitDuration: Duration.zero,

              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.location_pin, color: DynamicColors.primaryClr, size: 30),
                  Positioned(
                    top: 5,
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        "V$outboundViaCount",
                        style: TextStyle(color: DynamicColors.primaryClr, fontSize: 9, fontWeight: FontWeight.bold,),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            type: "via", point: p, width: 30, height: 30));
        outboundViaCount++;
      }
    }
    if (outboundDropOff != null) {
      outboundSequence.add(outboundDropOff);
    }

    ///  (C -> VIA -> D)
    if (returnPickup != null) {
      returnSequence.add(returnPickup);
    }
    int viaNumber = 1;
    for (var item in viaPoints) {
      if (item.withReturnWay != "via") {
        final p = LatLng(item.lat, item.lng);
        returnSequence.add(p);
        totalMapLayoutFocusPoints.add(p);
        markers.add(CustomMarker(withReturnType: "via with return", child:
        Tooltip(
          message: item.address ?? "Return Via Point",
          waitDuration: Duration.zero,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(Icons.location_pin, color: DynamicColors.primaryClr, size: 30),
              Positioned(
                top: 5,
                child: Container(
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    "R$viaNumber",
                    style: TextStyle(color: DynamicColors.primaryClr, fontSize: 9, fontWeight: FontWeight.bold,),
                  ),
                ),
              ),
            ],
          ),
        ),
            type: "via", point: p, width: 30, height: 30));
        viaNumber++ ;
      }
    }
    if (returnDropOff != null) {
      returnSequence.add(returnDropOff);
    }

    // Frame the journey the moment its points are known, NOT at the end of
    // this method: everything below is behind an OSRM round-trip and a fare
    // call, so a single entered address returned right here without even
    // centring the map, and any throw further down (an unset return vehicle in
    // getFares, an OSRM timeout) skipped the fit for a full journey too.
    mapFocusPoints = List<LatLng>.of(totalMapLayoutFocusPoints);
    focusMapOnJourney();
    update();

    if (totalMapLayoutFocusPoints.length == 1) {
      return;
    }

    double totalComputedMiles = 0.0;
    double computedOutboundMiles = 0.0;
    double computedReturnMiles = 0.0;
    double totalDurationMinutes = 0.0;
    double outboundDurationMinutes = 0.0;
    double returnDurationMinutes = 0.0;


    /// (A -> Vias -> B)
    if (outboundSequence.length >= 2) {
      final coordsOut = outboundSequence.map((p) => "${p.longitude},${p.latitude}").join(";");
      final urlOut = Uri.parse('https://router.project-osrm.org/route/v1/driving/$coordsOut?overview=full');
      try {
        final resOut = await Dio().getUri(urlOut);
        if (resOut.statusCode == 200 && resOut.data['routes'] != null && resOut.data['routes'].isNotEmpty) {
          final dataOut = resOut.data['routes'][0];
          computedOutboundMiles = dataOut['distance'] * 0.000621371;
          totalComputedMiles += computedOutboundMiles;

          // ADDED: Time duration added for Outbound
          outboundDurationMinutes = (dataOut['duration'] ?? 0).toDouble() / 60;
          totalDurationMinutes += outboundDurationMinutes;

          String encodedPoly = dataOut['geometry'];
          List<PointLatLng> result = PolylinePoints.decodePolyline(encodedPoly);
          List<LatLng> decodedSegmentPoints = result.map((p) => LatLng(p.latitude, p.longitude)).toList();
          polylinePointsCoordinate.addAll(decodedSegmentPoints);

          polylines.add(Polyline(
            points: decodedSegmentPoints,
            color: DynamicColors.primaryClr,
            strokeWidth: 2.5,
          ));
        }
      } catch (e) {
        print("Outbound Route Generation Error: $e");
      }
    }


    //  CONNECTING ROUTE (Bridge: Outbound ka last point -> Return ka first point)
    if (outboundSequence.isNotEmpty && returnSequence.isNotEmpty) {

      final LatLng connectFrom = outboundSequence.last;
      final LatLng connectTo = returnSequence.first;

      if (connectFrom != connectTo) {
        final coordsConnect = "${connectFrom.longitude},${connectFrom.latitude};${connectTo.longitude},${connectTo.latitude}";
        final urlConnect = Uri.parse('https://router.project-osrm.org/route/v1/driving/$coordsConnect?overview=full');

        try {
          final resConnect = await Dio().getUri(urlConnect);
          if (resConnect.statusCode == 200 && resConnect.data['routes'] != null && resConnect.data['routes'].isNotEmpty) {
            final dataConnect = resConnect.data['routes'][0];

            // ADDED: Bridge/Connecting path time calculation added
            double connectDurationMinutes = (dataConnect['duration'] ?? 0).toDouble() / 60;
            totalDurationMinutes += connectDurationMinutes;

            String encodedPoly = dataConnect['geometry'];
            List<PointLatLng> result = PolylinePoints.decodePolyline(encodedPoly);
            List<LatLng> decodedSegmentPoints = result.map((p) => LatLng(p.latitude, p.longitude)).toList();
            polylinePointsCoordinate.addAll(decodedSegmentPoints);

            polylines.add(Polyline(
              points: decodedSegmentPoints,
              color: Colors.grey.withOpacity(0.8), // Transition line
              strokeWidth: 2.5,
            ));
          }
        } catch (e) {
          print("Connecting Route Generation Error: $e");
        }
      }
    }

    ///  RETURN (C -> Vias -> D)
    if (returnSequence.length >= 2) {
      final coordsRet = returnSequence.map((p) => "${p.longitude},${p.latitude}").join(";");
      final urlRet = Uri.parse('https://router.project-osrm.org/route/v1/driving/$coordsRet?overview=full');
      try {
        final resRet = await Dio().getUri(urlRet);
        if (resRet.statusCode == 200 && resRet.data['routes'] != null && resRet.data['routes'].isNotEmpty) {
          final dataRet = resRet.data['routes'][0];
          computedReturnMiles = dataRet['distance'] * 0.000621371;
          totalComputedMiles += computedReturnMiles;

          // ADDED: Time duration added for Return Route
          returnDurationMinutes = (dataRet['duration'] ?? 0).toDouble() / 60;
          totalDurationMinutes += returnDurationMinutes;

          String encodedPoly = dataRet['geometry'];
          List<PointLatLng> result = PolylinePoints.decodePolyline(encodedPoly);
          List<LatLng> decodedSegmentPoints = result.map((p) => LatLng(p.latitude, p.longitude)).toList();
          polylinePointsCoordinate.addAll(decodedSegmentPoints);

          polylines.add(Polyline(
            points: decodedSegmentPoints,
            color: DynamicColors.pink,
            strokeWidth: 2.5,
          ));
        }
      } catch (e) {
        print("Return Route Generation Error: $e");
      }
    }

    totalDistance.value = totalComputedMiles.toStringAsFixed(2);
    tempStoreTotalDistance.value = totalComputedMiles.toStringAsFixed(2);
    tempStoreMils = computedOutboundMiles.toStringAsFixed(2);
    tempStoreReturnMils = computedReturnMiles.toStringAsFixed(2);
    totalTimeDuration.value = formatDuration(totalDurationMinutes);

    // Calculate
    if (viaPoints.any((element) => element.withReturnWay == "via")) {
      tempStoreViaMils = computedOutboundMiles.toStringAsFixed(2);
    } else {
      tempStoreViaMils = "0.00";
    }
    String postMils = (computedOutboundMiles).toStringAsFixed(2);

    // if (pickupTwoWayController.text.isNotEmpty && dropOffTwoWayController.text.isEmpty) {
    //   print("Waiting for final return segment dropoff checkpoint.");
    //   return;
    // }

    final storedTemFare = await getFares(
      journeyTypeId: selectJourneyTypeValue!.id,
      multiReservationList: multiReservationList,
      pickup: pickupController.text,
      dropOff: dropOffController.text,
      miles: postMils,
      pickUpPlotId: dashboardDZoneValue != null ? dashboardDZoneValue!.id : null,
      dropoffPlotId: dashboardZoneValue != null ? dashboardZoneValue!.id : null,
      pickupDate: "${pickUpDate!.year}-${pickUpDate!.month}-${pickUpDate!.day}",
      pickupTime: pickUpTimeController.text,
      // Null-safe, as in getFaresCalculation(): refreshPostAllFields() (F7)
      // sets selectVehicleValueReturn back to null, and a `!` here threw right
      // through the rest of this method — no fare, no update(), and (before
      // the fit moved above) no map focus either.
      vehicleTypeId: selectVehicleValue?.id,
      returnVehicleTypeId : dropOffTwoWayController.text.isNotEmpty || pickupTwoWayController.text.isNotEmpty && selectVehicleValueReturn !=  null?selectVehicleValueReturn!.id:selectVehicleValue!.id,

      withReturnPickUp: pickupTwoWayController.text.isEmpty ? null : pickupTwoWayController.text,
      withReturnDropOff: dropOffTwoWayController.text.isEmpty ? null : dropOffTwoWayController.text,
      returnMiles: dropOffTwoWayController.text.isNotEmpty || pickupTwoWayController.text.isNotEmpty ?tempStoreReturnMils: null,
      isOneWay: isOneWayJourney,
      isWaitAndReturn: jourValue == 'W/R',

    );
    var fareValue = jsonDecode(storedTemFare);
    fixedFare.value = fareValue['total_fare']?.toString() ?? "0";
    slugController.text = fareValue['fare']?.toString() ?? "0";
    returnFareValue = fareValue['return_fare']?.toString() ?? "0";
    slugControllerReturn.text = fareValue['return_fare']?.toString() ?? "0";

    // Refit now that the real road geometry is in: a route can bulge well
    // outside the straight-line box of its endpoints. Markers stay in the list
    // so nothing that was framed a moment ago drops off the edge.
    if (polylinePointsCoordinate.isNotEmpty) {
      focusMapOnJourney(
        points: [...polylinePointsCoordinate, ...totalMapLayoutFocusPoints],
      );
    }
    update();
  }

  final suggestionFocusNode = FocusNode();
  final suggestionScrollController = ScrollController();

// inside your controller
  final viaFocusNode = FocusNode();
  final viaSuggestionScrollController = ScrollController();

  List<GlobalKey> suggestionItemKeys = [];

  void updateKeys() {
    suggestionItemKeys =
        List.generate(allAddressesData.length, (_) => GlobalKey());
  }

  final GlobalKey suggestionListKey = GlobalKey();
  final GlobalKey suggestionListKeyVia = GlobalKey();

// change move functions to scroll after change:
  void moveHighlightDown({bool viaConditionValue = false}) {
    if (allAddressesData.isEmpty) return;
    highlightedIndex.value =
        (highlightedIndex.value + 1) % allAddressesData.length;
    highlightedIndex.refresh();
    _scrollToHighlighted(scrollDown: true);
  }

  void moveHighlightUp({bool viaConditionValue = false}) {
    if (allAddressesData.isEmpty) return;
    highlightedIndex.value =
        (highlightedIndex.value - 1 + allAddressesData.length) %
            allAddressesData.length;
    highlightedIndex.refresh();
    _scrollToHighlighted(
        scrollDown: false,
        viaCondition: viaConditionValue);
  }

  void _scrollToHighlighted(
      {bool scrollDown = true, bool viaCondition = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final i = highlightedIndex.value;

      if (i < 0 || i >= suggestionItemKeys.length) return;

      final itemCtx = suggestionItemKeys[i].currentContext;

      final listCtx =
          /*selectedTextFieldsValue.value !=
          "via"?*/
          suggestionListKey
              .currentContext /*:suggestionListKeyVia.currentContext*/;

      if (itemCtx != null &&
          listCtx != null &&
          suggestionScrollController.hasClients) {
        final RenderBox itemBox = itemCtx.findRenderObject() as RenderBox;

        final RenderBox listBox = listCtx.findRenderObject() as RenderBox;

        final Offset itemOffset =
            itemBox.localToGlobal(Offset.zero, ancestor: listBox);

        final double itemTopLocal = itemOffset.dy;

        final double itemBottomLocal = itemTopLocal + itemBox.size.height;

        final double viewportHeight = listBox.size.height;

        final double currentOffset = suggestionScrollController.offset;

        double targetOffset = currentOffset;

        const double edgeMargin = 8.0;

        if (itemBottomLocal > viewportHeight - edgeMargin) {
          final double delta = itemBottomLocal - (viewportHeight - edgeMargin);

          targetOffset = (currentOffset + delta).clamp(
            suggestionScrollController.position.minScrollExtent,
            suggestionScrollController.position.maxScrollExtent,
          );
        } else if (itemTopLocal < edgeMargin) {
          final double delta = itemTopLocal - edgeMargin; // negative

          targetOffset = (currentOffset + delta).clamp(
            suggestionScrollController.position.minScrollExtent,
            suggestionScrollController.position.maxScrollExtent,
          );
        } else {
          return; // already visible
        }

        _instantOrSmoothScroll(targetOffset, currentOffset);
      } else {
        _fallbackScroll(i, scrollDown);
      }
    });
  }

  void _fallbackScroll(int index, bool scrollDown) {
    if (!suggestionScrollController.hasClients) return;

    const double itemHeight = 48.0;
    const double topPadding = 15.0;
    final currentOffset = suggestionScrollController.offset;
    final viewport = suggestionScrollController.position.viewportDimension;
    final visibleStart = currentOffset;
    final visibleEnd = currentOffset + viewport;

    final itemTop = topPadding + index * itemHeight;
    final itemBottom = itemTop + itemHeight;

    double target = currentOffset;
    const double margin = itemHeight * 0.12;

    if (itemBottom > visibleEnd) {
      target = itemBottom - viewport + margin;
    } else if (itemTop < visibleStart) {
      target = itemTop - margin;
    } else {
      return;
    }

    target = target.clamp(
      suggestionScrollController.position.minScrollExtent,
      suggestionScrollController.position.maxScrollExtent,
    );

    _instantOrSmoothScroll(target, currentOffset);
  }

  void _instantOrSmoothScroll(double targetOffset, double currentOffset) {
    if (!suggestionScrollController.hasClients) return;

    // difference between current & target
    final double diff = (targetOffset - currentOffset).abs();

    // if small distance -> jump instantly
    if (diff < 60) {
      suggestionScrollController.jumpTo(targetOffset);
    } else {
      // if bigger move -> smooth scroll
      suggestionScrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    }
  }

  RxInt suggestionSelectedIndex = 0.obs;

  void tapSelect(int index) {
    if (allAddressesData.isEmpty) return;
    final selected = allAddressesData[index];
    final suggestion = selected.name!;
    final postCode = selected.postcode!;
    if (selectedTextFieldsValue.value == "PICKUP LOCATION") {
      int index = polyLineMarkerInfo
          .indexWhere((test) => test.markerType == "PICKUP LOCATION");
      if (index != -1) {
        polyLineMarkerInfo.remove(polyLineMarkerInfo[index]);
      }
      polylinePoints.add(
        LatLng(selected.lat!, selected.lon!),
      );
      polyLineMarkerInfo.add(ViaPoint(
        lat: selected.lat!,
        lng: selected.lon!,
        markerType: "PICKUP LOCATION",
        address: '',
      ));
      pickupController.text = "$suggestion $postCode".toUpperCase();
      fetchRouteFromOSRM();
    } else if (selectedTextFieldsValue.value == "DROP LOCATION") {
      int index = polyLineMarkerInfo
          .indexWhere((test) => test.markerType == "DROP LOCATION");
      if (index != -1) {
        polyLineMarkerInfo.remove(polyLineMarkerInfo[index]);
      }
      polylinePoints.add(
        LatLng(selected.lat!, selected.lon!),
      );
      polyLineMarkerInfo.add(ViaPoint(
        lat: selected.lat!,
        lng: selected.lon!,
        markerType: "DROP LOCATION",
        address: '',
      ));
      dropOffController.text = "$suggestion $postCode".toUpperCase();
      fetchRouteFromOSRM();
    } else if (selectedTextFieldsValue.value == "Create Booking PICKUP") {
      int index = polyLineMarkerInfo
          .indexWhere((test) => test.markerType == "Create Booking PICKUP");
      if (index != -1) {
        polyLineMarkerInfo.remove(polyLineMarkerInfo[index]);
      }
      polylinePoints.add(
        LatLng(selected.lat!, selected.lon!),
      );
      polyLineMarkerInfo.add(ViaPoint(
        lat: selected.lat!,
        lng: selected.lon!,
        markerType: "Create Booking PICKUP",
        address: '',
      ));
      pickupController.text = "$suggestion $postCode".toUpperCase();
      fetchRouteFromOSRM();
    } else if (selectedTextFieldsValue.value ==
        "Create Booking DROP LOCATION") {
      int index = polyLineMarkerInfo.indexWhere(
          (test) => test.markerType == "Create Booking DROP LOCATION");

      if (index != -1) {
        polyLineMarkerInfo.remove(polyLineMarkerInfo[index]);
      }

      polylinePoints.add(
        LatLng(selected.lat!, selected.lon!),
      );
      polyLineMarkerInfo.add(ViaPoint(
        lat: selected.lat!,
        lng: selected.lon!,
        markerType: "Create Booking DROP LOCATION",
        address: '',
      ));

      dropOffController.text = "$suggestion $postCode".toUpperCase();
      fetchRouteFromOSRM();
    } else if (selectedTextFieldsValue.value == "DROP LOCATION") {
      int index = polyLineMarkerInfo
          .indexWhere((test) => test.markerType == "DROP LOCATION");

      if (index != -1) {
        polyLineMarkerInfo.remove(polyLineMarkerInfo[index]);
      }

      polylinePoints.add(
        LatLng(selected.lat!, selected.lon!),
      );
      polyLineMarkerInfo.add(ViaPoint(
        lat: selected.lat!,
        lng: selected.lon!,
        markerType: "DROP LOCATION",
        address: '',
      ));

      dropOffTwoWayController.text = "$suggestion $postCode".toUpperCase();
      fetchRouteFromOSRM();
    } else if (selectedTextFieldsValue.value == "DROP TWO WAY LOCATION") {
      int index = polyLineMarkerInfo
          .indexWhere((test) => test.markerType == "DROP TWO WAY LOCATION");

      if (index != -1) {
        polyLineMarkerInfo.remove(polyLineMarkerInfo[index]);
      }

      polylinePoints.add(
        LatLng(selected.lat!, selected.lon!),
      );
      polyLineMarkerInfo.add(ViaPoint(
        lat: selected.lat!,
        lng: selected.lon!,
        markerType: "DROP TWO WAY LOCATION",
        address: '',
      ));

      dropOffTwoWayController.text = "$suggestion $postCode".toUpperCase();
      fetchRouteFromOSRM();
    } else if (selectedTextFieldsValue.value == "PICKUP TWO WAY LOCATION") {
      int index = polyLineMarkerInfo
          .indexWhere((test) => test.markerType == "PICKUP TWO WAY LOCATION");

      if (index != -1) {
        polyLineMarkerInfo.remove(polyLineMarkerInfo[index]);
      }

      polylinePoints.add(
        LatLng(selected.lat!, selected.lon!),
      );
      polyLineMarkerInfo.add(ViaPoint(
        lat: selected.lat!,
        lng: selected.lon!,
        markerType: "PICKUP TWO WAY LOCATION",
        address: '',
      ));

      pickupTwoWayController.text = "$suggestion $postCode".toUpperCase();
      fetchRouteFromOSRM();
    }

    allAddressesData.clear();
    highlightedIndex.value = 0;
    update();
  }


  changeJourneyFtn() async{
    pickupTwoWayController.clear();
    dropOffTwoWayController.clear();
    tempStoreReturnMils = null;
    FocusScope.of(Get.context!).requestFocus(pickupTwoTextFieldFocusNode);
    polyLineMarkerInfo.removeWhere((item) =>
    item.markerType == "PICKUP TWO WAY LOCATION" ||
        item.markerType == "DROP TWO WAY LOCATION"
    );

    // 2. تمام Return map markers صاف کریں
    markers.removeWhere((marker) =>
    marker.type == "pickup two way" ||
        marker.type == "dropOff two way" ||
        marker.type == "via with return"
    );
    final pickupPolylineIndex = polyLineMarkerInfo
        .indexWhere((e) => e.markerType == "PICKUP TWO WAY LOCATION");

    if (pickupPolylineIndex >= 0) {
      polyLineMarkerInfo.removeAt(pickupPolylineIndex);
    }
    final pickupMarkerIndex =
    markers.indexWhere((e) => e.type == "pickup two way");
    if (pickupMarkerIndex >= 0) {
      markers.removeAt(pickupMarkerIndex);
    }
    pickupTwoWayController.clear();
    clearReturnViaIfNoPickupAndDrop();
    selectAirportControllerReturn.clear();
    arrivalReturnTimeController.clear();
    isAirportResponseReturn.value = false;

    polyLineMarkerInfo.removeWhere((item) => item.markerType == "PICKUP TWO WAY LOCATION");
    if (markers is List<CustomMarker>) {
      markers.removeWhere((marker) => marker.type == "PICKUP TWO WAY LOCATION");
    }
    dropDownShow.value = false;
    FocusScope.of(Get.context!).requestFocus(dropOffTwoWayTextFieldFocusNode);

    final dropPolylineIndex = polyLineMarkerInfo
        .indexWhere((e) => e.markerType == "DROP TWO WAY LOCATION");

    if (dropPolylineIndex >= 0) {
      polyLineMarkerInfo.removeAt(dropPolylineIndex);
    }
    final dropOffMarkerIndex =
    markers.indexWhere((e) => e.type == "dropOff two way");

    if (dropOffMarkerIndex >= 0) {
      markers.removeAt(dropOffMarkerIndex);
    }
    markers.removeWhere((marker) => marker.type == "via with return");

    //  Route API
    fetchRouteFromOSRM();
    update();
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> get dashboard data

  FocusNode driverDropdownFocusNode = FocusNode();

  DashboardDataModel? dashboardAllData;
  DashboardDriverObject? selectDriverValue;
  DashboardDriverObject? selectDriverValueReturn;
  DashboardSubsidiaryObject? selectSubsidiariesValue;
  DashboardVehicleTypeObject? selectVehicleValue;
  DashboardVehicleTypeObject? selectVehicleValueReturn;
  DashboardVehicleTypeObject? selectMultiVehicleValue;
  PaymentTypeObject? selectPaymentTypeValue;
  JourneyTypeObject? selectJourneyTypeValue;
  List<BookingTabObject>? bookingTabsList;
  String? bookingTabs;
  int selectedTabId = 1;

  RxBool dashboardDataLoader = false.obs;



  Future<void> getBookingCounts() async {
    try {
      var response = await Api().get("enumerations/booking-count", sendCompanyId: true);
      if (response.statusCode == 200) {
        List<dynamic> apiTabs = response.data['booking_tabs'] ?? [];
        if (bookingTabsList != null && bookingTabsList!.isNotEmpty) {
          for (var apiTab in apiTabs) {
            int index = bookingTabsList!.indexWhere((element) => element.id == apiTab['id']);
            if (index != -1) {
              bookingTabsList![index].bookingCount = apiTab['booking_count'] ?? 0;
              if (apiTab['booking_tabs'] != null) {
                bookingTabsList![index].bookingTabs = apiTab['booking_tabs'];
              }
            }
          }
          update();
        }
      }
    } catch (e) {
      print("Error fetching booking counts: $e");
    }
  }

  // void startBookingCountTimer() {
  //   _bookingCountTimer?.cancel();
  //   _bookingCountTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
  //     await getBookingCounts();
  //   });
  // }

  dashboardData() async {
    dashboardDataLoader(true);
    var response = await Api().get("enumerations/get", sendCompanyId: true);
    if (response.statusCode == 200) {
      dashboardAllData = DashboardDataModel.fromJson(response.data);
      selectSubsidiariesValue = dashboardAllData!.subsidiaries![0];
      bookingTabsList = dashboardAllData!.bookingTabs;
      bookingTabsList!.first.selectedClr!.value = true;
      bookingTabsList!.add(
        BookingTabObject(
          bookingCount: 0,
          bookingTabs: "JOB DUE BY",
          id: 0,
          deletedClr: false.obs,
          selectedClr: true.obs,
          dropDownList: [
            "JOB DUE BY",
            "15 MIN",
            "30 MIN",
            "60 MIN",
          ],
        ),
      );
      bookingTabsList!.add(
        BookingTabObject(
            bookingCount: 0,
            bookingTabs: "DELETE SELECTION",
            id: 0,
            selectedClr: false.obs,
            deletedClr: true.obs,
            dropDownList: []),
      );

      selectPaymentTypeValue = dashboardAllData!.paymentTypes![0];
      selectJourneyTypeValue = dashboardAllData!.journeyTypes![0];
      await getBookingCounts();
      // startBookingCountTimer();
      if (dashboardAllData!.vehicleTypes != null &&
          dashboardAllData!.vehicleTypes!.isNotEmpty) {
        try {
          // List me se 'saloon' naam ka vehicle object filter karein
          DashboardVehicleTypeObject saloonVehicle =
              dashboardAllData!.vehicleTypes!.firstWhere(
            (vehicle) => vehicle.name?.toLowerCase().trim() == 'saloon',
            orElse: () => dashboardAllData!.vehicleTypes!
                .first, // Agar saloon na mile to pehla item select ho jaye
          );

          // Dono Outward aur Return fields ko page load par Saloon assign kar diya
          selectVehicleValue = saloonVehicle;
          selectVehicleValueReturn = saloonVehicle;
        } catch (e) {
          // Kisi unexpected crash se bachne k lye fallback safe index [0]
          selectVehicleValue = dashboardAllData!.vehicleTypes![0];
          selectVehicleValueReturn = dashboardAllData!.vehicleTypes![0];
        }
      }

      selectVehicleValue = dashboardAllData!.vehicleTypes![0];
      getAccountData(subsidiariesId: dashboardAllData!.subsidiaries![0].id);
      getDashboardTableData(tableId: bookingTabsList!.first.id);
      dashboardDataLoader(false);
      update();
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> get account data
  DashboardAccountModel? dashboardAccountData;
  DashboardAccountObject? selectAccountValue;
  DepartmentObject? selectDepartmentData;

  getAccountData({subsidiariesId}) async {
    var response = await Api().get("accounts/subsidiary/$subsidiariesId", sendCompanyId: true,);
    if (response.statusCode == 200) {
      selectDepartmentData = null;
      selectAccountValue = null;
      dashboardAccountData = DashboardAccountModel.fromJson(response.data);
      update();
    }
  }

  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> get dashboard table data
  DashboardTableModel? dashboardTableModelData;
  final referenceNumber = TextEditingController();
  final pickupDate = TextEditingController();
  final pickupTime = TextEditingController();
  final name = TextEditingController();
  final pickup = TextEditingController();
  final dropOff = TextEditingController();
  final accountName = TextEditingController();
  final driverName = TextEditingController();
  final notes = TextEditingController();
  final fares = TextEditingController();
  final bookingStatus = TextEditingController();
  final journeyType = TextEditingController();
  final paymentType = TextEditingController();
  final vehicleTypeName = TextEditingController();

  RxInt dashboardTableCurrentPage = 1.obs;
  RxInt dashboardTableTotalPages = 1.obs;
  final int dashboardTableLimit = 20;

  Timer? _tableDashboardBebounce;

  // 👇 ye function har baar text change hone par call hoga
  Future<void> onTableChangeHandler({required String tableId}) async {
    const duration = Duration(milliseconds: 800); // 800ms ka delay]
    // selectedTextFieldsValue.value = "";
    // 👇 Agar pehle se koi timer chal raha ho to usse cancel karo
    if (_tableDashboardBebounce?.isActive ?? false)
      _tableDashboardBebounce!.cancel();

    // 👇 Naya timer start karo
    _tableDashboardBebounce = Timer(duration, () {
      _stopTableDataTyping(tableId: tableId);
    });
  }

  void _stopTableDataTyping({required String tableId}) {
    // 👇 Yahan API call ya search function call karna hai
    getDashboardTableData(tableId: tableId);
  }

  Timer? _timer;

  String? jobDue;

  getDashboardTableData({tableId}) async {
    String selectJobDue = "";
    if (jobDue != null) {
      if (jobDue == "15 MIN") {
        selectJobDue = "15";
      } else if (jobDue == "30 MIN") {
        selectJobDue = "30";
      } else {
        selectJobDue = "60";
      }
    }
    var response =
        await Api().get("bookings/getbytabs/$tableId",  sendCompanyId: true, queryParameters: {
      "page": dashboardTableCurrentPage.value,
      "limit": dashboardTableLimit,
      "reference_number": referenceNumber.text,
      "pickup_date": pickupDate.text,
      "pickup_time": pickupTime.text,
      "name": name.text,
      "pickup": pickup.text,
      "dropoff": dropOff.text,
      "account_name": accountName.text,
      "driver_name": driverName.text,
      "notes": notes.text,
      "fares": fares.text,
      "booking_status": bookingStatus.text,
      "journey_type": journeyType.text,
      "payment_type": paymentType.text,
      "vehicle_type_name": vehicleTypeName.text,
      "job_due=": selectJobDue
    });
    if (response.statusCode == 200) {
      selectedTabId = tableId;
      dashboardTableModelData = DashboardTableModel.fromJson(response.data);
      dashboardTableTotalPages.value = dashboardTableModelData!.total!;
      _checkBookingsTimeAndPlaySound(dashboardTableModelData?.data ?? []);
      _timer?.cancel();
      // _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      //   getDashboardTableData(tableId: selectedTabId);
      // });
      update();
    }
  }

  void dashboardTablePageChange(int page) {
    dashboardTableCurrentPage.value = page;
    getDashboardTableData(tableId: selectedTabId);
  }

  final AudioPlayer _audioPlayer = AudioPlayer();



  /// Sound Notification
  Future<void> playNotificationSound() async {
    try {
      String baseApi = Environment().config.baseUrl;
      String rootUrl = baseApi.replaceAll('api/', '');
      String soundUrl = "${rootUrl}uploads/notification.mp3";
      await _audioPlayer.stop();
      await _audioPlayer.play(UrlSource(soundUrl));
    } catch (e) {
      print("Error playing sound: $e");
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> get table data status base
  int temSelectedTab = 1;
  int selectionIndex = 0;

  getTableDataStatus({index, value}) async {
    int selectedIndex =
        bookingTabsList!.indexWhere((test) => test.selectedClr!.value == true);
    if (selectedIndex != -1) {
      bookingTabsList![selectedIndex].selectedClr!.value = false;
    }
    if (value != null) {
      bookingTabsList![index].selectedDropDownValue = value;
      bookingTabsList![temSelectedTab].selectedClr!.value =
          true; // <-- fix selection
      jobDue = value;
    } else {
      if (bookingTabsList![index].deletedClr!.value == true) {
        return;
      }
      if (selectedIndex != -1) {
        bookingTabsList![selectedIndex].selectedClr!.value = false;
      }
      bookingTabsList![index].selectedClr!.value = true; // <-- fix selection}
    }
    print(bookingTabsList![index].id);
    if (value == null) {
      getDashboardTableData(tableId: bookingTabsList![index].id);
    } else {
      getDashboardTableData(tableId: bookingTabsList![temSelectedTab].id);

      ///testing
    }
    update();
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> delete job api
  List<BookingObjectData>? selectedDeletesItems;

  deleteJobs() async {
    // 1. Guard clause: Exit early if nothing is selected or list is null
    if (selectedDeletesItems == null || selectedDeletesItems!.isEmpty) {
      BotToast.showText(text: "Please select deleted items");
      return;
    }

    // 2. Efficiently extract IDs
    final List<int> idsToDelete =
        selectedDeletesItems!.map((item) => int.parse(item.id!)).toList();

    final Map<String, dynamic> payload = {"id": idsToDelete};

    // 3. Pass the payload to the delete call
    final response =
        await Api().delete("bookings/bulkdelete", formData: payload);
    if (response.statusCode == 200) {
      // 4. Update the local UI state efficiently
      // Using removeWhere is faster than a nested for-loop
      dashboardTableModelData?.data?.removeWhere(
        (item) => idsToDelete.contains(int.tryParse(item.id ?? '')),
      );

      // 5. Cleanup selection
      selectedDeletesItems?.clear();

      update();
    }
  }



  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> get phone numbers

  /// Current Time
  void _checkBookingsTimeAndPlaySound(List<BookingObjectData> bookings) {
    if (bookings.isEmpty) return;
    DateTime now = DateTime.now();
    String currentDateStr = DateFormat('yyyy-MM-dd').format(now);
    String currentTimeStr = DateFormat('HH:mm').format(now);
    bool shouldPlaySound = false;
    for (var booking in bookings) {
      if (booking.pickupDate == null || booking.pickupTime == null) continue;
      try {
        String bookingDateStr = DateFormat('yyyy-MM-dd').format(booking.pickupDate!);
        String bookingTimeStr = booking.pickupTime!.trim();
        if (bookingTimeStr.contains("AM") || bookingTimeStr.contains("PM")) {
          DateTime parsedTime = DateFormat("hh:mm a").parse(bookingTimeStr);
          bookingTimeStr = DateFormat("HH:mm").format(parsedTime);
        }
        bool isSameDate = (bookingDateStr == currentDateStr);
        bool isSameTime = (bookingTimeStr == currentTimeStr);
        if (isSameDate && isSameTime) {
          String uniqueBookingKey = "${booking.id}_${bookingTimeStr}";
          if (!_playedBookingIds.contains(uniqueBookingKey)) {
            _playedBookingIds.add(uniqueBookingKey);
            shouldPlaySound = true;
          }
        }
      } catch (e) {
        print("Date/Time Parsing Error: $e");
      }
    }
    if (shouldPlaySound) {
      playNotificationSound();
    }
  }

  Timer? _phoneNumberBebounce;
// 👇 ye function har baar text change hone par call hoga
  Future<void> onPhoneNoChangeHandler(
      {required String fieldName, required String searchingText}) async {
    const duration = Duration(milliseconds: 800); // 800ms ka delay]
// selectedTextFieldsValue.value = "";
// 👇 Agar pehle se koi timer chal raha ho to usse cancel karo
    if (_phoneNumberBebounce?.isActive ?? false) _phoneNumberBebounce!.cancel();
// 👇 Naya timer start karo
    _phoneNumberBebounce = Timer(duration, () {
      _stopPhoneNoTyping(fieldName: fieldName, searchingText: searchingText);
    });
  }



  void _stopPhoneNoTyping( {required String fieldName, required String searchingText}) {
// 👇 Yahan API call ya search function call karna hai
    getPhoneNumberOfUSers(fieldsName: fieldName, searchingText: searchingText);
  }


//   GetPhoneNumbersModel? customerPhoneNumber;
//   final Rx<FocusNode> suggestionPhoneFocusNode = FocusNode().obs;
//
//   getPhoneNumberOfUSers({fieldsName, searchingText}) async {
//     dashboardDataLoader(true);
//     var response = await Api().get("customers/search?mobile=$searchingText", sendCompanyId: true);
//     if (response.statusCode == 200) {
//       if (response.data['customer'].isNotEmpty) {
//         dropDownShow.value = true;
//         customerPhoneNumber = GetPhoneNumbersModel.fromJson(response.data);
//         SuggestionController suggestion_controller =
//             Get.isRegistered<SuggestionController>()
//                 ? Get.find<SuggestionController>()
//                 : Get.put(SuggestionController());
//         suggestion_controller.allListData = customerPhoneNumber!.customerInfo!;
//         FocusScope.of(Get.context!).requestFocus(phoneNumberFieldKey);
// // FocusScope.of(Get.context!).requestFocus(phoneKeyboardFocusNode);
//         selectedTextFieldsValue.value = fieldsName;
//       } else {
//         dropDownShow.value = false;
//       }
//       dashboardDataLoader(false);
//       update();
//     }
//   }


  GetPhoneNumbersModel? customerPhoneNumber;
  final Rx<FocusNode> suggestionPhoneFocusNode = FocusNode().obs;

  Future<void> getPhoneNumberOfUSers({
    required String fieldsName,
    required String searchingText,
  }) async {
    dashboardDataLoader(true);

    var response = await Api().get("customers/search?mobile=$searchingText",sendCompanyId: true,);
    if (response.statusCode == 200) {
      final list = response.data['customer'];
      if (list != null && list.isNotEmpty) {
        customerPhoneNumber = GetPhoneNumbersModel.fromJson(response.data);
      } else {
        customerPhoneNumber = null;   // empty → dropdown shows "No data"
      }
      dashboardDataLoader(false);
      update();                       // rebuild GetBuilder → autocomplete refilters
    }
  }

  TextEditingController newCustomController = TextEditingController();
  FocusNode newCustomFieldKey = FocusNode();
  FocusNode newCustomKeyboardFocusNode = FocusNode();
  final Rx<FocusNode> suggestionNewCustomFocusNode = FocusNode().obs;
  Timer? _newCustomDebounce;

  // ==================== DEBOUNCE HANDLER ====================
  Future<void> onNewCustomChangeHandler(
      {required String fieldName, required String searchingText}) async {
    const duration = Duration(milliseconds: 800);
    if (_newCustomDebounce?.isActive ?? false) _newCustomDebounce!.cancel();
    _newCustomDebounce = Timer(duration, () {
      _stopNewCustomTyping(fieldName: fieldName, searchingText: searchingText);
    });
  }

  void _stopNewCustomTyping(
      {required String fieldName, required String searchingText}) {
    getPhoneNumberOfUSers(fieldsName: fieldName, searchingText: searchingText);
  }


  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> get Fare API
  getFaresCalculation() async {




    final storedTemFare = await getFares(
      // day: ,
      journeyTypeId: selectJourneyTypeValue!.id,
      multiReservationList:
          multiReservationList.isEmpty ? null : multiReservationList,
      dropOff: dropOffController.text,
      pickup: pickupController.text,
      miles: tempStoreMils,
      dropoffPlotId:
          dashboardDZoneValue != null ? dashboardDZoneValue!.id : null,
      pickUpPlotId: dashboardZoneValue != null ? dashboardZoneValue!.id : null,
      pickupDate: "${pickUpDate!.year}-${pickUpDate!.month}-${pickUpDate!.day}",
      pickupTime: pickUpTimeController.text,
      vehicleTypeId: selectVehicleValue == null ? null : selectVehicleValue!.id,
      returnVehicleTypeId :selectVehicleValueReturn == null ? null : selectVehicleValueReturn!.id,
      congestionCharges: congestionChargesController.text.isEmpty
          ? null
          : congestionChargesController.text,
      partingCharges: parkingChargesController.text.isEmpty
          ? null
          : parkingChargesController.text,
      meetGreet:
          meetGreetController.text.isEmpty ? null : meetGreetController.text,
      waitingCharges: waitingChargesController.text.isEmpty
          ? null
          : waitingChargesController.text,
      extraDropCharges: extraDropChargesController.text.isEmpty
          ? null
          : extraDropChargesController.text,
      creditCardCharges: creditCardChargesController.text.isEmpty
          ? null
          : creditCardChargesController.text,
      companyPrice: companyPriceController.text.isEmpty
          ? null
          : companyPriceController.text,

      withReturnPickUp: pickupTwoWayController.text.isEmpty
          ? null
          : pickupTwoWayController.text,
      withReturnDropOff: dropOffTwoWayController.text.isEmpty
          ? null
          : dropOffTwoWayController.text,
      returnPickupDate:
          "${pickUpDateReturn!.year}-${pickUpDateReturn!.month}-${pickUpDateReturn!.day}",
      returnPickupTime:
      // pickUpTimeControllerReturn.text.isEmpty
      //     ? null
      //     :
      pickUpTimeControllerReturn.text,
      // selectVehicleValueReturn
      returnCompanyPrice: companyPriceController.text.isEmpty
          ? null
          : companyPriceController.text,
      returnParkingCharges: returnCompanyPriceController.text.isEmpty
          ? null
          : returnCompanyPriceController.text,
      returnMiles: dropOffTwoWayController.text.isNotEmpty &&
          pickupTwoWayController.text.isNotEmpty
          ? (double.parse(totalDistance.value) -
                  double.parse(tempStoreMils.toString()))
              .toString()
          : null,
      isOneWay: isOneWayJourney,
      isWaitAndReturn: jourValue == 'W/R',
      // returnMiles: () {
      //   if (dropOffTwoWayController.text.isNotEmpty || pickupTwoWayController.text.isNotEmpty) {
      //     // Agar outbound pickup ya dropoff me se koi ek bhi khali ho gaya hai
      //     if (pickupController.text.isEmpty || dropOffController.text.isEmpty) {
      //       // Pure route (Via + Return) ka distance utha kar returnMiles me bhej do
      //       double totalDist = double.tryParse(totalDistance.value) ?? 0.0;
      //       return totalDist > 0 ? totalDist.toStringAsFixed(2) : null;
      //     } else {
      //       // Normal flow (Agar kuch delete nahi hua)
      //       double totalDist = double.tryParse(totalDistance.value) ?? 0.0;
      //       double mainMils = double.tryParse(tempStoreMils.toString()) ?? 0.0;
      //       double diff = totalDist - mainMils;
      //       return (diff > 0 ? diff : 0.0).toStringAsFixed(2);
      //     }
      //   }
      //   return null;
      // }(),
    );
    var fareValue = jsonDecode(storedTemFare);
    // Extract fares safely
    final totalFare =
        fareValue == null ? "0" : (fareValue['total_fare'] ?? "0").toString();
    final returnFare =
        fareValue == null ? "0" : (fareValue['return_fare'] ?? "0").toString();
    // Calculate one-way fare (excluding return segment)
    double total = double.tryParse(totalFare) ?? 0.0;
    double ret = double.tryParse(returnFare) ?? 0.0;
    final oneWayFare = (total - ret).toStringAsFixed(2);
    fixedFare.value = oneWayFare;
    returnFareValue = returnFare;
    slugControllerReturn.text = returnFare;
    slugController.text = oneWayFare;
    print("Fixed fare Value-- ${fixedFare.value}");
    print("returnFareValue-- ${returnFareValue}");
    print("slugControllerReturn-- ${slugControllerReturn.text}");
    print("slugController-- ${slugController.text}");
    update();
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Multi Reservation variables
  var datePickerResetKey = UniqueKey();
  DateTime? multiReservationFromDate = DateTime.now();
  DateTime? multiReservationToDate = DateTime.now();
  final multiReservationToTimeController = TextEditingController(
      text:
          "${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}");
  final returnMultiReservationToTimeController = TextEditingController(
      text:
          "${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}");

  List<MultiReservation> multiReservationList = [];
  List<String> multiReservationDaysList = [];

  void addDayToTempList(String day) {
    if (multiReservationDaysList.contains(day)) {
      multiReservationDaysList.remove(day);
    } else {
      multiReservationDaysList.add(day);
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> start to end date are filters
  List<DateTime> getDatesBetween({
    required DateTime start,
    required DateTime end,
  }) {
    List<DateTime> dates = [];

    DateTime current = DateTime(start.year, start.month, start.day);

    while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
      dates.add(current);
      current = current.add(const Duration(days: 1));
    }

    return dates;
  }

  addToMultiReservation({
    DateTime? startTime,
    DateTime? endTime,
    required List<String> selectedDays,
    required String time,
    returnTime,
  }) async {
    if (startTime == null || endTime == null) {
      return BotToast.showText(
          text: "Please select start and end date with time");
    }

    if (selectedDays.isEmpty) {
          return BotToast.showText(text: "Please select day");
    }

    multiReservationList.clear();

    final allDates = getDatesBetween(start: startTime, end: endTime);

    // Convert selected day names → weekday numbers
    final selectedWeekdays = selectedDays.map(dayNameToWeekday).toList();

    for (final DateTime date in allDates) {
      if (selectedWeekdays.contains(date.weekday)) {
        final dayIndex = selectedWeekdays.indexOf(date.weekday);

        multiReservationList.add(
          MultiReservation(
            startDate: "${date.year}-${date.month}-${date.day}",
            day: selectedDays[dayIndex],
            exclude: false,
            returnTime: time,
            endTime: returnTime,
          ),
        );
      }
    }

    refreshMultiReservationData();
  }

  int dayNameToWeekday(String day) {
    switch (day.toLowerCase()) {
      case 'monday':
        return DateTime.monday;
      case 'tuesday':
        return DateTime.tuesday;
      case 'wednesday':
        return DateTime.wednesday;
      case 'thursday':
        return DateTime.thursday;
      case 'friday':
        return DateTime.friday;
      case 'saturday':
        return DateTime.saturday;
      case 'sunday':
        return DateTime.sunday;
      default:
        throw Exception("Invalid day name");
    }
  }

  void resetMultiReservationFields() {
    multiReservationFromDate = DateTime.now();
    multiReservationToDate = DateTime.now();
    String currentTime =
        "${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}";
    multiReservationToTimeController.text = currentTime;
    returnMultiReservationToTimeController.text = currentTime;
    multiReservationList.clear();
    multiReservationDaysList.clear();
    mondayValue.value = false;
    tuesdayValue.value = false;
    wednesdayValue.value = false;
    thursdayValue.value = false;
    fridayValue.value = false;
    saturdayValue.value = false;
    sundayValue.value = false;
    datePickerResetKey = UniqueKey();
    update();
  }

  refreshMultiReservationData() async {
    multiReservationDaysList.clear();
    mondayValue.value = false;
    tuesdayValue.value = false;
    wednesdayValue.value = false;
    thursdayValue.value = false;
    fridayValue.value = false;
    saturdayValue.value = false;
    sundayValue.value = false;
    update();
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo post dashboard api
  final pickUpNoteController = TextEditingController();
  final dropUpNoteController = TextEditingController();
  final returnPickUpNoteController = TextEditingController();
  final returnDropUpNoteController = TextEditingController();
  ZoneObject? dashboardZoneValue;
  ZoneObject? dashboardRNZoneValue;
  ZoneObject? dashboardRN1ZoneValue;
  ZoneObject? dashboardDZoneValue;
  DateTime? pickUpDate = DateTime.now();
  DateTime? pickUpDateReturn = DateTime.now();
  /// Pickup time defaults to the current time, matching [pickUpDate] above.
  /// TimePickerField reads and writes this as a 24h `HH:mm` string.
  final pickUpTimeController = TextEditingController(text: nowHHmm);
  final pickUpTimeControllerReturn = TextEditingController(text: nowHHmm);

  /// Set as soon as the user picks a value in the matching date/time field on
  /// the dashboard form. Anything still false counts as "never chosen".
  bool pickUpDatePicked = false;
  bool pickUpTimePicked = false;
  bool pickUpDateReturnPicked = false;
  bool pickUpTimeReturnPicked = false;
  bool arrivalTimePicked = false;
  bool arrivalReturnTimePicked = false;

  /// Re-seeds every date/time field the user never touched with "now", leaving
  /// user-picked values exactly as chosen. Called just before the booking is
  /// posted: this controller can stay alive for hours, so the date/time seeded
  /// when it was created would otherwise be posted stale.
  void refreshUntouchedDateTimeFields() {
    final now = DateTime.now();
    final nowTime = DateFormat('HH:mm').format(now);
    if (!pickUpDatePicked) pickUpDate = now;
    if (!pickUpTimePicked) pickUpTimeController.text = nowTime;
    if (!pickUpDateReturnPicked) pickUpDateReturn = now;
    if (!pickUpTimeReturnPicked) pickUpTimeControllerReturn.text = nowTime;
    if (!arrivalTimePicked) arrivalTimeController.text = nowTime;
    if (!arrivalReturnTimePicked) arrivalReturnTimeController.text = nowTime;
    update();
  }

  final passController = TextEditingController();
  final luggController = TextEditingController();
  final sluggController = TextEditingController();
  List restrictedDrivers = [];
  List childSeatList = [];
  List extraFaresList = [];
  List extraFaresReturnList = [];
  List viaPostList = [];
  List viaReturnPostList = [];
  List multiReservationTemp = [];
  List<DashboardVehicleTypeObject> multiVehicleList = [];
  List multiVehicleTempList = [];

  dashBoardApiValidation({int? id}) async {
    if (pickupController.text.isEmpty) {
      return BotToast.showText(text: "Please select pickup location");
    }

    if (dropOffController.text.isEmpty) {
      return BotToast.showText(text: "Please select dropoff location");
    }

    if (selectSubsidiariesValue == null) {
      return BotToast.showText(text: "Please select subsidiaries");
    }

    // if (nameController.text.isEmpty) {
    //   return BotToast.showText(text: "Please write name");
    // }
    //
    // if (emailController.text.isEmpty) {
    //   return BotToast.showText(text: "Please write email");
    // }

    if (mobileController.text.isEmpty) {
      return BotToast.showText(text: "Please write mobile");
    }
    if (pickUpTimeController.text.isEmpty) {
      return BotToast.showText(text: "Please select pickup time");
    }
    if (selectJourneyTypeValue == null) {
      return BotToast.showText(text: "Please select journey type");
    }
    if (selectPaymentTypeValue == null) {
      return BotToast.showText(text: "Please select payment type");
    }
    if (selectVehicleValue == null) {
      return BotToast.showText(text: "Please select vehicle type");
    }

    postDashboardApi(id: id);
    return null;
  }

  postDashboardApi({int? id}) async {
    /// Fields the user never opened go out as the current date/time; anything
    /// they picked on the form is posted as selected.
    refreshUntouchedDateTimeFields();

    ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> send restricted driver and child set configuration
    await restrictedDriversListConfig();

    if (viaPoints.isNotEmpty) {
      await postViaListConfig();
    }

    int pickUpTwoIndex =
        markers.indexWhere((test) => test.type == "pickup two way");
    int pickUpIndex = markers.indexWhere((test) => test.type == "pickup");
    int dropOffIndex = markers.indexWhere((test) => test.type == "dropOff");
    int dropOffTwoIndex =
        markers.indexWhere((test) => test.type == "dropOff two way");
    double? pickUpLatLat;
    double? pickUpLngLat;
    double? dropOffLatLat;
    double? dropOffLngLat;
    double? pickUpLatTwoLat;
    double? pickUpLngTwoLat;
    double? dropOffLatTwoLat;
    double? dropOffLngTwoLat;

    // Check if the marker was actually found to avoid errors
    if (pickUpIndex != -1) {
      // Assuming 'lat' is a property or constant available in your scope
      pickUpLatLat = markers[pickUpIndex].point.latitude;
      pickUpLngLat = markers[pickUpIndex].point.longitude;
    }

    // Check if the marker was actually found to avoid errors
    if (dropOffIndex != -1) {
      // Assuming 'lat' is a property or constant available in your scope
      dropOffLatLat = markers[dropOffIndex].point.latitude;
      dropOffLngLat = markers[dropOffIndex].point.longitude;
    }

// Check if the marker was actually found to avoid errors
    if (pickUpTwoIndex != -1) {
      // Assuming 'lat' is a property or constant available in your scope
      pickUpLatTwoLat = markers[pickUpTwoIndex].point.latitude;
      pickUpLngTwoLat = markers[pickUpTwoIndex].point.longitude;
    }
// Check if the marker was actually found to avoid errors
    if (dropOffTwoIndex != -1) {
      // Assuming 'lat' is a property or constant available in your scope
      dropOffLatTwoLat = markers[dropOffTwoIndex].point.longitude;
      dropOffLngTwoLat = markers[dropOffTwoIndex].point.longitude;
    }

    var formData = {
      'pickup': pickupController.text,
      if (dashboardZoneValue != null) 'pickup_plot': dashboardZoneValue!.id,
      'pickup_door_number': pickUpNoteController.text,

      'pickup_latitude': pickUpLatLat,
      'pickup_longitude': pickUpLngLat,
      'dropoff': dropOffController.text,
      if (dashboardDZoneValue != null) 'dropoff_plot': dashboardDZoneValue!.id,
      'dropoff_door_number': dropUpNoteController.text,
      'dropoff_latitude': dropOffLatLat,
      'dropoff_longitude': dropOffLngLat,
      if (viaPostList.isNotEmpty) 'viapoints': jsonEncode(viaPostList),
      // if (nameController.text.isNotEmpty) 'name': nameController.text,
      // if (emailController.text.isNotEmpty) 'email': emailController.text,

      'name':
          nameController.text.isNotEmpty ? nameController.text : 'Passenger',
      'email': emailController.text.isNotEmpty
          ? emailController.text
          : 'Dumy@gmail.com',

      if (mobileController.text.isNotEmpty) 'mobile': mobileController.text,
      if (telController.text.isNotEmpty) 'telephone': telController.text,
      'customer': // '[{name: "${nameController.text}", email: "${emailController.text}", mobile: "${mobileController.text}", telephone: "${telController.text}", blacklist: false}]',
          '[{name: "${nameController.text == "" ? "Passenger" : nameController.text}", email: "${emailController.text == '' ? "Dumy@gmail.com" : emailController.text}", mobile: "${mobileController.text}", telephone: "${telController.text}", blacklist: false}]',
      'pickup_date':
          "${pickUpDate!.year}-${pickUpDate!.month}-${pickUpDate!.day}",
      if (pickUpTimeController.text.isNotEmpty)
        'pickup_time': pickUpTimeController.text.trim(),
      if (minController.text.isNotEmpty) 'lead_time': minController.text,
      'journey_type_id':
          selectJourneyTypeValue != null ? selectJourneyTypeValue!.id : 1,
      if (selectAccountValue != null) 'account_id': selectAccountValue!.id,
      if (selectDepartmentData != null) 'department': selectDepartmentData!.id,
      'quotation': switchController.value,
      'sms': true /*smsCheckbox.value*/,
      'emailFlag': emailCheckbox.value,
      if (passController.text.isNotEmpty) 'passengers': passController.text,
      if (luggController.text.isNotEmpty) 'luggages': luggController.text,
      if (sluggController.text.isNotEmpty)
        'hand_luggages': sluggController.text,
      if (selectPaymentTypeValue != null)
        'payment_type_id': selectPaymentTypeValue!.id,
      if (selectVehicleValue != null) 'vehicle_type_id': selectVehicleValue!.id,
      if (restrictedDrivers.isNotEmpty)
        'restricted_drivers': jsonEncode(restrictedDrivers),
      if (childSeatList.isNotEmpty) 'child_seat': jsonEncode(childSeatList),
      if (parkingChargesController.text.isNotEmpty)
        'parking_charges': parkingChargesController.text,
      if (congestionChargesController.text.isNotEmpty)
        'congestion_charges': congestionChargesController.text,
      if (meetGreetController.text.isNotEmpty)
        'meet_and_greet': meetGreetController.text,
      if (waitingChargesController.text.isNotEmpty)
        'waiting_charges': waitingChargesController.text,
      if (extraDropChargesController.text.isNotEmpty)
        'extra_drop_charges': extraDropChargesController.text,
      if (creditCardChargesController.text.isNotEmpty)
        'credit_card_charges': creditCardChargesController.text,
      if (companyPriceController.text.isNotEmpty)
        'company_price': companyPriceController.text,
      // "total_charges": ,
      // "RETURN COMPANY PRICE": "????????????????????????????????????????????? taj missing",
      if (specialRequirementsController.text.isNotEmpty)
        'special_instructions': specialRequirementsController.text,
      if (extraFaresList.isNotEmpty) 'notes': jsonEncode(extraFaresList),
      if (selectDriverValue != null) 'driver_id': selectDriverValue!.id,
      if (slugController.text.isNotEmpty) 'fares': slugController.text,
      'eta': totalTimeDuration.value,
      'miles': totalDistance,
      if (selectSubsidiariesValue != null)
        'subsidiary_id': selectSubsidiariesValue!.id,
      'booking_status_id': '1',
      'booking_type_id':
          multiVehicleTempList.isNotEmpty || multiReservationTemp.isNotEmpty
              ? '2'
              : '1',
      'booking_source': 'dashboard',
      'employee_id': Employee.selectedEmployee?.id,
      if (multiReservationTemp.isNotEmpty)
        "multi_reservation": jsonEncode(multiReservationTemp),
      if (multiVehicleTempList.isNotEmpty)
        "multi_vehicle": jsonEncode(multiVehicleTempList),

      /// todo waiting return
      if (pickupTwoWayController.text.isNotEmpty)
        "return_pickup": pickupTwoWayController.text,
      if (dropOffTwoWayController.text.isNotEmpty)
        "return_dropoff": dropOffTwoWayController.text,
      if (pickUpLatTwoLat != null) "return_pickup_latitude": pickUpLatTwoLat,
      if (pickUpLngTwoLat != null) "return_pickup_longitude": pickUpLngTwoLat,
      if (dropOffLatTwoLat != null) "return_dropoff_latitude": dropOffLatTwoLat,
      if (dropOffLngTwoLat != null)
        "return_dropoff_longitude": dropOffLngTwoLat,
      'return_pickup_door_number': returnPickUpNoteController.text,
      'return_dropoff_door_number': returnDropUpNoteController.text,

      if (pickupTwoWayController.text.isNotEmpty)
        "return_pickup_date":
            "${pickUpDateReturn!.year}-${pickUpDateReturn!.month}-${pickUpDateReturn!.day}",
      if (dropOffTwoWayController.text.isNotEmpty)
        "return_pickup_time": pickUpTimeControllerReturn.text,
      if (viaReturnPostList.isNotEmpty)
        'return_viapoints': jsonEncode(viaReturnPostList),
      if (selectDriverValueReturn != null)
        "return_driver_id": selectDriverValueReturn!.id,
      if (selectVehicleValueReturn != null)
        "return_vehicle_type_id": selectVehicleValueReturn!.id,
      if (pickupTwoWayController.text.isNotEmpty)
        "return_fare": returnFareValue,
      if (extraFaresReturnList.isNotEmpty)
        "return_notes": jsonEncode(extraFaresReturnList),
      if (selectAirportController.text.isNotEmpty)
        "flight_number": selectAirportController.text,
      if (arrivalTimeController.text.isNotEmpty)
        "arriving_from": arrivalTimeController.text,
      if (selectAirportControllerReturn.text.isNotEmpty)
        "return_flight_number": selectAirportControllerReturn.text,
      if (arrivalReturnTimeController.text.isNotEmpty)
        "return_arriving_from": arrivalReturnTimeController.text,
      "total_charges": double.parse(fixedFare.value).toStringAsFixed(1)


      /// todo waiting return
    };
    print(markers);
    print("------------------------- ${formData}");
    var response = await Api().post(formData,  id == null ? "bookings/add" : "bookings/update/$id",auth: true, sendCompanyId: true, );
    if (response.statusCode == 200) {
      if (id != null) {
        refreshPostAllFields();
      } else {
        if ("${pickUpDate!.year}-${pickUpDate!.month}-${pickUpDate!.day}" ==
                "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}" &&
            selectedTabId == 1) {
          dashboardTableModelData!.data!.insert(
              0, BookingObjectData.fromJson(response.data['bookings'][0]));
        } else if ("${pickUpDate!.year}-${pickUpDate!.month}-${pickUpDate!.day}" !=
                "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}" &&
            selectedTabId == 2) {
          dashboardTableModelData!.data!.insert(
              0, BookingObjectData.fromJson(response.data['bookings'][0]));
        }

        refreshPostAllFields();
      }
      print(response.data);
    }
  }

  restrictedDriversListConfig() async {
    if (driversList.isNotEmpty) {
      restrictedDrivers.clear();
      for (var driverss in driversList) {
        restrictedDrivers.add({
          "id": driverss.id,
          "username": driverss.username,
          "name": driverss.name,
        });
      }
    }
    if (childSeatAlert.isNotEmpty) {
      childSeatList.clear();
      for (var ele in childSeatAlert) {
        childSeatList.add({
          "child": ele.sets,
          "age": ele.age,
        });
      }
    }
    if (controllerAlert.isNotEmpty) {
      extraFaresList.clear();
      extraFaresReturnList.clear();
      for (var index in controllerAlert) {
        if (index.title == "controller return note") {
          extraFaresReturnList.add({
            "note": index.note,
            "created_at": "2025-11-25 16:10",
            "created_by": "nadeem"
          });
        } else {
          extraFaresList.add({
            "note": index.note,
            "created_at": "2025-11-25 16:10",
            "created_by": "nadeem"
          });
        }
      }
    }

    if (multiReservationList.isNotEmpty) {
      for (var element in multiReservationList) {
        DateTime parsedDate = DateFormat('yyyy-M-d').parse(element.startDate!);

// 2. Format it into your desired output (yyyy-MM-dd)
        String tempDateStore = DateFormat('yyyy-MM-dd').format(parsedDate);

        print(tempDateStore); // Output: 2026-01-05
        multiReservationTemp.add({
          "exclude": element.exclude,
          "day": element.day,
          "pickup_date": tempDateStore,
          "pickup_time": element.returnTime,
          "return_pickup_time": element.endTime,
        });
      }
    }

    if (multiVehicleList.isNotEmpty) {
      for (var element in multiVehicleList) {
        multiVehicleTempList.add({
          "vehicle_type": element.id,
        });
      }
    }
    update();
  }

  postViaListConfig() async {
    viaPostList.clear();
    viaReturnPostList.clear();
    print(viaPoints);
    for (var action in viaPoints) {
      print(action.withReturnWay);
      if (action.withReturnWay == 'via') {
        viaPostList.add({
          "viapoint": action.address,
          "name": action.name,
          "mobile": action.mobile,
          "arrived": null,
          "passenger_on_board": null,
          "active": false,
          "latitude": action.lat,
          "longitude": action.lng
        });
      } else {
        viaReturnPostList.add({
          "viapoint": action.address,
          "name": action.name,
          "mobile": action.mobile,
          "arrived": null,
          "passenger_on_board": null,
          "active": false,
          "latitude": action.lat,
          "longitude": action.lng
        });
      }
    }
    update();
  }

  refreshPostAllFields() async {
    final LocationController _controller =
    Get.isRegistered<LocationController>()
        ? Get.find<LocationController>()
        : Get.put(LocationController());
    pickupController.clear();
    tempStoreMils = null;
    pickUpNoteController.clear();
    returnPickUpNoteController.clear();
    returnDropUpNoteController.clear();
    dropOffController.clear();
    dropUpNoteController.clear();
    nameController.clear();
    emailController.clear();
    mobileController.clear();
    selectAirportController.clear();
    arrivalTimeController.text = nowHHmm;
    arrivalReturnTimeController.text = nowHHmm;
    pickupTwoWayController.clear();
    dropOffTwoWayController.clear();
    telController.clear();
    minController.clear();
    minControllerReturn.clear();
    passController.clear();
    luggController.clear();
    sluggController.clear();
    parkingChargesController.clear();
    congestionChargesController.clear();
    meetGreetController.clear();
    waitingChargesController.clear();
    extraDropChargesController.clear();
    creditCardChargesController.clear();
    companyPriceController.clear();
    returnCompanyPriceController.clear();
    specialRequirementsController.clear();
    specialRequirementsReturnController.clear();
    controllerNoteController.clear();
    controllerNoteReturnController.clear();
    slugController.clear();
    slugControllerReturn.clear();
    // Back to "now" rather than empty — the field is pre-filled for a new
    // booking, and the controller can outlive the booking it was created for
    // (a loaded job overwrites this via dashBoardDataBinding).
    pickUpTimeController.text = nowHHmm;
    pickUpTimeControllerReturn.text = nowHHmm;
    pickUpDate = DateTime.now();
    pickUpDateReturn = DateTime.now();
    // Nothing is user-picked on a fresh form, so every date/time field tracks
    // "now" again until the operator opens one.
    pickUpDatePicked = false;
    pickUpTimePicked = false;
    pickUpDateReturnPicked = false;
    pickUpTimeReturnPicked = false;
    arrivalTimePicked = false;
    arrivalReturnTimePicked = false;
    viaPostList.clear();
    viaReturnPostList.clear();
    restrictedDrivers.clear();
    childSeatList.clear();
    extraFaresList.clear();
    extraFaresReturnList.clear();
    driversList.clear();
    childSeatAlert.clear();
    controllerAlert.clear();
    multiReservationTemp.clear();
    multiVehicleList.clear();
    multiVehicleTempList.clear();
    viaPoints.clear();
    dashboardZoneValue = null;
    dashboardDZoneValue = null;
    dashboardRNZoneValue = null;
    dashboardRN1ZoneValue = null;
    _controller.zoneValue = null;
    _controller.zoneDValue = null;
    selectAccountValue = null;
    selectDepartmentData = null;
    selectDriverValueReturn = null;
    selectVehicleValueReturn = null;
    switchController.value = false;
    smsCheckbox.value = true;
    emailCheckbox.value = false;
    markers.clear();
    polylines.clear();
    polylinePointsCoordinate.clear();
    polyLineMarkerInfo.clear();
    polylinePoints.clear();
    multiReservationToTimeController.clear();
    multiReservationDaysList.clear();
    multiReservationList.clear();
    viaTextEditingController.clear();
    totalDistance.value = "0";
    totalTimeDuration.value = "0";
    fixedFare.value = "0";
    returnFareValue = "0";

    // ---- FL (Flight) row hide ----
    isAirportResponse.value = false;

    // ---- Journey type reset to O/W & return section hidden ----
    jourValue = 'O/W';
    returnTrip.value = false;
    selectJourneyTypeValue = dashboardAllData!.journeyTypes![0];

    // ---- Dropdown labels reset back to placeholder text ----
    selectedJourneyType = 'O/W';
    selectedVehicleType = 'SELECT VEHICLE';
    selectedAccountType = 'SELECT ACCOUNT';
    selectedPaymentMethod = 'SELECT PAYMENT';
    selectedDriver = 'SELECT DRIVER';

    selectSubsidiariesValue = dashboardAllData!.subsidiaries![0];
    selectPaymentTypeValue = dashboardAllData!.paymentTypes![0];
    selectVehicleValue = dashboardAllData!.vehicleTypes![0];
    selectDriverValue = null;
    jobDetails = null;
    dashboardDataLoader(false);
    update();
  }

  /// Clear button k liye alag call — same reset use hoga
  clearAllFields() {
    refreshPostAllFields();
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo data binding for update
  BookingObjectData? jobDetails;

  dashBoardDataBinding(
      {BookingObjectData? jobData, id, bool hitAddBooking = false, cliHit = false}) async {
    var response = await Api().get("bookings/getbyid/$id");
    // var response = await Api().get("bookings/getbyid/$id");
    if (response.statusCode == 200) {
      BookingObjectData jobData =
          BookingObjectData.fromJson(response.data['booking']);
      jobDetails = jobData;
      polyLineMarkerInfo.clear();
      viaPoints.clear();
      polylinePoints.clear();
      pickupController.text = jobData.pickup.toString().toUpperCase();
      dropOffController.text = jobData.dropoff.toString().toUpperCase();

      polylinePoints.add(
        LatLng(double.parse(jobData.pickupLatitude!),
            double.parse(jobData.pickupLongitude!)),
      );
      polylinePoints.add(
        LatLng(double.parse(jobData.dropoffLatitude!),
            double.parse(jobData.dropoffLongitude!)),
      );
      polyLineMarkerInfo.add(ViaPoint(
        lat: double.parse(jobData.pickupLatitude!),
        lng: double.parse(jobData.pickupLongitude!),
        markerType: "PICKUP LOCATION",
        address: '',
      ));
      polyLineMarkerInfo.add(ViaPoint(
        lat: double.parse(jobData.dropoffLatitude!),
        lng: double.parse(jobData.dropoffLongitude!),
        markerType: "DROP LOCATION",
        address: '',
      ));

      for (var item in jobData.viapoints!) {
        final p = LatLng(double.parse(item.latitude.toString()),
            double.parse(item.longitude.toString()));
        polylinePoints.add(LatLng(p.latitude, p.longitude));

        viaPoints.add(ViaPoint(
          withReturnWay: 'via',
          // name: currentTypeName,
          address: item.viapoint!,
          lat: p.latitude,
          lng: p.longitude,
        ));
        viaTextEditingController.add(ViaTextEditingControllerClass(
            TextEditingController(text: item.name ?? ""),
            TextEditingController(text: item.mobile ?? "")));

        // markers.add(
        //   CustomMarker(
        //     withReturnType: "via",
        //     child: Icon(Icons.location_pin,
        //         color: DynamicColors.primaryClr,
        //         size: 30),
        //     type: "via",
        //     point: p,
        //     width: 30,
        //     height: 30,
        //   ),
        // );
      }

      fetchRouteFromOSRM();

      nameController.text = jobData.name!.toUpperCase();
      emailController.text = jobData.email!;
      mobileController.text = jobData.mobile!;
      if (jobData.telephone != null) {
        telController.text = jobData.telephone!;
      }
      if(cliHit == true){
        pickUpTimeController.text = DateFormat('HH:mm').format(DateTime.now());
      }else{
        pickUpTimeController.text = jobData.pickupTime!;
      }
      // A time carried over from an existing job is a real choice — don't let
      // refreshUntouchedDateTimeFields() overwrite it with "now" on post.
      pickUpTimePicked = true;
      // Same for the date: the job's own pickup date, so the Date field shows
      // the booking date instead of today's.
      if (jobData.pickupDate != null) {
        pickUpDate = jobData.pickupDate;
        pickUpDatePicked = true;
      }
      minController.text = jobData.leadTime ?? "";

      if (jobData.passengers != null) {
        passController.text = jobData.passengers.toString();
      }
      if (jobData.luggages != null) {
        luggController.text = jobData.luggages.toString();
      }
      if (jobData.handLuggages != null) {
        sluggController.text = jobData.handLuggages.toString();
      }
      if (jobData.parkingCharges != null) {
        parkingChargesController.text = jobData.parkingCharges.toString();
      }
      if (jobData.congestionCharges != null) {
        congestionChargesController.text = jobData.congestionCharges.toString();
      }
      if (jobData.meetAndGreet != null) {
        meetGreetController.text = jobData.meetAndGreet.toString();
      }
      if (jobData.waitingCharges != null) {
        waitingChargesController.text = jobData.waitingCharges.toString();
      }
      if (jobData.extraDropCharges != null) {
        extraDropChargesController.text = jobData.extraDropCharges.toString();
      }
      if (jobData.creditCardCharges != null) {
        creditCardChargesController.text = jobData.creditCardCharges.toString();
      }
      if (jobData.companyPrice != null) {
        companyPriceController.text = jobData.companyPrice.toString();
      }
      if (jobData.specialInstructions != null) {
        specialRequirementsController.text =
            jobData.specialInstructions.toString();
      }
      slugController.text = jobData.fares.toString();

      if (jobData.pickupDoorNumber != null) {
        pickUpNoteController.text = jobData.pickupDoorNumber.toString();
      }
      if (jobData.dropoffDoorNumber != null) {
        dropUpNoteController.text = jobData.dropoffDoorNumber.toString();
      }
      slugController.text = jobData.fares.toString();

      if (jobData.childSeat!.isNotEmpty) {
        for (var action in jobData.childSeat!) {
          childSeatAlert.add(ChildSeatClass(
            sets: action.child,
            age: action.age,
          ));
        }
      }

      if (jobData.restrictedDrivers?.isNotEmpty ?? false) {
        final restrictedIds =
            jobData.restrictedDrivers!.map((e) => e.id.toString()).toSet();
        driversList.addAll(allDriverData!.drivers!
            .where((driver) => restrictedIds.contains(driver.id.toString())));
      }

// 1. Using firstWhereOrNull (Cleanest & Safest)
      if (jobData.subsidiaryId != null) {
        selectSubsidiariesValue =
            dashboardAllData?.subsidiaries?.firstWhereOrNull(
          (subsidiary) => subsidiary.id == jobData.subsidiaryId,
        );
      }

      ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>get account data subsidiaries base
      await getAccountData(subsidiariesId: selectSubsidiariesValue!.id ?? 1);

// Professional approach using the 'collection' package
      selectAccountValue = dashboardAccountData?.accounts?.firstWhereOrNull(
        (account) => account.id == jobData.accountId,
      );

      selectDepartmentData = dashboardAccountData?.accounts
          ?.expand((account) => account.departments ?? [])
          .firstWhere(
            (dept) => dept.id.toString() == jobData.department.toString(),
            orElse: () => null, // This mimics the 'OrNull' behavior
          );

// 1. Using firstWhereOrNull (Cleanest & Safest)
      if (jobData.paymentTypeId != null) {
        selectPaymentTypeValue =
            dashboardAllData?.paymentTypes?.firstWhereOrNull(
          (payment) => payment.id == jobData.paymentTypeId,
        );
      }

      // 1. Using firstWhereOrNull (Cleanest & Safest)
      if (jobData.journeyTypeId != null) {
        selectJourneyTypeValue =
            dashboardAllData?.journeyTypes?.firstWhereOrNull(
          (journey) => journey.id == jobData.journeyTypeId,
        );
      }

      // 1. Using firstWhereOrNull (Cleanest & Safest)
      if (jobData.vehicleTypeId != null) {
        selectVehicleValue = dashboardAllData?.vehicleTypes?.firstWhereOrNull(
          (vehicle) => vehicle.id == jobData.vehicleTypeId,
        );
      }

      final LocationController _controller =
          Get.isRegistered<LocationController>()
              ? Get.find<LocationController>()
              : Get.put(LocationController());

      final zones = _controller.locationtypezoneModel?.zonesList;

      if (zones != null) {
        _controller.updateLocationValue.value == true;
        // Find pickup zone
        if (jobData.pickupPlot != null) {
          dashboardZoneValue =
              zones.firstWhereOrNull((z) => z.id == jobData.pickupPlot);
          _controller.zoneValue =
              zones.firstWhereOrNull((z) => z.id == jobData.pickupPlot);
        }

        // Find dropoff zone
        if (jobData.dropoffPlot != null) {
          dashboardDZoneValue =
              zones.firstWhereOrNull((z) => z.id == jobData.dropoffPlot);
          _controller.zoneDValue =
              zones.firstWhereOrNull((z) => z.id == jobData.dropoffPlot);
        }

        _controller.updateLocationValue.value == false;
      }
      if (hitAddBooking == true) {
        dashBoardApiValidation();
      } else {
          update();
      }
    }
  }

  bool cliJobHit = false;

  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo data binding for update

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo cli data binding without api hit
  cliDataBinding({
    String? pickup,
    String? dropoff,
    String? pickupLatitude,
    String? pickupLongitude,
    String? dropoffLatitude,
    String? dropoffLongitude,
    email,
    name,
    mobile,
    phoneNumber,

  }) async {
    polyLineMarkerInfo.clear();
    viaPoints.clear();
    polylinePoints.clear();
    pickupController.text = pickup.toString().toUpperCase();
    dropOffController.text = dropoff.toString().toUpperCase();

    polylinePoints.add(
      LatLng(double.parse(pickupLatitude!), double.parse(pickupLongitude!)),
    );
    polylinePoints.add(
      LatLng(double.parse(dropoffLatitude!), double.parse(dropoffLongitude!)),
    );
    polyLineMarkerInfo.add(ViaPoint(
      lat: double.parse(pickupLatitude),
      lng: double.parse(pickupLongitude),
      markerType: "PICKUP LOCATION",
      address: '',
    ));
    polyLineMarkerInfo.add(ViaPoint(
      lat: double.parse(dropoffLatitude),
      lng: double.parse(dropoffLongitude),
      markerType: "DROP LOCATION",
      address: '',
    ));

    nameController.text = name.toUpperCase();
    emailController.text = email;
    mobileController.text = mobile;
    telController.text = phoneNumber ?? "";

    Get.back();
    fetchRouteFromOSRM();
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo cli data binding without api hit

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo post dashboard api

  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo Get Mobile Number With Name Dashboard

  // TextEditingController mobileController = TextEditingController();
  // TextEditingController nameController = TextEditingController();

  // GetMobileNumberWithNameModel? getMobileNumberWithNameModel;
  //
  // RxBool getMobileNumberWithNameLoader = false.obs;
  // RxList<Customer> filteredList = <Customer>[].obs;
  //
  // // API FETCH
  // getMobileNumberWithName() async {
  //   getMobileNumberWithNameLoader(true);
  //
  //   var response = await Api().get("enumerations/get");
  //
  //   if (response.statusCode == 200) {
  //     getMobileNumberWithNameModel = GetMobileNumberWithNameModel.fromJson(response.data);
  //
  //     getMobileNumberWithNameLoader(false);
  //     update();
  //   }
  // }
  //
  // // 🔍 SEARCH FILTER (while typing mobile number)
  // void filterMobileResults(String query) {
  //   if (query.isEmpty || getMobileNumberWithNameModel == null) {
  //     filteredList.clear();
  //     return;
  //   }
  //
  //   filteredList.value = getMobileNumberWithNameModel!.customers!.where((item) {
  //         return item.mobile.toString().contains(query);
  //       }).toList();
  // }
  //
  // // ▶ Tap on suggestion → auto-fill
  // void fillFromSuggestion(Customer item) {
  //   mobileController.text = item.mobile.toString();
  //   nameController.text = item.name.toString();
  //   filteredList.clear(); // hide suggestion popup
  //   update();
  // }

  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo Get Mobile Number With Name Dashboard

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo create booking functionality

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final telController = TextEditingController();
  final minController = TextEditingController();
  final minControllerReturn = TextEditingController();
  final slugController = TextEditingController(text: "0.0");
  final slugControllerReturn = TextEditingController(text: "0.0");
  final accountNoController = TextEditingController();

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo create booking functionality

  @override
  void onClose() {
    // suggestionFocusNode.dispose();
    // keyboardFocusNode.dispose();
    _bookingCountTimer?.cancel();
    timer?.cancel();
    pickupFocusNode.dispose();
    dropoffFocusNode.dispose();
    via1FocusNode.dispose();
    via2FocusNode.dispose();
    pickupController.dispose();
    dropOffController.dispose();
    viaLocation1Controller.dispose();
    viaLocation2Controller.dispose();
    referenceNumberController.dispose();
    dateController.dispose();
    phoneKeyboardFocusNode.dispose();
    super.onClose();
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Alert Multi Booking
  RxBool mondayValue = false.obs;
  final FocusNode mondayNode = FocusNode();
  RxBool tuesdayValue = false.obs;
  final FocusNode tuesdayNode = FocusNode();
  RxBool wednesdayValue = false.obs;
  final FocusNode wednesdayNode = FocusNode();
  RxBool thursdayValue = false.obs;
  final FocusNode thursdayNode = FocusNode();
  RxBool fridayValue = false.obs;
  final FocusNode fridayNode = FocusNode();
  RxBool saturdayValue = false.obs;
  final FocusNode saturdayNode = FocusNode();
  RxBool sundayValue = false.obs;
  final FocusNode sundayNode = FocusNode();

  String? account;
  String? departmentType;
  String? cash;
  String? selectDriver;

  RxBool returnTrip = false.obs;
  final FocusNode returnTripNode = FocusNode();

  final weeks = TextEditingController();

  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo create booking

  Future<List<String>> getNamesRequest(String query) async {
    if (query.isEmpty) return [];

    const duration = Duration(milliseconds: 800);

    // 👇 cancel previous debounce timer
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // 👇 Completer to wait for API completion
    final completer = Completer<List<String>>();
    selectedTextFieldsValue.value = "createPickUp";
    _debounce = Timer(duration, () async {
      await getAddresses(fieldsName: "VIA", searchingText: query);

      // ✅ Prepare list after data fetched
      final list = allAddressesData
          .map((m) => "${m.name ?? ''} ${m.postcode ?? ''}")
          .toList();

      completer.complete(list); // mark as finished
    });

    // ✅ Wait until completer completes
    return completer.future;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> get all drivers
  final FocusNode phoneNumberFieldKey = FocusNode();
  List<DriverObject> driversList = [];
  RestricDriverModel? allDriverData;
  DriverObject? selectDriverObject;

  getAllDrivers() async {
    var response = await Api().get("drivers/get",sendCompanyId: true);
    if (response.statusCode == 200) {
      allDriverData = RestricDriverModel.fromJson(response.data);
      update();
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> child seat alert
  List<ChildSeatClass> childSeatAlert = [];

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> controller note alert
  List<NoteClass> controllerAlert = [];

  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo create booking
  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo booking recover

  bool isRecoverLoading = false;

  recoverBooking(dynamic bookingId, {paramUrl}) async {
    isRecoverLoading = true;
    update();
    try {
      var formData = {};

      var response = await Api().post(
        formData,
        paramUrl??"bookings/recover-booking/$bookingId",
        auth: true,
      );
      if (response.statusCode == 200) {
        BotToast.showText(text: "BOOKING RECOVERED SUCCESSFULLY");
      } else if (response.statusCode == 404) {
        BotToast.showText(text: "BOOKING NOT FOUND");
      } else {
        BotToast.showText(text: "FAILED TO RECOVER BOOKING");
      }
    } catch (e) {
      print("Error recovering booking: $e");
      BotToast.showText(text: "SOMETHING WENT WRONG");
    } finally {
      isRecoverLoading = false;
      update();
    }
  }

  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo booking recover
  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo booking recover

  bool bookingRequest = false;

  bookingRequests(dynamic bookingId, {paramUrl}) async {
    bookingRequest = true;
    update();
    try {
      var formData = {};

      var response = await Api().post(
        formData,
        paramUrl??"bookings/no-pickup-booking/$bookingId",
        auth: true,
      );
      if (response.statusCode == 200) {
        BotToast.showText(text: "BOOKING RECOVERED SUCCESSFULLY");
      } else if (response.statusCode == 404) {
        BotToast.showText(text: "BOOKING NOT FOUND");
      } else {
        BotToast.showText(text: "FAILED TO RECOVER BOOKING");
      }
    } catch (e) {
      print("Error recovering booking: $e");
      BotToast.showText(text: "SOMETHING WENT WRONG");
    } finally {
      bookingRequest = false;
      update();
    }
  }

  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo booking recover
  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo delete booking

  deleteBooking(dynamic id) async {
    var response = await Api().delete("bookings/delete/$id");
    if (response.statusCode == 200) {
      BotToast.showText(text: "BOOKING DELETED SUCCESSFULLY!");
      print(json.encode(response.data));
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo break ACCEPT or REJECT
  breakACCEPT(driveID, ONBreak) async {
    var formData = {
      "driver_id": driveID,
      "on_break": ONBreak,
    };

    var response =
        await Api().post(formData, 'drivers/break-request', auth: false);

    if (response.statusCode == 200) {
      Get.back();
    }
  }

  breakReject(driveID, ONBreak) async {
    var formData = {
      "driver_id": driveID,
      "on_break": ONBreak,
    };

    var response =
        await Api().post(formData, 'drivers/break-request', auth: false);

    if (response.statusCode == 200) {
      Get.back();
    }
  }

  DisablePanic(driveID) async {
    var response =
        await Api().get('drivers/panic-disable/$driveID', auth: false);

    if (response.statusCode == 200) {
      Get.back();
    }
  }
}

class DashBoardBindings implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}

/// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo Get Mobile Number With Name Dashboard

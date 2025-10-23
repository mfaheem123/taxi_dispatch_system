import 'dart:async';
import 'dart:convert';

import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/networks/api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:polyline_codec/polyline_codec.dart';

import '../../../Model/dashboard_booking_table.dart';
import '../../../Model/via_point.dart';
import '../../../component/marker_class.dart';
import '../../../tabbarview.dart';
import '../models/all_addresses_model.dart';

RxString shortCutKeyValue = 'shortCutKey'.obs;


class DashboardController extends GetxController {




  ///Todo menu bar functionality
  // Widget? currentPage;

  final Rx<Widget?> currentPage = Rx<Widget?>(null);

  List<SelectedDropdown> selectedMenuItems = [];


  ///refresh function for menu bar
  menuBarRefresh({title, pageName}) {
    print(title);
    print(title);
    // if(selectedMenuItems.length < 3){
    int index =
        selectedMenuItems.indexWhere((item) => item.selectedItem == true);
    if (index != -1) {
      selectedMenuItems[index].selectedItem = false;
    }
    selectedMenuItems.add(
        SelectedDropdown(title: title, selectedItem: true, category: pageName));
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
  // Start with shortcut mode that allows navigation; set to "alert" only when showing a modal

  // Dropdown selections
  String? jourValue; // O/W, R/N, W/R
  String? drvValue; // driver list
  String? payValue; // Cash, Credit Card, ...

  ///bool

  RxBool isHovered = false.obs;
  RxBool isHoveredF8 = false.obs;
  RxBool isHoveredF9 = false.obs;
  RxBool isHoveredVLA = false.obs;
  bool isDropdownOpen = false;

  ///text editing controllers
  final pickupController = TextEditingController();
  final dropOffController = TextEditingController();
  final switchController = ValueNotifier<bool>(false);
  RxBool smsCheckbox = false.obs;

  
  RxBool emailCheckbox = false.obs;
  RxBool hideDashBoard = true.obs;

  /// unique keys
  final GlobalKey bookingKey = GlobalKey();
  final GlobalKey bookingDropKey = GlobalKey();
  final GlobalKey jourKey = GlobalKey();
  final GlobalKey accKey = GlobalKey();
  final GlobalKey payKey = GlobalKey();
  String? vehKey;
  final GlobalKey dRVKey = GlobalKey();
  FocusNode focusNode = FocusNode();

  /// RxInt
  int selectedIndex = 0;
  int dropdownIndex = 0;
  RxInt selectionMenuBtn = 0.obs;


  ///Todo booking form data

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo alert controllers data

  final noOfChildren = TextEditingController();
  final childAge = TextEditingController();
  final partingChargesController = TextEditingController();
  final congestionChargesController = TextEditingController();
  final meetGreetController = TextEditingController();
  final waitingChargesController = TextEditingController();
  final extraDropChargesController = TextEditingController();
  final creditCardChargesController = TextEditingController();
  final companyPriceController = TextEditingController();
  final returnCompanyPriceController = TextEditingController();
  final controllerNoteController = TextEditingController();
  final sendEmailController = TextEditingController();
  final emailToController = TextEditingController();
  final mobileNoController = TextEditingController();
  final subjectController = TextEditingController();
  final typeEmailController = TextEditingController();
  final smsToController = TextEditingController();
  final typeYourMessageController = TextEditingController();

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo alert controllers data

  @override
  void onInit() {
    super.onInit();
    mapController = MapController(); // ✅ Initialize here

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
  final dropOffFieldKey = GlobalKey();
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
  final FocusNode dropOffKeyboardFocusNode = FocusNode();
  final FocusNode via1KeyboardFocusNode = FocusNode();
  final FocusNode via2KeyboardFocusNode = FocusNode();
  final FocusNode searchingAddressViaFocusNode = FocusNode();

  final FocusNode pickupTextFieldFocusNode = FocusNode();
  final FocusNode dropOffTextFieldFocusNode = FocusNode();
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

  void selectSuggestion(String? value) {
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
    }

    inputText.value = value!;
    suggestions.clear();
  }

  Timer? _debounce;

  RxString selectedTextFieldsValue = "".obs;

  // 👇 ye function har baar text change hone par call hoga
  Future<void> onChangeHandler({required String fieldName, required String searchingText}) async {
    const duration = Duration(milliseconds: 800); // 800ms ka delay
    selectedTextFieldsValue.value = fieldName;
    // 👇 Agar pehle se koi timer chal raha ho to usse cancel karo
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // 👇 Naya timer start karo
    _debounce = Timer(duration, () {
      _stopTyping(fieldName: fieldName, searchingText: searchingText);
    });
  }

  void _stopTyping({required String fieldName, required String searchingText}) {
    // 👇 Yahan API call ya search function call karna hai
    getAddresses(fieldsName: fieldName, searchingText: searchingText);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> searching all locations hit

  RxBool getPickupAddressesLoader = true.obs;
  RxBool getDropAddressesLoader = true.obs;
  List<AllAddressesModel> allAddressesData = <AllAddressesModel>[].obs;
  getAddresses({fieldsName, searchingText}) async {
    if (fieldsName == "PICKUP LOCATION") {
      getPickupAddressesLoader(false);
    }else if (fieldsName == "PICKUP LOCATION"){
      getDropAddressesLoader(false);
    }
    var response = await Api().get(
        "services/search?search=${searchingText.toString().toUpperCase()}",
        auth: true);
    if (response.statusCode == 200) {
      if (response.data.isNotEmpty) {
        allAddressesData.clear();
        allAddressesData.addAll(
          (response.data['result'] as List).map((e) => AllAddressesModel.fromJson(e)).toList());
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
        getPickupAddressesLoader(true);
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
      getPickupAddressesLoader(true);
      getDropAddressesLoader(true);
      update();
    }
  }

  AllAddressesModel? selectedModel;
  late final MapController mapController;
  final List<ViaPoint> viaPoints = [];
  final List<LatLng> polylinePoints = [];
  List<ViaPoint> polyLineMarkerInfo = [];
  List<LatLng> polylinePointsCoordinate = [];
  List<Polyline> polylines = [];
  List<CustomMarker> markers = [];

  RxString totalDistance = "0".obs;
  RxString totalTimeDuration = "0".obs;

  /// ✅ Step 2: Fetch real road route from OSRM (OpenStreetMap)
  // Future<void> fetchRouteFromOSRM() async {
  //   // if (polylinePoints.length < 2) return;
  //   markers.clear();
  //   List<LatLng> tempPoints = [];
  //   for (var item in viaPoints) {
  //     tempPoints.add(LatLng(item.lat, item.lng));
  //       markers.add(
  //           CustomMarker(
  //             type: "via",
  //             child: Icon(Icons.location_pin,color: DynamicColors.primaryClr,size: 30,),
  //             point: LatLng(item.lat, item.lng),
  //             width: 30, height: 30,
  //           ),
  //     );
  //   }
  //  if(polyLineMarkerInfo.isNotEmpty) {
  //     for (var item in polyLineMarkerInfo) {
  //       if (item.markerType == "PICKUP LOCATION") {
  //         print(markers);
  //         tempPoints.add(LatLng(item.lat, item.lng));
  //         markers.add(
  //             CustomMarker(
  //               type: "pickup",
  //                 point: LatLng(item.lat, item.lng),
  //                 child: Icon(
  //                   Icons.location_pin,
  //                   color: DynamicColors.greenClr,
  //                   size: 30,
  //                 ),
  //                 width: 30,
  //                 height: 30
  //             ),);
  //         mapController.camera.focusedZoomCenter(Offset.zero, 14);
  //         // CameraFit cameraFit = CameraFit.bounds(bounds: polyLineMarkerInfo.);
  //         // mapController.fitCamera(cameraFit);
  //       }
  //       else if(item.markerType == "DROP LOCATION") {
  //         tempPoints.add(LatLng(item.lat, item.lng));
  //         markers.add(
  //             CustomMarker(
  //                 type: "dropOff",
  //                 point: LatLng(item.lat, item.lng),
  //                 child: Icon(
  //                   Icons.location_pin,
  //                   color: DynamicColors.redClr,
  //                   size: 30,
  //                 ),
  //                 width: 30,
  //                 height: 30
  //             ),
  //         );
  //       }
  //       else if (item.markerType == "Create Booking PICKUP"){
  //         tempPoints.add(LatLng(item.lat, item.lng));
  //         markers.add(
  //           CustomMarker(
  //               type: "Create Booking PICKUP",
  //               point: LatLng(item.lat, item.lng),
  //               child: Icon(
  //                 Icons.location_pin,
  //                 color: DynamicColors.greenClr,
  //                 size: 30,
  //               ),
  //               width: 30,
  //               height: 30
  //           ),
  //         );
  //       }
  //       else if (item.markerType == "Create Booking DROP LOCATION"){
  //         tempPoints.add(LatLng(item.lat, item.lng));
  //         markers.add(
  //           CustomMarker(
  //               type: "Create Booking DROP LOCATION",
  //               point: LatLng(item.lat, item.lng),
  //               child: Icon(
  //                 Icons.location_pin,
  //                 color: DynamicColors.redClr,
  //                 size: 30,
  //               ),
  //               width: 30,
  //               height: 30
  //           ),
  //         );
  //       }
  //     }
  //   }
  //
  //
  //
  //  update();
  //
  //   final coordinates = tempPoints.map((p) => "${p.longitude},${p.latitude}").join(";");
  //
  //   final url = Uri.parse(
  //     'https://router.project-osrm.org/route/v1/driving/$coordinates?overview=full',
  //   );
  //
  //   final res = await Dio().getUri(url);
  //
  //   if (res.statusCode == 200) {
  //     polylinePointsCoordinate.clear();
  //     final data = res.data;
  //     final encodedPolyline = data['routes'][0]['geometry'];
  //     // PolylinePoints polylinePoints = PolylinePoints(apiKey: 'AIzaSyBaXpJ2zz_aelMDtgyfAVP9Xsb9e9MxRIA');
  //     List<PointLatLng> result =
  //     PolylinePoints.decodePolyline(encodedPolyline);
  //     List<LatLng> polylinePointss = result.map((PointLatLng point) => LatLng(point.latitude, point.longitude)).toList();
  //
  //     polylinePointsCoordinate = polylinePointss.map((p) => LatLng(p.latitude.toDouble(), p.longitude.toDouble())).toList();
  //
  //     if (polylinePointsCoordinate.isNotEmpty) {
  //       polylines.add(Polyline(
  //           points: polylinePointsCoordinate, color: DynamicColors.primaryClr, strokeWidth: 2.0));
  //
  //       LatLngBounds bounds = calculateBounds(polylinePointsCoordinate);
  //
  //       // Replacing fitBounds with fitCamera using CameraFit.bounds
  //       CameraFit cameraFit = CameraFit.bounds(bounds: bounds);
  //       mapController.fitCamera(cameraFit);
  //     }
  //     update();
  //   } else {
  //     print("❌ OSRM error: ${res.statusCode}");
  //   }
  // }
  //
  // LatLngBounds calculateBounds(List<LatLng> coordinates) {
  //   double minLat = coordinates[0].latitude;
  //   double maxLat = coordinates[0].latitude;
  //   double minLng = coordinates[0].longitude;
  //   double maxLng = coordinates[0].longitude;
  //
  //   for (LatLng coordinate in coordinates) {
  //     if (coordinate.latitude < minLat) {
  //       minLat = coordinate.latitude;
  //     }
  //     if (coordinate.latitude > maxLat) {
  //       maxLat = coordinate.latitude;
  //     }
  //     if (coordinate.longitude < minLng) {
  //       minLng = coordinate.longitude;
  //     }
  //     if (coordinate.longitude > maxLng) {
  //       maxLng = coordinate.longitude;
  //     }
  //   }
  //
  //   return LatLngBounds(LatLng(minLat, minLng), LatLng(maxLat, maxLng));
  // }

  // helper: bounds calculate karne ke liye
// helper: bounds calculate karne ke liye (using fromPoints)

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

// your updated fetchRouteFromOSRM
  Future<void> fetchRouteFromOSRM() async {
    markers.clear();
    polylines.clear();
    polylinePointsCoordinate.clear();
    List<LatLng> tempPoints = [];

    // add via points as markers
    for (var item in viaPoints) {
      final p = LatLng(item.lat, item.lng);
      tempPoints.add(p);
      markers.add(
        CustomMarker(
          type: "via",
          child: Icon(Icons.location_pin, color: DynamicColors.primaryClr, size: 30),
          point: p,
          width: 30,
          height: 30,
        ),
      );
    }

    // add other marker info (pickup / drop / create booking ...)
    if (polyLineMarkerInfo.isNotEmpty) {
      for (var item in polyLineMarkerInfo) {
        final p = LatLng(item.lat, item.lng);

        if (item.markerType == "PICKUP LOCATION" ||
            item.markerType == "Create Booking PICKUP") {
          tempPoints.add(p);
          markers.add(
            CustomMarker(
              type: "pickup",
              point: p,
              child: Icon(Icons.location_pin, color: DynamicColors.greenClr, size: 30),
              width: 30,
              height: 30,
            ),
          );
        } else if (item.markerType == "DROP LOCATION" ||
            item.markerType == "Create Booking DROP LOCATION") {
          tempPoints.add(p);
          markers.add(
            CustomMarker(
              type: "dropOff",
              point: p,
              child: Icon(Icons.location_pin, color: DynamicColors.redClr, size: 30),
              width: 30,
              height: 30,
            ),
          );
        }
      }
    }
    ///  jab hum ek address enter karte hai tu polyline banane k lye neche wala api hit nahe hogha yaha per ruk jaygha
    if(polyLineMarkerInfo.length == 1){
      return;
    }
    update();

    // --------- MULTI-POINT: request route from OSRM ----------
    final coordinates = tempPoints.map((p) => "${p.longitude },${p.latitude}").join(";");
    final url = Uri.parse('https://router.project-osrm.org/route/v1/driving/$coordinates?overview=full');

    final res = await Dio().getUri(url);

    if (res.statusCode == 200) {
      polylinePointsCoordinate.clear();
      final data = res.data;
      final encodedPolyline = data['routes'][0]['geometry'];

      // meters → miles
      final distanceInMiles = data['routes'][0]['distance'] * 0.000621371;

// seconds → minutes
      final durationInMinutes = data['routes'][0]['duration'] / 60;

      // final formattedDuration = formatDuration(durationInMinutes);

// (Optional) format nicely
      totalDistance.value = distanceInMiles.toStringAsFixed(2); // e.g. "0.94"
      // totalTimeDuration.value = durationInMinutes.toStringAsFixed(1); // e.g. "443.3"
      totalTimeDuration.value = formatDuration(durationInMinutes); // e.g. "443.3"

      List<PointLatLng> result = PolylinePoints.decodePolyline(encodedPolyline);
      List<LatLng> polylinePointss = result
          .map((PointLatLng point) => LatLng(point.latitude, point.longitude))
          .toList();

      polylinePointsCoordinate = polylinePointss
          .map((p) => LatLng(p.latitude.toDouble(), p.longitude.toDouble()))
          .toList();

      if (polylinePointsCoordinate.isNotEmpty) {
        polylines.add(Polyline(
          points: polylinePointsCoordinate,
          color: DynamicColors.primaryClr,
          strokeWidth: 2.0,
        ));

        // build bounds from the route or from markers (choose whichever you prefer)
        final List<LatLng> focusPoints = tempPoints.isNotEmpty ? tempPoints : polylinePointsCoordinate;

        LatLngBounds bounds;
        if (focusPoints.length == 1) {
          bounds = LatLngBounds.fromPoints([focusPoints.first, focusPoints.first]);
        } else {
          bounds = calculateBounds(focusPoints); // your existing helper
        }

        final cameraFit = CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(60));
        mapController.fitCamera(cameraFit);
      }

      update();
    } else {
      print("❌ OSRM error: ${res.statusCode}");
    }
  }

/// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> make function for mints and hours
  String formatDuration(double minutes) {
    final int totalMinutes = minutes.round();
    final int hours = totalMinutes ~/ 60;
    final int remainingMinutes = totalMinutes % 60;

    if (hours > 0 && remainingMinutes > 0) {
      return '$hours hour${hours > 1 ? 's' : ''} $remainingMinutes min${remainingMinutes > 1 ? 's' : ''}';
    } else if (hours > 0) {
      return '$hours hour${hours > 1 ? 's' : ''}';
    } else {
      return '$remainingMinutes min${remainingMinutes > 1 ? 's' : ''}';
    }
  }


// inside your controller
  final suggestionFocusNode = FocusNode();
  final suggestionScrollController = ScrollController();

// inside your controller
  final viaFocusNode = FocusNode();
  final viaSuggestionScrollController = ScrollController();

  List<GlobalKey> suggestionItemKeys = [];

  void updateKeys() {
    suggestionItemKeys = List.generate(allAddressesData.length, (_) => GlobalKey());
  }

  final GlobalKey suggestionListKey = GlobalKey();


// change move functions to scroll after change:
  void moveHighlightDown() {
    if (allAddressesData.isEmpty) return;
    highlightedIndex.value =
        (highlightedIndex.value + 1) % allAddressesData.length;
    highlightedIndex.refresh();
    _scrollToHighlighted(scrollDown: true); // 👈 scroll to bottom when down
  }

  void moveHighlightUp() {
    if (allAddressesData.isEmpty) return;
    highlightedIndex.value =
        (highlightedIndex.value - 1 + allAddressesData.length) %
            allAddressesData.length;
    highlightedIndex.refresh();
    _scrollToHighlighted(scrollDown: false); // 👈 scroll to top when up
  }


  void _scrollToHighlighted({bool scrollDown = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final i = highlightedIndex.value;
      if (i < 0 || i >= suggestionItemKeys.length) return;

      final itemCtx = suggestionItemKeys[i].currentContext;
      final listCtx = suggestionListKey.currentContext;

      if (itemCtx != null && listCtx != null && suggestionScrollController.hasClients) {
        final RenderBox itemBox = itemCtx.findRenderObject() as RenderBox;
        final RenderBox listBox = listCtx.findRenderObject() as RenderBox;

        final Offset itemOffset = itemBox.localToGlobal(Offset.zero, ancestor: listBox);
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



  // void _scrollToHighlighted({bool scrollDown = true}) {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     final i = highlightedIndex.value;
  //     if (i < 0 || i >= suggestionItemKeys.length) return;
  //
  //     final itemCtx = suggestionItemKeys[i].currentContext;
  //     final listCtx = suggestionListKey.currentContext;
  //
  //     if (itemCtx != null && listCtx != null && suggestionScrollController.hasClients) {
  //       final RenderBox itemBox = itemCtx.findRenderObject() as RenderBox;
  //       final RenderBox listBox = listCtx.findRenderObject() as RenderBox;
  //
  //       // item position relative to the ListView viewport
  //       final Offset itemOffset = itemBox.localToGlobal(Offset.zero, ancestor: listBox);
  //       final double itemTopLocal = itemOffset.dy;
  //       final double itemBottomLocal = itemTopLocal + itemBox.size.height;
  //
  //       final double viewportHeight = listBox.size.height;
  //       final double currentOffset = suggestionScrollController.offset;
  //
  //       double targetOffset = currentOffset;
  //
  //       // small margin so item doesn't hug the edge too tightly
  //       const double edgeMargin = 8.0;
  //
  //       // If item bottom is below visible viewport -> scroll down minimally
  //       if (itemBottomLocal > viewportHeight - edgeMargin) {
  //         final double delta = itemBottomLocal - (viewportHeight - edgeMargin);
  //         targetOffset = (currentOffset + delta).clamp(
  //           suggestionScrollController.position.minScrollExtent,
  //           suggestionScrollController.position.maxScrollExtent,
  //         );
  //       }
  //       // If item top is above visible viewport -> scroll up minimally
  //       else if (itemTopLocal < edgeMargin) {
  //         final double delta = itemTopLocal - edgeMargin; // negative
  //         targetOffset = (currentOffset + delta).clamp(
  //           suggestionScrollController.position.minScrollExtent,
  //           suggestionScrollController.position.maxScrollExtent,
  //         );
  //       } else {
  //         // already visible enough -> no scroll
  //         return;
  //       }
  //
  //       // tiny guard to avoid micro animations
  //       if ((targetOffset - currentOffset).abs() < 0.5) return;
  //
  //       suggestionScrollController.animateTo(
  //         targetOffset,
  //         duration: const Duration(milliseconds: 80),
  //         curve: Curves.easeOut,
  //       );
  //     } else {
  //       // fallback if contexts not ready
  //       _fallbackScroll(i, scrollDown);
  //     }
  //   });
  // }
  //
  // void _fallbackScroll(int index, bool scrollDown) {
  //   if (!suggestionScrollController.hasClients) return;
  //
  //   const double itemHeight = 48.0; // adjust if needed
  //   const double topPadding = 15.0;
  //   final currentOffset = suggestionScrollController.offset;
  //   final viewport = suggestionScrollController.position.viewportDimension;
  //   final visibleStart = currentOffset;
  //   final visibleEnd = currentOffset + viewport;
  //
  //   final itemTop = topPadding + index * itemHeight;
  //   final itemBottom = itemTop + itemHeight;
  //
  //   double target = currentOffset;
  //   const double margin = itemHeight * 0.12; // small margin
  //
  //   if (itemBottom > visibleEnd) {
  //     // scroll just enough so item bottom is inside viewport with margin
  //     target = itemBottom - viewport + margin;
  //   } else if (itemTop < visibleStart) {
  //     // scroll just enough so item top is inside viewport with margin
  //     target = itemTop - margin;
  //   } else {
  //     return; // visible
  //   }
  //
  //   target = target.clamp(
  //     suggestionScrollController.position.minScrollExtent,
  //     suggestionScrollController.position.maxScrollExtent,
  //   );
  //
  //   if ((target - currentOffset).abs() < 0.5) return;
  //
  //   suggestionScrollController.animateTo(
  //     target,
  //     duration: const Duration(milliseconds: 80),
  //     curve: Curves.easeOut,
  //   );
  // }


  RxInt suggestionSelectedIndex = 0.obs;

  void tapSelect(int index) {
    if (allAddressesData.isEmpty) return;
    final selected = allAddressesData[index];
    final suggestion = selected.name!;
    final postCode = selected.postcode!;
    if (selectedTextFieldsValue.value == "PICKUP LOCATION") {
      int index = polyLineMarkerInfo.indexWhere((test) => test.markerType == "PICKUP LOCATION");
      if(index != -1){
        polyLineMarkerInfo.remove(polyLineMarkerInfo[index]);
      }
      polylinePoints.add(
        LatLng(selected.lat!,
            selected.lon!),
      );
      polyLineMarkerInfo.add(ViaPoint(
        lat: selected.lat!,
          lng: selected.lon!,
        markerType: "PICKUP LOCATION",
        address: '',
      ));
      pickupController.text = "$suggestion $postCode";
      fetchRouteFromOSRM();
    }
    else if(selectedTextFieldsValue.value == "DROP LOCATION") {
      int index = polyLineMarkerInfo.indexWhere((test) => test.markerType == "DROP LOCATION");
      if(index != -1){
        polyLineMarkerInfo.remove(polyLineMarkerInfo[index]);
      }
      polylinePoints.add(
        LatLng(selected.lat!,
            selected.lon!),
      );
      polyLineMarkerInfo.add(ViaPoint(
        lat: selected.lat!,
        lng: selected.lon!,
        markerType: "DROP LOCATION",
        address: '',
      ));
      dropOffController.text = "$suggestion $postCode";
      fetchRouteFromOSRM();
    }
    else if(selectedTextFieldsValue.value == "Create Booking PICKUP"){
      int index = polyLineMarkerInfo.indexWhere((test) => test.markerType == "Create Booking PICKUP");
      if(index != -1){
        polyLineMarkerInfo.remove(polyLineMarkerInfo[index]);
      }
      polylinePoints.add(
        LatLng(selected.lat!,
            selected.lon!),
      );
      polyLineMarkerInfo.add(ViaPoint(
        lat: selected.lat!,
        lng: selected.lon!,
        markerType: "Create Booking PICKUP",
        address: '',
      ));
      pickupController.text = "$suggestion $postCode";
      fetchRouteFromOSRM();
    }
    else if(selectedTextFieldsValue.value == "Create Booking DROP LOCATION"){
      int index = polyLineMarkerInfo.indexWhere((test) => test.markerType == "Create Booking DROP LOCATION");
      if(index != -1){
        polyLineMarkerInfo.remove(polyLineMarkerInfo[index]);
      }
      polylinePoints.add(
        LatLng(selected.lat!,
            selected.lon!),
      );
      polyLineMarkerInfo.add(ViaPoint(
        lat: selected.lat!,
        lng: selected.lon!,
        markerType: "Create Booking DROP LOCATION",
        address: '',
      ));
      dropOffController.text = "$suggestion $postCode";
      fetchRouteFromOSRM();
    }
    allAddressesData.clear();
    highlightedIndex.value = 0;
  update();
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo create booking functionality

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final telController = TextEditingController();
  final minController = TextEditingController();
  final slugController = TextEditingController();
  final accountNoController = TextEditingController();

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo create booking functionality

  @override
  void onClose() {
    // suggestionFocusNode.dispose();
    // keyboardFocusNode.dispose();

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

  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo create booking
}

class DashBoardBindings implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}

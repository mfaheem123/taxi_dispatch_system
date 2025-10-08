import 'dart:async';
import 'dart:convert';

import 'package:dashboard_new1/component/networks/api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../Model/dashboard_booking_table.dart';
import '../../../tabbarview.dart';
import '../models/all_addresses_model.dart';

RxString shortCutKeyValue = 'shortCutKey'.obs;
class DashboardController extends GetxController {

  ///Todo menu bar functionality

  List<SelectedDropdown> selectedMenuItems = [];

  ///refresh function for menu bar
  menuBarRefresh({title,pageName}){
    // if(selectedMenuItems.length < 3){
      int index = selectedMenuItems.indexWhere((item) => item.selectedItem == true);
      if (index != -1) {
        selectedMenuItems[index].selectedItem = false;
      }
      selectedMenuItems.add(SelectedDropdown(
          title: title,
          selectedItem: true,
          category: pageName
      ));
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
  String? jourValue;   // O/W, R/N, W/R
  String? drvValue;    // driver list
  String? payValue;    // Cash, Credit Card, ...

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
  int selectedIndex= 0;
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

  var selectedBookingTab  = 'TODAY BOOKINGS'.obs;

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

  final FocusNode pickupTextFieldFocusNode = FocusNode();
  final FocusNode dropOffTextFieldFocusNode = FocusNode();
  final FocusNode via1TextFieldFocusNode = FocusNode();
  final FocusNode via2TextFieldFocusNode = FocusNode();

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
      suggestions = allAddressesData.where((loc) => loc.name!.toUpperCase().contains(value.toLowerCase())).toList();
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
  onChangeHandler({required String fieldName, required String searchingText}) {
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

  // final allLocations = [
  //   'Karachi',
  //   'Lahore',
  //   'Islamabad',
  //   'Peshawar',
  //   'Quetta',
  //   'Multan',
  //   'Rawalpindi',
  //   'Faisalabad',
  // ];

  RxBool getPickupAddressesLoader = true.obs;
  RxBool getDropAddressesLoader = true.obs;
  List<AllAddressesModel> allAddressesData = <AllAddressesModel>[].obs;
  getAddresses({fieldsName,searchingText}) async{
    if(fieldsName =="PICKUP LOCATION"){
      getPickupAddressesLoader(false);
    }else{
      getDropAddressesLoader(false);
    }
    var response = await Api().get("addresses/search?search=${searchingText.toString().toUpperCase()}",auth: true);
    if(response.statusCode == 200){
      if(response.data.isNotEmpty){
        allAddressesData.clear();
        allAddressesData.addAll(
          (response.data as List)
              .map((e) => AllAddressesModel.fromJson(e))
              .toList(),
        );

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
      }else{
        openStreetMapApi(searchingText: searchingText.toString().toUpperCase());
      }
    }
  }

  openStreetMapApi({searchingText}) async{

    var dio = Dio();
    var response = await dio.request(
      'https://api.postcodes.io/postcodes/nw67bt',
      options: Options(
        method: 'GET',
      ),
    );
 
    if (response.statusCode == 200) {
      allAddressesData.clear();
      pickLocationAddress(response.data['result']['latitude'], response.data['result']['longitude']);
    }
  }

  pickLocationAddress(lat,lng) async{
    var dio = Dio();
    var response = await dio.request(
      'https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$lng&format=json&addressdetails=1',
      options: Options(
        method: 'GET',
      ),
    );
    if(response.statusCode == 200){
      final addressObject = [{
        "name": response.data['display_name'], // e.g. Brondesbury Park, Brent
        "postcode": response.data['address']['postcode'], // e.g. Brondesbury Park, Brent
        "area": response.data['address']['postcode'],                                      // NW6
        "district": response.data['address']['postcode'],                           // Brent
        "sector": response.data['address']['postcode'],                                     // London
        "unit": response.data['address']['postcode'],                                     // NW6 7BP
        "type": "address",
        "lat": double.parse(response.data['lat']),                                    // 51.542059
        "lon": double.parse(response.data['lon']),                                  // -0.212545
      }];

      allAddressesData.addAll(
        (addressObject as List)
            .map((e) => AllAddressesModel.fromJson(e))
            .toList(),
      );
      getPickupAddressesLoader(true);
      getDropAddressesLoader(true);
      update();
    }
  }





// inside your controller
  final suggestionFocusNode = FocusNode();
  final suggestionScrollController = ScrollController();


// change move functions to scroll after change:
  void moveHighlightDown() {
    if (allAddressesData.isEmpty) return;
    highlightedIndex.value =
        (highlightedIndex.value + 1) % allAddressesData.length;
    _scrollToHighlighted();
  }

  void moveHighlightUp() {
    if (allAddressesData.isEmpty) return;
    highlightedIndex.value =
        (highlightedIndex.value - 1 + allAddressesData.length) %
            allAddressesData.length;
    _scrollToHighlighted();
  }

  void _scrollToHighlighted() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!suggestionScrollController.hasClients) return;
      final index = highlightedIndex.value;
      const itemHeight = 48.0; // adjust if your item height differs
      final offset = (index * itemHeight).clamp(
        suggestionScrollController.position.minScrollExtent,
        suggestionScrollController.position.maxScrollExtent,
      );
      suggestionScrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeInOut,
      );
    });
  }

// Keep tap selection (Enter intentionally NOT handled)
  void tapSelect(int index) {
    if (allAddressesData.isEmpty) return;
    final selected = allAddressesData[index];
    final suggestion = selected.name!;
    final postCode = selected.postcode!;
    if (selectedTextFieldsValue.value == "PICKUP LOCATION") {
      pickupController.text = "$suggestion $postCode";
    } else {
      dropOffController.text = "$suggestion $postCode";
    }
    allAddressesData.clear();
    highlightedIndex.value = 0;
  }




  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo create booking functionality

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

}

class DashBoardBindings implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}


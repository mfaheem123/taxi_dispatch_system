import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../Model/dashboard_booking_table.dart';
import '../../../tabbarview.dart';

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
  var selectedBookingTab  = 'TODAY BOOKINGS'.obs;

  RxString selectedTab = 'MAPS'.obs;
  RxString driverSelectionTab = 'activeDriver'.obs;
  var miles = '00.0'.obs;
  var duration = '00.0'.obs;
  var suggestions = <String>[].obs;
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

  final PickupController = TextEditingController();
  final DropoffController = TextEditingController();
  final viaLocation1Controller = TextEditingController();
  final viaLocation2Controller = TextEditingController();

  final allLocations = [
    'Karachi',
    'Lahore',
    'Islamabad',
    'Peshawar',
    'Quetta',
    'Multan',
    'Rawalpindi',
    'Faisalabad',
  ];


  void onInputChanged(String value) {
    inputText.value = value;
    if (value.isEmpty) {
      suggestions.clear();
    } else {
      suggestions.value = allLocations
          .where((loc) => loc.toLowerCase().contains(value.toLowerCase()))
          .toList();
      highlightedIndex.value = 0;
    }
  }

  void selectSuggestion(String value) {
    if (activeFieldKey.value == pickupFieldKey) {
      PickupController.text = value;
      PickupController.selection =
          TextSelection.collapsed(offset: value.length);
    } else if (activeFieldKey.value == dropOffFieldKey) {
      DropoffController.text = value;
      DropoffController.selection =
          TextSelection.collapsed(offset: value.length);
    } else if (activeFieldKey.value == via1FieldKey) {
      viaLocation1Controller.text = value;
      viaLocation1Controller.selection =
          TextSelection.collapsed(offset: value.length);
    } else if (activeFieldKey.value == via2FieldKey) {
      viaLocation2Controller.text = value;
      viaLocation2Controller.selection =
          TextSelection.collapsed(offset: value.length);
    }

    inputText.value = value;
    suggestions.clear();
  }


  @override
  void onInit() {
    super.onInit();

    // Add listeners to text controllers to detect focus and assign activeFieldKey
    PickupController.addListener(() {
      if (PickupController.selection.baseOffset != -1) {
        activeFieldKey.value = pickupFieldKey;
        inputText.value = PickupController.text;
        onInputChanged(PickupController.text);
      }
    });

    DropoffController.addListener(() {
      if (DropoffController.selection.baseOffset != -1) {
        activeFieldKey.value = dropOffFieldKey;
        inputText.value = DropoffController.text;
        onInputChanged(DropoffController.text);
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

    PickupController.dispose();
    DropoffController.dispose();
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


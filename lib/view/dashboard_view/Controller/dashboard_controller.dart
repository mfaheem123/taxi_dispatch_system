import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../Model/dashboard_booking_table.dart';


class DashboardController extends GetxController {

  ///Todo booking form data
  /// String
  String selectedJourneyType = 'Journey Type';
  String selectedVehicleType = 'Saloon';
  String selectedAccountType = 'Account';
  String selectedPaymentMethod = 'Cash';
  String selectedDriver = 'Select Driver';
  RxString shortCutKeyValue = 'alert'.obs;

  ///bool

  RxBool isHovered = false.obs;
  RxBool isHoveredF8 = false.obs;
  RxBool isHoveredF9 = false.obs;
  RxBool isHoveredVLA = false.obs;

  ///text editing controllers
  final pickupController = TextEditingController();
  final dropOffController = TextEditingController();
  final switchController = ValueNotifier<bool>(false);
  RxBool smsCheckbox = false.obs;
  RxBool emailCheckbox = false.obs;
  RxBool hideDashBoard = true.obs;


  ///Todo booking form data

  var bookings = <Booking>[].obs;
  var selectedBookingTab  = 'TODAY BOOKINGS'.obs;

  RxString selectedTab = 'MAPS'.obs;
  RxString driverSelectionTab = 'activeDriver'.obs;
  var miles = '00.0'.obs;
  var duration = '00.0'.obs;
  var suggestions = <String>[].obs;
  var inputText = ''.obs;
  final highlightedIndex = 0.obs;
  final pickupFieldKey = GlobalKey();
  final dropoffFieldKey = GlobalKey();
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
  final FocusNode dropoffKeyboardFocusNode = FocusNode();
  final FocusNode via1KeyboardFocusNode = FocusNode();
  final FocusNode via2KeyboardFocusNode = FocusNode();

  final FocusNode pickupTextFieldFocusNode = FocusNode();
  final FocusNode dropoffTextFieldFocusNode = FocusNode();
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
  final ViaLocation1Controller = TextEditingController();
  final ViaLocation2Controller = TextEditingController();

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
    } else if (activeFieldKey.value == dropoffFieldKey) {
      DropoffController.text = value;
      DropoffController.selection =
          TextSelection.collapsed(offset: value.length);
    } else if (activeFieldKey.value == via1FieldKey) {
      ViaLocation1Controller.text = value;
      ViaLocation1Controller.selection =
          TextSelection.collapsed(offset: value.length);
    } else if (activeFieldKey.value == via2FieldKey) {
      ViaLocation2Controller.text = value;
      ViaLocation2Controller.selection =
          TextSelection.collapsed(offset: value.length);
    }

    inputText.value = value;
    suggestions.clear();
  }

  //Date
  Future<void> pickDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('EEE d-M-yyyy').format(pickedDate);
      selectedDate.value = formattedDate;
      dateController.text = formattedDate;
    }
  }

  //Time
  Future<void> pickTime(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final now = DateTime.now();
      final formattedTime = DateFormat('HH:mm').format(
        DateTime(
            now.year, now.month, now.day, pickedTime.hour, pickedTime.minute),
      );
      selectedTime.value = formattedTime;
      timeController.text = formattedTime;
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadDummyBookings();

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
        activeFieldKey.value = dropoffFieldKey;
        inputText.value = DropoffController.text;
        onInputChanged(DropoffController.text);
      }
    });

    ViaLocation1Controller.addListener(() {
      if (ViaLocation1Controller.selection.baseOffset != -1) {
        activeFieldKey.value = via1FieldKey;
        inputText.value = ViaLocation1Controller.text;
        onInputChanged(ViaLocation1Controller.text);
      }
    });

    ViaLocation2Controller.addListener(() {
      if (ViaLocation2Controller.selection.baseOffset != -1) {
        activeFieldKey.value = via2FieldKey;
        inputText.value = ViaLocation2Controller.text;
        onInputChanged(ViaLocation2Controller.text);
      }
    });
  }


  void loadDummyBookings() {
    bookings.value = List.generate(12, (index) {
      return Booking(
        sno: index + 1,
        ref: 'NTG54851${800 + index}',
        date: 'Fri - 7 - 2025',
        time: '18:${30 + index}',
        customerName: 'Nadeem',
        pickupPoint: 'NW6 7BP, London',
        dropoffPoint: '6 Warrior Garden, London',
        phone: '07590455507',
        vehicle: 'Saloon',
        status: 'Waiting',
        driver: '!',
        account: 'Cash',
        fares: 146.35,
      );
  });
  }
  // void editBooking(int index) {
  //   var booking = bookings[index];
  // }

  void editBooking(int index) {
    print('Editing booking at index $index: ${bookings[index].ref}');
  }


  void deleteBooking(int index) {
    bookings.removeAt(index);
  }

  void selectTab(String tab) {
    selectedBookingTab.value = tab;
  }

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
    ViaLocation1Controller.dispose();
    ViaLocation2Controller.dispose();
    referenceNumberController.dispose();
    dateController.dispose();

    super.onClose();
  }

// @override
  // void onClose() {
  //   suggestionFocusNode.dispose();
  //   keyboardFocusNode.dispose();
  //   PickupController.dispose();
  //   DropoffController.dispose();
  //   ViaLocation1Controller.dispose();
  //   ViaLocation2Controller.dispose();
  //   referenceNumberController.dispose();
  //   dateController.dispose();
  //   super.onClose();
  // }
}

class DashBoardBindings implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}


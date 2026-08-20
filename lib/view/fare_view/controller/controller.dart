import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/networks/api.dart';
import 'package:dashboard_new1/view/fare_view/model/GetAllFareMeterRateModel.dart';
import 'package:dashboard_new1/view/fare_view/model/allPlotFareModel.dart';
import 'package:dashboard_new1/view/fare_view/model/fixedFareVehicleLocationTypeModel.dart';
import 'package:dashboard_new1/view/fare_view/fare_configuration_day/fare_configuration_model.dart';
import 'package:dashboard_new1/view/fare_view/model/getAirPortChargesModel.dart'
    hide LocationType;
import 'package:dashboard_new1/view/fare_view/model/getAllFixedfareModel.dart';
import 'package:dashboard_new1/view/fare_view/model/getFareIncrementModel.dart';
import 'package:dashboard_new1/view/fare_view/model/getSurchargesModel.dart';
import 'package:dashboard_new1/view/fare_view/model/getVehicleTypeAccountModel.dart';
import 'package:dashboard_new1/view/fare_view/model/plotVehicleModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_navigation/src/root/parse_route.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../../dashboard_view/models/all_addresses_model.dart';
import '../../vehicles_view/model/vehicle_type_model.dart';
import '../airport_charges/airport_model.dart';
import '../fare_by_vehicle/model/fare_by_vehicle_model.dart';
import '../fare_charges/fare_charges.dart';

class FareController extends GetxController {
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo Plot Fare functionality

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo Plot Fare functionality

  final vehicleTypeController = TextEditingController();
  final fareController = TextEditingController();
  final fareDescriptionController = TextEditingController();
  final fareDescription2ndController = TextEditingController();
  final ploteFareDescriptionController = TextEditingController();
  final ploteFareDescription2ndController = TextEditingController();

  VehicleTypee? plotVehicleTypevalue;
  Zonee? Zoneevalue;
  Zonee? Zonee1value;
  PlotVehicleTypeModel? plotVehicleTypeModel;
  RxBool getPlotVehicleTypeLoader = false.obs;
  getPlotVehicleType() async {
    getPlotVehicleTypeLoader(true);
    var response = await Api().get("combined/zone-vehicle-types", sendCompanyId: true,);
    if (response.statusCode == 200) {
      plotVehicleTypeModel = PlotVehicleTypeModel.fromJson(response.data);
      getPlotVehicleTypeLoader(false);
      update();
    }
  }

  List<int> selectedPickupIds = [];
  List<int> selectedDropoffIds = [];

// Jab '+' button dabayein tw list mein add karein
  void addPickupPlot(int id) {
    if (!selectedPickupIds.contains(id)) {
      selectedPickupIds.add(id);
      update();
    }
  }

  void addDropoffPlot(int id) {
    if (!selectedDropoffIds.contains(id)) {
      selectedDropoffIds.add(id);
      update();
    }
  }

  postPlotFare() async {
    var formData = {
      "vehicle_type_id": plotVehicleTypevalue!.id,
      "pickup_plot_id": selectedPickupIds, // Ab ye array jayega [27, 28, 30]
      "dropoff_plot_id": selectedDropoffIds, // Ab ye array jayega [35, 34]
      "fares": fareController.text,
    };
    print(formData);
    var response = await Api().post(
        formData,
        isUpdatePlot.value
            ? "plotfares/update/${plotUpdateId.value}"
            : "plotfares/add",
    sendCompanyId: true,
    );
    if (response.statusCode == 200) {

      BotToast.showText(
          text: isUpdatePlot.value
              ? "PLOT FARE UPDATED SUCCESSFULLY"
              : "PLOT FARE ADDED SUCCESSFULLY");
      clearFormData();
      print(response.data);
      getAllPlotFare();
      isUpdatePlot(false);
    }
  }

// Controller mein clearFormData ko is tarah update lazmi rakhein:
  clearFormData() {
    fareController.clear();
    addressController.clear();
    addressController1.clear();
    fromAddressList.clear();
    toAddressList.clear();
    fareDescriptionController.clear();
    fareDescription2ndController.clear();
    ploteFareDescriptionController.clear();
    ploteFareDescription2ndController.clear();
    selectedPickupIds.clear(); // Backend array reset
    selectedDropoffIds.clear();
    vehicleTypesFixedvalue = null;
    fromLocationTypeValue = null;
    toLocationTypeValue = null;
    plotVehicleTypevalue = null;
    Zoneevalue = null;
    Zonee1value = null;
    isUpdatePlot(false);
    update();
  }

  AllPlotFareModel? allPlotFareModel;
  RxBool getAllPlotFareLoader = false.obs;
  getAllPlotFare() async {
    getAllPlotFareLoader(true);
    var response = await Api().get("plotfares/get", sendCompanyId: true, );
    if (response.statusCode == 200) {
      allPlotFareModel = AllPlotFareModel.fromJson(response.data);
      getAllPlotFareLoader(false);
      update();
    }
  }

  plotfareDelete(int? id) async {
    var response = await Api().delete("plotfares/delete/$id");
    if (response.statusCode == 200) {
      getAllPlotFare();
      BotToast.showText(text: "PLOT FARE DELETED SUCCESSFULLY");
      print("PloteFare deleted successfully!");
    }
  }

  RxBool isUpdatePlot = false.obs;
  RxInt plotUpdateId = 0.obs;

  bindPlotFare(PlotFare fare) {
    fareController.text = fare.fares?.toString() ?? "";
    isUpdatePlot(true);
    plotUpdateId(fare.id!);

    selectedPickupIds.clear();
    selectedDropoffIds.clear();

    // Description fields fill karein
    ploteFareDescriptionController.text = (fare.pickupPlot?.name ?? "").toUpperCase();
    ploteFareDescription2ndController.text = (fare.dropoffPlot?.name ?? "").toUpperCase();

    if (fare.pickupPlot != null) {
      selectedPickupIds.add(fare.pickupPlot!.id!);
    }
    if (fare.dropoffPlot != null) {
      selectedDropoffIds.add(fare.dropoffPlot!.id!);
    }

    // Dropdown value select karne ke liye
    if (plotVehicleTypeModel?.vehicleTypes != null) {
      plotVehicleTypevalue = plotVehicleTypeModel!.vehicleTypes!
          .firstWhereOrNull((v) => v.id == fare.vehicleTypeId);
    }

    update();
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo Plot Fare functionality

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo Plot Fare functionality

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo Plot Fare functionality

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo Plot Fare functionality

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo Plot Fare functionality

  /// TextEditingControllers
  // final fareValueVehicleController = TextEditingController();

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo Plot Fare functionality

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo FARE INCREMENT functionality

  /// TextEditingControllers

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo FARE INCREMENT functionality

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo SURCHARGES functionality

  /// TextEditingControllers
  final surChargesFareController = TextEditingController();
  final parkingFareController = TextEditingController();
  final postCodeFareController = TextEditingController();
  final extraDropOffFareController = TextEditingController();
  final congestionFareController = TextEditingController();

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo SURCHARGES functionality

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo SURCHARGES functionality

  /// TextEditingControllers
  final activeWaitingController = TextEditingController();

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo SURCHARGES functionality
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo Fixed Fare functionality

  GetAllFixedFareModel? getAllFixedFareModels;
  RxBool fixedFareLoader = false.obs;

  ///--------------------- Pagination
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  final int limit = 20;

  /// >>>>>>>>>>>>>>>>>>>>> Search Work
  RxList<FixedFare> fixedFareAll = <FixedFare>[].obs;
  RxList<FixedFare> fixedFareFiltered = <FixedFare>[].obs;
  RxString searchVehicle = ''.obs;
  RxString searchFromLocation = ''.obs;
  RxString searchToLocation = ''.obs;
  RxString searchFares = ''.obs;

  ///--------------------- Pagination
  var currentPageFixedFare = 1.obs;
  var totalPagesFixedFare = 1.obs;
  final int limitFixedFare = 20;

  getAllFixedFare() async {
    fixedFareLoader(true);
    var response = await Api().get("fixedfares/get", queryParameters: {
      "vehicle_type_name": searchVehicle.value.toLowerCase(),
      "area1": searchFromLocation.value.toLowerCase(),
      "area2": searchToLocation.value.toLowerCase(),
      "fares": searchFares.value.toLowerCase(),
    },
    sendCompanyId: true,
    );
    if (response.statusCode == 200) {
      getAllFixedFareModels = GetAllFixedFareModel.fromJson(response.data);
      totalPagesFixedFare.value = getAllFixedFareModels?.totalPages ?? 1;
      fixedFareAll.value = getAllFixedFareModels?.fixedFares ?? [];
      fixedFareFiltered.value = fixedFareAll;
      fixedFareLoader(false);
      update();
    }
  }

  // -----------Search changes function
  void onSearchFixedFares() {
    currentPageFixedFare.value = 1;
    getAllFixedFare();
  }

  /// ------- pagination function
  void onPageFixedFare(int page) {
    currentPageFixedFare.value = page;
    getAllFixedFare();
  }

  /// ----------------------------------------- Delete fixed fare
  deleteFixedFareSetting(int? id) async {
    var response = await Api().delete("fixedfares/delete/${id}");
    if (response.statusCode == 200) {
      getAllFixedFare();
      BotToast.showText(text: " FIXED FARE SETTING DELETED SUCCESSFULLY ");
      update();
    }
  }

  VehicleTypeFixed? vehicleTypesFixedvalue;
  // LocationType?locationTypevalue;
  LocationType? fromLocationTypeValue;
  LocationType? toLocationTypeValue;

  FixedFareVehicleLocationTypeModel? fixedFareVehicleLocationTypeModel;
  RxBool getFixedFareVehicleLocationTypeLoader = false.obs;
  getFixedFareVehicleLocationType() async {
    getFixedFareVehicleLocationTypeLoader(true);
    var response = await Api().get("combined/vehicle-location-types", sendCompanyId: true);
    if (response.statusCode == 200) {
      fixedFareVehicleLocationTypeModel =
          FixedFareVehicleLocationTypeModel.fromJson(response.data);
      getFixedFareVehicleLocationTypeLoader(false);
      update();
    }
  }

// Controller ke andar
  var fromAddressList = <String>[].obs;
  var toAddressList = <String>[].obs;

// Add function for From Location
  void addFromAddress() {
    if (addressController.text.isNotEmpty) {
      fromAddressList.add(addressController.text);
      // UI field me dikhane ke liye update karein
      fareDescriptionController.text = fromAddressList.join("\n");
      addressController.clear();
    }
  }

// Add function for To Location
  void addToAddress() {
    if (addressController1.text.isNotEmpty) {
      toAddressList.add(addressController1.text);
      // UI field me dikhane ke liye update karein
      fareDescription2ndController.text = toAddressList.join("\n");
      addressController1.clear();
    }
  }

  RxBool postFixedFareLoader = false.obs;
  GetAllFixedFareModel? getAllFixedFareModel;
  RxBool getAllFixedFareLoader = false.obs;

  postFixedFare() async {
    postFixedFareLoader(true); // loader start

    dynamic finalArea1 = fromAddressList.isNotEmpty
        ? fromAddressList
        : addressController.text;

    dynamic finalArea2 = toAddressList.isNotEmpty
        ? toAddressList
        : addressController1.text;

    var formData = {
      "vehicle_type_id": vehicleTypesFixedvalue!.id,
      "area1":finalArea1,
      "area2":finalArea2,
      "fares": fareController.text,
      "from_location_id": fromLocationTypeValue!.id,
      "to_location_id": toLocationTypeValue!.id,
    };

    var response = await Api().post(
        formData,
        isUpdateFixedFare.value
            ? "fixedfares/edit/${fixedFareUpdateId.value}"
            : 'fixedfares/add',
        auth: true,
    sendCompanyId: true,
    );
    if (response.statusCode == 200) {
      BotToast.showText(
          text: isUpdateFixedFare.value
              ? "FIXED FARE IS UPDATED SUCCESSFULLY!"
              : "FIXED FARE IS ADDED SUCCESSFULLY!");
      clearForm();
      getAllFixedFare();
      print("POST success: ${response.data}");
    }
  }

  void clearForm() {
    addressController.clear();
    addressController1.clear();
    fareController.clear();
    fareDescriptionController.clear();
    fareDescription2ndController.clear();
    fromAddressList.clear();
    toAddressList.clear();
    vehicleTypesFixedvalue = null;
    fromLocationTypeValue = null;
    toLocationTypeValue = null;
    isUpdateFixedFare.value = false;
    fixedFareUpdateId.value = 0;
    update();
  }

  RxBool isUpdateFixedFare = false.obs;
  RxInt fixedFareUpdateId = 0.obs;
  void fixedFareBinding(FixedFare editModel) {
    addressController.text = (editModel.area1 ?? "").toUpperCase();
    addressController1.text = (editModel.area2 ?? "").toUpperCase();
    fareController.text = editModel.fares?.toString() ?? "";

    if (fixedFareVehicleLocationTypeModel != null) {
      vehicleTypesFixedvalue =
          fixedFareVehicleLocationTypeModel!.vehicleTypesFixed?.firstWhere(
        (item) => item.id == editModel.vehicleTypeId,
        orElse: () => vehicleTypesFixedvalue!,
      );

      fromLocationTypeValue =
          fixedFareVehicleLocationTypeModel!.locationTypes?.firstWhere(
        (item) => item.id == editModel.fromLocationId,
        orElse: () => fromLocationTypeValue!,
      );

      toLocationTypeValue =
          fixedFareVehicleLocationTypeModel!.locationTypes?.firstWhere(
        (item) => item.id == editModel.toLocationId,
        orElse: () => toLocationTypeValue!,
      );
    }
    isUpdateFixedFare(true);
    fixedFareUpdateId(editModel.id);
    update();
  }

  /// todo testing location ???????????????????????????????????????????????????????????????????????
  final FocusNode searchingAddressViaFocusNode = FocusNode();
  final FocusNode searchingAddress1ViaFocusNode = FocusNode();
  final highlightedIndex = 0.obs;
  final highlightedIndex1 = 0.obs;
  List<AllAddressesModel> suggestions = <AllAddressesModel>[].obs;
  List<AllAddressesModel> suggestions1 = <AllAddressesModel>[].obs;
  final viaLocation2Controller = TextEditingController();
  var inputText = ''.obs;
  final viaFocusNode = FocusNode();
  final viaFocusNode1 = FocusNode();
  final FocusNode viaFieldFocusNode = FocusNode();
  final FocusNode viaFieldFocusNode1 = FocusNode();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController addressController1 = TextEditingController();
  final activeFieldKey = Rx<GlobalKey?>(null);
  final GlobalKey fromFieldKey = GlobalKey();
  final GlobalKey toFieldKey = GlobalKey();
  final stackKey = GlobalKey();
  final GlobalKey suggestionListKey = GlobalKey();
  final GlobalKey suggestionListKeyVia = GlobalKey();
  final suggestionScrollController = ScrollController();
  AllAddressesModel? selectedModel;
  RxInt suggestionSelectedIndex = 0.obs;
  RxString activeField = "from".obs;

  void selectSuggestion(String? value) {
    viaLocation2Controller.text = value!;
    viaLocation2Controller.selection =
        TextSelection.collapsed(offset: value.length);
    inputText.value = value;
    suggestions.clear();
  }

  Timer? _debounce;

  // 👇 ye function har baar text change hone par call hoga
  Future<void> onChangeHandler(
      {required String fieldName, required String searchingText}) async {
    const duration = Duration(milliseconds: 800); // 800ms ka delay
    // selectedTextFieldsValue.value = fieldName;
    // 👇 Agar pehle se koi timer chal raha ho to usse cancel karo
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // 👇 Naya timer start karo
    _debounce = Timer(duration, () {
      _stopTyping(fieldName: fieldName, searchingText: searchingText);
    });
  }

  Future<void> onChangeHandler1(
      {required String fieldName, required String searchingText}) async {
    const duration = Duration(milliseconds: 800); // 800ms ka delay
    // selectedTextFieldsValue.value = fieldName;
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

  RxList allFromAddresses = [].obs;
  RxList allToAddresses = [].obs;

  List<AllAddressesModel> allAddressesData = <AllAddressesModel>[].obs;
  getAddresses({fieldsName, searchingText}) async {
    var response = await Api().get(
        "services/search?search=${searchingText.toString().toUpperCase()}",
        auth: true);
    if (response.statusCode == 200) {
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
    }
  }

  List<GlobalKey> suggestionItemKeys = [];

  void updateKeys() {
    suggestionItemKeys =
        List.generate(allAddressesData.length, (_) => GlobalKey());
    update();
  }

  // change move functions to scroll after change:
  void moveHighlightDown({bool viaConditionValue = false}) {
    if (allAddressesData.isEmpty) return;
    highlightedIndex.value =
        (highlightedIndex.value + 1) % allAddressesData.length;
    highlightedIndex.refresh();
    _scrollToHighlighted(scrollDown: true); // 👈 scroll to bottom when down
  }

  void moveHighlightUp({bool viaConditionValue = false}) {
    if (allAddressesData.isEmpty) return;
    highlightedIndex.value =
        (highlightedIndex.value - 1 + allAddressesData.length) %
            allAddressesData.length;
    highlightedIndex.refresh();
    _scrollToHighlighted(
        scrollDown: false,
        viaCondition: viaConditionValue); // 👈 scroll to top when up
  }

  /// Commits the currently highlighted suggestion into whichever field
  /// (from/to) is active, then closes the dropdown.
  void selectHighlightedAddress() {
    if (allAddressesData.isEmpty) return;
    final i = highlightedIndex.value;
    if (i < 0 || i >= allAddressesData.length) return;
    final item = allAddressesData[i];
    selectedModel = item;
    final text = "${item.name} ${item.postcode}".toUpperCase();
    if (activeField.value == "from") {
      addressController.text = text;
    } else {
      addressController1.text = text;
    }
    allAddressesData.clear();
    update();
  }

  void _scrollToHighlighted(
      {bool scrollDown = true, bool viaCondition = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final i = highlightedIndex.value;
      if (i < 0 || i >= suggestionItemKeys.length) return;

      final itemCtx = suggestionItemKeys[i].currentContext;

      final listCtx = suggestionListKey.currentContext;

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

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  ///  todo testing location ???????????????????????????????????????????????????????????????????????

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo Fixed Fare functionality
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo FARE CONFIGURATION functionality

  String? fromDayValue;
  String? toDayValue;
  String? startDate =
      "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
  String? endDate =
      "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
  String? fareConfiguration = "NORMAL";

  /// TextEditingControllers
  final fromDayController = TextEditingController(text: "09:08 ");
  final toDayController = TextEditingController(text: "09:08 ");
  final startingFareController = TextEditingController();
  final startingMilesController = TextEditingController();
  final perMileFareController = TextEditingController();
  final titleController = TextEditingController();

  List<String> weekDayList = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
  ];

  Account? accountValue;
  VehicleTypeConfiguration? vehicleValue;
  FareGetVehicleTypeAccount? fareGetVehicleTypeAccount;
  RxBool getFareGetVehicleTypeAccountLoader = false.obs;
  getFareGetVehicleTypeAccount() async {
    getFareGetVehicleTypeAccountLoader(true);
    var response = await Api().get("combined/vehicle-type-accounts", sendCompanyId: true);
    if (response.statusCode == 200) {
      fareGetVehicleTypeAccount =
          FareGetVehicleTypeAccount.fromJson(response.data);
      await getAllFareConfiguration();
      getFareGetVehicleTypeAccountLoader(false);
      update();
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> create fare setting

  createFareSetting() async {
    var formData = {
      "vehicle_type_id": vehicleValue!.id,
      // "account_id": accountValue!.id,
      if (accountValue != null) "account_id": accountValue!.id,
      "from_day": fromDayValue,
      "to_day": toDayValue,
      "from_time": fromDayController.text,
      "to_time": toDayController.text,
      "minimum_fares": startingFareController.text,
      "minimum_miles": startingMilesController.text,
      "per_mile_fares": perMileFareController.text,
      if (titleController.text.isNotEmpty && fareConfiguration != "NORMAL")
        "title": titleController.text,
      if (fareConfiguration != "NORMAL") "from_date": startDate,
      if (fareConfiguration != "NORMAL") "to_date": endDate,
    };

    print(formData);
    var response = await Api().post(
        formData,
        updateFareValue.value == false
            ? "faresconfiguration/add"
            : "faresconfiguration/edit/${fareUpdateId.value}", sendCompanyId: true,);
    if (response.statusCode == 200) {
      // getAllFareConfigurationData!.fareConfigurations!.insert(0, FareConfiguration.fromJson(response.data['fare_configuration']));
      var newFare =
          FareConfiguration.fromJson(response.data['fare_configuration']);

      if (updateFareValue.value) {
        int index = getAllFareConfigurationData!.fareConfigurations!
            .indexWhere((f) => f.id == fareUpdateId.value);

        if (index != -1) {
          newFare.vehicleType = getAllFareConfigurationData!
              .fareConfigurations![index].vehicleType;
          newFare.account =
              getAllFareConfigurationData!.fareConfigurations![index].account;

          getAllFareConfigurationData!.fareConfigurations![index] = newFare;
        }
      } else {
        getAllFareConfigurationData!.fareConfigurations!.insert(0, newFare);
        getAllFareConfiguration();
      }
      print(response.data);
      BotToast.showText(
          text: updateFareValue.value
              ? "FARE CONFIGURATION IS UPDATED SUCCESSFULLY!"
              : "FARE CONFIGURATION IS ADDED SUCCESSFULLY!");
      refreshCreateFareFields();
    }
  }

  deletecreateFareSetting(int? id) async {
    var response = await Api().delete("faresconfiguration/delete/${id}");
    if (response.statusCode == 200) {
      // getAllFareConfigurationData!.fareConfigurations!.insert(0, FareConfiguration.fromJson(response.data['fare_configuration']));
      // print(response.data);
      BotToast.showText(text: "FARE CONFIGURATION DELETED SUCCESSFULLY");
      getAllFareConfiguration();
      refreshCreateFareFields();
      update();
    }
  }

  refreshCreateFareFields() async {
    vehicleValue = null;
    accountValue = null;
    fromDayValue = null;
    toDayValue = null;
    fromDayController.clear();
    toDayController.clear();
    startingFareController.clear();
    startingMilesController.clear();
    perMileFareController.clear();
    titleController.clear();
    updateFareValue.value = false;
    fareUpdateId.value = 0;
    update();
  }

  RxBool updateFareValue = false.obs;
  RxInt fareUpdateId = 0.obs;
  bindFare(FareConfiguration fare) {
    /// vehicle dropdown ka same instance select karna
    vehicleValue = fareGetVehicleTypeAccount!.vehicleTypes!
        .firstWhere((v) => v.id == fare.vehicleTypeId);

    /// account dropdown ka same instance select karna
    if (fare.account != null) {
      accountValue = fareGetVehicleTypeAccount!.accounts!
          .firstWhere((a) => a.id == fare.accountId);
    }

    fromDayValue = fare.fromDay;
    toDayValue = fare.toDay;

    fromDayController.text = fare.fromTime ?? "";
    toDayController.text = fare.toTime ?? "";

    startingFareController.text = fare.minimumFares?.toString() ?? "";
    startingMilesController.text = fare.minimumMiles?.toString() ?? "";
    perMileFareController.text = fare.perMileFares?.toString() ?? "";

    titleController.text = fare.title ?? "";

    startDate = fare.fromDate;
    endDate = fare.toDate;

    updateFareValue(true);
    fareUpdateId(fare.id!);

    update();
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> get all fare view
  RxBool getAllFareViewLoader = false.obs;
  GetAllFareConfigurationModel? getAllFareConfigurationData;
  getAllFareConfiguration() async {
    getAllFareViewLoader(true);

    var response =
        await Api().get("faresconfiguration/get?title=$fareConfiguration", sendCompanyId: true);

    if (response.statusCode == 200) {
      getAllFareConfigurationData =
          GetAllFareConfigurationModel.fromJson(response.data);

      getAllFareViewLoader(false);

      update();
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo FARE CONFIGURATION functionality
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo FARE INCREMENT functionality

  String? FareIncrementStart =
      "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";

  String? FareIncrementEnd =
      "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";

  String? operatorType;

  final incrementValueVehicleController = TextEditingController();

  String selectedType = "fixFare";

  bool isFixedFare = true;

  bool isMileage = false;

  void selectType(String type) {
    selectedType = type;

    if (type == "fixFare") {
      isFixedFare = true;
      isMileage = false;
    } else {
      isFixedFare = false;
      isMileage = true;
    }

    update();
  }

  postFareIncrement() async {
    var formData = {
      "start_date": FareIncrementStart,
      "end_date": FareIncrementEnd,
      "operator": operatorType,
      "amount": incrementValueVehicleController.text,
      "fix_fare": isFixedFare,
      "mileage": isMileage,
    };
    print(formData);
    var response = await Api().post(
        formData,
        isFareIncrementEditMode
            ? "fareincrement/update/${editingId}"
            : "fareincrement/add", sendCompanyId: true);
    if (response.statusCode == 200) {
      String msg = isFareIncrementEditMode
          ? "FARE INCREMENT UPDATED SUCCESSFULLY"
          : "FARE INCREMENT ADDED SUCCESSFULLY";

      BotToast.showText(text: msg);
      getFareIncrement();
      incrementValueVehicleController.clear();
      operatorType = null;
      isFareIncrementEditMode = false;
      editingId = null;
      FareIncrementStart = "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";
      FareIncrementEnd = "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";
      update();
      print(response.data);
    }
  }

  GetFareIncrementMoodel? getFareIncrementMoodel;
  RxBool getFareIncrementLoader = false.obs;

  getFareIncrement() async {
    getFareIncrementLoader(true);
    var response = await Api().get("fareincrement/get", sendCompanyId: true);
    if (response.statusCode == 200) {
      getFareIncrementMoodel = GetFareIncrementMoodel.fromJson(response.data);
      getFareIncrementLoader(false);
      update();
    }
  }

  bool isFareIncrementEditMode = false;
  int? editingId;

  bindFareIncrementForEdit(FareIncrement model) {
    isFareIncrementEditMode = true;
    editingId = model.id;

    // model.startDate agar 2026-03-10 14:30:00 hai, to ye sirf 2026-03-10 nikalega
    FareIncrementStart = model.startDate?.toIso8601String().split('T')[0] ??
        DateFormat('yyyy-MM-dd').format(DateTime.now());

    FareIncrementEnd = model.endDate?.toIso8601String().split('T')[0] ??
        DateFormat('yyyy-MM-dd').format(DateTime.now());

    operatorType = model.fareIncrementOperator;
    incrementValueVehicleController.text = model.amount ?? "";
    isFixedFare = model.fixFare ?? false;
    isMileage = model.mileage ?? false;
    selectedType = isFixedFare ? "fixFare" : "mileage";

    update();
  }

  deleteFareIncrement(int? id) async {
    var response = await Api().delete("fareincrement/delete/$id");
    if (response.statusCode == 200) {
      getFareIncrement();
      BotToast.showText(text: "FARE INCREMENT DELETED SUCCESSFULLY");
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo FARE INCREMENT functionality
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo SurCharges functionality

  String? postCodeWise = "POSTCODE WISE";
  String? selectDateWise = "TIME WISE";
  String? selectOperation = "SELECT OPERATION";
  String? selectPickup = "PICKUP";
  DaysClass? selectedDay;

  DateTime? startDateSurCharges = DateTime.now();
  DateTime? endDateSurCharges = DateTime.now();
  TextEditingController startTimeSurCharge = TextEditingController();
  TextEditingController endTimeSurCharge = TextEditingController();
  bool activeStatus = true;

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>post surcharge data
  postSurchargeData() async {
    var formData = {
      "active": activeStatus,
      "condition": selectPickup,
      if (congestionFareController.text.isNotEmpty)
        "congestion_charges": congestionFareController.text,
      "duration": selectDateWise,
      if (extraDropOffFareController.text.isNotEmpty)
        "extra_drop_charges": extraDropOffFareController.text,
      if (surChargesFareController.text.isNotEmpty)
        "fare": surChargesFareController.text,
      if (selectDateWise == "DATE WISE")
        "from_date":
            "${startDateSurCharges!.year}-${startDateSurCharges!.month}-${startDateSurCharges!.day}",
      if (startTimeSurCharge.text.isNotEmpty)
        "from_time": startTimeSurCharge.text,
      "operator": selectOperation,
      if (parkingFareController.text.isNotEmpty)
        "parking_charges": parkingFareController.text,
      "postcode": postCodeFareController.text,
      "surcharges_type": postCodeWise,
      if (selectDateWise == "DATE WISE")
        "to_date":
            "${endDateSurCharges!.year}-${endDateSurCharges!.month}-${endDateSurCharges!.day}",
      if (endTimeSurCharge.text.isNotEmpty) "to_time": endTimeSurCharge.text,
      if (selectDateWise == "DAY WISE") "day": selectedDay!.dayName,
    };
    var response = await Api().post(
        formData,
        sureChargeObject != null
            ? "surcharges/edit/${sureChargeObject!.id}"
            : "surcharges/add", sendCompanyId: true);
    if (response.statusCode == 200) {
      String message = sureChargeObject != null
          ? "SURCHARGES UPDATED SUCCESSFULLY"
          : "SURCHARGES ADDED SUCCESSFULLY";
      if (sureChargeObject == null) {
        getSurchargesModel!.surcharges!
            .insert(0, SurchargeObject.fromJson(response.data['surcharges']));
      } else {
        int index = getSurchargesModel!.surcharges!
            .indexWhere((test) => test.id == sureChargeObject!.id);
        getSurchargesModel!.surcharges![index] =
            SurchargeObject.fromJson(response.data['surcharges']);
      }
      sureChargeObject = null;
      BotToast.showText(text: message);
      clearSurchargesData();

    }
  }

  clearSurchargesData() async {
    congestionFareController.clear();
    extraDropOffFareController.clear();
    surChargesFareController.clear();
    parkingFareController.clear();
    postCodeFareController.clear();
    startTimeSurCharge.clear();
    endTimeSurCharge.clear();
    startDateSurCharges = DateTime.now();
    endDateSurCharges = DateTime.now();
    postCodeWise = "POSTCODE WISE";
    selectDateWise = "TIME WISE";
    selectOperation = "SELECT OPERATION";
    selectPickup = "PICKUP";
    selectedDay = null;
    update();
  }

  GetSurchargesModel? getSurchargesModel;
  RxBool getSurchargesLoader = false.obs;
  getSurcharges() async {
    getSurchargesLoader(true);
    var response = await Api().get("surcharges/get", sendCompanyId: true);
    if (response.statusCode == 200) {
      sureChargeObject = null;
      getSurchargesModel = GetSurchargesModel.fromJson(response.data);
      getSurchargesLoader(false);
      update();
    }
  }

  DateTime parseDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return DateTime.now();
    try {
      List<String> p = dateStr.split('-');
      return p.length == 3 ? DateTime(int.parse(p[2]), int.parse(p[1]), int.parse(p[0])) : (DateTime.tryParse(dateStr) ?? DateTime.now());
    } catch (_) {
      return DateTime.now();
    }
  }

  SurchargeObject? sureChargeObject;

  bindSurChargesData(
      {SurchargeObject? sureChargeData,
      bool changeActiveStatus = false}) async {
    sureChargeObject = sureChargeData;
    congestionFareController.text =
        sureChargeData!.congestionCharges.toString();
    activeStatus = sureChargeData.active!;
    extraDropOffFareController.text =
        sureChargeData.extraDropCharges.toString();
    postCodeFareController.text = sureChargeData.postcode.toString();
    surChargesFareController.text = sureChargeData.fare.toString();
    startTimeSurCharge.text = sureChargeData.fromTime.toString();
    parkingFareController.text = sureChargeData.parkingCharges.toString();
    endTimeSurCharge.text = sureChargeData.toTime.toString();
    postCodeWise = sureChargeData.surchargesType.toString();
    selectDateWise = sureChargeData.duration.toString();
    selectPickup = sureChargeData.condition.toString();
    startDateSurCharges = parseDate(sureChargeData.fromDate?.toString());
    endDateSurCharges = parseDate(sureChargeData.toDate?.toString());
    if (sureChargeData.day != null) {
      selectedDay =
          DaysClass(selectedDay: true.obs, dayName: sureChargeData.day);
      int index =
          daysList.indexWhere((test) => test.dayName == sureChargeData.day);
      daysList[index] =
          DaysClass(selectedDay: true.obs, dayName: sureChargeData.day);
    }
    if (changeActiveStatus == true) {
      activeStatus = !(sureChargeObject!.active ?? false);
      postSurchargeData();
    }
    update();
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> delete sure charge api

  deleteSureCharge({id}) async {
    var response = await Api().delete("surcharges/delete/$id");
    if (response.statusCode == 200) {
      int index =
          getSurchargesModel!.surcharges!.indexWhere((test) => test.id == id);
      getSurchargesModel!.surcharges!
          .remove(getSurchargesModel!.surcharges![index]);
      BotToast.showText(text: "SURCHARGES DELETED SUCCESSFULLY");
      update();
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo SurCharges functionality

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo Airport charges functionality

  AirPortChargesModel? airportChargesData;
  RxBool getAllAirPortChargesLoader = true.obs;
  getAllAirPortCharges() async {
    getAllAirPortChargesLoader(false);
    var response = await Api().get("airports/get",
    sendCompanyId: true,
    );
    if (response.statusCode == 200) {
      airportChargesData = AirPortChargesModel.fromJson(response.data);
      filteredLocations = airportChargesData?.locations ?? [];
      getAllAirPortChargesLoader(true);
      update();
    }
  }

  List<Location>? filteredLocations = [];
  bool isEditing = false;

  void filterAirports(String query) {
    if (isEditing) return;

    filteredLocations = (airportChargesController.text.isEmpty &&
            pickUpChargesController.text.isEmpty &&
            dropOffChargesController.text.isEmpty)
        ? (airportChargesData?.locations ?? [])
        : airportChargesData?.locations
            ?.where((loc) =>
                loc.name!
                    .toLowerCase()
                    .contains(airportChargesController.text.toLowerCase()) &&
                loc.pickupCharges!.contains(pickUpChargesController.text) &&
                loc.dropoffCharges!.contains(dropOffChargesController.text))
            .toList();

    update();
  }

  TextEditingController pickUpChargesController = TextEditingController();
  TextEditingController dropOffChargesController = TextEditingController();
  TextEditingController airportChargesController = TextEditingController();
  int? airPortSelectedItemId;

  editAirPortCharge() async {
    var formData = {
      "pickup_charges": pickUpChargesController.text,
      "dropoff_charges": dropOffChargesController.text,
    };
    var response =
        await Api().post(formData, "airports/edit/$airPortSelectedItemId");
    if (response.statusCode == 200) {
      print(response.data);
      int index = airportChargesData!.locations!
          .indexWhere((test) => test.id == airPortSelectedItemId);
      airportChargesData!.locations![index] =
          Location.fromJson(response.data['location']);
      airportChargesController.clear();
      pickUpChargesController.clear();
      dropOffChargesController.clear();
      BotToast.showText(text: "AIRPORT CHARGES UPDATED");
      filterAirports("");
      update();
    }
  }

  clearAirPortCharges(id) async {
    var response = await Api().post({}, "airports/clear/$id");
    if (response.statusCode == 200) {
      int index =
          airportChargesData!.locations!.indexWhere((test) => test.id == id);
      airportChargesData!.locations![index].pickupCharges = "0.0";
      airportChargesData!.locations![index].dropoffCharges = "0.0";
      BotToast.showText(text: "SUCCESS! SAVED");
      update();
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo Airport charges functionality
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo FARE METER functionality

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> get all fare meter

  GetAllFareMeterRateModel? getAllFareMeterRateModel;
  getAllFareMeterRate() async {
    var response = await Api().get("faremeter/get", sendCompanyId: true);
    if (response.statusCode == 200) {
      getAllFareMeterRateModel =
          GetAllFareMeterRateModel.fromJson(response.data);
      update();
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> edit fare mater

  RxBool specialDayValue = false.obs;
  final FocusNode specialDayNode = FocusNode();
  String? selectFareMeterDay;
  DateTime? specialDate = DateTime.now();

  editFareMeterRate({FareMeterObject? fareMeterObj}) async {
    var formData = {
      "has_meter": fareMeterObj!.hasMeter,
      "waiting_intervals": fareMeterObj.waitingIntervalsController.text,
      "autostart_wait": fareMeterObj.autostartWait,
      "autostart_waiting_speed_limit":
          fareMeterObj.activeWaitingController.text,
      "autostart_waiting_time":
          fareMeterObj.autostartWaitingTimeController.text,
      "autostop_waiting_speed_limit":
          fareMeterObj.suspendWaitingSpeedController.text,
    };
    formData["waiting_charges"] =
        fareMeterObj.waitingCharges!.map((e) => e.toJson()).toList();
    print(formData);
    var response =
        await Api().post(formData, "faremeter/edit/${fareMeterObj.id}");
    if (response.statusCode == 200) {
      int index = getAllFareMeterRateModel!.fareMeters!
          .indexWhere((test) => test.id == fareMeterObj.id);
      getAllFareMeterRateModel!.fareMeters![index] =
          FareMeterObject.fromJson(response.data['fareMeter']);
      BotToast.showText(text: "Fare Add Sucessfully");
      update();
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo FARE METER functionality

  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Create Fare by Vehicle Setting

  VehicleTypeFixed? createByVehicleTypes;
  FixedFareVehicleLocationTypeModel? VehicleTypeModel;
  RxBool getFixedFareVehicleLoader = false.obs;
  getFixedFareVehicleType() async {
    getFixedFareVehicleLoader(true);
    var response = await Api().get("combined/vehicle-location-types", sendCompanyId: true );
    if (response.statusCode == 200) {
      VehicleTypeModel =
          FixedFareVehicleLocationTypeModel.fromJson(response.data);
      getFixedFareVehicleLoader(false);
      update();
    }
  }

  String? fareByVehicleOperater = "AMOUNT";
  final fareValueVehicleController = TextEditingController();

  FareByVehicleSetting? fareByVehicleSetting;
  RxBool farebyVehicleLoader = false.obs;
  getFareByVehicleSetting() async {
    farebyVehicleLoader(true);
    var response = await Api().get(
      "farebyvehicle/get",
      sendCompanyId: true,
    );
    if (response.statusCode == 200) {
      fareByVehicleSetting = FareByVehicleSetting.fromJson(response.data);
      farebyVehicleLoader(false);
      update();
    }
  }

  postFareByVehicleSetting() async {
    var formData = {
      'vehicle_type_id': createByVehicleTypes!.id,
      'value': fareValueVehicleController.text,
      'operator': fareByVehicleOperater,
    };
    print(formData);
    var response = await Api().post(
        formData,
        updateFarebyVehicle.value == false
            ? "farebyvehicle/add"
            : "farebyvehicle/update/${fareByVehicleUpdateId.value}",
    sendCompanyId: true,
    );
    if (response.statusCode == 200) {
      BotToast.showText(
          text: updateFarebyVehicle.value
              ? "FARE BY VEHICLE UPDATED SUCCESSFULLY"
              : "FARE BY VEHICLE ADDED SUCCESSFULLY"
      );
      getFareByVehicleSetting();
      fareValueVehicleController.clear();
      createByVehicleTypes = null;
      fareByVehicleOperater = 'AMOUNT';
      print(response.data);
    }
  }

  RxBool updateFarebyVehicle = false.obs;
  RxInt fareByVehicleUpdateId = 0.obs;

  bindFareByVechicle(FareByVehicle fareByVehicleEdit) {
    fareByVehicleUpdateId.value = fareByVehicleEdit.id!;
    createByVehicleTypes = VehicleTypeModel!.vehicleTypesFixed?.firstWhere(
        (element) => element.id == fareByVehicleEdit.vehicleTypeId);
    fareValueVehicleController.text = fareByVehicleEdit.value.toString();
    fareByVehicleOperater = fareByVehicleEdit.fareByVehicleOperator;
    updateFarebyVehicle(true);
    update();
  }

  deleteCustomer(int? id) async {
    var response = await Api().delete("farebyvehicle/delete/$id");
    if (response.statusCode == 200) {
      getFareByVehicleSetting();
      BotToast.showText(text: "FARE BY VEHICLE DELETED SUCCESSFULLY");
    }
  }

  clearAllFields() {
    fareValueVehicleController.clear();
    createByVehicleTypes = null;
    fareByVehicleOperater = 'AMOUNT';
    updateFarebyVehicle(false);
    update();
  }
}

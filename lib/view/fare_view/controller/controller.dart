

import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/networks/api.dart';
import 'package:dashboard_new1/view/fare_view/model/allPlotFareModel.dart';
import 'package:dashboard_new1/view/fare_view/model/fixedFareVehicleLocationTypeModel.dart';
import 'package:dashboard_new1/view/fare_view/fare_configuration_day/fare_configuration_model.dart';
import 'package:dashboard_new1/view/fare_view/model/getAllFixedfareModel.dart';
import 'package:dashboard_new1/view/fare_view/model/getFareIncrementModel.dart';
import 'package:dashboard_new1/view/fare_view/model/getSurchargesModel.dart';
import 'package:dashboard_new1/view/fare_view/model/getVehicleTypeAccountModel.dart';
import 'package:dashboard_new1/view/fare_view/model/plotVehicleModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../dashboard_view/models/all_addresses_model.dart';

class FareController extends GetxController {

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo Plot Fare functionality

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo Plot Fare functionality

  final vehicleTypeController = TextEditingController();
  final fareController = TextEditingController();
  final fareDescriptionController = TextEditingController();
  final fareDescription2ndController = TextEditingController();
  final fareValueVehicleController = TextEditingController();


  VehicleTypee? plotVehicleTypevalue;
  Zonee? Zoneevalue;
  Zonee? Zonee1value;
  PlotVehicleTypeModel? plotVehicleTypeModel;
  RxBool getPlotVehicleTypeLoader = false.obs;
  getPlotVehicleType()async{
    getPlotVehicleTypeLoader(true);
    var response = await Api().get("combined/zone-vehicle-types");
    if (response.statusCode == 200) {
      plotVehicleTypeModel = PlotVehicleTypeModel.fromJson(response.data);
      getPlotVehicleTypeLoader(false);
      update();
    }
  }

  postPlotFare() async{
    var formData = {
      "vehicle_type_id": plotVehicleTypevalue!.id,
      "pickup_plot_id": Zoneevalue!.id,
      "dropoff_plot_id": Zonee1value!.id,
      "fares": fareController.text,

    };
    print(formData);
    var response = await Api().post(formData, "plotfares/add");
    if(response.statusCode == 200){

      print(response.data);
      BotToast.showText(text: "Plot Fare successfully added");

    }
  }



  AllPlotFareModel? allPlotFareModel;
  RxBool getAllPlotFareLoader = false.obs;
  getAllPlotFare()async{
    getAllPlotFareLoader(true);
    var response = await Api().get("plotfares/get");
    if (response.statusCode == 200) {
      allPlotFareModel = AllPlotFareModel.fromJson(response.data);
      getAllPlotFareLoader(false);
      update();
    }
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

  /// bool
  final meteredSwitch = ValueNotifier<bool>(false);
  final autoWaitSwitch = ValueNotifier<bool>(false);

  /// TextEditingControllers
  final activeWaitingController = TextEditingController();

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo SURCHARGES functionality
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo Fixed Fare functionality




  VehicleTypeFixed? vehicleTypesFixedvalue;
  LocationType?locationTypevalue;

  FixedFareVehicleLocationTypeModel? fixedFareVehicleLocationTypeModel;
  RxBool getFixedFareVehicleLocationTypeLoader = false.obs;
  getFixedFareVehicleLocationType()async{
    getFixedFareVehicleLocationTypeLoader(true);
    var response = await Api().get("combined/vehicle-location-types");
    if (response.statusCode == 200) {
      fixedFareVehicleLocationTypeModel = FixedFareVehicleLocationTypeModel.fromJson(response.data);
      getFixedFareVehicleLocationTypeLoader(false);
      update();
    }
  }



  GetAllFixedFareModel? getAllFixedFareModel;
  RxBool getAllFixedFareLoader = false.obs;

  getAllFixedFare()async{
    getFixedFareVehicleLocationTypeLoader(true);
    var response = await Api().get("fixedfares/get");
    if (response.statusCode == 200) {
      getAllFixedFareModel = GetAllFixedFareModel.fromJson(response.data);
      getAllFixedFareLoader(false);
      update();
    }
  }


  RxBool postFixedFareLoader = false.obs;


  postFixedFare() async {
    postFixedFareLoader(true);
    var formData = {
      "vehicle_type_id": "70",
      "area1": "Islamabad",
      "area2": "Lahore",
      "fares": "20",
      "from_location_id": "1",
      "to_location_id": "24",

    };

    var response = await Api().post(
        formData,
        'fixedfares/add',
        auth: true);
    if (response.statusCode == 200) {

      getAllFixedFare();
      update();
      print(response);
    } else {
      print("errorrrrrrrrrrrrrrrrrrrrrrrrrrr");
      print(response);
    }
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
  final stackKey = GlobalKey();
  final GlobalKey suggestionListKey = GlobalKey();
  final GlobalKey suggestionListKeyVia = GlobalKey();
  final suggestionScrollController = ScrollController();
  AllAddressesModel? selectedModel;
  RxInt suggestionSelectedIndex = 0.obs;


  void selectSuggestion(String? value) {
    viaLocation2Controller.text = value!;
    viaLocation2Controller.selection = TextSelection.collapsed(offset: value.length);
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
    highlightedIndex.value = (highlightedIndex.value + 1) % allAddressesData.length;
    highlightedIndex.refresh();_scrollToHighlighted(scrollDown: true); // 👈 scroll to bottom when down
  }

  void moveHighlightUp({bool viaConditionValue = false}) {
    if (allAddressesData.isEmpty) return;

    highlightedIndex.value = (highlightedIndex.value - 1 + allAddressesData.length) % allAddressesData.length;
    highlightedIndex.refresh();
    _scrollToHighlighted(
        scrollDown: false,
        viaCondition: viaConditionValue
    ); // 👈 scroll to top when up
  }

  void _scrollToHighlighted(
      {bool scrollDown = true, bool viaCondition = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final i = highlightedIndex.value;
      if (i < 0 || i >= suggestionItemKeys.length) return;

      final itemCtx = suggestionItemKeys[i].currentContext;

      final listCtx = suggestionListKey.currentContext;

      if (itemCtx != null && listCtx != null &&
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
  String? startDate = "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
  String? endDate = "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
  String? fareConfiguration = "NORMAL";

  /// TextEditingControllers
  final fromDayController = TextEditingController(text: "09:08 AM");
  final toDayController = TextEditingController(text: "09:08 AM");
  final startingFareController = TextEditingController();
  final startingMilesController = TextEditingController();
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
  getFareGetVehicleTypeAccount()
  async{
    getFareGetVehicleTypeAccountLoader(true);
    var response = await Api().get("combined/vehicle-type-accounts");
    if (response.statusCode == 200) {
      fareGetVehicleTypeAccount = FareGetVehicleTypeAccount.fromJson(response.data);
      await getAllFareConfiguration();
      getFareGetVehicleTypeAccountLoader(false);
      update();
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> create fare setting
  createFareSetting() async{
    var formData = {
      "vehicle_type_id": vehicleValue!.id,
      "account_id": accountValue!.id,
      "from_day": fromDayValue,
      "to_day": toDayValue,
      "from_time": fromDayController.text,
      "to_time": toDayController.text,
      "minimum_fares": startingFareController.text,
      "minimum_miles": startingMilesController.text,
      if(titleController.text.isNotEmpty && fareConfiguration != "NORMAL") "title": titleController.text,
      if(fareConfiguration != "NORMAL") "from_date": startDate,
      if(fareConfiguration != "NORMAL") "to_date": endDate,
    };
    print(formData);
    var response = await Api().post(formData, "faresconfiguration/add");
    if(response.statusCode == 200){
      getAllFareConfigurationData!.fareConfigurations!.insert(0, FareConfiguration.fromJson(response.data['fare_configuration']));
      print(response.data);
      BotToast.showText(text: "Fare configuration is successfully added");
      refreshCreateFareFields();
    }
  }

  refreshCreateFareFields() async{
    vehicleValue = null;
    accountValue = null;
    fromDayValue = null;
    toDayValue = null;
    fromDayController.clear();
    toDayController.clear();
    startingFareController.clear();
    startingMilesController.clear();
    titleController.clear();
    update();
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> get all fare view
  RxBool getAllFareViewLoader = false.obs;
  GetAllFareConfigurationModel? getAllFareConfigurationData;
  getAllFareConfiguration() async{

    getAllFareViewLoader(true);

    var response = await Api().get("faresconfiguration/get?title=$fareConfiguration");

    if(response.statusCode == 200){

      getAllFareConfigurationData = GetAllFareConfigurationModel.fromJson(response.data);

      getAllFareViewLoader(false);

      update();
    }
  }



///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo FARE CONFIGURATION functionality
///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo FARE INCREMENT functionality



  String? FareIncrementStart = "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
  String? FareIncrementEnd = "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
  String? operatorType;
  final  incrementValueVehicleController = TextEditingController();
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






  postFareIncrement() async{
    var formData = {
      "start_date": FareIncrementStart,
      "end_date": FareIncrementEnd,
      "operator": operatorType,
      "amount": incrementValueVehicleController.text,
      "fix_fare": isFixedFare,
      "mileage": isMileage,

    };
    print(formData);
    var response = await Api().post(formData, "fareincrement/add");
    if(response.statusCode == 200){
      print(response.data);
      BotToast.showText(text: "Fare configuration is successfully added");

    }
  }







  GetFareIncrementMoodel? getFareIncrementMoodel;
  RxBool getFareIncrementLoader = false.obs;

  getFareIncrement() async{
    getFareIncrementLoader(true);
    var response = await Api().get("fareincrement/get");
    if(response.statusCode == 200){
      getFareIncrementMoodel = GetFareIncrementMoodel.fromJson(response.data);
      getFareIncrementLoader(false);
      update();
    }
  }












///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo FARE INCREMENT functionality
///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo SurCharges functionality





  GetSurchargesModel? getSurchargesModel;
  RxBool getSurchargesLoader = false.obs;

  getSurcharges() async{
    getSurchargesLoader(true);
    var response = await Api().get("surcharges/get");
    if(response.statusCode == 200){
      getSurchargesModel = GetSurchargesModel.fromJson(response.data);
      getSurchargesLoader(false);
      update();
    }
  }










///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo SurCharges functionality



}
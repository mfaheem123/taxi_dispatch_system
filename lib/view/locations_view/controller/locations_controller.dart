import 'dart:convert';

import 'package:dashboard_new1/component/networks/api.dart';
import 'package:dashboard_new1/view/locations_view/Model/locationListModel.dart';
import 'package:dashboard_new1/view/locations_view/Model/location_types_zoneModel.dart';
import 'package:dashboard_new1/view/locations_view/Model/zoneListModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../Model/zoneListModel.dart';

class LocationController extends GetxController {
  final List<Postcode> _postcodes = [
    Postcode("NW7"),
    Postcode("N3"),
    Postcode("N12"),
    Postcode("NW4"),
    Postcode("N2"),
    Postcode("N20"),
    Postcode("NW9"),
    Postcode("NW11"),
    Postcode("HA8"),
    Postcode("N11"),
    Postcode("EN5"),
    Postcode("NW6"),
  ];

  List<Postcode> get postcodes => List.unmodifiable(_postcodes);

  void addPostcode(String code) {
    _postcodes.add(Postcode(code));
    update();
  }

  void removePostcode(Postcode postcode) {
    _postcodes.remove(postcode);
    update();
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>LIST OF LOCATIONS Functionality

  /// bool variables
  RxBool blackList = false.obs;

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>LIST OF LOCATIONS Functionality
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo Create Location Form
  final locationNameCtrl = TextEditingController();
  final longitudeCtrl = TextEditingController();
  final postcodeCtrl = TextEditingController();
  final shortcutCtrl = TextEditingController();
  final extraChargesCtrl = TextEditingController();

  final latitudeCtrl = TextEditingController();
  final addressCtrl = TextEditingController();

  ZoneObject? zoneValue;
  LocationTypeObject? locationTypeValue;

  RxBool getLocationTypeZoneLoader = false.obs;
  LocationtypezoneModel? locationtypezoneModel;

  getLocationTypeZone({selectedZoneId, selectedLocationTypeId}) async {
    getLocationTypeZoneLoader(true);
    var response = await Api().get("locationtype/zone");
    if (response.statusCode == 200) {
      locationtypezoneModel = LocationtypezoneModel.fromJson(response.data);
      if (updateLocationValue.value == true) {
        int index = locationtypezoneModel!.zonesList!
            .indexWhere((test) => test.id == selectedZoneId);
        int indexx = locationtypezoneModel!.locationTypesList!
            .indexWhere((testt) => testt.id == selectedLocationTypeId);
        zoneValue = locationtypezoneModel!.zonesList![index];
        locationTypeValue = locationtypezoneModel!.locationTypesList![index];
      }
      getLocationTypeZoneLoader(false);
      update();
    }
  }

  RxBool postLocationForm = false.obs;

  postLocation() async {
    postLocationForm(true);
    var formData = {
      "name": locationNameCtrl.text,
      "location_type_id": locationTypeValue!.id,
      "address": addressCtrl.text,
      "postcode": postcodeCtrl.text,
      "zone_id": zoneValue!.id,
      "shortcut": shortcutCtrl.text,
      "background_color": null,
      "foreground_color": null,
      "extra_charges": extraChargesCtrl.text,
      "pickup_charges": null,
      "dropoff_charges": null,
      "blacklist": false,
      "latitude": latitudeCtrl.text,
      "longitude": longitudeCtrl.text,
    };
    print(locationUpdateId.value);
    var response = await Api().post(
        formData,
        updateLocationValue.value == false
            ? 'locations'
            : 'locations/${locationUpdateId.value}',
        auth: true);
    if (response.statusCode == 200) {
      locationNameCtrl.clear();
      longitudeCtrl.clear();
      postcodeCtrl.clear();
      shortcutCtrl.clear();
      extraChargesCtrl.clear();
      latitudeCtrl.clear();
      addressCtrl.clear();
      locationTypeValue = null;
      zoneValue = null;

      update();
      print(response);
    } else {
      print("errorrrrrrrrrrrrrrrrrrrrrrrrrrr");
      print(response);
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo Create Location Form
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  todo List Location Work

  RxList<Locations> locationsAll = <Locations>[].obs;
  RxList<Locations> locationsFiltered = <Locations>[].obs;
  RxString searchLocationName = ''.obs;
  RxString searchPostCode = ''.obs;
  RxString searchShortCuts = ''.obs;
  RxString searchAddress = ''.obs;
  RxString searchLocationType = ''.obs;
  RxString searchZone = ''.obs;
//   ///------------------------- Pagination
  var locationCurrentPage = 1.obs;
  var locationTotalPages = 1.obs;
  final int locationLimit = 20;
  LocationListModel? locationListModel;
  RxBool getLocationLoader = false.obs;

  getLocationList() async {
    try {
      getLocationLoader(true);
      var response = await Api().get("locations/get?",queryParameters: {
        'page': locationCurrentPage.value,
        "limit": locationLimit,
        "name": searchLocationName.value.toLowerCase(),
        "postcode": searchPostCode.value.toLowerCase(),
        "shortcut": searchShortCuts.value.toLowerCase(),
        "address": searchAddress.value.toLowerCase(),
        "location_type": searchLocationType.value.toLowerCase(),
        "zone": searchZone.value.toLowerCase(),
      });
      if (response.statusCode == 200) {
        locationListModel = LocationListModel.fromJson(response.data);
        locationTotalPages.value = locationListModel?.totalPages ?? 1;
        locationsAll.value = locationListModel?.locations ?? [];
        locationsFiltered.value = locationsAll;
        getLocationLoader(false);
        update();
      }
    } catch (e) {
      print("Error in Location List: $e");
    } finally {
      getLocationLoader.value = false;
      update();
    }
  }

  // --------Search changes function
  void SearchLocation() {
    locationCurrentPage.value = 1;
    getLocationList();
  }

  void PageLocation(int page) {
    locationCurrentPage.value = page;
    getLocationList();
  }

  RxBool updateLocationValue = false.obs;
  RxInt locationUpdateId = 0.obs;
  bindLocationUpdateLocation({Locations? locationUpdate}) async {
    locationUpdateId.value = locationUpdate!.id!;
    locationNameCtrl.text = locationUpdate.name!;
    longitudeCtrl.text = locationUpdate.longitude!;
    postcodeCtrl.text = locationUpdate.postcode!;
    shortcutCtrl.text = locationUpdate.shortcut!;
    extraChargesCtrl.text = locationUpdate.extraCharges!;
    latitudeCtrl.text = locationUpdate.latitude!;
    addressCtrl.text = locationUpdate.address!;
    updateLocationValue(true);
    getLocationTypeZone(
        selectedZoneId: locationUpdate.zoneId,
        selectedLocationTypeId: locationUpdate.locationTypeId);  //-------------------------------------------------------------------
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Delete Location List Work

  deleteLocation(int? id) async {
    var response = await Api().delete("locations/delete/$id");
    if (response.statusCode == 200) {
      getLocationList();
      print("✅ Location deleted successfully!");
      print(json.encode(response.data));
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Delete Location List Work

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo Localization Work

  // class Postcode {
  // final String code;
  // Postcode(this.code);
  // }
  // List<Postcode> postcodes = [];
  //
  // final Dio _dio = Dio(BaseOptions(
  //   baseUrl: 'http://192.168.110.4:5000/api',
  //   connectTimeout: const Duration(seconds: 10),
  //   receiveTimeout: const Duration(seconds: 10),
  // ));
  //
  // Future<void> adddPostcode(String code) async {
  //   try {
  //     final response = await _dio.post(
  //       '/localizations',
  //       data: FormData.fromMap({
  //         'postcode': code,
  //       }),
  //     );
  //
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       // Successfully added on server — now update local list
  //       postcodes.add(Postcode(code));
  //       update();
  //       Get.snackbar('Success', 'Postcode added successfully',
  //           snackPosition: SnackPosition.BOTTOM,
  //           backgroundColor: const Color(0xFF4CAF50),
  //           colorText: const Color(0xFFFFFFFF));
  //     } else {
  //       Get.snackbar('Error', 'Failed to add postcode',
  //           snackPosition: SnackPosition.BOTTOM,
  //           backgroundColor: const Color(0xFFE53935),
  //           colorText: const Color(0xFFFFFFFF));
  //     }
  //   } catch (e) {
  //     Get.snackbar('Error', e.toString(),
  //         snackPosition: SnackPosition.BOTTOM,
  //         backgroundColor: const Color(0xFFE53935),
  //         colorText: const Color(0xFFFFFFFF));
  //   }
  // }
  //
  // void removeePostcode(Postcode postcode) {
  //   postcodes.remove(postcode);
  //   update();
  // }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo Localization Work
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo zone List Work

  ZoneModel? zoneListModel;
  RxList<Zones> zoneAll = <Zones>[].obs;
  RxList<Zones> zoneFiltered = <Zones>[].obs;
  RxString searchZoneName = ''.obs;
  RxString searchShortName = ''.obs;
  RxString searchType = ''.obs;
  RxString searchCategory = ''.obs;
  var zoneCurrentPage = 1.obs;
  var zoneTotalPages = 1.obs;
  final int zoneLimit = 20;
  RxBool getZoneLoader = false.obs;
  Future<void> getZoneList() async {
    try {
      getZoneLoader(true);
      String query = 'page=${zoneCurrentPage.value}&limit=$zoneLimit';
      if (searchZoneName.value.isNotEmpty)
        query += '&name=${searchZoneName.value}';
      if (searchShortName.value.isNotEmpty)
        query += '&secondary_name=${searchShortName.value}';
      if (searchType.value.isNotEmpty) query += '&type=${searchType.value}';
      if (searchCategory.value.isNotEmpty)
        query += '&category=${searchCategory.value}';
      print("API Query: zones/get?$query");
      var response = await Api().get("zones/get?$query");
      if (response.statusCode == 200) {
        zoneListModel = ZoneModel.fromJson(response.data);
        zoneTotalPages.value = zoneListModel?.totalPages ?? 1;
        zoneAll.value = zoneListModel?.zones ?? [];
        zoneFiltered.value = zoneAll;
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception in getZoneList: $e");
    } finally {
      getZoneLoader(false);
      update();
    }
  }









// -----------Search function

  void onSearchChanged() {
    zoneCurrentPage.value = 1;
    getZoneList();
  }

  /// ------- pagination function
  void zonePageChange(int page) {
    zoneCurrentPage.value = page;
    getZoneList();
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Zone Work
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo zone List Delete Work

  deleteZoneList(
    int? id,
  ) async {
    var response = await Api().delete("zones/delete/$id");
    if (response.statusCode == 200) {
      getZoneList();

      update();
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo zone List Delete Work
}

class DashBoardBindings implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<LocationController>(() => LocationController());
  }
}

class Postcode {
  final String code;
  Postcode(this.code);
}

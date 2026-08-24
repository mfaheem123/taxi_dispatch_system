import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/networks/api.dart';
import 'package:dashboard_new1/view/locations_view/Model/locationListModel.dart'
    hide Zone;
import 'package:dashboard_new1/view/locations_view/Model/location_types_zoneModel.dart';
import 'package:dashboard_new1/view/locations_view/Model/zoneListModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../Model/zoneListModel.dart' hide Zone;

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
  ZoneObject? RNzoneValue;
  ZoneObject? RN1zoneValue;
  ZoneObject? zoneDValue;
  LocationTypeObject? locationTypeValue;
  RxBool getLocationTypeZoneLoader = false.obs;
  LocationtypezoneModel? locationtypezoneModel;

  getLocationTypeZone({selectedZoneId, selectedLocationTypeId}) async {
    getLocationTypeZoneLoader(true);
    update(); // UI ko loader dikhane ke liye

    try {
      var response = await Api().get("locationtype/zone", sendCompanyId: true);
      if (response.statusCode == 200) {
        locationtypezoneModel = LocationtypezoneModel.fromJson(response.data);

        // Agar update mode hai toh list load hote hi matching objects set karein
        if (updateLocationValue.value == true) {
          zoneValue = locationtypezoneModel!.zonesList?.firstWhereOrNull(
                  (z) => z.id == selectedZoneId
          );
          locationTypeValue = locationtypezoneModel!.locationTypesList?.firstWhereOrNull(
                  (lt) => lt.id == selectedLocationTypeId
          );
        }
      }
    } catch (e) {
      print("Error fetching dropdown data: $e");
    } finally {
      getLocationTypeZoneLoader(false);
      update();
    }
  }

  RxBool postLocationForm = false.obs;

  postLocation() async {
    if (locationNameCtrl.text.trim().isEmpty ||
        latitudeCtrl.text.trim().isEmpty ||
        longitudeCtrl.text.trim().isEmpty ||
        postcodeCtrl.text.trim().isEmpty ||
        addressCtrl.text.trim().isEmpty ||
        shortcutCtrl.text.trim().isEmpty ||
        extraChargesCtrl.text.trim().isEmpty ||
        locationTypeValue == null ||
        zoneValue == null) {

      BotToast.showText(
        text: "PLEASE FILL ALL FIELDS AND SELECT ALL DROPDOWNS!",
      );
      return;
    }

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
    var response = await Api().post(
        formData,
        updateLocationValue.value == false
        ?'locations':
        'locations/${locationUpdateId.value}'
             ,
        sendCompanyId: true,
        auth: true);
    if (response.statusCode == 200) {
      BotToast.showText(
          text: updateLocationValue.value
              ? "LOCATION UPDATED SUCCESSFULLY"
              : "LOCATION ADDED SUCCESSFULLY"
      );
      print(formData);
      clearLocationForm();
      update();
      print(response);
    } else {
      print("errorrrrrrrrrrrrrrrrrrrrrrrrrrr");
      print(response);
    }
  }

  void clearLocationForm() {
    locationNameCtrl.clear();
    longitudeCtrl.clear();
    postcodeCtrl.clear();
    shortcutCtrl.clear();
    extraChargesCtrl.clear();
    latitudeCtrl.clear();
    addressCtrl.clear();
    locationTypeValue = null;
    zoneValue = null;
    updateLocationValue(false);
    locationUpdateId.value = 0;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo Create Location Form
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  todo List Location Work

  RxList<Location> locationsAll = <Location>[].obs;
  RxList<Location> locationsFiltered = <Location>[].obs;
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
  RxBool blackList = false.obs;
  getLocationList() async {
      getLocationLoader(true);
      var response = await Api().get("locations/get", queryParameters: {
        'page': locationCurrentPage.value,
        "limit": locationLimit,
        "name": searchLocationName.value.toLowerCase(),
        "postcode": searchPostCode.value.toLowerCase(),
        "shortcut": searchShortCuts.value.toLowerCase(),
        "address": searchAddress.value.toLowerCase(),
        "location_type": searchLocationType.value.toLowerCase(),
        "zone": searchZone.value.toLowerCase(),
        "blacklist" : blackList.value,
      },
       auth: true,
      sendCompanyId: true,
      );
      if (response.statusCode == 200) {
        locationListModel = LocationListModel.fromJson(response.data);
        locationTotalPages.value = locationListModel?.totalPages ?? 1;
        locationsAll.value = locationListModel?.locations ?? [];
        locationsFiltered.value = locationsAll;
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
  RxBool updateDLocationValue = false.obs;
  RxBool updateRNLocationValue = false.obs;
  RxBool updateRN1LocationValue = false.obs;
  RxInt locationUpdateId = 0.obs;
  // bindLocationUpdateLocation({Location? locationUpdate}) async {
  //   if (locationUpdate == null) return;
  //
  //   locationUpdateId.value = locationUpdate.id ?? 0;
  //   locationNameCtrl.text = (locationUpdate.name ?? '').toUpperCase();
  //   longitudeCtrl.text = locationUpdate.longitude ?? '';
  //   latitudeCtrl.text = locationUpdate.latitude ?? '';
  //   postcodeCtrl.text = (locationUpdate.postcode ?? '').toUpperCase();
  //   shortcutCtrl.text = (locationUpdate.shortcut ?? '').toUpperCase();
  //   addressCtrl.text = (locationUpdate.address ?? '').toUpperCase();
  //   extraChargesCtrl.text = (locationUpdate.extraCharges.toString()).toUpperCase();
  //
  //   updateLocationValue(true);
  //
  //   await getLocationTypeZone();
  //   if (locationtypezoneModel != null) {
  //     zoneValue = locationtypezoneModel!.zonesList?.firstWhereOrNull(
  //             (z) => z.id == locationUpdate.zoneId
  //     );
  //     locationTypeValue = locationtypezoneModel!.locationTypesList?.firstWhereOrNull(
  //             (lt) => lt.id == locationUpdate.locationTypeId
  //     );
  //
  //     print("Zone Found: ${zoneValue?.name}");
  //   }
  //   update();
  // }
  bindLocationUpdateLocation({Location? locationUpdate}) async {
    if (locationUpdate == null) return;

    locationUpdateId.value = locationUpdate.id ?? 0;

    locationNameCtrl.text = (locationUpdate.name ?? '').toUpperCase();
    longitudeCtrl.text = locationUpdate.longitude ?? '';
    latitudeCtrl.text = locationUpdate.latitude ?? '';
    postcodeCtrl.text = (locationUpdate.postcode ?? '').toUpperCase();
    shortcutCtrl.text = (locationUpdate.shortcut ?? '').toUpperCase();
    addressCtrl.text = (locationUpdate.address ?? '').toUpperCase();
    extraChargesCtrl.text = locationUpdate.extraCharges.toString();

    updateLocationValue(true);


    await getLocationTypeZone();


    zoneValue = locationtypezoneModel?.zonesList?.firstWhereOrNull(
          (z) => z.id == locationUpdate.zoneId,
    );


    locationTypeValue =
        locationtypezoneModel?.locationTypesList?.firstWhereOrNull(
              (lt) => lt.id == locationUpdate.locationTypeId,
        );


    print("EDIT ZONE => ${zoneValue?.name}");
    print("EDIT TYPE => ${locationTypeValue?.name}");

    update();
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Delete Location List Work

  deleteLocation(int? id) async {
    var response = await Api().delete("locations/delete/$id");
    if (response.statusCode == 200) {
      BotToast.showText(text: "LOCATION DELETED SUCCESSFULLY");
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
  //   baseUrl: 'http://192.168.110.3:5000/api',
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
// ------------------ Zone Controller Logic ------------------

ZoneModel? zoneListModel;
RxList<Zone> zoneAll = <Zone>[].obs;
RxList<Zone> zoneFiltered = <Zone>[].obs;
RxString searchZoneName = ''.obs;
RxString searchShortName = ''.obs;
RxString searchType = ''.obs;
RxString searchCategory = ''.obs;
var zoneCurrentPage = 1.obs;
var zoneTotalPages = 1.obs;
final int zoneLimit = 20;
RxBool getZoneLoader = false.obs;

getZoneList() async {
    getZoneLoader(true);
    var response = await Api().get(
  "zones/get",
      queryParameters: {
        "page": zoneCurrentPage.value,
        "limit": zoneLimit,
        "name": searchZoneName.value.toLowerCase(),
        "secondary_name": searchShortName.value.toLowerCase(),
        "type": searchType.value.toLowerCase(),
        "category": searchCategory.value.toLowerCase(),
      },
     auth: true,
      sendCompanyId: true,
    );

    if (response.statusCode == 200) {
      zoneListModel = ZoneModel.fromJson(response.data);
      zoneTotalPages.value = zoneListModel?.totalPages ?? 1;
      zoneAll.value = zoneListModel?.zones ?? [];
      zoneFiltered.value = zoneAll;
      update();
    }

}

/// -----------Search function
void onSearchChanged() {
  zoneCurrentPage.value = 1;
  getZoneList();
}

/// ------- Pagination function
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
      BotToast.showText(text: 'ZONE DELETED SUCCESSFULLY');
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

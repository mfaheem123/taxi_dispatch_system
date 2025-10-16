


import 'package:dashboard_new1/component/networks/api.dart';
import 'package:dashboard_new1/view/locations_view/Model/locationListModel.dart';
import 'package:dashboard_new1/view/locations_view/Model/location_types_zoneModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LocationController extends GetxController{

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
final locationNameCtrl=TextEditingController();
final longitudeCtrl=TextEditingController();
final postcodeCtrl=TextEditingController();
final shortcutCtrl=TextEditingController();
final extraChargesCtrl=TextEditingController();
final latitudeCtrl=TextEditingController();
final addressCtrl=TextEditingController();

  LocationtypezoneModel? locationtypezoneModel;



  RxString zoneValue = ''.obs;
  RxString locationTypeValue = ''.obs;

  List<String> zones = ["Zone 1", "Zone 2", "Zone 3"];
  List<String> locationTypes = ["Pickup", "Dropoff", "Hub"];

  RxBool postLocationForm = false.obs;

  postLocation()async{
    postLocationForm(true);

    var formData = {

      "name":locationNameCtrl.text,
      "location_type_id": 11,
      "address": addressCtrl.text,
      "postcode": postcodeCtrl.text,
      "zone_id": null,
      "shortcut":shortcutCtrl.text,
      "background_color": null,
      "foreground_color": null,
      "extra_charges": extraChargesCtrl.text,
      "pickup_charges": null,
      "dropoff_charges": null,
      "blacklist": false,
      "latitude": latitudeCtrl.text,
      "longitude": longitudeCtrl.text

    };
      var response = await Api().post(formData, 'locations', auth: true);
    if (response.statusCode == 201) {
      print(response);
    }else{
      print("errorrrrrrrrrrrrrrrrrrrrrrrrrrr");
      print(response);
    }

  }



  RxBool getLocationtypeZone = false.obs;
  getLocationTypeZone()async{
    getLocationtypeZone(true);
    var response = await Api().get("locationtype/zone");
    if(response.statusCode == 200){
      locationtypezoneModel = LocationtypezoneModel.fromJson(response.data);
      getLocationtypeZone(false);
      update();
    }
  }



///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo Create Location Form
///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo Location List Work

  LocationListModel? locationListModel;
  RxBool getLocationLoader = false.obs;
  getLocationList() async{
    getLocationLoader(true);
    var response = await Api().get("locations");
    if(response.statusCode == 200){
      locationListModel = LocationListModel.fromJson(response.data);
      getLocationLoader(false);
      update();
    }
  }

///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo Location List Work


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

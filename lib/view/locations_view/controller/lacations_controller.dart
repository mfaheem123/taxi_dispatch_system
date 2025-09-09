


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

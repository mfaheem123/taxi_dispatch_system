import 'package:flutter/cupertino.dart';

class ViaPoint {
  final String address;
  TextEditingController? name  = TextEditingController();
  TextEditingController? mobile = TextEditingController();
  double lat;
  double lng;

  ViaPoint({
    required this.address,
    required this.lat,
    required this.lng,
    this.name,
    this.mobile,
  });
}

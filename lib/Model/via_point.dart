import 'package:flutter/cupertino.dart';

class ViaPoint {
  final String address;
  String? name;
  String? mobile;
  double lat;
  double lng;
  String? markerType;

  ViaPoint({
    required this.address,
    required this.lat,
    required this.lng,
    this.name,
    this.mobile,
    this.markerType,
  });
}


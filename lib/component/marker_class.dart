

import 'package:flutter_map/flutter_map.dart';

class CustomMarker extends Marker {
  final String type;
  String? withReturnType;

  CustomMarker({
    required this.type,
    this.withReturnType,
    required super.point,
    required super.child,
    super.width,
    super.height,
  });
}
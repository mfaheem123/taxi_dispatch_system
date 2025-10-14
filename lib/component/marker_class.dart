

import 'package:flutter_map/flutter_map.dart';

class CustomMarker extends Marker {
  final String type;

  CustomMarker({
    required this.type,
    required super.point,
    required super.child,
    super.width,
    super.height,
  });
}
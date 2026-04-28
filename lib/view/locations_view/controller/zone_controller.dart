



import 'dart:async';
import 'dart:math' as math;

import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/networks/api.dart';
import 'package:dashboard_new1/view/locations_view/Model/locationListModel.dart'
    hide Zone;
import 'package:dashboard_new1/view/locations_view/Model/zoneListModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


// class ZoneControllerA {
//   Zone zone = Zone();

//   void updateBase(bool value) {
//     zone.base = value;
//   }

//   void updateName(String value) {
//     zone.name = value;
//   }

//   void updateShortName(String value) {
//     zone.shortName = value;
//   }

//   void updateType(String value) {
//     zone.type = value;
//   }

//   void updateCategory(String value) {
//     zone.category = value;
//   }

//   void clear() {
//     zone = Zone();
//   }

//   void save() {
//     print(
//       "Zone Saved => ${zone.name}, ${zone.shortName}, ${zone.type}, ${zone.category}, Base: ${zone.base}",
//     );
//   }

// }

enum DrawMode {
  navigate,
  freehand,
  rectangle,
  points,
  edit,
  polygon,
}

enum RectHandle { nw, n, ne, e, se, s, sw, w }

enum RectDragSource { liveDraft, savedRect, none }

class RectBounds {
  double minLat, maxLat, minLng, maxLng;
  RectBounds(this.minLat, this.maxLat, this.minLng, this.maxLng);
}

class ZoneController extends GetxController {
  // ZoneController ke andar
  List<LatLng> activeVertices = [];

  // -------- Text Controllers --------
  final zonenameContoller = TextEditingController();
  final secondarynamezoneController = TextEditingController();
  final searchController = TextEditingController();
  final postcodeController = TextEditingController();

  // -------- Reactive Variables --------
  var categoryValue = 'SELECT CATEGORY'.obs;
  var zoneValue = 'SELECT ZONE TYPE'.obs;
  var isEditing = false.obs;
  var base = false.obs;
  var selectedPolyId = RxnString();
  // var mode = DrawMode.navigate.obs;
  RxList<Marker> editMarkers = <Marker>[].obs;
  RxList<LatLng> pointsDraft = <LatLng>[].obs;
  RxList<LatLng> draft = <LatLng>[].obs;
  Rx<DrawMode> mode = DrawMode.navigate.obs;
  LatLng? rectStart;
  LatLng? rectCurrent;
  final categoryItems = ['SELECT CATEGORY', 'INNER', 'OUTER'];
  final zoneItems = ['SELECT ZONE TYPE', 'MAJOR', 'MINOR'];

  // -------- Google Map Data --------
  // final Completer<GoogleMapController> ctrl = Completer();
  Completer<GoogleMapController> ctrl = Completer();
  GoogleMapController? mapController;
  final mapKey = GlobalKey();
  final polyPoints = <String, List<LatLng>>{}.obs;
  final zoneID = 0.obs;
  List<dynamic>? localZoneData;

  static const initialCamera = CameraPosition(
    target: LatLng(37.7749, -122.4194),
    zoom: 18,
  );

  // -------- Helper Getters --------
  bool get lockMapGestures =>
      mode.value == DrawMode.freehand ||
          mode.value == DrawMode.rectangle ||
          mode.value == DrawMode.points ||
          mode.value == DrawMode.edit;

  // -------- Utility Methods --------
  double _rad(double d) => d * math.pi / 180.0;
  double _hav(double t) => (1 - math.cos(t)) / 2;
  double distanceMeters(LatLng a, LatLng b) {
    const r = 6371000.0;
    final dLat = _rad(b.latitude - a.latitude);
    final dLon = _rad(b.longitude - a.longitude);
    final lat1 = _rad(a.latitude);
    final lat2 = _rad(b.latitude);
    final h = _hav(dLat) + math.cos(lat1) * math.cos(lat2) * _hav(dLon);
    return 2 * r * math.asin(math.min(1, math.sqrt(h)));
  }

  void clearZoneForm() {
    zonenameContoller.clear();
    secondarynamezoneController.clear();
    zoneValue.value = 'SELECT ZONE TYPE';
    categoryValue.value = "SELECT CATEGORY";
    postcodeController.clear();
    base.value = false;
    updateZone.value = false;
    isEditing.value = false;
    draft.clear();
    pointsDraft.clear();
    rectStart = null;
    rectCurrent = null;
    selectedPolyId.value = null;
    editMarkers.clear();
    polyPoints.clear();
    mode.value = DrawMode.navigate;
    update();
  }
  void refreshMapController() {
    ctrl = Completer<GoogleMapController>();
    update();
  }

  List<Map<String, double>> toApiVertices(List<LatLng> pts) {
    return pts
        .map((p) => {"latitude": p.latitude, "longitude": p.longitude})
        .toList();
  }

  List<LatLng>? currentVertices() {
    if (selectedPolyId.value != null) {
      final pts = polyPoints[selectedPolyId.value];
      if (pts != null && pts.length >= 3) return List<LatLng>.from(pts);
    }
    if (mode.value == DrawMode.rectangle &&
        rectStart != null &&
        rectCurrent != null) {
      return rectFromDiagonal(rectStart!, rectCurrent!);
    }
    if (mode.value == DrawMode.freehand && draft.length >= 3) {
      return List<LatLng>.from(draft);
    }
    if (mode.value == DrawMode.points && pointsDraft.length >= 3) {
      return List<LatLng>.from(pointsDraft);
    }
    return null;
  }

  postZone(context) async {
    print("Draw mode: ${mode.value}");
    print("Draft points: ${draft.length}");
    print("Points draft: ${pointsDraft.length}");
    print("Rect start: $rectStart, Rect end: $rectCurrent");

    List<Vertices> vertices = [];
    // Handle polygon/freehand draw
    if (draft.isNotEmpty) {
      vertices = draft
          .map((p) => Vertices(latitude: p.latitude, longitude: p.longitude))
          .toList();
    }
    else if (pointsDraft.isNotEmpty) {
      vertices = pointsDraft
          .map((p) => Vertices(latitude: p.latitude, longitude: p.longitude))
          .toList();
    }
    // Handle rectangle draw
    else if (rectStart != null && rectCurrent != null) {
      vertices = [
        Vertices(
            latitude: rectStart!.latitude, longitude: rectStart!.longitude),
        Vertices(
            latitude: rectStart!.latitude, longitude: rectCurrent!.longitude),
        Vertices(
            latitude: rectCurrent!.latitude, longitude: rectCurrent!.longitude),
        Vertices(
            latitude: rectCurrent!.latitude, longitude: rectStart!.longitude),
      ];
    }

    if (vertices.length < 3) {
      BotToast.showText(text: 'Please draw/select a zone (at least 3 points)');
      return;
    }

    var formData = {
      if (updateZone.value)
        "id": zoneUpdateId.value,
      "name": zonenameContoller.text.trim(),
      "secondary_name": secondarynamezoneController.text.trim(),
      "type": zoneValue.value,
      "category": categoryValue.value,
      "base": base.value,
      "vertices": vertices.map((v) => v.toJson()).toList(),
      "overlay": mode.value == DrawMode.rectangle ? "rectangle" : "polygon",
    };

    final response = await Api().post(
      formData,
      updateZone.value ? 'zones/edit/${zoneUpdateId.value}' : 'zones',
    );

    if (response.statusCode == 200) {
      update();
      clearZoneForm();
      print("FormData saved: ${response.statusCode}");
      print("Zone saved: ${response.data}");
      print("FormData saved: ${formData}");
    } else {
      print(
        "Error saving zone: $response",
      );
    }
  }

  Zone? currentZoneBeingEdited;

  RxBool updateZone = false.obs;
  RxInt zoneUpdateId = 0.obs;

  bindUpdateZone(Set<dynamic> set, {Zone? zoneUpdate}) async {
    if (zoneUpdate == null) return;

    zoneUpdateId.value = zoneUpdate.id ?? 0;
    zonenameContoller.text = (zoneUpdate.name ?? '').toUpperCase();
    secondarynamezoneController.text = (zoneUpdate.secondaryName ?? '').toUpperCase();
    zoneValue.value = zoneUpdate.type ?? 'SELECT ZONE TYPE';
    categoryValue.value = zoneUpdate.category ?? 'SELECT CATEGORY';
    base.value = zoneUpdate.base ?? false;
    //  Clear previous state
    draft.clear();
    pointsDraft.clear();
    rectStart = null;
    rectCurrent = null;
    editMarkers.clear();

    if (zoneUpdate.vertices != null && zoneUpdate.vertices!.isNotEmpty) {
      final loadedVertices = zoneUpdate.vertices!
          .map((v) => LatLng(v.latitude!, v.longitude!))
          .toList();

      print("Loaded Vertices: ${loadedVertices.length}");
      for (final v in loadedVertices) {
        print(" → ${v.latitude}, ${v.longitude}");
      }

      // Detect shape
      if (loadedVertices.length == 4 && _isRectangle(loadedVertices)) {
        // rectStart = loadedVertices.first;
        rectStart = loadedVertices[0];
        rectCurrent = loadedVertices[2];
        mode.value = DrawMode.rectangle;
        print(" Detected Rectangle zone for editing");
      } else {
        draft.assignAll(loadedVertices);
        pointsDraft.assignAll(loadedVertices);
        // mode.value = DrawMode.polygon;
        mode.value = DrawMode.edit;
        print(" Detected Polygon zone for editing");
      }

      //  Add markers
      for (int i = 0; i < loadedVertices.length; i++) {
        editMarkers.add(
          Marker(
            markerId: MarkerId("edit_marker_$i"),
            position: loadedVertices[i],
            icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          ),
        );
      }
    } else {
      print(" No vertices found for this zone");
    }

    isEditing.value = true;
    updateZone(true);
    update();
  }

  /// ====== RECTANGLE DETECTION ======
  bool _isRectangle(List<LatLng> pts) {
    if (pts.length != 4) return false;
    final lats = pts.map((e) => e.latitude).toSet();
    final lngs = pts.map((e) => e.longitude).toSet();
    return lats.length == 2 && lngs.length == 2;
  }

  List<LatLng> rectFromDiagonal(LatLng a, LatLng b) {
    final minLat = math.min(a.latitude, b.latitude);
    final maxLat = math.max(a.latitude, b.latitude);
    final minLng = math.min(a.longitude, b.longitude);
    final maxLng = math.max(a.longitude, b.longitude);
    return [
      LatLng(minLat, minLng),
      LatLng(minLat, maxLng),
      LatLng(maxLat, maxLng),
      LatLng(maxLat, minLng),
    ];
  }

  void changeMode(DrawMode m) {
    mode.value = m;
    draft.clear();
    pointsDraft.clear();
    rectStart = null;
    rectCurrent = null;
    if (mode.value != DrawMode.edit && mode.value != DrawMode.rectangle) {
      selectedPolyId.value = null;
    }
  }




}
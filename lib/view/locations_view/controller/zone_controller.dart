import 'package:dashboard_new1/component/networks/api.dart';
import 'package:dashboard_new1/view/locations_view/Model/locationListModel.dart'
    hide Zone;
import 'package:dashboard_new1/view/locations_view/Model/zoneListModel.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD

import '../../../Model/zone_model.dart' hide Zone;
=======
import '../../../Model/zone_model.dart';
>>>>>>> 37148c98a40a96dd171d0675b31ec9740800fcff
import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:html' as html;
import 'package:dashboard_new1/component/app_promts.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
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

enum DrawMode { navigate, freehand, rectangle, points, edit }

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
  var categoryValue = 'Select Category'.obs;
  var zoneValue = 'Select Zone Type'.obs;
  var isEditing = false.obs;
  var base = false.obs;
  var selectedPolyId = RxnString();
  var mode = DrawMode.navigate.obs;

  final categoryItems = ['Select Category', 'Inner', 'Outer'];
  final zoneItems = ['Select Zone Type', 'Major', 'Minor'];

  // -------- Google Map Data --------
  final Completer<GoogleMapController> ctrl = Completer();
  GoogleMapController? mapController;
  final mapKey = GlobalKey();

  final draft = <LatLng>[].obs;
  final pointsDraft = <LatLng>[].obs;
  final polyPoints = <String, List<LatLng>>{}.obs;
  LatLng? rectStart;
  LatLng? rectCurrent;

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
    zoneValue.value = 'Select Value';
    categoryValue.value = "Select category";
    draft.clear();
    pointsDraft.clear();
    rectStart = null;
    rectCurrent = null;
    mode.value = DrawMode.navigate;
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

  //  List<LatLng>? _currentVertices() {
  //   // Selected saved polygon
  //   if (selectedPolyId.value != null) {
  //     final pts = polyPoints[selectedPolyId!];
  //     if (pts != null && pts.length >= 3) return List<LatLng>.from(pts);
  //   }

  //   // Live rectangle draft
  //   if (mode == DrawMode.rectangle &&
  //       rectStart != null &&
  //       rectCurrent != null) {
  //     return rectFromDiagonal(rectStart!, rectCurrent!);
  //   }

  //   // Live freehand draft
  //   if (mode == DrawMode.freehand && draft.length >= 3) {
  //     return List<LatLng>.from(draft);
  //   }

  //   // Live points draft
  //   if (mode == DrawMode.points && pointsDraft.length >= 3) {
  //     return List<LatLng>.from(pointsDraft);
  //   }

  //   return null;
  // }

  // void submitForm(BuildContext context) {
  //   final pts = currentVertices();
  //   if (pts == null || pts.length < 3) {
  //     Prompts().showErrorMessage(
  //       msg: "Please draw/select a zone first (need at least 3 points).",
  //       context: context,
  //     );
  //     return;
  //   }
  //   if (isEditing.value) {
  //     postZone(context);
  //   } else {
  //     postZone(context);
  //   }
  // }

///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  // void bindZoneUpdate({required dynamic zoneUpdate}) {
  //   isEditing.value = true; // Edit mode ON
  //   zoneID.value = zoneUpdate['id']; // Zone ID set karo

  //   // Text fields fill karo
  //   zonenameContoller.text = zoneUpdate['name'] ?? '';
  //   secondarynamezoneController.text = zoneUpdate['secondary_name'] ?? '';
  //   zoneValue.value = zoneUpdate['type'] ?? 'Select Zone Type';
  //   categoryValue.value = zoneUpdate['category'] ?? 'Select Category';
  //   base.value = zoneUpdate['base'] ?? false;

  //   // Agar map points hain to wo bhi load kar lo
  //   if (zoneUpdate['vertices'] != null) {
  //     List vertices = zoneUpdate['vertices'];
  //     polyPoints['editedZone'] =
  //         vertices.map((v) => LatLng(v['latitude'], v['longitude'])).toList();
  //     selectedPolyId.value = 'editedZone';
  //   }

  //   update();
  // }

  // Future<void> registerZoneForm(BuildContext context) async {
  //   final pts = currentVertices();
  //   if (pts == null || pts.length < 3) {
  //     Prompts().showErrorMessage(
  //       msg: "Please draw/select a zone (at least 3 points) before saving.",
  //       context: context,
  //     );
  //     return;
  //   }

  //   final vertices = toApiVertices(pts);

  //   const url = "http://192.168.110.4:5000/api/zones";
  //   final data = {};

  //   try {
  //     final res = await http.post(Uri.parse(url),
  //         body: json.encode(data),
  //         headers: {"Content-Type": "application/json"});
  //     if (res.statusCode >= 200 && res.statusCode < 300) {
  //       Prompts().showToastMessage(
  //           msg: "Zone saved successfully!", context: context);
  //       clearTextFields();
  //     } else {
  //       Prompts().showErrorMessage(
  //         msg: "Save failed (${res.statusCode}): ${res.body}",
  //         context: context,
  //       );
  //     }
  //   } catch (e) {
  //     Prompts().showErrorMessage(msg: "Network error: $e", context: context);
  //   }
  // }

  // void submitForm(BuildContext context) {
  //   // final pts = currentVertices();
  //   // if (pts == null || pts.length < 3) {
  //   //   Prompts().showErrorMessage(
  //   //     msg: "Please draw/select a zone first (need at least 3 points).",
  //   //     context: context,
  //   //   );
  //   //   return;
  //   // }
  //   if (isEditing.value) {
  //     updateZoneOld(context);
  //   } else {
  //     registerZoneForm(context);
  //   }
  // }

  // Future<void> registerZoneForm(BuildContext context) async {
  //   final pts = currentVertices();
  //   if (pts == null || pts.length < 3) {
  //     Prompts().showErrorMessage(
  //       msg: "Please draw/select a zone (at least 3 points) before saving.",
  //       context: context,
  //     );
  //     return;
  //   }
  //   final vertices = toApiVertices(pts);
  //   const url = "http://192.168.110.4:5000/api/zones";
  //   final data = {
  //     "name": zonenameContoller.text.trim(),
  //     "secondary_name": secondarynamezoneController.text.trim(),
  //     "type": zoneValue.value,
  //     "category": categoryValue.value,
  //     "base": false,
  //     "vertices": vertices,
  //     "overlay": "rectangle",
  //   };
  //   try {
  //     final res = await http.post(Uri.parse(url),
  //         body: json.encode(data),
  //         headers: {"Content-Type": "application/json"});
  //     if (res.statusCode >= 200 && res.statusCode < 300) {
  //       Prompts().showToastMessage(
  //           msg: "Zone saved successfully!", context: context);
  //       clearTextFields();
  //     } else {
  //       Prompts().showErrorMessage(
  //         msg: "Save failed (${res.statusCode}): ${res.body}",
  //         context: context,
  //       );
  //     }
  //   } catch (e) {
  //     Prompts().showErrorMessage(msg: "Network error: $e", context: context);
  //   }
  // }

  // Future<void> updateZoneOld(BuildContext context) async {
  //   final pts = currentVertices();
  //   if (pts == null || pts.length < 3) {
  //     Prompts().showErrorMessage(
  //       msg: "Please draw/select a zone (at least 3 points) before updating.",
  //       context: context,
  //     );
  //     return;
  //   }
  //   final vertices = toApiVertices(pts);
  //   final url = "http://192.168.110.4:5000/api/zones/edit/${zoneID.value}";
  //   final storedUserId = html.window.localStorage['key'];
  //   final data = {
  //     "userId": storedUserId,
  //     "name": zonenameContoller.text.trim(),
  //     "secondaryName": secondarynamezoneController.text.trim(),
  //     "type": zoneValue.value,
  //     "category": categoryValue.value,
  //     "base": base.value,
  //     "vertices": vertices,
  //   };
  //   try {
  //     final res = await http.put(Uri.parse(url),
  //         body: json.encode(data),
  //         headers: {"Content-Type": "application/json"});
  //     if (res.statusCode == 200) {
  //       clearTextFields();
  //       localZoneData = null;
  //       isEditing.value = false;
  //       Prompts().showToastMessage(
  //         msg: "Zone updated successfully",
  //         context: context,
  //       );
  //     } else {
  //       clearTextFields();
  //       Prompts().showErrorMessage(
  //         msg: "Error updating zone (${res.statusCode}): ${res.body}",
  //         context: context,
  //       );
  //     }
  //   } catch (e) {
  //     clearTextFields();
  //     Prompts().showErrorMessage(msg: "Network error: $e", context: context);
  //   }
  // }

 postZone(context) async {
    print("=== DEBUG: Zone Save Attempt ===");
    print("Draw mode: ${mode.value}");
    print("Draft points: ${draft.length}");
    print("Points draft: ${pointsDraft.length}");
    print("Rect start: $rectStart, Rect end: $rectCurrent");
    print("===============================");
    List<Vertices> vertices = [];

    // Handle polygon/freehand draw
    if (draft.isNotEmpty) {
      vertices = draft
          .map((p) => Vertices(latitude: p.latitude, longitude: p.longitude))
          .toList();
    } 
    // Handle rectangle draw
    else if (rectStart != null && rectCurrent != null) {
      vertices = [
        Vertices(latitude: rectStart!.latitude, longitude: rectStart!.longitude),
        Vertices(latitude: rectStart!.latitude, longitude: rectCurrent!.longitude),
        Vertices(latitude: rectCurrent!.latitude, longitude: rectCurrent!.longitude),
        Vertices(latitude: rectCurrent!.latitude, longitude: rectStart!.longitude),
      ];
    }

    if (vertices.length < 3) {
      Get.snackbar('Error', 'Please draw/select a zone (at least 3 points)');
      return;
    }


  var formData = {
    "name": zonenameContoller.text.trim(),
    "secondary_name": secondarynamezoneController.text.trim(),
    "type": zoneValue.value,
    "category": categoryValue.value,
    "base": base.value,
    "vertices": vertices.map((v) => v.toJson()).toList(), // <-- send lat/lng here
    "overlay": "rectangle", // or whatever type
  };

  final response = await Api().post(
    formData,
    updateZone.value ? 'zones/edit' : 'zones',
    auth: true,
  );

  if (response.statusCode == 200) {

    clearZoneForm();
    update();
    print("Zone saved: ${response}");
    print("FormData saved: ${formData}");

  } else {
    print("Error saving zone: $response", );
  }
}

  RxBool updateZone = false.obs;
  RxInt zoneUpdateId = 0.obs;
  bindUpdateZone(Set<dynamic> set, {Zone? zoneUpdate}) async {
    if (zoneUpdate == null) return;

    // 1️⃣ Set basic zone info
    zoneUpdateId.value = zoneUpdate.id!;
    zonenameContoller.text = zoneUpdate.name ?? '';
    secondarynamezoneController.text = zoneUpdate.secondaryName ?? '';
    zoneValue.value = zoneUpdate.type ?? 'Select Zone Type';
    categoryValue.value = zoneUpdate.category ?? 'Select Category';
    base.value = zoneUpdate.base ?? false;

    // 2️⃣ Convert server vertices to LatLng
    if (zoneUpdate.vertices != null && zoneUpdate.vertices!.isNotEmpty) {
      final pts = zoneUpdate.vertices!
          .map((v) => LatLng(v.latitude ?? 0, v.longitude ?? 0))
          .toList();

      // 3️⃣ Set controller map points
      activeVertices = pts;
      pointsDraft.clear();
      draft.clear();
      rectStart = null;
      rectCurrent = null;

      // Optional: polyPoints for edit mode
      polyPoints['editZone'] = pts;
      selectedPolyId.value = 'editZone';

      // 4️⃣ Move map camera safely (Flutter Web safe)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mapController != null) {
          final bounds = LatLngBounds(
            southwest: LatLng(
              pts.map((p) => p.latitude).reduce(math.min),
              pts.map((p) => p.longitude).reduce(math.min),
            ),
            northeast: LatLng(
              pts.map((p) => p.latitude).reduce(math.max),
              pts.map((p) => p.longitude).reduce(math.max),
            ),
          );
          mapController!
              .animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
        }
      });
    }

    // 5️⃣ Notify UI
    isEditing.value = true;
    updateZone(true);
  }

  ///---------------------------------------------------------------------------------------------- Update

  // Future<void> updateZone(BuildContext context) async {
  //   final pts = currentVertices();
  //   if (pts == null || pts.length < 3) {
  //     Prompts().showErrorMessage(
  //       msg: "Please draw/select a zone (at least 3 points) before updating.",
  //       context: context,
  //     );
  //     return;
  //   }
  //   final vertices = toApiVertices(pts);
  //   final url = "http://192.168.110.4:5000/api/zones/edit/${zoneID}";
  //   final storedUserId = html.window.localStorage['key'];
  //   final data = {
  //     "userId": storedUserId,
  //     "name": zonenameContoller.text.trim(),
  //     "secondaryName": secondarynamezoneController.text.trim(),
  //     "type": zoneValue.value,
  //     "category": categoryValue.value,
  //     "base": base.value,
  //     "vertices": vertices,
  //   };
  //   try {
  //     final res = await http.put(Uri.parse(url),
  //         body: json.encode(data),
  //         headers: {"Content-Type": "application/json"});
  //     if (res.statusCode == 200) {
  //       clearTextFields();
  //       localZoneData = null;
  //       isEditing.value = false;
  //       Prompts().showToastMessage(
  //         msg: "Zone updated successfully",
  //         context: context,
  //       );
  //     } else {
  //       clearTextFields();
  //       Prompts().showErrorMessage(
  //         msg: "Error updating zone (${res.statusCode}): ${res.body}",
  //         context: context,
  //       );
  //     }
  //   } catch (e) {
  //     clearTextFields();
  //     Prompts().showErrorMessage(msg: "Network error: $e", context: context);
  //   }
  // }

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

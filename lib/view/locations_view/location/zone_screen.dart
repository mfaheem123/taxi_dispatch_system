import 'dart:async' show Completer;
import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui' as html hide window;
import 'dart:html' as html;
import 'package:dashboard_new1/component/app_promts.dart';
import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/oldDropDown.dart';
import 'package:dashboard_new1/view/locations_view/controller/zone_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

enum DrawMode { navigate, freehand, rectangle, points, edit }

enum RectHandle { nw, n, ne, e, se, s, sw, w }

enum _RectDragSource { liveDraft, savedRect, none }

class _RectBounds {
  double minLat, maxLat, minLng, maxLng;
  _RectBounds(this.minLat, this.maxLat, this.minLng, this.maxLng);
}

_RectBounds _boundsFromTwo(LatLng a, LatLng b) {
  return _RectBounds(
    math.min(a.latitude, b.latitude),
    math.max(a.latitude, b.latitude),
    math.min(a.longitude, b.longitude),
    math.max(a.longitude, b.longitude),
  );
}

Map<RectHandle, LatLng> _handlePositions(_RectBounds b) {
  final midLat = (b.minLat + b.maxLat) / 2;
  final midLng = (b.minLng + b.maxLng) / 2;
  return {
    RectHandle.nw: LatLng(b.maxLat, b.minLng),
    RectHandle.n: LatLng(b.maxLat, midLng),
    RectHandle.ne: LatLng(b.maxLat, b.maxLng),
    RectHandle.e: LatLng(midLat, b.maxLng),
    RectHandle.se: LatLng(b.minLat, b.maxLng),
    RectHandle.s: LatLng(b.minLat, midLng),
    RectHandle.sw: LatLng(b.minLat, b.minLng),
    RectHandle.w: LatLng(midLat, b.minLng),
  };
}

class ZoneScreen extends StatefulWidget {
  @override
  State<ZoneScreen> createState() => _ZoneScreenState();
}

class _ZoneScreenState extends State<ZoneScreen> {
  ZoneController controller = Get.isRegistered<ZoneController>()
      ? Get.find<ZoneController>()
      : Get.put(ZoneController());

  // TextEditingController zonenameContoller = TextEditingController();
  // TextEditingController secondarynamezoneController = TextEditingController();
  // TextEditingController searchController = TextEditingController();
  // final TextEditingController _postcodeController = TextEditingController();
  // GoogleMapController? _mapController;
  // String categoryValue = 'Select Category';
  // var categoryItems = ['Select Category', 'Inner', 'Outer'];
  // String zoneValue = 'Select Zone Type';
  // var zoneItems = ['Select Zone Type', 'Major', 'Minor'];
  // LatLng? _rectStart; // live rectangle start
  // LatLng? _rectCurrent;
  // final VoidCallback? onUpdateComplete;
  // bool base = false;
  // final List<LatLng> _draft = [];
  // final List<LatLng> _pointsDraft = [];
  // final Completer<GoogleMapController> _ctrl = Completer();
  // final GlobalKey _mapKey = GlobalKey();

  String zoneID = "";
  static const _initialCamera = CameraPosition(
    target: LatLng(37.7749, -122.4194),
    zoom: 18,
  );
  DrawMode mode = DrawMode.navigate;
  bool get _lockMapGestures =>
      mode == DrawMode.freehand ||
      mode == DrawMode.rectangle ||
      mode == DrawMode.points ||
      mode == DrawMode.edit;

  final Map<String, List<LatLng>> _polyPoints = {};
  _RectDragSource _activeDragSource = _RectDragSource.none;
  RectHandle? _activeHandle; // which edge/corner is being dragged
  bool _draggingCenter = false; // moving whole rect?
  _RectBounds? _activeStartBounds;
  List<dynamic>? localZoneData;
  String? _selectedPolyId;
  // double _rad(double d) => d * math.pi / 180.0;
  // double _hav(double t) => (1 - math.cos(t)) / 2;

  // double _distanceMeters(LatLng a, LatLng b) {
  //   const r = 6371000.0;
  //   final dLat = _rad(b.latitude - a.latitude);
  //   final dLon = _rad(b.longitude - a.longitude);
  //   final lat1 = _rad(a.latitude);
  //   final lat2 = _rad(b.latitude);
  //   final h = _hav(dLat) + math.cos(lat1) * math.cos(lat2) * _hav(dLon);
  //   return 2 * r * math.asin(math.min(1, math.sqrt(h)));
  // }

  void _cancelActiveRectDrag() {
    _activeDragSource = _RectDragSource.none;
    _activeHandle = null;
    _draggingCenter = false;
    _activeStartBounds = null;
  }

  void _onPanEnd() {
    _isDragging = false;
    _cancelActiveRectDrag();
    setState(() {});
  }

  // List<LatLng>? _currentVertices() {
  //   // Selected saved polygon
  //   if (_selectedPolyId != null) {
  //     final pts = _polyPoints[_selectedPolyId!];
  //     if (pts != null && pts.length >= 3) return List<LatLng>.from(pts);
  //   }

  //   // Live rectangle draft
  //   if (mode == DrawMode.rectangle &&
  //       _rectStart != null &&
  //       _rectCurrent != null) {
  //     return _rectFromDiagonal(_rectStart!, _rectCurrent!);
  //   }

  //   // Live freehand draft
  //   if (mode == DrawMode.freehand && _draft.length >= 3) {
  //     return List<LatLng>.from(_draft);
  //   }

  //   // Live points draft
  //   if (mode == DrawMode.points && _pointsDraft.length >= 3) {
  //     return List<LatLng>.from(_pointsDraft);
  //   }

  //   return null;
  // }

  // bool isEditing = false;

  // void submitForm() {
  //   final pts = _currentVertices();
  //   if (pts == null || pts.length < 3) {
  //     Prompts().showErrorMessage(
  //       msg: "Please draw/select a zone first (need at least 3 points).",
  //       context: context,
  //     );
  //     return;
  //   }
  //   if (isEditing) {
  //    controller.updateZone(context);
  //   } else {
  //     registerzoneForm();
  //   }
  // }

  // clearTextFields() {
  //   if (mounted) {
  //     setState(() {
  //       zonenameContoller.clear();
  //       secondarynamezoneController.clear();
  //       searchController.clear();
  //       zoneValue = 'Select Zone Type';
  //       categoryValue = 'Select Category';
  //       // base = false;
  //     });
  //   }
  // }

  registerzoneForm() {
    controller.registerZoneForm(context);
    controller.clearTextFields();
    Prompts().showToastMessage(msg: "Data posted Succesfully!", context: context);
  }

  // List<Map<String, double>> toApiVertices(List<LatLng> pts) {
  //   return pts
  //       .map((p) => {"latitude": p.latitude, "longitude": p.longitude})
  //       .toList();
  // }

  void _onPanUpdate(Offset global) async {
    if (!_isDragging) return;
    final p = await _screenToLatLng(global);
    if (p == null) return;

    if (mode == DrawMode.freehand) {
      if (controller.draft.isEmpty || controller.distanceMeters(controller.draft.last, p) > 3) {
        setState(() => controller.draft.add(p));
      }
      return;
    }

    if (mode == DrawMode.rectangle) {
      // Handle live grip drag (unsaved)
      if (_activeDragSource == _RectDragSource.liveDraft &&
          _activeStartBounds != null) {
        final b0 = _activeStartBounds!;
        if (_draggingCenter) {
          final center0 = _boundsCenter(b0);
          final dLat = p.latitude - center0.latitude;
          final dLng = p.longitude - center0.longitude;
          final moved = _translateBounds(b0, dLat, dLng);
          setState(() {
            controller.rectStart = LatLng(moved.minLat, moved.minLng);
            controller.rectCurrent = LatLng(moved.maxLat, moved.maxLng);
          });
        } else if (_activeHandle != null) {
          final nb = _boundsWithDraggedHandle(b0, _activeHandle!, p);
          setState(() {
            controller.rectStart = LatLng(nb.minLat, nb.minLng);
            controller.rectCurrent = LatLng(nb.maxLat, nb.maxLng);
          });
        }
        return;
      }

      // Handle saved rect grip drag
      if (_activeDragSource == _RectDragSource.savedRect &&
          _activeStartBounds != null &&
          _selectedPolyId != null) {
        final b0 = _activeStartBounds!;
        if (_draggingCenter) {
          final center0 = _boundsCenter(b0);
          final dLat = p.latitude - center0.latitude;
          final dLng = p.longitude - center0.longitude;
          final moved = _translateBounds(b0, dLat, dLng);
          setState(() => _polyPoints[_selectedPolyId!] = _ptsFromBounds(moved));
        } else if (_activeHandle != null) {
          final nb = _boundsWithDraggedHandle(b0, _activeHandle!, p);
          setState(() => _polyPoints[_selectedPolyId!] = _ptsFromBounds(nb));
        }
        return;
      }

      // If not dragging grips, update live draft corners while drawing
      if ( controller.rectStart != null &&
          controller.rectCurrent != null &&
          _selectedPolyId == null) {
        setState(() => controller.rectCurrent = p);
      }
    }
  }

  Widget _modeButton(DrawMode m, IconData icon, String tip) {
    final active = mode == m;
    return IconButton(
      tooltip: tip,
      icon: Icon(icon,
          color: active ? Theme.of(context).colorScheme.primary : null),
      onPressed: () => setState(() {
        mode = m;
        controller.draft.clear();
        controller.rectStart = null;
        controller.rectCurrent = null;
        controller.pointsDraft.clear();
        if (mode != DrawMode.edit && mode != DrawMode.rectangle) {
          _selectedPolyId = null;
        }
        _cancelActiveRectDrag();
      }),
    );
  }

  Future<void> _goToPostcode(String postcode) async {
    if (postcode.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a postcode")),
      );
      return;
    }
    try {
      final controllers = await controller.ctrl.future;
      final url = "https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(postcode)}&format=json&limit=1";
      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        final lat = double.parse(data[0]['lat']);
        final lng = double.parse(data[0]['lon']);
        final target = LatLng(lat, lng);
        await controllers.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: target, zoom: 16),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No location found for '$postcode'")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  Future<({RectHandle? handle, bool isCenter})?> _nearestRectGripAt(
      Offset global, _RectBounds b,
      {int thresholdPx = 28}) async {
    double best = double.infinity;
    RectHandle? bestHandle;
    bool bestIsCenter = false;

    Future<Offset?> _latLngToScreen(LatLng latLng) async {
      final ctrl = await controller.ctrl.future;
      final renderBox =
          controller.mapKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox == null || !renderBox.hasSize) return null;
      final origin = renderBox.localToGlobal(Offset.zero);
      try {
        final sc = await ctrl.getScreenCoordinate(latLng);
        return Offset(sc.x.toDouble(), sc.y.toDouble()) + origin;
      } catch (_) {
        return null;
      }
    }

    // Handles
    final hp = _handlePositions(b);
    for (final e in hp.entries) {
      final pt = await _latLngToScreen(e.value);
      if (pt == null) continue;
      final d = (pt - global).distance;
      if (d < best) {
        best = d;
        bestHandle = e.key;
        bestIsCenter = false;
      }
    }
    // Center
    final center = await _latLngToScreen(_boundsCenter(b));
    if (center != null) {
      final d = (center - global).distance;
      if (d < best) {
        best = d;
        bestHandle = null;
        bestIsCenter = true;
      }
    }

    if (best <= thresholdPx) {
      return (handle: bestHandle, isCenter: bestIsCenter);
    }
    return null;
  }

  List<LatLng> _ptsFromBounds(_RectBounds b) => <LatLng>[
        LatLng(b.minLat, b.minLng), // SW
        LatLng(b.minLat, b.maxLng), // SE
        LatLng(b.maxLat, b.maxLng), // NE
        LatLng(b.maxLat, b.minLng), // NW
      ];
  bool _isDragging = false;
  Future<LatLng?> _screenToLatLng(Offset global) async {
    final ctrl = await controller.ctrl.future;
    final renderBox = controller.mapKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return null;
    final origin = renderBox.localToGlobal(Offset.zero);
    final local = global - origin;
    final sc = ScreenCoordinate(x: local.dx.round(), y: local.dy.round());
    try {
      return await ctrl.getLatLng(sc);
    } catch (_) {
      return null;
    }
  }

  void _onPanStart(Offset global) async {
    _isDragging = true;
    final p = await _screenToLatLng(global);
    if (p == null) return;

    if (mode == DrawMode.freehand) {
      setState(() {
        controller.draft
          ..clear()
          ..add(p);
      });
      return;
    }

    if (mode == DrawMode.rectangle) {
      // 1) Try to pick grips on a saved selected rectangle first.
      if (_selectedPolyId != null) {
        final pts = _polyPoints[_selectedPolyId!];
        if (pts != null && _isAxisAlignedRect(pts)) {
          final b = _boundsFromPts(pts);
          final hit = await _nearestRectGripAt(global, b);
          if (hit != null) {
            setState(() {
              _activeDragSource = _RectDragSource.savedRect;
              _activeStartBounds = b;
              _draggingCenter = hit.isCenter;
              _activeHandle = hit.handle;
            });
            return;
          }
        }
      }

      // 2) Else try live rectangle’s grips (unsaved)
      if (controller.rectStart != null && controller.rectCurrent != null) {
        final b = _boundsFromTwo(controller.rectStart!, controller.rectCurrent!);
        final hit = await _nearestRectGripAt(global, b);
        if (hit != null) {
          setState(() {
            _activeDragSource = _RectDragSource.liveDraft;
            _activeStartBounds = b;
            _draggingCenter = hit.isCenter;
            _activeHandle = hit.handle;
          });
          return;
        }
      }

      // 3) If we didn’t hit any grip and no live rect, start a brand-new draft
      setState(() {
        if (_selectedPolyId == null) {
          controller.rectStart = p;
          controller.rectCurrent = p;
          _cancelActiveRectDrag();
        }
      });
    }
  }

  _RectBounds _boundsFromPts(List<LatLng> pts) {
    double minLat = double.infinity, maxLat = -double.infinity;
    double minLng = double.infinity, maxLng = -double.infinity;
    for (final p in pts) {
      minLat = math.min(minLat, p.latitude);
      maxLat = math.max(maxLat, p.latitude);
      minLng = math.min(minLng, p.longitude);
      maxLng = math.max(maxLng, p.longitude);
    }
    return _RectBounds(minLat, maxLat, minLng, maxLng);
  }

  List<LatLng> _rectFromDiagonal(LatLng a, LatLng b) {
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

  _RectBounds _boundsWithDraggedHandle(
      _RectBounds b, RectHandle h, LatLng newPos) {
    var minLat = b.minLat,
        maxLat = b.maxLat,
        minLng = b.minLng,
        maxLng = b.maxLng;
    switch (h) {
      case RectHandle.nw:
        maxLat = newPos.latitude;
        minLng = newPos.longitude;
        break;
      case RectHandle.n:
        maxLat = newPos.latitude;
        break;
      case RectHandle.ne:
        maxLat = newPos.latitude;
        maxLng = newPos.longitude;
        break;
      case RectHandle.e:
        maxLng = newPos.longitude;
        break;
      case RectHandle.se:
        minLat = newPos.latitude;
        maxLng = newPos.longitude;
        break;
      case RectHandle.s:
        minLat = newPos.latitude;
        break;
      case RectHandle.sw:
        minLat = newPos.latitude;
        minLng = newPos.longitude;
        break;
      case RectHandle.w:
        minLng = newPos.longitude;
        break;
    }
    final nMinLat = math.min(minLat, maxLat);
    final nMaxLat = math.max(minLat, maxLat);
    final nMinLng = math.min(minLng, maxLng);
    final nMaxLng = math.max(minLng, maxLng);
    return _RectBounds(nMinLat, nMaxLat, nMinLng, nMaxLng);
  }

  _RectBounds _translateBounds(_RectBounds b, double dLat, double dLng) =>
      _RectBounds(
          b.minLat + dLat, b.maxLat + dLat, b.minLng + dLng, b.maxLng + dLng);
  LatLng _boundsCenter(_RectBounds b) =>
      LatLng((b.minLat + b.maxLat) / 2, (b.minLng + b.maxLng) / 2);

  bool _isAxisAlignedRect(List<LatLng> pts) {
    if (pts.length != 4) return false;
    final b = _boundsFromPts(pts);
    final set = pts
        .map((p) =>
            '${p.latitude.toStringAsFixed(6)},${p.longitude.toStringAsFixed(6)}')
        .toSet();
    final corners = {
      '${b.minLat.toStringAsFixed(6)},${b.minLng.toStringAsFixed(6)}',
      '${b.minLat.toStringAsFixed(6)},${b.maxLng.toStringAsFixed(6)}',
      '${b.maxLat.toStringAsFixed(6)},${b.maxLng.toStringAsFixed(6)}',
      '${b.maxLat.toStringAsFixed(6)},${b.minLng.toStringAsFixed(6)}',
    };
    return set.length == 4 && set.containsAll(corners);
  }

  Set<Polygon> _buildPolygonsForRender() {
    final set = <Polygon>{};

    // Saved polygons
    _polyPoints.forEach((id, pts) {
      set.add(Polygon(
        polygonId: PolygonId(id),
        points: pts,
        strokeWidth: 3,
        strokeColor: id == _selectedPolyId ? Colors.orange : Colors.green,
        fillColor: (id == _selectedPolyId ? Colors.orange : Colors.green)
            .withOpacity(0.18),
        geodesic: true,
        consumeTapEvents: true,
        zIndex: id == _selectedPolyId ? 2 : 1,
        onTap: () {
          // Select a saved rect while in Rectangle or Edit mode
          if (mode == DrawMode.rectangle && _isAxisAlignedRect(pts)) {
            setState(() => _selectedPolyId = id);
          } else if (mode == DrawMode.edit) {
            setState(() => _selectedPolyId = id);
          }
        },
      ));
    });

    // Live freehand preview
    if (mode == DrawMode.freehand && controller.draft.length >= 2) {
      set.add(Polygon(
        polygonId: const PolygonId('live'),
        points: controller.draft,
        strokeWidth: 3,
        strokeColor: Colors.blue,
        fillColor: Colors.blue.withOpacity(0.18),
        geodesic: true,
        zIndex: 3,
      ));
    }

    // Live rectangle preview
    if (mode == DrawMode.rectangle &&
        controller.rectStart != null &&
        controller.rectCurrent != null) {
      final rectPts = _rectFromDiagonal(controller.rectStart!, controller.rectCurrent!);
      set.add(Polygon(
        polygonId: const PolygonId('live_rect'),
        points: rectPts,
        strokeWidth: 3,
        strokeColor: Colors.blue,
        fillColor: Colors.blue.withOpacity(0.18),
        geodesic: true,
        zIndex: 3,
      ));
    }

    // Live points preview
    if (mode == DrawMode.points && controller.pointsDraft.length >= 2) {
      set.add(Polygon(
        polygonId: const PolygonId('live_points'),
        points: controller.pointsDraft,
        strokeWidth: 3,
        strokeColor: Colors.blue,
        fillColor: Colors.blue.withOpacity(0.18),
        geodesic: true,
        zIndex: 3,
      ));
    }

    return set;
  }

  Set<Marker> _buildMarkersForRender() {
    final markers = <Marker>{};

    // Draft dots (Points mode)
    if (mode == DrawMode.points && controller.pointsDraft.isNotEmpty) {
      for (int i = 0; i < controller.pointsDraft.length; i++) {
        final p = controller.pointsDraft[i];
        markers.add(Marker(
          markerId: MarkerId('draft_$i'),
          position: p,
          draggable: true,
          zIndex: 4,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          onDragEnd: (newPos) => setState(() => controller.pointsDraft[i] = newPos),
          onTap: () {
            if (controller.pointsDraft.length > 1) {
              setState(() => controller.pointsDraft.removeAt(i));
            }
          },
        ));
      }
    }

    // Live rectangle handles during drawing
    if (mode == DrawMode.rectangle &&
        controller.rectStart != null &&
        controller.rectCurrent != null) {
      final b = _boundsFromTwo(controller.rectStart!, controller.rectCurrent!);
      final hp = _handlePositions(b);
      for (final entry in hp.entries) {
        final handle = entry.key;
        final pos = entry.value;
        markers.add(Marker(
          markerId: MarkerId('live_rect_${handle.name}'),
          position: pos,
          draggable: true,
          zIndex: 5,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          onDragEnd: (newPos) {
            setState(() {
              final nb = _boundsWithDraggedHandle(b, handle, newPos);
              controller.rectStart = LatLng(nb.minLat, nb.minLng);
              controller.rectCurrent = LatLng(nb.maxLat, nb.maxLng);
            });
          },
        ));
      }
      // Center move handle
      final center = _boundsCenter(b);
      markers.add(Marker(
        markerId: const MarkerId('live_rect_center'),
        position: center,
        draggable: true,
        zIndex: 6,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        onDragEnd: (newCenter) {
          setState(() {
            final dLat = newCenter.latitude - center.latitude;
            final dLng = newCenter.longitude - center.longitude;
            final moved = _translateBounds(b, dLat, dLng);
            controller.rectStart = LatLng(moved.minLat, moved.minLng);
            controller.rectCurrent = LatLng(moved.maxLat, moved.maxLng);
          });
        },
      ));
    }

    // Rectangle-mode grips for saved rectangles (no need to switch to Edit)
    if (mode == DrawMode.rectangle && _selectedPolyId != null) {
      final pts = _polyPoints[_selectedPolyId!];
      if (pts != null && _isAxisAlignedRect(pts)) {
        final b = _boundsFromPts(pts);
        final hp = _handlePositions(b);

        for (final entry in hp.entries) {
          final handle = entry.key;
          final pos = entry.value;
          markers.add(Marker(
            markerId:
                MarkerId('rhdl_rectmode_${_selectedPolyId}_${handle.name}'),
            position: pos,
            draggable: true,
            zIndex: 6,
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueAzure),
            onDragEnd: (newPos) {
              setState(() {
                final nb = _boundsWithDraggedHandle(b, handle, newPos);
                _polyPoints[_selectedPolyId!] = _ptsFromBounds(nb);
              });
            },
          ));
        }

        final center = _boundsCenter(b);
        markers.add(Marker(
          markerId: MarkerId('center_rectmode_$_selectedPolyId'),
          position: center,
          draggable: true,
          zIndex: 7,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          onDragEnd: (newCenter) {
            setState(() {
              final dLat = newCenter.latitude - center.latitude;
              final dLng = newCenter.longitude - center.longitude;
              final moved = _translateBounds(b, dLat, dLng);
              _polyPoints[_selectedPolyId!] = _ptsFromBounds(moved);
            });
          },
        ));
      }
    }

    // Edit mode grips (unchanged)
    if (mode == DrawMode.edit && _selectedPolyId != null) {
      final pts = _polyPoints[_selectedPolyId!];
      if (pts != null && pts.isNotEmpty) {
        if (_isAxisAlignedRect(pts)) {
          final b = _boundsFromPts(pts);
          final hp = _handlePositions(b);
          for (final entry in hp.entries) {
            final handle = entry.key;
            final pos = entry.value;
            markers.add(Marker(
              markerId: MarkerId('rhdl_${_selectedPolyId}_${handle.name}'),
              position: pos,
              draggable: true,
              zIndex: 5,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueAzure),
              onDragEnd: (newPos) {
                setState(() {
                  final nb = _boundsWithDraggedHandle(b, handle, newPos);
                  _polyPoints[_selectedPolyId!] = _ptsFromBounds(nb);
                });
              },
            ));
          }
        } else {
          for (int i = 0; i < pts.length; i++) {
            markers.add(Marker(
              markerId: MarkerId('vh_${_selectedPolyId}_$i'),
              position: pts[i],
              draggable: true,
              zIndex: 4,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueAzure),
              onDragEnd: (newPos) {
                setState(() {
                  final list = List<LatLng>.from(pts);
                  list[i] = newPos;
                  _polyPoints[_selectedPolyId!] = list;
                });
              },
              onTap: () {
                final list = List<LatLng>.from(_polyPoints[_selectedPolyId!]!);
                if (list.length > 3) {
                  setState(() {
                    list.removeAt(i);
                    _polyPoints[_selectedPolyId!] = list;
                  });
                }
              },
            ));
          }
        }
      }
    }

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    final polygons = _buildPolygonsForRender();
    final markers = _buildMarkersForRender();
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Container(
        color: Colors.grey[200],
        child: Row(
          crossAxisAlignment: CrossAxisAlignment
              .stretch, // Ensure all children stretch to full height
          children: [
            // Form Section
            Expanded(
              flex: 1, // More space for form
              child: Container(
                padding: EdgeInsets.all(15),
                color: Colors.white,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),
                    TextField(
                      controller: controller.zonenameContoller,
                      decoration: InputDecoration(
                        labelText: 'NAME',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: controller.secondarynamezoneController,
                      decoration: InputDecoration(
                        labelText: 'SHORT NAME',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),

                    SizedBox(height: 15),

                    CustomDropdown(
                      width: MediaQuery.of(context).size.width * 0.15,
                      items: controller.zoneItems,
                      selecteditem: controller.zoneValue.value,
                      onchanged: (String? newValue) {
                        setState(() {
                          controller.zoneValue.value = newValue!;
                        });
                      },
                    ),

                    CustomDropdown(
                        width: MediaQuery.of(context).size.width * 0.15,
                        items: controller.categoryItems,
                        selecteditem: controller.categoryValue.value,
                        onchanged: (String? newValue) {
                          setState(() {
                            controller.categoryValue.value = newValue!;
                          });
                        }),

                    SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: Text('CLEAR'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red[700],
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),

                        ElevatedButton(
                          onPressed: () {
                            controller.submitForm(context);
                          },
                          child: Text('SAVE'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.green[700],
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Map Placeholder
            Expanded(
              flex: 3, // More space for map
              child: Container(
                  color: DynamicColors.whiteClr,
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.55,
                  child: Stack(children: [
                    RepaintBoundary(
                        key: controller.mapKey,
                        child: GoogleMap(
                          initialCameraPosition: _initialCamera,
                          onMapCreated: (c) => controller.ctrl.complete(c),
                          scrollGesturesEnabled: !_lockMapGestures,
                          zoomGesturesEnabled: !_lockMapGestures,
                          rotateGesturesEnabled: !_lockMapGestures,
                          tiltGesturesEnabled: !_lockMapGestures,
                          polygons: polygons,
                          markers: markers,
                          myLocationButtonEnabled: false,
                          zoomControlsEnabled: false,
                          compassEnabled: false,
                          onTap: (latLng) async {
                            if (mode == DrawMode.points) {
                              setState(() => controller.pointsDraft.add(latLng));
                            } else if (mode == DrawMode.edit) {
                              setState(() => _selectedPolyId = null);
                            }
                          },
                        )),

                    // Gesture layer for drag modes
                    if (mode == DrawMode.freehand || mode == DrawMode.rectangle)
                      Positioned.fill(
                          child: Listener(
                              behavior: HitTestBehavior.opaque,
                              onPointerDown: (e) => _onPanStart(e.position),
                              onPointerMove: (e) => _onPanUpdate(e.position),
                              onPointerUp: (_) => _onPanEnd(),
                              onPointerCancel: (_) => _onPanEnd())),

                    if ((mode == DrawMode.freehand && controller.draft.isNotEmpty) ||
                        (mode == DrawMode.rectangle &&
                            (controller.rectStart != null && controller.rectCurrent != null ||
                                _selectedPolyId != null)) ||
                        (mode == DrawMode.points && controller.pointsDraft.isNotEmpty))
                      Positioned(
                          left: 12,
                          bottom: 16,
                          child: DecoratedBox(
                              decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(8)),
                              child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  child: Text(
                                      "Tip: In Rectangle mode, drag corners/edges or the center to resize/move — even before saving.",
                                      style: TextStyle(color: Colors.white))))),
                    Container(
                        decoration: BoxDecoration(
                            color: DynamicColors.whiteClr,
                            border: Border(
                                top: BorderSide(color: DynamicColors.gryClr),
                                bottom:
                                    BorderSide(color: DynamicColors.gryClr))),
                        height: 45,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // 🔹 Post Code TextField
                            SizedBox(
                              width: 160,
                              child: TextField(
                                controller: controller.postcodeController,
                                decoration: InputDecoration(
                                  labelText: "Post Code",
                                  hintText: "e.g. SW1A 1AA",
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 8),
                                ),
                                onSubmitted: (value) {
                                  if (value.isNotEmpty) {
                                    _goToPostcode(value);
                                  }
                                },
                              ),
                            ),

                            const SizedBox(width: 10),

                            // 🔹 Mode buttons
                            _modeButton(DrawMode.navigate, Icons.pan_tool_alt,
                                "Navigate"),
                            _modeButton(
                                DrawMode.freehand, Icons.gesture, "Freehand"),
                            _modeButton(DrawMode.rectangle, Icons.crop_square,
                                "Rectangle"),
                            _modeButton(
                                DrawMode.points, Icons.more_horiz, "Points"),
                            _modeButton(DrawMode.edit, Icons.edit, "Edit"),
                            IconButton(
                              tooltip: "Clear all",
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => setState(() {
                                controller.draft.clear();
                                controller.rectStart = null;
                                controller.rectCurrent = null;
                                controller.pointsDraft.clear();
                                _polyPoints.clear();
                                _selectedPolyId = null;
                                _cancelActiveRectDrag();
                              }),
                            ),
                          ],
                        )),
                  ])),
            ),
          ],
        ),
      ),
    );
  }
}

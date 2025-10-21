import 'dart:async' show Completer;
import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui' as html;
import 'dart:html' as html;
import 'package:dashboard_new1/component/app_promts.dart';
import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/oldDropDown.dart';
import 'package:flutter/material.dart';
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

  TextEditingController zonenameContoller = TextEditingController();
  TextEditingController secondarynamezoneController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  String categoryValue = 'Select Category';
  var categoryItems = ['Select Category', 'Inner', 'Outer'];
  String zoneValue = 'Select Zone Type';
  var zoneItems = ['Select Zone Type', 'Major', 'Minor'];
  LatLng? _rectStart; // live rectangle start
  LatLng? _rectCurrent;
  final List<LatLng> _draft = [];
  final List<LatLng> _pointsDraft = [];
  final Completer<GoogleMapController> _ctrl = Completer();
  final GlobalKey _mapKey = GlobalKey();
  static const _initialCamera = CameraPosition(
    target: LatLng(37.7749, -122.4194),
    zoom: 12,
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
  String? _selectedPolyId;
  double _rad(double d) => d * math.pi / 180.0;
  double _hav(double t) => (1 - math.cos(t)) / 2;
  double _distanceMeters(LatLng a, LatLng b) {
    const r = 6371000.0;
    final dLat = _rad(b.latitude - a.latitude);
    final dLon = _rad(b.longitude - a.longitude);
    final lat1 = _rad(a.latitude);
    final lat2 = _rad(b.latitude);
    final h = _hav(dLat) + math.cos(lat1) * math.cos(lat2) * _hav(dLon);
    return 2 * r * math.asin(math.min(1, math.sqrt(h)));
  }
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




  List<LatLng>? _currentVertices() {
    // Selected saved polygon
    if (_selectedPolyId != null) {
      final pts = _polyPoints[_selectedPolyId!];
      if (pts != null && pts.length >= 3) return List<LatLng>.from(pts);
    }

    // Live rectangle draft
    if (mode == DrawMode.rectangle &&
        _rectStart != null &&
        _rectCurrent != null) {
      return _rectFromDiagonal(_rectStart!, _rectCurrent!);
    }

    // Live freehand draft
    if (mode == DrawMode.freehand && _draft.length >= 3) {
      return List<LatLng>.from(_draft);
    }

    // Live points draft
    if (mode == DrawMode.points && _pointsDraft.length >= 3) {
      return List<LatLng>.from(_pointsDraft);
    }

    return null;
  }


  bool isEditing = false;

  void submitForm() {
    final pts = _currentVertices();
    if (pts == null || pts.length < 3) {
      Prompts().showErrorMessage(
        msg: "Please draw/select a zone first (need at least 3 points).",
        context: context,
      );
      return;
    }
    if (isEditing) {
      // updateZone();
    } else {
      registerzoneForm();
    }
  }



  clearTextFields() {
    if (mounted) {
      setState(() {
        zonenameContoller.clear();
        secondarynamezoneController.clear();
        searchController.clear();
        zoneValue = 'Select Zone Type';
        categoryValue = 'Select Category';
        // base = false;
      });
    }
  }






  registerzoneForm() {
    registerZoneForm();
    clearTextFields();
    Prompts()
        .showToastMessage(msg: "Data posted Succesfully!", context: context);
  }


  List<Map<String, double>> _toApiVertices(List<LatLng> pts) {
    return pts
        .map((p) => {"latitude": p.latitude, "longitude": p.longitude})
        .toList();
  }


  void registerZoneForm() async {
    // 1) Collect vertices from the current selection/draft
    final pts = _currentVertices();
    if (pts == null || pts.length < 3) {
      Prompts().showErrorMessage(
        msg: "Please draw/select a zone (at least 3 points) before saving.",
        context: context,
      );
      return;
    }

    final vertices = _toApiVertices(pts);

    // 2) Build request body
    const url = "http://192.168.110.4:5000/api/zones";
    // final storedUserId = html.window.localStorage['key'];

    final data = {
      // "userId": storedUserId,
      "name": zonenameContoller.text.trim(),
      "secondary_name": secondarynamezoneController.text.trim(),
      "type": zoneValue, // e.g., "restricted" / "Major" / "Minor" — whatever your UI sets
      "category": categoryValue, // e.g., "security" / "Inner" / "Outer"
      "base": false,
      "vertices": vertices,
      "overlay": "rectangle",
    };

    try {
      final res = await http.post(
        Uri.parse(url),
        body: json.encode(data),
        headers: {"Content-Type": "application/json"},
      );

      if (res.statusCode >= 200 && res.statusCode < 300) {
        print(jsonDecode(res.body));
        Prompts().showToastMessage(
            msg: "Zone saved successfully!", context: context);
        clearTextFields();
        // Optional: keep selection or clear shapes; your call.
        // setState(() { _polyPoints.clear(); _selectedPolyId = null; });
      } else {
        Prompts().showErrorMessage(
          msg: "Save failed (${res.statusCode}): ${res.body}",
          context: context,
        );
      }
    } catch (e) {
      Prompts().showErrorMessage(msg: "Network error: $e", context: context);
    }
  }

  // Future<void> updateZone() async {
  //   final pts = _currentVertices();
  //   if (pts == null || pts.length < 3) {
  //     Prompts().showErrorMessage(
  //       msg: "Please draw/select a zone (at least 3 points) before updating.",
  //       context: context,
  //     );
  //     return;
  //   }
  //
  //   final vertices = _toApiVertices(pts);
  //
  //   final url = "https://nexustechnologys.com:4000/api/zone/updateZone/$zoneID";
  //   final storedUserId = html.window.localStorage['key'];
  //
  //   final data = {
  //     "userId": storedUserId,
  //     "name": zonenameContoller.text.trim(),
  //     "secondaryName": secondarynamezoneController.text.trim(),
  //     "type": zoneValue,
  //     "category": categoryValue,
  //     "base": base,
  //     "vertices": vertices,
  //   };
  //
  //   try {
  //     final res = await http.put(
  //       Uri.parse(url),
  //       body: json.encode(data),
  //       headers: {"Content-Type": "application/json"},
  //     );
  //
  //     if (res.statusCode == 200) {
  //       if (mounted) {
  //         setState(() {
  //           clearTextFields();
  //           localZoneData = null;
  //           isEditing = false;
  //         });
  //       }
  //       widget.onUpdateComplete?.call();
  //
  //       Prompts().showToastMessage(
  //         msg: "Zone updated successfully",
  //         context: context,
  //       );
  //     } else {
  //       if (mounted) clearTextFields();
  //       Prompts().showErrorMessage(
  //         msg: "Error updating zone (${res.statusCode}): ${res.body}",
  //         context: context,
  //       );
  //     }
  //   } catch (e) {
  //     if (mounted) clearTextFields();
  //     Prompts().showErrorMessage(msg: "Network error: $e", context: context);
  //   }
  // }








  void _onPanUpdate(Offset global) async {
    if (!_isDragging) return;
    final p = await _screenToLatLng(global);
    if (p == null) return;

    if (mode == DrawMode.freehand) {
      if (_draft.isEmpty || _distanceMeters(_draft.last, p) > 3) {
        setState(() => _draft.add(p));
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
            _rectStart = LatLng(moved.minLat, moved.minLng);
            _rectCurrent = LatLng(moved.maxLat, moved.maxLng);
          });
        } else if (_activeHandle != null) {
          final nb = _boundsWithDraggedHandle(b0, _activeHandle!, p);
          setState(() {
            _rectStart = LatLng(nb.minLat, nb.minLng);
            _rectCurrent = LatLng(nb.maxLat, nb.maxLng);
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
      if (_rectStart != null &&
          _rectCurrent != null &&
          _selectedPolyId == null) {
        setState(() => _rectCurrent = p);
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
        _draft.clear();
        _rectStart = null;
        _rectCurrent = null;
        _pointsDraft.clear();
        if (mode != DrawMode.edit && mode != DrawMode.rectangle) {
          _selectedPolyId = null;
        }
        _cancelActiveRectDrag();
      }),
    );
  }


  Future<({RectHandle? handle, bool isCenter})?> _nearestRectGripAt(
      Offset global, _RectBounds b,
      {int thresholdPx = 28}) async {
    double best = double.infinity;
    RectHandle? bestHandle;
    bool bestIsCenter = false;

    Future<Offset?> _latLngToScreen(LatLng latLng) async {
      final ctrl = await _ctrl.future;
      final renderBox = _mapKey.currentContext?.findRenderObject() as RenderBox?;
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
    final ctrl = await _ctrl.future;
    final renderBox = _mapKey.currentContext?.findRenderObject() as RenderBox?;
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
        _draft
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
      if (_rectStart != null && _rectCurrent != null) {
        final b = _boundsFromTwo(_rectStart!, _rectCurrent!);
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
          _rectStart = p;
          _rectCurrent = p;
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
    if (mode == DrawMode.freehand && _draft.length >= 2) {
      set.add(Polygon(
        polygonId: const PolygonId('live'),
        points: _draft,
        strokeWidth: 3,
        strokeColor: Colors.blue,
        fillColor: Colors.blue.withOpacity(0.18),
        geodesic: true,
        zIndex: 3,
      ));
    }

    // Live rectangle preview
    if (mode == DrawMode.rectangle &&
        _rectStart != null &&
        _rectCurrent != null) {
      final rectPts = _rectFromDiagonal(_rectStart!, _rectCurrent!);
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
    if (mode == DrawMode.points && _pointsDraft.length >= 2) {
      set.add(Polygon(
        polygonId: const PolygonId('live_points'),
        points: _pointsDraft,
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
    if (mode == DrawMode.points && _pointsDraft.isNotEmpty) {
      for (int i = 0; i < _pointsDraft.length; i++) {
        final p = _pointsDraft[i];
        markers.add(Marker(
          markerId: MarkerId('draft_$i'),
          position: p,
          draggable: true,
          zIndex: 4,
          icon:
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          onDragEnd: (newPos) => setState(() => _pointsDraft[i] = newPos),
          onTap: () {
            if (_pointsDraft.length > 1) {
              setState(() => _pointsDraft.removeAt(i));
            }
          },
        ));
      }
    }

    // Live rectangle handles during drawing
    if (mode == DrawMode.rectangle &&
        _rectStart != null &&
        _rectCurrent != null) {
      final b = _boundsFromTwo(_rectStart!, _rectCurrent!);
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
              _rectStart = LatLng(nb.minLat, nb.minLng);
              _rectCurrent = LatLng(nb.maxLat, nb.maxLng);
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
            _rectStart = LatLng(moved.minLat, moved.minLng);
            _rectCurrent = LatLng(moved.maxLat, moved.maxLng);
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

          crossAxisAlignment: CrossAxisAlignment.stretch, // Ensure all children stretch to full height
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
                      controller: zonenameContoller,
                      decoration: InputDecoration(
                        labelText: 'NAME',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        // ),
                      ),
                    ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                     controller:  secondarynamezoneController,
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
                      items: zoneItems,
                      selecteditem: zoneValue,
                      onchanged: (String? newValue) {
                        setState(() {
                          zoneValue = newValue!;
                        });
                      },
                    ),
                    CustomDropdown(
                        width: MediaQuery.of(context).size.width * 0.15,
                        items: categoryItems,
                        selecteditem: categoryValue,
                        onchanged: (String? newValue) {
                          setState(() {
                            categoryValue = newValue!;
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
                            foregroundColor: Colors.white, backgroundColor: Colors.red[700],
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            submitForm();
                          },
                          child: Text('SAVE'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Colors.green[700],
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
              child:  Container(
                  color:DynamicColors.whiteClr,
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.55,
                  child: Stack(children: [
                    RepaintBoundary(
                        key: _mapKey,
                        child: GoogleMap(
                          initialCameraPosition: _initialCamera,
                          onMapCreated: (c) => _ctrl.complete(c),
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
                              setState(() => _pointsDraft.add(latLng));
                            } else if (mode == DrawMode.edit) {
                              setState(() => _selectedPolyId = null);
                            }
                          },
                        )
                    ),

                    // Gesture layer for drag modes
                    if (mode == DrawMode.freehand ||
                        mode == DrawMode.rectangle)
                      Positioned.fill(
                          child: Listener(
                              behavior: HitTestBehavior.opaque,
                              onPointerDown: (e) =>
                                  _onPanStart(e.position),
                              onPointerMove: (e) =>
                                  _onPanUpdate(e.position),
                              onPointerUp: (_) => _onPanEnd(),
                              onPointerCancel: (_) => _onPanEnd())),

                    if ((mode == DrawMode.freehand &&
                        _draft.isNotEmpty) ||
                        (mode == DrawMode.rectangle &&
                            (_rectStart != null && _rectCurrent != null ||
                                _selectedPolyId != null)) ||
                        (mode == DrawMode.points &&
                            _pointsDraft.isNotEmpty))
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
                                      style: TextStyle(
                                          color: Colors.white))))),
                    Container(
                      decoration: BoxDecoration(
                          color: DynamicColors.whiteClr,
                          border: Border(
                              top: BorderSide(
                                  color: DynamicColors.gryClr),
                              bottom: BorderSide(
                                  color: DynamicColors.gryClr))),
                      height: 45,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _modeButton(DrawMode.navigate,
                                Icons.pan_tool_alt, "Navigate"),
                            _modeButton(DrawMode.freehand, Icons.gesture,
                                "Freehand"),
                            _modeButton(DrawMode.rectangle,
                                Icons.crop_square, "Rectangle"),
                            _modeButton(DrawMode.points, Icons.more_horiz,
                                "Points"),
                            _modeButton(
                                DrawMode.edit, Icons.edit, "Edit"),
                            IconButton(
                                tooltip: "Clear all",
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () => setState(() {
                                  _draft.clear();
                                  _rectStart = null;
                                  _rectCurrent = null;
                                  _pointsDraft.clear();
                                  _polyPoints.clear();
                                  _selectedPolyId = null;
                                  _cancelActiveRectDrag();
                                })),
                          ]),
                    ),
                  ])),
            ),
          ],
        ),
      ),
    );
  }
}
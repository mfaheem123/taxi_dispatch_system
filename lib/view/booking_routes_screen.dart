import 'dart:math' as math;

import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class BookingRouteOption {
  final String id;
  final String title;
  final String pickup;
  final String dropoff;
  final String timeText;
  final String distanceText;
  final String fareText;
  final Color routeColor;
  final List<LatLng> points;
  final bool avoidTolls;
  final double distanceMiles;
  final double durationMinutes;

  const BookingRouteOption({
    required this.id,
    required this.title,
    required this.pickup,
    required this.dropoff,
    required this.timeText,
    required this.distanceText,
    required this.fareText,
    required this.routeColor,
    required this.points,
    this.avoidTolls = false,
    this.distanceMiles = 0,
    this.durationMinutes = 0,
  });
}

class OsmRouteService {
  static final Dio _dio = Dio();

  static const List<Color> _normalPalette = [
    Color(0xFF16A34A),
    Color(0xFFF59E0B),
    Color(0xFFEC4899),
    Color(0xFF2563EB),
  ];

  static const List<Color> _avoidPalette = [
    Color(0xFF06B6D4),
    Color(0xFFEC4899),
    Color(0xFF8B5CF6),
    Color(0xFFEA580C),
  ];

  static Future<({
  List<BookingRouteOption> normal,
  List<BookingRouteOption> avoidHighwayTolls,
  })> fetchRoutes({
    required LatLng pickupLatLng,
    required LatLng dropoffLatLng,
    required String pickupAddress,
    required String dropoffAddress,
    double Function(double miles, double minutes)? fareCalculator,
    String osrmBaseUrl = 'https://router.project-osrm.org',
  }) async {
    final coords =
        '${pickupLatLng.longitude},${pickupLatLng.latitude};${dropoffLatLng.longitude},${dropoffLatLng.latitude}';

    List<BookingRouteOption> normalRoutes = [];
    List<BookingRouteOption> avoidRoutes = [];

    try {
      final res = await _dio.get(
        '$osrmBaseUrl/route/v1/driving/$coords',
        queryParameters: {
          'overview': 'full',
          'geometries': 'geojson',
          'alternatives': 'true',
        },
      );

      final List routesJson = (res.data?['routes'] as List?) ?? [];
      for (int i = 0; i < routesJson.length; i++) {
        final r = routesJson[i] as Map<String, dynamic>;
        final meters = ((r['distance'] as num?) ?? 0).toDouble();
        final seconds = ((r['duration'] as num?) ?? 0).toDouble();
        final miles = meters / 1609.344;
        final mins = seconds / 60.0;

        final List rawCoords =
            ((r['geometry']?['coordinates']) as List?) ?? [];
        final points = rawCoords
            .map((c) => LatLng(
          ((c as List)[1] as num).toDouble(),
          (c[0] as num).toDouble(),
        ))
            .toList();

        final fare = fareCalculator != null
            ? fareCalculator(miles, mins)
            : (miles * 2.015);

        normalRoutes.add(
          BookingRouteOption(
            id: 'normal_${i + 1}',
            title: 'ROUTE #: ${i + 1}',
            pickup: pickupAddress,
            dropoff: dropoffAddress,
            timeText: 'TIME: ${mins.round()} MIN',
            distanceText: 'DISTANCE: ${miles.toStringAsFixed(1)} MI',
            fareText: 'FARES: ${fare.toStringAsFixed(2)}',
            routeColor: _normalPalette[i % _normalPalette.length],
            points: points,
            avoidTolls: false,
            distanceMiles: miles,
            durationMinutes: mins,
          ),
        );
      }

      if (normalRoutes.length > 3) {
        final extras = normalRoutes.sublist(3);
        normalRoutes = normalRoutes.sublist(0, 3);
        avoidRoutes = [
          for (int j = 0; j < extras.length; j++)
            BookingRouteOption(
              id: 'avoid_${j + 1}',
              title: 'ROUTE #: ${j + 1}',
              pickup: pickupAddress,
              dropoff: dropoffAddress,
              timeText: extras[j].timeText,
              distanceText: extras[j].distanceText,
              fareText: extras[j].fareText,
              routeColor: _avoidPalette[j % _avoidPalette.length],
              points: extras[j].points,
              avoidTolls: true,
              distanceMiles: extras[j].distanceMiles,
              durationMinutes: extras[j].durationMinutes,
            ),
        ];
      }
    } catch (_) {}

    return (normal: normalRoutes, avoidHighwayTolls: avoidRoutes);
  }
}

// class OsmRouteService {
//   static final Dio _dio = Dio();
//
//   static const List<Color> _normalPalette = [
//     Color(0xFF16A34A), // Green
//     Color(0xFFF59E0B), // Amber
//     Color(0xFFEC4899), // Pink
//     Color(0xFF2563EB), // Blue
//   ];
//
//   static const List<Color> _avoidPalette = [
//     Color(0xFF06B6D4), // Cyan
//     Color(0xFF8B5CF6), // Purple
//     Color(0xFFEA580C), // Orange
//     Color(0xFFEC4899), // Pink
//   ];
//
//   static LatLng _offsetMidpoint(LatLng a, LatLng b, double offsetDeg) {
//     final midLat = (a.latitude + b.latitude) / 2.0;
//     final midLng = (a.longitude + b.longitude) / 2.0;
//     final dLat = b.latitude - a.latitude;
//     final dLng = b.longitude - a.longitude;
//     final len = math.sqrt(dLat * dLat + dLng * dLng);
//     if (len == 0) return LatLng(midLat, midLng);
//
//     final perpLat = -dLng / len;
//     final perpLng = dLat / len;
//     return LatLng(midLat + perpLat * offsetDeg, midLng + perpLng * offsetDeg);
//   }
//
//   static BookingRouteOption _buildOptionFromOsrmJson({
//     required Map<String, dynamic> routeJson,
//     required String id,
//     required String title,
//     required String pickupAddress,
//     required String dropoffAddress,
//     required Color color,
//     required bool avoidTolls,
//     double Function(double miles, double minutes)? fareCalculator,
//   }) {
//     final meters = ((routeJson['distance'] as num?) ?? 0).toDouble();
//     final seconds = ((routeJson['duration'] as num?) ?? 0).toDouble();
//     final miles = meters / 1609.344;
//     final mins = seconds / 60.0;
//
//     final List rawCoords =
//         ((routeJson['geometry']?['coordinates']) as List?) ?? [];
//     final points = rawCoords
//         .map((c) => LatLng(
//       ((c as List)[1] as num).toDouble(),
//       (c[0] as num).toDouble(),
//     ))
//         .toList();
//
//     final fare = fareCalculator != null
//         ? fareCalculator(miles, mins)
//         : (miles * 2.015);
//
//     return BookingRouteOption(
//       id: id,
//       title: title,
//       pickup: pickupAddress,
//       dropoff: dropoffAddress,
//       timeText: 'TIME: ${mins.round()} MIN',
//       distanceText: 'DISTANCE: ${miles.toStringAsFixed(1)} MI',
//       fareText: 'FARES: ${fare.toStringAsFixed(2)}',
//       routeColor: color,
//       points: points,
//       avoidTolls: avoidTolls,
//       distanceMiles: miles,
//       durationMinutes: mins,
//     );
//   }
//
//   static Future<BookingRouteOption?> _fetchSingleWaypointRoute({
//     required String osrmBaseUrl,
//     required List<LatLng> waypoints,
//     required String id,
//     required String title,
//     required String pickupAddress,
//     required String dropoffAddress,
//     required Color color,
//     required bool avoidTolls,
//     double Function(double miles, double minutes)? fareCalculator,
//   }) async {
//     if (waypoints.length < 2) return null;
//     final coords = waypoints
//         .map((p) => '${p.longitude},${p.latitude}')
//         .join(';');
//
//     final res = await _dio.get(
//       '$osrmBaseUrl/route/v1/driving/$coords',
//       queryParameters: {
//         'overview': 'full',
//         'geometries': 'geojson',
//         'alternatives': 'false',
//       },
//     );
//
//     final List routesJson = (res.data?['routes'] as List?) ?? [];
//     if (routesJson.isEmpty) return null;
//
//     return _buildOptionFromOsrmJson(
//       routeJson: routesJson.first as Map<String, dynamic>,
//       id: id,
//       title: title,
//       pickupAddress: pickupAddress,
//       dropoffAddress: dropoffAddress,
//       color: color,
//       avoidTolls: avoidTolls,
//       fareCalculator: fareCalculator,
//     );
//   }
//
//   static Future<({
//   List<BookingRouteOption> normal,
//   List<BookingRouteOption> avoidHighwayTolls,
//   })> fetchRoutes({
//     required LatLng pickupLatLng,
//     required LatLng dropoffLatLng,
//     required String pickupAddress,
//     required String dropoffAddress,
//     double Function(double miles, double minutes)? fareCalculator,
//     String osrmBaseUrl = 'https://router.project-osrm.org',
//   }) async {
//     final List<BookingRouteOption> normalRoutes = [];
//     final List<BookingRouteOption> avoidRoutes = [];
//
//     try {
//       // 1. Direct OSRM alternatives for Normal Routes (up to 3)
//       final directCoords =
//           '${pickupLatLng.longitude},${pickupLatLng.latitude};${dropoffLatLng.longitude},${dropoffLatLng.latitude}';
//       final res = await _dio.get(
//         '$osrmBaseUrl/route/v1/driving/$directCoords',
//         queryParameters: {
//           'overview': 'full',
//           'geometries': 'geojson',
//           'alternatives': 'true',
//           // 'exclude': 'motorway,toll',
//         },
//       );
//
//       final List routesJson = (res.data?['routes'] as List?) ?? [];
//       for (int i = 0; i < routesJson.length && normalRoutes.length < 3; i++) {
//         normalRoutes.add(
//           _buildOptionFromOsrmJson(
//             routeJson: routesJson[i] as Map<String, dynamic>,
//             id: 'normal_${normalRoutes.length + 1}',
//             title: 'ROUTE #: ${normalRoutes.length + 1}',
//             pickupAddress: pickupAddress,
//             dropoffAddress: dropoffAddress,
//             color: _normalPalette[normalRoutes.length % _normalPalette.length],
//             avoidTolls: false,
//             fareCalculator: fareCalculator,
//           ),
//         );
//       }
//
//       // Fill Normal Routes up to 3 with mild lateral offsets if OSRM returned fewer
//       const normalFallbackOffsets = [0.015, -0.015, 0.03];
//       int normalOffsetIdx = 0;
//       while (normalRoutes.length < 3 &&
//           normalOffsetIdx < normalFallbackOffsets.length) {
//         final via = _offsetMidpoint(
//           pickupLatLng,
//           dropoffLatLng,
//           normalFallbackOffsets[normalOffsetIdx++],
//         );
//         final alt = await _fetchSingleWaypointRoute(
//           osrmBaseUrl: osrmBaseUrl,
//           waypoints: [pickupLatLng, via, dropoffLatLng],
//           id: 'normal_${normalRoutes.length + 1}',
//           title: 'ROUTE #: ${normalRoutes.length + 1}',
//           pickupAddress: pickupAddress,
//           dropoffAddress: dropoffAddress,
//           color: _normalPalette[normalRoutes.length % _normalPalette.length],
//           avoidTolls: false,
//           fareCalculator: fareCalculator,
//         );
//         if (alt != null) {
//           normalRoutes.add(alt);
//         }
//       }
//
//       // 2. Wider lateral offsets for Avoid Highway & Tolls Routes (3 options)
//       const avoidOffsets = [0.055, -0.055, 0.095];
//       for (int j = 0; j < avoidOffsets.length; j++) {
//         final via = _offsetMidpoint(
//           pickupLatLng,
//           dropoffLatLng,
//           avoidOffsets[j],
//         );
//         final alt = await _fetchSingleWaypointRoute(
//           osrmBaseUrl: osrmBaseUrl,
//           waypoints: [pickupLatLng, via, dropoffLatLng],
//           id: 'avoid_${j + 1}',
//           title: 'ROUTE #: ${j + 1}',
//           pickupAddress: pickupAddress,
//           dropoffAddress: dropoffAddress,
//           color: _avoidPalette[j % _avoidPalette.length],
//           avoidTolls: true,
//           fareCalculator: fareCalculator,
//         );
//         if (alt != null) {
//           avoidRoutes.add(alt);
//         }
//       }
//     } catch (_) {}
//
//     return (normal: normalRoutes, avoidHighwayTolls: avoidRoutes);
//   }
// }

class BookingRoutesScreen extends StatefulWidget {
  final List<BookingRouteOption>? normalRoutes;
  final List<BookingRouteOption>? avoidTollsRoutes;
  final LatLng? pickupLatLng;
  final LatLng? dropoffLatLng;
  final String? pickupAddress;
  final String? dropoffAddress;
  final double Function(double miles, double minutes)? fareCalculator;
  final ValueChanged<BookingRouteOption>? onRouteSelected;

  const BookingRoutesScreen({
    super.key,
    this.normalRoutes,
    this.avoidTollsRoutes,
    this.pickupLatLng,
    this.dropoffLatLng,
    this.pickupAddress,
    this.dropoffAddress,
    this.fareCalculator,
    this.onRouteSelected,
  });

  @override
  State<BookingRoutesScreen> createState() => _BookingRoutesScreenState();
}

class _BookingRoutesScreenState extends State<BookingRoutesScreen> {
  final MapController _mapController = MapController();

  List<BookingRouteOption> _normalRoutes = [];
  List<BookingRouteOption> _avoidTollsRoutes = [];

  String? _isolatedRouteId;
  String? _activePopupPoint; // 'A' or 'B'
  bool _isLoadingRoutes = false;

  LatLng? get _pickupLatLng => widget.pickupLatLng;
  LatLng? get _dropoffLatLng => widget.dropoffLatLng;
  String get _pickupText => (widget.pickupAddress ?? '').trim();
  String get _dropoffText => (widget.dropoffAddress ?? '').trim();

  @override
  void initState() {
    super.initState();
    if (widget.normalRoutes != null) {
      _normalRoutes = List<BookingRouteOption>.from(widget.normalRoutes!);
    }
    if (widget.avoidTollsRoutes != null) {
      _avoidTollsRoutes =
      List<BookingRouteOption>.from(widget.avoidTollsRoutes!);
    }

    if (widget.normalRoutes == null &&
        _pickupLatLng != null &&
        _dropoffLatLng != null) {
      _loadOsmRoutes();
    }
  }

  Future<void> _loadOsmRoutes() async {
    setState(() => _isLoadingRoutes = true);
    final fetched = await OsmRouteService.fetchRoutes(
      pickupLatLng: _pickupLatLng!,
      dropoffLatLng: _dropoffLatLng!,
      pickupAddress: _pickupText,
      dropoffAddress: _dropoffText,
      fareCalculator: widget.fareCalculator,
    );
    if (!mounted) return;
    setState(() {
      _normalRoutes = fetched.normal;
      _avoidTollsRoutes = fetched.avoidHighwayTolls;
      _isolatedRouteId = null;
      _isLoadingRoutes = false;
    });
    _fitAllRoutes();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  List<BookingRouteOption> get _allRoutes => [
    ..._normalRoutes,
    ..._avoidTollsRoutes,
  ];

  void _fitPoints(List<LatLng> pts) {
    if (pts.isEmpty) return;
    if (pts.length == 1) {
      _mapController.move(pts.first, 13.0);
      return;
    }
    final bounds = LatLngBounds.fromPoints(pts);
    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.all(55),
      ),
    );
  }

  void _fitAllRoutes() {
    final allPts = <LatLng>[
      if (_pickupLatLng != null) _pickupLatLng!,
      if (_dropoffLatLng != null) _dropoffLatLng!,
      for (final r in _allRoutes) ...r.points,
    ];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && allPts.isNotEmpty) _fitPoints(allPts);
    });
  }

  void _handleDoubleTapRoute(BookingRouteOption route) {
    setState(() {
      _isolatedRouteId = route.id;
      _activePopupPoint = null;
    });
    widget.onRouteSelected?.call(route);

    final pts = route.points.isNotEmpty
        ? route.points
        : [
      if (_pickupLatLng != null) _pickupLatLng!,
      if (_dropoffLatLng != null) _dropoffLatLng!,
    ];
    _fitPoints(pts);
  }

  List<Polyline> _buildPolylines() {
    final routesToDraw = _isolatedRouteId == null
        ? _allRoutes.reversed.toList()
        : _allRoutes.where((r) => r.id == _isolatedRouteId).toList();

    return [
      for (int i = 0; i < routesToDraw.length; i++)
        if (routesToDraw[i].points.length >= 2)
          Polyline(
            points: routesToDraw[i].points,
            color: routesToDraw[i].routeColor.withOpacity(
              _isolatedRouteId == null ? 0.85 : 1.0,
            ),
            strokeWidth: _isolatedRouteId == routesToDraw[i].id
                ? 5.0
                : (4.5 - (i * 0.8)).clamp(2.2, 4.5),
          ),
    ];
  }

  List<Marker> _buildMarkers() {
    final markers = <Marker>[];

    if (_pickupLatLng != null) {
      markers.add(
        Marker(
          point: _pickupLatLng!,
          width: 34,
          height: 38,
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _activePopupPoint = _activePopupPoint == 'A' ? null : 'A';
              });
            },
            child: _PinMarker(
              letter: 'A',
              color: DynamicColors.redClr,
            ),
          ),
        ),
      );
      if (_activePopupPoint == 'A' && _pickupText.isNotEmpty) {
        markers.add(
          Marker(
            point: _pickupLatLng!,
            width: 240,
            height: 64,
            alignment: Alignment.bottomCenter,
            child: Transform.translate(
              offset: const Offset(0, -40),
              child: _AddressCalloutBubble(address: _pickupText),
            ),
          ),
        );
      }
    }

    if (_dropoffLatLng != null) {
      markers.add(
        Marker(
          point: _dropoffLatLng!,
          width: 34,
          height: 38,
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _activePopupPoint = _activePopupPoint == 'B' ? null : 'B';
              });
            },
            child: _PinMarker(
              letter: 'B',
              color: DynamicColors.redClr,
            ),
          ),
        ),
      );
      if (_activePopupPoint == 'B' && _dropoffText.isNotEmpty) {
        markers.add(
          Marker(
            point: _dropoffLatLng!,
            width: 240,
            height: 64,
            alignment: Alignment.bottomCenter,
            child: Transform.translate(
              offset: const Offset(0, -40),
              child: _AddressCalloutBubble(address: _dropoffText),
            ),
          ),
        );
      }
    }

    return markers;
  }

  Widget _buildSectionHeader(String title, Color borderGrey, Color textMuted) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        border: Border(
          top: BorderSide(color: borderGrey),
          bottom: BorderSide(color: borderGrey),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.35,
          color: textMuted,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color pageBg = Color(0xFFF4F6F9);
    const Color panelWhite = Colors.white;
    const Color borderGrey = Color(0xFFDCE2E8);
    const Color textDark = Color(0xFF1F2937);
    const Color textMuted = Color(0xFF4B5563);

    final initialCenter = _pickupLatLng ??
        _dropoffLatLng ??
        (_allRoutes.isNotEmpty && _allRoutes.first.points.isNotEmpty
            ? _allRoutes.first.points.first
            : const LatLng(0, 0));

    return Scaffold(
      backgroundColor: pageBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: panelWhite,
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      "BOOKING ROUTES",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                        color: textDark,
                      ),
                    ),
                  ),
                  if (_isLoadingRoutes)
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: borderGrey),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final bool isWide = constraints.maxWidth >= 820;

                  final Widget leftListPanel = Container(
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: panelWhite,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: borderGrey),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        _buildSectionHeader(
                          "NORMAL ROUTES",
                          borderGrey,
                          textMuted,
                        ),
                        if (_normalRoutes.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(18),
                            child: Text(
                              "No normal routes available.",
                              style: TextStyle(fontSize: 12.5, color: textMuted),
                            ),
                          )
                        else
                          ..._normalRoutes.map(
                                (route) => _RouteOptionTile(
                              route: route,
                              isIsolated: _isolatedRouteId == route.id,
                              onDoubleTap: () => _handleDoubleTapRoute(route),
                            ),
                          ),
                        const SizedBox(height: 40),
                        _buildSectionHeader(
                          "AVOID HIGHWAY & TOLLS ROUTES",
                          borderGrey,
                          textMuted,
                        ),
                        if (_avoidTollsRoutes.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(18),
                            child: Text(
                              "No avoid highway & tolls routes available.",
                              style: TextStyle(fontSize: 12.5, color: textMuted),
                            ),
                          )
                        else
                          ..._avoidTollsRoutes.map(
                                (route) => _RouteOptionTile(
                              route: route,
                              isIsolated: _isolatedRouteId == route.id,
                              onDoubleTap: () => _handleDoubleTapRoute(route),
                            ),
                          ),
                      ],
                    ),
                  );

                  final Widget rightMapPanel = Container(
                    color: const Color(0xFFE5EAF0),
                    child: FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: initialCenter,
                        initialZoom: 12.0,
                        onMapReady: _fitAllRoutes,
                        onTap: (_, __) {
                          if (_activePopupPoint != null) {
                            setState(() => _activePopupPoint = null);
                          }
                        },
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.dashboard_new1',
                        ),
                        PolylineLayer(polylines: _buildPolylines()),
                        MarkerLayer(markers: _buildMarkers()),
                      ],
                    ),
                  );

                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(flex: 52, child: leftListPanel),
                        const VerticalDivider(
                          width: 1,
                          thickness: 1,
                          color: borderGrey,
                        ),
                        Expanded(flex: 48, child: rightMapPanel),
                      ],
                    );
                  }

                  return Column(
                    children: [
                      Expanded(flex: 52, child: leftListPanel),
                      const Divider(height: 1, thickness: 1, color: borderGrey),
                      Expanded(flex: 48, child: rightMapPanel),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RouteOptionTile extends StatelessWidget {
  final BookingRouteOption route;
  final bool isIsolated;
  final VoidCallback onDoubleTap;

  const _RouteOptionTile({
    required this.route,
    required this.isIsolated,
    required this.onDoubleTap,
  });

  @override
  Widget build(BuildContext context) {
    const Color borderGrey = Color(0xFFE5E9F0);
    const Color textDark = Color(0xFF1F2937);

    return GestureDetector(
      onDoubleTap: onDoubleTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
          color: isIsolated ? const Color(0xFFF9FBFF) : Colors.white,
          border: const Border(
            bottom: BorderSide(color: borderGrey),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _RouteDiamondIcon(color: route.routeColor),
                      const SizedBox(width: 7),
                      Text(
                        route.title,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: textDark,
                          letterSpacing: 0.25,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 11),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 1),
                        child: Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: Color(0xFF10B981),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          route.pickup,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: textDark,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 1),
                        child: Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: Color(0xFFF43F5E),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          route.dropoff,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: textDark,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.schedule,
                      size: 13,
                      color: Color(0xFFD97706),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      route.timeText,
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: textDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.route,
                      size: 13,
                      color: Color(0xFFEA580C),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      route.distanceText,
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: textDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.payments_outlined,
                      size: 13,
                      color: Color(0xFF059669),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      route.fareText,
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: textDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RouteDiamondIcon extends StatelessWidget {
  final Color color;

  const _RouteDiamondIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.directions,
      size: 16,
      color: color,
    );
  }
}

class _PinMarker extends StatelessWidget {
  final String letter;
  final Color color;

  const _PinMarker({
    required this.letter,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(
          Icons.location_pin,
          size: 30,
          color: color,
        ),
        Positioned(
          top: 5,
          child: Text(
            letter,
            style: mozillaTextSemiBoldText(
              color: Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _AddressCalloutBubble extends StatelessWidget {
  final String address;

  const _AddressCalloutBubble({required this.address});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFDCE2E8)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        address,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1F2937),
          height: 1.3,
        ),
      ),
    );
  }
}
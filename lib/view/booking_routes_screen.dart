import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  });
}

class BookingRoutesScreen extends StatefulWidget {
  final List<BookingRouteOption>? normalRoutes;
  final List<BookingRouteOption>? avoidTollsRoutes;
  final ValueChanged<BookingRouteOption>? onRouteSelected;

  const BookingRoutesScreen({
    super.key,
    this.normalRoutes,
    this.avoidTollsRoutes,
    this.onRouteSelected,
  });

  @override
  State<BookingRoutesScreen> createState() => _BookingRoutesScreenState();
}

class _BookingRoutesScreenState extends State<BookingRoutesScreen> {
  GoogleMapController? _mapController;
  late List<BookingRouteOption> _normalRoutes;
  late List<BookingRouteOption> _avoidTollsRoutes;
  String? _selectedRouteId;
  Set<Marker> _markers = {};
  bool _isDisposed = false;

  static const LatLng _pickupLatLng = LatLng(51.3750, -2.5480);
  static const LatLng _dropoffLatLng = LatLng(53.6458, -1.7850);

  @override
  void initState() {
    super.initState();
    _normalRoutes = widget.normalRoutes ?? _defaultNormalRoutes();
    _avoidTollsRoutes = widget.avoidTollsRoutes ?? _defaultAvoidTollsRoutes();
    if (_normalRoutes.isNotEmpty) {
      _selectedRouteId = _normalRoutes.first.id;
    } else if (_avoidTollsRoutes.isNotEmpty) {
      _selectedRouteId = _avoidTollsRoutes.first.id;
    }
    _loadMarkers();
  }

  Future<void> _loadMarkers() async {
    final built = await _buildMarkers();
    if (!mounted || _isDisposed) return;
    setState(() {
      _markers = built;
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    final controller = _mapController;
    _mapController = null;
    if (controller != null) {
      try {
        controller.dispose();
      } catch (_) {}
    }
    super.dispose();
  }

  List<BookingRouteOption> _defaultNormalRoutes() {
    const String pickup =
        "NORTON COURT NORTON MALREWARD PENSFORD, BRISTOL BS39 4EZ UK";
    const String dropoff =
        "ASDA EXPRESS, HUDDERSFIELD ROAD, KIRKLEES, HD9 6LT UK";

    return const [
      BookingRouteOption(
        id: "normal_1",
        title: "ROUTE #: 1",
        pickup: pickup,
        dropoff: dropoff,
        timeText: "TIME: 243 MIN",
        distanceText: "DISTANCE: 199.0 MI",
        fareText: "FARES: 401.05",
        routeColor: Color(0xFF16A34A),
        points: [
          LatLng(51.3750, -2.5480),
          LatLng(51.8994, -2.0783),
          LatLng(52.4862, -1.8904),
          LatLng(53.0027, -2.1794),
          LatLng(53.4808, -2.2426),
          LatLng(53.6458, -1.7850),
        ],
      ),
      BookingRouteOption(
        id: "normal_2",
        title: "ROUTE #: 2",
        pickup: pickup,
        dropoff: dropoff,
        timeText: "TIME: 245 MIN",
        distanceText: "DISTANCE: 206.1 MI",
        fareText: "FARES: 415.28",
        routeColor: Color(0xFFF59E0B),
        points: [
          LatLng(51.3750, -2.5480),
          LatLng(51.7500, -2.2200),
          LatLng(52.4068, -1.5197),
          LatLng(52.9548, -1.1581),
          LatLng(53.3811, -1.4701),
          LatLng(53.6458, -1.7850),
        ],
      ),
    ];
  }

  List<BookingRouteOption> _defaultAvoidTollsRoutes() {
    return const [];
  }

  List<BookingRouteOption> get _allRoutes => [
    ..._normalRoutes,
    ..._avoidTollsRoutes,
  ];

  void _handleSelectRoute(BookingRouteOption route) {
    setState(() {
      _selectedRouteId = route.id;
    });
    widget.onRouteSelected?.call(route);

    if (_mapController != null && route.points.isNotEmpty) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(
          _boundsFromLatLngList(route.points),
          60,
        ),
      );
    }
  }

  LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
    double minLat = list.first.latitude;
    double maxLat = list.first.latitude;
    double minLng = list.first.longitude;
    double maxLng = list.first.longitude;

    for (final latLng in list) {
      if (latLng.latitude < minLat) minLat = latLng.latitude;
      if (latLng.latitude > maxLat) maxLat = latLng.latitude;
      if (latLng.longitude < minLng) minLng = latLng.longitude;
      if (latLng.longitude > maxLng) maxLng = latLng.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  Set<Polyline> _buildPolylines() {
    final Set<Polyline> polylines = {};
    for (final route in _allRoutes) {
      if (route.points.length < 2) continue;
      final bool isSelected = route.id == _selectedRouteId;
      polylines.add(
        Polyline(
          polylineId: PolylineId(route.id),
          points: route.points,
          color: isSelected
              ? route.routeColor
              : route.routeColor.withOpacity(0.55),
          width: isSelected ? 5 : 3,
        ),
      );
    }
    return polylines;
  }

  Future<Set<Marker>> _buildMarkers() async {
    final BitmapDescriptor iconA = await _createPinWithLetter("A");
    final BitmapDescriptor iconB = await _createPinWithLetter("B");

    return {
      Marker(
        markerId: const MarkerId("pickup_a"),
        position: _pickupLatLng,
        icon: iconA,
        infoWindow: InfoWindow.noText,
        consumeTapEvents: true,
      ),
      Marker(
        markerId: const MarkerId("dropoff_b"),
        position: _dropoffLatLng,
        icon: iconB,
        infoWindow: InfoWindow.noText,
        consumeTapEvents: true,
      ),
    };
  }

  Future<BitmapDescriptor> _createPinWithLetter(String letter) async {
    const double size = 38;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    const Color pinRed = Color(0xFFDC2626);
    const Color pinDark = Color(0xFF991B1B);

    final pinPath = Path()
      ..moveTo(size * 0.5, size * 0.94)
      ..cubicTo(
        size * 0.22,
        size * 0.66,
        size * 0.16,
        size * 0.44,
        size * 0.16,
        size * 0.34,
      )
      ..arcToPoint(
        Offset(size * 0.84, size * 0.34),
        radius: const Radius.circular(size * 0.34),
        clockwise: true,
      )
      ..cubicTo(
        size * 0.84,
        size * 0.44,
        size * 0.78,
        size * 0.66,
        size * 0.5,
        size * 0.94,
      )
      ..close();

    canvas.drawPath(
      pinPath.shift(const Offset(0, 1.2)),
      Paint()..color = Colors.black.withOpacity(0.22),
    );
    canvas.drawPath(pinPath, Paint()..color = pinRed);
    canvas.drawPath(
      pinPath,
      Paint()
        ..color = pinDark
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.3,
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text: letter,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(
        (size - textPainter.width) / 2,
        size * 0.34 - textPainter.height / 2,
      ),
    );

    final picture = recorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
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

    return Scaffold(
      backgroundColor: pageBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Heading
            Container(
              width: double.infinity,
              color: panelWhite,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
              child: const Text(
                "BOOKING ROUTES",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                  color: textDark,
                ),
              ),
            ),
            const Divider(height: 1, thickness: 1, color: borderGrey),

            // Split Left List + Right Map
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
                        // NORMAL ROUTES Section
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
                              isSelected: route.id == _selectedRouteId,
                              onTap: () => _handleSelectRoute(route),
                            ),
                          ),


                        const SizedBox(height: 50),

                        // AVOID HIGHWAY & TOLLS ROUTES Section
                        _buildSectionHeader(
                          "AVOID HIGHWAY & TOLLS ROUTES",
                          borderGrey,
                          textMuted,
                        ),

                        if (_avoidTollsRoutes.isEmpty)
                          const SizedBox(height: 240)
                        else
                          ..._avoidTollsRoutes.map(
                                (route) => _RouteOptionTile(
                              route: route,
                              isSelected: route.id == _selectedRouteId,
                              onTap: () => _handleSelectRoute(route),
                            ),
                          ),
                      ],
                    ),
                  );

                  final Widget rightMapPanel = Container(
                    color: const Color(0xFFE5EAF0),
                    child: GoogleMap(
                      initialCameraPosition: const CameraPosition(
                        target: LatLng(52.4500, -1.9000),
                        zoom: 6.7,
                      ),
                      markers: _markers,
                      polylines: _buildPolylines(),
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      mapToolbarEnabled: false,
                      onMapCreated: (controller) {
                        if (_isDisposed) return;
                        _mapController = controller;
                      },
                    ),
                  );

                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 52,
                          child: leftListPanel,
                        ),
                        const VerticalDivider(
                          width: 1,
                          thickness: 1,
                          color: borderGrey,
                        ),
                        Expanded(
                          flex: 48,
                          child: rightMapPanel,
                        ),
                      ],
                    );
                  }

                  return Column(
                    children: [
                      Expanded(
                        flex: 52,
                        child: leftListPanel,
                      ),
                      const Divider(height: 1, thickness: 1, color: borderGrey),
                      Expanded(
                        flex: 48,
                        child: rightMapPanel,
                      ),
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
  final bool isSelected;
  final VoidCallback onTap;

  const _RouteOptionTile({
    required this.route,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const Color borderGrey = Color(0xFFE5E9F0);
    const Color textDark = Color(0xFF1F2937);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF9FBFF) : Colors.white,
          border: const Border(
            bottom: BorderSide(color: borderGrey),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left: Route Title + Pickup & Dropoff
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

            // Right: Time, Distance, Fares
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
    return Transform.rotate(
      angle: 0.785398, // 45 degrees
      child: Container(
        width: 9.5,
        height: 9.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          border: Border.all(color: color, width: 1.6),
        ),
      ),
    );
  }
}
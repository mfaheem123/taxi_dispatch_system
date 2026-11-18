import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../component/color.dart';
import '../../../component/marker_class.dart';
import '../../../component/networks/api.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_widget.dart';
import '../Controller/dashboard_controller.dart';
import '../models/tracking_drivers_model.dart';

/// One car gliding from [from] to [to] over [duration].
class _Move {
  _Move(this.from, this.to, this.start, this.duration);
  final LatLng from;
  final LatLng to;
  final DateTime start;
  final Duration duration;
}

class ViewDriversMap extends StatefulWidget {
  const ViewDriversMap({super.key});

  @override
  State<ViewDriversMap> createState() => _ViewDriversMapState();
}

class _ViewDriversMapState extends State<ViewDriversMap> {
  // final dashBoardCntrl = Get.find<DashboardController>();
  final dashBoardCntrl = Get.put(DashboardController());

  late final MapController mapController;
  int? selectTrackingCarId;

  /// Reactive marker list
  final RxList<CustomMarker> trackingMarkers = <CustomMarker>[].obs;
  // ---------------------------------------------------------------------
  // Sockets. This screen opens its OWN connections - it does not borrow the
  // dashboard controller's. A socket belongs to one tab (every tab is a
  // separate app), so sharing the dashboard's would leave this tab with
  // nothing to listen to.
  // ---------------------------------------------------------------------

  final Map<String, WebSocketChannel> _channels = {};
  final Map<String, StreamSubscription> _subs = {};
  final Map<String, Timer> _retryTimers = {};
  final Map<String, int> _failures = {};

  /// Names of the sockets that are connected right now.
  final Set<String> _up = {};

  Timer? _pollTimer;
  Timer? _statusTimer;
  Timer? _reconcileTimer;
  bool _fetching = false;
  bool _disposed = false;

  String get _companyQuery => "company_id=${Api.singleton.globalCompanyId}";

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    _loadDrivers();
    _connect("location", "/driver-tracking-dashboard", _onLocationMessage);
    _connect("login", "/driver-login?$_companyQuery", _onLoginMessage);
    _connect("busy", "/driver-busy?$_companyQuery", _onBusyMessage);
    _startPolling();
    // A car that stops stops sending positions, so nothing would ever flip its
    // tag to "Stopped": re-check every 5 seconds.
    _statusTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (_disposed || !mounted) return;
      _rebuildMarkers();
      dashBoardCntrl.update();
      setState(() {});
    });
  }

  @override
  void dispose() {
    _disposed = true;
    _pollTimer?.cancel();
    _reconcileTimer?.cancel();
    _animTimer?.cancel();
    _statusTimer?.cancel();
    for (final t in _retryTimers.values) {
      t.cancel();
    }
    for (final s in _subs.values) {
      s.cancel();
    }
    for (final c in _channels.values) {
      try {
        c.sink.close();
      } catch (_) {}
    }
    _retryTimers.clear();
    _subs.clear();
    _channels.clear();
    super.dispose();
  }

  /// Opens one socket and keeps it open: a failed connect or a drop is retried
  /// after 2s, 4s, 8s ... up to 30s, with one log line per attempt.
  void _connect(String name, String path, void Function(dynamic) onMessage) {
    if (_disposed || !mounted) return;
    _retryTimers.remove(name)?.cancel();
    _subs.remove(name)?.cancel();

    final url = Uri.parse("$socketUrl$path");
    late final WebSocketChannel channel;
    try {
      channel = WebSocketChannel.connect(url);
    } catch (e) {
      print("❌ Drivers map '$name' socket: $e");
      _scheduleRetry(name, path, onMessage);
      return;
    }
    _channels[name] = channel;

    // A failed connect only shows up on `ready`; with nothing listening there
    // it surfaces as an uncaught WebSocketChannelException.
    channel.ready.then((_) {
      if (_disposed) return;
      _failures[name] = 0;
      _up.add(name);
      print("✅ Drivers map '$name' socket connected");
    }).catchError((Object e) {
      _up.remove(name);
      final n = (_failures[name] ?? 0) + 1;
      _failures[name] = n;
      print("❌ Drivers map '$name' socket could not connect (attempt $n), "
          "retrying in ${_delayFor(name).inSeconds}s - url: $url");
    });

    _subs[name] = channel.stream.listen(
      (message) {
        if (_disposed || !mounted) return;
        try {
          onMessage(message);
        } catch (e) {
          print("Drivers map '$name' message error: $e");
        }
      },
      onError: (_) {}, // a failure is reported once, by `ready`, above
      onDone: () {
        _up.remove(name);
        if (identical(_channels[name], channel)) _channels.remove(name);
        _scheduleRetry(name, path, onMessage);
      },
    );
  }

  Duration _delayFor(String name) {
    final n = (_failures[name] ?? 0).clamp(0, 4);
    final seconds = 2 << n;
    return Duration(seconds: seconds > 30 ? 30 : seconds);
  }

  void _scheduleRetry(
      String name, String path, void Function(dynamic) onMessage) {
    if (_disposed || !mounted) return;
    _retryTimers[name]?.cancel();
    _retryTimers[name] =
        Timer(_delayFor(name), () => _connect(name, path, onMessage));
  }

  // ---------------------------------------------------------------------
  // The driver list: loading, and live changes from the sockets.
  // ---------------------------------------------------------------------

  /// Fetches the whole list. Returns false when the request got no answer, in
  /// which case the list keeps what it had.
  Future<bool> _fetchDrivers() async {
    if (_fetching || _disposed) return false;
    _fetching = true;
    try {
      final response =
          await Api().get("drivers/tracking-drivers", sendCompanyId: true);
      if (_disposed) return false;
      if (response == null || response.statusCode != 200) return false;
      dashBoardCntrl.onlineBusyDriversList =
          GetAllLabelsFromWidowModel.fromJson(response.data);
      _listChanged();
      return true;
    } catch (e) {
      print("Drivers map list load error: $e");
      return false;
    } finally {
      _fetching = false;
    }
  }

  /// First load, retried until the server answers.
  Future<void> _loadDrivers() async {
    var wait = 2;
    while (!_disposed && !await _fetchDrivers()) {
      await Future.delayed(Duration(seconds: wait));
      wait = wait >= 16 ? 16 : wait * 2;
    }
  }

  /// While either list socket is down, the list is refetched every 15s, so it
  /// still follows logins and logouts in a browser where sockets fail.
  void _startPolling() {
    _pollTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      if (_up.contains("login") && _up.contains("busy")) return;
      _fetchDrivers();
    });
  }

  /// Re-reads the list shortly after an event that doesn't say where the driver
  /// went (a busy driver who is available again, or logged out).
  void _reconcileSoon() {
    _reconcileTimer?.cancel();
    _reconcileTimer = Timer(const Duration(milliseconds: 1500), _fetchDrivers);
  }

  List<TrackingDriverObject>? get _list =>
      dashBoardCntrl.onlineBusyDriversList?.trackingDrivers;

  void _listChanged() {
    if (_disposed || !mounted) return;
    _syncMarkers();
    dashBoardCntrl.update(); // rebuilds the sidebar's GetBuilder
    setState(() {});
  }

  /// True once the camera has framed all the drivers, so later updates don't
  /// keep pulling the map back while the user pans or zooms.
  bool _cameraFitted = false;

  // ---- Smooth movement ----------------------------------------------------
  //
  // A driver's position arrives every few seconds. Putting the pin straight on
  // the new position makes the car jump; instead the pin glides from where it
  // is shown to the new position over about as long as the gap between the two
  // updates, so it keeps moving until the next one arrives.

  final Map<String, LatLng> _shown = {}; // where each car is drawn right now
  final Map<String, _Move> _moves = {};
  final Map<String, DateTime> _lastMoveAt = {};

  /// When each car's position last actually changed; "moving" is judged from it.
  final Map<String, DateTime> _movedAt = {};
  Timer? _animTimer;

  /// Every car to draw: the drivers in the list.
  List<TrackingDriverObject> get _allCars =>
      _list ?? const <TrackingDriverObject>[];

  /// Reads each driver's latest position and starts a glide for any that moved.
  void _syncMarkers() {
    final targets = <String, LatLng>{};
    for (final d in _allCars) {
      final lat = double.tryParse(d.latitude ?? "");
      final lng = double.tryParse(d.longitude ?? "");
      if (lat == null || lng == null) continue;
      targets[d.id.toString()] = LatLng(lat, lng);
    }

    // Cars that left the list.
    _shown.removeWhere((k, _) => !targets.containsKey(k));
    _moves.removeWhere((k, _) => !targets.containsKey(k));
    _lastMoveAt.removeWhere((k, _) => !targets.containsKey(k));
    _movedAt.removeWhere((k, _) => !targets.containsKey(k));

    final now = DateTime.now();
    targets.forEach((key, target) {
      final shown = _shown[key];
      if (shown == null) {
        _shown[key] = target; // first time seen: no glide, just appear
        _lastMoveAt[key] = now;
        return;
      }
      final moving = _moves[key];
      final goal = moving?.to ?? shown;
      if ((goal.latitude - target.latitude).abs() < 1e-7 &&
          (goal.longitude - target.longitude).abs() < 1e-7) {
        return; // not moved
      }
      // A far jump (a stale position corrected, a driver re-appearing) is
      // not a drive: snap instead of sliding across the city.
      if ((shown.latitude - target.latitude).abs() > 0.5 ||
          (shown.longitude - target.longitude).abs() > 0.5) {
        _shown[key] = target;
        _moves.remove(key);
        _lastMoveAt[key] = now;
        _movedAt[key] = now;
        return;
      }
      final gap = now.difference(_lastMoveAt[key] ?? now);
      final ms = gap.inMilliseconds.clamp(600, 4000);
      _lastMoveAt[key] = now;
      _movedAt[key] = now;
      _moves[key] = _Move(shown, target, now, Duration(milliseconds: ms));
    });

    _rebuildMarkers();
    if (_moves.isNotEmpty) {
      _animTimer ??=
          Timer.periodic(const Duration(milliseconds: 33), (_) => _tick());
    }

    // Frame all the drivers once, on the first list that has positions. The
    // map may not be built yet, so this is retried on the next update.
    if (!_cameraFitted && targets.isNotEmpty) {
      // Framed once and then left alone: the camera never follows a car.
      final points = targets.values.toList();
      try {
        if (points.length == 1) {
          mapController.move(points.first, 17);
        } else {
          mapController.fitCamera(CameraFit.coordinates(
            coordinates: points,
            padding: const EdgeInsets.fromLTRB(60, 60, 310, 60),
            maxZoom: 17, // street level when the cars are close together
          ));
        }
        _cameraFitted = true;
      } catch (_) {}
    }
  }

  /// One animation frame: moves every gliding car a little further.
  void _tick() {
    if (_disposed || !mounted) return;
    final now = DateTime.now();
    final done = <String>[];
    _moves.forEach((key, m) {
      final t = (now.difference(m.start).inMilliseconds /
              m.duration.inMilliseconds)
          .clamp(0.0, 1.0);
      _shown[key] = LatLng(
        m.from.latitude + (m.to.latitude - m.from.latitude) * t,
        m.from.longitude + (m.to.longitude - m.from.longitude) * t,
      );
      if (t >= 1.0) done.add(key);
    });
    done.forEach(_moves.remove);
    _rebuildMarkers();
    setState(() {});
    if (_moves.isEmpty) {
      _animTimer?.cancel();
      _animTimer = null;
    }
  }

  /// A car counts as moving if its position changed in the last 15 seconds.
  bool _isMoving(TrackingDriverObject d) {
    final t = _movedAt[d.id.toString()];
    return t != null && DateTime.now().difference(t) < const Duration(seconds: 15);
  }

  /// The status to show: the job status while there is one (Accepted, Arrived,
  /// On Route, STC), otherwise the driver's own (Available, Break, Sin Bin...).
  String _statusLabel(TrackingDriverObject d) {
    final booking = (d.bookingStatus ?? "").trim();
    final driver = (d.driverStatus ?? "").trim();
    if (booking.isNotEmpty && booking != "Available") return booking;
    if (driver.isNotEmpty) return driver;
    return "Available";
  }

  /// Builds the pins from where each car is drawn right now.
  void _rebuildMarkers() {
    final markers = <CustomMarker>[];
    for (final d in _allCars) {
      final point = _shown[d.id.toString()];
      if (point == null) continue;
      markers.add(CustomMarker(
        withReturnType: "driverMarker",
        type: "driverMarker",
        point: point,
        width: 70,
        height: 70,
        id: d.id,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Image.asset(_statusImage(d.bookingStatus ?? ""),
                width: 70, height: 70, fit: BoxFit.contain),
            Container(
              padding: const EdgeInsets.only(bottom: 10.0, left: 4, right: 4),
              child: Text(d.username ?? "",
                  style: const TextStyle(fontSize: 9, color: Colors.white)),
            ),
            // Status under the car, outside the pin's own box so the car
            // stays exactly on the driver's position.
            Positioned(
              bottom: -14,
              child: _statusPill(_statusLabel(d), _isMoving(d)),
            ),
          ],
        ),
      ));
    }
    trackingMarkers.assignAll(markers);
  }

  void _upsertDriver(Map data) {
    final list = _list;
    final id = data['id']?.toString();
    if (list == null || id == null) return;
    String? s(Object? v) => v?.toString();
    final i = list.indexWhere((d) => d.id.toString() == id);
    final old = i == -1 ? null : list[i];
    final driver = TrackingDriverObject(
      id: int.tryParse(id) ?? old?.id,
      name: s(data['name']) ?? old?.name,
      username: s(data['username']) ?? old?.username,
      zone: data['zone'] ?? old?.zone,
      latitude: s(data['latitude']) ?? old?.latitude,
      longitude: s(data['longitude']) ?? old?.longitude,
      bookingStatus: s(data['booking_status']) ?? old?.bookingStatus,
      sessionStatus: s(data['session_status']) ?? old?.sessionStatus,
      driverStatus: s(data['driver_status']) ?? old?.driverStatus,
      lastLoginAt: data['last_login_at'] ?? old?.lastLoginAt,
      vehicleType: s(data['vehicle_type']) ?? old?.vehicleType,
    );
    if (i == -1) {
      list.add(driver);
    } else {
      list[i] = driver;
    }
    _listChanged();
  }

  void _removeDriver(Object? rawId) {
    final list = _list;
    final id = rawId?.toString();
    if (list == null || id == null) return;
    final before = list.length;
    list.removeWhere((d) => d.id.toString() == id);
    trackingMarkers.removeWhere((m) => m.id.toString() == id);
    if (selectTrackingCarId?.toString() == id) selectTrackingCarId = null;
    if (list.length != before) _listChanged();
  }

  void _setStatus(Object? rawId, {Object? booking, Object? driver}) {
    final list = _list;
    final id = rawId?.toString();
    if (list == null || id == null) return;
    final i = list.indexWhere((d) => d.id.toString() == id);
    if (i == -1) return;
    if (booking != null) list[i].bookingStatus = booking.toString();
    if (driver != null) list[i].driverStatus = driver.toString();
    _listChanged();
  }

  /// driver-login socket: a driver logs in, changes status, or logs out.
  void _onLoginMessage(dynamic message) {
    final data = jsonDecode(message as String);
    final event = data['event'];
    final payload = data['data'];
    if (event == "DRIVER_LOGIN") {
      if (payload is Map) _upsertDriver(payload);
    } else if (event == "DRIVER_BREAK_STATUS_UPDATE" ||
        event == "DRIVER_SIN_BIN_STATUS_UPDATE") {
      if (payload is Map) {
        _setStatus(payload['id'],
            booking: payload['booking_status'],
            driver: payload['driver_status']);
      }
    } else if (event != "DRIVER_LIST") {
      // Anything else on this socket is a logout.
      if (payload is Map) _removeDriver(payload['driverId'] ?? payload['id']);
    }
  }

  /// driver-busy socket: a driver takes a job, the job moves on, or it ends.
  void _onBusyMessage(dynamic message) {
    final data = jsonDecode(message as String);
    final event = data['event'];
    final payload = data['data'];
    if (payload is! Map) return;
    if (event == "DRIVER_BOOKING_STATUS_WEB_UPDATE") {
      _setStatus(payload['id'] ?? payload['driver_id'] ?? payload['driverId'],
          booking: payload['booking_status'],
          driver: payload['driver_status']);
    } else if (event == "BUSY_DRIVER_UPDATE") {
      _upsertDriver(payload);
    } else {
      // A busy driver is gone from the busy list: logged out, or free again.
      // The event doesn't say which, so drop them and re-read the list.
      _removeDriver(payload['id']);
      _reconcileSoon();
    }
  }

  /// driver-tracking-dashboard socket: a driver's position or job status.
  void _onLocationMessage(dynamic message) {
    final data = jsonDecode(message as String);
    if (data['event'] != 'DRIVER_LOCATION_UPDATE' &&
        data['event'] != "DRIVER_BOOKING_STATUS_UPDATE") {
      return;
    }
    final payload = data['data'];
    final list = _list;
    if (payload is! Map || list == null) return;
    final id = payload['id']?.toString();
    final i = list.indexWhere((d) => d.id.toString() == id);
    if (i == -1) {
      // A driver this list has not heard of: read the list again.
      _reconcileSoon();
      return;
    }
    final lat = double.tryParse(payload['latitude']?.toString() ?? "");
    final lng = double.tryParse(payload['longitude']?.toString() ?? "");
    if (lat != null) list[i].latitude = lat.toString();
    if (lng != null) list[i].longitude = lng.toString();
    if (payload['booking_status'] != null) {
      list[i].bookingStatus = payload['booking_status'].toString();
    }
    _listChanged();
  }

  /// "On Route - Moving" style tag shown under a car on the map.
  Widget _statusPill(String status, bool moving) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: _statusColor(status),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: moving ? Colors.lightGreenAccent : Colors.white38,
            ),
          ),
          const SizedBox(width: 3),
          Text(
            "$status \u00b7 ${moving ? 'Moving' : 'Stopped'}",
            maxLines: 1,
            softWrap: false,
            style: const TextStyle(
                fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String? status) {
    switch (status) {
      case "Accepted":
        return Colors.orange;
      case "Arrived":
        return Colors.amber.shade800;
      case "On Route":
        return Colors.red;
      case "STC":
        return Colors.blue;
      default:
        return Colors.green;
    }
  }


  String _statusImage(String status) {
    print("statusstatusstatus $status");
    switch (status) {
      case "Accepted":
        return "assets/c.png";   // Orange Car

      case "Arrived":
        return "assets/d.png";   // Yellow Car

      case "On Route":
        return "assets/tracking_car.png";    // Black Car

      case "STC":
        return "assets/a.png";        // Blue Car

      default:
        return "assets/green.jpeg";
    }
  }



  void _updateZoom(bool zoomIn) {
    double currentZoom = mapController.camera.zoom;
    double newZoom = zoomIn ? currentZoom + 1 : currentZoom - 1;

    if (newZoom >= 3.0 && newZoom <= 18.0) {
      mapController.move(mapController.camera.center, newZoom);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// MAP
          SizedBox(
            height: Get.height,
            width: Get.width,
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: LatLng(51.2709722, 0.1893883),
                initialZoom: 13.0,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all,
                  enableMultiFingerGestureRace: true,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                  'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                ),

                /// Reactive markers
                MarkerLayer(
                  markers: trackingMarkers,
                ),
              ],
            ),
          ),

          /// MAP CONTROLS
          Positioned(
            right: 265, // Sidebar width (250) + margin
            bottom: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Zoom In
                SizedBox(
                  height: 35,
                  width: 35,
                  child: FloatingActionButton.small(
                    heroTag: "zoom_in_btn",
                    backgroundColor: Colors.white,
                    onPressed: () => _updateZoom(true),
                    child: const Icon(
                      Icons.add,
                      color: Colors.black87,
                      size: 20,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                /// Zoom Out
                SizedBox(
                  height: 35,
                  width: 35,
                  child: FloatingActionButton.small(
                    heroTag: "zoom_out_btn",
                    backgroundColor: Colors.white,
                    onPressed: () => _updateZoom(false),
                    child: const Icon(
                      Icons.remove,
                      color: Colors.black87,
                      size: 20,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                /// Focus Selected Driver
                SizedBox(
                  height: 40,
                  width: 40,
                  child: FloatingActionButton.small(
                    heroTag: "focus_driver_btn",
                    backgroundColor: Colors.black26,
                    onPressed: () {
                      mapController.move(
                        LatLng(50.5, 30.51),
                        12,
                      );
                    },
                    child: const Icon(
                      Icons.center_focus_strong,
                      color: Colors.black87,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// DRIVER LIST SIDEBAR
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 250,
              height: Get.height,
              color: DynamicColors.whiteClr,
              child: Column(
                children: [
                  /// Header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppText.drivers.toUpperCase(),
                          style: mozillaTextSemiBoldText(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),

                  /// Driver list
                  Expanded(
                    child: GetBuilder<DashboardController>(
                      builder: (controller) {
                        if (controller.onlineBusyDriversList == null) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        return ListView.builder(
                          itemCount: controller.onlineBusyDriversList
                              ?.trackingDrivers?.length ??
                              0,
                          itemBuilder: (context, index) {
                            final driver = controller.onlineBusyDriversList!
                                .trackingDrivers![index];

                            return GestureDetector(
                              onTap: () {
                                final lat = double.tryParse(driver.latitude ?? "");
                                final lng = double.tryParse(driver.longitude ?? "");
                                // No position yet: nothing to zoom to.
                                if (lat == null || lng == null) return;
                                final target = LatLng(lat, lng);

                                selectTrackingCarId = driver.id;

                                /// Move map
                                Future.delayed(
                                    const Duration(milliseconds: 100), () {
                                  mapController.move(target, 16);
                                });

                                setState(() {});
                              },
                              child: _driverTile(
                                driver.username ?? "",
                                _statusLabel(driver),
                                color: _statusColor(_statusLabel(driver)),
                                moving: _isMoving(driver),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _driverTile(String name, String status,
      {Color color = const Color(0xff424899), bool moving = false}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              name,
              style: mozillaTextSemiBoldText(
                  fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 5),
          Tooltip(
            message: moving ? "Moving" : "Stopped",
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: moving ? Colors.green : Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 5),
          const Icon(Icons.send_outlined,
              size: 16, color: Color(0xff424899)),
        ],
      ),
    );
  }
}
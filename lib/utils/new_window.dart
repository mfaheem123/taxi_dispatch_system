import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'open_new_window.dart';
import 'shared_window_storage.dart';

/// Opening any screen in its OWN BROWSER WINDOW, with data handed to it.
///
/// A popped window is a second, independent instance of the app: it boots from
/// scratch with its own GetX bindings and controllers, so neither a widget nor
/// a Dart object can be passed to it the way they are passed to a dialog. What
/// the two instances share is the origin's localStorage, so the data travels
/// as JSON through storage and a one-off window id travels in the URL.
///
/// Two halves, used together:
///
///  * the opener calls [openScreenInNewWindow] with a route and its data;
///  * that route's GetPage builds a [NewWindowScreen], which reads the data
///    back and hands it to the real screen.
///
/// ```dart
/// // app_pages.dart
/// GetPage(
///   name: _Paths.customerInvoiceView,
///   page: () => NewWindowScreen<CustomerInvoiceByIdModel>(
///     fromJson: CustomerInvoiceByIdModel.fromJson,
///     builder: (context, data) =>
///         CustomerInvoiceViewScreen(invoice: data.customerInvoice),
///   ),
/// ),
///
/// // any screen
/// openScreenInNewWindow(Routes.customerInvoiceView,
///     data: controller.customerInvoiceByIdModel);
/// ```
///
/// See new_window_booking.dart for the booking-specific predecessor this
/// generalises.

/// Prefix of the storage key the data is parked under; the route is appended,
/// so windows of different screens never overwrite each other's data.
const String _kKeyPrefix = 'newWindowData:';

/// Query parameter carrying the window id on the popped window's URL.
const String _kWindowIdParam = 'wid';

/// Opens [route] in a new browser window and hands [data] to it.
///
/// [data] is anything `jsonEncode` accepts — a Map, a List, or a model with a
/// `toJson()` method (jsonEncode calls it). The receiving [NewWindowScreen]
/// turns it back into the model with its `fromJson`.
///
/// The data is parked BEFORE the window opens and without an `await` in
/// between: the browser only opens windows while it is still handling the
/// click, and the new instance reads storage while it boots.
///
/// Off the web there is no second window to open, so the route is pushed in
/// this app instead, with the data handed over the same way.
Future<void> openScreenInNewWindow(
  String route, {
  Object? data,
  int width = 1200,
  int height = 850,
}) async {
  final windowId = DateTime.now().microsecondsSinceEpoch.toString();
  final key = '$_kKeyPrefix${_pathOf(route)}';

  String? payload;
  try {
    payload = data == null ? null : jsonEncode(data);
  } catch (e) {
    // A model whose toJson throws on incomplete data must not cost the user
    // the window — it opens on its empty state instead.
    debugPrint('openScreenInNewWindow: could not encode data for $route: $e');
  }
  if (payload == null) {
    removeSharedValue(key);
  } else {
    writeSharedValue(key, '{"wid":"$windowId","data":$payload}');
  }

  final separator = route.contains('?') ? '&' : '?';
  final target = '$route$separator$_kWindowIdParam=$windowId';
  if (!kIsWeb) {
    await Get.toNamed(target);
    return;
  }
  await openInNewWindow('${Uri.base.origin}/#$target',
      width: width, height: height);
}

/// Page wrapper for a screen opened through [openScreenInNewWindow].
///
/// Reads the data parked for this window, decodes it with [fromJson] and
/// builds [builder] with it — or [empty] when there is none (the route was
/// opened by hand, or the data belonged to another window).
///
/// The data is deliberately NOT removed once read, so reloading the popped
/// window shows the same screen again. Opening the same route once more
/// replaces it; a window already on screen keeps what it built.
class NewWindowScreen<T> extends StatefulWidget {
  final T Function(Map<String, dynamic> json) fromJson;
  final Widget Function(BuildContext context, T data) builder;

  /// Shown when no data was handed over. Defaults to a plain message.
  final Widget? empty;

  const NewWindowScreen({
    super.key,
    required this.fromJson,
    required this.builder,
    this.empty,
  });

  @override
  State<NewWindowScreen<T>> createState() => _NewWindowScreenState<T>();
}

class _NewWindowScreenState<T> extends State<NewWindowScreen<T>> {
  T? _data;

  @override
  void initState() {
    super.initState();
    _data = _read();
  }

  T? _read() {
    final route = _currentRoute();
    if (route == null) return null;
    final raw = readSharedValue('$_kKeyPrefix${_pathOf(route)}');
    if (raw == null || raw.isEmpty) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      // Data parked for a different window of this screen is not ours.
      final expected = _windowId();
      if (expected != null && map['wid']?.toString() != expected) return null;
      final data = map['data'];
      return data is Map<String, dynamic> ? widget.fromJson(data) : null;
    } catch (e) {
      debugPrint('NewWindowScreen: could not decode data for $route: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _data;
    if (data != null) return widget.builder(context, data);
    return widget.empty ??
        const Scaffold(
          backgroundColor: Colors.white,
          body: Center(child: Text('NO DATA FOUND')),
        );
  }
}

/// The route this window is showing.
///
/// The window is opened on a fragment URL ("/#/view/customerInvoice?wid=1"),
/// but main() runs PathUrlStrategy, and once the app has booted Flutter can
/// report the route back into the PATH ("/view/customerInvoice?wid=1"),
/// dropping the fragment — so both are tried. GetX's own current route covers
/// the in-app push used off the web.
String? _currentRoute() {
  if (kIsWeb) {
    final fragment = Uri.base.fragment;
    if (fragment.isNotEmpty && fragment != '/') return fragment;
    final path = Uri.base.path;
    if (path.isNotEmpty && path != '/') {
      final query = Uri.base.query;
      return query.isEmpty ? path : '$path?$query';
    }
  }
  final current = Get.currentRoute;
  return current.isEmpty ? null : current;
}

/// The window id on this window's URL, or null when there is none.
String? _windowId() {
  final route = _currentRoute();
  final fromRoute =
      route == null ? null : Uri.tryParse(route)?.queryParameters[_kWindowIdParam];
  if (fromRoute != null && fromRoute.isNotEmpty) return fromRoute;
  final fromGet = Get.parameters[_kWindowIdParam];
  return (fromGet != null && fromGet.isNotEmpty) ? fromGet : null;
}

/// [route] without its query, so the opener and the window agree on the key.
String _pathOf(String route) => Uri.tryParse(route)?.path ?? route;

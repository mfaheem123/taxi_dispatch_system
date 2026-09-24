import 'dart:convert';

import '../view/dashboard_view/models/dashboard_table_model.dart';
import 'open_new_window.dart';
import 'shared_window_storage.dart';

/// Handing the open booking to a page opened in a NEW BROWSER WINDOW.
///
/// A popped window is a second, independent instance of the app: it boots from
/// scratch, with its own GetX bindings and its own controllers. A Dart object
/// cannot be passed to it the way it is passed to a dialog or a pushed route —
/// there is no shared heap on the other side of `window.open`. What the two
/// instances DO share is the origin's local storage, which is what GetStorage
/// writes to on web, so the booking travels as JSON through storage while the
/// booking id travels in the URL.
///
/// The id in the URL is not decoration: it is what lets the receiving window
/// tell "the booking I was opened for" from "a booking some earlier window
/// left behind", which is checked in [takeHandedOverBooking].

/// Storage key the parked booking is written under.
const String _kHandoffKey = 'newWindowBooking';

/// Query parameter carrying the booking id on the popped window's URL.
const String _kHandoffIdParam = 'bookingId';

/// Storage key the bookings linked to the parked one (the return legs of a
/// return journey, which `bookings/getbyid` sends after the main booking) are
/// written under.
const String _kHandoffLinkedKey = 'newWindowLinkedBookings';

/// Opens [route] in a new window with [booking] handed over to it.
///
/// [linked] travels alongside it — the other bookings the same lookup
/// returned, e.g. the return legs a receipt lists under the main booking.
///
/// The booking is parked BEFORE the window opens and without an `await` in
/// between: the new instance reads storage while it boots, so a write still in
/// flight would land after the screen it was meant for had already built — and
/// an async gap here is also what gets the popup blocked, since the browser
/// only opens windows while it is still processing the click.
Future<void> openBookingInNewWindow(
    String route, BookingObjectData? booking,
    {List<BookingObjectData> linked = const []}) {
  final payload = _encode(booking);
  if (payload == null) {
    // Nothing to hand over — clear whatever an earlier window parked, so the
    // new one opens on an empty form rather than on a stale booking.
    removeSharedValue(_kHandoffKey);
  } else {
    writeSharedValue(_kHandoffKey, payload);
  }

  final linkedPayload = linked.map(_encode).whereType<String>().toList();
  if (payload == null || linkedPayload.isEmpty) {
    removeSharedValue(_kHandoffLinkedKey);
  } else {
    // Tagged with the main booking's id for the same reason the main payload
    // is checked against the URL: a list some earlier window left behind must
    // not end up on this booking's receipt.
    writeSharedValue(
      _kHandoffLinkedKey,
      '{"forId":${jsonEncode(booking?.id?.toString())},'
      '"bookings":[${linkedPayload.join(',')}]}',
    );
  }

  final id = booking?.id;
  final query =
      id == null ? '' : '?$_kHandoffIdParam=${Uri.encodeComponent(id)}';
  return openInNewWindow('${Uri.base.origin}/#$route$query');
}

/// Returns the booking this window was opened for, and consumes it.
///
/// Consuming matters: without it the same booking would prefill every later
/// visit to the screen in this window, including one the user reached from the
/// menu rather than from a booking.
///
/// Returns null when the window was not opened from a booking, when the parked
/// payload belongs to a different booking than the URL names, or when the
/// payload cannot be decoded.
BookingObjectData? takeHandedOverBooking() {
  final raw = readSharedValue(_kHandoffKey);
  if (raw == null || raw.isEmpty) return null;

  BookingObjectData? booking;
  try {
    booking =
        BookingObjectData.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  } catch (_) {
    removeSharedValue(_kHandoffKey);
    return null;
  }

  // A booking left behind by some earlier window is not this window's booking.
  final expectedId = handedOverBookingId();
  if (expectedId != null && booking.id.toString() != expectedId) return null;

  removeSharedValue(_kHandoffKey);
  return booking;
}

/// Returns the bookings handed over next to the main one, and consumes them.
///
/// Empty when none were handed over, when they belong to a different booking
/// than the URL names, or when they cannot be decoded.
List<BookingObjectData> takeHandedOverLinkedBookings() {
  final raw = readSharedValue(_kHandoffLinkedKey);
  if (raw == null || raw.isEmpty) return const [];

  try {
    final map = jsonDecode(raw) as Map<String, dynamic>;
    final expectedId = handedOverBookingId();
    if (expectedId != null && map['forId']?.toString() != expectedId) {
      return const [];
    }
    removeSharedValue(_kHandoffLinkedKey);
    return [
      for (final b in (map['bookings'] as List? ?? const []))
        BookingObjectData.fromJson(b as Map<String, dynamic>),
    ];
  } catch (_) {
    removeSharedValue(_kHandoffLinkedKey);
    return const [];
  }
}

/// The booking id on this window's URL, or null when there is none.
///
/// The window is opened on a fragment URL ("/#/LostProperty?bookingId=12"), so
/// the query sits inside [Uri.base.fragment] and never reaches
/// `Uri.base.queryParameters`. Both are read so the helper keeps working if the
/// app is ever moved off the hash strategy.
String? handedOverBookingId() {
  final fromFragment =
      Uri.tryParse(Uri.base.fragment)?.queryParameters[_kHandoffIdParam];
  if (fromFragment != null && fromFragment.isNotEmpty) return fromFragment;
  final fromQuery = Uri.base.queryParameters[_kHandoffIdParam];
  return (fromQuery != null && fromQuery.isNotEmpty) ? fromQuery : null;
}

/// JSON for [booking], or null when there is nothing worth handing over.
///
/// `BookingObjectData.toJson` dereferences `pickupDate!` and a few nested
/// models do the same, so it throws on a booking that is merely incomplete.
/// That must not cost the user the whole handover, hence the fallback to the
/// fields the receiving screens actually read. `fromJson` is null-safe
/// throughout, so a partial map decodes cleanly on the other side.
String? _encode(BookingObjectData? booking) {
  if (booking == null) return null;
  try {
    return jsonEncode(booking.toJson());
  } catch (_) {
    final date = booking.pickupDate;
    return jsonEncode({
      'id': booking.id,
      'reference_number': booking.referenceNumber,
      'customer_id': booking.customerId,
      'name': booking.name,
      'email': booking.email,
      'mobile': booking.mobile,
      'telephone': booking.telephone,
      'pickup': booking.pickup,
      'dropoff': booking.dropoff,
      'pickup_date': date == null
          ? null
          : '${date.year.toString().padLeft(4, '0')}-'
              '${date.month.toString().padLeft(2, '0')}-'
              '${date.day.toString().padLeft(2, '0')}',
      'pickup_time': booking.pickupTime,
      'vehicle_type': booking.vehicleType == null
          ? null
          : {'name': booking.vehicleType!.name},
      'driver': booking.driver == null
          ? null
          : {
              'name': booking.driver!.name,
              'vehicle': booking.driver!.vehicle == null
                  ? null
                  : {
                      'vehicle_number':
                          booking.driver!.vehicle!.vehicleNumber,
                    },
            },
    });
  }
}

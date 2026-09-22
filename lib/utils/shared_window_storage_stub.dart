// Non-web: there is no second app instance to share anything with — the URL is
// handed to the system browser, which starts a process this one cannot reach.
// GetStorage still backs the handover so the API behaves the same everywhere
// (and so a value written here survives into the next run of this app).
import 'package:get_storage/get_storage.dart';

String? readSharedValue(String key) {
  final value = GetStorage().read(key);
  return value is String ? value : null;
}

void writeSharedValue(String key, String value) {
  // Deliberately not awaited: see the note in [new_window_booking.dart] — the
  // write must not put an async gap in front of the window being opened.
  GetStorage().write(key, value);
}

void removeSharedValue(String key) {
  GetStorage().remove(key);
}

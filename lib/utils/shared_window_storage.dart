// Storage both app instances can see: the window that opens another one writes
// through here, the window that opens reads through here.
export 'shared_window_storage_stub.dart'
    if (dart.library.html) 'shared_window_storage_web.dart';

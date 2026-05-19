# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Flutter app (`pubspec.yaml` name: `dashboard_new1`) — a taxi dispatch dashboard targeting **Flutter Web first**. `main.dart` imports `dart:html` directly and uses `setUrlStrategy(HashUrlStrategy())`, so non-web builds will not compile without conditional changes.

## Commands

Dart SDK constraint: `^3.6.0` (see `pubspec.yaml`).

```powershell
flutter pub get                                              # install deps
flutter run -d chrome --web-browser-flag=--start-maximized   # dev (also: npm run flutter-web)
flutter analyze                                              # lint (uses flutter_lints)
flutter test                                                 # run tests (only test/widget_test.dart exists)
flutter test test/widget_test.dart --plain-name "<name>"     # run a single test
flutter build web --dart-define=ENVIRONMENT=production       # production build
```

Environment is selected via `--dart-define=ENVIRONMENT=dev|production` and consumed by `lib/component/networks/url.dart` (`Environment` singleton → `BaseConfig`). **Note:** the current `_getConfig` switch falls through to `ProductionConfig` for *any* value including `dev`, so `DevConfig` is effectively dead code unless that switch is fixed.

## Architecture

### State management & DI: GetX

GetX is used for everything — routing (`GetMaterialApp` + `GetPage`), DI (`Get.put`, `Get.find`), reactive state (`Rx<T>`, `.obs`, `Obx`), and navigation (`Get.to`, `Get.offAllNamed`). Three controllers are registered as `permanent: true` in `main.dart` and are available app-wide: `ZoneController`, `AuthController`, `DashboardController`. Page-scoped controllers are wired through `DashBoardBindings` on `GetPage` entries.

### Routing

`lib/routes/app_pages.dart` + `lib/routes/app_routes.dart` (joined via `part`/`part of`). All routes live in `AppPages.routes`. Initial route is `Routes.loginScreen`. An `AuthMiddleware` exists that redirects to login when no `token` is in `GetStorage`, but it is **not currently attached** to any `GetPage` — auth gating today relies on the initial route plus controller-level checks.

### Feature module layout

Features live under `lib/view/<feature>/` and each typically contains:
- `controller/` (or `Controller/` — casing is inconsistent) — GetX controllers
- `model/` or `models/` — data models
- screen/widget Dart files at the feature root

Top-level features: `auth`, `dashboard_view`, `booking_view`, `drivers_view`, `vehicles_view`, `customer`, `accounts`, `administration`, `authorization`, `fare_view`, `locations_view`, `reports`, `setting`, `main_appbar`. Shared UI building blocks live in `lib/component/`, shared models in `lib/Model/`, and modal dialogs in `lib/alert/`.

Two parallel dashboard controller directories exist — `lib/dashboard_view/Controller/dashboard_controller.dart` and `lib/view/dashboard_view/Controller/dashboard_controller.dart`. The one under `lib/view/...` is the live one (imported by `main.dart` and `app_pages.dart`); treat the top-level `lib/dashboard_view/` as legacy unless verified otherwise.

### Networking

`lib/component/networks/api.dart` — `Api` singleton wrapping `Dio`. Reads bearer token from `GetStorage().read('token')` per request. `injectCompanyId` automatically attaches `globalCompanyId = "1"` to request payloads — be aware when constructing request bodies. `RetryOnConnectionChangeInterceptor` (in `interceptor.dart`) retries on connectivity loss. Base URLs come from `Environment().config` — never hardcode.

### Real-time

Two channels are used in parallel:
- **WebSocket** (`web_socket_channel`) — CLI events (`$socketUrl/cli`) and driver login (`$socketUrl/driver-login`), wired in `DashboardController`.
- **socket.io_client** — also imported in `DashboardController` for other live driver/booking events.
- **Firebase Cloud Messaging** (web only) — `setupWebNotifications()` in `main.dart` requests permission, fetches FCM token with the hardcoded VAPID key, and shows foreground messages via `BotToast`. The Firebase config is **hardcoded in `main.dart`** (apiKey, projectId, etc.) — keep that in mind when changing environments.

### Web-specific behavior

`main.dart` calls `disableInspect()` which uses `dart:html` to block right-click, F12, Ctrl+Shift+I/J, and Ctrl+U. This is the main reason the codebase doesn't currently build for non-web targets without changes. `lib/utils/open_new_tab_{web,stub}.dart` is the conditional-import pattern to follow for any other `dart:html` usage.

### Keyboard navigation system

The booking form implements full Tab/Shift+Tab/Enter keyboard navigation through `DashboardController.focusableWidgets` (a list of `FocusNode`s) with `focusNextWidget()` / `focusPreviousWidget()` / `handleTabNavigation()` / `handleEnterKey()` methods. Widgets opt in by wrapping with `RawKeyboardListener` + `Focus` and pulling a node from the controller's list. When adding a new focusable form element: append a `FocusNode` to `focusableWidgets` in `DashboardController`, wrap the widget with `Focus`, and (for buttons) pass an `onEnterPressed` callback. See `KEYBOARD_NAVIGATION_GUIDE.md` and `IMPLEMENTATION_SUMMARY.md` for the intended focus order and integration points.

### Persistence

`GetStorage` (initialized in `main.dart` before `runApp`) holds `token`, `userData`, `userRole`, etc. Treat it as the source of truth for the current session.

## Conventions worth knowing

- **Directory casing is inconsistent** (`Controller` vs `controller`, `Model` vs `model`, `Url.dart` vs `url.dart`). On case-sensitive filesystems imports can break — match existing casing when adding imports.
- **Commented-out code is common**, especially large blocks at the top of `main.dart` showing prior iterations. Don't assume the active code is at the top of the file.
- The package name in imports is `dashboard_new1` (not the directory name `taxi_dispatch_system`).
- `flutter_lints: ^5.0.0` is enabled via `analysis_options.yaml` with no rule customization.

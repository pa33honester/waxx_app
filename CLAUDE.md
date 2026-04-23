# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Waxxapp — a Flutter e-commerce app with live-selling / auction features. Two distinct user surfaces (buyer + seller) ship from a single codebase. Targets Android, iOS, web, macOS, Windows, Linux.

- Flutter **3.32.5**, Dart **^3.6.1**, Java 21 (Android build toolchain)
- Current version pin: [pubspec.yaml](pubspec.yaml) `version: 1.0.3+6`

## Commands

```bash
flutter pub get                                 # fetch deps (required after pubspec changes)
flutter run                                     # run on attached device/emulator
flutter run -d <device-id>                      # select device; `flutter devices` to list
flutter analyze                                 # static analysis (flutter_lints via analysis_options.yaml)
flutter test                                    # run all tests in test/
flutter test test/path/to/foo_test.dart         # single test file
flutter test --name "substring of test name"    # single test by name
flutter build apk --release                     # Android release build
flutter build appbundle --release               # Play Store bundle
flutter build ios --release                     # iOS release build
```

Note: there is a local path dependency override for `cool_dropdown` pointing at [packages/cool_dropdown/](packages/cool_dropdown/) — do not delete that directory and re-run `flutter pub get` after modifying it.

## Architecture

### State management & navigation
GetX is the backbone ([main.dart](lib/main.dart) uses `GetMaterialApp`). This drives three things at once:

1. **Routing** — all named routes live in [lib/utils/routes_pages.dart](lib/utils/routes_pages.dart) (`AppPages.routes`). Add new pages there rather than using `Navigator.push` ad hoc.
2. **DI** — controllers are instantiated via `Get.put` / `Get.lazyPut` (often inside `Bindings` attached to a `GetPage`) and retrieved with `Get.find`.
3. **Reactive state** — `.obs` values + `Obx(...)` widgets; avoid mixing with `setState` in the same widget.

Global singletons and flags live in [lib/utils/globle_veriables.dart](lib/utils/globle_veriables.dart) (spelled "globle") — things like `getStorage`, `identify`, `fcmToken`, `dialCode`, `isDemoSeller`, `isDark`. The app's dark-mode toggle is a `ValueNotifier<bool> isDark` read in [lib/utils/Theme/](lib/utils/Theme/).

### Layered structure (under lib/)
The codebase mixes two organizational conventions — treat them as one logical MVC:

- **[Controller/](lib/Controller/)** — GetX controllers (`GetxController/user/…`, `GetxController/seller/…`, `GetxController/login/…`, `GetxController/socket controller/`) and `ApiControllers/`.
- **[ApiService/](lib/ApiService/)** — one file per HTTP endpoint, grouped by `user/`, `seller/`, `login/`, `socket service/`. Controllers call these. All endpoint paths are centralized in [lib/utils/api_url.dart](lib/utils/api_url.dart) (`class Api`, `Api.baseUrl = "https://www.waxxapp.com/"`, plus `Api.secretKey`).
- **[ApiModel/](lib/ApiModel/)** and **[model/](lib/model/)** — request/response DTOs.
- **[user_pages/](lib/user_pages/)** and **[seller_pages/](lib/seller_pages/)** — feature-first: each feature has its own `controller/`, `view/`, `widget/` subfolders (e.g. [lib/user_pages/home_page/](lib/user_pages/home_page/)). This is the preferred pattern for new features.
- **[View/MyApp/AppPages/](lib/View/MyApp/AppPages/)** — older flat page files (e.g. `product_detail.dart`); still linked from routes, edited in-place, not the template for new work.
- **[services/](lib/services/)** — cross-cutting services, notably [push_notification_service.dart](lib/services/push_notification_service.dart) (FCM + `flutter_local_notifications`, initialized in `main()`).
- **[custom/](lib/custom/)** — shared widgets (dialogs, inputs).
- **[localization/](lib/localization/)** — `AppLanguages` (GetX translations) and `LocalizationConstant`. `getLocale()` persists the user's choice; `Get.updateLocale` applies it.
- **[PaymentMethod/](lib/PaymentMethod/)** — Razorpay, Stripe, Flutterwave integrations.

### Live streaming / realtime
- **ZEGOCLOUD** (`zego_express_engine`) drives live video — utilities in [lib/utils/Zego/](lib/utils/Zego/). `LivePageRouteObserver` in [lib/main.dart](lib/main.dart) tracks whether the user is currently on a live page (sockets/FCM behavior diverges on live pages).
- **Socket.IO** (`socket_io_client`) for live-selling chat/bids — service in [lib/utils/socket_services.dart](lib/utils/socket_services.dart), controllers under `Controller/GetxController/socket controller/`.

### Firebase
Initialized in `main()` — Auth (phone OTP + Google + Apple sign-in), Messaging, Crashlytics, and a background FCM handler `firebaseMessagingBackgroundHandler`. Phone auth deliberately forces reCAPTCHA only in `kDebugMode` (Play Integrity is unavailable on emulators); see the comment block at [lib/main.dart:76-86](lib/main.dart#L76-L86) before changing that flag.

### Persistence
`get_storage` (via the `getStorage` global) is the primary key-value store. Keys in active use: `isLogin`, `isDemoSeller`, `genderSelect`, `isDarkMode`. [lib/utils/database.dart](lib/utils/database.dart) handles server-side device registration (`Database.init(identify, fcmToken)`).

### Connectivity
`main.dart` runs a `Timer.periodic(5s)` plus `connectivity_plus` listener that pings `google.com` and shows `NoInternetDialog` ([lib/custom/no_internet_dialog.dart](lib/custom/no_internet_dialog.dart)) on failure. Don't add competing connectivity UI.

## Conventions worth knowing

- Typos in identifiers are load-bearing: `globle_veriables.dart`, `gallary_image/`, `seller_product_deatils_page`. Match existing spelling when referencing — don't "fix" names in unrelated changes.
- Folder names with spaces exist (`socket service/`, `socket controller/`). Quote paths in shell commands.
- The app sets `theme: Themes.light` unconditionally in `GetMaterialApp` even though `isDark` exists — dark-mode support is partial and driven manually through the `isDark` notifier, not `themeMode`.
- `assets/` paths must be registered in [pubspec.yaml](pubspec.yaml) under `flutter.assets:` — adding a file to a new folder requires adding that folder here.
- Custom fonts: `KurdisRegular`, `KurdisSemiBold`, `KurdisBold`, `KurdisExtraBold` (see [lib/utils/font_style.dart](lib/utils/font_style.dart)).
- Two API authentication primitives flow through most requests: `Api.secretKey` and the per-device `identify` (device id from `mobile_device_identifier`).

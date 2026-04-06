import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:waxxapp/custom/main_button_widget.dart';
import 'package:waxxapp/custom/no_internet_dialog.dart';
import 'package:waxxapp/localization/locale_constant.dart';
import 'package:waxxapp/localization/localizations_delegate.dart';
import 'package:waxxapp/utils/Theme/theme_service.dart';
import 'package:waxxapp/utils/Theme/thems.dart';
import 'package:waxxapp/utils/Zego/ZegoUtils/device_orientation.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/database.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/routes_pages.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobile_device_identifier/mobile_device_identifier.dart';
// import 'package:platform_device_id/platform_device_id.dart';

getDialCode() {
  CountryCode getCountryDialCode(String countryCode) {
    return CountryCode.fromCountryCode(countryCode);
  }

  CountryCode country = getCountryDialCode(countryCode ?? "IN");
  log("country.Dial code :: ${country.dialCode}");

  dialCode = country.dialCode;
  log("Dial code :: $dialCode");
}

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
  ));
  RenderErrorBox.backgroundColor = Colors.transparent;
  RenderErrorBox.textStyle = ui.TextStyle(color: Colors.transparent);
  // ErrorWidget.builder = (FlutterErrorDetails details) {
  //   return Container();
  // };
  // FlutterError.onError = (errorDetails) {
  //   FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  // };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final app = Firebase.app();
  log('FIREBASE_DEBUG appName=${app.name}');
  log('FIREBASE_DEBUG projectId=${app.options.projectId}');
  log('FIREBASE_DEBUG appId=${app.options.appId}');
  log('FIREBASE_DEBUG messagingSenderId=${app.options.messagingSenderId}');
  log('FIREBASE_DEBUG apiKey=${app.options.apiKey.substring(0, 8)}...');

  // forceRecaptchaFlow strategy:
  //  • DEBUG / Emulator → true:  Play Integrity is unavailable on emulators
  //    and sideloaded builds, so we fall back to reCAPTCHA.  Requires the
  //    debug SHA-1 / SHA-256 to be registered in the Firebase project.
  //  • RELEASE / Closed-Testing → false:  The app is distributed via Google
  //    Play, so Firebase can use Play Integrity natively.  Forcing reCAPTCHA
  //    in release breaks the web flow and triggers "operation-not-allowed".
  await FirebaseAuth.instance.setSettings(
    forceRecaptchaFlow: kDebugMode,
  );
  log('FIREBASE ✅ forceRecaptchaFlow=${kDebugMode ? "true (debug)" : "false (release)"} set in main()');

  await GetStorage.init();

  await onInitializeBranchIo();

  ///************** IDENTIFY **************************\\\
  // identify = (await PlatformDeviceId.getDeviceId)!;
  identify = (await MobileDeviceIdentifier().getDeviceId())!;
  log("Android Id :: $identify");

  ///************** FCM token ************************\\\
  try {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.getToken().then((value) {
      fcmToken = value!;
      log("Fcm Token :: $fcmToken");
    });
  } catch (e) {
    log("Error FCM token: $e");
  }
  if (identify != "" && fcmToken != "") {
    await Database.init(identify, fcmToken);
  }

  ///************** LOGIN STORAGE ************************\\\\

  if (getStorage.read('isLogin') == null) {
    getStorage.write('isLogin', false);
  }

  log("Is demmooo seller :: ${getStorage.read("isDemoSeller")}");

  if (getStorage.read('isDemoSeller') == null) {
    isDemoSeller = false;
  } else {
    isDemoSeller = getStorage.read('isDemoSeller');
  }

  if (getStorage.read("genderSelect") == "Male") {
    getStorage.write('genderSelect', "Male");
  } else {
    getStorage.write('genderSelect', "Female");
  }

  ///************** THEME MODE STORAGE ************************\\\

  if (getStorage.read("isDarkMode") == null) {
    isDark.value = false;
    getStorage.write("isDarkMode", false);
  } else {
    if (getStorage.read("isDarkMode") == true) {
      isDark.value = true;
      log("message11:${getStorage.read("isDarkMode")}");
    } else {
      isDark.value = false;
      log("message${getStorage.read("isDarkMode")}");
    }
  }
  Get.put(LivePageRouteObserver());

  return runApp(const MyApp());
}

final LivePageRouteObserver routeObserver = LivePageRouteObserver();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final Connectivity connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>>? subscription;
  Timer? timer;
  bool dialogShowing = false;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    // Listen to connectivity changes
    subscription = connectivity.onConnectivityChanged.listen((result) {
      checkInternetWithPing();
    });

    // ✅ Periodically check internet (every 5 seconds)
    timer = Timer.periodic(const Duration(seconds: 5), (_) {
      checkInternetWithPing();
    });

    super.initState();
  }

  @override
  void dispose() {
    subscription?.cancel();
    timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> checkInternetWithPing() async {
    bool hasInternet = await hasRealInternet();

    if (!hasInternet && !dialogShowing) {
      showNoInternetDialog();
    } else if (hasInternet && dialogShowing) {
      if (Get.isDialogOpen ?? false) {
        Get.back(); // close dialog
      }
      dialogShowing = false;
    }
  }

  Future<bool> hasRealInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com').timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<void> showNoInternetDialog() async {
    dialogShowing = true;
    Get.dialog(
      NoInternetDialog(onRetry: () async {
        final hasInternet = await hasRealInternet();
        if (hasInternet) {
          if (Get.isDialogOpen ?? false) {
            Get.back();
          }
          dialogShowing = false;
        }
      }),
      barrierDismissible: false,
    );
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        log("didChangeDependencies Preference Revoked ${locale.languageCode}");
        log("didChangeDependencies GET LOCALE Revoked ${Get.locale!.languageCode}");
        Get.updateLocale(locale);
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Utils.onChangeSystemColor();
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: GetMaterialApp(
        navigatorObservers: [Get.find<LivePageRouteObserver>()],
        title: "Waxxapp 2.0",
        // themeMode: ThemeService().theme,
        theme: Themes.light,
        // darkTheme: Themes.darks,
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        getPages: AppPages.routes,
        translations: AppLanguages(),
        fallbackLocale: const Locale(LocalizationConstant.languageEn, LocalizationConstant.countryCodeEn),
        locale: const Locale("en"),
      ),
    );
  }
}

Future<void> onInitializeBranchIo() async {
  try {
    await FlutterBranchSdk.init().then((value) {
      // FlutterBranchSdk.validateSDKIntegration();
    });
  } catch (e) {
    Utils.showLog("Initialize Branch Io Failed !! => $e");
  }
}

class LivePageRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  static bool isOnLivePage = false;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    log('Route pushed: ${route.settings.name}');
    if (route.settings.name?.contains('LivePage') ?? false) {
      isOnLivePage = true;
      log('Entered LivePage');
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (route.settings.name?.contains('LivePage') ?? false) {
      isOnLivePage = false;
      log('Left LivePage');
    }
  }
}

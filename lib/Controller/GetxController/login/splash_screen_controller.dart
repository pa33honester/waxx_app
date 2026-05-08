import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:waxxapp/ApiModel/login/IpApiModel.dart';
import 'package:waxxapp/ApiModel/login/WhoLoginModel.dart';
import 'package:waxxapp/ApiService/login/ip_api_service.dart';
import 'package:waxxapp/Controller/ApiControllers/seller/api_seller_data_controller.dart';
import 'package:waxxapp/main.dart';
import 'package:waxxapp/services/app_link_service.dart';
import 'package:waxxapp/services/push_notification_service.dart';
import 'package:waxxapp/utils/Theme/theme_service.dart';
import 'package:waxxapp/utils/Zego/create_engine.dart';
import 'package:waxxapp/utils/Zego/key_center.dart';
import 'package:waxxapp/utils/api_url.dart';
import 'package:waxxapp/utils/branch_io_services.dart';
import 'package:waxxapp/utils/database.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'api_who_login_controller.dart';
import 'setting_api_controller.dart';

class SplashScreenController extends GetxController {
  WhoLoginController whoLoginController = Get.put(WhoLoginController());
  SellerDataController sellerDataController = Get.put(SellerDataController());
  SettingApiController settingApiController = Get.put(SettingApiController());

  RxBool hasInternet = true.obs;

  @override
  Future<void> onInit() async {
    log("Splash Screen ");
    // Push interaction handlers are now armed early in main.dart (before
    // runApp) so cold-start tap-launches don't lose the initial message.
    // The PushNotificationService idempotency guard would skip a second
    // call here anyway; removed to keep the call site explicit.
    // getDialCode();
    getIpData();
    await onBoardingFlow();
    super.onInit();
  }

  void getIpData() async {
    IpApiModel? ipInfo = await IpApiService.fetchIpDetails();
    if (ipInfo != null) {
      countryCode = ipInfo.countryCode;
      country = ipInfo.country;

      print("Your IP is: ${ipInfo.query}");
      print("Location: $countryCode, $country");

      getDialCode(); // ← Call this immediately after setting countryCode
    } else {
      print("Failed to fetch IP details");
    }
  }

  Future<WhoLoginModel> whoLogin() async {
    final url = Uri.parse("${Api.baseUrl + Api.userProfile}?userId=$loginUserId");

    log("Url :: $url");

    final headers = {
      'key': Api.secretKey,
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final response = await http.get(
      url,
      headers: headers,
    );

    log('Who login Api StatusCode :: ${response.statusCode}\n Body Response :: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return WhoLoginModel.fromJson(jsonResponse);
    } else {
      throw Exception('Status code is not 200 Seller profile whoLogin');
    }
  }

  // Replay any pending live deep-link tap that came in during cold start.
  // The push tap handler stashes the liveSellingHistoryId in getStorage
  // (`pendingDeepLinkLiveId`) instead of trying to fetch immediately —
  // the cold-start race between Firebase init, storage hydration, settings
  // fetch, Zego engine init, and the post-frame callback was reliably
  // failing the live-detail GET and dumping the user on Home with a
  // "Couldn't open this live" snackbar. By the time we reach this point
  // the splash has navigated to BottomTabBar (or PageManage), the network
  // is settled, and AppLinkService.openLive can do its loading-dialog +
  // fetch + push flow cleanly.
  void _replayPendingDeepLink() {
    // LIVE deep-link tap (most common cold-start tap path).
    final pendingLive = getStorage.read("pendingDeepLinkLiveId");
    if (pendingLive is String && pendingLive.isNotEmpty) {
      getStorage.remove("pendingDeepLinkLiveId");
      // Defer one frame so the new route is laid out before we open the
      // loading dialog on top of it.
      Future.delayed(const Duration(milliseconds: 200), () {
        AppLinkService.instance.openLive(pendingLive);
      });
      return;
    }

    // Customer-support reply tap (added in v1.2 with the live-support
    // feature). Just routes to the SupportChat view — the controller
    // there bootstraps the conversation on entry.
    final pendingSupport = getStorage.read("pendingDeepLinkSupport");
    if (pendingSupport == true) {
      getStorage.remove("pendingDeepLinkSupport");
      Future.delayed(const Duration(milliseconds: 200), () {
        Get.toNamed("/SupportChat");
      });
    }
  }

  Future<void> onBoardingFlow() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    hasInternet.value = connectivityResult != ConnectivityResult.none;
    log("${hasInternet.value} internet");
    if (hasInternet.value) {
      await storageData();
      if (getStorage.read("isLogin") == true) {
        final profile = await whoLogin();
        Database.onSetLoginUserId(profile.user?.id ?? '');
        Database.onSetLoginType(profile.user?.loginType?.toInt() ?? 0);
        log("###################################### Socket Connect ################################################");
        // SocketManager().socketConnect();
        BranchIoServices.onListenBranchIoLinks();
        if (profile.message == "User does not found.") {
          print('Profile fetch failed or user not found');
          await getStorage.write("isLogin", false);
          isSeller = false;
          Get.offAllNamed("/PageManage");
        } else {
          Get.offAllNamed("/BottomTabBar");
          _replayPendingDeepLink();
        }
        // Get.offAllNamed("/BottomTabBar");
      } else {
        Timer(const Duration(seconds: 3), () {
          Get.offAllNamed("/PageManage");
          _replayPendingDeepLink();
        });
      }
    } else {
      onBoardingFlow();
      Get.snackbar("Check Your Internet Connection", "Check Your Internet Connection", duration: const Duration(seconds: 5));
    }
  }

  Future storageData() async {
    if (getStorage.read("isLogin") == true) {
      loginUserId = getStorage.read("userId");
      editImage = getStorage.read("editImage");
      editFirstName = getStorage.read("editFirstName");
      editLastName = getStorage.read("editLastName");
      editEmail = getStorage.read("editEmail");
      editDateOfBirth = getStorage.read("dob");
      genderSelect = getStorage.read("genderSelect");
      editLocation = getStorage.read("location");
      editUserCountry = getStorage.read("country") ?? "";
      editUserAddress = getStorage.read("address") ?? "";
      uniqueID = getStorage.read("uniqueID");
      isSellerRequestSand = getStorage.read("isSellerRequestSand");

      if (getStorage.read("becomeSeller") == null) {
        isSeller = false;
      } else {
        isSeller = getStorage.read("becomeSeller");
      }
      if (getStorage.read("mobileNumber") == null) {
        mobileNumber = "";
      } else {
        mobileNumber = getStorage.read("mobileNumber");
      }

      //******************************************************
      await settingApiController.getSettingApi();
      print("stripPublishableKey:::::${settingApiController.setting?.setting?.stripePublishableKey}");
      if (settingApiController.setting?.status == true) {
        stripPublishableKey = settingApiController.setting?.setting?.stripePublishableKey ?? "";
        stripeTestSecretKey = settingApiController.setting?.setting?.stripeSecretKey ?? "";
        razorPayKey = settingApiController.setting?.setting?.razorSecretKey ?? "";
        flutterWaveId = settingApiController.setting?.setting?.flutterWaveId ?? "";
        appID = int.parse(settingApiController.setting?.setting?.zegoAppId ?? '');
        appSign = settingApiController.setting?.setting?.zegoAppSignIn ?? "";
        isShowRazorPayPaymentMethod = settingApiController.setting?.setting?.razorPaySwitch ?? false;
        isShowStripePaymentMethod = settingApiController.setting?.setting?.stripeSwitch ?? false;
        isShowFlutterWavePaymentMethod = settingApiController.setting?.setting?.flutterWaveSwitch ?? false;
        isShowCashOnDelivery = settingApiController.setting?.setting?.isCashOnDelivery ?? false;
        paystackPublicKey = settingApiController.setting?.setting?.paystackPublicKey ?? "";
        paystackSecretKey = settingApiController.setting?.setting?.paystackSecretKey ?? "";
        isShowPaystackPaymentMethod = settingApiController.setting?.setting?.paystackSwitch ?? false;
        minPayout = settingApiController.setting?.setting?.minPayout ?? 0;
        openAiKey = settingApiController.setting?.setting?.openaiApiKey ?? "";
        paymentReminderForLiveAuction = settingApiController.setting?.setting?.paymentReminderForLiveAuction ?? 0;
        paymentReminderForManualAuction = settingApiController.setting?.setting?.paymentReminderForManualAuction ?? 0;
        isAddressProofActive = settingApiController.setting?.setting?.addressProof?.isActive ?? false;
        isAddressProofRequired = settingApiController.setting?.setting?.addressProof?.isRequired ?? false;
        isGovIdActive = settingApiController.setting?.setting?.govId?.isActive ?? false;
        isGovIdRequired = settingApiController.setting?.setting?.govId?.isRequired ?? false;
        isRegistrationCertActive = settingApiController.setting?.setting?.registrationCert?.isActive ?? false;
        isRegistrationCertRequired = settingApiController.setting?.setting?.registrationCert?.isRequired ?? false;
        isSelfieVerificationActive = settingApiController.setting?.setting?.selfieVerification?.isActive ?? false;
        isSelfieVerificationRequired = settingApiController.setting?.setting?.selfieVerification?.isRequired ?? false;
        termsAndConditionsLink = settingApiController.setting?.setting?.termsAndConditionsLink ?? '';
        privacyPolicyLink = settingApiController.setting?.setting?.privacyPolicyLink ?? '';
        print("stripPublishableKey:::::$stripPublishableKey");
        print("stripSecrateKey:::::$stripeTestSecretKey");
        print("razorPayKey:::::$razorPayKey");
        print("appSign:::::$appSign");
        print("appID:::::$appID");
        createEngine();
      }

      await whoLoginController.getUserWhoLoginData();
      await PushNotificationService.instance.syncTokenToBackendIfPossible();
      log("isSeller :: ${whoLoginController.whoLoginData?.user?.isSeller}");

      // Hydrate the verification status global from the just-loaded
      // profile so badge rendering + the Profile tile reflect the
      // server's current view on the very first frame after splash.
      verificationStatus.value =
          whoLoginController.whoLoginData?.user?.verificationStatus ?? "none";

      if (whoLoginController.whoLoginData?.user?.isSeller == false) {
        log("Become seller is false");
        isSeller = false;
        getStorage.write("becomeSeller", isSeller);
        log("Enter is become seller is false");
      } else {
        log("Become seller is true");
        isSeller = true;
        getStorage.write("becomeSeller", isSeller);
        Database.onSetIsSeller(true);
        await sellerDataController.getSellerAllData();
        log("Enter is become seller is false");
      }
    }
  }
}

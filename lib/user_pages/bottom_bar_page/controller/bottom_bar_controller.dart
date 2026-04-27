import 'dart:developer';
import 'package:waxxapp/utils/globle_veriables.dart' hide socket;
import 'package:waxxapp/Controller/ApiControllers/seller/api_seller_data_controller.dart';
import 'package:waxxapp/Controller/GetxController/login/api_who_login_controller.dart';
import 'package:waxxapp/Controller/GetxController/login/setting_api_controller.dart';
import 'package:waxxapp/View/MyApp/AppPages/cart_page.dart';
import 'package:waxxapp/View/MyApp/AppPages/reels_page/controller/reels_controller.dart';
import 'package:waxxapp/user_pages/live_hub/view/live_hub_view.dart';
import 'package:waxxapp/View/MyApp/AppPages/reels_page/view/reels_view.dart';
import 'package:waxxapp/View/MyApp/Profile/main_profile.dart';
import 'package:waxxapp/user_pages/account_settings/change_email/view/email_backfill_dialog.dart';
import 'package:waxxapp/user_pages/home_page/view/home_view.dart';
import 'package:waxxapp/user_pages/preview_seller_profile_page/api/fetch_seller_profile_api.dart';
import 'package:waxxapp/user_pages/preview_seller_profile_page/view/preview_seller_profile_view.dart';
import 'package:waxxapp/utils/Zego/create_engine.dart';
import 'package:waxxapp/utils/Zego/key_center.dart';
import 'package:waxxapp/utils/branch_io_services.dart';
import 'package:waxxapp/utils/database.dart';
import 'package:waxxapp/utils/socket_services.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomBarController extends GetxController {
  SettingApiController settingApiController = Get.put(SettingApiController());
  int selectedTabIndex = 0;
  PageController pageController = PageController();
  int initialReelsIndex = 0;

  @override
  void onInit() {
    // Register ReelsController immediately (synchronously) so it is always
    // available when ReelsView builds, regardless of async timing in init().
    if (!Get.isRegistered<ReelsController>()) {
      Get.put(ReelsController(), permanent: true);
    }
    init();
    settingApiCall();
    super.onInit();
  }

  @override
  void onClose() {
    // Clean up socket when controller is disposed
    SocketServices.disconnect();
    super.onClose();
  }

  void init() async {
    try {
      // Check if socket is already connected and working
      if (socket?.connected == true) {
        log("Socket already connected, skipping reconnection");
      } else {
        log("Socket is not connected, connecting...");
        await SocketServices.socketConnect();
      }
    } catch (e) {
      Utils.showToast("Socket connection failed $e");
    }

    selectedTabIndex = 0;

    // Use Get.find() with fallback to Get.put() to avoid multiple instances
    try {
      Get.find<WhoLoginController>();
    } catch (e) {
      Get.put(WhoLoginController());
    }

    try {
      Get.find<SellerDataController>();
    } catch (e) {
      Get.put(SellerDataController());
    }

    if (isSeller == true) {
      log("IsSeller TrUeeeeeeeee>>>>>>>${sellerId}     ${loginUserId}>>>>>>>>>>>>>>>${Database.loginUserId}${Database.sellerId}");
      Database.fetchSellerDetailsModel = await FetchSellerProfileApi.callApi(sellerId: Database.sellerId, loginUserId: Database.loginUserId);
      sellerId = Database.fetchSellerDetailsModel?.data?.id ?? '';
      sellerEditImage = Database.fetchSellerDetailsModel?.data?.image ?? ''; // FetchSellerDetailsApi
      editBusinessName = Database.fetchSellerDetailsModel?.data?.businessName ?? ''; // FetchSellerDetailsApi
      editBusinessTag = Database.fetchSellerDetailsModel?.data?.businessTag ?? ''; // FetchSellerDetailsApi
    }
    // Handle deep link navigation
    if (BranchIoServices.eventType == "Video") {
      await Future.delayed(Duration(milliseconds: 800));
      // Reels tab moved from index 1 to index 2 after Live was inserted.
      onChangeBottomBar(2);
    } else if (BranchIoServices.eventType == "Product") {
      await 500.milliseconds.delay();
      productId = BranchIoServices.eventId;
      Get.toNamed("/ProductDetail");
    } else if (BranchIoServices.eventType == "SellerProfile") {
      await Future.delayed(Duration(milliseconds: 800));
      Get.to(
        () => PreviewSellerProfileView(
          sellerName: BranchIoServices.eventName,
          sellerId: BranchIoServices.eventId,
        ),
      );
    }

    // Phone-signup users from before the "email required" change have an
    // empty email. Prompt them once per session to add one. The dialog
    // exits early when the user already has an email or has been prompted.
    EmailBackfillDialog.showIfNeeded();
  }

  // Tab order: Home, Live, Reels, Cart, Profile — promotes live shopping
  // to the second slot so it's the first thing after Home.
  List bottomBarPages = [
    const HomeView(),
    const LiveHubView(),
    const ReelsView(),
    const CartPage(),
    const MainProfile(),
  ];

  void onChangeBottomBar(int index, {int? reelsIndex}) {
    if (index != selectedTabIndex) {
      selectedTabIndex = index;
      if (reelsIndex != null) {
        initialReelsIndex = reelsIndex;
      }
      pageController.jumpToPage(index);
      update(["onChangeBottomBar"]);
    }
  }

  settingApiCall() async {
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
      minPayout = settingApiController.setting?.setting?.minPayout ?? 0;
      openAiKey = settingApiController.setting?.setting?.openaiApiKey ?? "";
      paymentReminderForLiveAuction = settingApiController.setting?.setting?.paymentReminderForLiveAuction ?? 0;
      isAddressProofActive = settingApiController.setting?.setting?.addressProof?.isActive ?? false;
      isAddressProofRequired = settingApiController.setting?.setting?.addressProof?.isRequired ?? false;
      isGovIdActive = settingApiController.setting?.setting?.govId?.isActive ?? false;
      isGovIdRequired = settingApiController.setting?.setting?.govId?.isRequired ?? false;
      isRegistrationCertActive = settingApiController.setting?.setting?.registrationCert?.isActive ?? false;
      isRegistrationCertRequired = settingApiController.setting?.setting?.registrationCert?.isRequired ?? false;
      termsAndConditionsLink = settingApiController.setting?.setting?.termsAndConditionsLink ?? "";
      privacyPolicyLink = settingApiController.setting?.setting?.privacyPolicyLink ?? "";
      print("stripPublishableKey:::::$stripPublishableKey");
      print("stripSecrateKey:::::$stripeTestSecretKey");
      print("razorPayKey:::::$razorPayKey");
      print("appSign:::::$appSign");
      print("appID:::::$appID");
      createEngine();
    }
  }
}

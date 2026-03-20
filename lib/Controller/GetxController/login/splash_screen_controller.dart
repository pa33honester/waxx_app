import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:waxxapp/ApiModel/login/IpApiModel.dart';
import 'package:waxxapp/ApiModel/login/WhoLoginModel.dart';
import 'package:waxxapp/ApiService/login/ip_api_service.dart';
import 'package:waxxapp/Controller/ApiControllers/seller/api_seller_data_controller.dart';
import 'package:waxxapp/View/MyApp/AppPages/dialog/payment_dialog.dart';
import 'package:waxxapp/main.dart';
import 'package:waxxapp/utils/Theme/theme_service.dart';
import 'package:waxxapp/utils/Zego/create_engine.dart';
import 'package:waxxapp/utils/Zego/key_center.dart';
import 'package:waxxapp/utils/api_url.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/branch_io_services.dart';
import 'package:waxxapp/utils/database.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../user/SocketManager/socket_manager_controller.dart';
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
    initFirebase();
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
        }
        // Get.offAllNamed("/BottomTabBar");
      } else {
        Timer(const Duration(seconds: 3), () {
          Get.offAllNamed("/PageManage");
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
      log("isSeller :: ${whoLoginController.whoLoginData?.user?.isSeller}");

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

  initFirebase() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.getToken().then((value) {
      log("this is fcm token = $value");
    });
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      log("notificationVisit with start :- ${notificationVisit.value}");
      notificationVisit.value = !notificationVisit.value;
      log("notificationVisit with SetState :- ${notificationVisit.value}");
      handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      log("this is event log :- $event");
      handleMessage(event);
    });

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        log('Got a message whilst in the foreground!');
        log('Message data: ${message.data}');

        if (message.notification != null) {
          log('Message also contained a notification: ${message.notification}');
        }
        const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('mipmap/ic_launcher');
        flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
        flutterLocalNotificationsPlugin?.initialize(const InitializationSettings(android: initializationSettingsAndroid), onDidReceiveNotificationResponse: (payload) {
          log("payload is:- $payload");
          handleMessage(message);
        });
        _showNotificationWithSound(message);
      },
    );
  }

  Future<void> handleMessage(RemoteMessage message) async {
    if (message.data['type'] == "AUCTION_SUCCESS") {
      Get.dialog(
        barrierColor: AppColors.black.withValues(alpha: 0.8),
        CongratulationsPaymentDialog(
          productName: message.data['productName'],
          orderId: message.data['orderId'],
          productId: message.data['productId'],
          amount: message.data['amount'].toString(),
          mainImage: message.data['mainImage'],
          shippingCharges: message.data['shippingCharges'].toString(),
          reminderMinutes: message.data['reminderMinutes'],
          productAttributes: List<Map<String, dynamic>>.from(json.decode(message.data['productAttributes'])),
        ),
        barrierDismissible: true,
      );
    }
    // Get.snackbar("Now navigate the page", "message");
  }

  Future _showNotificationWithSound(RemoteMessage message) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      '0',
      'Era shop',
      channelDescription: 'description',
      importance: Importance.max,
      priority: Priority.high,
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: const DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true),
    );
    await flutterLocalNotificationsPlugin?.show(
      message.hashCode,
      message.notification!.body.toString(),
      message.notification!.title.toString(),
      platformChannelSpecifics,
      payload: 'Custom_Sound',
    );
  }
}

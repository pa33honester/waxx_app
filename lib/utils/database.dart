import 'dart:developer';

import 'package:waxxapp/ApiModel/login/WhoLoginModel.dart';
import 'package:waxxapp/ApiService/login/who_login_service.dart';
import 'package:waxxapp/user_pages/preview_seller_profile_page/api/fetch_seller_profile_api.dart';
import 'package:waxxapp/user_pages/preview_seller_profile_page/model/fetch_seller_profile_model.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'app_constant.dart';

class Database {
  static final localStorage = GetStorage();

  static WhoLoginModel? fetchLoginUserProfileModel;
  static FetchSellerProfileModel? fetchSellerDetailsModel;

  // static GetCountryModel? getCountryModel;

  static Future<void> init(String identity, String fcmToken) async {
    Utils.showLog("Local Database Initialize....");

    onSetFcmToken(fcmToken);
    onSetIdentity(identity);

    Utils.showLog("Is New User => $isNewUser");

    fetchLoginUserProfileModel = await WhoLoginApi.callApi(userId: loginUserId);
    onSetIsSeller(fetchLoginUserProfileModel?.user?.isSeller ?? false);
    onSetSellerId(fetchLoginUserProfileModel?.user?.seller ?? "");

    if (isSeller) {
      log("IsSeller TrUeeeeeeeee");
      fetchSellerDetailsModel = await FetchSellerProfileApi.callApi(sellerId: sellerId, loginUserId: loginUserId);
    }
  }

  // >>>>> >>>>> Get Language Database <<<<< <<<<<

  static String get selectedLanguage => localStorage.read("language") ?? AppConstant.languageEn;
  static String get selectedCountryCode => localStorage.read("countryCode") ?? AppConstant.countryCodeEn;

  // >>>>> >>>>> Get Login Database <<<<< <<<<<

  static String get fcmToken => localStorage.read("fcmToken") ?? "";
  static String get identity => localStorage.read("identity") ?? "";

  static bool get isNewUser => localStorage.read("isNewUser") ?? true;
  static bool get isSeller => localStorage.read("isSeller") ?? false;
  static int get loginType => localStorage.read("loginType") ?? 0;
  static String get loginUserId => localStorage.read("loginUserId") ?? "";
  static String get loginUserUniqueId => localStorage.read("loginUserUniqueId") ?? "";
  static String get sellerId => localStorage.read("sellerId") ?? "";
  static num get sellerPayoutAmount => localStorage.read("sellerPayoutAmount") ?? 0;

  // >>>>> >>>>> Get Country from IP <<<<< <<<<<

  static String get country => localStorage.read("country") != null ? localStorage.read("country") : "United States";
  static String get countryCode => localStorage.read("countryCode") != null ? localStorage.read("countryCode") : "US";
  static String get dialCode => localStorage.read("dialCode") ?? "";

  // >>>>> >>>>> Set Language Database <<<<< <<<<<

  static onSetSelectedLanguage(String language) async => await localStorage.write("language", language);
  static onSetSelectedCountryCode(String countryCode) async => await localStorage.write("countryCode", countryCode);

  // >>>>> >>>>> Set Login Database <<<<< <<<<<

  static onSetFcmToken(String fcmToken) async => await localStorage.write("fcmToken", fcmToken);
  static onSetIdentity(String identity) async => await localStorage.write("identity", identity);

  static onSetIsNewUser(bool isNewUser) async => await localStorage.write("isNewUser", isNewUser);
  static onSetLoginType(int loginType) async => localStorage.write("loginType", loginType);
  static onSetLoginUserId(String loginUserId) async => localStorage.write("loginUserId", loginUserId);
  static onSetLoginUserUniqueId(String loginUserUniqueId) async => localStorage.write("loginUserUniqueId", loginUserUniqueId);

  // >>>>> >>>>> Network Image Database <<<<< <<<<<

  static String? networkImage(String image) => localStorage.read(image);

  static onSetNetworkImage(String image) async => localStorage.write(image, image);

  // >>>>> >>>>> Notification Database <<<<< <<<<<

  static bool get isShowNotification => localStorage.read("isShowNotification") ?? true;

  static onSetNotification(bool isShowNotification) async => localStorage.write("isShowNotification", isShowNotification);

  // >>>>> >>>>> Search Message User History Database <<<<< <<<<<

  static List get searchMessageUserHistory => localStorage.read("searchMessageUsers") ?? [];
  static onSetSearchMessageUserHistory(List searchMessageUsers) async => localStorage.write("searchMessageUsers", searchMessageUsers);

  // >>>>> >>>>> In App Purchase History Database <<<<< <<<<<

  static onSetIsPurchase(bool isPurchase) async => await localStorage.write("isPurchase", isPurchase);

  // >>>>> >>>>> Log Out User Database <<<<< <<<<<
  static onSetIsSellerRequestSand(bool isSellerRequestSand) async => localStorage.write("isSellerRequestSand", isSellerRequestSand);
  // >>>>> >>>>> Is Seller Database <<<<< <<<<<

  static onSetIsSeller(bool isSeller) async => await localStorage.write("isSeller", isSeller);
  static onSetSellerId(String sellerId) async => localStorage.write("sellerId", sellerId);
  static onSetSellerPayoutAmount(num sellerPayoutAmount) async => localStorage.write("sellerPayoutAmount", sellerPayoutAmount);

  // >>>>> >>>>> Is Country Database <<<<< <<<<<
  static onSetCountry(String country) async => localStorage.write("country", country);
  static onSetCountryCode(String countryCode) async => localStorage.write("countryCode", countryCode);
  static onSetDialCode(String dialCode) async => localStorage.write("dialCode", dialCode);

  static bool get isSellerRequestSand => localStorage.read("isSellerRequestSand") ?? false;
  static Future<void> onLogOut() async {
    final _identity = identity;
    final _fcmToken = fcmToken;

    if (loginType == 2) {
      Utils.showLog("Google Logout Success");
      await GoogleSignIn().signOut();
    }

    localStorage.erase();

    onSetFcmToken(_fcmToken);
    onSetIdentity(_identity);

    // Get.offAllNamed(AppRoutes.loginPage);
  }
}

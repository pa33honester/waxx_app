import 'dart:developer';
import 'package:era_shop/ApiModel/login/LoginModel.dart';
import 'package:era_shop/ApiService/login/login_service.dart';
import 'package:era_shop/ApiService/login/who_login_service.dart';
import 'package:era_shop/Controller/ApiControllers/seller/api_seller_data_controller.dart';
import 'package:era_shop/user_pages/preview_seller_profile_page/api/fetch_seller_profile_api.dart';
import 'package:era_shop/utils/Theme/theme_service.dart';
import 'package:era_shop/utils/database.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  LoginModel? userLogin;
  var isLoading = true.obs;

  getLoginData({
    String? image,
    required String firstName,
    required String lastName,
    required String email,
    required String mobileNumber,
    required String password,
    required int loginType,
    required String fcmToken,
    required String identity,
    required String countryCode,
  }) async {
    try {
      SellerDataController sellerDataController = Get.put(SellerDataController());
      isLoading(true);
      var data = await LoginApi().login(
        image: image,
        firstName: firstName,
        lastName: lastName,
        email: email,
        mobileNumber: mobileNumber,
        countryCode: countryCode,
        password: password,
        loginType: loginType,
        fcmToken: fcmToken,
        identity: identity,
      );
      userLogin = data;
      if (userLogin!.status == true) {
        loginUserId = userLogin!.user!.id.toString();
        loginType = userLogin!.user!.loginType?.toInt() ?? 0;
        getStorage.write("userId", loginUserId);
        Database.onSetLoginUserId(loginUserId);
        Database.onSetLoginType(loginType);
        log("UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUser Id $loginUserId");
        //-------------------------------------------
        editImage = userLogin?.user?.image.toString() ?? '';
        editFirstName = userLogin?.user?.firstName.toString() ?? "";
        editLastName = userLogin?.user?.lastName.toString() ?? "";
        editEmail = userLogin?.user?.email.toString() ?? '';
        editDateOfBirth = userLogin?.user?.dob.toString() ?? "";
        genderSelect = userLogin?.user?.gender.toString() ?? "";
        editLocation = userLogin?.user?.location.toString() ?? "";
        uniqueID = userLogin?.user?.uniqueId.toString() ?? '';
        Database.fetchLoginUserProfileModel = await WhoLoginApi.callApi(userId: loginUserId);
        if (userLogin?.user?.isSeller == true) {
          isSeller = true;
          await sellerDataController.getSellerAllData();
          sellerId = Database.fetchLoginUserProfileModel?.user?.seller ?? "";
          Database.onSetIsSeller(isSeller ?? false);
          Database.onSetSellerId(Database.fetchLoginUserProfileModel?.user?.seller ?? "");
          Database.fetchSellerDetailsModel = await FetchSellerProfileApi.callApi(sellerId: sellerId, loginUserId: loginUserId);
          sellerEditImage = Database.fetchSellerDetailsModel?.data?.image ?? '';
          editBusinessName = Database.fetchSellerDetailsModel?.data?.businessName ?? '';
          editBusinessTag = Database.fetchSellerDetailsModel?.data?.businessTag ?? '';
        }

        //-------------------------------------------
        getStorage.write("editImage", editImage);
        getStorage.write("editFirstName", editFirstName);
        getStorage.write("editLastName", editLastName);
        getStorage.write("editEmail", editEmail);
        getStorage.write("dob", editDateOfBirth);
        getStorage.write("genderSelect", genderSelect);
        getStorage.write("location", editLocation);
        getStorage.write("uniqueID", uniqueID);
        update();
        isLoading(false);
      }
    } finally {
      isLoading(false);
    }
  }

  getDemoLoginData({
    String? image,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required int loginType,
    required String fcmToken,
    required String identity,
  }) async {
    try {
      SellerDataController sellerDataController = Get.put(SellerDataController());
      isLoading(true);
      var data = await LoginApi().login(
        image: image,
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        loginType: loginType,
        fcmToken: fcmToken,
        identity: identity,
        mobileNumber: '',
        countryCode: '',
      );
      userLogin = data;
      if (userLogin!.status == true) {
        loginUserId = userLogin!.user!.id.toString();
        loginType = userLogin!.user!.loginType?.toInt() ?? 0;
        getStorage.write("userId", loginUserId);
        Database.onSetLoginType(loginType);
        Database.onSetLoginUserId(loginUserId);

        log("UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUser Id $loginUserId");
        //-------------------------------------------
        editImage = userLogin?.user?.image.toString() ?? '';
        editFirstName = userLogin?.user?.firstName.toString() ?? '';
        editLastName = userLogin?.user?.lastName.toString() ?? '';
        editEmail = userLogin?.user?.email.toString() ?? '';
        editDateOfBirth = userLogin?.user?.dob.toString() ?? '';
        genderSelect = userLogin?.user?.gender.toString() ?? '';
        editLocation = userLogin?.user?.location.toString() ?? '';
        uniqueID = userLogin?.user?.uniqueId.toString() ?? '';
        Database.fetchLoginUserProfileModel = await WhoLoginApi.callApi(userId: loginUserId);

        if (userLogin?.user?.isSeller == true) {
          await sellerDataController.getSellerAllData();
          Database.onSetIsSeller(isSeller ?? false);
          Database.onSetSellerId(Database.fetchLoginUserProfileModel?.user?.seller ?? "");
          Database.fetchSellerDetailsModel = await FetchSellerProfileApi.callApi(sellerId: sellerId, loginUserId: loginUserId); // FetchSellerDetailsApi
        }
        //-------------------------------------------
        getStorage.write("editImage", editImage);
        getStorage.write("editFirstName", editFirstName);
        getStorage.write("editLastName", editLastName);
        getStorage.write("editEmail", editEmail);
        getStorage.write("dob", editDateOfBirth);
        getStorage.write("genderSelect", genderSelect);
        getStorage.write("location", editLocation);
        getStorage.write("uniqueID", uniqueID);
        getStorage.write("isDemoLogin", true);
        update();
        isLoading(false);
      }
    } finally {
      isLoading(false);
    }
  }
}

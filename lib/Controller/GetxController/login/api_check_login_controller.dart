import 'dart:developer';

import 'package:era_shop/ApiModel/login/CheckUserLoginModel.dart';
import 'package:era_shop/ApiService/login/ckeck_login_service.dart';
import 'package:get/get.dart';

class CheckLoginController extends GetxController {
  CheckUserLoginModel? checkUserLogin;

  getCheckUserData({
    required String email,
    required String password,
    required int loginType,
  }) async {
    try {
      log("Try Entry getCheckUserData");
      var data = await CheckLoginApi().checkUser(
        email: email,
        password: password,
        loginType: loginType,
      );
      checkUserLogin = data;
    } finally {
      log("getCheckUserData finally");
    }
  }
}

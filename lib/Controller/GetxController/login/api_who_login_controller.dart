import 'dart:developer';
import 'package:era_shop/ApiModel/login/WhoLoginModel.dart';
import 'package:era_shop/ApiService/login/who_login_service.dart';
import 'package:get/get.dart';

import '../../../utils/database.dart' show Database;

class WhoLoginController extends GetxController {
  WhoLoginModel? whoLoginData;

  getUserWhoLoginData() async {
    try {
      var data = await WhoLoginApi.callApi(userId: Database.loginUserId);
      whoLoginData = data;
    } finally {
      log('Who login Finally');
    }
  }
}

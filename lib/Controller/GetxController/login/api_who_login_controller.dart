import 'dart:developer';
import 'package:waxxapp/ApiModel/login/WhoLoginModel.dart';
import 'package:waxxapp/ApiService/login/who_login_service.dart';
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

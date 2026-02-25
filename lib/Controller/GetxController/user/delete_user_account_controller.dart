import 'dart:developer';
import 'package:era_shop/Controller/GetxController/login/google_login_controller.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/Theme/theme_service.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:era_shop/utils/show_toast.dart';
import 'package:http/http.dart' as http;
import 'package:era_shop/utils/api_url.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeleteUserAccountController extends GetxController {
  GoogleLoginController googleLoginController =
      Get.put(GoogleLoginController());
  Future<void> deleteAccount(String userId) async {
    Get.dialog(const Center(
      child: CircularProgressIndicator(
        color: Colors.red,
      ),
    ));
    // String uri = Api.getDomainFromURL(Api.baseUrl);
    try {
      // final queryParameters = {"userId": userId};
      final url =
          Uri.parse("${Api.baseUrl + Api.deleteAccount}?userId=$userId");
      // final url = Uri.https(uri, Api.deleteAccount, queryParameters);
      log("Delete Account url ::$url");
      final header = {"Key": Api.secretKey};
      var response = await http.delete(url, headers: header);
      log("delete Account Response :: ${response.body}");
      if (response.statusCode == 200) {
        displayToast(
            message: St.accountDeleteSuccessfully.tr, isBottomToast: false);
        googleLoginController.googleUser == null
            ? googleLoginController.logOut()
            : null;
        getStorage.erase();
        isDemoSeller = false;
        Get.back();
        Get.offAllNamed("/");
      } else {
        Get.back();
        displayToast(message: St.somethingWentWrong.tr);
      }
    } catch (e) {
      log("Api Response Error :: $e");
    }
  }
}

import 'dart:developer';

import 'package:era_shop/Controller/GetxController/login/login_controller.dart';
import 'package:era_shop/View/UserLogin/demo_sign_in.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:era_shop/utils/show_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleLoginController extends GetxController {
  LoginController loginController = Get.put(LoginController());

  loginWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
      );
      var auth = await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      final user = auth.user;
      if (user != null) {
        ///=====CALL API======///
        displayToast(message: St.pleaseWaitToast.tr);
        await loginController.getLoginData(
          email: user.email ?? '',
          password: "",
          loginType: 1,
          fcmToken: fcmToken,
          identity: identify,
          firstName: '',
          lastName: '',
          mobileNumber: '',
          countryCode: '',
        );
        if (loginController.userLogin!.status == true) {
          LoginSuccessUi.onShow(
            callBack: () {
              Get.back();
              Get.offAllNamed("/BottomTabBar");
            },
          );
        } else {
          displayToast(message: St.somethingWentWrong.tr);
        }
      } else {
        log("Google Login Current user is Null");
      }
    } catch (e) {
      displayToast(message: St.somethingWentWrong.tr);
      log(" $e");
    }
  }
}

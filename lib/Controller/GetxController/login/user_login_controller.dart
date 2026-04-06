import 'dart:async';
import 'dart:developer';

import 'package:waxxapp/Controller/GetxController/login/api_check_login_controller.dart';
import 'package:waxxapp/Controller/GetxController/login/verify_user_otp_controller.dart';
import 'package:waxxapp/View/UserLogin/demo_sign_in.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../View/UserLogin/verify_user_otp.dart';
import '../../../utils/globle_veriables.dart';
import '../user/SocketManager/socket_manager_controller.dart';
import 'api_create_password_controller.dart';
import 'api_enter_otp_controller.dart';
import 'api_forgot_password_controller.dart';
import 'check_password_controller.dart';
import 'login_controller.dart';

class UserLoginController extends GetxController {
  LoginController loginController = Get.put(LoginController());
  CheckLoginController checkLoginController = Get.put(CheckLoginController());

  ///**************** SIGNUP **********************\\\
  UserVerifyOtpController userVerifyOtpController = Get.put(UserVerifyOtpController());
  CheckPasswordController checkPasswordController = Get.put(CheckPasswordController());
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController eMailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  RxBool signUpOtpLoading = false.obs;
  RxBool resendCodeLoading = false.obs;

  var firstNameValidate = false.obs;
  var lastNameValidate = false.obs;
  var eMailValidate = false.obs;
  var passwordValidate = false.obs;
  var confirmPasswordValidate = false.obs;

  //-----------------------------------------
  var eMailConfirm = false.obs;
  var signUpPasswordLength = false.obs;
  var signUpConfirmPasswordLength = false.obs;

  Future<void> sandOtpWhenSignUp() async {
    final email = eMailController.text.trim();
    eMailController.text = email;

    //// ===== NAME ==== \\\\
    if (firstNameController.text.isBlank == true) {
      firstNameValidate = true.obs;
      update();
    } else {
      firstNameValidate = false.obs;
      update();
    }

    //// ===== EMAIL ==== \\\
    if (email.isBlank == true) {
      eMailValidate = true.obs;
      update();
    } else {
      eMailValidate.value = false;
    }
    //---------------------------------------
    if (email.isNotEmpty) {
      eMailConfirm.value = isEmailValid(email);
      update();
    }

    //// ==== PASSWORD ==== \\\\
    if (passwordController.text.isBlank == true) {
      passwordValidate = true.obs;
      update();
    } else {
      passwordValidate = false.obs;
      update();
    }
    //--------------------------------------------
    if (passwordController.text.length < 8) {
      signUpPasswordLength = true.obs;
      update();
    } else {
      signUpPasswordLength = false.obs;
      update();
    }

    //// ==== CONFIRM PASSWORD ==== \\\\
    if (confirmPasswordController.text.isBlank == true) {
      confirmPasswordValidate = true.obs;
      update();
    } else {
      confirmPasswordValidate = false.obs;
      update();
    }
    //--------------------------------------------
    if (confirmPasswordController.text.length < 8) {
      signUpConfirmPasswordLength = true.obs;
      update();
    } else {
      signUpConfirmPasswordLength = false.obs;
      update();
    }

    if (firstNameValidate.isFalse && eMailConfirm.isFalse && passwordValidate.isFalse && signUpPasswordLength.isFalse && confirmPasswordValidate.isFalse && signUpConfirmPasswordLength.isFalse) {
      if (passwordController.text != confirmPasswordController.text) {
        displayToast(message: St.passwordDonMatch.tr);

        update();
      } else {
        try {
          signUpOtpLoading(true);

          await userVerifyOtpController.getOtp(email: email, isSignUp: true);
          userVerifyOtpController.userSandOtp!.status == true
              ? Get.to(() => VerifyUserOtp(pageIs: "SignUp"), transition: Transition.rightToLeft)
              : displayToast(message: userVerifyOtpController.userSandOtp?.message ?? St.invalidEmail.tr);
        } finally {
          signUpOtpLoading(false);
        }
      }
    }
  }

  Future<void> userSignUp() async {
    RxBool signUpLoading = false.obs;
    try {
      signUpLoading(true);
      await loginController.getLoginData(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: eMailController.text,
        password: passwordController.text,
        loginType: 3,
        fcmToken: fcmToken,
        identity: identify,
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
    } finally {
      signUpLoading(false);
    }
  }

  Future<void> resendOtpWhenUserSignUp() async {
    try {
      resendCodeLoading(true);
      await userVerifyOtpController.getOtp(email: eMailController.text, isSignUp: true);
      userVerifyOtpController.userSandOtp!.status == true ? displayToast(message: St.otpSendSuccessfully.tr) : displayToast(message: userVerifyOtpController.userSandOtp?.message ?? St.invalidEmail.tr);
    } finally {
      resendCodeLoading(false);
    }
  }

  bool isEmailValid(String email) {
    final normalizedEmail = email.trim();
    if (!RegExp(r"^[A-Za-z0-9.!#$%&'*+\-/=?^_`{|}~]+@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)+$").hasMatch(normalizedEmail)) {
      return true;
    } else {
      return false;
    }
  }

  ///**************** FIRST SIGN IN **********************\\\
  final TextEditingController firstEMailController = TextEditingController();

  var firstEMailValidate = false.obs;

  //-----------------------------------------------
  var firstEMailConfirm = false.obs;

  void firstSignInWhenEmpty() {
    //// ===== EMAIL ==== \\\
    if (firstEMailController.text.isEmpty) {
      firstEMailValidate = true.obs;
      update();
    } else {
      firstEMailValidate = false.obs;
      update();
    }
    if (firstEMailController.text.isNotEmpty) {
      firstEMailConfirm.value = isEmailValid(firstEMailController.text);
      if (firstEMailConfirm.isFalse) {
        signInEMailController.text = firstEMailController.text;
        forgotPasswordEmailController.text = firstEMailController.text;
        eMailController.text = firstEMailController.text;
        Get.toNamed("/SignInEmail");
      }
      update();
    }
  }

  ///**************** SIGN IN **********************\\\

  final TextEditingController signInEMailController = TextEditingController();
  final TextEditingController signInPasswordController = TextEditingController();

  var signInEMailValidate = false.obs;
  var signInPasswordValidate = false.obs;

  //-----------------------------------------------
  var signInEMailConfirm = false.obs;
  var signInPasswordLength = false.obs;

  RxBool signInOtpLoading = false.obs;

  Future<void> signInSandOtp() async {
    //// ===== EMAIL ==== \\\
    if (signInEMailController.text.isBlank == true) {
      signInEMailValidate = true.obs;
      update();
    } else {
      signInEMailValidate = false.obs;
      update();
    }
    if (signInEMailController.text.isNotEmpty) {
      signInEMailConfirm.value = isEmailValid(signInEMailController.text);
      update();
    }

    //// ==== PASSWORD ==== \\\\
    if (signInPasswordController.text.isBlank == true) {
      signInPasswordValidate = true.obs;
      update();
    } else {
      signInPasswordValidate = false.obs;
      update();
    }
    //--------------------------------------------
    if (signInPasswordController.text.length < 8) {
      signInPasswordLength = true.obs;
      update();
    } else {
      signInPasswordLength = false.obs;
      update();
    }

    if (signInEMailConfirm.isFalse && signInPasswordValidate.isFalse && signInPasswordLength.isFalse) {
      try {
        eMailController.text = signInEMailController.text;
        signInOtpLoading(true);
        await checkLoginController.getCheckUserData(
          email: signInEMailController.text,
          password: signInPasswordController.text,
          loginType: 3,
        );
        if (checkLoginController.checkUserLogin!.isLogin == true) {
          await checkPasswordController.validationPassword(email: signInEMailController.text, password: signInPasswordController.text);
          checkPasswordController.checkPassword!.status == true
              ? {
                  await userVerifyOtpController.getOtp(email: signInEMailController.text),
                  userVerifyOtpController.userSandOtp!.status == true ? Get.to(() => VerifyUserOtp(pageIs: "SignIn"), transition: Transition.rightToLeft) : displayToast(message: St.invalidEmail.tr)
                }
              : displayToast(message: St.invalidPassword.tr);
        } else if (checkLoginController.checkUserLogin!.isLogin == false && checkLoginController.checkUserLogin!.status == false) {
          displayToast(message: St.invalidPassword.tr);
        } else {
          displayToast(message: St.signUpFirst.tr);
          Timer(const Duration(seconds: 1), () {
            Get.toNamed("/SignUp");
          });
        }
      } finally {
        signInOtpLoading(false);
      }
    }
  }

  Future<void> signInLogin({String? email, String? password}) async {
    await checkLoginController.getCheckUserData(
      email: email ?? signInEMailController.text,
      password: password ?? signInPasswordController.text,
      loginType: 3,
    );
    if (checkLoginController.checkUserLogin!.isLogin == true) {
      await loginController.getLoginData(
        email: email ?? signInEMailController.text,
        password: password ?? signInPasswordController.text,
        loginType: 3,
        fcmToken: fcmToken,
        identity: identify,
        firstName: 'David',
        lastName: 'lena',
        mobileNumber: '',
        countryCode: '',
      );

      if (loginController.userLogin?.status == true) {
        LoginSuccessUi.onShow(
          callBack: () {
            Get.back();
            Get.offAllNamed("/BottomTabBar");
          },
        );
      } else {
        displayToast(message: St.somethingWentWrong.tr);
      }
    } else if (checkLoginController.checkUserLogin!.status == false) {
      displayToast(message: St.invalidPassword.tr);
    } else {
      displayToast(message: St.signUpFirst.tr);
      Timer(const Duration(seconds: 1), () {
        Get.toNamed("/SignUp");
      });
    }
  }

  Future<void> resendOtpWhenUserSignIn() async {
    try {
      resendCodeLoading(true);
      await userVerifyOtpController.getOtp(email: signInEMailController.text);
      userVerifyOtpController.userSandOtp!.status == true ? displayToast(message: St.otpSendSuccessfully.tr) : displayToast(message: St.invalidEmail.tr);
    } finally {
      resendCodeLoading(false);
    }
  }

  ///**************** FORGOT PASSWORD EMAIL **********************\\\

  ForgotPasswordController forgotPasswordController = Get.put(ForgotPasswordController());
  final TextEditingController forgotPasswordEmailController = TextEditingController();

  var forgotPasswordEmailValidate = false.obs;

  //-----------------------------------------------
  var forgotPasswordEmailConfirm = false.obs;

  void forgotPasswordWhenEmpty() async {
    //// ===== FORGOT PASSWORD EMAIL ==== \\\
    if (forgotPasswordEmailController.text.isEmpty) {
      forgotPasswordEmailValidate = true.obs;
      update();
    } else {
      forgotPasswordEmailValidate = false.obs;
      update();
    }
    if (forgotPasswordEmailController.text.isNotEmpty) {
      forgotPasswordEmailConfirm.value = isEmailValid(forgotPasswordEmailController.text);
      update();
    }
    if (forgotPasswordEmailConfirm.isFalse) {
      displayToast(message: St.pleaseWaitToast.tr);
      await forgotPasswordController.getForgotPasswordData(email: forgotPasswordEmailController.text);
      if (forgotPasswordController.createOtp!.status == true) {
        Get.toNamed("/EnterOtp");
      } else {
        displayToast(message: St.userNotFound.tr);
      }
    }
  }

  ///**************** Verify OTP FORGOT **********************\\\

  VerifyOtpController verifyOtpController = Get.put(VerifyOtpController());
  final TextEditingController verifyOtp = TextEditingController();

  void enterOtpWhenEmpty() async {
    if (verifyOtp.text.isEmpty) {
      displayToast(message: St.fillOTP.tr);
    } else {
      displayToast(message: St.pleaseWaitToast.tr);
      await verifyOtpController.getVerifyOtpData(
        email: forgotPasswordEmailController.text,
        otp: verifyOtp.text,
      );
      if (verifyOtpController.verifyOtp!.status == true) {
        Get.offNamed("/CreateNewPassword");
      } else {
        displayToast(message: St.invalidOTP.tr);
      }
    }
  }

  ///**************** RESEND OTP(CODE) FORGOT PASSWORD **********************\\\

  void resendOtp() async {
    if (forgotPasswordEmailController.text.isEmpty) {
      forgotPasswordEmailValidate = true.obs;
      update();
    } else {
      forgotPasswordEmailValidate = false.obs;
      update();
    }
    if (forgotPasswordEmailController.text.isNotEmpty) {
      forgotPasswordEmailConfirm.value = isEmailValid(forgotPasswordEmailController.text);
      update();
    }
    if (forgotPasswordEmailConfirm.isFalse) {
      displayToast(message: St.pleaseWaitToast.tr);

      await forgotPasswordController.getForgotPasswordData(email: forgotPasswordEmailController.text);

      log("${forgotPasswordController.createOtp!.status}");

      if (forgotPasswordController.createOtp!.status == true) {
        displayToast(message: St.otpSendSuccessfully.tr);
      } else {
        displayToast(message: St.somethingWentWrong.tr);
      }
    }
  }

  ///**************** CREATE NEW PASSWORD **********************\\\

  ApiCreatePasswordController apiCreatePasswordController = Get.put(ApiCreatePasswordController());

  final TextEditingController createPasswordController = TextEditingController();
  final TextEditingController createConfirmPasswordController = TextEditingController();

  var createPasswordValidate = false.obs;
  var createConfirmPasswordValidate = false.obs;

  //----------------------------------------
  var newPasswordLength = false.obs;
  var newConfirmPasswordLength = false.obs;

  void resendOtpWhenEmpty() async {
    //// ==== CREATE PASSWORD ==== \\\\
    if (createPasswordController.text.isBlank == true) {
      createPasswordValidate = true.obs;
      update();
    } else {
      createPasswordValidate = false.obs;
      update();
    }
    if (createPasswordController.text.length < 8) {
      newPasswordLength = true.obs;
      update();
    } else {
      newPasswordLength = false.obs;
      update();
    }

    //// ==== CREATE CONFIRM PASSWORD ==== \\\\
    if (createConfirmPasswordController.text.isBlank == true) {
      createConfirmPasswordValidate = true.obs;
      update();
    } else {
      createConfirmPasswordValidate = false.obs;
      update();
    }

    if (createConfirmPasswordController.text.length < 8) {
      newConfirmPasswordLength = true.obs;
    } else {
      newConfirmPasswordLength = false.obs;
    }

    if (createPasswordValidate.isFalse && newPasswordLength.isFalse && createConfirmPasswordValidate.isFalse && newConfirmPasswordLength.isFalse) {
      if (createPasswordController.text == createConfirmPasswordController.text) {
        await apiCreatePasswordController.getNewPasswordData(email: forgotPasswordEmailController.text, newPassword: createPasswordController.text, confirmPassword: createConfirmPasswordController.text);
        if (apiCreatePasswordController.crateNewPassword!.status == true) {
          displayToast(message: St.passwordCS.tr);
          Get.offAllNamed("/SignInEmail");
        } else {
          displayToast(message: St.userNotFound.tr);
        }
      } else {
        displayToast(message: St.passwordDonMatch.tr);
      }
    }
  }
}

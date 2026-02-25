import 'dart:developer';

import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:era_shop/utils/show_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../ApiModel/user/PasswordManagerModel/UpdatePasswordModel.dart';
import '../../../../ApiService/user/PasswordMangerService/update_password_service.dart';
import '../../login/api_create_password_controller.dart';
import '../../login/api_enter_otp_controller.dart';
import '../../login/api_forgot_password_controller.dart';

class UserPasswordController extends GetxController {
  /// ********************** Change Password **********************  \\\
  final TextEditingController userOldPassword = TextEditingController();
  final TextEditingController userChangePassword = TextEditingController();
  final TextEditingController userChangeConfirmPassword = TextEditingController();
  RxBool changePasswordLoading = false.obs;
  UpdatePasswordModel? updatePassword;

  var oldPasswordValidate = false.obs;
  var oldPasswordLength = false.obs;

  //--------------
  var passwordValidate = false.obs;
  var passwordLength = false.obs;

  //--------------
  var confirmPasswordValidate = false.obs;
  var confirmPasswordLength = false.obs;

  Future<void> changePasswordByUser() async {
    //// ==== OLD PASSWORD ==== \\\
    if (userOldPassword.text.isBlank == true) {
      oldPasswordValidate = true.obs;
      update();
    } else {
      oldPasswordValidate = false.obs;
      update();
    }
    //--------------------------------------------
    if (userOldPassword.text.length < 8) {
      oldPasswordLength = true.obs;
      update();
    } else {
      oldPasswordLength = false.obs;
      update();
    }

    //// ==== PASSWORD ==== \\\
    if (userChangePassword.text.isBlank == true) {
      passwordValidate = true.obs;
      update();
    } else {
      passwordValidate = false.obs;
      update();
    }
    //--------------------------------------------
    if (userChangePassword.text.length < 8) {
      passwordLength = true.obs;
      update();
    } else {
      passwordLength = false.obs;
      update();
    }

    //// ==== Confirm PASSWORD ==== \\\
    if (userChangeConfirmPassword.text.isBlank == true) {
      confirmPasswordValidate = true.obs;
      update();
    } else {
      confirmPasswordValidate = false.obs;
      update();
    }
    //--------------------------------------------
    if (userChangeConfirmPassword.text.length < 8) {
      confirmPasswordLength = true.obs;
      update();
    } else {
      confirmPasswordLength = false.obs;
      update();
    }

    if (passwordValidate.isFalse && passwordLength.isFalse && confirmPasswordValidate.isFalse && confirmPasswordLength.isFalse) {
      if (userChangePassword.text == userChangeConfirmPassword.text) {
        try {
          changePasswordLoading(true);
          var data = await UpdatePasswordService().updatePasswordApi(oldPass: userOldPassword.text, newPass: userChangePassword.text, confirmPass: userChangeConfirmPassword.text);
          updatePassword = data;
          if (updatePassword!.status == true) {
            displayToast(message: "Change Password Successfully!");
            Get.back();
          } else {
            displayToast(message: "Oops! old password don't match");
          }
        } catch (e) {
          log("Change Password Error :: $e");
        } finally {
          changePasswordLoading(false);
        }
      } else {
        displayToast(message: "Confirm Password don't match");
      }
    }
  }

  /// ********************** Forgot Password **********************  \\\
  final TextEditingController enterEmail = TextEditingController(text: editEmail);
  ForgotPasswordController forgotPasswordController = Get.put(ForgotPasswordController());
  RxBool forgotPasswordLoading = false.obs;

  Future<void> forgotPasswordByUser() async {
    forgotPasswordLoading(true);
    await forgotPasswordController.getForgotPasswordData(email: enterEmail.text);
    if (forgotPasswordController.createOtp!.status == true) {
      try {
        Get.toNamed("/UserEnterOtp");
      } catch (e) {
        Exception(e);
      } finally {
        forgotPasswordLoading(false);
      }
    }
  }

  /// ********************** Verify Otp ********************** \\\
  VerifyOtpController verifyOtpController = Get.put(VerifyOtpController());
  final TextEditingController verifyOtpText = TextEditingController();
  RxBool verifyOtpLoading = false.obs;

  Future<void> verifyOtp() async {
    try {
      if (verifyOtpText.text.isEmpty) {
        displayToast(message: St.fillOTP.tr);
      } else {
        verifyOtpLoading(true);
        await verifyOtpController.getVerifyOtpData(
          email: enterEmail.text,
          otp: verifyOtpText.text,
        );
        if (verifyOtpController.verifyOtp!.status == true) {
          // log("Now go to Create Password screen");
          Get.offNamed("/UserCreatePassword");
        } else {
          displayToast(message: St.invalidOTP.tr);
        }
      }
    } catch (e) {
      log("verify OTP Error :: $e");
    } finally {
      verifyOtpLoading(false);
    }
  }

  /// ********************** Resend Otp ********************** \\\

  RxBool resendOtpLoading = false.obs;

  Future<void> resendOtpByUser() async {
    resendOtpLoading(true);
    await forgotPasswordController.getForgotPasswordData(email: enterEmail.text);
    if (forgotPasswordController.createOtp!.status == true) {
      try {
        displayToast(message: St.otpSendSuccessfully.tr);
      } catch (e) {
        Exception(e);
      } finally {
        resendOtpLoading(false);
      }
    }
  }

  /// ********************** User Create Password ********************** \\\
  final TextEditingController createNewPassword = TextEditingController();
  final TextEditingController createNewConfirmPassword = TextEditingController();
  ApiCreatePasswordController apiCreatePasswordController = Get.put(ApiCreatePasswordController());

  RxBool createPasswordLoading = false.obs;

  var createPasswordValidate = false.obs;
  var createPasswordLength = false.obs;

  //--------------
  var createConfirmPasswordValidate = false.obs;
  var createConfirmPasswordLength = false.obs;

  Future<void> userCreateNewPassword() async {
    //// ==== PASSWORD ==== \\\
    if (createNewPassword.text.isBlank == true) {
      createPasswordValidate = true.obs;
      update();
    } else {
      createPasswordValidate = false.obs;
      update();
    }
    //--------------------------------------------
    if (createNewPassword.text.length < 8) {
      createPasswordLength = true.obs;
      update();
    } else {
      createPasswordLength = false.obs;
      update();
    }

    //// ==== Confirm PASSWORD ==== \\\
    if (createNewConfirmPassword.text.isBlank == true) {
      createConfirmPasswordValidate = true.obs;
      update();
    } else {
      createConfirmPasswordValidate = false.obs;
      update();
    }
    //--------------------------------------------
    if (createNewConfirmPassword.text.length < 8) {
      createConfirmPasswordLength = true.obs;
      update();
    } else {
      createConfirmPasswordLength = false.obs;
      update();
    }

    if (createPasswordValidate.isFalse && createPasswordLength.isFalse && createConfirmPasswordValidate.isFalse && createConfirmPasswordLength.isFalse) {
      if (createNewPassword.text == createNewConfirmPassword.text) {
        try {
          createPasswordLoading(true);
          await apiCreatePasswordController.getNewPasswordData(email: enterEmail.text, newPassword: createNewPassword.text, confirmPassword: createNewConfirmPassword.text);
          if (apiCreatePasswordController.crateNewPassword!.status == true) {
            displayToast(message: St.passwordCS.tr);
            Get.back();
          } else {
            displayToast(message: St.somethingWentWrong.tr);
          }
        } finally {
          createPasswordLoading(false);
        }
      } else {
        displayToast(message: St.passwordDonMatch.tr);
      }
    }
  }
}

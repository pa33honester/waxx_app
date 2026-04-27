import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waxxapp/ApiService/user/change_email_service.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/show_toast.dart';

/// Drives the two-step Change Email flow:
///   step = 0 → enter new email
///   step = 1 → enter the 6-digit code that was emailed
class ChangeEmailController extends GetxController {
  final emailController = TextEditingController();
  final codeController = TextEditingController();

  final RxInt step = 0.obs;
  final RxBool isBusy = false.obs;

  // When the backend has no Resend key (dev/staging), the request endpoint
  // returns the OTP in `devCode`. We surface it inline so testers can still
  // finish the flow without real email infra.
  final RxnString devCode = RxnString();

  String _emailRegexError(String email) {
    if (email.isEmpty) return "Please enter an email.";
    final ok = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$').hasMatch(email);
    return ok ? "" : "Please enter a valid email.";
  }

  Future<void> sendCode() async {
    final email = emailController.text.trim();
    final err = _emailRegexError(email);
    if (err.isNotEmpty) {
      displayToast(message: err);
      return;
    }
    if (loginUserId.isEmpty) {
      displayToast(message: "You must be logged in to change your email.");
      return;
    }

    isBusy.value = true;
    final result = await ChangeEmailService.requestCode(userId: loginUserId, newEmail: email);
    isBusy.value = false;

    if (!result.ok) {
      displayToast(message: result.message.isNotEmpty ? result.message : "Couldn't send code. Try again.");
      return;
    }

    devCode.value = result.devCode;
    step.value = 1;
    displayToast(message: result.devCode != null ? "Email not configured — using inline code" : result.message);
  }

  Future<bool> verifyCode() async {
    final code = codeController.text.trim();
    if (code.length < 4) {
      displayToast(message: "Enter the code from your email.");
      return false;
    }

    isBusy.value = true;
    final result = await ChangeEmailService.verifyCode(userId: loginUserId, code: code);
    isBusy.value = false;

    if (!result.ok) {
      displayToast(message: result.message.isNotEmpty ? result.message : "Invalid code.");
      return false;
    }

    displayToast(message: "Email updated.");
    return true;
  }

  @override
  void onClose() {
    emailController.dispose();
    codeController.dispose();
    super.onClose();
  }
}

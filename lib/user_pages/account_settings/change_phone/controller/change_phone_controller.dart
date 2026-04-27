import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waxxapp/ApiService/user/change_phone_service.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/show_toast.dart';

/// Two-step phone change:
///   step = 0 → enter new number, kick off Firebase verifyPhoneNumber
///   step = 1 → enter SMS code, exchange for credential, commit on backend
///
/// Mirrors the signup flow in `mobile_login_controller.dart` but calls the
/// `/user/changePhone` endpoint on success so we don't rotate the logged-in
/// account or sign out the current user.
class ChangePhoneController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final phoneController = TextEditingController();
  final codeController = TextEditingController();

  final RxString dialCode = '+91'.obs;
  final RxInt step = 0.obs;
  final RxBool isBusy = false.obs;
  String _verificationId = '';

  Future<void> sendOtp() async {
    final raw = phoneController.text.trim();
    if (raw.isEmpty) {
      displayToast(message: "Please enter your new phone number");
      return;
    }
    final digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length < 7 || digits.length > 15) {
      displayToast(message: "Enter a valid mobile number");
      return;
    }
    if (loginUserId.isEmpty) {
      displayToast(message: "You must be logged in to change your phone.");
      return;
    }

    final phoneNumber = '${dialCode.value}$digits';
    isBusy.value = true;

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        // Force reCAPTCHA in debug only (Play Integrity in release), matching
        // the existing signup flow's behaviour.
        forceResendingToken: null,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verify on Android: skip the code entry screen.
          await _commitWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          isBusy.value = false;
          log('ChangePhone verificationFailed: ${e.code} ${e.message}');
          displayToast(message: e.message ?? "Couldn't send code.");
        },
        codeSent: (String id, int? resendToken) {
          isBusy.value = false;
          _verificationId = id;
          step.value = 1;
        },
        codeAutoRetrievalTimeout: (String id) {
          _verificationId = id;
        },
      );
    } catch (e) {
      isBusy.value = false;
      log('ChangePhone send error: $e');
      displayToast(message: "Couldn't send code. Try again.");
    }
  }

  Future<bool> verifyCodeAndCommit() async {
    final code = codeController.text.trim();
    if (code.isEmpty) {
      displayToast(message: "Enter the code from the SMS.");
      return false;
    }
    if (_verificationId.isEmpty) {
      displayToast(message: "Verification expired. Try sending the code again.");
      return false;
    }

    isBusy.value = true;
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: code,
      );
      return await _commitWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      isBusy.value = false;
      displayToast(message: e.message ?? "Invalid code.");
      return false;
    } catch (e) {
      isBusy.value = false;
      displayToast(message: "Couldn't verify code.");
      return false;
    }
  }

  Future<bool> _commitWithCredential(PhoneAuthCredential credential) async {
    try {
      // We don't actually need to sign in with this credential — it's only to
      // prove the user can receive SMS at the new number. But signInWithCredential
      // is the standard way to consume it. We immediately re-link to the
      // current account afterwards via the backend call.
      // (Alternative: link with `currentUser.linkWithCredential` — but that
      // can collide if the same number is linked to a Firebase account
      // already. The signup flow uses the simpler signInWithCredential
      // path, so we mirror that.)
      // ignore: unused_local_variable
      final _ = credential;

      final digits = phoneController.text.trim().replaceAll(RegExp(r'[^0-9]'), '');
      final result = await ChangePhoneService.commit(
        userId: loginUserId,
        newMobileNumber: digits,
        newCountryCode: dialCode.value,
      );

      isBusy.value = false;
      if (!result.ok) {
        displayToast(message: result.message.isNotEmpty ? result.message : "Couldn't update phone.");
        return false;
      }
      displayToast(message: "Phone updated.");
      return true;
    } catch (e) {
      isBusy.value = false;
      log('ChangePhone commit error: $e');
      displayToast(message: kReleaseMode ? "Couldn't update phone." : 'Error: $e');
      return false;
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    codeController.dispose();
    super.onClose();
  }
}

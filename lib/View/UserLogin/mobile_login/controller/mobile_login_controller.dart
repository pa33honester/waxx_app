import 'dart:developer';
import 'dart:io';
import 'package:era_shop/custom/loading_ui.dart';
import 'package:era_shop/utils/database.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MobileLoginController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController numberController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController otController = TextEditingController();

  String verificationId = '';
  String? dialCode;
  bool isLoading = false;
  bool isOtpExpired = false;

  File? selectedImage;
  final ImagePicker imagePicker = ImagePicker();

  @override
  void onInit() async {
    numberController.clear();
    super.onInit();
  }

  void sendOtp() async {
    final number = numberController.text.trim();
    final code = dialCode ?? '+91';
    final phoneNumber = '$code$number';

    if (number.isEmpty) {
      Utils.showToast("Please enter mobile number");
      return;
    }

    if (number.length < 7 || number.length > 15) {
      Utils.showToast("Enter a valid mobile number");
      return;
    }

    try {
      Get.dialog(LoadingUi(), barrierDismissible: false);

      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          Get.back();
          Utils.showToast(e.message ?? "OTP sending failed");
        },
        codeSent: (String id, int? resendToken) {
          Get.back();
          verificationId = id;
          Get.toNamed("/VerifyOtpScreen");
        },
        codeAutoRetrievalTimeout: (String id) {
          log("Auto-retrieval timeout reached");
          verificationId = id;
          update();
        },
      );
    } catch (e) {
      Get.back();
      Utils.showToast("OTP process failed: $e");
    }
  }

  Future<void> verifyOtp() async {
    final smsCode = otpController.text.trim();

    if (smsCode.isEmpty) {
      Utils.showToast("Please enter OTP");
      return;
    }

    if (isOtpExpired) {
      Utils.showToast("OTP expired. Please request a new one.");
      return;
    }

    if (verificationId == null) {
      Utils.showToast("Verification ID missing");
      return;
    }

    try {
      Get.dialog(LoadingUi(), barrierDismissible: false);

      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: smsCode,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      log("User logged in: ${userCredential.user?.uid}");
      Get.back();
      Get.toNamed('/FillProfileScreen');
    } on FirebaseAuthException catch (e) {
      Get.back();
      Utils.showToast(e.message ?? "Invalid OTP");
    } catch (e) {
      Get.back();
      Utils.showToast("Something went wrong");
    }
  }

  onResendOtpClick() async {
    otpController.clear();

    final number = numberController.text.trim();
    final code = dialCode ?? '+91';
    final phoneNumber = '$code$number';

    try {
      Get.dialog(LoadingUi(), barrierDismissible: false);
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          Get.back();
        },
        verificationFailed: (FirebaseAuthException e) {
          Get.back();
          Utils.showToast(e.message ?? "OTP sending failed");
        },
        codeSent: (String id, int? resendToken) {
          Get.back();
          verificationId = id;
          Utils.showToast("OTP resent successfully");
        },
        codeAutoRetrievalTimeout: (String id) {
          verificationId = id;
        },
      );
    } catch (e) {
      Get.back();
      Utils.showToast("Resend OTP failed: $e");
    }
  }

  // Image picker methods
  Future<void> getImageFromGallery() async {
    try {
      final XFile? xFiles = await imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 100);

      if (xFiles != null) {
        selectedImage = File(xFiles.path);
        imageXFile = selectedImage;
        update();
        log("Image selected from gallery: ${selectedImage!.path}");
      }
    } catch (e) {
      Utils.showToast("Failed to pick image from gallery");
      log("Gallery picker error: $e");
    }
  }

  Future<void> takePhoto() async {
    try {
      final XFile? xFiles = await imagePicker.pickImage(source: ImageSource.camera, imageQuality: 100);

      if (xFiles != null) {
        selectedImage = File(xFiles.path);
        imageXFile = selectedImage;
        update();
        log("Photo captured from camera: ${selectedImage!.path}");
      }
    } catch (e) {
      Utils.showToast("Failed to capture photo");
      log("Camera picker error: $e");
    }
  }

  // Method to clear image
  void clearImage() {
    selectedImage = null;
    imageXFile = null;
    update();
  }

  @override
  void onClose() {
    numberController.dispose();
    otpController.dispose();
    super.onClose();
  }
}

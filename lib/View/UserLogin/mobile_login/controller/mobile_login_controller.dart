import 'dart:developer';
import 'dart:io';
import 'package:era_shop/Controller/GetxController/login/login_controller.dart';
import 'package:era_shop/View/UserLogin/demo_sign_in.dart';
import 'package:era_shop/custom/loading_ui.dart';
import 'package:era_shop/utils/Theme/theme_service.dart';
import 'package:era_shop/utils/database.dart';
import 'package:era_shop/utils/globle_veriables.dart' as gv;
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
    dialCode = gv.dialCode;
    super.onInit();
  }

  String _buildPhoneNumber() {
    final rawNumber = numberController.text.trim().replaceAll(' ', '');

    // If user enters full E.164 (e.g. +15555550123), use as-is.
    if (rawNumber.startsWith('+')) {
      return rawNumber;
    }

    final code = dialCode ?? gv.dialCode ?? '+91';
    return '$code$rawNumber';
  }

  Future<void> _loginOrRouteToSignup() async {
    final loginController = Get.put(LoginController());
    final number = numberController.text.trim();
    final code = dialCode ?? gv.dialCode ?? '+91';

    await loginController.getLoginData(
      firstName: '',
      lastName: '',
      email: '',
      mobileNumber: number,
      password: '',
      loginType: 5,
      fcmToken: gv.fcmToken,
      identity: gv.identify,
      countryCode: code,
    );

    final isExistingUserLogin = loginController.userLogin?.status == true && loginController.userLogin?.signUp != true;

    if (isExistingUserLogin) {
      LoginSuccessUi.onShow(
        callBack: () {
          Get.back();
          Get.offAllNamed('/BottomTabBar');
        },
      );
      return;
    }

    // New mobile user: do not keep logged-in state yet, require profile completion.
    await getStorage.write("isLogin", false);
    await getStorage.remove("userId");
    await Database.onSetLoginUserId("");
    await Database.onSetLoginType(0);
    gv.loginUserId = "";
    Get.toNamed('/FillProfileScreen');
  }

  void sendOtp() async {
    final number = numberController.text.trim();
    final phoneNumber = _buildPhoneNumber();
    final digitsOnly = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');

    log('FIREBASE_DEBUG phoneNumber=$phoneNumber');


    if (number.isEmpty) {
      Utils.showToast("Please enter mobile number");
      return;
    }

    if (digitsOnly.length < 7 || digitsOnly.length > 15) {
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
      await _loginOrRouteToSignup();
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
    final phoneNumber = _buildPhoneNumber();

    log('FIREBASE_DEBUG resendPhoneNumber=$phoneNumber');

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
        gv.imageXFile = selectedImage;
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
        gv.imageXFile = selectedImage;
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
    gv.imageXFile = null;
    update();
  }

  @override
  void onClose() {
    numberController.dispose();
    otpController.dispose();
    super.onClose();
  }
}

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:waxxapp/ApiModel/seller/get_all_bank_model.dart';
import 'package:waxxapp/ApiService/seller/get_bank_name_service.dart';
import 'package:waxxapp/Controller/ApiControllers/seller/api_seller_login_controller.dart';
import 'package:waxxapp/Controller/GetxController/login/api_check_login_controller.dart';
import 'package:waxxapp/Controller/GetxController/login/check_password_controller.dart';
import 'package:waxxapp/Controller/GetxController/login/verify_user_otp_controller.dart';
import 'package:waxxapp/Controller/GetxController/user/edit_profile_controller.dart';
import 'package:waxxapp/View/MyApp/Seller/SellerAccount/seller_document_verification.dart';
import 'package:waxxapp/View/MyApp/Seller/SellerAccount/seller_email_verify.dart';
import 'package:waxxapp/View/UserLogin/mobile_login/controller/mobile_login_controller.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/Theme/theme_service.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/app_constant.dart';
import 'package:waxxapp/utils/database.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../ApiModel/seller/ChangePasswordBySellerModel.dart';
import '../../../ApiService/seller/PasswordMangerService/seller_create_password_service.dart';
import '../../../ApiService/seller/PasswordMangerService/seller_forgot_password_service.dart';
import '../../../ApiService/seller/PasswordMangerService/seller_otp_verification_service.dart';
import '../../../ApiService/seller/PasswordMangerService/seller_update_password_service.dart';
import '../../../utils/show_toast.dart';

// Enum to identify document type
enum DocumentType { govId, businessRegistration, addressProof }

class SellerCommonController extends GetxController {
  // Seller Account Controller

  final mobileLoginController = Get.put(MobileLoginController());
  final FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController(text: Database.fetchLoginUserProfileModel?.user?.mobileNumber);
  TextEditingController emailController = TextEditingController(text: Database.fetchLoginUserProfileModel?.user?.email);
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  // int countryWisePhoneLength = 10; // [Default India Phone Len => 10]
  String countryCode = dialCode ?? "+91"; // [Default India Phone Len => +91]

  String? bankName;
  final isTermsAndCondition = false.obs;
  void toggleTermsAndCondition() {
    isTermsAndCondition.value = !isTermsAndCondition.value;
  }

  TextEditingController businessNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController accountNoController = TextEditingController();
  TextEditingController ifscController = TextEditingController();
  TextEditingController branchController = TextEditingController();

  TextEditingController businessAddressController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();

  UserVerifyOtpController userVerifyOtpController = Get.put(UserVerifyOtpController());
  CheckPasswordController checkPasswordController = Get.put(CheckPasswordController());

  RxBool signInOtpLoading = false.obs;

  final otpTime = false.obs;

  String? selectedBusinessType;

  final List<String> businessTypes = [
    'Indivisual Seller',
    'Company',
  ];

  File? selectedImage;
  List<File> selectedImages = [];
  final ImagePicker imagePicker = ImagePicker();

  Future<void> getLogoFromGallery() async {
    try {
      final XFile? xFiles = await imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 100);

      if (xFiles != null) {
        selectedImage = File(xFiles.path);
        selectedImages.add(selectedImage!);
        imageXFile = selectedImage;
        update();
        log("Image selected from gallery: ${selectedImage!.path}");
      }
    } catch (e) {
      Utils.showToast("Failed to pick image from gallery");
      log("Gallery picker error: $e");
    }
  }

  void removeLogo() {
    selectedImage = null;
    if (selectedImages.isNotEmpty) {
      selectedImages.removeLast(); // Remove the last image if needed
    }
    update();
    log("Logo removed");
  }

// Separate lists for different document types
  List<File> govIdImageList = [];
  List<File> businessRegisImageFileList = [];
  List<File> addressProofImageList = [];
  File? photoFile;

// Generic function for picking images based on document type
  Future<void> getImageFromGallery(DocumentType docType) async {
    try {
      final XFile? xFiles = await imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 100);

      if (xFiles != null) {
        photoFile = File(xFiles.path);

        // Add to appropriate list based on document type
        switch (docType) {
          case DocumentType.govId:
            govIdImageList.add(photoFile!);
            update([AppConstant.idVerifyProof]);
            break;
          case DocumentType.businessRegistration:
            businessRegisImageFileList.add(photoFile!);
            update([AppConstant.idBusinessRegCertificate]);
            break;
          case DocumentType.addressProof:
            addressProofImageList.add(photoFile!);
            update([AppConstant.idAddressProof]);
            break;
        }

        log("Image selected from gallery for ${docType.toString()}: ${photoFile!.path}");
      }
    } catch (e) {
      Utils.showToast("Failed to pick image from gallery");
      log("Gallery picker error: $e");
    }
  }

  Future<void> getGovIdImage() async {
    await getImageFromGallery(DocumentType.govId);
  }

  Future<void> getBusinessRegImage() async {
    await getImageFromGallery(DocumentType.businessRegistration);
  }

  Future<void> getAddressProofImage() async {
    await getImageFromGallery(DocumentType.addressProof);
  }

  void onRemoveGovIdImage(int index) {
    if (index < govIdImageList.length) {
      govIdImageList.removeAt(index);
      update([AppConstant.idVerifyProof]);
    }
  }

  void onRemoveBusinessRegImage(int index) {
    if (index < businessRegisImageFileList.length) {
      businessRegisImageFileList.removeAt(index);
      update([AppConstant.idBusinessRegCertificate]);
    }
  }

  void onRemoveAddressProofImage(int index) {
    if (index < addressProofImageList.length) {
      addressProofImageList.removeAt(index);
      update([AppConstant.idAddressProof]);
    }
  }

  // Future<void> takePhoto() async {
  //   try {
  //     final XFile? image = await imagePicker.pickImage(source: ImageSource.camera);
  //     if (image != null) {
  //       imageFileList.add(File(image.path));
  //       update(); // Notify listeners
  //     }
  //   } catch (e) {
  //     Get.snackbar('Error', 'Failed to take photo: ${e.toString()}');
  //   }
  // }

  void onRemoveImage(int index, DocumentType docType) {
    switch (docType) {
      case DocumentType.govId:
        onRemoveGovIdImage(index);
        break;
      case DocumentType.businessRegistration:
        onRemoveBusinessRegImage(index);
        break;
      case DocumentType.addressProof:
        onRemoveAddressProofImage(index);
        break;
    }
  }

  Future<void> onSubmitSellerDetails() async {
    // Get.toNamed("/SellerEnterOtp");
    if (firstNameController.text.trim().isEmpty) {
      Utils.showToast("Please enter full name !!");
    } else if (phoneController.text.trim().isEmpty) {
      Utils.showToast("Please enter phone number !!");
    }
    // else if (countryWisePhoneLength != phoneController.text.trim().length) {
    //   Utils.showToast("Please enter $countryWisePhoneLength digit phone number !!");
    // }
    else if (emailController.text.trim().isEmpty) {
      Utils.showToast("Please enter email address !!");
    } else if (Database.fetchLoginUserProfileModel?.user?.loginType == 5 && passwordController.text.trim().isEmpty) {
      Utils.showToast("Please enter password !!");
    } else if (selectedBusinessType == null) {
      Utils.showToast("Please select business type !!");
    } else {
      if (Database.fetchLoginUserProfileModel?.user?.loginType == 5) {
        try {
          Get.dialog(
            Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            ),
            barrierDismissible: false,
          );
          await userVerifyOtpController.getOtp(email: emailController.text);
          userVerifyOtpController.userSandOtp!.status == true ? Get.to(() => SellerEmailVerify(), transition: Transition.rightToLeft) : displayToast(message: St.invalidEmail.tr);
        } catch (e) {
          Get.back();
        }
      } else {
        try {
          Get.dialog(
            Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            ),
            barrierDismissible: false,
          );

          // forceRecaptchaFlow strategy:
          //  • DEBUG / Emulator → true:  Play Integrity unavailable; fall back to reCAPTCHA.
          //  • RELEASE / Closed-Testing → false:  App is on Play Store; use Play Integrity.
          //    Forcing reCAPTCHA in release triggers "operation-not-allowed" errors.
          await FirebaseAuth.instance.setSettings(
            forceRecaptchaFlow: kDebugMode,
          );
          log('SELLER forceRecaptchaFlow=${kDebugMode ? "true (debug)" : "false (release)"}');

          // Build a valid E.164 phone number (+<dialCode><number>).
          // Use the instance `countryCode` field (e.g. "+91") which is kept in
          // sync with the IntlPhoneField selection via onCountryChanged in
          // seller_login.dart and initialised in onInit() from the global
          // dialCode set by getDialCode() at app startup.
          final rawDialCode = countryCode.replaceAll('+', '');
          // Strip leading zero — many countries use local format with a
          // leading 0 (e.g. Ghana: 0244123456) but E.164 requires none
          // (+233244123456). Without this, Firebase rejects the number.
          final rawPhoneOriginal = phoneController.text.trim();
          String rawPhone = rawPhoneOriginal;
          if (rawPhone.startsWith('0')) {
            rawPhone = rawPhone.substring(1);
            log("SELLER_DEBUG ⚠️ Leading zero detected and stripped: '$rawPhoneOriginal' → '$rawPhone'");
          } else {
            log("SELLER_DEBUG ✅ No leading zero: '$rawPhone'");
          }
          final fullPhone = '+$rawDialCode$rawPhone';

          log("SELLER_DEBUG phoneNumber=$fullPhone");
          await FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: fullPhone,
            timeout: const Duration(seconds: 60),
            verificationCompleted: (PhoneAuthCredential credential) async {
              if (Get.isDialogOpen ?? false) Get.back();
              await checkLoginController.getCheckUserData(
                email: eMailController.text,
                password: passwordController.text,
                loginType: 3,
              );
              if (checkLoginController.checkUserLogin!.isLogin == true) {
                displayToast(message: St.loginSuccessfully.tr);
              } else {
                displayToast(message: St.invalidPassword.tr);
              }
            },
            verificationFailed: (FirebaseAuthException e) {
              log('SELLER_DEBUG verificationFailed code=${e.code} message=${e.message}');
              if (Get.isDialogOpen ?? false) Get.back(); // dismiss loading dialog
              displayToast(message: "Mobile verification failed: ${e.message}");
            },
            codeSent: (String verificationId, int? resendToken) {
              log('SELLER_DEBUG codeSent verificationId=$verificationId');
              if (Get.isDialogOpen ?? false) Get.back(); // dismiss loading dialog
              bankBusinessNameController.text = businessNameController.text;
              otpVerificationId = verificationId;
              Get.toNamed("/SellerEnterOtp");
            },
            codeAutoRetrievalTimeout: (String verificationId) {
              otpVerificationId = verificationId;
            },
          );
        } catch (e) {
          Get.back();
          Utils.showToast("Something went wrong: $e");
        }
      }
    }
    //
    // //// ===== NAME ==== \\\\
    // if (businessNameController.text.isBlank == true) {
    //   businessValidate = true.obs;
    //   update();
    // } else {
    //   businessValidate = false.obs;
    //   update();
    // }
    //
    // //// ==== LASTNAME === \\\\
    // if (businessTagController.text.isBlank == true) {
    //   businessTagValidate = true.obs;
    //   update();
    // } else {
    //   businessTagValidate = false.obs;
    //   update();
    // }
    //
    // //// ==== MOBILE NUMBER ==== \\\\
    // if (mobileNumberController.text.isBlank == true) {
    //   mobileNumberValidate = true.obs;
    //   update();
    // } else {
    //   mobileNumberValidate = false.obs;
    //   update();
    // }
    //
    // //// ===== EMAIL ==== \\\
    // if (eMailController.text.isBlank == true) {
    //   eMailValidate = true.obs;
    //   update();
    // } else {
    //   eMailValidate = false.obs;
    // }
    //
    // //// ==== PASSWORD ==== \\\\
    // if (passwordController.text.isBlank == true) {
    //   passwordValidate = true.obs;
    //   update();
    // } else {
    //   passwordValidate = false.obs;
    //   update();
    // }
    // //--------------------------------------------
    // if (passwordController.text.length < 8) {
    //   passwordLength = true.obs;
    //   update();
    // } else {
    //   passwordLength = false.obs;
    //   update();
    // }
    //
    // if (businessValidate.isFalse && businessTagValidate.isFalse && mobileNumberValidate.isFalse && eMailValidate.isFalse && passwordValidate.isFalse && passwordLength.isFalse) {
    //   displayToast(message: St.pleaseWaitToast.tr);
    //   await FirebaseAuth.instance.verifyPhoneNumber(
    //     phoneNumber: "+$countryCode ${mobileNumberController.text}",
    //     verificationCompleted: (PhoneAuthCredential credential) async {
    //       await checkLoginController.getCheckUserData(
    //         email: eMailController.text,
    //         password: passwordController.text,
    //         loginType: 3,
    //       );
    //       if (checkLoginController.checkUserLogin!.isLogin == true) {
    //         displayToast(message: St.loginSuccessfully.tr);
    //       } else {
    //         displayToast(message: St.invalidPassword.tr);
    //       }
    //     },
    //     verificationFailed: (FirebaseAuthException e) {
    //       displayToast(message: "Mobile verification failed: ${e.message}");
    //     },
    //     codeSent: (String verificationId, int? resendToken) {
    //       bankBusinessNameController.text = businessNameController.text;
    //       otpVerificationId = verificationId;
    //       Get.toNamed("/SellerEnterOtp");
    //     },
    //     codeAutoRetrievalTimeout: (String verificationId) {},
    //   );
    // }
  }

  Future<void> onSubmitSellerStoreDetails() async {
    if (businessNameController.text.trim().isEmpty) {
      Utils.showToast("Please enter business name !!");
    } else if (descriptionController.text.trim().isEmpty) {
      Utils.showToast("Please enter description !!");
    } else if (selectedImage == null) {
      Utils.showToast("Please select a image !!");
    } else {
      Get.toNamed("/SellerAddressDetails");
    }
  }

  Future<void> onSubmitSellerAccountDetails() async {
    if (businessNameController.text.trim().isEmpty) {
      Utils.showToast("Please enter business name !!");
    } else if (bankName == null) {
      Utils.showToast("Please enter bank name !!");
    } else if (accountNoController.text.trim().isEmpty) {
      Utils.showToast("Please enter account number !!");
    } else if (ifscController.text.trim().isEmpty) {
      Utils.showToast("Please enter ifsc code !!");
    } else if (branchController.text.trim().isEmpty) {
      Utils.showToast("Please enter branch name !!");
    } else {
      Get.to(() => SellerDocumentVerification());
      // Get.toNamed("/SellerAddressDetails");
    }
  }

  Future<void> onSubmitDocumentsDetails() async {
    if (isGovIdRequired && govIdImageList.isEmpty) {
      Utils.showToast("Please upload Government ID verification document !!");
      return;
    } else if (isRegistrationCertRequired && businessRegisImageFileList.isEmpty) {
      Utils.showToast("Please upload Business registration certificate !!");
      return;
    } else if (isAddressProofRequired && addressProofImageList.isEmpty) {
      Utils.showToast("Please upload Address proof document !!");
      return;
    } else {
      Get.toNamed("/TermsAndConditions");
    }
  }

  Future<void> onSubmitTermsAndCondition() async {
    displayToast(message: St.pleaseWaitToast.tr);
    await sellerLoginController.getSellerLoginData(
      userId: loginUserId,
      storeName: businessNameController.text,
      businessTag: businessTagController.text,
      mobileNumber: phoneController.text,
      countryCode: countryCode,
      email: emailController.text,
      password: passwordController.text,
      address: businessAddressController.text,
      landMark: landmarkController.text,
      city: cityController.text,
      pinCode: pinCodeController.text,
      state: stateController.text,
      country: countryController.text,
      bankBusinessName: businessNameController.text,
      bankName: bankName ?? "",
      accountNumber: accountNoController.text,
      IFSCCode: ifscController.text,
      branchName: branchController.text,
      businessType: selectedBusinessType ?? "",
      category: '',
      description: descriptionController.text.trim(),
      logo: selectedImage!,
      govId: govIdImageList.toList(),
      registrationCert: businessRegisImageFileList.toList(),
      addressProof: addressProofImageList.toList(),
    );
    if (sellerLoginController.sellerLogin!.isAccepted == false) {
      isSellerRequestSand = true;
      getStorage.write("isSellerRequestSand", isSellerRequestSand);
      displayToast(message: "Seller request sent \nsuccessfully!!");
      Get.toNamed("/SellerAccountVerification");
    } else {
      displayToast(message: "You have already sent seller request!!");
      Get.toNamed("/SellerAccountVerification");
    }
  }

  // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  EditProfileController editProfileController = Get.put(EditProfileController());
  CheckLoginController checkLoginController = Get.put(CheckLoginController());

  ///**************** MOBILE OTP **********************\\\

  static String otpVerificationId = "";

  ///**************** DATE PICK  **********************\\\
  final orderDatePick = TextEditingController();
  final walletDatePick = TextEditingController();

  ///**************** SELLER ACCOUNT  **********************\\\

  final TextEditingController businessTagController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController eMailController = TextEditingController(text: editEmail);

  // final TextEditingController passwordController = TextEditingController();

  var businessValidate = false.obs;
  var businessTagValidate = false.obs;
  var mobileNumberValidate = false.obs;
  var eMailValidate = false.obs;
  var passwordValidate = false.obs;
  var passwordLength = false.obs;
  GetAllBankModel? getAllBankModel;
  List<String> bankList = [];

  @override
  void onInit() {
    getBankName();
    // NOTE: user?.countryCode stores the ISO country code (e.g. "IN"), NOT a
    // phone dial code (e.g. "+91").  We must NOT write it into the global
    // `dialCode` variable because that would corrupt phone-number building.
    // The global `dialCode` is already set correctly by getDialCode() in
    // main.dart at startup.  We just sync the instance field from it.
    countryCode = dialCode ?? '+91';
    super.onInit();
  }

  getBankName() async {
    getAllBankModel = await GetBankService().getBank();
    if (getAllBankModel != null) {
      for (var element in getAllBankModel!.bank!) {
        bankList.add(element.name!);
        log("message${element.name!}");
      }
      update();
    }
  }

  ///**************** SELLER ADDRESS  **********************\\\

  var addressValidate = false.obs;
  var landmarkValidate = false.obs;
  var cityValidate = false.obs;
  var pinCodeValidate = false.obs;
  var stateValidate = false.obs;
  var countryValidate = false.obs;

  // void sellerAddress() {
  //   //// ===== ADDRESS ==== \\\\
  //   if (businessAddressController.text.isBlank == true) {
  //     addressValidate = true.obs;
  //     update();
  //   } else {
  //     addressValidate = false.obs;
  //     update();
  //   }
  //
  //   //// ===== LANDMARK ==== \\\\
  //
  //   if (landmarkController.text.isBlank == true) {
  //     landmarkValidate = true.obs;
  //     update();
  //   } else {
  //     landmarkValidate = false.obs;
  //     update();
  //   }
  //
  //   //// ===== CITY ==== \\\\
  //
  //   if (cityController.text.isBlank == true) {
  //     cityValidate = true.obs;
  //     update();
  //   } else {
  //     cityValidate = false.obs;
  //     update();
  //   }
  //
  //   //// ===== PIN CODE ==== \\\\
  //
  //   if (pinCodeController.text.isBlank == true) {
  //     pinCodeValidate = true.obs;
  //     update();
  //   } else {
  //     pinCodeValidate = false.obs;
  //     update();
  //   }
  //
  //   //// ===== STATE & COUNTRY==== \\\\
  //
  //   if (stateController.text.isEmpty || countryController.text.isEmpty) {
  //     stateValidate = true.obs;
  //     countryValidate = true.obs;
  //     displayToast(message: "Fill all details!");
  //     update();
  //   } else {
  //     stateValidate = false.obs;
  //     countryValidate = false.obs;
  //     update();
  //   }
  //
  //   if (addressValidate.isFalse && landmarkValidate.isFalse && countryValidate.isFalse && pinCodeValidate.isFalse && stateValidate.isFalse && countryValidate.isFalse) {
  //     Get.toNamed("/SellerAccountDetails");
  //   }
  // }

  ///**************** SELLER ACCOUNT  **********************\\\

  final TextEditingController bankBusinessNameController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();

  // final TextEditingController accountNumberController = TextEditingController();

  var bankBusinessNameValidate = false.obs;
  var bankNameValidate = false.obs;
  var accountNumberValidate = false.obs;
  var ifscValidate = false.obs;
  var branchValidate = false.obs;

  // void sellerBankAccount() {
  //   //// ===== BUSINESS NAME ==== \\\\
  //   if (bankBusinessNameController.text.isEmpty || bankBusinessNameController.text.isBlank == true) {
  //     bankBusinessNameValidate = true.obs;
  //     update();
  //   } else {
  //     bankBusinessNameValidate = false.obs;
  //     update();
  //   }
  //
  //   //// ===== BANK NAME ==== \\\\
  //
  //   if (bankNameController.text.isEmpty) {
  //     bankNameValidate = true.obs;
  //     displayToast(message: "Fill bank details!");
  //     update();
  //   } else {
  //     bankNameValidate = false.obs;
  //     update();
  //   }
  //
  //   //// ===== ACCOUNT NUMBER ==== \\\\
  //
  //   if (accountNumberController.text.isEmpty || accountNumberController.text.isBlank == true) {
  //     accountNumberValidate = true.obs;
  //     update();
  //   } else {
  //     accountNumberValidate = false.obs;
  //     update();
  //   }
  //
  //   //// ===== IFSC ==== \\\\
  //
  //   if (ifscController.text.isEmpty || ifscController.text.isBlank == true) {
  //     ifscValidate = true.obs;
  //     update();
  //   } else {
  //     ifscValidate = false.obs;
  //     update();
  //   }
  //
  //   //// ===== BRANCH ==== \\\\
  //
  //   if (branchController.text.isEmpty || branchController.text.isBlank == true) {
  //     branchValidate = true.obs;
  //     update();
  //   } else {
  //     branchValidate = false.obs;
  //     update();
  //   }
  //
  //   if (bankBusinessNameValidate.isFalse && bankNameValidate.isFalse && accountNumberValidate.isFalse && ifscValidate.isFalse && branchValidate.isFalse) {
  //     Get.toNamed("/TermsAndConditions");
  //   }
  // }

  ///**************** SELLER CHANGE PASSWORD **********************\\\
  final TextEditingController sellerOldPassword = TextEditingController();
  final TextEditingController sellerChangePassword = TextEditingController();
  final TextEditingController sellerChangeConfirmPassword = TextEditingController();
  RxBool changePasswordLoading = false.obs;
  ChangePasswordBySellerModel? changePassword;

  var oldPasswordValidate = false.obs;
  var oldPasswordLength = false.obs;

  //--------------
  var changePasswordValidate = false.obs;
  var changePasswordLength = false.obs;

  //--------------
  var confirmPasswordValidate = false.obs;
  var confirmPasswordLength = false.obs;

  Future<void> changePasswordBySeller() async {
    log("On tap worked");
    log("sellerOldPassword.text :: ${sellerOldPassword.text}");
    log("sellerChangePassword.text :: ${sellerChangePassword.text}");
    log("sellerChangeConfirmPassword.text :: ${sellerChangeConfirmPassword.text}");
    //// ==== OLD PASSWORD ==== \\\
    if (sellerOldPassword.text.isBlank == true) {
      oldPasswordValidate = true.obs;
      update();
    } else {
      oldPasswordValidate = false.obs;
      update();
    }
    //--------------------------------------------
    if (sellerOldPassword.text.length < 8) {
      oldPasswordLength = true.obs;
      update();
    } else {
      oldPasswordLength = false.obs;
      update();
    }

    //// ==== PASSWORD ==== \\\
    if (sellerChangePassword.text.isBlank == true) {
      changePasswordValidate = true.obs;
      update();
    } else {
      changePasswordValidate = false.obs;
      update();
    }
    //--------------------------------------------
    if (sellerChangePassword.text.length < 8) {
      changePasswordLength = true.obs;
      update();
    } else {
      changePasswordLength = false.obs;
      update();
    }

    //// ==== Confirm PASSWORD ==== \\\
    if (sellerChangeConfirmPassword.text.isBlank == true) {
      confirmPasswordValidate = true.obs;
      update();
    } else {
      confirmPasswordValidate = false.obs;
      update();
    }
    //--------------------------------------------
    if (sellerChangeConfirmPassword.text.length < 8) {
      confirmPasswordLength = true.obs;
      update();
    } else {
      confirmPasswordLength = false.obs;
      update();
    }

    if (oldPasswordLength.isFalse && changePasswordLength.isFalse && confirmPasswordLength.isFalse) {
      log("All is false");
      try {
        changePasswordLoading(false);
        if (sellerChangePassword.text == sellerChangeConfirmPassword.text) {
          try {
            changePasswordLoading(true);
            var data = await SellerUpdatePasswordService().updatePasswordApi(oldPass: sellerOldPassword.text, newPass: sellerChangePassword.text, confirmPass: sellerChangeConfirmPassword.text);
            changePassword = data;

            if (changePassword!.status == true) {
              displayToast(message: "Change Password Successfully!");
              Get.back();
            } else {
              displayToast(message: "Oops! old password don't match!");
            }
          } catch (e) {
            log("Change Password Error :: $e");
          } finally {
            changePasswordLoading(false);
          }
        } else {
          displayToast(message: "Confirm Password don't match!");
        }
      } catch (e) {
        log("Change Password By Seller Error :: $e");
      }
    }
  }

  ///**************** SELLER FORGOT PASSWORD **********************\\\

  final TextEditingController enterEmail = TextEditingController(text: editEmail);
  RxBool forgotPasswordLoading = false.obs;

  Future<void> forgotPasswordBySeller() async {
    forgotPasswordLoading(true);
    var changePassword = await SellerForgotPasswordService().forgotPassword(email: enterEmail.text);
    if (changePassword.status == true) {
      try {
        Get.toNamed("/SellerForgotEnterOtp");
      } catch (e) {
        Exception(e);
      } finally {
        forgotPasswordLoading(false);
      }
    }
  }

  ///**************** VERIFY OTP **********************\\\
  final TextEditingController verifyOtpText = TextEditingController();
  RxBool verifyOtpLoading = false.obs;

  Future<void> verifyOtp() async {
    try {
      if (verifyOtpText.text.isEmpty) {
        displayToast(message: St.fillOTP.tr);
      } else {
        verifyOtpLoading(true);
        var verifyOtp = await SellerOtpVerifyService().verifyOtp(email: enterEmail.text, otp: verifyOtpText.text);
        if (verifyOtp!.status == true) {
          log("Now go to create password screen");
          Get.offNamed("/SellerCreatePassword");
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

  Future<void> resendOtpBySeller() async {
    resendOtpLoading(true);
    var verifyOtp = await SellerOtpVerifyService().verifyOtp(email: enterEmail.text, otp: verifyOtpText.text);
    if (verifyOtp!.status == true) {
      try {
        displayToast(message: St.otpSendSuccessfully.tr);
      } catch (e) {
        Exception(e);
      } finally {
        resendOtpLoading(false);
      }
    }
  }

  /// ********************** CREATE PASSWORD ********************** \\\

  final TextEditingController createNewPassword = TextEditingController();
  final TextEditingController createNewConfirmPassword = TextEditingController();

  RxBool createPasswordLoading = false.obs;

  //------------
  var createPasswordValidate = false.obs;
  var createPasswordLength = false.obs;

  //--------------
  var createConfirmPasswordValidate = false.obs;
  var createConfirmPasswordLength = false.obs;

  Future<void> sellerCreateNewPassword() async {
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
          var passwordData = await SellerCreatePasswordApi().createPassword(email: enterEmail.text, newPassword: createNewPassword.text, confirmPassword: createNewConfirmPassword.text);
          if (passwordData.status == true) {
            displayToast(message: St.passwordCS.tr);
            Get.back();
            Get.back();
            verifyOtpText.clear();
            createNewPassword.clear();
            createNewConfirmPassword.clear();
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

  ///**************** SELLER TERMS AND CONDITION(API CALLING) **********************\\\
  SellerLoginController sellerLoginController = Get.put(SellerLoginController());

  ///**************** SELLER TERMS AND CONDITION WHEN SELLER FIRST TIME MAKE ACCOUNT **********************\\\

  List<TAC> termsList = [
    TAC(
        title: "Video Call Privacy Policy",
        isSelectedTerms: false.obs,
        description: "• Our video call feature is designed to enhance the user experience by providing a platform for real-time communication between sellers and buyers. We prioritize the privacy and security of your data during video calls"
            "\n\n• During video calls, we collect only the necessary information required for the functionality of the service. This may include user IDs, device information, and call metadata. We do not access the content of the video calls, ensuring the confidentiality of your conversations."
            "\n\n• In the interest of providing a seamless video call experience, we may use third-party services. These services adhere to our privacy standards, and we ensure that they comply with data protection regulations."
            "\n\n• We empower users with controls over their video call settings. You can manage permissions, opt-out of certain data collection, and choose the level of privacy you are comfortable with during video calls."),
    TAC(
        title: "Chat Privacy Policy",
        isSelectedTerms: false.obs,
        description: "• Our chat feature enables users to communicate conveniently within the app. This policy outlines the privacy measures in place to safeguard your messaging experience."
            "\n\n• All messages exchanged within the chat feature are encrypted to protect the content from unauthorized access. We employ robust security measures to ensure the confidentiality and integrity of your messages."
            "\n\n• We store messages temporarily to facilitate real-time communication. However, we do not retain your messages indefinitely, and they are regularly purged from our servers to respect your privacy."
            "\n\n• We enforce community guidelines to maintain a safe and respectful environment. Users can report inappropriate content or behavior, and our moderation team will take appropriate action."),
    TAC(
        title: "Seller Listing Privacy Policy",
        isSelectedTerms: false.obs,
        description: "• Our platform allows sellers to list and showcase their products. This policy explains how we handle the privacy of the information provided by sellers during product listings."
            "\n\n• When creating a seller profile, we collect essential information such as business details, contact information, and product listings. This information is used to verify and authenticate sellers on our platform."
            "\n\n• Details provided for product listings, including images and descriptions, are used solely for the purpose of showcasing and selling products on our platform. We do not use this information for unrelated activities."
            "\n\n• For successful transactions, we collect data related to payments and order fulfillment. This data is secured and used exclusively for transactional purposes."),
  ];
}

class TAC {
  final String title;
  final String description;
  final RxBool isSelectedTerms;

  TAC({required this.title, required this.description, required this.isSelectedTerms});
}

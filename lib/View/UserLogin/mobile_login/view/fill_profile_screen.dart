import 'dart:developer';
import 'dart:io';
import 'package:era_shop/Controller/ApiControllers/user/api_profile_edit_controller.dart';
import 'package:era_shop/Controller/GetxController/login/login_controller.dart';
import 'package:era_shop/View/UserLogin/demo_sign_in.dart';
import 'package:era_shop/View/UserLogin/mobile_login/controller/mobile_login_controller.dart';
import 'package:era_shop/custom/loading_ui.dart';
import 'package:era_shop/custom/simple_app_bar_widget.dart';
import 'package:era_shop/utils/CoustomWidget/App_theme_services/primary_buttons.dart';
import 'package:era_shop/utils/CoustomWidget/App_theme_services/textfields.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/Theme/theme_service.dart';
import 'package:era_shop/utils/all_images.dart';
import 'package:era_shop/utils/app_asset.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:era_shop/utils/show_toast.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class FillProfileScreen extends StatelessWidget {
  FillProfileScreen({super.key});

  final LoginController loginController = Get.put(LoginController());
  final ApiProfileEditController apiProfileEditController = Get.put(ApiProfileEditController());
  final MobileLoginController mobileController = Get.find<MobileLoginController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.transparent,
          shadowColor: AppColors.black.withValues(alpha: 0.4),
          flexibleSpace: SimpleAppBarWidget(title: St.fillProfile.tr),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: PrimaryPinkButton(
            onTaped: () async {
              try {
                if (!_validateForm(mobileController)) {
                  return;
                }
                final nameParts = _splitFullName(mobileController.fullNameController.text);
                final firstName = nameParts.$1;
                final lastName = nameParts.$2;
                final selectedDialCode = mobileController.dialCode ?? dialCode ?? '+91';
                final selectedNumber = mobileController.numberController.text.trim();

                Get.dialog(LoadingUi(), barrierDismissible: false);

                await loginController.getLoginData(
                  firstName: firstName,
                  lastName: lastName,
                  email: "",
                  password: "",
                  loginType: 5,
                  fcmToken: fcmToken,
                  identity: identify,
                  mobileNumber: selectedNumber,
                  countryCode: selectedDialCode,
                );

                final userId = loginController.userLogin?.user?.id ?? '';
                if (loginController.userLogin?.status == true && userId.isNotEmpty) {
                  await apiProfileEditController.profileEditData(
                    userId: userId,
                    firstName: firstName,
                    lastName: lastName,
                    email: loginController.userLogin?.user?.email?.toString() ?? "",
                    dob: loginController.userLogin?.user?.dob?.toString() ?? "",
                    gender: loginController.userLogin?.user?.gender?.toString() ?? "",
                    location: loginController.userLogin?.user?.location?.toString() ?? "",
                    mobileNumber: selectedNumber,
                    countryCode: selectedDialCode,
                  );
                }

                if (loginController.userLogin?.status == true && (apiProfileEditController.profileEditModel?.status ?? true)) {
                  editFirstName = firstName;
                  editLastName = lastName;
                  getStorage.write("editFirstName", firstName);
                  getStorage.write("editLastName", lastName);
                  LoginSuccessUi.onShow(
                    callBack: () {
                      Get.back();
                      Get.offAllNamed("/BottomTabBar");
                    },
                  );
                } else {
                  Get.back();
                  displayToast(message: St.somethingWentWrong.tr);
                }
              } catch (e) {
                Get.back();
              }
            },
            text: St.save.tr),
      ),
      body: SafeArea(
        child: SizedBox(
          height: Get.height,
          width: Get.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Get.height / 22),

                  // Profile Image Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GetBuilder<MobileLoginController>(
                        builder: (controller) => GestureDetector(
                          onTap: () {
                            _showImagePickerDialog(controller);
                          },
                          child: Stack(
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.tabBackground,
                                  border: Border.all(
                                    color: AppColors.darkGrey,
                                    width: 1,
                                  ),
                                ),
                                child: controller.selectedImage == null
                                    ? Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.person,
                                            size: 40,
                                            color: AppColors.unselected,
                                          ),
                                        ],
                                      )
                                    : ClipOval(
                                        child: Image.file(
                                          controller.selectedImage!,
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: CircleAvatar(
                                  radius: 15.4,
                                  backgroundColor: Colors.black,
                                  child: CircleAvatar(
                                    radius: 12.6,
                                    backgroundColor: controller.selectedImage == null ? AppColors.primary : AppColors.primaryPink,
                                    child: Image(
                                      image: AssetImage(controller.selectedImage == null ? AppAsset.icCamera : AppImage.imageEditPencil),
                                      color: AppColors.black,
                                      height: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  40.height,

                  // Full Name Field
                  Text(
                    St.fullNameTFTitle.tr,
                    style: AppFontStyle.styleW500(AppColors.unselected, 12),
                  ),
                  7.height,
                  TextFormField(
                    controller: mobileController.fullNameController,
                    style: AppFontStyle.styleW700(AppColors.white, 14),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.tabBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.transparent,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.transparent,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.transparent),
                      ),
                    ),
                  ),
                  20.height,
                  Text(
                    St.mobileNumber.tr,
                    style: AppFontStyle.styleW500(AppColors.unselected, 12),
                  ),
                  7.height,
                  GetBuilder<MobileLoginController>(builder: (logic) {
                    return IntlPhoneField(
                      enabled: false,
                      onCountryChanged: (value) {},
                      flagsButtonPadding: const EdgeInsets.all(8),
                      dropdownIconPosition: IconPosition.trailing,
                      controller: logic.numberController,
                      obscureText: false,
                      cursorColor: AppColors.unselected,
                      dropdownTextStyle: AppFontStyle.styleW700(AppColors.unselected, 15),
                      keyboardType: TextInputType.number,
                      showCountryFlag: true,
                      style: AppFontStyle.styleW600(AppColors.unselected, 16),
                      dropdownIcon: Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.unselected,
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        hintStyle: AppFontStyle.styleW600(AppColors.black, 16),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.transparent),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.transparent,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.transparent,
                          ),
                        ),
                        filled: true,
                        fillColor: AppColors.tabBackground,
                        errorStyle: AppFontStyle.styleW700(AppColors.red, 10),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.red,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.transparent,
                          ),
                        ),
                        counterStyle: AppFontStyle.styleW700(Colors.red, 12),
                      ),
                      initialCountryCode: countryCode,
                    );
                  }),
                  // 5.height,
                  // Text(
                  //   "This number is verified and cannot be changed",
                  //   style: AppFontStyle.styleW400(AppColors.darkGrey, 10),
                  // ),
                  20.height,
                  // Text(
                  //   St.gender.tr,
                  //   style: AppFontStyle.styleW500(AppColors.unselected, 12),
                  // ),
                  // 10.height,
                  /*GetBuilder<MobileLoginController>(builder: (logic) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            genderSelect = "Male";
                            logic.update();
                          },
                          child: Container(
                            height: 54,
                            width: Get.width / 2.3,
                            decoration: BoxDecoration(
                                color: genderSelect == "Male" ? AppColors.transparent : AppColors.tabBackground,
                                border: Border.all(
                                  width: 1.4,
                                  color: genderSelect == "Male" ? AppColors.primary : AppColors.transparent,
                                ),
                                borderRadius: BorderRadius.circular(50)),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: Get.width / 27,
                                    right: Get.width / 25,
                                  ),
                                  child: genderSelect == "Male"
                                      ? Container(
                                          height: 24,
                                          width: 24,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.primaryPink,
                                          ),
                                          child: Icon(Icons.done_outlined, color: AppColors.black, size: 15),
                                        )
                                      : Container(
                                          height: 24,
                                          width: 24,
                                          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade400)),
                                        ),
                                ),
                                Text(
                                  St.male.tr,
                                  style: AppFontStyle.styleW600(genderSelect == "Male" ? AppColors.white : AppColors.unselected, 15),
                                )
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            genderSelect = "Female";
                            logic.update();
                          },
                          child: Container(
                            height: 54,
                            width: Get.width / 2.3,
                            decoration: BoxDecoration(
                                color: genderSelect == "Female" ? AppColors.transparent : AppColors.tabBackground,
                                border: Border.all(
                                  width: 1.4,
                                  color: genderSelect == "Female" ? AppColors.primary : AppColors.transparent,
                                ),
                                borderRadius: BorderRadius.circular(50)),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: Get.width / 27,
                                    right: Get.width / 25,
                                  ),
                                  child: genderSelect == "Female"
                                      ? Container(
                                          height: 24,
                                          width: 24,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.primaryPink,
                                          ),
                                          child: Icon(Icons.done_outlined, color: AppColors.black, size: 15),
                                        )
                                      : Container(
                                          height: 24,
                                          width: 24,
                                          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade400)),
                                        ),
                                ),
                                Text(
                                  St.female.tr,
                                  style: AppFontStyle.styleW700(genderSelect == "Female" ? AppColors.white : AppColors.unselected, 15),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                  40.height,*/
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _validateForm(MobileLoginController controller) {
    if (controller.fullNameController.text.trim().isEmpty) {
      displayToast(message: St.pleaseEnterYourFullName.tr);
      return false;
    }

    if (controller.selectedImage == null) {
      displayToast(message: St.pleaseSelectAProfileImage.tr);
      return false;
    }

    // if (genderSelect.isEmpty) {
    //   displayToast(message: St.pleaseSelectYourGender.tr);
    //   return false;
    // }

    return true;
  }

  (String, String) _splitFullName(String fullName) {
    final cleaned = fullName.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (cleaned.isEmpty) {
      return ('', '');
    }
    final parts = cleaned.split(' ');
    if (parts.length == 1) {
      return (parts.first, '');
    }
    final firstName = parts.first;
    final lastName = parts.sublist(1).join(' ');
    return (firstName, lastName);
  }

  void _showImagePickerDialog(MobileLoginController controller) {
    Get.defaultDialog(
      backgroundColor: AppColors.tabBackground,
      title: St.changeYourPic.tr,
      titlePadding: const EdgeInsets.only(top: 30),
      titleStyle: AppFontStyle.styleW700(AppColors.white, 16),
      content: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Divider(
              thickness: 1,
              color: Colors.grey.shade100,
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.back();
              controller.takePhoto();
            },
            child: Container(
              height: 60,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Image(
                      color: AppColors.white,
                      image: const AssetImage("assets/profile_icons/camera.png"),
                      height: 20,
                    ),
                  ),
                  Text(
                    St.takePhoto.tr,
                    style: AppFontStyle.styleW700(AppColors.white, 15),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: GestureDetector(
              onTap: () {
                Get.back();
                controller.getImageFromGallery();
              },
              child: Container(
                height: 60,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Image(
                        color: AppColors.white,
                        image: const AssetImage("assets/profile_icons/folder.png"),
                        height: 20,
                      ),
                    ),
                    Text(
                      St.chooseFF.tr,
                      style: AppFontStyle.styleW700(AppColors.white, 15),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

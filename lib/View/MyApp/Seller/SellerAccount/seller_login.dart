import 'dart:developer';

import 'package:waxxapp/Controller/GetxController/seller/seller_common_controller.dart';
import 'package:waxxapp/custom/custom_color_bg_widget.dart';
import 'package:waxxapp/custom/main_button_widget.dart';
import 'package:waxxapp/custom/simple_app_bar_widget.dart';
import 'package:waxxapp/main.dart';
import 'package:waxxapp/seller_pages/seller_wallet_page/widget/seller_wallet_widget.dart';

import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/Theme/theme_service.dart';
import 'package:waxxapp/utils/Zego/ZegoUtils/device_orientation.dart';
import 'package:waxxapp/utils/app_asset.dart';
import 'package:waxxapp/utils/database.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/show_toast.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class SellerLogin extends StatefulWidget {
  const SellerLogin({super.key});

  @override
  State<SellerLogin> createState() => _SellerLoginState();
}

class _SellerLoginState extends State<SellerLogin> {
  final controller = Get.put(SellerCommonController());

  @override
  Widget build(BuildContext context) {
    return CustomColorBgWidget(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.transparent,
            surfaceTintColor: AppColors.transparent,
            flexibleSpace: SimpleAppBarWidget(title: St.sellerAccount.tr),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                15.height,
                Image.asset(AppAsset.icStoreProduct, color: AppColors.primary, height: 50, fit: BoxFit.cover, width: 50),
                15.height,
                Text(
                  St.completeSellerAccount.tr,
                  style: AppFontStyle.styleW900(AppColors.primary, 20),
                  textAlign: TextAlign.center,
                ),
                10.height,
                Text(
                  St.completeSellerAccountSubTitle.tr,
                  style: AppFontStyle.styleW500(AppColors.unselected, 12),
                ),
                25.height,
                SellerItemWidget(
                  hintText: St.enterFullName.tr,
                  title: St.fullNameTFTitle.tr,
                  keyboardType: TextInputType.name,
                  controller: controller.firstNameController,
                ),
                25.height,
                const PhoneNoTextField(),
                25.height,
                SellerItemWidget(
                  hintText: St.enterEmail.tr,
                  enabled: Database.fetchLoginUserProfileModel?.user?.loginType != 5 ? false : true,
                  title: St.emailTextFieldTitle.tr,
                  keyboardType: TextInputType.emailAddress,
                  controller: controller.emailController,
                ),

                if (Database.fetchLoginUserProfileModel?.user?.loginType == 5) ...{
                  25.height,
                  SellerItemWidget(
                    hintText: St.enterPassword.tr,
                    title: St.passwordTextFieldTitle.tr,
                    keyboardType: TextInputType.name,
                    controller: controller.passwordController,
                  ),
                },
                // 25.height,
                // SellerItemWidget(
                //   title: "Confirm Password",
                //   keyboardType: TextInputType.name,
                //   controller: controller.confirmPasswordController,
                // ),
                25.height,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Business Type",
                      style: AppFontStyle.styleW500(AppColors.unselected, 12),
                    ),
                    10.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: controller.businessTypes.map(
                        (type) {
                          final isSelected = controller.selectedBusinessType == type;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  controller.selectedBusinessType = type;
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RadioItem(isSelected: isSelected),
                                  10.width,
                                  Text(
                                    type,
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 16,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    )
                  ],
                )

                // PrimaryTextField(
                //   titleText: St.businessNameTFTitle.tr,
                //   hintText: St.businessNameTFHintText.tr,
                //   controllerType: "BusinessName",
                // ),
                // const SizedBox(height: 15),
                // PrimaryTextField(
                //   titleText: St.businessTag.tr,
                //   hintText: St.enterYourBusinessTag.tr,
                //   controllerType: "BusinessTag",
                // ),
                // const SizedBox(height: 15),
                // SizedBox(
                //   child: Obx(
                //     () => Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Text(
                //           St.mobileNumber.tr,
                //           style: GoogleFonts.plusJakartaSans(
                //             fontSize: 14,
                //             color: isDark.value ? AppColors.white : AppColors.mediumGrey,
                //             fontWeight: FontWeight.w500,
                //           ),
                //         ),
                //         Padding(
                //           padding: const EdgeInsets.only(top: 7),
                //           child: GetBuilder<SellerCommonController>(
                //             builder: (controller) => TextFormField(
                //               keyboardType: TextInputType.number,
                //               controller: sellerController.mobileNumberController,
                //               style: TextStyle(color: isDark.value ? AppColors.dullWhite : AppColors.black),
                //               decoration: InputDecoration(
                //                   errorText: sellerController.mobileNumberValidate.value ? St.phoneNumberCanNotBeEmpty.tr : null,
                //                   prefixIcon: GestureDetector(
                //                     onTap: () {
                //                       showCountryPicker(
                //                         context: context,
                //                         //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
                //                         exclude: <String>['KN', 'MF'],
                //                         favorite: <String>['SE'],
                //                         //Optional. Shows phone code before the country name.
                //                         showPhoneCode: true,
                //                         onSelect: (Country country) {
                //                           setState(() {
                //                             imoges = country.flagEmoji;
                //                             sellerController.countryCode = country.phoneCode;
                //                           });
                //                         },
                //                         countryListTheme: CountryListThemeData(
                //                           borderRadius: const BorderRadius.only(
                //                             topLeft: Radius.circular(40.0),
                //                             topRight: Radius.circular(40.0),
                //                           ),
                //                           inputDecoration: InputDecoration(
                //                             hintText: St.searchText.tr,
                //                             prefixIcon: const Icon(Icons.search),
                //                             border: OutlineInputBorder(
                //                               borderSide: BorderSide(
                //                                 color: const Color(0xFF8C98A8).withValues(alpha:0.2),
                //                               ),
                //                             ),
                //                           ),
                //                           // Optional. Styles the text in the search field
                //                           searchTextStyle: const TextStyle(
                //                             color: Colors.blue,
                //                             fontSize: 18,
                //                           ),
                //                         ),
                //                       );
                //                     },
                //                     child: SizedBox(
                //                       height: 58,
                //                       width: 75,
                //                       child: Row(
                //                         children: [
                //                           const SizedBox(
                //                             width: 15,
                //                           ),
                //                           imoges == null ? const Text("🇮🇳", style: TextStyle(fontSize: 25)) : Text(imoges, style: const TextStyle(fontSize: 25)),
                //                           Icon(
                //                             Icons.keyboard_arrow_down_sharp,
                //                             color: Colors.grey.shade400,
                //                           ),
                //                         ],
                //                       ),
                //                     ),
                //                   ),
                //                   filled: true,
                //                   fillColor: isDark.value ? AppColors.blackBackground : AppColors.dullWhite,
                //                   hintText: St.mobileNumberTFHintText.tr,
                //                   hintStyle: GoogleFonts.plusJakartaSans(color: Colors.grey.shade400, fontSize: 16),
                //                   enabledBorder: OutlineInputBorder(
                //                       borderSide: isDark.value ? BorderSide(color: Colors.grey.shade800) : BorderSide.none, borderRadius: BorderRadius.circular(26)),
                //                   border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryPink), borderRadius: BorderRadius.circular(26))),
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 15),
                // PrimaryTextField(
                //   titleText: St.emailTextFieldTitle.tr,
                //   hintText: St.emailTextFieldHintText.tr,
                //   controllerType: "eMail",
                // ),
                // const SizedBox(height: 15),
                // PrimaryPasswordField(
                //   titleText: St.passwordTextFieldTitle.tr,
                //   hintText: St.passwordTextFieldHintText,
                //   controllerType: "Password",
                // ),
                // const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        bottomNavigationBar: MainButtonWidget(
          height: 55,
          width: Get.width,
          margin: const EdgeInsets.all(15),
          color: AppColors.primary,
          child: Text(
            St.nextText.tr.toUpperCase(),
            style: AppFontStyle.styleW700(AppColors.black, 16),
          ),
          callback: () {
            if (getStorage.read("isDemoLogin") ?? false || isDemoSeller) {
              displayToast(message: St.thisIsDemoUser.tr);
            } else {
              controller.onSubmitSellerDetails();
            }
            // if (controller.otpTime.value) {
            //   Utils.showToast("Request time out. Please wait before retrying.");
            // } else {
            //   controller.onSubmitSellerDetails();
            // }
          },
        ),
      ),
    );
  }
}

class SellerItemWidget extends StatelessWidget {
  const SellerItemWidget({super.key, required this.title, this.child, this.controller, this.keyboardType, this.counterText, this.maxLength, this.currentLength, this.enabled, required this.hintText});

  final String title;
  final String hintText;

  final Widget? child;
  final String? counterText;
  final int? maxLength; // Maximum allowed characters
  final int? currentLength;
  final bool? enabled;

  final TextEditingController? controller;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppFontStyle.styleW500(AppColors.unselected, 12),
        ),
        10.height,
        MainButtonWidget(
          height: 55,
          width: Get.width,
          borderRadius: 12,
          padding: const EdgeInsets.only(left: 15),
          color: AppColors.tabBackground,
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  enabled: enabled,
                  controller: controller,
                  cursorColor: AppColors.unselected,
                  keyboardType: keyboardType,
                  style: AppFontStyle.styleW700(AppColors.white, 15),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: AppFontStyle.styleW600(AppColors.unselected, 12),
                    border: InputBorder.none,
                    counterText: counterText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PhoneNoTextField extends StatelessWidget {
  const PhoneNoTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SellerCommonController>(
      builder: (controller) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            St.contactNumber.tr,
            style: AppFontStyle.styleW500(AppColors.unselected, 12),
          ),
          10.height,
          IntlPhoneField(
            enabled: Database.fetchLoginUserProfileModel?.user?.loginType == 5 ? false : true,
            onCountryChanged: (value) {
              log("Country Code => ${value.dialCode}");
              dialCode = value.dialCode;    // global: digits only, e.g. "91"
              countryCode = value.code;     // global: ISO code, e.g. "IN"
              getDialCode();               // converts ISO → "+91", updates global dialCode
              // Keep the controller's instance field in sync so that
              // onSubmitSellerDetails() and the resend-OTP screen use the
              // correct dial code when building the E.164 phone number.
              controller.countryCode = dialCode ?? '+${value.dialCode}';
              log('SELLER countryCode updated to ${controller.countryCode}');
            },
            flagsButtonPadding: const EdgeInsets.all(8),
            dropdownIconPosition: IconPosition.trailing,
            controller: controller.phoneController,
            obscureText: false,
            cursorColor: AppColors.unselected,
            dropdownTextStyle: AppFontStyle.styleW700(AppColors.white, 15),
            keyboardType: TextInputType.number,
            showCountryFlag: true,
            style: AppFontStyle.styleW600(AppColors.white, 16),
            dropdownIcon: Icon(
              Icons.arrow_drop_down,
              color: AppColors.white,
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              hintText: St.enterContactNumber.tr,
              hintStyle: AppFontStyle.styleW600(AppColors.unselected, 12),
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
          ),
        ],
      ),
    );
  }
}

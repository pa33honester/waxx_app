// ignore_for_file: must_be_immutable

import 'package:waxxapp/Controller/GetxController/seller/add_product_controller.dart';
import 'package:waxxapp/Controller/GetxController/seller/seller_common_controller.dart';
import 'package:waxxapp/Controller/GetxController/seller/seller_edit_profile_controller.dart';
import 'package:waxxapp/Controller/GetxController/user/edit_profile_controller.dart';
import 'package:waxxapp/Controller/GetxController/user/user_add_address_controller.dart';
import 'package:waxxapp/utils/CoustomWidget/Page_devided/filter_bottem_shit.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/all_images.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Controller/GetxController/seller/manage_reels_controller.dart';
import '../../../Controller/GetxController/seller/update_status_wise_order_controller.dart';
import '../../../Controller/GetxController/user/UserPasswordManage/user_password_controller.dart';
import '../Page_devided/select_product_when_create_reels.dart';

// searchTextField({TextEditingController? controller, void Function(String)? onFieldSubmitted, context}) {
//   final FocusNode focusNode = FocusNode();
//   if (focusNode.hasFocus) {
//     FocusScope.of(context).requestFocus(focusNode);
//   }
//   return SizedBox(
//     height: 56,
//     child: Obx(
//       () => TextFormField(
//         focusNode: focusNode,
//         onFieldSubmitted: onFieldSubmitted,
//         controller: controller,
//         style: TextStyle(color: isDark.value ? AppColors.dullWhite : AppColors.black),
//         decoration: InputDecoration(
//             filled: true,
//             suffixIcon: Padding(
//               padding: const EdgeInsets.all(17),
//               child: GestureDetector(
//                 onTap: () {
//                   Get.bottomSheet(
//                     isScrollControlled: true,
//                     const FilterBottomShirt(),
//                   );
//                 },
//                 child: Container(
//                   height: 100,
//                   width: 40,
//                   color: Colors.transparent,
//                   child: Padding(
//                     padding: const EdgeInsets.all(3.5),
//                     child: Image(
//                       image: AssetImage(AppImage.filterImage),
//                       color: isDark.value ? AppColors.white : AppColors.black,
//                       height: 15,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             prefixIcon: Padding(
//               padding: const EdgeInsets.only(left: 10, top: 15, bottom: 15),
//               child: Image(
//                 image: AssetImage(AppImage.searchImage),
//                 height: 8,
//                 width: 10,
//               ),
//             ),
//             hintText: "Search... ",
//             hintStyle: GoogleFonts.plusJakartaSans(color: const Color(0xff9CA4AB), fontSize: 17),
//             fillColor: isDark.value ? AppColors.blackBackground : AppColors.dullWhite,
//             enabledBorder: OutlineInputBorder(
//                 borderSide: isDark.value ? BorderSide(color: Colors.grey.shade800) : BorderSide.none,
//                 borderRadius: BorderRadius.circular(30)),
//             border: OutlineInputBorder(
//                 borderSide: BorderSide(color: AppColors.primaryPink), borderRadius: BorderRadius.circular(30))),
//       ),
//     ),
//   );
// }

dummySearchField() {
  return Obx(
    () => Container(
      height: 54,
      width: double.infinity,
      decoration: BoxDecoration(
          color: isDark.value ? AppColors.blackBackground : AppColors.dullWhite,
          border: Border.all(
            color: isDark.value ? Colors.grey.shade800 : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(50)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 18),
                  child: Image(
                    image: AssetImage(AppImage.searchImage),
                    height: 18,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(St.searchText.tr,
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xff9CA4AB),
                        fontSize: 16,
                      )),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 17),
            child: InkWell(
              onTap: () {
                Get.bottomSheet(
                  isScrollControlled: true,
                  const FilterBottomShirt(),
                );
              },
              child: Container(
                height: 100,
                width: 40,
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Image(
                    image: AssetImage(AppImage.filterImage),
                    color: isDark.value ? AppColors.white : AppColors.black,
                    height: 15,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

///************************** ProfileTextField ***********************************\\\

class ProfileTextField extends StatelessWidget {
  final String titleText;
  final String hintText;
  String? controllerType;

  ProfileTextField({
    super.key,
    required this.titleText,
    this.controllerType,
    required this.hintText,
  });

  EditProfileController profileEditController = Get.put(EditProfileController());
  SellerEditProfileController sellerEditProfileController = Get.put(SellerEditProfileController());

  UserAddAddressController userAddAddressController = Get.put(UserAddAddressController());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titleText,
            style: AppFontStyle.styleW500(AppColors.unselected, 12),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 7),
            child: SizedBox(
              height: 56,
              child: TextFormField(
                controller: (controllerType == "FirstName")
                    ? profileEditController.firstNameController
                    : (controllerType == "LastName")
                        ? profileEditController.lastNameController
                        : (controllerType == "Email")
                            ? profileEditController.eMailController
                            : (controllerType == "EditBusinessName")
                                ? sellerEditProfileController.editBusinessNameController
                                : (controllerType == "EditBusinessTag")
                                    ? sellerEditProfileController.editBusinessTagController
                                    : null,
                style: AppFontStyle.styleW700(AppColors.white, 14),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: AppFontStyle.styleW600(AppColors.unselected, 12),
                  filled: true,
                  fillColor: AppColors.tabBackground,
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

///************************** PrimaryTextField ***********************************\\\

class PrimaryTextField extends StatelessWidget {
  final String? titleText;
  final String hintText;
  final String? controllerType;
  void Function()? onTap;
  final bool readOnly;
  Widget? suffixIcon;

  PrimaryTextField({super.key, this.titleText, required this.hintText, this.controllerType, this.onTap, this.readOnly = false, this.suffixIcon});

  SellerCommonController sellerCommonController = Get.put(SellerCommonController());
  SellerEditProfileController sellerEditProfileController = Get.put(SellerEditProfileController());
  AddProductController addProductController = Get.put(AddProductController());
  UserAddAddressController userAddAddressController = Get.put(UserAddAddressController());
  UpdateStatusWiseOrderController updateStatusWiseOrderController = Get.put(UpdateStatusWiseOrderController());
  UserPasswordController changePasswordController = Get.put(UserPasswordController());
  ManageShortsController manageShortsController = Get.put(ManageShortsController());

  List justForYouImage = [
    "assets/Home_page_image/just_for_you/Rectangle 22431.png",
    "assets/Home_page_image/just_for_you/Rectangle 22431 (1).png",
    "assets/Home_page_image/just_for_you/Rectangle 22431 (2).png",
    "assets/Home_page_image/just_for_you/Group 1000003097.png",
    "assets/Home_page_image/just_for_you/Rectangle 22431.png",
  ];
  List justForYouName = [
    "Kendow Premium T-shirt",
    "Bondera Premium T-shirt",
    "Degra Premium T-shirt",
    "Dress Rehia",
    "Kendow Premium T-shirt",
  ];
  List justForYouPrise = [
    "95",
    "95",
    "89",
    "85",
    "95",
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleText != null
              ? Text(
                  titleText ?? "",
                  style: AppFontStyle.styleW500(AppColors.unselected, 12),
                )
              : const SizedBox(),
          Padding(
            padding: const EdgeInsets.only(top: 7),
            child: GetBuilder<SellerCommonController>(
              builder: (controller) => TextFormField(
                onTap: (controllerType == "ReelsSelectProduct")
                    ? () {
                        Get.toNamed("/SelectProductWhenCreateReels");
                        // Get.bottomSheet(backgroundColor: AppColors.tabBackground, isScrollControlled: true, const SelectProductWhenCreateReels());

                        /// Short select
                        // Get.bottomSheet(
                        //   isScrollControlled: true,
                        //   Container(
                        //     height: Get.height / 1.5,
                        //     decoration: BoxDecoration(
                        //         color:
                        //             isDark.value ? AppColors.blackBackground : const Color(0xffffffff),
                        //         borderRadius: const BorderRadius.vertical(top: Radius.circular(25))),
                        //     child: Padding(
                        //       padding: const EdgeInsets.symmetric(horizontal: 20),
                        //       child: SizedBox(
                        //         child: Stack(
                        //           children: [
                        //             SingleChildScrollView(
                        //               physics: const BouncingScrollPhysics(),
                        //               child: Column(
                        //                 children: [
                        //                   const SizedBox(
                        //                     height: 73,
                        //                   ),
                        //                   ListView.builder(
                        //                     shrinkWrap: true,
                        //                     physics: const NeverScrollableScrollPhysics(),
                        //                     itemCount: justForYouImage.length,
                        //                     scrollDirection: Axis.vertical,
                        //                     itemBuilder: (context, index) {
                        //                       return Padding(
                        //                         padding: const EdgeInsets.symmetric(vertical: 7),
                        //                         child: SizedBox(
                        //                           height: Get.height / 8.2,
                        //                           child: Stack(
                        //                             children: [
                        //                               Row(
                        //                                 mainAxisAlignment: MainAxisAlignment.start,
                        //                                 children: [
                        //                                   Container(
                        //                                     width: Get.width / 4.3,
                        //                                     decoration: BoxDecoration(
                        //                                         image: DecorationImage(
                        //                                             image: AssetImage(
                        //                                                 justForYouImage[index]),
                        //                                             fit: BoxFit.cover),
                        //                                         borderRadius:
                        //                                             BorderRadius.circular(15)),
                        //                                   ),
                        //                                   Padding(
                        //                                     padding: const EdgeInsets.only(left: 15),
                        //                                     child: Column(
                        //                                       crossAxisAlignment:
                        //                                           CrossAxisAlignment.start,
                        //                                       mainAxisAlignment:
                        //                                           MainAxisAlignment.spaceEvenly,
                        //                                       children: [
                        //                                         SizedBox(
                        //                                           child: Column(
                        //                                             crossAxisAlignment:
                        //                                                 CrossAxisAlignment.start,
                        //                                             children: [
                        //                                               Text(
                        //                                                 justForYouName[index],
                        //                                                 style: GoogleFonts
                        //                                                     .plusJakartaSans(
                        //                                                         fontSize: 16,
                        //                                                         fontWeight:
                        //                                                             FontWeight.w500),
                        //                                               ),
                        //                                               Padding(
                        //                                                 padding: const EdgeInsets.only(
                        //                                                     top: 5),
                        //                                                 child: Text(
                        //                                                   "Size S,M,L,XL",
                        //                                                   style: GoogleFonts
                        //                                                       .plusJakartaSans(
                        //                                                           fontWeight:
                        //                                                               FontWeight.w300),
                        //                                                 ),
                        //                                               ),
                        //                                             ],
                        //                                           ),
                        //                                         ),
                        //                                         Text(
                        //                                           "$currencySymbol${justForYouPrise[index]}",
                        //                                           style: GoogleFonts.plusJakartaSans(
                        //                                               fontWeight: FontWeight.bold),
                        //                                         ),
                        //                                       ],
                        //                                     ),
                        //                                   )
                        //                                 ],
                        //                               ),
                        //                               Align(
                        //                                 alignment: Alignment.bottomRight,
                        //                                 child: Padding(
                        //                                   padding: const EdgeInsets.all(11),
                        //                                   child: Container(
                        //                                     height: 30,
                        //                                     width: 75,
                        //                                     decoration: BoxDecoration(
                        //                                         color: AppColors.primaryPink,
                        //                                         borderRadius:
                        //                                             BorderRadius.circular(6)),
                        //                                     child: Center(
                        //                                         child: Text(
                        //                                       "Buy Now",
                        //                                       style: GoogleFonts.plusJakartaSans(
                        //                                           fontSize: 12,
                        //                                           color: AppColors.white,
                        //                                           fontWeight: FontWeight.bold),
                        //                                     )),
                        //                                   ),
                        //                                 ),
                        //                               ),
                        //                             ],
                        //                           ),
                        //                         ),
                        //                       );
                        //                     },
                        //                   ),
                        //                 ],
                        //               ),
                        //             ),
                        //             Align(
                        //               alignment: Alignment.topCenter,
                        //               child: Container(
                        //                 height: 70,
                        //                 decoration: BoxDecoration(
                        //                   color: isDark.value
                        //                       ? AppColors.blackBackground
                        //                       : const Color(0xffffffff),
                        //                 ),
                        //                 child: Column(
                        //                   children: [
                        //                     const SizedBox(
                        //                       height: 18,
                        //                     ),
                        //                     Row(
                        //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //                       children: [
                        //                         const SmallTitle(title: "Add Product"),
                        //                         Container(
                        //                           height: 30,
                        //                           width: 66,
                        //                           decoration: BoxDecoration(
                        //                               color: AppColors.primaryPink,
                        //                               borderRadius:
                        //                                   const BorderRadius.all(Radius.circular(5))),
                        //                           child: Center(
                        //                               child: Text(
                        //                             "Done",
                        //                             style: GoogleFonts.plusJakartaSans(
                        //                                 color: isDark.value
                        //                                     ? AppColors.black
                        //                                     : AppColors.white,
                        //                                 fontSize: 13,
                        //                                 fontWeight: FontWeight.w600),
                        //                           )),
                        //                         ),
                        //                       ],
                        //                     ),
                        //                     const Spacer(),
                        //                     Divider(
                        //                       color: AppColors.darkGrey.withValues(alpha:0.30),
                        //                       thickness: 1,
                        //                     )
                        //                   ],
                        //                 ),
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // );
                      }
                    : onTap,
                textCapitalization: (controllerType == "IFSC") ? TextCapitalization.characters : TextCapitalization.none,
                controller: controllerTypes(),
                maxLength: (controllerType == "Pincode") || (controllerType == "EditPinCode") ? 6 : null,
                readOnly: (controllerType == "eMail") ||
                        (controllerType == "bankBusinessName") ||
                        (controllerType == "ForgetPasswordEmail") ||
                        (controllerType == "SellerForgetPasswordEmail") ||
                        (controllerType == "ReelsBusinessName") ||
                        (controllerType == "ReelsSelectProduct")
                    ? true
                    : readOnly,
                keyboardType: (controllerType == "Pincode") || (controllerType == "AccountNumber") || (controllerType == "ProductPrice") || (controllerType == "MinimumOrder") || (controllerType == "ZipCode") || (controllerType == "ShippingCharge")
                    ? TextInputType.number
                    : null,
                cursorColor: AppColors.unselected,
                style: AppFontStyle.styleW700(AppColors.white, 14),
                decoration: InputDecoration(
                  counterText: "",
                  errorText: errorText(),
                  filled: true,
                  fillColor: isDark.value ? AppColors.blackBackground : AppColors.tabBackground,
                  hintText: hintText,
                  hintStyle: AppFontStyle.styleW500(AppColors.unselected, 14),
                  suffixIcon: (controllerType == "ReelsSelectProduct") ? const Icon(Icons.keyboard_arrow_down_outlined) : suffixIcon,

                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  // border: OutlineInputBorder(
                  //     borderSide: BorderSide(
                  //         color: readOnly == true
                  //             ? AppColors.transparent
                  //             : AppColors.primaryPink),
                  //     borderRadius: BorderRadius.circular(26)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  controllerTypes() {
    return (controllerType == "BusinessName")
        ? sellerCommonController.businessNameController
        : (controllerType == "BusinessTag")
            ? sellerCommonController.businessTagController
            : (controllerType == "eMail")
                ? sellerCommonController.eMailController
                : (controllerType == "Address")
                    ? sellerCommonController.businessAddressController
                    : (controllerType == "Landmark")
                        ? sellerCommonController.landmarkController
                        : (controllerType == "City")
                            ? sellerCommonController.cityController
                            : (controllerType == "Pincode")
                                ? sellerCommonController.pinCodeController
                                : (controllerType == "bankBusinessName")
                                    ? sellerCommonController.bankBusinessNameController
                                    : (controllerType == "AccountNumber")
                                        ? sellerCommonController.accountNoController
                                        : (controllerType == "IFSC")
                                            ? sellerCommonController.ifscController
                                            : (controllerType == "Branch")
                                                ? sellerCommonController.branchController
                                                : (controllerType == "EditAddress")
                                                    ? sellerEditProfileController.editSellerAddressController
                                                    : (controllerType == "EditLandMark")
                                                        ? sellerEditProfileController.editLandmarkController
                                                        : (controllerType == "EditCity")
                                                            ? sellerEditProfileController.editCityController
                                                            : (controllerType == "EditPinCode")
                                                                ? sellerEditProfileController.editPinCodeController
                                                                : (controllerType == "EditBankAccNum")
                                                                    ? sellerEditProfileController.editAccNumberController
                                                                    : (controllerType == "EditIFSC")
                                                                        ? sellerEditProfileController.editIfscController
                                                                        : (controllerType == "EditBranch")
                                                                            ? sellerEditProfileController.editBranchController
                                                                            : (controllerType == "ProductName")
                                                                                ? addProductController.nameController
                                                                                : (controllerType == "ProductPrice")
                                                                                    ? addProductController.priceController
                                                                                    : (controllerType == "ShippingCharge")
                                                                                        ? addProductController.shippingChargeController
                                                                                        : (controllerType == "ZipCode")
                                                                                            ? userAddAddressController.zipCodeController
                                                                                            : (controllerType == "UserAddressName")
                                                                                                ? userAddAddressController.nameController
                                                                                                : (controllerType == "UserCity")
                                                                                                    ? userAddAddressController.cityController
                                                                                                    : (controllerType == "TrackingId")
                                                                                                        ? updateStatusWiseOrderController.trackingIdController
                                                                                                        : (controllerType == "TrackingLink")
                                                                                                            ? updateStatusWiseOrderController.trackingLinkController
                                                                                                            : (controllerType == "ForgetPasswordEmail")
                                                                                                                ? changePasswordController.enterEmail
                                                                                                                : (controllerType == "SellerForgetPasswordEmail")
                                                                                                                    ? sellerCommonController.enterEmail
                                                                                                                    : (controllerType == "ReelsSelectProduct")
                                                                                                                        ? manageShortsController.selectProductName
                                                                                                                        : (controllerType == "myCountryController")
                                                                                                                            ? userAddAddressController.myCountryController
                                                                                                                            : (controllerType == "myStateController")
                                                                                                                                ? userAddAddressController.myStateController
                                                                                                                                : (controllerType == "updateCountryController")
                                                                                                                                    ? sellerEditProfileController.countryController
                                                                                                                                    : (controllerType == "updateStateController")
                                                                                                                                        ? sellerEditProfileController.stateCountroller
                                                                                                                                        : (controllerType == "myCityController")
                                                                                                                                            ? userAddAddressController.myCityController
                                                                                                                                            : (controllerType == "addCountryController")
                                                                                                                                                ? sellerCommonController.countryController
                                                                                                                                                : (controllerType == "addStateController")
                                                                                                                                                    ? sellerCommonController.stateController
                                                                                                                                                    : (controllerType == "addCityController")
                                                                                                                                                        ? sellerCommonController.cityController
                                                                                                                                                        : null;
  }

  errorText() {
    return (sellerCommonController.businessValidate.value && controllerType == "FirstName")
        ? "First name cannot be empty"
        : (sellerCommonController.businessTagValidate.value && controllerType == "LastName")
            ? "Last name cannot be empty"
            : (sellerCommonController.eMailValidate.value && controllerType == "eMail")
                ? "Email cannot be empty"
                : (sellerCommonController.addressValidate.value && controllerType == "Address")
                    ? "Address cannot be empty"
                    : (sellerCommonController.landmarkValidate.value && controllerType == "Landmark")
                        ? "Landmark cannot be empty"
                        : (sellerCommonController.cityValidate.value && controllerType == "City")
                            ? "City cannot be empty"
                            : (sellerCommonController.pinCodeValidate.value && controllerType == "Pincode")
                                ? "Pincode cannot be empty"
                                : (sellerCommonController.bankBusinessNameValidate.value && controllerType == "BusinessName")
                                    ? "BusinessName cannot be empty"
                                    : (sellerCommonController.accountNumberValidate.value && controllerType == "AccountNumber")
                                        ? "AccountNumber cannot be empty"
                                        : (sellerCommonController.ifscValidate.value && controllerType == "IFSC")
                                            ? "IFSC code cannot be empty"
                                            : (sellerCommonController.branchValidate.value && controllerType == "Branch")
                                                ? "Branch cannot be empty"
                                                : null;
  }
}

///************************** PrimaryPasswordField ***********************************\\\

class PrimaryPasswordField extends StatefulWidget {
  final String titleText;
  final String hintText;
  final String? controllerType;

  const PrimaryPasswordField({
    super.key,
    required this.titleText,
    required this.hintText,
    this.controllerType,
  });

  @override
  State<PrimaryPasswordField> createState() => _PrimaryPasswordFieldState();
}

class _PrimaryPasswordFieldState extends State<PrimaryPasswordField> {
  var _obscureText = true;

  // SellerCommonController sellerController = Get.put(SellerCommonController());
  UserPasswordController changePasswordController = Get.put(UserPasswordController());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.titleText,
            style: AppFontStyle.styleW500(AppColors.unselected, 12),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: GetBuilder<SellerCommonController>(
              builder: (SellerCommonController sellerController) => TextFormField(
                controller: (widget.controllerType == "Password")
                    ? sellerController.passwordController
                    : (widget.controllerType == "SellerAddOldPassword")
                        ? sellerController.sellerOldPassword
                        : (widget.controllerType == "SellerChangePassword")
                            ? sellerController.sellerChangePassword
                            : (widget.controllerType == "SellerChangeConfirmPassword")
                                ? sellerController.sellerChangeConfirmPassword
                                : (widget.controllerType == "SellerCreatePassword")
                                    ? sellerController.createNewPassword
                                    : (widget.controllerType == "SellerCreateConfirmPassword")
                                        ? sellerController.createNewConfirmPassword
                                        : null,
                style: AppFontStyle.styleW700(AppColors.white, 14),
                obscureText: _obscureText,
                decoration: InputDecoration(
                    errorText: (sellerController.passwordValidate.value && widget.controllerType == "Password")
                        ? "Password cannot be empty"
                        : (sellerController.passwordLength.value && widget.controllerType == "Password")
                            ? "Password must be 8 digits"
                            : (sellerController.oldPasswordValidate.value && widget.controllerType == "SellerAddOldPassword")
                                ? "Old password cannot be empty"
                                : (sellerController.oldPasswordLength.value && widget.controllerType == "SellerAddOldPassword")
                                    ? "Password must be 8 digits"
                                    : (sellerController.changePasswordValidate.value && widget.controllerType == "SellerChangePassword")
                                        ? "Password cannot be empty"
                                        : (sellerController.changePasswordLength.value && widget.controllerType == "SellerChangePassword")
                                            ? "Password must be 8 digits"
                                            : (sellerController.confirmPasswordValidate.value && widget.controllerType == "SellerChangeConfirmPassword")
                                                ? "Confirm password cannot be empty"
                                                : (sellerController.confirmPasswordLength.value && widget.controllerType == "SellerChangeConfirmPassword")
                                                    ? "Confirm password must be 8 digits"
                                                    : (sellerController.createPasswordValidate.value && widget.controllerType == "SellerCreatePassword")
                                                        ? "Password cannot be empty"
                                                        : (sellerController.createPasswordLength.value && widget.controllerType == "SellerCreatePassword")
                                                            ? "Password must be 8 digits"
                                                            : (sellerController.createConfirmPasswordValidate.value && widget.controllerType == "SellerCreateConfirmPassword")
                                                                ? "Confirm password cannot be empty"
                                                                : (sellerController.createConfirmPasswordLength.value && widget.controllerType == "SellerCreateConfirmPassword")
                                                                    ? "Confirm password must be 8 digits"
                                                                    : null,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      child: Icon(
                        _obscureText ? Icons.remove_red_eye_rounded : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                    ),
                    filled: true,
                    fillColor: AppColors.tabBackground,
                    hintText: widget.hintText,
                    hintStyle: AppFontStyle.styleW500(AppColors.unselected, 14),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

///************************** ChangePasswordField ***********************************\\\

class ChangePasswordField extends StatefulWidget {
  final String titleText;
  final String hintText;
  final String? controllerType;

  const ChangePasswordField({
    super.key,
    required this.titleText,
    required this.hintText,
    this.controllerType,
  });

  @override
  State<ChangePasswordField> createState() => _ChangePasswordFieldState();
}

class _ChangePasswordFieldState extends State<ChangePasswordField> {
  var _obscureText = true;
  UserPasswordController changePasswordController = Get.put(UserPasswordController());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.titleText,
            style: AppFontStyle.styleW500(AppColors.unselected, 12),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: GetBuilder<UserPasswordController>(
              builder: (controller) => TextFormField(
                controller: (widget.controllerType == "oldPassword")
                    ? changePasswordController.userOldPassword
                    : (widget.controllerType == "changePassword")
                        ? changePasswordController.userChangePassword
                        : (widget.controllerType == "changeConfirmPassword")
                            ? changePasswordController.userChangeConfirmPassword
                            : (widget.controllerType == "UserCreatePassword")
                                ? changePasswordController.createNewPassword
                                : (widget.controllerType == "UserCreateConfirmPassword")
                                    ? changePasswordController.createNewConfirmPassword
                                    : null,
                style: AppFontStyle.styleW700(AppColors.white, 14),
                obscureText: _obscureText,
                cursorColor: AppColors.unselected,
                decoration: InputDecoration(
                  errorText: (changePasswordController.oldPasswordValidate.value && widget.controllerType == "oldPassword")
                      ? "Old Password cannot be empty"
                      : (changePasswordController.oldPasswordLength.value && widget.controllerType == "oldPassword")
                          ? "Password must be 8 digits"
                          : (changePasswordController.passwordValidate.value && widget.controllerType == "changePassword")
                              ? "Password cannot be empty"
                              : (changePasswordController.passwordLength.value && widget.controllerType == "changePassword")
                                  ? "Password must be 8 digits"
                                  : (changePasswordController.confirmPasswordValidate.value && widget.controllerType == "changeConfirmPassword")
                                      ? "Confirm Password cannot be empty"
                                      : (changePasswordController.confirmPasswordLength.value && widget.controllerType == "changeConfirmPassword")
                                          ? "Confirm Password must be 8 digits"
                                          : (changePasswordController.createPasswordValidate.value && widget.controllerType == "UserCreatePassword")
                                              ? "Password cannot be empty"
                                              : (changePasswordController.createPasswordLength.value && widget.controllerType == "UserCreatePassword")
                                                  ? "Password must be 8 digits"
                                                  : (changePasswordController.createConfirmPasswordValidate.value && widget.controllerType == "UserCreateConfirmPassword")
                                                      ? "Confirm Password cannot be empty"
                                                      : (changePasswordController.createConfirmPasswordLength.value && widget.controllerType == "UserCreateConfirmPassword")
                                                          ? "Confirm Password must be 8 digits"
                                                          : null,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    child: Icon(
                      _obscureText ? Icons.remove_red_eye_rounded : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                  ),
                  filled: true,
                  fillColor: AppColors.tabBackground,
                  hintText: widget.hintText,
                  hintStyle: AppFontStyle.styleW500(AppColors.unselected, 14),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

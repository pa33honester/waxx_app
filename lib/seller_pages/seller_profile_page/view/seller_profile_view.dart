import 'dart:io';

import 'package:dotted_line/dotted_line.dart';
import 'package:waxxapp/custom/circle_button_widget.dart';
import 'package:waxxapp/custom/main_button_widget.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_asset.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

import '../../../utils/all_images.dart';

class SellerProfileView extends StatefulWidget {
  const SellerProfileView({super.key});

  @override
  State<SellerProfileView> createState() => _SellerProfileViewState();
}

class _SellerProfileViewState extends State<SellerProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.transparent,
          surfaceTintColor: AppColors.transparent,
          flexibleSpace: const SellerProfileAppBarWidget(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              15.height,
              Center(
                child: Column(
                  children: [
                    Center(
                      child: GestureDetector(
                        // onTap: () => Get.to(const EditProfileView()),
                        child: Container(
                          height: 120,
                          width: 120,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.white),
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                height: 120,
                                width: 120,
                                clipBehavior: Clip.antiAlias,
                                decoration: const BoxDecoration(shape: BoxShape.circle),
                                child: sellerImageXFile == null ? Image.network(sellerEditImage, fit: BoxFit.cover) : Image.file(File(sellerImageXFile?.path ?? "")),
                              ),
                              Positioned(
                                right: -10,
                                bottom: 10,
                                child: GestureDetector(
                                  onTap: () => Get.toNamed("/SellerEditProfile")?.then((value) => setState(() {})),
                                  child: Container(
                                    height: 35,
                                    width: 35,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: AppColors.black),
                                    ),
                                    child: Image(
                                      image: AssetImage(AppImage.imageEditPencil),
                                      width: 14,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    10.height,
                    Text(
                      editBusinessName,
                      style: AppFontStyle.styleW700(AppColors.white, 16),
                    ),
                    3.height,
                    Text(
                      editBusinessTag,
                      style: AppFontStyle.styleW500(AppColors.white, 12),
                    ),
                  ],
                ),
              ),
              20.height,
              DottedLine(dashColor: AppColors.unselected.withValues(alpha: 0.3)),
              15.height,
              Text(
                St.personalInfo.tr,
                style: AppFontStyle.styleW500(AppColors.unselected, 14),
              ),
              15.height,
              SellerProfileItemWidget(
                title: St.myProduct.tr,
                icon: AppAsset.icCategory,
                iconSize: 23,
                callback: () => Get.toNamed("/SellerCatalogScreen"),
              ),
              15.height,
              SellerProfileItemWidget(
                title: St.listAnItem.tr,
                icon: AppAsset.icListItem,
                iconSize: 22,
                callback: () => Get.toNamed("/ListingSummary", arguments: false),
              ),
              15.height,
              SellerProfileItemWidget(
                title: St.myOrder.tr,
                icon: AppAsset.icCartFill,
                iconSize: 23,
                callback: () => Get.toNamed("/MyOrders"),
              ),
              15.height,
              SellerProfileItemWidget(
                title: St.myWallet.tr,
                icon: AppAsset.icWallet,
                iconSize: 28,
                callback: () => Get.toNamed("/sellerWalletPage"),
              ),
              15.height,
              SellerProfileItemWidget(
                title: St.liveStemming.tr,
                icon: AppAsset.icLiveVideo,
                iconSize: 27,
                callback: () => Get.toNamed("/SelectProductForStream"),
              ),
              15.height,
              SellerProfileItemWidget(
                title: St.uploadedShort.tr,
                icon: AppAsset.icReelsFill,
                iconSize: 18,
                callback: () => Get.toNamed("/UploadShort"),
              ),
              15.height,
              Text(
                St.general.tr,
                style: AppFontStyle.styleW500(AppColors.unselected, 14),
              ),
              15.height,
              SellerProfileItemWidget(
                title: St.myAddress.tr,
                icon: AppAsset.icHomeLocation,
                iconSize: 28,
                callback: () => Get.toNamed("/SellerAddress"),
              ),
              15.height,
              SellerProfileItemWidget(
                title: St.bankAccount.tr,
                icon: AppAsset.icBank,
                iconSize: 24,
                callback: () => Get.toNamed("/SellerBankAccount"),
              ),
              15.height,

              /*Text(
                St.security.tr,
                style: AppFontStyle.styleW500(AppColors.unselected, 14),
              ),
              15.height,
              SellerProfileItemWidget(
                title: St.changePassword.tr,
                icon: AppAsset.icLock,
                iconSize: 20,
                callback: () => Get.toNamed("/SellerChangePassword"),
              ),
              15.height,
              SellerProfileItemWidget(
                title: St.forgotPassword.tr,
                icon: AppAsset.icUnlock,
                iconSize: 20,
                callback: () => Get.toNamed("/SellerForgotPassword"),
              ),
              15.height,*/
            ],
          ),
        ),
      ),
    );
  }
}

class SellerProfileItemWidget extends StatelessWidget {
  const SellerProfileItemWidget({super.key, required this.title, required this.icon, this.child, this.callback, required this.iconSize});

  final String title;
  final String icon;
  final Widget? child;
  final Callback? callback;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return MainButtonWidget(
      height: 60,
      width: Get.width,
      borderRadius: 15,
      padding: const EdgeInsets.all(5),
      color: AppColors.tabBackground,
      callback: callback,
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(icon, width: iconSize, color: AppColors.black),
          ),
          15.width,
          Text(
            title,
            style: AppFontStyle.styleW700(AppColors.white, 16),
          ),
          10.width,
          SizedBox(child: child),
          const Spacer(),
          Image.asset(AppAsset.icArrowRight, width: 10, color: AppColors.unselected),
          15.width,
        ],
      ),
    );
  }
}

class SellerProfileAppBarWidget extends StatelessWidget {
  const SellerProfileAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        color: AppColors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  height: 50,
                  width: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(AppAsset.icBack, width: 15),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    St.sellerAccount.tr,
                    style: AppFontStyle.styleW900(AppColors.white, 18),
                  ),
                ),
              ),
              CircleButtonWidget(
                size: 40,
                color: AppColors.white.withValues(alpha: 0.2),
                child: Image.asset(AppAsset.icNotification, width: 20),
                callback: () => Get.toNamed("/Notifications"),
              ),
              10.width,
            ],
          ),
        ),
      ),
    );
  }
}

// appBar: PreferredSize(
//   preferredSize: const Size.fromHeight(60),
//   child: AppBar(
//     elevation: 0,
//     automaticallyImplyLeading: false,
//     actions: [
//       SizedBox(
//         width: Get.width,
//         height: double.maxFinite,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 15),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(top: 10),
//                 child: PrimaryRoundButton(
//                     onTaped: () {
//                       /*isDemoSeller == true
//                           ? Get.offAll(transition: Transition.leftToRight, const SignIn())
//                           :*/
//                       Get.offAll(
//                           transition: Transition.leftToRight,
//                           BottomTabBar(
//                             index: 4,
//                           ));
//                       // Get.off(const MainProfile(),
//                       //     transition: Transition.leftToRight);
//                     },
//                     icon: Icons.arrow_back_rounded),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 7),
//                 child: GeneralTitle(title: St.sellerAccount.tr),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 15),
//                 child: GestureDetector(
//                   onTap: () {
//                     Get.toNamed("/Notifications");
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 10),
//                     child: Obx(
//                       () => Image(
//                         image: isDark.value ? AssetImage(AppImage.notificationWhite) : AssetImage(AppImage.notificationBlack),
//                         height: 24,
//                       ),
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     ],
//   ),
// ),

// Row(
//   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//   children: [
//     Container(
//       height: 47,
//       width: Get.width / 2.5,
//       decoration: BoxDecoration(color: AppColors.primaryPink, borderRadius: BorderRadius.circular(100)),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Image.asset(
//             "assets/icons/seller_user_followers.png",
//             height: 22,
//             color: Colors.white,
//           ),
//           const SizedBox(
//             width: 15,
//           ),
//           Text(
//             sellerFollower,
//             style: GoogleFonts.plusJakartaSans(fontSize: 17, fontWeight: FontWeight.w500, color: AppColors.white),
//           )
//         ],
//       ),
//     ),
//     GestureDetector(
//       onTap: () {
//         isDemoSeller == true ? displayToast(message: St.thisIsDemoApp.tr) : Get.toNamed("/SellerEditProfile");
//       },
//       child: Container(
//         height: 47,
//         width: Get.width / 2.5,
//         decoration: BoxDecoration(color: AppColors.primaryPink, borderRadius: BorderRadius.circular(100)),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               "assets/icons/Edit Square.png",
//               height: 26,
//               color: Colors.white,
//             ),
//             const SizedBox(
//               width: 15,
//             ),
//             Text(
//               St.editText.tr,
//               style: GoogleFonts.plusJakartaSans(fontSize: 17, fontWeight: FontWeight.w500, color: AppColors.white),
//             )
//           ],
//         ),
//       ),
//     ),
//   ],
// ),
// SizedBox(
//   height: Get.height / 20,
// ),
// Row(
//   children: [
//     Text(
//       St.personalInfo.tr,
//       style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w500),
//     ),
//   ],
// ),
// const SizedBox(
//   height: 5,
// ),

//  ProfileOptions(
//                     image: const AssetImage("assets/icons/catalog.png"),
//                     text: St.catalog.tr,
//                     onTap: () {
//                       Get.toNamed("/SellerCatalogScreen");
//                     }),
//                 ProfileOptions(
//                     image: AssetImage(AppImage.myOrder),
//                     text: St.myOrder.tr,
//                     onTap: () {
//                       Get.toNamed("/MyOrders");
//                     }),
//                 ProfileOptions(
//                     image: AssetImage(AppImage.paymentMethod),
//                     text: St.myWallet.tr,
//                     onTap: () {
//                       Get.toNamed("/MyWallet");
//                     }),
//                 ProfileOptions(
//                     image: const AssetImage("assets/icons/live_strimming.png"),
//                     text: St.liveStemming.tr,
//                     onTap: () {
//                       Get.toNamed("/LiveStreaming");
//                     }),
//                 ProfileOptions(
//                     image: const AssetImage("assets/bottombar_image/unselected/ReelsU.png"),
//                     text: "Upload Shorts",
//                     onTap: () {
//                       Get.toNamed("/UploadShort");
//                     }),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 Row(
//                   children: [
//                     Text(
//                       St.general.tr,
//                       style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w500),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 5,
//                 ),
//                 ProfileOptions(
//                     image: AssetImage(AppImage.myAddress),
//                     text: St.myAddress.tr,
//                     onTap: () {
//                       Get.offNamed("/SellerAddress");
//                     }),
//                 ProfileOptions(
//                     image: const AssetImage("assets/icons/bank.png"),
//                     text: St.bankAccount.tr,
//                     onTap: () {
//                       Get.offNamed("/SellerBankAccount");
//                     }),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 Row(
//                   children: [
//                     Text(
//                       St.security.tr,
//                       style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w500),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 5,
//                 ),
//                 ProfileOptions(image: AssetImage(AppImage.changePassword), text: St.changePassword.tr, onTap: () => Get.toNamed("/SellerChangePassword")),
//                 ProfileOptions(image: AssetImage(AppImage.forgotPassword), text: St.forgotPassword.tr, onTap: () => Get.toNamed("/SellerForgotPassword")),
//                 const SizedBox(
//                   height: 20,
//                 ),

import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:waxxapp/Controller/ApiControllers/seller/api_seller_login_controller.dart';
import 'package:waxxapp/Controller/GetxController/login/google_login_controller.dart';
import 'package:waxxapp/Controller/GetxController/user/delete_user_account_controller.dart';
import 'package:waxxapp/custom/circle_button_widget.dart';
import 'package:waxxapp/custom/custom_color_bg_widget.dart';
import 'package:waxxapp/custom/main_button_widget.dart';
import 'package:waxxapp/user_pages/bottom_bar_page/controller/bottom_bar_controller.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/all_images.dart';
import 'package:waxxapp/utils/app_asset.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/database.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

class MainProfile extends StatefulWidget {
  const MainProfile({super.key});

  @override
  State<MainProfile> createState() => _MainProfileState();
}

class _MainProfileState extends State<MainProfile> {
  bool changeMode = false;
  GoogleLoginController googleLoginController = Get.put(GoogleLoginController());
  SellerLoginController sellerLoginController = Get.put(SellerLoginController());
  DeleteUserAccountController deleteUserAccountController = Get.put(DeleteUserAccountController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // if (isDark.value == true) {
    //   changeMode = true;
    // } else {
    //   changeMode = false;
    // }
  }

  Map<String, dynamic> get expiredData => {
        "productId": "prod_987654",
        "productName": "Limited Edition Sneakers",
        "mainImage": "https://images.unsplash.com/photo-1542291026-7eec264c27ff?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
        "startingPrice": 120.00,
        "currentBid": 215.50,
        "shippingCharges": 15.00,
        "liveStreamerId": "streamer_456",
        "auctionEndTime": DateTime.now().subtract(Duration(hours: 2)).toIso8601String(),
      };

  @override
  Widget build(BuildContext context) {
    Utils.onChangeSystemColor();
    log("Data => ${Database.fetchLoginUserProfileModel?.user?.firstName}");
    log("Data => ${Database.fetchLoginUserProfileModel?.user?.lastName}");
    log("Data => ${Database.fetchLoginUserProfileModel?.user?.isSeller}");
    log("Data => ${Database.fetchLoginUserProfileModel?.user?.image}");
    log("edit image => ${editImage}");
    log("edit imageXFILE => ${imageXFile}");
    return CustomColorBgWidget(
      child: PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) {
          Get.find<BottomBarController>().onChangeBottomBar(0);
          if (didPop) {
            return;
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.black,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MediaQuery.of(context).viewPadding.top.height,
                      20.height,
                      Center(
                        child: Column(
                          children: [
                            GestureDetector(
                              // onTap: () => Get.to(EditProfileView()),
                              onTap: () => Get.toNamed("/EditProfile")?.then((value) => setState(() {})),
                              child: Container(
                                height: 128,
                                width: 128,
                                padding: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.white),
                                ),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      height: 128,
                                      width: 128,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: const BoxDecoration(shape: BoxShape.circle),
                                      child: imageXFile == null
                                          ? CachedNetworkImage(
                                              imageUrl: editImage ?? "",
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) => Image.asset(AppAsset.profilePlaceholder),
                                              errorWidget: (context, url, error) => Image.asset(AppAsset.profilePlaceholder),
                                            )
                                          : ClipOval(
                                              child: Image.file(
                                                imageXFile!,
                                                height: 100,
                                                width: 100,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                    ),
                                    Positioned(
                                      right: -10,
                                      bottom: 10,
                                      child: Container(
                                        height: 35,
                                        width: 35,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          shape: BoxShape.circle,
                                          border: Border.all(color: AppColors.black),
                                        ),
                                        child: Image.asset(
                                          AppImage.imageEditPencil,
                                          width: 14,
                                          color: AppColors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            10.height,
                            Text(
                              "${editFirstName.capitalizeFirst}",
                              style: AppFontStyle.styleW700(AppColors.white, 18),
                            ),
                            3.height,
                            Text(
                              "ID : $uniqueID",
                              style: TextStyle(color: AppColors.white, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      30.height,
                      Text(
                        St.personalInfo.tr,
                        style: AppFontStyle.styleW500(AppColors.unselected, 14),
                      ),
                      15.height,
                      ProfileItemWidget(
                        title: St.myOrder.tr,
                        icon: AppAsset.icCartFill,
                        iconSize: 22,
                        // callback: () => Get.to(MyOrder()),
                        callback: () => Get.toNamed("/MyOrder"),
                      ),
                      15.height,
                      ProfileItemWidget(
                        title: St.myAddress.tr,
                        icon: AppAsset.icHomeLocation,
                        iconSize: 28,
                        callback: () => Get.toNamed("/UserAddress"),
                      ),
                      15.height,
                      ProfileItemWidget(
                        title: 'Giveaway Wins',
                        icon: AppAsset.icCartFill,
                        iconSize: 22,
                        callback: () => Get.toNamed("/MyGiveawayWins"),
                      ),
                      15.height,
                      ProfileItemWidget(
                        title: 'My Offers',
                        icon: AppAsset.icCartFill,
                        iconSize: 22,
                        callback: () => Get.toNamed("/MyOffers"),
                      ),
                      15.height,
                      // ProfileItemWidget(
                      //   title: St.paymentMethod.tr,
                      //   icon: AppAsset.icPayment,
                      //   iconSize: 23,
                      // ),
                      // 15.height,
                      GestureDetector(
                        onTap: () {
                          // Get.dialog(
                          //   barrierColor: AppColors.black.withValues(alpha: 0.8),
                          //   CongratulationsPaymentDialog(),
                          //   barrierDismissible: true,
                          // );
                        },
                        child: Text(
                          St.sellerAccount.tr,
                          style: AppFontStyle.styleW500(AppColors.unselected, 14),
                        ),
                      ),
                      15.height,
                      ProfileItemWidget(
                        title: isSeller == true
                            ? ((Database.fetchSellerDetailsModel?.data?.businessName?.trim().isNotEmpty ?? false)
                                ? Database.fetchSellerDetailsModel!.data!.businessName!
                                : St.sellerAccount.tr)
                            : St.becomeSeller.tr,
                        icon: AppAsset.icStoreProduct,
                        color: AppColors.black,
                        iconSize: 22,
                        callback: isSeller == true
                            ? () {
                                Get.toNamed("/SellerProfile");
                              }
                            : () {
                                if (isSellerRequestSand == true) {
                                  Get.toNamed("/SellerAccountVerification");
                                } else {
                                  Get.toNamed("/SellerLogin");
                                }
                              },
                        child: isSeller == true ? Image.asset(AppAsset.icTik, width: 16) : null,
                      ),

                      15.height,
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     SizedBox(
                      //       child: Row(
                      //         children: [
                      //           SizedBox(
                      //             child: imageXFile == null
                      //                 ? CircleAvatar(
                      //                     radius: 28,
                      //                     backgroundImage: NetworkImage(editImage),
                      //                   )
                      //                 : CircleAvatar(
                      //                     radius: 28,
                      //                     backgroundImage: FileImage(File(imageXFile!.path)),
                      //                   ),
                      //           ),
                      //           Padding(
                      //             padding: const EdgeInsets.only(left: 12),
                      //             child: Column(
                      //               crossAxisAlignment: CrossAxisAlignment.start,
                      //               children: [
                      //                 SizedBox(
                      //                   width: Get.width / 1.6,
                      //                   child: GeneralTitle(title: "${editFirstName.capitalizeFirst} $editLastName"),
                      //                 ),
                      //                 const SizedBox(
                      //                   height: 6,
                      //                 ),
                      //                 Text(
                      //                   uniqueID,
                      //                   style: GoogleFonts.plusJakartaSans(color: const Color(0xff78828A), fontSize: 13, fontWeight: FontWeight.w600),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //     Padding(
                      //       padding: const EdgeInsets.only(right: 7),
                      //       child: SizedBox(
                      //         child: Row(
                      //           children: [
                      //             GestureDetector(
                      //               onTap: () {
                      //                 Get.toNamed("/EditProfile");
                      //               },
                      //               child: Obx(
                      //                 () => Image(
                      //                   image: AssetImage(AppImage.profileEdit),
                      //                   color: isDark.value ? AppColors.white : AppColors.black,
                      //                   height: 24,
                      //                 ),
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     )
                      //   ],
                      // ),
                      // SizedBox(
                      //   height: Get.height / 30,
                      // ),
                      // Text(
                      //   St.personalInfo.tr,
                      //   style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w500),
                      // ),
                      // const SizedBox(
                      //   height: 5,
                      // ),
                      // ProfileOptions(
                      //     image: AssetImage(AppImage.myOrder),
                      //     text: St.myOrder.tr,
                      //     onTap: () {
                      //       Get.toNamed("/MyOrder");
                      //     }),
                      // ProfileOptions(
                      //     image: AssetImage(AppImage.myAddress),
                      //     text: St.myAddress.tr,
                      //     onTap: () {
                      //       Get.toNamed("/UserAddress");
                      //     }),
                      // ProfileOptions(
                      //     image: const AssetImage("assets/bottombar_image/unselected/Heart.png"),
                      //     text: St.myFavorite.tr,
                      //     onTap: () {
                      //       Get.toNamed("/MyFavorite");
                      //     }),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      // Text(
                      //   St.seller.tr,
                      //   style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w500),
                      // ),
                      // const SizedBox(
                      //   height: 5,
                      // ),
                      // becomeSeller == true
                      //     ? GestureDetector(
                      //         onTap: () {
                      //           Get.toNamed("/SellerProfile");
                      //         },
                      //         child: Container(
                      //           height: 55,
                      //           color: Colors.transparent,
                      //           child: Row(
                      //             children: [
                      //               const SizedBox(
                      //                 width: 5,
                      //               ),
                      //               Obx(
                      //                 () => Image(
                      //                   color: isDark.value ? AppColors.white : AppColors.black,
                      //                   image: const AssetImage("assets/profile_icons/become seller.png"),
                      //                   height: 22,
                      //                 ),
                      //               ),
                      //               Padding(
                      //                 padding: const EdgeInsets.only(left: 15),
                      //                 child: Row(
                      //                   children: [
                      //                     Text(
                      //                       editBusinessName,
                      //                       style: GoogleFonts.plusJakartaSans(
                      //                         fontSize: 15.7,
                      //                         fontWeight: FontWeight.w600,
                      //                       ),
                      //                     ),
                      //                     const Padding(
                      //                       padding: EdgeInsets.only(left: 8),
                      //                       child: Image(image: AssetImage("assets/profile_icons/seller done.png"), height: 21),
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ),
                      //               const Spacer(),
                      //               Padding(
                      //                 padding: const EdgeInsets.all(8.0),
                      //                 child: Icon(
                      //                   Icons.arrow_forward_ios_rounded,
                      //                   color: AppColors.mediumGrey,
                      //                   size: 20,
                      //                 ),
                      //               )
                      //             ],
                      //           ),
                      //         ),
                      //       )
                      //     : ProfileOptions(
                      //         image: const AssetImage("assets/profile_icons/become seller.png"),
                      //         text: St.becomeSeller.tr,
                      //         onTap: () {
                      //           if (isSellerRequestSand == true) {
                      //             Get.toNamed("/SellerAccountVerification");
                      //           } else {
                      //             Get.toNamed("/SellerLogin");
                      //           }
                      //         }),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      Text(
                        St.security.tr,
                        style: AppFontStyle.styleW500(AppColors.unselected, 14),
                      ),
                      15.height,
                      ProfileItemWidget(
                        title: St.changePassword.tr,
                        icon: AppAsset.icLock,
                        iconSize: 23,
                        callback: () => Get.toNamed("/ChangePassword"),
                      ),
                      15.height,
                      ProfileItemWidget(
                        title: St.forgotPassword.tr,
                        icon: AppAsset.icUnlock,
                        color: AppColors.black,
                        iconSize: 23,
                        callback: () => Get.toNamed("/UserForgotPassword"),
                      ),
                      100.height,

                      // ProfileOptions(
                      //     image: AssetImage(AppImage.changePassword),
                      //     text: St.changePassword.tr,
                      //     onTap: () {
                      //       Get.toNamed("/ChangePassword");
                      //     }),
                      //
                      // ProfileOptions(
                      //     image: AssetImage(AppImage.forgotPassword),
                      //     text: St.forgotPassword.tr,
                      //     onTap: () {
                      //       Get.toNamed("/UserForgotPassword");
                      //     }),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      // Text(
                      //   St.general.tr,
                      //   style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w500),
                      // ),
                      // const SizedBox(
                      //   height: 5,
                      // ),
                      // ProfileOptions(
                      //     image: AssetImage(AppImage.language),
                      //     text: St.language.tr,
                      //     onTap: () {
                      //       Get.toNamed("/Language");
                      //     }),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      // Text(
                      //   St.about.tr,
                      //   style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w500),
                      // ),
                      // const SizedBox(
                      //   height: 5,
                      // ),
                      // ProfileOptions(
                      //     image: AssetImage(AppImage.policies),
                      //     text: St.legalAndPolicies.tr,
                      //     onTap: () {
                      //       Get.toNamed("/LegalAndPolicies");
                      //     }),
                      // ProfileOptions(
                      //     image: AssetImage(AppImage.helpSupport),
                      //     text: St.helpAndSupport.tr,
                      //     onTap: () {
                      //       Get.toNamed("/HelpAndSupport");
                      //     }),
                      // GestureDetector(
                      //   onTap: () {},
                      //   child: SizedBox(
                      //     height: 55,
                      //     // color: Colors.purple.shade100,
                      //     child: Row(
                      //       children: [
                      //         Obx(
                      //           () => Image(
                      //             color: isDark.value ? AppColors.white : AppColors.black,
                      //             image: AssetImage(AppImage.darkMode),
                      //             height: 22,
                      //           ),
                      //         ),
                      //         Padding(
                      //           padding: const EdgeInsets.only(left: 15),
                      //           child: Text(
                      //             St.darkMode.tr,
                      //             style: GoogleFonts.plusJakartaSans(
                      //               fontSize: 15.7,
                      //               fontWeight: FontWeight.w600,
                      //             ),
                      //           ),
                      //         ),
                      //         const Spacer(),
                      //         Transform.scale(
                      //           scale: 0.8,
                      //           transformHitTests: false,
                      //           child: CupertinoSwitch(
                      //             activeColor: AppColors.primaryPink,
                      //             value: changeMode,
                      //             onChanged: (value) {
                      //               setState(() {});
                      //               if (isDark.value) {
                      //                 isDark.value = false;
                      //               } else {
                      //                 isDark.value = true;
                      //               }
                      //               changeMode = value;
                      //               themeService.switchTheme();
                      //             },
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(vertical: 15),
                      //   child: PrimaryWhiteButton(
                      //       onTaped: () {
                      //         Get.defaultDialog(
                      //           backgroundColor: isDark.value ? AppColors.blackBackground : AppColors.white,
                      //           title: St.dialogBoxLogoutTitle.tr,
                      //           titlePadding: const EdgeInsets.only(top: 45),
                      //           titleStyle: GoogleFonts.plusJakartaSans(color: isDark.value ? AppColors.white : AppColors.black, fontSize: 18, fontWeight: FontWeight.w600),
                      //           content: Column(
                      //             children: [
                      //               SizedBox(
                      //                 height: Get.height / 30,
                      //               ),
                      //               Padding(
                      //                 padding: const EdgeInsets.symmetric(horizontal: 30),
                      //                 child: PrimaryPinkButton(
                      //                     onTaped: () {
                      //                       Get.back();
                      //                     },
                      //                     text: St.cancelSmallText.tr),
                      //               ),
                      //               Padding(
                      //                 padding: const EdgeInsets.only(top: 20, bottom: 10),
                      //                 child: GestureDetector(
                      //                   onTap: () async {
                      //                     googleLoginController.googleUser == null ? googleLoginController.logOut() : null;
                      //
                      //                     Get.offAllNamed("/SignIn");
                      //                     getStorage.erase();
                      //                     isDemoSeller = false;
                      //                     isSellerRequestSand = false;
                      //                     becomeSeller = false;
                      //                   },
                      //                   child: Text(
                      //                     St.logout.tr,
                      //                     style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.red),
                      //                   ),
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //         );
                      //       },
                      //       text: St.logout.tr),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(vertical: 5),
                      //   child: PrimaryWhiteButton(
                      //       onTaped: () {
                      //         Get.defaultDialog(
                      //           backgroundColor: isDark.value ? AppColors.blackBackground : AppColors.white,
                      //           title: St.deleteAccount.tr,
                      //           titlePadding: const EdgeInsets.only(top: 45),
                      //           titleStyle: GoogleFonts.plusJakartaSans(color: isDark.value ? AppColors.white : AppColors.black, fontSize: 18, fontWeight: FontWeight.w600),
                      //           content: Column(
                      //             children: [
                      //               SizedBox(
                      //                 height: Get.height / 30,
                      //               ),
                      //               Padding(
                      //                 padding: const EdgeInsets.symmetric(horizontal: 30),
                      //                 child: PrimaryPinkButton(
                      //                     onTaped: () {
                      //                       Get.back();
                      //                     },
                      //                     text: St.cancelSmallText.tr),
                      //               ),
                      //               Padding(
                      //                 padding: const EdgeInsets.only(top: 20, bottom: 10),
                      //                 child: GestureDetector(
                      //                   onTap: isDemoSeller == true
                      //                       ? () => displayToast(message: St.thisIsDemoApp.tr)
                      //                       : () async {
                      //                           log("UserId ::: $userId");
                      //                           await deleteUserAccountController.deleteAccount(userId);
                      //                         },
                      //                   child: Text(
                      //                     St.removeAccount.tr,
                      //                     style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.red),
                      //                   ),
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //         );
                      //       },
                      //       text: St.removeAccount.tr),
                      // ),
                    ],
                  ),
                  Positioned(
                    top: MediaQuery.of(context).viewPadding.top + 15,
                    right: 5,
                    child: CircleButtonWidget(
                      size: 40,
                      color: AppColors.white.withValues(alpha: 0.2),
                      child: Image.asset(AppAsset.icSetting, width: 20),
                      callback: () => Get.toNamed("/SettingView"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileItemWidget extends StatelessWidget {
  const ProfileItemWidget({super.key, required this.title, required this.icon, this.child, this.callback, required this.iconSize, this.color});

  final String title;
  final Color? color;
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
            child: Image.asset(
              icon,
              width: iconSize,
            ),
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

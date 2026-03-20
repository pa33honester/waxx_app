import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:waxxapp/Controller/GetxController/seller/seller_edit_profile_controller.dart';
import 'package:waxxapp/custom/custom_color_bg_widget.dart';
import 'package:waxxapp/custom/main_button_widget.dart';
import 'package:waxxapp/custom/simple_app_bar_widget.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/all_images.dart';
import 'package:waxxapp/utils/app_asset.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/show_toast.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class SellerEditProfileView extends StatefulWidget {
  const SellerEditProfileView({super.key});

  @override
  State<SellerEditProfileView> createState() => _SellerEditProfileViewState();
}

class _SellerEditProfileViewState extends State<SellerEditProfileView> {
  XFile? xFiles;
  final ImagePicker imagePicker = ImagePicker();

  getImageFromGallery() async {
    xFiles = await imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    setState(() {
      sellerImageXFile = File(xFiles!.path);
      log("imageXFileeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee $sellerImageXFile");
    });
  }

  takePhoto() async {
    xFiles = await imagePicker.pickImage(source: ImageSource.camera, imageQuality: 100);
    setState(() {
      sellerImageXFile = File(xFiles!.path);
    });
  }

  final controller = Get.put(SellerEditProfileController());

  @override
  Widget build(BuildContext context) {
    return CustomColorBgWidget(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.transparent,
            shadowColor: AppColors.black.withValues(alpha: 0.4),
            flexibleSpace: const SimpleAppBarWidget(title: "Edit Profile"),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              25.height,
              Center(
                child: GestureDetector(
                  onTap: () {
                    Get.defaultDialog(
                      backgroundColor: isDark.value ? AppColors.blackBackground : const Color(0xffffffff),
                      title: St.changeYourPic.tr,
                      titlePadding: const EdgeInsets.only(top: 30),
                      titleStyle: GoogleFonts.plusJakartaSans(color: isDark.value ? AppColors.white : AppColors.black, fontSize: 18, fontWeight: FontWeight.w600),
                      content: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Divider(
                              thickness: 1,
                              color: Colors.grey.shade400,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.back();
                              takePhoto();
                            },
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(color: isDark.value ? AppColors.lightBlack : const Color(0xffF5F5F5), borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Image(
                                      color: isDark.value ? AppColors.white : AppColors.black,
                                      image: const AssetImage("assets/profile_icons/camera.png"),
                                      height: 20,
                                    ),
                                  ),
                                  Text(
                                    St.takePhoto.tr,
                                    style: GoogleFonts.plusJakartaSans(color: isDark.value ? AppColors.white : AppColors.black, fontSize: 14, fontWeight: FontWeight.w600),
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
                                getImageFromGallery();
                              },
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(color: isDark.value ? AppColors.lightBlack : const Color(0xffF5F5F5), borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: Image(
                                        color: isDark.value ? AppColors.white : AppColors.black,
                                        image: const AssetImage("assets/profile_icons/folder.png"),
                                        height: 20,
                                      ),
                                    ),
                                    Text(
                                      St.chooseFF.tr,
                                      style: GoogleFonts.plusJakartaSans(color: isDark.value ? AppColors.white : AppColors.black, fontSize: 14, fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    height: 120,
                    width: 120,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                      border: Border.all(
                        color: AppColors.white,
                        width: 1,
                      ),
                    ),
                    child: sellerImageXFile == null
                        ? FutureBuilder(
                            future: precacheImage(CachedNetworkImageProvider(sellerEditImage), context),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                return CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 50,
                                  backgroundImage: CachedNetworkImageProvider(sellerEditImage),
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: CircleAvatar(
                                      radius: 15.4,
                                      backgroundColor: Colors.black,
                                      child: CircleAvatar(
                                        radius: 14,
                                        backgroundColor: AppColors.primaryPink,
                                        child: Image.asset(AppAsset.icCamera, width: 18),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return CircleAvatar(
                                  backgroundColor: AppColors.lightGrey,
                                  radius: 50,
                                  child: const Center(
                                    child: CupertinoActivityIndicator(),
                                  ),
                                );
                              }
                            },
                          )
                        : CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 50,
                            backgroundImage: FileImage(File(sellerImageXFile!.path)),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: CircleAvatar(
                                radius: 15.4,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 12.6,
                                  backgroundColor: AppColors.primaryPink,
                                  child: Image(
                                    image: AssetImage(AppImage.imageEditPencil),
                                    height: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
              ),
              30.height,
              DottedLine(dashColor: AppColors.unselected.withValues(alpha: 0.25)),
              25.height,
              Text(
                St.businessNameTFTitle.tr,
                style: AppFontStyle.styleW500(AppColors.unselected, 12),
              ),
              15.height,
              Container(
                height: 58,
                width: Get.width,
                padding: const EdgeInsets.only(right: 15),
                decoration: BoxDecoration(
                  color: AppColors.tabBackground,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 58,
                      width: 70,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                        ),
                      ),
                      child: Image.asset(AppAsset.icStoreProduct, color: AppColors.black, width: 25),
                    ),
                    15.width,
                    Expanded(
                      child: TextFormField(
                        controller: controller.editBusinessNameController,
                        style: AppFontStyle.styleW700(AppColors.white, 14),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: St.enterBusinessName.tr,
                          hintStyle: AppFontStyle.styleW500(AppColors.unselected, 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              25.height,
              Text(
                St.enterBusinessTag.tr,
                style: AppFontStyle.styleW500(AppColors.unselected, 12),
              ),
              15.height,
              Container(
                height: 58,
                width: Get.width,
                padding: const EdgeInsets.only(right: 15),
                decoration: BoxDecoration(
                  color: AppColors.tabBackground,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 58,
                      width: 70,
                      padding: const EdgeInsets.only(bottom: 5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                        ),
                      ),
                      child: Text("@", style: AppFontStyle.styleW700(AppColors.black, 28)),
                    ),
                    15.width,
                    Expanded(
                      child: TextFormField(
                        controller: controller.editBusinessTagController,
                        style: AppFontStyle.styleW700(AppColors.white, 14),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: St.enterYourPromoCode.tr,
                          hintStyle: AppFontStyle.styleW500(AppColors.unselected, 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(15),
          child: MainButtonWidget(
            height: 60,
            width: Get.width,
            child: Text(
              St.saveChanges.tr.toUpperCase(),
              style: AppFontStyle.styleW700(AppColors.black, 15),
            ),
            callback: () async {
              isDemoSeller == true ? displayToast(message: St.thisIsDemoUser.tr) : controller.sellerEditProfile();
              Get.back();
            },
          ),
        ),
      ),
    );
  }
}

// bottomNavigationBar: Padding(
//   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//   child: PrimaryPinkButton(
//       onTaped: () async {
//         await sellerEditProfileController.sellerEditProfile();
//         Get.back();
//       },
//       text: St.saveChanges.tr),
// ),
// appBar: PreferredSize(
//   preferredSize: const Size.fromHeight(60),
//   child: AppBar(
//     elevation: 0,
//     automaticallyImplyLeading: false,
//     actions: [
//       SizedBox(
//         width: Get.width,
//         height: double.maxFinite,
//         child: Stack(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(left: 15, top: 10),
//               child: PrimaryRoundButton(
//                 onTaped: () {
//                   Get.back();
//                 },
//                 icon: Icons.arrow_back_rounded,
//               ),
//             ),
//             Align(
//               alignment: Alignment.center,
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 5),
//                 child: GeneralTitle(title: St.sellerAccount.tr),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ],
//   ),
// ),

// ProfileTextField(titleText: St.businessNameTFTitle.tr, controllerType: "EditBusinessName"),
// const SizedBox(height: 25),
// ProfileTextField(titleText: St.businessTag.tr, controllerType: "EditBusinessTag"),

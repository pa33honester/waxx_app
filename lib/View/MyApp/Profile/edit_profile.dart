import 'dart:developer';
import 'dart:io';

import 'package:waxxapp/Controller/GetxController/user/edit_profile_controller.dart';
import 'package:waxxapp/custom/simple_app_bar_widget.dart';
import 'package:waxxapp/user_pages/account_settings/change_email/view/change_email_view.dart';
import 'package:waxxapp/user_pages/account_settings/change_phone/view/change_phone_view.dart';
import 'package:waxxapp/utils/CoustomWidget/App_theme_services/primary_buttons.dart';
import 'package:waxxapp/utils/CoustomWidget/App_theme_services/textfields.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/Theme/theme_service.dart';
import 'package:waxxapp/utils/all_images.dart';
import 'package:waxxapp/utils/app_asset.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/database.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/show_toast.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../utils/Zego/ZegoUtils/device_orientation.dart';
import '../../../utils/app_circular.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => EditProfileState();
}

//----------------------
class EditProfileState extends State<EditProfile> {
  EditProfileController editProfileController = Get.put(EditProfileController());
  XFile? xFiles;
  final ImagePicker imagePicker = ImagePicker();

  getImageFromGallery() async {
    xFiles = await imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    setState(() {
      imageXFile = File(xFiles!.path);
      log("imageXFileeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee $imageXFile");
    });
  }

  takePhoto() async {
    xFiles = await imagePicker.pickImage(source: ImageSource.camera, imageQuality: 100);
    setState(() {
      imageXFile = File(xFiles!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.black,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: AppColors.transparent,
              shadowColor: AppColors.black.withValues(alpha: 0.4),
              flexibleSpace: SimpleAppBarWidget(title: St.editProfile.tr),
            ),
          ),
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
          //                 child: GeneralTitle(title: St.profile.tr),
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: PrimaryPinkButton(
                // onTaped: isDemoSeller == true
                //     ? () => displayToast(message: St.thisIsDemoApp.tr)
                //     : () async {
                //         await editProfileController.editDataStorage();
                //         Get.back();
                //       },
                onTaped: getStorage.read("isDemoLogin") ?? false || isDemoSeller
                    ? () => displayToast(message: St.thisIsDemoUser.tr)
                    : () async {
                        await editProfileController.editDataStorage();
                        Get.back();
                      },
                text: St.saveChanges.tr),
          ),
          body: SafeArea(
            child: SizedBox(
                height: Get.height,
                width: Get.width,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: Get.height / 22),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        log("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx $imageXFile");
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
                                                  takePhoto();
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
                                                    getImageFromGallery();
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
                                      },
                                      child: imageXFile == null
                                          ? CircleAvatar(
                                              radius: 50,
                                              backgroundImage: NetworkImage(editImage),
                                              child: Align(
                                                alignment: Alignment.bottomRight,
                                                child: CircleAvatar(
                                                  radius: 15.4,
                                                  backgroundColor: Colors.black,
                                                  child: CircleAvatar(
                                                    radius: 12.6,
                                                    backgroundColor: AppColors.primary,
                                                    child: Image(
                                                      image: AssetImage(AppAsset.icCamera),
                                                      color: AppColors.black,
                                                      height: 14,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : CircleAvatar(
                                              radius: 50,
                                              backgroundImage: FileImage(File(imageXFile!.path)),
                                              child: Align(
                                                alignment: Alignment.bottomRight,
                                                child: CircleAvatar(
                                                  radius: 15.4,
                                                  backgroundColor: AppColors.black,
                                                  child: CircleAvatar(
                                                    radius: 14,
                                                    backgroundColor: AppColors.primary,
                                                    child: Image(
                                                      image: AssetImage(AppImage.imageEditPencil),
                                                      height: 14,
                                                      color: AppColors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            ProfileTextField(
                              titleText: St.fullNameTFTitle.tr,
                              controllerType: "FirstName",
                              hintText: St.enterFullName.tr,
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(vertical: 20),
                            //   child: ProfileTextField(
                            //     titleText: St.lastNameTextFieldTitle.tr,
                            //     controllerType: "LastName",
                            //   ),
                            // ),
                            20.height,
                            // Phone number — read-only with a "Change" button.
                            // Editing it inline here was always disabled; the
                            // dedicated flow below adds Firebase OTP verification.
                            _readOnlyFieldRow(
                              title: St.contactNumber.tr,
                              value: () {
                                final cc = Database.fetchLoginUserProfileModel?.user?.countryCode ?? '';
                                final num = editProfileController.eNumberController.text.trim();
                                if (num.isEmpty) return 'Add phone number';
                                return cc.isEmpty ? num : '$cc $num';
                              }(),
                              isPlaceholder: editProfileController.eNumberController.text.trim().isEmpty,
                              actionLabel: 'Change',
                              onAction: () async {
                                final ok = await Get.to(() => ChangePhoneView());
                                if (ok == true && mounted) setState(() {});
                              },
                            ),
                            20.height,
                            // Email — show for everyone (was hidden for
                            // phone-signup users), with a "Change" / "Add"
                            // button that routes through email-OTP verify.
                            _readOnlyFieldRow(
                              title: St.emailTextFieldTitle.tr,
                              value: () {
                                final email = editProfileController.eMailController.text.trim();
                                return email.isEmpty ? 'Add your email' : email;
                              }(),
                              isPlaceholder: editProfileController.eMailController.text.trim().isEmpty,
                              actionLabel: editProfileController.eMailController.text.trim().isEmpty ? 'Add' : 'Change',
                              onAction: () async {
                                final ok = await Get.to(() => ChangeEmailView());
                                if (ok == true && mounted) setState(() {});
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: SizedBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Text(
                                    //   St.dateOfBirth.tr,
                                    //   style: AppFontStyle.styleW500(AppColors.unselected, 12),
                                    // ),
                                    // Padding(
                                    //   padding: const EdgeInsets.only(top: 7),
                                    //   child: SizedBox(
                                    //     height: 56,
                                    //     child: GestureDetector(
                                    //       child: TextFormField(
                                    //         controller: editProfileController.dateOfBirth,
                                    //         readOnly: true,
                                    //         onTap: () => _selectDate(context),
                                    //         style: AppFontStyle.styleW700(AppColors.white, 14),
                                    //         decoration: InputDecoration(
                                    //           suffixIcon: Padding(
                                    //             padding: const EdgeInsets.all(16),
                                    //             child: Image(
                                    //               image: AssetImage(
                                    //                 AppImage.celenderIcon,
                                    //               ),
                                    //               color: AppColors.primary,
                                    //             ),
                                    //           ),
                                    //           filled: true,
                                    //           fillColor: AppColors.tabBackground,
                                    //           hintText: "24 february 1996",
                                    //           hintStyle: AppFontStyle.styleW500(AppColors.unselected, 12),
                                    //           enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                    //           focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                            // Text(
                            //   St.gender.tr,
                            //   style: AppFontStyle.styleW500(AppColors.unselected, 12),
                            // ),
                            // const SizedBox(
                            //   height: 10,
                            // ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     GestureDetector(
                            //       onTap: () {
                            //         setState(() {});
                            //         genderSelect = "Male";
                            //       },
                            //       child: Container(
                            //         height: 54,
                            //         width: Get.width / 2.3,
                            //         decoration: BoxDecoration(
                            //             color: genderSelect == "Male" ? AppColors.transparent : AppColors.tabBackground,
                            //             border: Border.all(
                            //               width: 1.4,
                            //               color: genderSelect == "Male" ? AppColors.primary : AppColors.transparent,
                            //             ),
                            //             borderRadius: BorderRadius.circular(50)),
                            //         child: Row(
                            //           children: [
                            //             Padding(
                            //               padding: EdgeInsets.only(
                            //                 left: Get.width / 27,
                            //                 right: Get.width / 25,
                            //               ),
                            //               child: genderSelect == "Male"
                            //                   ? Container(
                            //                       height: 24,
                            //                       width: 24,
                            //                       decoration: BoxDecoration(
                            //                         shape: BoxShape.circle,
                            //                         color: AppColors.primaryPink,
                            //                       ),
                            //                       child: Icon(Icons.done_outlined, color: AppColors.black, size: 15),
                            //                     )
                            //                   : Container(
                            //                       height: 24,
                            //                       width: 24,
                            //                       decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade400)),
                            //                     ),
                            //             ),
                            //             Text(
                            //               St.male.tr,
                            //               style: AppFontStyle.styleW600(genderSelect == "Male" ? AppColors.white : AppColors.unselected, 15),
                            //             )
                            //           ],
                            //         ),
                            //       ),
                            //     ),
                            //     GestureDetector(
                            //       onTap: () {
                            //         setState(() {});
                            //         genderSelect = "Female";
                            //       },
                            //       child: Container(
                            //         height: 54,
                            //         width: Get.width / 2.3,
                            //         decoration: BoxDecoration(
                            //             color: genderSelect == "Female" ? AppColors.transparent : AppColors.tabBackground,
                            //             border: Border.all(
                            //               width: 1.4,
                            //               color: genderSelect == "Female" ? AppColors.primary : AppColors.transparent,
                            //             ),
                            //             borderRadius: BorderRadius.circular(50)),
                            //         child: Row(
                            //           children: [
                            //             Padding(
                            //               padding: EdgeInsets.only(
                            //                 left: Get.width / 27,
                            //                 right: Get.width / 25,
                            //               ),
                            //               child: genderSelect == "Female"
                            //                   ? Container(
                            //                       height: 24,
                            //                       width: 24,
                            //                       decoration: BoxDecoration(
                            //                         shape: BoxShape.circle,
                            //                         color: AppColors.primaryPink,
                            //                       ),
                            //                       child: Icon(Icons.done_outlined, color: AppColors.black, size: 15),
                            //                     )
                            //                   : Container(
                            //                       height: 24,
                            //                       width: 24,
                            //                       decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade400)),
                            //                     ),
                            //             ),
                            //             Text(
                            //               St.female.tr,
                            //               style: AppFontStyle.styleW700(genderSelect == "Female" ? AppColors.white : AppColors.unselected, 15),
                            //             )
                            //           ],
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            // const SizedBox(
                            //   height: 40,
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ),
        Obx(() => editProfileController.isLoading.value ? ScreenCircular.blackScreenCircular() : const SizedBox.shrink())
      ],
    );
  }

  /// Read-only "value + Change/Add" row used for fields that can't be
  /// edited inline — phone (needs Firebase OTP) and email (needs an
  /// email-OTP round-trip). [isPlaceholder] dims the value text when it's
  /// a "Add your email" / "Add phone number" prompt rather than real data.
  Widget _readOnlyFieldRow({
    required String title,
    required String value,
    required bool isPlaceholder,
    required String actionLabel,
    required VoidCallback onAction,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppFontStyle.styleW500(AppColors.unselected, 12)),
        const SizedBox(height: 7),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.tabBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: AppFontStyle.styleW600(
                    isPlaceholder ? AppColors.unselected : AppColors.white,
                    14,
                  ),
                ),
              ),
              TextButton(
                onPressed: onAction,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  actionLabel,
                  style: AppFontStyle.styleW700(AppColors.primary, 13),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        String formattedDate = DateFormat('dd MMMM yyyy').format(_selectedDate!);
        log("---------------------------$formattedDate");
        editDateOfBirth = editProfileController.dateOfBirth.text = formattedDate;
      });
    }
  }
}

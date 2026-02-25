import 'package:dotted_line/dotted_line.dart';
import 'package:era_shop/custom/custom_color_bg_widget.dart';
import 'package:era_shop/custom/main_button_widget.dart';
import 'package:era_shop/custom/simple_app_bar_widget.dart';
import 'package:era_shop/user_pages/cancel_order_page/widget/cancelled_order_bottom_sheet.dart';
import 'package:era_shop/utils/app_asset.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

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
            flexibleSpace: SimpleAppBarWidget(title: "My Profile"),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                15.height,
                Center(
                  child: GestureDetector(
                    onTap: () => Get.to(const EditProfileView()),
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
                            child: Image.network(Utils.image, fit: BoxFit.cover),
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
                              child: Image.asset(AppAsset.icCamera, width: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                30.height,
                DottedLine(dashColor: AppColors.unselected.withValues(alpha: 0.3)),
                30.height,
                ProfileItemWidget(title: "First Name", icon: AppAsset.icProfileFill, iconSize: 22),
                20.height,
                ProfileItemWidget(title: "User Name", icon: AppAsset.icAt, iconSize: 25),
                20.height,
                ProfileItemWidget(title: "User ID", icon: AppAsset.icId, iconSize: 28),
                20.height,
                ProfileItemWidget(title: "Email ID", icon: AppAsset.icMailFill, iconSize: 28),
                20.height,
                ProfileItemWidget(title: "Contact Number", icon: AppAsset.icCall, iconSize: 26),
                20.height,
                ProfileItemWidget(title: "Date Of Birth", icon: AppAsset.icDate, iconSize: 25),
                20.height,
                ProfileItemWidget(title: "Gender", icon: AppAsset.icBoth, iconSize: 26),
                20.height,
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(15),
          child: MainButtonWidget(
            height: 60,
            width: Get.width,
            color: AppColors.primary,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                "SAVE CHANGES",
                style: AppFontStyle.styleW700(AppColors.black, 15),
              ),
            ),
            callback: () => CancelledOrderBottomSheet.onShow(
              callBack: () {},
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileItemWidget extends StatelessWidget {
  const ProfileItemWidget({super.key, required this.title, required this.icon, required this.iconSize, this.controller, this.callback});

  final String title;
  final String icon;
  final double iconSize;
  final TextEditingController? controller;
  final Callback? callback;

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
        Container(
          height: 55,
          width: Get.width,
          decoration: BoxDecoration(
            color: AppColors.tabBackground,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                height: 55,
                width: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: Image.asset(icon, width: iconSize, color: AppColors.black),
              ),
              15.width,
              Expanded(
                child: TextFormField(
                  controller: controller,
                  style: AppFontStyle.styleW700(AppColors.white, 14),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "",
                    hintStyle: AppFontStyle.styleW500(AppColors.unselected, 14),
                  ),
                ),
              ),
              15.width,
            ],
          ),
        ),
      ],
    );
  }
}

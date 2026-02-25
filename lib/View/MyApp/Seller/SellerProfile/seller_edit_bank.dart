// ignore_for_file: must_be_immutable

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:era_shop/Controller/GetxController/seller/seller_edit_profile_controller.dart';
import 'package:era_shop/custom/main_button_widget.dart';
import 'package:era_shop/custom/simple_app_bar_widget.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SellerEditBank extends StatelessWidget {
  SellerEditBank({super.key});
  SellerEditProfileController sellerEditProfileController = Get.put(SellerEditProfileController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SellerEditProfileController>(
      builder: (controller) => Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.transparent,
            surfaceTintColor: AppColors.transparent,
            flexibleSpace: const SimpleAppBarWidget(title: "Edit Bank Account"),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Text(
                        St.bankNameText.tr,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          color: isDark.value ? AppColors.white : AppColors.mediumGrey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 55,
                  width: Get.width,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: AppColors.tabBackground,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonFormField2(
                    value: sellerEditProfileController.editBankNameController.text,
                    dropdownStyleData: DropdownStyleData(decoration: BoxDecoration(color: AppColors.tabBackground)),
                    decoration: const InputDecoration(
                      isDense: true,
                      suffixIconConstraints: BoxConstraints(minWidth: 2, minHeight: 2),
                      prefixIconConstraints: BoxConstraints(minWidth: 2, minHeight: 2),
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                    ),
                    isExpanded: true,
                    hint: Text(St.pleaseSelectBankName.tr, style: AppFontStyle.styleW500(AppColors.unselected, 15)),
                    items: sellerEditProfileController.bankList
                        .map(
                          (item) => DropdownMenuItem<String>(
                            value: item,
                            child: Row(
                              children: [
                                const SizedBox(width: 8),
                                Text(item, style: AppFontStyle.styleW700(AppColors.white, 15)),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select bank.';
                      }
                      return value;
                    },
                    onChanged: (value) {
                      sellerEditProfileController.editBankNameController.text = value.toString();
                    },
                    onSaved: (value) {
                      sellerEditProfileController.editBankNameController.text = value.toString();
                    },
                  ),
                ),
                // SizedBox(
                //   height: 60,
                //   width: Get.width,
                //   child: DropdownButtonFormField<String>(
                //     value: editBankName,
                //     onChanged: (value) {
                //       sellerEditProfileController.editBankNameController.text = value!;
                //     },
                //     dropdownColor: isDark.value ? AppColors.blackBackground : AppColors.dullWhite,
                //     style: TextStyle(color: isDark.value ? AppColors.dullWhite : AppColors.black, fontSize: 16),
                //     decoration: InputDecoration(
                //         hintText: St.stateTFHintText.tr,
                //         filled: true,
                //         fillColor: isDark.value ? AppColors.blackBackground : AppColors.dullWhite,
                //         hintStyle: GoogleFonts.plusJakartaSans(color: Colors.grey.shade400, fontSize: 16),
                //         enabledBorder: OutlineInputBorder(
                //             borderSide: isDark.value ? BorderSide(color: Colors.grey.shade800) : BorderSide.none,
                //             borderRadius: BorderRadius.circular(24)),
                //         border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryPink), borderRadius: BorderRadius.circular(26))),
                //     icon: const Icon(Icons.expand_more_outlined),
                //     items: <String>[
                //       'Axis',
                //       "HDFC",
                //       "SBI",
                //       'Kotak',
                //       'IndusInd',
                //       "ICICI",
                //       "IDBI",
                //     ].map((String value) {
                //       return DropdownMenuItem(
                //         value: value,
                //         child: Container(
                //           height: 50,
                //           color: isDark.value ? AppColors.blackBackground : AppColors.dullWhite,
                //           child: Center(
                //             child: Text(
                //               value,
                //               style: GoogleFonts.plusJakartaSans(color: isDark.value ? AppColors.white : AppColors.black),
                //             ),
                //           ),
                //         ),
                //       );
                //     }).toList(),
                //   ),
                // ),
                const SizedBox(height: 15),
                // PrimaryTextField(
                //   titleText: St.accountNumTitle.tr,
                //   hintText: St.enterAccountNum.tr,
                //   controllerType: "EditBankAccNum",
                // ),
                // const SizedBox(height: 15),
                // PrimaryTextField(
                //   titleText: St.ifscText.tr,
                //   hintText: St.ifscHintText.tr,
                //   controllerType: "EditIFSC",
                // ),
                // const SizedBox(height: 15),
                // PrimaryTextField(
                //   titleText: St.branchText.tr,
                //   hintText: St.enterBranch.tr,
                //   controllerType: "EditBranch",
                // ),
                SellerItemWidget(
                  title: St.accountNumTitle.tr,
                  controller: sellerEditProfileController.editAccNumberController,
                ),
                15.height,
                SellerItemWidget(
                  title: St.ifscText.tr,
                  controller: sellerEditProfileController.editIfscController,
                ),
                15.height,
                SellerItemWidget(
                  title: St.branchText.tr,
                  controller: sellerEditProfileController.editBranchController,
                ),
                const SizedBox(height: 15),
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
            St.saveChanges.tr.toUpperCase(),
            style: AppFontStyle.styleW700(AppColors.black, 16),
          ),
          callback: () async {
            await sellerEditProfileController.sellerEditProfile();
            Get.close(2);
          },
        ),
      ),
    );
  }
}

class SellerItemWidget extends StatelessWidget {
  const SellerItemWidget({super.key, required this.title, this.child, this.controller, this.keyboardType});

  final String title;

  final Widget? child;

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
                  controller: controller,
                  cursorColor: AppColors.unselected,
                  keyboardType: keyboardType,
                  style: AppFontStyle.styleW700(AppColors.white, 15),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
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

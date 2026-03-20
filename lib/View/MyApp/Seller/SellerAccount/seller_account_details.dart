import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:waxxapp/Controller/GetxController/seller/seller_common_controller.dart';
import 'package:waxxapp/View/MyApp/Seller/SellerAccount/seller_login.dart';
import 'package:waxxapp/custom/custom_color_bg_widget.dart';
import 'package:waxxapp/custom/main_button_widget.dart';
import 'package:waxxapp/custom/simple_app_bar_widget.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_asset.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SellerAccountDetails extends StatelessWidget {
  SellerAccountDetails({super.key});
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
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                15.height,
                Center(child: Image.asset(AppAsset.icStoreProduct, color: AppColors.primary, height: 50, fit: BoxFit.cover, width: 50)),
                15.height,
                Center(
                  child: Text(
                    St.completeSellerAccount.tr,
                    style: AppFontStyle.styleW900(AppColors.primary, 20),
                    textAlign: TextAlign.center,
                  ),
                ),
                10.height,
                Center(
                  child: Text(
                    St.securelyProcessYourPayment.tr,
                    style: AppFontStyle.styleW500(AppColors.unselected, 12),
                  ),
                ),
                25.height,
                Text(
                  St.bankNameText.tr,
                  style: AppFontStyle.styleW500(AppColors.unselected, 12),
                ),
                10.height,
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
                    value: controller.bankName,
                    dropdownStyleData: DropdownStyleData(decoration: BoxDecoration(color: AppColors.tabBackground)),
                    decoration: const InputDecoration(
                      isDense: true,
                      suffixIconConstraints: BoxConstraints(minWidth: 2, minHeight: 2),
                      prefixIconConstraints: BoxConstraints(minWidth: 2, minHeight: 2),
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                    ),
                    isExpanded: true,
                    hint: Text(
                      St.pleaseSelectBankName.tr,
                      style: AppFontStyle.styleW600(AppColors.unselected, 12),
                    ),
                    items: controller.bankList
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
                      controller.bankName = value.toString();
                    },
                    onSaved: (value) {
                      controller.bankName = value.toString();
                    },
                  ),
                ),
                25.height,
                SellerItemWidget(
                  hintText: St.enterAccountNumber.tr,
                  title: St.accountNumTitle.tr,
                  keyboardType: TextInputType.number,
                  controller: controller.accountNoController,
                ),
                25.height,
                SellerItemWidget(
                  hintText: St.enterIfsc.tr,
                  title: St.ifscText.tr,
                  keyboardType: TextInputType.name,
                  controller: controller.ifscController,
                ),
                25.height,
                SellerItemWidget(
                  hintText: St.enterBranch.tr,
                  title: St.branchText.tr,
                  keyboardType: TextInputType.name,
                  controller: controller.branchController,
                ),
                25.height,
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
          callback: () => controller.onSubmitSellerAccountDetails(),
        ),
      ),
    );
  }
}

// PrimaryTextField(
//   titleText: St.businessNameTFTitle.tr,
//   hintText: St.businessNameTFHintText.tr,
//   controllerType: "bankBusinessName",
// ),
// const SizedBox(height: 15),
// Padding(
//   padding: const EdgeInsets.only(bottom: 8),
//   child: Row(
//     children: [
//       Text(
//         St.bankNameText.tr,
//         style: GoogleFonts.plusJakartaSans(
//           fontSize: 14,
//           color: isDark.value ? AppColors.white : AppColors.mediumGrey,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     ],
//   ),
// ),
// Container(
//   height: 55,
//   width: Get.width,
//   decoration: BoxDecoration(
//     color: AppColors.tabBackground,
//     borderRadius: BorderRadius.circular(12),
//   ),
//   child: DropdownButtonFormField<String>(
//     onChanged: (value) {
//       controller.bankNameController.text = value!;
//     },
//     dropdownColor: AppColors.primary,
//     style: TextStyle(color: isDark.value ? AppColors.dullWhite : AppColors.black),
//     decoration: InputDecoration(
//       hintText: St.stateTFHintText.tr,
//       border: InputBorder.none,
//       hintStyle: GoogleFonts.plusJakartaSans(color: Colors.grey.shade400, fontSize: 16),
//     ),
//     icon: const Icon(
//       Icons.expand_more_outlined,
//       weight: 25,
//     ),
//     items: controller.bankList.map((String value) {
//       return DropdownMenuItem(
//         value: value,
//         alignment: Alignment.centerLeft,
//         child: Container(
//           height: 50,
//           width: Get.width,
//           padding: const EdgeInsets.only(left: 15),
//           alignment: Alignment.centerLeft,
//           color: AppColors.tabBackground,
//           child: Text(
//             value,
//             style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w500, color: isDark.value ? AppColors.white : AppColors.white),
//           ),
//         ),
//       );
//     }).toList(),
//   ),
// ),
// const SizedBox(height: 15),
// PrimaryTextField(
//   titleText: St.accountNumTitle.tr,
//   hintText: St.enterAccountNum.tr,
//   controllerType: "AccountNumber",
// ),
// const SizedBox(height: 15),
// PrimaryTextField(
//   titleText: St.ifscText.tr,
//   hintText: St.ifscHintText.tr,
//   controllerType: "IFSC",
// ),
// const SizedBox(height: 15),
// PrimaryTextField(
//   titleText: St.branchText.tr,
//   hintText: St.enterBranch.tr,
//   controllerType: "Branch",
// ),
// const SizedBox(height: 15),

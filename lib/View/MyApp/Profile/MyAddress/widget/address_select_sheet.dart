import 'dart:developer';

import 'package:waxxapp/Controller/GetxController/seller/seller_edit_profile_controller.dart';
import 'package:waxxapp/Controller/GetxController/user/user_add_address_controller.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_asset.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

List<dynamic>? searchCountryList = [];
addressSelectSheet(
    {BuildContext? context,
    List<dynamic>? countries,
    TextEditingController? controller,
    UserAddAddressController? userAddAddressController,
    SellerEditProfileController? sellerEditProfileController,
    required Function onTap,
    required Function onStateTap,
    bool? isStateValue,
    String? hintText,
    bool? updateStateValue}) {
  log("list>>>:${countries?.toList()}");
  searchCountryList?.clear();
  controller?.text = "";
  FocusManager.instance.primaryFocus?.unfocus();
  return showModalBottomSheet(
    backgroundColor: AppColors.black,
    barrierColor: AppColors.tabBackground.withValues(alpha: 0.8),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    context: context!,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, call) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      width: Get.width,
                      padding: const EdgeInsets.only(left: 15),
                      decoration: BoxDecoration(
                        color: AppColors.tabBackground,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        children: [
                          Image.asset(AppAsset.icSearch, width: 20, color: AppColors.unselected),
                          10.width,
                          Expanded(
                            child: TextFormField(
                              style: TextStyle(color: AppColors.white),
                              cursorColor: AppColors.unselected,
                              controller: controller,
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  searchCountryList = countries?.where((element) => element.toLowerCase().contains(value.toLowerCase())).toList();
                                } else {
                                  searchCountryList = countries;
                                }
                                call(() {});
                              },
                              decoration: InputDecoration(
                                hintText: hintText,
                                hintStyle: GoogleFonts.plusJakartaSans(color: AppColors.unselected, fontSize: 16),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 377,
                    child: (searchCountryList?.isNotEmpty ?? true)
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: searchCountryList?.length ?? 0,
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () {
                                  if (isStateValue == true) {
                                    userAddAddressController?.stateController.text = searchCountryList?[index] ?? "";
                                  } else {
                                    userAddAddressController?.myCountryController.text = searchCountryList?[index] ?? "";
                                  }

                                  onTap(searchCountryList?[index]);
                                  onStateTap(searchCountryList?[index]);
                                  Get.back();
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                                title: Text(
                                  searchCountryList?[index] ?? "",
                                  style: AppFontStyle.styleW500(AppColors.white, 17),
                                ),
                              );
                            },
                          )
                        : (controller?.text.isNotEmpty ?? true)
                            ? Center(child: Text(St.noDataFound.tr))
                            : (countries?.isNotEmpty ?? true)
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: countries?.length ?? 0,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        onTap: () {
                                          if (isStateValue == true) {
                                            userAddAddressController?.stateController.text = countries?[index] ?? "";
                                          } else {
                                            userAddAddressController?.myCountryController.text = countries?[index] ?? "";
                                          }

                                          onTap(countries?[index]);
                                          onStateTap(countries?[index]);
                                          Get.back();

                                          FocusManager.instance.primaryFocus?.unfocus();
                                        },
                                        title: Text(
                                          countries?[index] ?? "",
                                          style: AppFontStyle.styleW500(AppColors.white, 17),
                                        ),
                                      );
                                    },
                                  )
                                : Center(child: Text(St.noDataFound.tr)),
                  )
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

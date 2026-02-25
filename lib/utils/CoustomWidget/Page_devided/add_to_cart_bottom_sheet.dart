// ignore_for_file: must_be_immutable
import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:era_shop/utils/CoustomWidget/App_theme_services/primary_buttons.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/shimmers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Controller/GetxController/user/add_product_to_cart_controller.dart';
import '../../../Controller/GetxController/user/remove_all_product_from_cart_controller.dart';
import '../../../Controller/GetxController/user/user_product_details_controller.dart';
import '../../app_circular.dart';
import '../../globle_veriables.dart';
import '../../show_toast.dart';

class AddToCartBottomSheet extends StatelessWidget {
  final String? productImage;
  final String? productName;
  final String? productPrice;

  AddToCartBottomSheet({super.key, this.productImage, this.productName, this.productPrice});

  UserProductDetailsController userProductDetailsController = Get.put(UserProductDetailsController());
  AddProductToCartController addProductToCartController = Get.put(AddProductToCartController());
  RemoveAllProductFromCartController removeAllProductFromCartController = Get.put(RemoveAllProductFromCartController());

  Map<String, DropdownController> dropdownControllers = {};
  bool areAllAttributesFilled = false;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          height: Get.height / 1.4,
          width: Get.width,
          decoration: BoxDecoration(color: const Color(0xffffffff), borderRadius: const BorderRadius.vertical(top: Radius.circular(25))),
          child: Stack(
            children: [
              Obx(
                () => userProductDetailsController.isLoading.value
                    ? Shimmers.addToCartBottomSheet().paddingOnly(top: 120)
                    : SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                              child: Column(
                                children: userProductDetailsController.selectedValuesByType.keys.map((key) {
                                  DropdownController dropdownController = dropdownControllers[key] ?? DropdownController();
                                  userProductDetailsController.categoryDropdownItems =
                                      userProductDetailsController.selectedValuesByType[key]!.map((value) {
                                    return CoolDropdownItem<String>(
                                      value: value,
                                      label: value,
                                    );
                                  }).toList();
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 3),
                                        child: Text(
                                          key.capitalizeFirst.toString(),
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 7),
                                        child: CoolDropdown<dynamic>(
                                          controller: dropdownController,
                                          dropdownList: userProductDetailsController.categoryDropdownItems,
                                          defaultItem: null,
                                          onChange: (value) async {
                                            if (dropdownController.isError) {
                                              await dropdownController.resetError();
                                            } else {
                                              setState(() {
                                                dropdownController.close();
                                                addProductToCartController.selectedValues[key] = value;
                                                log("selectedValues  ${addProductToCartController.selectedValues}");
                                                List<Map<String, String>> selectedValueList = addProductToCartController.selectedValues.entries
                                                    .map((entry) => {entry.key: entry.value})
                                                    .toList();

                                                log("selectedValueList :: $selectedValueList");
                                                // aa value api ma moklwani thashe
                                                log("selectedValueList Json String :: ${jsonEncode(selectedValueList)}");

                                                bool allAttributesFilled = userProductDetailsController.selectedValuesByType.keys
                                                    .every((key) => addProductToCartController.selectedValues[key] != null);
                                                setState(() {
                                                  areAllAttributesFilled = allAttributesFilled;
                                                  log("Attrubutes Filled :: $areAllAttributesFilled");
                                                });
                                                log("All attributr selected or not :: $areAllAttributesFilled");
                                              });
                                            }
                                            userProductDetailsController.sizeSelectController.text = value;
                                          },
                                          onOpen: (value) {},
                                          resultOptions: ResultOptions(
                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                            height: 58,
                                            width: Get.width,
                                            boxDecoration: BoxDecoration(
                                              border: Border.all(color: AppColors.mediumGrey),
                                              borderRadius: BorderRadius.circular(26),
                                              color: AppColors.dullWhite,
                                            ),
                                            errorBoxDecoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(26), border: Border.all(color: AppColors.primaryRed, width: 1.8)),
                                            icon: const SizedBox(
                                              width: 10,
                                              height: 10,
                                              child: CustomPaint(
                                                painter: DropdownArrowPainter(),
                                              ),
                                            ),
                                            placeholder: 'Select $key'.capitalizeFirst.toString(),
                                            placeholderTextStyle:
                                                GoogleFonts.plusJakartaSans(color: Colors.grey.shade400, fontSize: 15.3, fontWeight: FontWeight.w600),
                                            textStyle: GoogleFonts.plusJakartaSans(fontSize: 16),
                                            isMarquee: true,
                                            alignment: Alignment.center,
                                            openBoxDecoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(26),
                                                border: Border.all(color: AppColors.primaryPink, width: 1.8)),
                                          ),
                                          dropdownOptions: DropdownOptions(
                                              borderRadius: BorderRadius.circular(15),
                                              top: 10,
                                              height: 250,
                                              width: 150,
                                              gap: const DropdownGap.all(5),
                                              selectedItemAlign: SelectedItemAlign.center,
                                              curve: Curves.bounceInOut,
                                              borderSide: BorderSide(color: AppColors.primaryPink, width: 2),
                                              color: AppColors.dullWhite,
                                              align: DropdownAlign.right,
                                              animationType: DropdownAnimationType.scale),
                                          dropdownTriangleOptions: const DropdownTriangleOptions(
                                            width: 0,
                                            height: 0,
                                            align: DropdownTriangleAlign.right,
                                            borderRadius: 0,
                                            left: 0,
                                          ),
                                          dropdownItemOptions: DropdownItemOptions(
                                            textStyle: TextStyle(
                                              color: AppColors.white,
                                            ),
                                            selectedTextStyle: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w600),
                                            selectedBoxDecoration:
                                                BoxDecoration(border: Border.all(width: 2), color: AppColors.primaryPink.withValues(alpha: 0.20)),
                                            isMarquee: true,
                                            alignment: Alignment.centerRight,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            render: DropdownItemRender.all,
                                            height: 50,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              child: GestureDetector(
                                onTap: () async {
                                  if (areAllAttributesFilled != true) {
                                    displayToast(message: "Please fill all attributes!");
                                  } else {
                                    addProductToCartController.addToCartWhenLive();
                                  }
                                },
                                child: Container(
                                  height: 58,
                                  decoration: BoxDecoration(
                                      color: areAllAttributesFilled == false ? AppColors.darkGrey.withValues(alpha: 0.40) : AppColors.primaryPink,
                                      borderRadius: BorderRadius.circular(24)),
                                  child: Center(
                                    child: Obx(
                                      () => Text(
                                        addProductToCartController.isAddToCart.isFalse ? St.addToCart.tr : St.goToCart.tr,
                                        style: GoogleFonts.plusJakartaSans(
                                            color: areAllAttributesFilled == false ? AppColors.darkGrey : AppColors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ).paddingOnly(top: 130),
                      ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 130,
                  width: Get.width,
                  decoration: const BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          height: 100,
                          width: 85,
                          fit: BoxFit.cover,
                          imageUrl: productImage.toString(),
                          placeholder: (context, url) => const Center(
                              child: CupertinoActivityIndicator(
                            animating: true,
                          )),
                          errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                        ),
                      ).paddingOnly(right: 20, left: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            productName.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(fontSize: 17, fontWeight: FontWeight.w600),
                          ).paddingOnly(bottom: 8),
                          Text(
                            "$currencySymbol${productPrice.toString()}",
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                      alignment: Alignment.topRight,
                      child: PrimaryRoundButton(
                          onTaped: () {
                            setState(() {
                              addProductToCartController.isAddToCart(false);
                            });
                            Get.back();
                          },
                          icon: Icons.close))
                  .paddingAll(15),
              Obx(
                () => addProductToCartController.userAddProLoading.value ? ScreenCircular.blackScreenCircular() : const SizedBox(),
              ),
            ],
          ),
        );
      },
    );
  }
}

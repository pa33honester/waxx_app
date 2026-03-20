import 'dart:developer';

import 'package:waxxapp/ApiModel/user/AddProductToCartModel.dart';
import 'package:waxxapp/ApiService/user/add_product_to_cart_service.dart';
import 'package:waxxapp/Controller/GetxController/user/remove_all_product_from_cart_controller.dart';
import 'package:waxxapp/Controller/GetxController/user/user_product_details_controller.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AddProductToCartController extends GetxController {
  AddProductToCartModel? addProductToCart;
  RxBool isLoading = false.obs;
  RxBool userAddProLoading = false.obs;

  RxBool isAddToCart = false.obs;
  Map<String, String> selectedValues = {};
  RemoveAllProductFromCartController removeAllProductFromCartController = Get.put(RemoveAllProductFromCartController());
  UserProductDetailsController userProductDetailsController = Get.put(UserProductDetailsController());

  var itemLoadingMap = <String, bool>{}.obs;

  void setItemLoading(String id, bool isLoading) {
    itemLoadingMap[id] = isLoading;
  }

  Future addProductToCartData({required int productQuantity, required List<dynamic> attributes}) async {
    try {
      isLoading(true);
      log("Controller :::: userId :: $loginUserId \n productId :: $productId \n productQuantity :: $productQuantity \n attributesArray :: $attributes");

      var data = await AddProductToCartApi().addProductToCart(
        userId: loginUserId,
        productId: productId,
        productQuantity: productQuantity,
        attributes: attributes,
      );
      addProductToCart = data;
      // if (addProductToCart?.status == true) {
      isAddToCart(true);

      /*Get.back();
      final controller = Get.put(BottomBarController());
      controller.onChangeBottomBar(2);*/

      // Get.toNamed("/CartPage");

      // }
      // else {
      //   Get.dialog(
      //     Dialog(
      //       backgroundColor: Colors.transparent,
      //       child: Container(
      //         decoration: BoxDecoration(color: AppColors.tabBackground, borderRadius: BorderRadius.circular(25)),
      //         child: Column(
      //           mainAxisSize: MainAxisSize.min,
      //           crossAxisAlignment: CrossAxisAlignment.center,
      //           children: [
      //             Container(
      //               height: 50,
      //               width: double.maxFinite,
      //               decoration: BoxDecoration(
      //                 color: AppColors.primaryPink,
      //                 borderRadius: const BorderRadius.vertical(
      //                   top: Radius.circular(25),
      //                 ),
      //               ),
      //               child: Center(
      //                 child: Text(
      //                   St.addToCart.tr,
      //                   style: GoogleFonts.plusJakartaSans(
      //                     fontSize: 17,
      //                     fontWeight: FontWeight.w600,
      //                     color: AppColors.black,
      //                   ),
      //                 ),
      //               ),
      //             ),
      //             Image.asset("assets/icons/add-to-shopping-cart2.png", height: 200).paddingSymmetric(vertical: 8),
      //             Text(
      //               St.onlyOneSellersProductsAddedToCartAtATimeCanWeRemoveIt.tr,
      //               textAlign: TextAlign.center,
      //               style: GoogleFonts.plusJakartaSans(
      //                 height: 1.5,
      //                 fontWeight: FontWeight.w500,
      //                 fontSize: 15,
      //                 color: AppColors.darkGrey,
      //               ),
      //             ).paddingSymmetric(horizontal: 15),
      //             Row(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               children: [
      //                 GestureDetector(
      //                   onTap: () => removeAllProductFromCartController.deleteAllCartProduct().then((value) => Get.back()),
      //                   // .then((value) => addToCart()),
      //                   child: Container(
      //                     height: 50,
      //                     width: Get.width / 3,
      //                     decoration: BoxDecoration(color: AppColors.primaryPink, borderRadius: BorderRadius.circular(16)),
      //                     child: Center(
      //                       child: Text(
      //                         St.remove.tr,
      //                         style:
      //                             GoogleFonts.plusJakartaSans(color: AppColors.black, fontSize: 16, fontWeight: FontWeight.w500),
      //                       ),
      //                     ),
      //                   ),
      //                 ).paddingOnly(right: 13),
      //                 GestureDetector(
      //                   onTap: () {
      //                     Get.back();
      //                   },
      //                   child: Container(
      //                     height: 50,
      //                     width: Get.width / 3,
      //                     decoration: BoxDecoration(color: AppColors.primaryPink, borderRadius: BorderRadius.circular(16)),
      //                     child: Center(
      //                       child: Text(
      //                         St.cancelSmallText.tr,
      //                         style:
      //                             GoogleFonts.plusJakartaSans(color: AppColors.black, fontSize: 16, fontWeight: FontWeight.w500),
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             ).paddingSymmetric(vertical: 15)
      //           ],
      //         ),
      //       ),
      //     ),
      //   );
      // }
    } catch (e) {
      log('ADD PRODUCT TO CART: $e');
    } finally {
      isLoading(false);
      log('ADD PRODUCT TO CART Api Response');
    }
  }

  addToCartWhenLive() {
    List<Map<String, String>> attributesArray = selectedValues.entries.map((entry) {
      return {
        "name": entry.key,
        "values": entry.value,
      };
    }).toList();

    addToCart(
      productQuantity: 1,
      attributes: attributesArray,
    );
  }

  addToCart({required int productQuantity, required List<dynamic> attributes}) async {
    RemoveAllProductFromCartController removeAllProductFromCartController = Get.put(RemoveAllProductFromCartController());

    try {
      userAddProLoading(true);
      log("addToCartWhenLive :::: userId :: $loginUserId \n productId :: $productId \n productQuantity :: $productQuantity \n attributesArray :: $selectedValues");

      var data = await AddProductToCartApi().addProductToCart(
        userId: loginUserId,
        productId: productId,
        productQuantity: productQuantity,
        attributes: attributes,
      );
      addProductToCart = data;
      if (addProductToCart!.status == true) {
        Get.dialog(Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: AppColors.primaryPink,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(25),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Add to Cart",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
                Image.asset("assets/icons/add-to-shopping-cart2.png", height: 200).paddingSymmetric(vertical: 8),
                Text(
                  "Your product added to cart successfully!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: AppColors.darkGrey,
                  ),
                ).paddingSymmetric(horizontal: 15),
                GestureDetector(
                  onTap: () {
                    Get.back();
                    Get.back();
                  },
                  child: Container(
                    height: 50,
                    width: Get.width / 2,
                    decoration: BoxDecoration(color: AppColors.primaryPink, borderRadius: BorderRadius.circular(16)),
                    child: Center(
                      child: Text(
                        "Continue",
                        style: GoogleFonts.plusJakartaSans(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ).paddingSymmetric(vertical: 15)
              ],
            ),
          ),
        ));
      } else {
        Get.dialog(Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: AppColors.primaryPink,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(25),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Add to Cart",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
                Image.asset("assets/icons/add-to-shopping-cart2.png", height: 200).paddingSymmetric(vertical: 8),
                Text(
                  "Only one seller's products added to cart at a time,can we remove it!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: AppColors.darkGrey,
                  ),
                ).paddingSymmetric(horizontal: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => removeAllProductFromCartController.deleteAllCartProduct().then((value) => Get.back()).then((value) => addToCartWhenLive()),
                      child: Container(
                        height: 50,
                        width: Get.width / 3,
                        decoration: BoxDecoration(color: AppColors.primaryPink, borderRadius: BorderRadius.circular(16)),
                        child: Center(
                          child: Text(
                            St.remove.tr,
                            style: GoogleFonts.plusJakartaSans(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ).paddingOnly(right: 13),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        height: 50,
                        width: Get.width / 3,
                        decoration: BoxDecoration(color: AppColors.primaryPink, borderRadius: BorderRadius.circular(16)),
                        child: Center(
                          child: Text(
                            St.cancelText.tr,
                            style: GoogleFonts.plusJakartaSans(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ],
                ).paddingSymmetric(vertical: 15)
              ],
            ),
          ),
        ));
      }
    } catch (e) {
      log('ADD PRODUCT TO CART: $e');
    } finally {
      userAddProLoading(false);
      log('ADD PRODUCT TO CART Api Response');
    }
  }

  ///
}

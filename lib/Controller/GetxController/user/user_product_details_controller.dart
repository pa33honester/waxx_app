import 'dart:convert';
import 'dart:developer';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:waxxapp/ApiModel/user/UserProductDetailsModel.dart';
import 'package:waxxapp/ApiModel/user/related_product_model.dart';
import 'package:waxxapp/ApiService/user/auction_bid_service.dart';
import 'package:waxxapp/ApiService/user/user_product_details_service.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserProductDetailsController extends GetxController {
  UserProductDetailsModel? userProductDetails;
  RxBool isLoading = true.obs;
  final TextEditingController sizeSelectController = TextEditingController();

  RxMap<String, List<String>> selectedValuesByType = RxMap<String, List<String>>();
  List<Attribute>? selectedCategoryValues = [];
  // RxList<Attribute> selectedAttributes = <Attribute>[].obs;
  List<CoolDropdownItem<String>> categoryDropdownItems = [];

  bool isSwiped = false;

  // userProductDetailsData() async {
  //   try {
  //     isLoading(true);
  //     var data = await UserProductDetailsApi().userProductDetails(productId: productId, userId: userId);
  //     userProductDetails = data;
  //     if (userProductDetails?.status == true) {
  //       selectedAttributes.value = userProductDetails!.product![0].attributes ?? [];
  //       update();
  //     }
  //   } catch (e) {
  //     log('Error: $e');
  //   } finally {
  //     isLoading(false);
  //   }
  // }
  //
  // List<Map<String, dynamic>> getSelectedAttributesForApi() {
  //   return selectedAttributes.map((attr) {
  //     return {
  //       "name": attr.name,
  //       "fieldType": attr.fieldType,
  //       "values": attr.values != null ? [attr.values!] : [],
  //       "minLength": attr.minLength,
  //       "maxLength": attr.maxLength,
  //       "isRequired": attr.isRequired,
  //       "_id": attr.id,
  //     };
  //   }).toList();
  // }

  var isDescriptionExpanded = false.obs;

  void toggleDescription() {
    isDescriptionExpanded.value = !isDescriptionExpanded.value;
  }

  userProductDetailsData() async {
    try {
      isLoading(true);
      var data = await UserProductDetailsApi().userProductDetails(productId: productId, userId: loginUserId);
      userProductDetails = data;
      if (userProductDetails?.status == true) {
        selectedCategoryValues = userProductDetails!.product![0].attributes;

        log("Json response :: ${jsonEncode(selectedCategoryValues)}");

        for (var categoryValue in selectedCategoryValues!) {
          selectedValuesByType[categoryValue.name.toString()] = List<String>.from(categoryValue.values!.toList());
        }
        log("A aavo data :: $selectedValuesByType");

        if (userProductDetails!.product![0].category?.id != null) {
          await getRelatedProducts(userProductDetails!.product![0].category!.id!);
        }
        update();
      }
    } catch (e) {
      log('product detail Error: $e');
    } finally {
      isLoading(false);
      log('User Product Details finally');
    }
  }

  getRelatedProducts(String categoryId) async {
    try {
      isLoading(true);
      var data = await UserProductDetailsApi().relatedProducts(productId: productId, userId: loginUserId, categoryId: userProductDetails?.product?[0].category?.id ?? '');
      relatedProductModel = data;
      print('--------------${json.encode(relatedProductModel)}');
    } catch (e) {
      log('product detail Error: $e');
    } finally {
      isLoading(false);
      log('User Product Details finally');
    }
  }

  RxBool isAuctionLoading = true.obs;
  final Rx<num> latestBidAmount = 0.obs;

  // Future<void> placeBidData({
  //   required String userId,
  //   required String productId,
  //   required String bidAmount,
  //   required Map<String, dynamic>? selectedValues,
  // }) async {
  //   try {
  //     Get.focusScope?.unfocus();
  //     Get.dialog(
  //       Center(
  //         child: CircularProgressIndicator(
  //           color: AppColors.primary,
  //         ),
  //       ),
  //       barrierDismissible: false,
  //     );
  //
  //     // Prepare attributes array same as add to cart
  //     final originalAttributes = selectedCategoryValues;
  //     List<Map<String, dynamic>> attributesArray = [];
  //
  //     if (selectedValues != null && selectedValues.isNotEmpty) {
  //       attributesArray = selectedValues.entries.map((entry) {
  //         final originalAttribute = originalAttributes?.firstWhere(
  //           (attr) => attr.name == entry.key,
  //           orElse: () => Attribute(), // Fallback if not found
  //         );
  //
  //         return {
  //           "name": entry.key,
  //           "values": [entry.value],
  //           "image": originalAttribute?.image,
  //         };
  //       }).toList();
  //     }
  //
  //     PlaceBidModel response = await AuctionBidService().placeBid(userId: userId, productId: productId, bidAmount: bidAmount, attributes: attributesArray);
  //     Get.back();
  //     if (response.status == true) {
  //       await userProductDetailsData();
  //       Utils.showToast(response.message ?? "Bid placed successfully!");
  //     } else {
  //       Utils.showToast(response.message ?? "Failed to place bid");
  //     }
  //   } catch (e) {
  //     Get.back();
  //     Utils.showToast("Something went wrong.${e.toString()}");
  //   } finally {
  //     Get.back();
  //   }
  // }

  Future<void> placeBidData({
    required String userId,
    required String productId,
    required String bidAmount,
    required Map<String, dynamic>? selectedValues,
  }) async {
    bool loaderShown = false;
    try {
      Get.focusScope?.unfocus();

      Get.dialog(
        Center(
            child: CircularProgressIndicator(
          color: AppColors.primary,
        )),
        barrierDismissible: false,
      );
      loaderShown = true;

      final originalAttributes = selectedCategoryValues;
      List<Map<String, dynamic>> attributesArray = [];
      if (selectedValues != null && selectedValues.isNotEmpty) {
        attributesArray = selectedValues.entries.map((entry) {
          final originalAttribute = originalAttributes?.firstWhere(
            (attr) => attr.name == entry.key,
            orElse: () => Attribute(),
          );
          return {
            "name": entry.key,
            "values": [entry.value],
            "image": originalAttribute?.image,
          };
        }).toList();
      }

      final response = await AuctionBidService().placeBid(userId: userId, productId: productId, bidAmount: bidAmount, attributes: attributesArray);

      if (response.status == true) {
        await userProductDetailsData();
        Get.back();
        Utils.showToast(response.message ?? "Bid placed successfully!");
      } else {
        Utils.showToast(response.message ?? "Failed to place bid");
      }
    } catch (e) {
      Utils.showToast("Something went wrong.${e.toString()}");
    } finally {
      if (loaderShown) {
        Get.back();
      }
    }
  }

  RelatedProductModel? relatedProductModel;

  @override
  void onInit() {
    userProductDetailsData();
    super.onInit();
  }
}

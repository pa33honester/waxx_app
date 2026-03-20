import 'dart:convert';
import 'dart:developer';
import 'package:waxxapp/ApiModel/seller/SellerProductDetailsModel.dart';
import 'package:waxxapp/ApiService/seller/seller_product_details_service.dart';
import 'package:waxxapp/Controller/GetxController/seller/add_product_controller.dart';
import 'package:waxxapp/Controller/GetxController/seller/attributes_add_product_controller.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../user/get_all_category_controller.dart';

class SellerProductDetailsController extends GetxController {
  AddProductController addProductController = Get.put(AddProductController());
  AttributesAddProductController attributesAddProductController = Get.put(AttributesAddProductController());
  GetAllCategoryController getAllCategoryController = Get.put(GetAllCategoryController());
  SellerProductDetailsModel? sellerProductDetails;
  RxBool isLoading = true.obs;
  String productName = "";
  String price = "";
  String shippingCharge = "";
  String? productCode;

  var isDescriptionExpanded = false.obs;

  void toggleDescription() {
    isDescriptionExpanded.value = !isDescriptionExpanded.value;
  }

  final TextEditingController descriptionController = TextEditingController();

  List<Attributes>? selectedCategoryValues = [];

  RxMap<String, List<String>> selectedValuesByType = RxMap<String, List<String>>();

  void toggleSelection(String value, String type) {
    if (selectedValuesByType[type]?.contains(value) ?? false) {
      selectedValuesByType[type]?.remove(value);
    } else {
      if (selectedValuesByType[type] == null) {
        selectedValuesByType[type] = <String>[value];
      } else {
        selectedValuesByType[type]?.add(value);
      }
    }
  }

  String selectedCategoryId = '';
  String selectedSubCategoryId = '';

  getProductDetails() async {
    try {
      isLoading(true);
      var data = await SellerProductDetailsApi().sellerProductDetails(productId: productId, sellerId: sellerId);
      sellerProductDetails = data;
      productCode = sellerProductDetails!.product![0].productCode; // paerams ma product Code add krwano chhe

      String? categoryId = sellerProductDetails!.product![0].category!.id;
      String? categoryName = sellerProductDetails!.product![0].category!.name;

      String? subCategoryId = sellerProductDetails!.product![0].subCategory!.id;
      String? subCategoryName = sellerProductDetails!.product![0].subCategory!.name;

      selectedCategoryId = categoryId!;
      selectedSubCategoryId = subCategoryId!;

      if (getAllCategoryController.categoryList.isNotEmpty) {
        selectedCategoryId = getAllCategoryController.categoryList[0].id!;

        // Check if the selected category ID exists in the category list
        bool isCategoryExists = getAllCategoryController.categoryList.any((category) => category.id == selectedCategoryId);
        if (isCategoryExists) {
          selectedSubCategoryId = getAllCategoryController.categoryList.firstWhere((category) => category.id == selectedCategoryId).subCategory![0].id!;
        } else {
          // Handle the case when the selected category does not exist
          selectedCategoryId = '';
          selectedSubCategoryId = '';
        }
      }

      // Print the extracted values for testing
      log('Selected Category: $categoryName ($categoryId)');
      log('Selected Subcategory: $subCategoryName ($subCategoryId)');
      log('Selected Attributes: $subCategoryName ($subCategoryId)');

      if (sellerProductDetails!.status == true) {
        descriptionController.text = "${sellerProductDetails!.product![0].description}";
        productName = sellerProductDetails!.product![0].productName!;
        price = "${sellerProductDetails!.product![0].price!}";
        shippingCharge = "${sellerProductDetails!.product![0].shippingCharges}";
        selectedCategoryValues = sellerProductDetails!.product![0].attributes;
        selectedCategoryId = sellerProductDetails!.product![0].category!.id!;
        selectedSubCategoryId = sellerProductDetails!.product![0].subCategory!.id!;

        log("Json Encode :: ${jsonEncode(selectedCategoryValues)}");

        for (var categoryValue in selectedCategoryValues!) {
          selectedValuesByType[categoryValue.name.toString()] = List<String>.from(categoryValue.values!.toList());
        }
        log("A aavo data :: $selectedValuesByType");

        addProductController.nameController.text = productName;
        addProductController.priceController.text = price;
        addProductController.shippingChargeController.text = shippingCharge;
      }
    } finally {
      isLoading(false);
      log('Seller product details finally');
    }
  }
}

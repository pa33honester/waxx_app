import 'dart:developer' as log;
import 'dart:io';
import 'dart:math';

import 'package:waxxapp/Controller/GetxController/seller/attributes_add_product_controller.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../ApiModel/seller/AddProductModel.dart';
import '../../../ApiService/seller/add_product_service.dart';
import '../../../utils/show_toast.dart';

class AddProductController extends GetxController {
  AddProductModel? addProduct;
  RxBool isLoading = false.obs;
  AttributesAddProductController attributesAddProductController = Get.put(AttributesAddProductController());

  PageController pageController = PageController();

  String generateRandomCode() {
    Random random = Random();
    int min = 100000; // Minimum 6-digit number
    int max = 999999; // Maximum 6-digit number
    int randomNumber = min + random.nextInt(max - min);
    return randomNumber.toString();
  }

  File? productImageXFile;
  List<File> addProductImages = [];
  List<Map<String, dynamic>> attributes = [];

  //--------------------------------------------------------
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController shippingChargeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String? category;
  String? subCategory;

  addCatalog() async {
    try {
      isLoading(true);
      // if (addProductImages.isEmpty ||
      //     nameController.text.trim().isEmpty ||
      //     priceController.text.trim().isEmpty ||
      //     category!.isEmpty ||
      //     subCategory!.isEmpty ||
      //     shippingChargeController.text.trim().isEmpty ||
      //     descriptionController.text.trim().isEmpty) {
      //   Utils.showToast("All fields are required to be filled");
      // } else {
      /// **************** API CALLING *****************\\\
      attributesAddProductController.selectedValuesByType.forEach((key, values) {
        Map<String, dynamic> attribute = {
          'name': key,
          'value': values,
        };
        attributes.add(attribute);
      });
      log.log("Attributes :: $attributes");

      // var data = await AddProductApi().addProduct(
      //     sellerId: sellerId,
      //     mainImage: addProductImages[0],
      //     images: addProductImages,
      //     productName: nameController.text.toString().capitalizeFirst.toString(),
      //     price: priceController.text,
      //     category: category.toString(),
      //     subCategory: subCategory.toString(),
      //     shippingCharges: shippingChargeController.text,
      //     description: descriptionController.text,
      //     attributes: attributes,
      //     productCode: generateRandomCode());
      // addProduct = data;

      if (addProduct!.status == true) {
        Utils.showToast("Catalog add successfully");
        Get.close(4);
      } else {
        displayToast(message: St.somethingWentWrong.tr);
      }
      // }
    } catch (e) {
      Exception("Add product Error ::  $e");
    } finally {
      isLoading(false);
    }
  }
}

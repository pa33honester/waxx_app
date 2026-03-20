// ignore_for_file: unrelated_type_equality_checks

import 'dart:developer';
import 'dart:io';
import 'package:waxxapp/Controller/GetxController/seller/seller_product_detail_controller.dart';
import 'package:waxxapp/utils/show_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../ApiModel/seller/ProductEditModel.dart';
import '../../../ApiService/seller/product_edit_service.dart';

class EditProductController extends GetxController {
  ProductEditModel? productEditModel;
  RxBool isLoading = false.obs;
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  SellerProductDetailsController sellerProductDetailsController = Get.put(SellerProductDetailsController());

  List<Map<String, dynamic>> attributes = [];

  editCatalog({
    required File mainImage,
    required List<File> images,
    required String productCode,
    required String productName,
    required String price,
    required String category,
    required String subCategory,
    required String shippingCharges,
    required String description,
  }) async {
    try {
      sellerProductDetailsController.selectedValuesByType.forEach((key, values) {
        String attributeName = key;
        String? attributeId;

        for (var attribute in sellerProductDetailsController.selectedCategoryValues!) {
          if (attribute.name == attributeName) {
            attributeId = attribute.id;
            break;
          }
        }

        Map<String, dynamic> attribute = {
          'name': attributeName,
          'value': values,
          '_id': attributeId,
        };
        attributes.add(attribute);
      });

      log("Edit Product Attributes :: $attributes");

      // var data = await ProductEditApi().editProduct(
      //     mainImage: mainImage,
      //     images: images,
      //     productCode: productCode,
      //     productName: productName,
      //     price: price,
      //     category: category,
      //     subCategory: subCategory,
      //     shippingCharges: shippingCharges,
      //     description: description,
      //     attributes: attributes);
      // productEditModel = data;
      if (productEditModel!.status == true) {
        displayToast(message: "Catalog Edit successfully").then((value) => Get.back(result: true));
      }
    } finally {
      isLoading(false);
      log('Add Product Api Response');
    }
  }
}

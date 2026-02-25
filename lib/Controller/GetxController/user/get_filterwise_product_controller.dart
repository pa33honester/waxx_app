import 'dart:developer';

import 'package:get/get.dart';

import '../../../ApiModel/user/GetFilterwiseProductModel.dart';
import '../../../ApiService/user/get_filterwise_product_service.dart';
import '../../../utils/show_toast.dart';

class GetFilterWiseProductController extends GetxController {
  GetFilterwiseProductModel? getFilterWiseProduct;
  RxBool isLoading = false.obs;

  String category = "";
  String subCategory = "";
  int minPrice = 50;
  int maxPrice = 500;

  getFilteredProducts() async {
    try {
      isLoading(true);
      log("category :: $category");
      log("subCategory :: $subCategory");
      log("minPrice :: $minPrice");
      log("maxPrice :: $maxPrice");
      var data = await GetFilterWiseProductService().applyFilter(
        category: category,
        subCategory: subCategory,
        minPrice: minPrice,
        maxPrice: maxPrice,
      );
      getFilterWiseProduct = data;
      if (getFilterWiseProduct!.status == true) {
        Get.toNamed("/ShowFilteredProduct");
      } else {
        displayToast(message: "No product found!");
      }
    } finally {
      isLoading(false);
      log('Seller product details finally');
    }
  }
}

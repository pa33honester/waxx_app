import 'dart:developer';

import 'package:waxxapp/seller_pages/select_product_for_streame/model/selected_product_model.dart';
import 'package:get/get.dart';

import '../../../ApiModel/seller/LiveSellerForSellingModel.dart';

class LiveSellerForSellingController extends GetxController {
  LiveSellerForSellingModel? liveSellerForSelling;
  RxBool isLoading = false.obs;

  List<SelectedProduct> sellerSelectedProducts = [];

  sellerLiveForSelling({required List<Map<String, dynamic>> selectedProducts}) async {
    try {
      isLoading(true);
      sellerSelectedProducts.clear();
      // var data = await LiveSellerForSellingApi().sellerLiveForSellingApi(selectedProducts: selectedProducts);
      // liveSellerForSelling = data;
      sellerSelectedProducts.addAll(liveSellerForSelling!.liveseller!.selectedProducts!);
    } catch (e) {
      log('Live Seller For Selling Controller :: $e');
    } finally {
      isLoading(false);
      log('finally ${liveSellerForSelling?.message}');
    }
  }
}

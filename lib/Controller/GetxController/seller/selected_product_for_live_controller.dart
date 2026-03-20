import 'dart:developer';
import 'package:waxxapp/ApiModel/seller/SelectedProductForLiveModel.dart';
import 'package:waxxapp/ApiService/seller/selected_product_for_live_service.dart';
import 'package:get/get.dart';

class SelectedProductForLiveController extends GetxController {
  SelectedProductForLiveModel? selectCategory;
  RxBool isLoading = false.obs;

  getSelectedProduct(/*{bool isHost = true, bool? forLive = true}*/) async {
    try {
      isLoading(true);
      var data = await SelectedProductForLiveApi().selectedProduct();
      selectCategory = data;
      // var addProductData = jsonEncode({
      //   "addProduct": selectCategory!.selectedProducts,
      //   "liveSellingHistoryId": selectCategory!.liveSellingHistoryId,
      // });
      // if (forLive == true) {
      //   isHost ? socket!.emit("addProduct", addProductData) : socket!.emit("addProductforUser", addProductData);
      // }
    } finally {
      isLoading(false);
      log('Select Category for live selling finally');
    }
  }
}

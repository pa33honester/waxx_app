import 'dart:developer';

import 'package:waxxapp/ApiModel/user/GetAllCartProductsModel.dart';
import 'package:waxxapp/ApiService/user/get_all_cart_products_service.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:get/get.dart';

class GetAllCartProductController extends GetxController {
  GetAllCartProductsModel? getAllCartProducts;
  List<bool> isLoadingList = [];
  RxInt paymentSelect = 0.obs;
  RxBool firstLoading = false.obs;
  RxBool updateLoading = false.obs;

  var itemLoadingMap = <String, bool>{}.obs;

  void setItemLoading(String id, bool value) {
    itemLoadingMap[id] = value;
    itemLoadingMap.refresh(); // force notify
  }

  bool isItemLoading(String id) {
    return itemLoadingMap[id] ?? false;
  }

  getCartProductData({
    bool? updatedData,
  }) async {
    try {
      updatedData == true ? updateLoading(true) : firstLoading(true);
      var data = await GetAllCartProductApi().getAllCartProductDetails(userId: loginUserId);
      getAllCartProducts = data;
      log("Get All Cart Product Data :: ${getAllCartProducts?.toJson()}");
      update();
    } catch (e) {
      log('Get All Cart Product Error: $e');
    } finally {
      firstLoading(false);
      updateLoading(false);
      log('All Cart Product Details finally');
    }
  }

  // secondTimeTry() async {
  //   try {
  //     updateLoading(true);
  //     var data = await GetAllCartProductApi().getAllCartProductDetails(userId: userId);
  //     getAllCartProducts = data;
  //     update();
  //   } catch (e) {
  //     log('Get All Cart Product Error: $e');
  //   } finally {
  //     updateLoading(false);
  //     log('All Cart Product Details finally');
  //   }
  // }
}

import 'dart:developer';

import 'package:waxxapp/ApiModel/user/RemoveProductToCartModel.dart';
import 'package:waxxapp/ApiService/user/remove_product_to_cart_service.dart';
import 'package:waxxapp/user_pages/bottom_bar_page/controller/bottom_bar_controller.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:get/get.dart';

import '../../../utils/show_toast.dart';

class RemoveProductToCartController extends GetxController {
  RemoveProductToCartModel? removeProductToCartModel;
  RxBool isLoading = false.obs;

  var itemLoadingMap = <String, bool>{}.obs;

  void setItemLoading(String id, bool isLoading) {
    itemLoadingMap[id] = isLoading;
  }

  Future removeProductToCartData({required int productQuantity, required List<dynamic> attributes, String? attributesId}) async {
    try {
      isLoading(true);
      var data = await RemoveProductToCartApi().removeProductToCart(userId: loginUserId, productId: productId, productQuantity: productQuantity, attributes: attributes);
      removeProductToCartModel = data;
      log("Remove product Status :: ${removeProductToCartModel?.status}");
      if (removeProductToCartModel?.status == true) {
        displayToast(message: "Product Removed").then((value) {
          // Get.offAll(BottomBarController());
          final controller = Get.put(BottomBarController());
          controller.onChangeBottomBar(2);
        });
      } else {
        displayToast(message: "Something Wrong Please Try Again");
      }
    } catch (e) {
      log('REMOVE PRODUCT TO CART: $e');
    } finally {
      isLoading(false);
      log('REMOVE PRODUCT TO CART Api Response');
    }
  }
}

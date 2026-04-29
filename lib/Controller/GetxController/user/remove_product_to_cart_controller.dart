import 'dart:developer';

import 'package:waxxapp/ApiModel/user/RemoveProductToCartModel.dart';
import 'package:waxxapp/ApiService/user/remove_product_to_cart_service.dart';
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
        // Just toast — the cart page reloads itself via getCartProductData.
        // The previous code force-jumped the bottom bar to index 2, which
        // was Cart before Live was inserted at index 1 but is now Reels;
        // pressing the minus button kicked users out to Reels.
        displayToast(message: "Product Removed");
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

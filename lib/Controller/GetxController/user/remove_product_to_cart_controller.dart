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
      log("Remove product Status :: ${removeProductToCartModel?.status} Message :: ${removeProductToCartModel?.message}");
      if (removeProductToCartModel?.status == true) {
        // Only toast "Product Removed" when the item actually left
        // the cart — i.e. the backend deleted the cart (data == null)
        // or said so explicitly. A plain quantity reduction (4 → 3)
        // also returns status:true but the item is still there, so
        // toasting "Product Removed" then was misleading. For those
        // the visual quantity change is feedback enough — stay silent.
        final msg = (removeProductToCartModel?.message ?? "").toLowerCase();
        final actuallyRemoved =
            removeProductToCartModel?.data == null || msg.contains("cart deleted");
        if (actuallyRemoved) {
          displayToast(message: "Product Removed");
        }
        // else: quantity reduced; no toast.
      } else {
        // Backend may return status:false with a message that actually
        // means "already removed" — typically when the user's last
        // decrement deleted the cart and a follow-up tap on a stale
        // tile sends another remove. Treat those as benign — the
        // refetch will sync the UI to the real (empty) state. Only
        // surface the alarming "Something Wrong" toast for genuine
        // failures.
        final msg = (removeProductToCartModel?.message ?? "").toLowerCase();
        final benignNotFound = msg.contains("cart does not found") ||
            msg.contains("cart not found") ||
            msg.contains("product with specified attributes not found");
        if (benignNotFound) {
          displayToast(message: "Product Removed");
        } else {
          displayToast(message: "Something Wrong Please Try Again");
        }
      }
    } catch (e) {
      log('REMOVE PRODUCT TO CART: $e');
    } finally {
      isLoading(false);
      log('REMOVE PRODUCT TO CART Api Response');
    }
  }
}

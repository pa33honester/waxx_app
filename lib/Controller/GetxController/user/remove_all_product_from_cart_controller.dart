import 'package:get/get.dart';

import '../../../ApiModel/user/RemoveAllProductFromCartModel.dart';
import '../../../ApiService/user/remove_all_product_from_cart_service.dart';

class RemoveAllProductFromCartController extends GetxController {
  RemoveAllProductFromCartModel? removeAllProduct;
  RxBool isLoading = false.obs;

  Future deleteAllCartProduct() async {
    try {
      isLoading(true);
      var data = await RemoveAllProductFromCartService().removeAllProduct();
      removeAllProduct = data;
    } catch (e) {
      throw Exception("Error from delete all cart product from cart :: $e");
    } finally {
      isLoading(false);
    }
  }
}

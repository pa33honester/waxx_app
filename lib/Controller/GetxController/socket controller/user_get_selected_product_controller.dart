import 'dart:developer';

import 'package:get/get.dart';

import '../../../ApiModel/socket model/user_get_selected_product_model.dart';
import '../../../ApiService/socket service/user_get_selected_product_service.dart';

class UserGetSelectedProductController extends GetxController {
  UserGetSelectedProductModel? userGetSelectedProduct;
  RxBool isLoading = false.obs;

  getSelectedProducts({
    required String roomId,
  }) async {
    try {
      isLoading(true);
      var data = await UserGetSelectedProductService().selectedProducts(roomId: roomId);
      userGetSelectedProduct = data;
    } catch (e) {
      log('Get live selling data for user Controller :: $e');
    } finally {
      isLoading(false);
      log('finally ${userGetSelectedProduct?.message}');
    }
  }
}

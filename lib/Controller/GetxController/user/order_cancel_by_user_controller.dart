import 'dart:developer';
import 'package:get/get.dart';
import '../../../ApiModel/user/OrderCancelByUserModel.dart';
import '../../../ApiService/user/order_cancel_by_user_service.dart';

class OrderCancelByUserController extends GetxController {
  OrderCancelByUserModel? orderCancelByUser;
  RxBool isLoading = false.obs;

  String? orderId;
  // String? status;Order Cancel
  String? itemId;

  orderCancel() async {
    try {
      isLoading(true);
      var data = await OrderCancelByUserService().orderCancelByUser(
        orderId: orderId.toString(),
        // status: status.toString(),
        itemId: itemId.toString(),
      );
      orderCancelByUser = data;
    } catch (e) {
      log('Order Cancel error: $e');
    } finally {
      isLoading(false);
      log('Order Cancel finally');
    }
  }
}

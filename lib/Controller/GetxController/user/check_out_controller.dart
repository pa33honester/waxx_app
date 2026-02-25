import 'dart:developer';

import 'package:get/get.dart';

import '../../../ApiModel/user/CheckOutModel.dart';
import '../../../ApiService/user/check_out_service.dart';
import '../../../utils/globle_veriables.dart';

class CheckOutController extends GetxController {
  CheckOutModel? checkOutModel;
  RxString? promoCode = "".obs;

  checkOutData({required String promoCode}) async {
    try {
      var data = await CheckOutApi.checkOut(userId: loginUserId, promoCode: promoCode);
      checkOutModel = data;
    } catch (e) {
      // Exception handling code
      log('Check Out : $e');
    } finally {
      log('Check Out Api Response');
    }
  }
}

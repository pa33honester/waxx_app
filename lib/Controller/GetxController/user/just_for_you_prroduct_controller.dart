import 'dart:developer';

import 'package:era_shop/utils/app_constant.dart';
import 'package:get/get.dart';

import '../../../ApiModel/user/JustForYouProductModel.dart';
import '../../../ApiService/user/just_for_you_product_service.dart';

class JustForYouProductController extends GetxController {
  JustForYouProductModel? justForYouProduct;
  RxBool isLoading = true.obs;
  List<bool> likes = [];

  Future getJustForYouProduct() async {
    try {
      isLoading(true);
      update([AppConstant.idJustForYou]);
      var data = await JustForYouApi().showProduct();
      justForYouProduct = data;
      likes = List.generate(data!.justForYouProducts!.length, (_) => true);
    } catch (e) {
      log('New Collection Error: $e');
    } finally {
      isLoading(false);
      update([AppConstant.idJustForYou]);
      log('Get Review Details finally');
    }
  }
}

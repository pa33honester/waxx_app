import 'dart:developer';

import 'package:get/get.dart';

import '../../../ApiModel/user/PreviousSearchProductModel.dart';
import '../../../ApiService/user/previous_search_product_service.dart';

class PreviousSearchController extends GetxController {
  PreviousSearchProductModel? previousSearchProduct;
  RxBool isLoading = true.obs;
  @override
  void onInit() {
    log("Enter ONINIT SEARCH");
    // TODO: implement onInit
    super.onInit();
    getPreviousSearchData();
  }

  getPreviousSearchData() async {
    try {
      isLoading(true);
      var data = await PreviousSearchProductApi().previousSearchData();
      previousSearchProduct = data;
    } catch (e) {
      log('Previous Api controller Error: $e');
    } finally {
      isLoading(false);
      log('Get Review Details finally');
    }
  }
}

import 'dart:developer';

import 'package:get/get.dart';

import '../../../ApiModel/user/user_search_product_model.dart';
import '../../../ApiService/user/user_search_product_search.dart';

class UserSearchProductController extends GetxController {
  UserSearchProductModel? userSearchProductModel;
  RxBool isLoading = true.obs;

  userSearchProductDetailsData({String? productName}) async {
    try {
      isLoading(true);
      var data = await UserSearchProductApi().userSearchProductDetails(productName: "$productName");
      userSearchProductModel = data;
      update(['searchResults']);
    } catch (e) {
      log('SEARCH PRODUCT ERROR: $e');
    } finally {
      isLoading(false);
      log('User Product Details finally');
    }
  }

  Future<void> searchContent(String searchTerm) async {
    isLoading(true);
    update(['searchResults']);
    await userSearchProductDetailsData(productName: searchTerm);
    isLoading(true);
    update(['searchResults']);
  }
}

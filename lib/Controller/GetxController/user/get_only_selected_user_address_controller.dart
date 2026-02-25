import 'dart:developer';

import 'package:get/get.dart';

import '../../../ApiModel/user/UserAddressSelectModel.dart';
import '../../../ApiService/user/get_only_selected_user_address_service.dart';

class GetOnlySelectedUserAddressController extends GetxController {
  UserAddressSelectModel? userAddressSelect;
  RxBool isLoading = true.obs;
  var addressDetails;

  getOnlySelectedUserAddressData() async {
    try {
      isLoading(true);
      var data = await GetOnlySelectedUserAddressApi().getOnlySelectedAddress();
      userAddressSelect = data;
       addressDetails = userAddressSelect!.address;
    } catch (e) {
      // Exception handling code
      log('Get Only Selected User Address Error: $e');
    } finally {
      isLoading(false);
      log('Get Only Selected User Address finally :: ${userAddressSelect?.message}');
    }
  }
}

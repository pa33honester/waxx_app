import 'dart:developer';

import 'package:era_shop/ApiModel/user/UserAddressSelectModel.dart';
import 'package:era_shop/ApiService/user/user_address_select_service.dart';
import 'package:get/get.dart';

import '../../../utils/show_toast.dart';

class UserAddressSelectController extends GetxController {
  UserAddressSelectModel? userAddressSelect;
  RxBool isLoading = false.obs;

  Future userSelectAddressData({required String addressId}) async {
    try {
      isLoading(true);
      var data = await UserAddressSelectApi().userSelectAddress(addressId: addressId);
      userAddressSelect = data;
      update();
      if (userAddressSelect!.status == true) {
        addressId = userAddressSelect!.address!.id.toString();
      } else {
        displayToast(message: "Address does not found!!");
      }
    } catch (e) {
      // Exception handling code
      log('User Select Address Error: $e');
    } finally {
      isLoading(false);
      log('User Select Address Finally');
    }
  }
}

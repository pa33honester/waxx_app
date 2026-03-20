import 'dart:developer';

import 'package:waxxapp/ApiModel/user/GetAllUserAddressModel.dart';
import 'package:waxxapp/ApiService/user/get_all_user_address_service.dart';
import 'package:waxxapp/Controller/GetxController/user/user_add_address_controller.dart';
import 'package:get/get.dart';

class GetAllUserAddressController extends GetxController {
  GetAllUserAddressModel? getAllUserAddress;
  UserAddAddressController userAddAddressController = Get.put(UserAddAddressController());
  RxBool isLoading = true.obs;
  var getAddress = "";

  getAllUserAddressData({required bool load}) async {
    try {
      load ? isLoading(true) : null;
      var data = await GetAllUserAddressApi().getAllAddress();
      getAllUserAddress = data;
      if (getAllUserAddress!.status == true) {
        for (int i = 0; i < getAllUserAddress!.address!.length; i++) {
          getAddress = getAllUserAddress!.address![i].address.toString();
        }
        userAddAddressController.addressController.text = getAddress;
      }
      update();
    } catch (e) {
      // Exception handling code
      log('Get All User Address Error: $e');
    } finally {
      isLoading(false);
      log('Get All User Address finally');
    }
  }
}

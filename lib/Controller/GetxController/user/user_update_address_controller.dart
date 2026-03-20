import 'dart:developer';

import 'package:waxxapp/ApiModel/user/UserAddAddressModel.dart';
import 'package:waxxapp/ApiService/user/user_update_address_service.dart';
import 'package:waxxapp/Controller/GetxController/user/user_add_address_controller.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:get/get.dart';

import '../../../utils/show_toast.dart';

class UserUpdateAddressController extends GetxController {
  UserAddAddressController userAddAddressController = Get.put(UserAddAddressController());
  UserAddAddressModel? userAddAddress;

  Future userUpdateAddressData({
    required String userId,
    required String name,
    required String country,
    required String state,
    required String city,
    required String zipCode,
    required String address,
  }) async {
    try {
      var data = await UserUpdateAddressApi().userUpdateAddress(userId: userId, name: name, country: country, state: state, city: city, zipCode: zipCode, address: address);
      userAddAddress = data;
      if (userAddAddress!.status == true) {
        addressId = userAddAddress!.address!.id.toString();
      }
    } catch (e) {
      // Exception handling code
      log('User Update Address Error: $e');
    } finally {
      log('User Update Address Finally');
    }
  }

  userUpdateAddress({required String country, required String state, required String city}) async {
    if (userAddAddressController.nameController.text.isEmpty ||
        userAddAddressController.myCountryController.text.isEmpty ||
        userAddAddressController.myStateController.text.isEmpty ||
        userAddAddressController.myCityController.text.isEmpty ||
        userAddAddressController.zipCodeController.text.isEmpty ||
        userAddAddressController.addressController.text.isEmpty) {
      displayToast(message: "All fields are required \nto be filled");
    } else {
      /// **************** API CALLING *****************\\\
      displayToast(message: St.pleaseWaitToast.tr);
      await userUpdateAddressData(
          userId: loginUserId, name: userAddAddressController.nameController.text, country: country, state: state, city: city, zipCode: userAddAddressController.zipCodeController.text, address: userAddAddressController.addressController.text);
      if (userAddAddress?.status == true) {
        Get.back();
        displayToast(message: "Address update successfully");
      } else {
        displayToast(message: St.somethingWentWrong.tr);
      }
    }
  }
}

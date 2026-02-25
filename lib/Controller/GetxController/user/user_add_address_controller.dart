import 'dart:developer';

import 'package:era_shop/ApiModel/user/UserAddAddressModel.dart';
import 'package:era_shop/ApiService/user/user_add_address_service.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/Theme/theme_service.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/show_toast.dart';

class UserAddAddressController extends GetxController {
  UserAddAddressModel? userAddAddress;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController myCountryController = TextEditingController();
  final TextEditingController myStateController = TextEditingController();
  final TextEditingController myCityController = TextEditingController();
  String? selectedCountry;
  String? selectedState;

  Future userAddAddressData({
    required String userId,
    required String name,
    required String country,
    required String state,
    required String city,
    required String zipCode,
    required String address,
  }) async {
    try {
      var data = await UserAddAddressApi().userAddAddress(userId: userId, name: name, country: country, state: state, city: city, zipCode: zipCode, address: address);
      userAddAddress = data;
      if (userAddAddress!.status == true) {
        addressId = userAddAddress!.address!.id.toString();
      }
    } catch (e) {
      // Exception handling code
      log('User Add Address Error: $e');
    } finally {
      log('User Add Address Finally');
    }
  }

  useraddAddress({required String country, required String state, required String city}) async {
    log("${nameController.text.isEmpty}");
    log("$selectedCountry");
    log("$selectedState");
    log("${cityController.text.isEmpty}");
    log("${zipCodeController.text.isEmpty}");
    log("${addressController.text.isEmpty}");

    /// **************** API CALLING *****************\\\

    displayToast(message: St.pleaseWaitToast.tr);
    await userAddAddressData(userId: loginUserId, name: nameController.text, country: country, state: state, city: city, zipCode: zipCodeController.text.trim(), address: addressController.text.trim());
    if (userAddAddress!.status == true) {
      Get.back();
      displayToast(message: "Address Add successfully");
    } else {
      displayToast(message: St.somethingWentWrong.tr);
    }
  }
}

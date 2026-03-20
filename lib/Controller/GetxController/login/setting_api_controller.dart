import 'dart:developer';
import 'package:waxxapp/utils/Theme/theme_service.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:get/get.dart';

import '../../../ApiModel/login/SettingApiModel.dart';
import '../../../ApiService/login/setting_api_service.dart';

class SettingApiController extends GetxController {
  SettingApiModel? setting;
  RxBool isLoading = true.obs;

  getSettingApi() async {
    try {
      setting = await SettingApi().settingApi();
      isUpdateProductRequest = setting?.setting!.isAddProductRequest;
      cancelOrderCharges = setting?.setting!.cancelOrderCharges;
      currencySymbol = getStorage.read("isDemoLogin") ?? false || isDemoSeller ? "\$" : setting?.setting!.currency?.symbol ?? '';
      currencyCode = setting?.setting!.currency?.currencyCode ?? '';
      // stripPublishableKey = data.setting?.stripePublishableKey ?? "";
      // stripSecrateKey = data.setting?.stripeSecretKey ?? "";
      print("CURRENCY :: ${currencyCode} SYMBOAL :: ${currencySymbol}");
      // print("CURRENCY :: ${stripPublishableKey} SYMBOAL :: ${stripSecrateKey}");
    } finally {
      isLoading(false);
      log('Setting api call done');
    }
  }
}

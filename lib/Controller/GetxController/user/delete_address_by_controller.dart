import 'dart:developer';
import 'package:get/get.dart';
import '../../../ApiModel/user/DeleteAddressByUserModel.dart';
import '../../../ApiService/user/delete_address_by_user_service.dart';

class DeleteAddressByUserController extends GetxController {
  DeleteAddressByUserModel? deleteAddressByUser;
  RxBool isLoading = false.obs;

  deleteAddress({
    required String addressId,
  }) async {
    try {
      isLoading(true);
      var data = await DeleteAddressByUserService().deleteAddress(addressId: addressId);
      deleteAddressByUser = data;
    } finally {
      isLoading(false);
      log('FAQ finally');
    }
  }
}

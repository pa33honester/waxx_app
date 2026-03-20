import 'package:waxxapp/ApiModel/user/ProfileEditModel.dart';
import 'package:waxxapp/ApiService/login/profile_edit_service.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:get/get.dart';

class ApiProfileEditController extends GetxController {
  ProfileEditModel? profileEditModel;
  var isLoading = true.obs;

  profileEditData({
    required String userId,
    required String firstName,
    required String lastName,
    required String email,
    required String dob,
    required String gender,
    required String location,
    String? mobileNumber,
    String? countryCode,
  }) async {
    try {
      isLoading(true);
      update();
      var data = await ProfileEditApi().updateUser(
        userId: userId,
        firstName: firstName,
        lastName: lastName,
        email: email,
        dob: dob,
        gender: gender,
        location: location,
        mobileNumber: mobileNumber,
        countryCode: countryCode,
      );
      profileEditModel = data;
      if (profileEditModel!.status == true) {
        isLoading(false);
        editImage = profileEditModel!.user!.image.toString();
        update();
      }
    } finally {
      isLoading(false);
    }
  }
}

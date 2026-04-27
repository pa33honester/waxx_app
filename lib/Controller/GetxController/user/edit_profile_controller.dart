import 'dart:developer';

import 'package:waxxapp/Controller/ApiControllers/user/api_profile_edit_controller.dart';
import 'package:waxxapp/utils/Theme/theme_service.dart';
import 'package:waxxapp/utils/database.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/show_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  RxBool isLoading = false.obs;

  ApiProfileEditController profileEditController = Get.put(ApiProfileEditController());

//--------------------------------------------------
  final TextEditingController firstNameController = TextEditingController(text: editFirstName);
  final TextEditingController lastNameController = TextEditingController(text: editLastName);
  final TextEditingController eMailController = TextEditingController(text: editEmail);
  final TextEditingController eNumberController = TextEditingController(text: Database.fetchLoginUserProfileModel?.user?.mobileNumber);
  final TextEditingController dateOfBirth = TextEditingController(text: editDateOfBirth);
  final TextEditingController locationController = TextEditingController(text: editLocation);
  //------------------------------------------------
  final TextEditingController mobileNumberController = TextEditingController();

  editDataStorage() async {
    try {
      isLoading(true);
      // Email and mobile number are NOT saved here — they go through the
      // dedicated Change Email / Change Phone flows that round-trip via OTP.
      // Sending empty strings keeps the backend's existing-value fallback
      // (`user.email = body.email.trim() ? trim : user.email`) so we don't
      // accidentally overwrite a freshly-changed email with a stale text
      // controller value.
      await profileEditController.profileEditData(
        userId: loginUserId,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: "",
        dob: editDateOfBirth,
        gender: genderSelect,
        location: locationController.text,
        mobileNumber: "",
        countryCode: dialCode,
        fcmToken: fcmToken,
      );
      displayToast(message: "Save changes successfully!");
      getStorage.write("imageXFile", imageXFile.toString());
      getStorage.write("editImage", editImage);
      getStorage.write("editFirstName", firstNameController.text);
      getStorage.write("editLastName", lastNameController.text);
      getStorage.write("dob", dateOfBirth.text);
      getStorage.write("genderSelect", genderSelect);
      getStorage.write("location", locationController.text);
      getStorage.write("dialCode", dialCode);

      editImage = getStorage.read("imageXFile");
      editImage = getStorage.read("editImage");
      editFirstName = getStorage.read("editFirstName");
      editLastName = getStorage.read("editLastName");
      editEmail = getStorage.read("editEmail");
      editDateOfBirth = getStorage.read("dob");
      genderSelect = getStorage.read("genderSelect");
      editLocation = getStorage.read("location");
      mobileNumber = getStorage.read("mobileNumber");
      dialCode = getStorage.read("dialCode");
    } catch (e) {
      log("Edit profile error :: $e");
    } finally {
      isLoading(false);
    }
  }
}

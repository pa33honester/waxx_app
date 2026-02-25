import 'package:get/get.dart';

import '../../../ApiModel/login/check_password_model.dart';
import '../../../ApiService/login/check_password_service.dart';

class CheckPasswordController extends GetxController {
  CheckPasswordModel? checkPassword;

  validationPassword({
    required String email,
    required String password,
  }) async {
    try {
      var data = await CheckPasswordService().checkPassword(
        email: email,
        password: password,
      );
      checkPassword = data;
    } finally {}
  }
}

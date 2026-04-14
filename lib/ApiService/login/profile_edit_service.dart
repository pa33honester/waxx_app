import 'dart:convert';
import 'dart:developer';
import 'package:waxxapp/ApiModel/user/ProfileEditModel.dart';
import 'package:waxxapp/utils/api_url.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class ProfileEditApi extends GetxService {
  Future<ProfileEditModel?> updateUser({
    required String userId,
    required String firstName,
    required String lastName,
    required String email,
    required String dob,
    required String gender,
    required String location,
    String? mobileNumber,
    String? countryCode,
    String? fcmToken,
  }) async {
    try {
      log("userId = $userId");
      log("firstName = $firstName");
      log("lastName = $lastName");
      log("email = $email");
      log("dob = $dob");
      log("gender = $gender");
      log("location = $location");
      log("mobileNumber = $mobileNumber");
      log("countryCode = $countryCode");
      log("fcmToken = $fcmToken");

      final uri = Uri.parse(
        Api.baseUrl + Api.editProfile,
      );

      var request = http.MultipartRequest("PATCH", uri);

      if (imageXFile == null) {
        log("IMAGE NULL");
      } else {
        var addImage = await http.MultipartFile.fromPath('image', imageXFile!.path);
        request.files.add(addImage);
        log("IMAGE ==========================================${imageXFile!.path}");
      }

      request.headers.addAll({
        "key": Api.secretKey,
        "Content-Type": "application/json; charset=UTF-8",
      });

      Map<String, String> requestBody = <String, String>{
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "dob": dob,
        "gender": gender,
        "location": location,
        "mobileNumber": mobileNumber.toString(),
        "countryCode": countryCode.toString(),
      };

      if (fcmToken != null && fcmToken.isNotEmpty) {
        requestBody["fcmToken"] = fcmToken;
      }

      request.fields.addAll(requestBody);
      var res1 = await request.send();
      var response = await http.Response.fromStream(res1);
      log("Status code :: ${response.statusCode} \nEdit Profile Body :: ${response.body} ");
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return ProfileEditModel.fromJson(data);
      }
    } catch (e) {
      log("%Edit profile response isn't 200");
      throw Exception(e);
    }
    return null;
  }
}

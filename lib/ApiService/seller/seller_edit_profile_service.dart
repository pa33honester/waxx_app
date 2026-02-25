import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:era_shop/ApiModel/seller/SellerEditProfileModel.dart';
import 'package:era_shop/utils/api_url.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:get/get.dart';

class SellerProfileEditApi extends GetxService {
  Future<SellerEditProfileModel?> sellerProfileEdit({
    required String businessName,
    required String businessTag,
    required String address,
    required String landMark,
    required String city,
    required String pinCode,
    required String state,
    required String country,
    required String bankName,
    required String accountNumber,
    required String IFSCCode,
    required String branchName,
  }) async {
    // String uri = Api.getDomainFromURL(Api.baseUrl);
    try {
      log("businessName = $businessName");
      log("businessTag = $businessTag");
      log("address = $address");
      log("landMark = $landMark");
      log("city = $city");
      log("pinCode = $pinCode");
      log("state = $state");
      log("country = $country");
      log("bankName = $bankName");
      log("accountNumber = $accountNumber");
      log("IFSCCode = $IFSCCode");
      log("branchName = $branchName");
      // final params = {
      //   "sellerId": sellerId,
      // };

      final url =
          Uri.parse("${Api.baseUrl + Api.sellerUpdate}?sellerId=$sellerId");
      // final url = Uri.https(uri, Api.sellerUpdate, params);
      log("sellerurl:$url");

      var request = http.MultipartRequest("PATCH", url);

      if (sellerImageXFile == null) {
        log("sellerImageXFile NULL");
      } else {
        var addImage =
            await http.MultipartFile.fromPath('image', sellerImageXFile!.path);
        request.files.add(addImage);
        log("IMAGE ==========================================${sellerImageXFile!.path}=======");
      }
      request.headers.addAll({
        'key': Api.secretKey,
        'Content-Type': 'application/json; charset=UTF-8',
      });

      Map<String, String> requestBody = <String, String>{
        "businessName": businessName,
        "businessTag": businessTag,
        "address": address,
        "landMark": landMark,
        "city": city,
        "pinCode": pinCode,
        "state": state,
        "country": country,
        "bankName": bankName,
        "accountNumber": accountNumber,
        "IFSCCode": IFSCCode,
        "branchName": branchName,
      };

      log("<<<<<<<< request$requestBody");
      request.fields.addAll(requestBody);

      var res1 = await request.send();
      var response = await http.Response.fromStream(res1);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return SellerEditProfileModel.fromJson(data);
      } else {
        log("STATUS CODE:-${response.statusCode.toString()}");
        log(response.reasonPhrase.toString());
      }
    } finally {
      log("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Response Complete");
    }
    return null;
  }
}

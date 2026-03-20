import 'dart:convert';
import 'dart:developer';
import 'package:waxxapp/utils/api_url.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../ApiModel/seller/ChangePasswordBySellerModel.dart';

class SellerUpdatePasswordService extends GetxService {
  Future<ChangePasswordBySellerModel> updatePasswordApi({
    required String oldPass,
    required String newPass,
    required String confirmPass,
  }) async {
    // String uri = Api.getDomainFromURL(Api.baseUrl);
    // var params = {"sellerId": sellerId};

    // final url = Uri.https(uri, Api.updatePasswordBySeller, params);
    final url = Uri.parse(
        "${Api.baseUrl + Api.updatePasswordBySeller}?sellerId=$sellerId");

    final headers = {
      'key': Api.secretKey,
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final body = json.encode({
      "oldPass": oldPass,
      "newPass": newPass,
      "confirmPass": confirmPass,
    });
    final response = await http.patch(url, headers: headers, body: body);

    log('Update Password URL :: $url \n API STATUS CODE :: ${response.statusCode} \n RESPONSE :: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return ChangePasswordBySellerModel.fromJson(jsonResponse);
    } else {
      throw Exception('Seller Update password failed');
    }
  }
}

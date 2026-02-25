import 'dart:convert';
import 'dart:developer';
import 'package:era_shop/utils/api_url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../ApiModel/user/userApplyPromoCheck.dart';
import '../../utils/globle_veriables.dart';

class UserApplyPromoCheckApi extends GetxService {
  Future<UserApplyPromoCheckModel> userApplyPromoCheck({
    required String promocodeId,
  }) async {
    // String uri = Api.getDomainFromURL(Api.baseUrl);
    // final params = {
    //   "promocodeId": promocodeId,
    //   "userId": userId,
    // };

    log("Promo id :: $promocodeId");
    log("UUUser id :: $loginUserId");
    // final url = Uri.https(uri, Api.userApplyPromoCheck, params);
    final url = Uri.parse("${Api.baseUrl + Api.userApplyPromoCheck}?promocodeId=$promocodeId&userId=$loginUserId");

    final headers = {
      'key': Api.secretKey,
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final response = await http.post(url, headers: headers);

    log('User Apply Promo Check API STATUS CODE ::url  $url :::::: RESPONSE :: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return UserApplyPromoCheckModel.fromJson(jsonResponse);
    } else {
      throw Exception('user Apply Promo Api call failed');
    }
  }
}

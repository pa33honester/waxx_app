import 'dart:convert';
import 'dart:developer';
import 'package:era_shop/utils/api_url.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../../ApiModel/socket model/user_get_selected_product_model.dart';

class UserGetSelectedProductService extends GetxService {
  Future<UserGetSelectedProductModel> selectedProducts({
    required String roomId,
  }) async {
    // String uri = Api.getDomainFromURL(Api.baseUrl);
    // final params = {"liveSellingHistoryId": roomId};

    final url = Uri.parse(
        "${Api.baseUrl + Api.getSelectedProductForUser}?liveSellingHistoryId=$roomId");
    // final url = Uri.https(uri, Api.getSelectedProductForUser, params);

    final headers = {
      'key': Api.secretKey,
      "Content-Type": "application/json; charset=UTF-8",
    };

    final response = await http.get(url, headers: headers);

    log("Get live selling data Api :: Status code :: ${response.statusCode} \n Response Body :: ${response.body}");

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return UserGetSelectedProductModel.fromJson(jsonResponse);
    } else {
      throw Exception('Get live selling data Api Failed');
    }
  }
}

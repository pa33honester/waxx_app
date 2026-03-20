import 'dart:convert';
import 'dart:developer';
import 'package:waxxapp/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:waxxapp/utils/api_url.dart';
import 'package:get/get.dart';
import '../../ApiModel/seller/LiveSellerForSellingModel.dart';
import '../../utils/globle_veriables.dart';

/*class LiveSellerForSellingApi extends GetxService {
  Future<LiveSellerForSellingModel> sellerLiveForSellingApi({required List<Map<String, dynamic>> selectedProducts}) async {
    final url = Uri.parse(Api.baseUrl + Api.liveSeller);

    final headers = {
      'key': Api.secretKey,
      "Content-Type": "application/json; charset=UTF-8",
    };

    final body = jsonEncode({
      'sellerId': sellerId,
      'selectedProducts': selectedProducts,
    });

    print('Final payload: ${jsonEncode({
          'sellerId': sellerId,
          'selectedProducts': selectedProducts,
        })}');
    final response = await http.post(url, body: body, headers: headers);

    log("Live Seller For Selling Api :: Status code :: ${response.statusCode} \n Response Body :: ${response.body}");

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return LiveSellerForSellingModel.fromJson(jsonResponse);
    } else {
      throw Exception('Live Seller For Selling Api Failed');
    }
  }
}*/

class CreateLiveSellerWithProductApi {
  static Future<LiveSellerForSellingModel?> callApi({
    required String sellerId,
    required List<Map<String, dynamic>> selectedProducts,
    required int liveType,
  }) async {
    Utils.showLog("Create Live Seller Api Calling...");

    final uri = Uri.parse(Api.baseUrl + Api.liveSeller);

    final headers = {
      "key": Api.secretKey,
      "Content-Type": "application/json",
    };

    final body = jsonEncode({"selectedProducts": selectedProducts, "sellerId": sellerId, "liveType": liveType});

    log("Create Live Seller Api URL => $uri");
    log("Create Live Seller Api Body => $body");

    try {
      final response = await http.post(uri, headers: headers, body: body);

      if (response.statusCode == 200) {
        Utils.showLog("Create Live Seller Api Response => ${response.body}");

        final jsonResponse = json.decode(response.body);
        return LiveSellerForSellingModel.fromJson(jsonResponse);
      } else {
        Utils.showLog("Create Live Seller Api Error ${response.statusCode}: ${response.body}");
      }
    } catch (error) {
      Utils.showLog("Create Live Seller Api Exception => $error");
    }

    return null;
  }
}

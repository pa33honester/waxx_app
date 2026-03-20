import 'dart:convert';
import 'dart:developer';

import 'package:waxxapp/ApiModel/user/place_bid_model.dart';
import 'package:waxxapp/utils/api_url.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:http/http.dart' as http;

class AuctionBidService {
  Future<PlaceBidModel> placeBid({
    required String userId,
    required String productId,
    required String bidAmount,
    required List<dynamic> attributes,
  }) async {
    final url = Uri.parse("${Api.baseUrl + Api.placeManualBid}");

    final body = jsonEncode({
      'userId': userId,
      'productId': productId,
      'bidAmount': bidAmount,
      'attributes': attributes,
    });

    log("PlaceBid URL :: $url");
    log("PlaceBid body :: $body");

    final headers = {
      'key': Api.secretKey,
      'Content-Type': 'application/json; charset=UTF-8',
    };

    try {
      final response = await http.post(url, headers: headers, body: body);

      log('PlaceBid API STATUS CODE :: ${response.statusCode} \n RESPONSE :: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return PlaceBidModel.fromJson(jsonResponse);
      } else {
        log('PlaceBid API Error :: ${response.statusCode} :: ${response.body}');
        throw Exception('Failed to place bid: ${response.statusCode}');
      }
    } catch (e) {
      log('PlaceBid API Exception :: $e');
      throw Exception('Network error: $e');
    }
  }
}

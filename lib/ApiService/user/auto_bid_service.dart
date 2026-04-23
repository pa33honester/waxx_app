import 'dart:convert';
import 'dart:developer';

import 'package:waxxapp/ApiModel/user/auto_bid_model.dart';
import 'package:waxxapp/utils/api_url.dart';
import 'package:http/http.dart' as http;

class AutoBidService {
  final _headers = {
    'key': Api.secretKey,
    'Content-Type': 'application/json; charset=UTF-8',
  };

  Future<AutoBidModel> setAutoBid({
    required String userId,
    required String productId,
    required String maxBidAmount,
    required List<dynamic> attributes,
  }) async {
    final url = Uri.parse(Api.baseUrl + Api.setAutoBid);
    final body = jsonEncode({
      'userId': userId,
      'productId': productId,
      'maxBidAmount': maxBidAmount,
      'attributes': attributes,
    });
    log('SetAutoBid URL :: $url\nBody :: $body');
    try {
      final response = await http.post(url, headers: _headers, body: body);
      log('SetAutoBid STATUS :: ${response.statusCode} BODY :: ${response.body}');
      if (response.statusCode == 200) {
        return AutoBidModel.fromJson(json.decode(response.body));
      }
      throw Exception('SetAutoBid failed: ${response.statusCode}');
    } catch (e) {
      log('SetAutoBid error: $e');
      throw Exception('Network error: $e');
    }
  }

  Future<AutoBidModel> getAutoBid({
    required String userId,
    required String productId,
  }) async {
    final url = Uri.parse('${Api.baseUrl}${Api.getAutoBid}?userId=$userId&productId=$productId');
    log('GetAutoBid URL :: $url');
    try {
      final response = await http.get(url, headers: _headers);
      log('GetAutoBid STATUS :: ${response.statusCode}');
      if (response.statusCode == 200) {
        return AutoBidModel.fromJson(json.decode(response.body));
      }
      throw Exception('GetAutoBid failed: ${response.statusCode}');
    } catch (e) {
      log('GetAutoBid error: $e');
      throw Exception('Network error: $e');
    }
  }

  Future<AutoBidModel> cancelAutoBid({
    required String userId,
    required String productId,
  }) async {
    final url = Uri.parse(Api.baseUrl + Api.cancelAutoBid);
    final body = jsonEncode({'userId': userId, 'productId': productId});
    log('CancelAutoBid URL :: $url');
    try {
      final response = await http.post(url, headers: _headers, body: body);
      log('CancelAutoBid STATUS :: ${response.statusCode}');
      if (response.statusCode == 200) {
        return AutoBidModel.fromJson(json.decode(response.body));
      }
      throw Exception('CancelAutoBid failed: ${response.statusCode}');
    } catch (e) {
      log('CancelAutoBid error: $e');
      throw Exception('Network error: $e');
    }
  }
}

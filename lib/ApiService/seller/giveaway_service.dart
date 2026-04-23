import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:waxxapp/ApiModel/giveaway/giveaway_model.dart';
import 'package:waxxapp/utils/api_url.dart';

class SellerGiveawayService {
  static final _headers = {
    'key': Api.secretKey,
    'Content-Type': 'application/json; charset=UTF-8',
  };

  /// Seller starts a giveaway during a live broadcast.
  Future<GiveawayModel?> startGiveaway({
    required String sellerId,
    required String liveSellingHistoryId,
    required String productId,
    required int type, // 1 = standard, 2 = followerOnly
    required int entryWindowSeconds,
  }) async {
    final url = Uri.parse(Api.baseUrl + Api.startGiveaway);
    final body = jsonEncode({
      'sellerId': sellerId,
      'liveSellingHistoryId': liveSellingHistoryId,
      'productId': productId,
      'type': type,
      'entryWindowSeconds': entryWindowSeconds,
    });

    try {
      final res = await http.post(url, headers: _headers, body: body);
      log('startGiveaway ${res.statusCode}: ${res.body}');
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      if (json['status'] == true && json['giveaway'] != null) {
        return GiveawayModel.fromApi(Map<String, dynamic>.from(json['giveaway'] as Map));
      }
      return null;
    } catch (e) {
      log('startGiveaway exception: $e');
      return null;
    }
  }

  /// Seller forces an early draw.
  Future<bool> drawGiveaway({required String giveawayId}) async {
    final url = Uri.parse(Api.baseUrl + Api.drawGiveaway);
    final body = jsonEncode({'giveawayId': giveawayId});
    try {
      final res = await http.post(url, headers: _headers, body: body);
      log('drawGiveaway ${res.statusCode}: ${res.body}');
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      return json['status'] == true;
    } catch (e) {
      log('drawGiveaway exception: $e');
      return false;
    }
  }

  /// Past giveaways this seller has run.
  Future<List<GiveawayModel>> fetchHistory({required String sellerId, int page = 1}) async {
    final url = Uri.parse('${Api.baseUrl}${Api.sellerGiveawayHistory}?sellerId=$sellerId&page=$page');
    try {
      final res = await http.get(url, headers: _headers);
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      if (json['status'] == true && json['giveaways'] is List) {
        return (json['giveaways'] as List)
            .whereType<Map>()
            .map((e) => GiveawayModel.fromApi(Map<String, dynamic>.from(e)))
            .toList();
      }
    } catch (e) {
      log('sellerHistory exception: $e');
    }
    return [];
  }
}

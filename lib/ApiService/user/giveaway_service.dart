import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:waxxapp/ApiModel/giveaway/giveaway_model.dart';
import 'package:waxxapp/utils/api_url.dart';

class GiveawayEnterResult {
  final bool ok;
  final int entryCount;
  final String message;
  final String? code; // e.g. FOLLOW_REQUIRED
  final bool alreadyEntered;

  GiveawayEnterResult({
    required this.ok,
    required this.entryCount,
    required this.message,
    this.code,
    this.alreadyEntered = false,
  });
}

class UserGiveawayService {
  static final _headers = {
    'key': Api.secretKey,
    'Content-Type': 'application/json; charset=UTF-8',
  };

  /// Enter an open giveaway. Returns a typed result so the UI can show
  /// a "Follow to enter" CTA for follower-only giveaways.
  Future<GiveawayEnterResult> enter({required String userId, required String giveawayId}) async {
    final url = Uri.parse(Api.baseUrl + Api.enterGiveaway);
    final body = jsonEncode({'userId': userId, 'giveawayId': giveawayId});
    try {
      final res = await http.post(url, headers: _headers, body: body);
      log('enterGiveaway ${res.statusCode}: ${res.body}');
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      return GiveawayEnterResult(
        ok: json['status'] == true,
        entryCount: (json['entryCount'] as num?)?.toInt() ?? 0,
        message: json['message']?.toString() ?? '',
        code: json['code']?.toString(),
        alreadyEntered: json['alreadyEntered'] == true,
      );
    } catch (e) {
      log('enterGiveaway exception: $e');
      return GiveawayEnterResult(ok: false, entryCount: 0, message: 'Network error');
    }
  }

  /// Buyer's won giveaways.
  Future<List<GiveawayModel>> fetchMyWins({required String userId}) async {
    final url = Uri.parse('${Api.baseUrl}${Api.myGiveawayWins}?userId=$userId');
    try {
      final res = await http.get(url, headers: _headers);
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      if (json['status'] == true && json['wins'] is List) {
        return (json['wins'] as List)
            .whereType<Map>()
            .map((e) => GiveawayModel.fromApi(Map<String, dynamic>.from(e)))
            .toList();
      }
    } catch (e) {
      log('myWins exception: $e');
    }
    return [];
  }

  /// Giveaways attached to a broadcast (buyer prefetches on join).
  Future<List<GiveawayModel>> fetchByLive({required String liveSellingHistoryId}) async {
    final url = Uri.parse('${Api.baseUrl}${Api.giveawaysByLive}?liveSellingHistoryId=$liveSellingHistoryId');
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
      log('giveawaysByLive exception: $e');
    }
    return [];
  }
}

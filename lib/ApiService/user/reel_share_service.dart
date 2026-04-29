import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:waxxapp/utils/api_url.dart';

class ReelShareService {
  static Future<int?> incrementShare({required String reelId}) async {
    if (reelId.isEmpty) return null;
    final uri = Uri.parse("${Api.baseUrl}${Api.incrementReelShare}/$reelId");
    try {
      final res = await http.post(
        uri,
        headers: {
          "key": Api.secretKey,
          "Content-Type": "application/json",
        },
      );
      if (res.statusCode != 200) return null;
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      if (body["status"] != true) return null;
      final share = body["share"];
      return share is int ? share : (share is num ? share.toInt() : null);
    } catch (e) {
      log("ReelShareService.incrementShare error: $e");
      return null;
    }
  }
}

import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:waxxapp/utils/api_url.dart';
import 'package:waxxapp/utils/globle_veriables.dart';

/// Fire-and-forget bump of a reel's view counter. Called when a reel
/// becomes the visible page in the swipe feed. The backend dedupes by
/// (userId, reelId) via a compound unique index on ViewHistoryOfReel, so
/// a given user only ever increments a reel's `view` count once — repeat
/// taps return `counted: false` and no-op. Errors are swallowed; view
/// counting must not block the playback path.
class ReelViewService {
  /// Returns `true` if this call actually bumped the count (first view by
  /// this user for this reel) so callers can apply an optimistic local +1
  /// in lockstep with the backend. Returns `false` for duplicate views or
  /// any error.
  static Future<bool> incrementView({required String reelId}) async {
    if (reelId.isEmpty || loginUserId.isEmpty) return false;
    final uri = Uri.parse("${Api.baseUrl}${Api.incrementReelView}/$reelId");
    try {
      final res = await http.post(
        uri,
        headers: {
          "key": Api.secretKey,
          "Content-Type": "application/json",
        },
        body: jsonEncode({"userId": loginUserId}),
      );
      if (res.statusCode != 200) return false;
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      return body["counted"] == true;
    } catch (e) {
      log("ReelViewService.incrementView error: $e");
      return false;
    }
  }
}

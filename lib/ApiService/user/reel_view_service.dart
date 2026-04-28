import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:waxxapp/utils/api_url.dart';

/// Fire-and-forget bump of a reel's view counter. Called when a reel
/// becomes the visible page in the swipe feed. Errors are swallowed —
/// view counting is best-effort and must not block the playback path.
class ReelViewService {
  static Future<void> incrementView({required String reelId}) async {
    if (reelId.isEmpty) return;
    final uri = Uri.parse("${Api.baseUrl}${Api.incrementReelView}/$reelId");
    try {
      await http.post(uri, headers: {"key": Api.secretKey});
    } catch (e) {
      log("ReelViewService.incrementView error: $e");
    }
  }
}

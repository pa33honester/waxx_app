import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:waxxapp/ApiModel/user/GetLiveSellerListModel.dart';
import 'package:waxxapp/utils/api_url.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/socket_services.dart';

/// Looks up a single live show by its `liveSellingHistoryId`. Used by the
/// `/live/{id}` deep-link target so a tap on a shared link can jump straight
/// into the broadcast room instead of dumping the user on the Live tab.
///
/// Result is a 3-state record so the caller can branch cleanly:
///   ok=true            → `live` is non-null, push the live page.
///   ok=false + ended=true → the live no longer exists (broadcaster gone).
///   ok=false + ended=false → network or parse error.
class FetchLiveByHistoryIdService {
  static final _headers = {
    "key": Api.secretKey,
    "Content-Type": "application/json; charset=UTF-8",
  };

  static Future<({bool ok, LiveSeller? live, bool ended, String message})> fetch({
    required String liveSellingHistoryId,
  }) async {
    // Include the viewer's userId so the backend can project a per-viewer
    // `isFollow` against the followers collection — without it, the
    // FollowPill on the deep-linked live page always defaults to "Follow".
    final qs = loginUserId.isNotEmpty ? "?userId=$loginUserId" : "";
    final uri = Uri.parse("${Api.baseUrl}${Api.liveByHistoryId}/$liveSellingHistoryId$qs");
    log("FetchLiveByHistoryId → $uri");
    try {
      final res = await http.get(uri, headers: _headers);
      log("FetchLiveByHistoryId ← ${res.statusCode} ${res.body}");
      if (res.statusCode != 200) {
        return (ok: false, live: null, ended: false, message: "Couldn't open this live.");
      }
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      if (json["status"] == true && json["data"] is Map<String, dynamic>) {
        final dataMap = json["data"] as Map<String, dynamic>;
        // Seed the room-wide like + share totals before the socket subscribes,
        // so a late joiner sees the running counts straight away instead of
        // "0" until someone next taps.
        final lc = dataMap["likeCount"];
        if (lc is num) SocketServices.liveLikeCount.value = lc.toInt();
        final sc = dataMap["shareCount"];
        if (sc is num) SocketServices.liveShareCount.value = sc.toInt();
        final live = LiveSeller.fromJson(dataMap);
        return (ok: true, live: live, ended: false, message: "");
      }
      // status:false with our standard "ended" message means the LiveSeller
      // row is gone — the show has wrapped.
      return (ok: false, live: null, ended: true, message: (json["message"] ?? "This live show has ended.").toString());
    } catch (e) {
      log("FetchLiveByHistoryId error: $e");
      return (ok: false, live: null, ended: false, message: "Couldn't open this live.");
    }
  }
}

import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:waxxapp/utils/api_url.dart';

/// Remove a product from the seller's currently-broadcasting live show.
/// Used by the host-side delete affordance on each row of the
/// Available Products sheet.
class RemoveProductFromLiveService {
  static final _headers = {
    "key": Api.secretKey,
    "Content-Type": "application/json; charset=UTF-8",
  };

  /// Returns `(ok, message)`. On success the backend has filtered the
  /// product out of LiveSeller.selectedProducts and emitted
  /// `selectedProductsUpdated` to every socket in the room — the host's
  /// own LiveController picks that up so no extra refresh logic is
  /// needed at the call site.
  static Future<({bool ok, String message})> remove({
    required String sellerId,
    required String productId,
  }) async {
    final uri = Uri.parse(Api.baseUrl + Api.removeProductFromLive);
    final body = jsonEncode({"sellerId": sellerId, "productId": productId});
    log("RemoveProductFromLive → $uri body=$body");
    try {
      final res = await http.post(uri, headers: _headers, body: body);
      log("RemoveProductFromLive ← ${res.statusCode} ${res.body}");
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      return (
        ok: json["status"] == true,
        message: (json["message"] ?? "").toString(),
      );
    } catch (e) {
      log("RemoveProductFromLive error: $e");
      return (ok: false, message: "Network error. Please try again.");
    }
  }
}

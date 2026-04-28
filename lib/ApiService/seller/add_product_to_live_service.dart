import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:waxxapp/utils/api_url.dart';

/// Append a product to the seller's currently-broadcasting live show.
/// Used by the host-side "+ Add product" button on the live page.
class AddProductToLiveService {
  static final _headers = {
    "key": Api.secretKey,
    "Content-Type": "application/json; charset=UTF-8",
  };

  /// Returns `(ok, message)`. On success the backend has appended the
  /// product to LiveSeller.selectedProducts and emitted
  /// `selectedProductsUpdated` to every socket in the room — the host's
  /// own LiveController can pick that up to refresh the visible list.
  static Future<({bool ok, String message})> add({
    required String sellerId,
    required String productId,
  }) async {
    final uri = Uri.parse(Api.baseUrl + Api.addProductToLive);
    final body = jsonEncode({"sellerId": sellerId, "productId": productId});
    log("AddProductToLive → $uri body=$body");
    try {
      final res = await http.post(uri, headers: _headers, body: body);
      log("AddProductToLive ← ${res.statusCode} ${res.body}");
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      return (
        ok: json["status"] == true,
        message: (json["message"] ?? "").toString(),
      );
    } catch (e) {
      log("AddProductToLive error: $e");
      return (ok: false, message: "Network error. Please try again.");
    }
  }
}

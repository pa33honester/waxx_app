import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:waxxapp/utils/api_url.dart';

/// Lightweight DTO for the multi-select on the seller's add-product screen.
/// Discount text is precomputed server-agnostic so the picker UI doesn't
/// have to re-implement the flat-vs-percentage formatting.
class PromoCodeOption {
  PromoCodeOption({
    required this.id,
    required this.code,
    required this.discountLabel,
  });

  final String id;
  final String code;
  final String discountLabel;
}

class PromoCodeListService {
  static final _headers = {
    "key": Api.secretKey,
    "Content-Type": "application/json; charset=UTF-8",
  };

  /// Returns all admin-managed PromoCodes available for sellers to attach
  /// to a product. Empty list on any failure — the caller treats "no codes
  /// available" the same as "couldn't fetch", which is the right UX.
  static Future<List<PromoCodeOption>> fetchAll() async {
    final uri = Uri.parse("${Api.baseUrl}${Api.allPromoCode}");
    log("PromoCodeList → $uri");
    try {
      final res = await http.get(uri, headers: _headers);
      if (res.statusCode != 200) {
        log("PromoCodeList ← ${res.statusCode} ${res.body}");
        return const [];
      }
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      // Backend response shape: { status, message, promoCode: [ ... ] }
      final list = json["promoCode"] ?? json["promoCodes"] ?? json["data"] ?? const [];
      if (list is! List) return const [];
      return list.map(_parse).whereType<PromoCodeOption>().toList();
    } catch (e) {
      log("PromoCodeList error: $e");
      return const [];
    }
  }

  static PromoCodeOption? _parse(dynamic raw) {
    if (raw is! Map) return null;
    final id = raw["_id"]?.toString();
    if (id == null || id.isEmpty) return null;
    final code = (raw["promoCode"] ?? raw["code"] ?? "").toString();
    if (code.isEmpty) return null;

    final amount = raw["discountAmount"];
    final type = raw["discountType"]; // 0 = flat, 1 = percentage
    final amountText = amount == null ? "" : amount.toString();
    final label = type == 1 ? "$amountText% off" : (amountText.isEmpty ? "" : "$amountText off");

    return PromoCodeOption(id: id, code: code, discountLabel: label);
  }
}

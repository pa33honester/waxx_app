import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:waxxapp/ApiModel/offer/offer_model.dart';
import 'package:waxxapp/utils/api_url.dart';

/// Thin wrapper around the /offer/* backend routes. Used by both buyer and
/// seller flows — the server distinguishes roles via the action endpoint,
/// not auth, so a single service is enough.
class OfferService {
  static Map<String, String> get _headers => {
        'key': Api.secretKey,
        'Content-Type': 'application/json; charset=UTF-8',
      };

  static Future<OfferActionResult> createOffer({
    required String productId,
    required String buyerId,
    required num offerAmount,
    String buyerMessage = '',
  }) async {
    final url = Uri.parse("${Api.baseUrl}${Api.createOffer}");
    final body = jsonEncode({
      'productId': productId,
      'buyerId': buyerId,
      'offerAmount': offerAmount,
      'buyerMessage': buyerMessage,
    });
    try {
      final resp = await http.post(url, headers: _headers, body: body);
      return OfferActionResult.fromResponse(resp);
    } catch (e) {
      log('createOffer error: $e');
      return OfferActionResult(ok: false, message: 'Network error');
    }
  }

  static Future<OfferActionResult> withdraw({required String offerId, required String buyerId}) =>
      _patch(Api.withdrawOffer, {'offerId': offerId, 'buyerId': buyerId});

  static Future<OfferActionResult> accept({required String offerId}) =>
      _patch(Api.acceptOffer, {'offerId': offerId});

  static Future<OfferActionResult> counter({required String offerId, required num counterAmount}) =>
      _patch(Api.counterOffer, {'offerId': offerId, 'counterAmount': counterAmount});

  static Future<OfferActionResult> decline({required String offerId, required String declinedBy}) =>
      _patch(Api.declineOffer, {'offerId': offerId, 'declinedBy': declinedBy});

  static Future<List<OfferModel>> getReceived({required String sellerId, String? status}) async {
    final q = {'sellerId': sellerId, if (status != null && status.isNotEmpty) 'status': status};
    return _list(Api.getReceivedOffers, q);
  }

  static Future<List<OfferModel>> getSent({required String buyerId}) {
    return _list(Api.getSentOffers, {'buyerId': buyerId});
  }

  static Future<OfferActionResult> _patch(String path, Map<String, dynamic> payload) async {
    final url = Uri.parse("${Api.baseUrl}$path");
    try {
      final resp = await http.patch(url, headers: _headers, body: jsonEncode(payload));
      return OfferActionResult.fromResponse(resp);
    } catch (e) {
      log('$path error: $e');
      return OfferActionResult(ok: false, message: 'Network error');
    }
  }

  static Future<List<OfferModel>> _list(String path, Map<String, String> query) async {
    final url = Uri.parse("${Api.baseUrl}$path").replace(queryParameters: query);
    try {
      final resp = await http.get(url, headers: _headers);
      if (resp.statusCode != 200) return [];
      final data = jsonDecode(resp.body);
      if (data['status'] != true) return [];
      final list = (data['offers'] as List?) ?? const [];
      return list.map((e) => OfferModel.fromJson(Map<String, dynamic>.from(e))).toList();
    } catch (e) {
      log('$path error: $e');
      return [];
    }
  }
}

class OfferActionResult {
  final bool ok;
  final String message;
  final OfferModel? offer;
  final String? orderId;

  OfferActionResult({required this.ok, required this.message, this.offer, this.orderId});

  factory OfferActionResult.fromResponse(http.Response resp) {
    try {
      if (resp.statusCode != 200) {
        return OfferActionResult(ok: false, message: 'HTTP ${resp.statusCode}');
      }
      final data = jsonDecode(resp.body);
      return OfferActionResult(
        ok: data['status'] == true,
        message: data['message']?.toString() ?? '',
        offer: data['offer'] is Map
            ? OfferModel.fromJson(Map<String, dynamic>.from(data['offer']))
            : null,
        orderId: data['order'] is Map ? data['order']['_id']?.toString() : null,
      );
    } catch (e) {
      return OfferActionResult(ok: false, message: 'Parse error: $e');
    }
  }
}

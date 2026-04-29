import 'dart:convert';
import 'dart:developer';

import 'package:waxxapp/ApiModel/user/GetAllCartProductsModel.dart';
import 'package:waxxapp/utils/api_url.dart';
import 'package:http/http.dart' as http;

/// Shape B per-option shipping (v1.0.10) — buyer flipped the chosen
/// delivery option on a cart line. Backend updates the cart item's
/// `chosenDeliveryType` + `purchasedTimeShippingCharges`, re-aggregates
/// the cart total, and returns the populated cart.
class UpdateCartDeliveryOptionService {
  static Future<GetAllCartProductsModel?> update({
    required String userId,
    required String productId,
    required String chosenDeliveryType,
    List<dynamic>? attributesArray,
  }) async {
    try {
      final uri = Uri.parse(Api.baseUrl + Api.updateCartDeliveryOption);
      final body = jsonEncode({
        "userId": userId,
        "productId": productId,
        "chosenDeliveryType": chosenDeliveryType,
        if (attributesArray != null) "attributesArray": attributesArray,
      });

      final response = await http.patch(
        uri,
        headers: {
          "key": Api.secretKey,
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: body,
      );

      log("UpdateCartDeliveryOption ${response.statusCode}: ${response.body}");
      if (response.statusCode != 200) return null;
      // Backend wraps the populated cart under `data` for this endpoint.
      // Reuse the existing cart model factory by feeding it just the data
      // chunk (which is the cart shape the buyer cart page already reads).
      final decoded = json.decode(response.body) as Map<String, dynamic>;
      if (decoded["status"] != true || decoded["data"] == null) return null;
      // The /getCartProduct response wraps cart inside `data`; this
      // endpoint returns the same shape, so we instantiate the model
      // directly off `data`.
      return GetAllCartProductsModel(
        status: decoded["status"] as bool?,
        message: decoded["message"] as String?,
        data: Data.fromJson(decoded["data"] as Map<String, dynamic>),
      );
    } catch (e) {
      log("UpdateCartDeliveryOption failed: $e");
      return null;
    }
  }
}

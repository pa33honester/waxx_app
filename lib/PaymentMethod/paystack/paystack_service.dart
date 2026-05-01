import 'dart:convert';

import 'package:waxxapp/utils/api_url.dart';
import 'package:waxxapp/utils/database.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:paystack_for_flutter/paystack_for_flutter.dart';

class PaystackService {
  /// Launches the Paystack Standard checkout (in-app webview), then verifies
  /// the resulting reference against our backend before invoking [callback].
  ///
  /// We never trust the client-side success event by itself — the popup only
  /// proves the in-app webview saw a success page, not that Paystack actually
  /// settled the charge. The backend's POST /payment/paystack/verify route
  /// hits Paystack's transaction/verify endpoint with the secret key and
  /// confirms `status === "success"` plus the amount we expected.
  ///
  /// [amount] is the major-unit amount in GHS (e.g. 280254 for GH¢280,254).
  /// We convert to pesewas (×100) here, since Paystack expects the smallest
  /// currency unit.
  /// Launches the Paystack checkout. [onVerified] fires only after the
  /// backend's `/payment/paystack/verify` confirms the charge actually
  /// settled — never on the popup's onSuccess alone. The reference
  /// argument is the Paystack transaction reference; pass it to
  /// `/order/create` so the webhook handler can find the order if the
  /// app dies before the verify call returns.
  Future<void> pay({
    required int amount,
    required Future<void> Function(String reference) onVerified,
  }) async {
    final email = (Database.fetchLoginUserProfileModel?.user?.email ?? "").trim();

    // The `paystack_for_flutter` package proxies through Paystack's
    // server-side initialize endpoint, which requires the secret key — that's
    // why this widget takes secretKey rather than publicKey. Rotate via the
    // admin Settings page if it's ever exposed.
    if (paystackSecretKey.isEmpty) {
      Utils.showToast("Paystack is not configured. Contact support.");
      return;
    }
    if (email.isEmpty) {
      Utils.showToast("Add an email to your profile to pay with Paystack.");
      return;
    }

    final reference = "wxp_${DateTime.now().millisecondsSinceEpoch}_${Database.loginUserId}";
    final pesewas = amount * 100;

    await PaystackFlutter().pay(
      context: Get.context!,
      secretKey: paystackSecretKey,
      amount: pesewas.toDouble(),
      email: email,
      reference: reference,
      currency: Currency.GHS,
      callbackUrl: "${Api.baseUrl}payment/paystack/callback",
      showProgressBar: true,
      paymentOptions: [
        PaymentOption.card,
        PaymentOption.bankTransfer,
        PaymentOption.mobileMoney,
        PaymentOption.ussd,
      ],
      metaData: {
        "userId": Database.loginUserId,
      },
      onSuccess: (paystackCallback) async {
        Utils.showLog("Paystack popup reported success: ${paystackCallback.reference}");
        final verified = await _verifyOnBackend(
          reference: paystackCallback.reference,
          expectedAmount: pesewas,
        );
        if (verified) {
          await onVerified(paystackCallback.reference);
        } else {
          Utils.showToast("Payment couldn't be verified. Please try again.");
        }
      },
      onCancelled: (paystackCallback) {
        Utils.showLog("Paystack cancelled: ${paystackCallback.reference}");
      },
    );
  }

  Future<bool> _verifyOnBackend({required String reference, required int expectedAmount}) async {
    try {
      final uri = Uri.parse("${Api.baseUrl}${Api.paystackVerify}");
      final response = await http
          .post(
            uri,
            headers: {
              "key": Api.secretKey,
              "Content-Type": "application/json",
            },
            body: jsonEncode({
              "reference": reference,
              "expectedAmount": expectedAmount,
              "userId": Database.loginUserId,
            }),
          )
          .timeout(const Duration(seconds: 20));

      Utils.showLog("Paystack verify response (${response.statusCode}): ${response.body}");
      if (response.statusCode != 200) return false;
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return body["status"] == true;
    } catch (e) {
      Utils.showLog("Paystack verify failed: $e");
      return false;
    }
  }
}

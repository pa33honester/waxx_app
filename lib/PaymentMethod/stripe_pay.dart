import 'dart:convert';
import 'dart:developer';

import 'package:waxxapp/View/MyApp/AppPages/cheak_out.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../Controller/GetxController/user/create_order_by_user_controller.dart';
import '../Controller/GetxController/user/get_all_cart_products_controller.dart';
import '../Controller/GetxController/user/get_all_promocode_controller.dart';
import '../utils/globle_veriables.dart';
import '../utils/show_toast.dart';

class StripeService {
  CreateOrderByUserController createOrderByUserController = Get.put(CreateOrderByUserController());
  GetAllCartProductController getAllCartProductController = Get.put(GetAllCartProductController());
  GetAllPromoCodeController getAllPromoCodeController = Get.put(GetAllPromoCodeController());

  Map<String, dynamic>? paymentIntentData;

  RxBool isStripeLoading = false.obs;

  Future<void> makePayment({
    required int amount,
    required String currency,
  }) async {
    try {
      Get.dialog(
        Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
        barrierDismissible: false,
      );
      paymentIntentData = await createPaymentIntent(amount, currency);
      if (paymentIntentData != null) {
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
          primaryButtonLabel: "Pay $currencySymbol ${amount.toStringAsFixed(2)}",
          // appearance: const PaymentSheetAppearance(
          //     colors: PaymentSheetAppearanceColors(background: Colors.white),
          //     shapes: PaymentSheetShape(
          //       borderRadius: 20,
          //       borderWidth: 2,
          //     )),
          allowsDelayedPaymentMethods: true,
          customFlow: true,
          merchantDisplayName: 'Prospects',
          customerId: paymentIntentData!['customer'],
          paymentIntentClientSecret: paymentIntentData!['client_secret'],
          googlePay: const PaymentSheetGooglePay(merchantCountryCode: '+91', testEnv: true),
        ));
        displayPaymentSheet();
      }
    } catch (e, s) {
      log("After payment intent Error: ${e.toString()}");
      log("After payment intent s Error: ${s.toString()}");
    } finally {
      Get.back();
      1.5.seconds;
      isStripeLoading(false);
    }
  }

  Future<void> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      paymentIntentData = null;

      await createOrderByUserController.postOrderData(
        paymentGateway: "Stripe",
        promoCode: getAllPromoCodeController.promoCodeController.text,
        finalTotal: createOrderByUserController.isPromoApplied == true
            ? createOrderByUserController.finalAmount
            : createOrderByUserController.total,
        paymentStatus: 2,
      );
      if (createOrderByUserController.createOrderByUserModel!.status == true) {
        OrderConfirmDialogUi.onShow(
          callBack: () {
            Get.offAllNamed("/BottomTabBar");
            Get.toNamed("/MyOrder");
          },
        );
      } else {
        displayToast(message: "Try other promo!");
      }
    } on Exception catch (e) {
      if (e is StripeException) {
        debugPrint("Error from Stripe: ${e.error.localizedMessage}");
      } else {
        debugPrint("Unforced Error: $e");
      }
    } catch (e) {
      debugPrint("Exception $e");
    }
  }

  createPaymentIntent(int amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculate(amount.toString()),
        'currency': currency,
        'payment_method_types[]': 'card',
      };

      log("Start Payment Intent http rwq post method");
      log("body $body");

      var response = await http.post(Uri.parse("https://api.stripe.com/v1/payment_intents"), body: body, headers: {
        "Authorization": "Bearer $stripeTestSecretKey",
        "Content-Type": 'application/x-www-form-urlencoded'
      });
      log("End Payment Intent http rwq post method");
      log(" payment response ${response.body.toString()}");

      return jsonDecode(response.body);
    } catch (e) {
      log('err charging user: ${e.toString()}');
    }
  }

  calculate(String amount) {
    final a = (double.parse(amount).toInt()) * 100;
    return a.toString();
  }
}

import 'dart:developer';

import 'package:era_shop/ApiModel/user/CreateOrderByUserModel.dart';
import 'package:era_shop/ApiService/user/check_out_service.dart';
import 'package:era_shop/ApiService/user/create_order_by_user_service.dart';
import 'package:era_shop/PaymentMethod/flutter_wave/flutter_wave_services.dart';
import 'package:era_shop/PaymentMethod/razor_pay/razor_pay_view.dart';
import 'package:era_shop/PaymentMethod/stripe/stripe_service.dart';
import 'package:era_shop/View/MyApp/AppPages/cheak_out.dart';
import 'package:era_shop/custom/loading_ui.dart';
import 'package:era_shop/seller_pages/order_payment_page/view/order_payment_view.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/Theme/theme_service.dart';
import 'package:era_shop/utils/app_asset.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:era_shop/utils/show_toast.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:get/get.dart';

import '../../../utils/database.dart' show Database;

class OrderPaymentController extends GetxController {
  // CheckOutController checkOutController = Get.find<CheckOutController>();

  num finalTotal = 0.0;
  String promoCode = "";
  String selectedPromoCodeId = "";
  bool isAuctionPayment = false;
  String orderId = ""; // Add orderId for auction payments
  String itemId = ""; // Add itemId for auction payments
  int paymentStatus = 2; //1 => Pending(Cash on Delivery), 2 => Completed(stripe, razorpay, flutterwave)
  CreateOrderByUserModel? createOrderByUserModel;

  @override
  void onInit() {
    Utils.showLog("Selected Plan => ${Get.arguments}");
    getArguments();
    super.onInit();
  }

  getArguments() {
    finalTotal = Get.arguments["finalTotal"] ?? "";
    promoCode = Get.arguments["promoCode"] ?? "";
    selectedPromoCodeId = Get.arguments["selectedPromoCodeId"] ?? "";
    isAuctionPayment = Get.arguments["isAuctionPayment"] ?? false;
    orderId = Get.arguments["orderId"] ?? "";
    itemId = Get.arguments["productId"] ?? "";
  }

  final paymentMethodList = [
    {"icon": AppAsset.icRazorpay, "title": "Razorpay", "size": "35.0"},
    {"icon": AppAsset.icStripe, "title": "Stripe", "size": "35.0"},
    {"icon": AppAsset.icFlutterWave, "title": "Flutter Wave", "size": "30"},
    {"icon": AppAsset.icCashOnDelivery, "title": "Cash on Delivery", "size": "30"},
  ];

  int selectedPaymentMethod = 0;

  void onChangePaymentMethod(int index) async {
    selectedPaymentMethod = index;
    update(["onChangePaymentMethod"]);
  }

  // Helper method to handle post-payment success logic
  Future<void> handlePaymentSuccess(String paymentGateway, int paymentStatus) async {
    Get.dialog(const LoadingUi(), barrierDismissible: false);

    try {
      bool isSuccess = false;

      if (isAuctionPayment) {
        Utils.showLog("Processing auction payment - updating order item status");
        isSuccess = await CreateOrderByUserApi.updateOrderItemStatusCallApi(
          userId: Database.loginUserId,
          orderId: orderId,
          itemId: itemId,
          paymentGateway: paymentGateway,
        );
      } else {
        Utils.showLog("Processing regular payment - creating new order");
        createOrderByUserModel = await CreateOrderByUserApi.createOrderByUserApi(paymentGateway: paymentGateway, promoCode: promoCode, finalTotal: finalTotal, paymentStatus: paymentStatus);
        isSuccess = createOrderByUserModel?.status == true;
      }

      Get.back(); // Stop Loading

      if (isSuccess) {
        String successMessage = isAuctionPayment ? St.txtAuctionOrderApproved.tr : St.txtCreateOrderSuccess.tr;
        Utils.showToast(successMessage);
        OrderConfirmDialogUi.onShow(
          callBack: () {
            Get.offAllNamed("/BottomTabBar");
            Get.toNamed("/MyOrder");
          },
        );
      } else {
        Utils.showToast(St.somethingWentWrong.tr);
      }
    } catch (e) {
      Get.back(); // Ensure loading dialog is dismissed
      Utils.showLog("Payment processing error: $e");
      Utils.showToast(St.somethingWentWrong.tr);
    }
  }

  Future<void> onClickPayNow() async {
    if (getStorage.read("isDemoLogin") ?? false || isDemoSeller) {
      displayToast(message: St.thisIsDemoUser.tr);
      return;
    }
    // >>>>> >>>>> >>>>> RazorPay Payment <<<<< <<<<< <<<<<

    if (selectedPaymentMethod == 0) {
      Utils.showLog("Razorpay Payment Working....");
      Utils.showLog("Is Auction Payment: $isAuctionPayment");

      try {
        Get.dialog(const LoadingUi(), barrierDismissible: false); // Start Loading...
        RazorPayService().init(
          razorKey: razorPayKey,
          callback: () async {
            Utils.showLog("RazorPay Payment Successfully");
            await handlePaymentSuccess("Razorpay", paymentStatus);
          },
        );
        await 1.seconds.delay();
        RazorPayService().razorPayCheckout(((finalTotal ?? 0) * 100).toInt());
        Get.back(); // Stop Loading...
      } catch (e) {
        Get.back(); // Stop Loading...
        Utils.showLog("RazorPay Payment Failed => $e");
      }
    }

    // >>>>> >>>>> >>>>> Stripe Payment <<<<< <<<<< <<<<<

    if (selectedPaymentMethod == 1) {
      try {
        Utils.showLog("Stripe Payment Working...$finalTotal");
        Utils.showLog("Is Auction Payment: $isAuctionPayment");
        Get.dialog(const LoadingUi(), barrierDismissible: false); // Start Loading...
        await StripeService().init(isTest: true);
        await 1.seconds.delay();
        StripeService()
            .stripePay(
          amount: ((finalTotal ?? 0) * 100).toInt(),
          callback: () async {
            Utils.showLog("Stripe Payment Success Method Called....");
            await handlePaymentSuccess("Stripe", paymentStatus);
          },
        )
            .then((value) async {
          Utils.showLog("Stripe Payment Successfully");
        }).catchError((e) {
          Utils.showLog("Stripe Payment Error!");
        });
        Get.back(); // Stop Loading...
      } catch (e) {
        Get.back(); // Stop Loading...
        Utils.showLog("Stripe Payment Failed => $e");
      }
    }

    // >>>>> >>>>> >>>>> Flutter Wave Payment <<<<< <<<<< <<<<<

    if (selectedPaymentMethod == 2) {
      // Fixed index from 3 to 2
      Utils.showLog("Flutter Wave Payment Working....");
      Utils.showLog("Is Auction Payment: $isAuctionPayment");

      try {
        Get.dialog(const LoadingUi(), barrierDismissible: false); // Start Loading...
        FlutterWaveService.init(
          amount: finalTotal.toString() ?? "",
          onPaymentComplete: () async {
            Utils.showLog("Flutter Wave Payment Successfully");
            await handlePaymentSuccess("Flutter Wave", paymentStatus);
          },
        );

        Get.back(); // Stop Loading...
      } catch (e) {
        Get.back(); // Stop Loading...
        Utils.showLog("Flutter Wave Payment Failed => $e");
      }
    }
    // >>>>> >>>>> >>>>> Cash On Delivery Payment <<<<< <<<<< <<<<<
    if (selectedPaymentMethod == 3) {
      showVerificationDialog(
        onVerified: () async {
          paymentStatus = 1;
          await handlePaymentSuccess("Cash On Delivery", paymentStatus);
        },
      );
    }
  }
}

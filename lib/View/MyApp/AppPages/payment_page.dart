// import 'dart:developer';
// import 'dart:math' as math;
//
// import 'package:era_shop/Controller/GetxController/user/create_order_by_user_controller.dart';
// import 'package:era_shop/Controller/GetxController/user/get_all_cart_products_controller.dart';
// import 'package:era_shop/Controller/GetxController/user/get_all_promocode_controller.dart';
// import 'package:era_shop/Controller/GetxController/user/get_only_selected_user_address_controller.dart';
// import 'package:era_shop/PaymentMethod/flutter_wave/flutter_wave_pay.dart';
// import 'package:era_shop/PaymentMethod/stripe_pay.dart';
// import 'package:era_shop/custom/main_button_widget.dart';
// import 'package:era_shop/custom/simple_app_bar_widget.dart';
// import 'package:era_shop/utils/Strings/strings.dart';
// import 'package:era_shop/utils/Theme/theme_service.dart';
// import 'package:era_shop/utils/app_asset.dart';
// import 'package:era_shop/utils/app_colors.dart';
// import 'package:era_shop/utils/font_style.dart';
// import 'package:era_shop/utils/globle_veriables.dart';
// import 'package:era_shop/utils/show_toast.dart';
// import 'package:era_shop/utils/utils.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:pinput/pinput.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
//
// import 'cheak_out.dart';
//
// class PaymentPage extends StatefulWidget {
//   const PaymentPage({super.key});
//
//   @override
//   State<PaymentPage> createState() => _PaymentPageState();
// }
//
// class _PaymentPageState extends State<PaymentPage> {
//   GetOnlySelectedUserAddressController getOnlySelectedUserAddressController = Get.put(GetOnlySelectedUserAddressController());
//   CreateOrderByUserController createOrderByUserController = Get.put(CreateOrderByUserController());
//   GetAllCartProductController getAllCartProductController = Get.put(GetAllCartProductController());
//   GetAllPromoCodeController getAllPromoCodeController = Get.put(GetAllPromoCodeController());
//
//   var stripePayService = StripeService();
//   late Razorpay razorpay;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     // editProfileController.mobileNumberController.text = "+91 ";
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await getAllCartProductController.getCartProductData();
//       if (getAllCartProductController.getAllCartProducts?.data != null) {
//         createOrderByUserController.total = ((getAllCartProductController.getAllCartProducts!.data!.subTotal ?? 0).toInt() + (getAllCartProductController.getAllCartProducts!.data!.totalShippingCharges ?? 0).toInt());
//       }
//       getOnlySelectedUserAddressController.getOnlySelectedUserAddressData();
//       razorpay = Razorpay();
//       razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//       razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//       razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//     });
//
//     super.initState();
//   }
//
//   /// Razor Pay Success function ///
//   Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
//     OrderConfirmDialogUi.onShow(
//       callBack: () {
//         Get.offAllNamed("/BottomTabBar");
//         Get.toNamed("/MyOrder");
//       },
//     );
//
//     createOrderByUserController.postOrderData(
//       paymentGateway: getAllCartProductController.paymentSelect.value == 0 ? "Stripe" : "Razorpay",
//       promoCode: getAllPromoCodeController.promoCodeController.text,
//       finalTotal: createOrderByUserController.isPromoApplied == true
//           ? createOrderByUserController.finalAmount.toInt()
//           : ((getAllCartProductController.getAllCartProducts?.data!.subTotal ?? 0).toInt() + (getAllCartProductController.getAllCartProducts?.data!.totalShippingCharges ?? 0).toInt()),
//       paymentStatus: 2,
//     );
//   }
//
//   /// Razor Pay error function ///
//   void _handlePaymentError(PaymentFailureResponse response) {
//     displayToast(message: "${response.code} - ${response.message}");
//   }
//
//   /// Razor Pay Wallet  function ///
//   void _handleExternalWallet(ExternalWalletResponse response) {
//     displayToast(message: "EXTERNAL_WALLET: ${response.walletName}");
//   }
//
//   /// Razor Pay ///
//   void openCheckout(
//     String amount,
//   ) {
//     var options = {
//       'key': razorPayKey,
//       'amount': num.parse(amount) * 100,
//       'name': St.appName.tr,
//       'theme.color': '#DEF213',
//       'description': St.appNameProduct.tr,
//       'image': 'https://razorpay.com/assets/razorpay-glyph.svg',
//       'currency': "USD",
//       'prefill': {'contact': "9966332255", 'email': "sdfdf@gmail.com"},
//       'external': {
//         'wallets': ["paytm"]
//       }
//     };
//     try {
//       razorpay.open(options);
//     } catch (e) {
//       log(e.toString());
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(60),
//         child: AppBar(
//           automaticallyImplyLeading: false,
//           backgroundColor: AppColors.transparent,
//           shadowColor: AppColors.black.withValues(alpha: 0.4),
//           flexibleSpace: SimpleAppBarWidget(title: St.payment.tr),
//         ),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 15),
//           child: Obx(
//             () {
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     St.paymentMethod.tr,
//                     style: AppFontStyle.styleW700(AppColors.white, 18),
//                   ),
//                   20.height,
//
//                   /// stripe
//                   stripeSwitch
//                       ? GestureDetector(
//                           onTap: () {
//                             getAllCartProductController.paymentSelect.value = 0;
//                           },
//                           child: Container(
//                             height: 65,
//                             decoration: BoxDecoration(
//                               color: AppColors.tabBackground,
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                             child: Row(
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(left: 8, right: 10),
//                                   child: Container(
//                                     height: 50,
//                                     width: 50,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(10),
//                                       color: AppColors.white,
//                                     ),
//                                     child: Image.asset(
//                                       "assets/icons/stripe.png",
//                                       height: 30,
//                                     ),
//                                   ),
//                                 ),
//                                 Text(
//                                   "Stripe",
//                                   style: AppFontStyle.styleW700(AppColors.white, 15),
//                                 ),
//                                 const Spacer(),
//                                 Padding(
//                                   padding: const EdgeInsets.only(right: 20),
//                                   child: getAllCartProductController.paymentSelect.value == 0
//                                       ? Container(
//                                           height: 24,
//                                           width: 24,
//                                           decoration: BoxDecoration(
//                                             shape: BoxShape.circle,
//                                             color: AppColors.primaryPink,
//                                           ),
//                                           child: const Icon(Icons.done_outlined, color: Colors.black, size: 15),
//                                         )
//                                       : Container(
//                                           height: 24,
//                                           width: 24,
//                                           decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade400)),
//                                         ),
//                                 )
//                               ],
//                             ),
//                           ),
//                         )
//                       : const SizedBox(),
//
//                   /// razorpay
//                   razorPaySwitch
//                       ? GestureDetector(
//                           onTap: () {
//                             getAllCartProductController.paymentSelect.value = 1;
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 17),
//                             child: Container(
//                               height: 65,
//                               decoration: BoxDecoration(
//                                 color: AppColors.tabBackground,
//                                 borderRadius: BorderRadius.circular(15),
//                                 // border: isDark.value
//                                 //     ? getAllCartProductController.paymentSelect.value == 1
//                                 //         ? Border.all(color: AppColors.primaryPink)
//                                 //         : Border.all(color: Colors.transparent)
//                                 //     : getAllCartProductController.paymentSelect.value == 1
//                                 //         ? Border.all(color: AppColors.primaryPink)
//                                 //         : Border.all(color: Colors.grey.shade400),
//                               ),
//                               child: Row(
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.only(left: 8, right: 10),
//                                     child: Container(
//                                       height: 50,
//                                       width: 50,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(10),
//                                         color: AppColors.white,
//                                       ),
//                                       child: Image.asset(
//                                         "assets/icons/razorpay.png",
//                                         height: 30,
//                                       ),
//                                     ),
//                                   ),
//                                   Text(
//                                     "Razor Pay",
//                                     style: AppFontStyle.styleW700(AppColors.white, 15),
//                                   ),
//                                   const Spacer(),
//                                   Padding(
//                                     padding: const EdgeInsets.only(right: 20),
//                                     child: getAllCartProductController.paymentSelect.value == 1
//                                         ? Container(
//                                             height: 24,
//                                             width: 24,
//                                             decoration: BoxDecoration(
//                                               shape: BoxShape.circle,
//                                               color: AppColors.primaryPink,
//                                             ),
//                                             child: const Icon(Icons.done_outlined, color: Colors.black, size: 15),
//                                           )
//                                         : Container(
//                                             height: 24,
//                                             width: 24,
//                                             decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade400)),
//                                           ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         )
//                       : const SizedBox(),
//
//                   /// flutter wave
//                   flutterWaveSwitch
//                       ? GestureDetector(
//                           onTap: () {
//                             getAllCartProductController.paymentSelect.value = 2;
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 0),
//                             child: Container(
//                               height: 65,
//                               decoration: BoxDecoration(
//                                 color: AppColors.tabBackground,
//                                 borderRadius: BorderRadius.circular(15),
//                               ),
//                               child: Row(
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.only(left: 8, right: 10),
//                                     child: Container(
//                                       height: 50,
//                                       width: 50,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(10),
//                                         color: AppColors.white,
//                                       ),
//                                       child: Image.asset(
//                                         "assets/icons/flutterWave.png",
//                                         height: 30,
//                                       ),
//                                     ),
//                                   ),
//                                   Text(
//                                     "Flutter wave",
//                                     style: AppFontStyle.styleW700(AppColors.white, 15),
//                                   ),
//                                   const Spacer(),
//                                   Padding(
//                                     padding: const EdgeInsets.only(right: 20),
//                                     child: getAllCartProductController.paymentSelect.value == 2
//                                         ? Container(
//                                             height: 24,
//                                             width: 24,
//                                             decoration: BoxDecoration(
//                                               shape: BoxShape.circle,
//                                               color: AppColors.primaryPink,
//                                             ),
//                                             child: const Icon(Icons.done_outlined, color: Colors.black, size: 15),
//                                           )
//                                         : Container(
//                                             height: 24,
//                                             width: 24,
//                                             decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade400)),
//                                           ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         )
//                       : const SizedBox(),
//
//                   ///Cash on Delivery
//                   codSwitch
//                       ? GestureDetector(
//                           onTap: () {
//                             getAllCartProductController.paymentSelect.value = 3;
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 17),
//                             child: Container(
//                               height: 65,
//                               decoration: BoxDecoration(
//                                 color: AppColors.tabBackground,
//                                 borderRadius: BorderRadius.circular(15),
//                               ),
//                               child: Row(
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.only(left: 8, right: 10),
//                                     child: Container(
//                                       height: 50,
//                                       width: 50,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(10),
//                                         color: AppColors.white,
//                                       ),
//                                       child: Image.asset(
//                                         "assets/icons/cod.png",
//                                         height: 20,
//                                       ).paddingAll(8),
//                                     ),
//                                   ),
//                                   Text(
//                                     "Cash On Delivery",
//                                     style: AppFontStyle.styleW700(AppColors.white, 15),
//                                   ),
//                                   const Spacer(),
//                                   Padding(
//                                     padding: const EdgeInsets.only(right: 20),
//                                     child: getAllCartProductController.paymentSelect.value == 3
//                                         ? Container(
//                                             height: 24,
//                                             width: 24,
//                                             decoration: BoxDecoration(
//                                               shape: BoxShape.circle,
//                                               color: AppColors.primaryPink,
//                                             ),
//                                             child: const Icon(Icons.done_outlined, color: Colors.black, size: 15),
//                                           )
//                                         : Container(
//                                             height: 24,
//                                             width: 24,
//                                             decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade400)),
//                                           ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         )
//                       : const SizedBox(),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(15),
//         child: MainButtonWidget(
//           height: 60,
//           width: Get.width,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 St.payNow.tr,
//                 overflow: TextOverflow.ellipsis,
//                 maxLines: 1,
//                 style: AppFontStyle.styleW700(AppColors.black, 15),
//               ),
//               8.width,
//               Image.asset(AppAsset.icDoubleArrowRight, width: 14),
//             ],
//           ),
//           callback: () async {
//             if (getOnlySelectedUserAddressController.userAddressSelect?.address == null) {
//               Fluttertoast.showToast(
//                 msg: "Please select address",
//                 backgroundColor: AppColors.grayLight,
//                 textColor: AppColors.white,
//                 gravity: ToastGravity.BOTTOM,
//               );
//               return; // Stop execution if address is null
//             } else {
//               log("Final amount :: ${createOrderByUserController.finalAmount}");
//               log("Final total :: ${createOrderByUserController.total}");
//               log("Final total :: ${createOrderByUserController.isPromoApplied}");
//
//               log("index:${getAllCartProductController.paymentSelect.value}");
//
//               if (getStorage.read("isDemoLogin") ?? false) {
//                 displayToast(message: St.thisIsDemoUser.tr);
//                 return;
//               }
//
//               /// Payment Rozarpay and stripe \\\
//               if (getAllCartProductController.paymentSelect.value == 0) {
//                 Stripe.publishableKey = stripPublishableKey;
//                 await Stripe.instance.applySettings();
//                 stripePayService.makePayment(
//                   amount: createOrderByUserController.isPromoApplied == true ? createOrderByUserController.finalAmount.toInt() : createOrderByUserController.total.toInt(),
//                   currency: currencyCode ?? "",
//                 );
//               } else if (getAllCartProductController.paymentSelect.value == 1) {
//                 openCheckout(
//                   createOrderByUserController.isPromoApplied == true ? "${createOrderByUserController.finalAmount.toDouble()}" : createOrderByUserController.total.toString(),
//                 );
//               } else if (getAllCartProductController.paymentSelect.value == 2) {
//                 FlutterWaveService().handlePaymentInitialization(
//                   createOrderByUserController.isPromoApplied == true ? "${createOrderByUserController.finalAmount.toDouble()}" : createOrderByUserController.total.toString(),
//                 );
//                 // FlutterWaveService().handlePaymentInitialization(createOrderByUserController.finalAmount.toStringAsFixed(2));
//                 log("flutter wave");
//               } else if (getAllCartProductController.paymentSelect.value == 3) {
//                 showVerificationDialog(
//                   onVerified: () async {
//                     try {
//                       await createOrderByUserController.postOrderData(
//                         paymentGateway: "CashOnDelivery",
//                         promoCode: getAllPromoCodeController.promoCodeController.text,
//                         finalTotal: createOrderByUserController.isPromoApplied == true ? createOrderByUserController.finalAmount : createOrderByUserController.total,
//                         paymentStatus: 1,
//                       );
//                       if (createOrderByUserController.createOrderByUserModel!.status == true) {
//                         OrderConfirmDialogUi.onShow(
//                           callBack: () {
//                             Get.offAllNamed("/BottomTabBar");
//                             Get.toNamed("/MyOrder");
//                           },
//                         );
//                       } else {
//                         displayToast(message: "Try other promo!");
//                       }
//                     } catch (e) {
//                       Utils.showToast('Failed to place order: ${e.toString()}');
//                     }
//                   },
//                 );
//               }
//             }
//           },
//         ),
//       ),
//     );
//   }
//
//   final randomNumber = ''.obs;
//   final enteredNumber = ''.obs;
//   final isLoading = false.obs;
//
//   void generateRandomNumber() {
//     final random = math.Random();
//     randomNumber.value = (1000 + random.nextInt(9000)).toString();
//   }
//
//   void showVerificationDialog({
//     required Function() onVerified,
//   }) {
//     generateRandomNumber();
//
//     Get.dialog(
//       barrierDismissible: false,
//       Dialog(
//         backgroundColor: AppColors.white,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(45),
//         ),
//         child: Container(
//           padding: EdgeInsets.all(24),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(45),
//             color: AppColors.white,
//           ),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // Title
//                 Text(
//                   St.oTPCode.tr,
//                   style: AppFontStyle.styleW800(AppColors.black, 22),
//                 ),
//                 FittedBox(
//                   child: Text(
//                     St.verificationRequired.tr,
//                     style: AppFontStyle.styleW800(AppColors.black, 22),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//
//                 // Description
//                 Text(
//                   St.pleaseEnterThisNumberToConfirmYourOrder.tr,
//                   textAlign: TextAlign.center,
//                   style: AppFontStyle.styleW600(AppColors.unselected, 14),
//                 ),
//                 20.height,
//
//                 // Random Number Display
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                   decoration: BoxDecoration(
//                     color: Color(0xffFFF5F5),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Text(
//                     randomNumber.value,
//                     style: TextStyle(letterSpacing: 6, fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xffF46B6B)),
//                   ),
//                 ),
//                 24.height,
//                 Pinput(
//                   length: 4,
//                   onChanged: (value) => enteredNumber.value = value,
//                   onCompleted: (value) => enteredNumber.value = value,
//                   defaultPinTheme: PinTheme(
//                     width: 50,
//                     height: 50,
//                     textStyle: AppFontStyle.styleW700(AppColors.black, 18),
//                     decoration: BoxDecoration(
//                       color: AppColors.white,
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: AppColors.unselected.withValues(alpha: .7), width: 1),
//                     ),
//                   ),
//                   focusedPinTheme: PinTheme(
//                     width: 50,
//                     height: 50,
//                     textStyle: AppFontStyle.styleW700(AppColors.black, 18),
//                     decoration: BoxDecoration(
//                       color: AppColors.white,
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: AppColors.unselected, width: 2),
//                     ),
//                   ),
//                   submittedPinTheme: PinTheme(
//                     width: 50,
//                     height: 50,
//                     textStyle: AppFontStyle.styleW700(AppColors.black, 18),
//                     decoration: BoxDecoration(
//                       color: AppColors.white,
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: AppColors.unselected, width: 1),
//                     ),
//                   ),
//                   errorPinTheme: PinTheme(
//                     width: 50,
//                     height: 50,
//                     textStyle: AppFontStyle.styleW700(AppColors.red, 18),
//                     decoration: BoxDecoration(
//                       color: AppColors.tabBackground,
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: AppColors.red, width: 2),
//                     ),
//                   ),
//                   cursor: Container(
//                     width: 1,
//                     height: 20,
//                     color: AppColors.primary,
//                   ),
//                 ),
//                 20.height,
//                 GestureDetector(
//                   onTap: () {
//                     Get.back();
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(100),
//                       color: AppColors.red,
//                     ),
//                     height: 52,
//                     width: Get.width,
//                     child: Center(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(St.cancelText.tr, style: AppFontStyle.styleW700(AppColors.white, 16)),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 10.height,
//                 Obx(
//                   () => GestureDetector(
//                     onTap: enteredNumber.value == randomNumber.value
//                         ? () {
//                             Get.back();
//                             onVerified();
//                           }
//                         : () {
//                             Utils.showToast(St.verificationFailedPleaseCheckTheCodeAndTryAgain.tr);
//                           },
//                     child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(100),
//                         color: enteredNumber.value == randomNumber.value ? AppColors.primary : AppColors.unselected.withValues(alpha: 0.2),
//                       ),
//                       height: 52,
//                       width: Get.width,
//                       child: Center(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(St.submit.tr, style: AppFontStyle.styleW700(enteredNumber.value == randomNumber.value ? AppColors.black : AppColors.unselected, 16)),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

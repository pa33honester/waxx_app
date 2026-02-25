import 'dart:developer';

import 'package:dotted_line/dotted_line.dart';
import 'package:era_shop/Controller/GetxController/user/get_all_promocode_controller.dart';
import 'package:era_shop/Controller/GetxController/user/user_apply_promo_check_controller.dart';
import 'package:era_shop/custom/main_button_widget.dart';
import 'package:era_shop/custom/simple_app_bar_widget.dart';
import 'package:era_shop/utils/CoustomWidget/App_theme_services/no_data_found.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_asset.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:era_shop/utils/shimmers.dart';
import 'package:era_shop/utils/show_toast.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../Controller/GetxController/user/create_order_by_user_controller.dart';
import '../../../Controller/GetxController/user/edit_profile_controller.dart';
import '../../../Controller/GetxController/user/get_all_cart_products_controller.dart';
import '../../../Controller/GetxController/user/get_only_selected_user_address_controller.dart';
import '../../../PaymentMethod/stripe_pay.dart';

class CheckOut extends StatefulWidget {
  const CheckOut({super.key});

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  GetOnlySelectedUserAddressController getOnlySelectedUserAddressController = Get.put(GetOnlySelectedUserAddressController());
  GetAllCartProductController getAllCartProductController = Get.put(GetAllCartProductController());
  GetAllPromoCodeController getAllPromoCodeController = Get.put(GetAllPromoCodeController());
  EditProfileController editProfileController = Get.put(EditProfileController());
  UserApplyPromoCheckController userApplyPromoCheckController = Get.put(UserApplyPromoCheckController());
  CreateOrderByUserController createOrderByUserController = Get.put(CreateOrderByUserController());

  //-------------------------------------------------------------------------------

  final FirebaseAuth auth = FirebaseAuth.instance;

  late Razorpay razorpay;
  var stripePayService = StripeService();
  // var flutterWaveService = FlutterWaveService();

  // bool isNavigate = false;
  bool isMobileNumberValidate = false;

  //--------------------------------------
  int discountAmount = 0;
  double getFinalDiscount = 0;
  int cutDiscount = 0;
  int discountType = 0;

  //--------------------------------------
  String checkOtpLength = "";
  String otpCode = "";
  RxBool getCodeLoading = false.obs;

  @override
  void initState() {
    // TODO: implement initState
    editProfileController.mobileNumberController.text = "+91 ";
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getAllCartProductController.getCartProductData();
      getOnlySelectedUserAddressController.getOnlySelectedUserAddressData();
      if (getAllCartProductController.getAllCartProducts?.data != null) {
        createOrderByUserController.total = ((getAllCartProductController.getAllCartProducts!.data!.subTotal ?? 0).toInt() + (getAllCartProductController.getAllCartProducts!.data!.totalShippingCharges ?? 0).toInt());
      }
      razorpay = Razorpay();
      razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    });

    super.initState();
  }

  /// Razor Pay Success function ///
  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
/*
    Get.defaultDialog(
      barrierDismissible: false,
      backgroundColor: isDark.value ? const Color(0xff171725) : const Color(0xffffffff),
      title: "",
      content: Column(
        children: [
          const SizedBox(
              height: 120,
              width: 120,
              // color: Colors.deepPurple,
              child: Image(
                image: AssetImage('assets/icons/Group 162903.png'),
                fit: BoxFit.fill,
              )),
          SizedBox(
            height: Get.height / 30,
          ),
          Text(
            St.orderSuccessfully.tr,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(color: isDark.value ? AppColors.white : AppColors.black, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Text(
              St.orderSuccessfullySubtitle.tr,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 12, color: isDark.value ? AppColors.white : Colors.grey.shade600, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            height: Get.height / 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: PrimaryPinkButton(
                onTaped: () {
                  Get.offAllNamed("/BottomTabBar");
                },
                text: St.continueText.tr),
          )
        ],
      ),
    );
*/

    OrderConfirmDialogUi.onShow(
      callBack: () {
        Get.offAllNamed("/BottomTabBar");
        Get.toNamed("/MyOrder");
      },
    );

    createOrderByUserController.postOrderData(
      paymentGateway: getAllCartProductController.paymentSelect.value == 0 ? "Stripe" : "Razorpay",
      promoCode: getAllPromoCodeController.promoCodeController.text,
      finalTotal: createOrderByUserController.isPromoApplied == true
          ? createOrderByUserController.finalAmount.toInt()
          : ((getAllCartProductController.getAllCartProducts?.data!.subTotal ?? 0).toInt() + (getAllCartProductController.getAllCartProducts?.data!.totalShippingCharges ?? 0).toInt()),
      paymentStatus: 2,
    );
    // displayToast(message: "${St.success.tr}: ${response.paymentId!}");
  }

  /// Razor Pay error function ///
  void _handlePaymentError(PaymentFailureResponse response) {
    displayToast(message: "${response.code} - ${response.message}");
  }

  /// Razor Pay Wallet  function ///
  void _handleExternalWallet(ExternalWalletResponse response) {
    displayToast(message: "EXTERNAL_WALLET: ${response.walletName}");
  }

  /// Razor Pay ///
  void openCheckout(
    String amount,
  ) {
    /*   var options = {
      "key": razorPayKey,
      "amount": num.parse(amount) * 100,
      "currency": "USD",
      "name": "EraShop",
      "description": "EraShop Product",
       'theme.color': '#DEF213',
      'image': 'https://razorpay.com/assets/razorpay-glyph.svg',
    };*/
    var options = {
      'key': razorPayKey,
      'amount': num.parse(amount) * 100,
      'name': St.appName.tr,
      'theme.color': '#DEF213',
      'description': St.appNameProduct.tr,
      'image': 'https://razorpay.com/assets/razorpay-glyph.svg',
      'currency': "USD",
      'prefill': {'contact': "9966332255", 'email': "sdfdf@gmail.com"},
      'external': {
        'wallets': ["paytm"]
      }
    };
    try {
      razorpay.open(options);
    } catch (e) {
      log(e.toString());
    }
  }

  bool mobileVerified = false;
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    createOrderByUserController.total = ((getAllCartProductController.getAllCartProducts?.data!.subTotal ?? 0).toInt() + (getAllCartProductController.getAllCartProducts?.data!.totalShippingCharges ?? 0).toInt());
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.black,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: AppColors.transparent,
              shadowColor: AppColors.black.withValues(alpha: 0.4),
              flexibleSpace: SimpleAppBarWidget(title: St.checkOut.tr),
            ),
          ),
          body: SafeArea(
              child: SizedBox(
            height: Get.height,
            width: Get.width,
            child: Obx(
              () => getOnlySelectedUserAddressController.isLoading.value
                  ? Shimmers.checkoutShimmer()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            15.height,
                            GestureDetector(
                              onTap: () {
                                Get.toNamed("/UserAddress")?.then((value) {
                                  getOnlySelectedUserAddressController.getOnlySelectedUserAddressData();
                                });
                              },
                              child: Container(
                                width: Get.width,
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: AppColors.tabBackground),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(AppAsset.icLocation, color: AppColors.primary, width: 12),
                                        10.width,
                                        Text(
                                          St.deliveryLocation.tr,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: AppFontStyle.styleW700(AppColors.primary, 14),
                                        ),
                                        const Spacer(),
                                        Image.asset(AppAsset.icCircleArrowRight, color: AppColors.white, width: 20),
                                      ],
                                    ),
                                    15.height,
                                    DottedLine(dashColor: AppColors.unselected.withValues(alpha: 0.3)),
                                    15.height,
                                    getOnlySelectedUserAddressController.userAddressSelect?.address == null
                                        ? Offstage()
                                        : Text(
                                            getOnlySelectedUserAddressController.userAddressSelect?.address?.name ?? "",
                                            style: AppFontStyle.styleW700(AppColors.white, 16),
                                          ),
                                    5.height,
                                    getOnlySelectedUserAddressController.userAddressSelect?.address == null
                                        ? Text(
                                            St.pleaseSelectAddress.tr,
                                            style: AppFontStyle.styleW500(AppColors.unselected, 12),
                                          )
                                        : Text(
                                            _buildAddressString(),
                                            style: AppFontStyle.styleW500(AppColors.unselected, 12),
                                          ),
                                  ],
                                ),
                              ),
                            ),

                            // SmallTitle(title: St.deliveryLocation.tr),
                            // InkWell(
                            //   onTap: () => Get.toNamed("/UserAddress")?.then((value) {
                            //     getOnlySelectedUserAddressController.getOnlySelectedUserAddressData();
                            //   }),
                            //   child: Padding(
                            //     padding: const EdgeInsets.symmetric(vertical: 20),
                            //     child: SizedBox(
                            //       height: 63,
                            //       width: double.maxFinite,
                            //       child: Stack(
                            //         children: [
                            //           getOnlySelectedUserAddressController.userAddressSelect?.address == null
                            //               ? Align(alignment: Alignment.centerLeft, child: Text(St.pleaseSelectAddress.tr))
                            //               : Column(
                            //                   crossAxisAlignment: CrossAxisAlignment.start,
                            //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //                   children: [
                            //                     Text(
                            //                       "${getOnlySelectedUserAddressController.userAddressSelect!.address!.name}",
                            //                       style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w500),
                            //                     ),
                            //                     SizedBox(
                            //                       width: Get.width / 1.5,
                            //                       child: Text(
                            //                         "${getOnlySelectedUserAddressController.addressDetails!.address}, ${getOnlySelectedUserAddressController.addressDetails.city}, ${getOnlySelectedUserAddressController.addressDetails.state}, ${getOnlySelectedUserAddressController.addressDetails.country}, ${getOnlySelectedUserAddressController.addressDetails.zipCode}",
                            //                         style: GoogleFonts.plusJakartaSans(
                            //                             color: isDark.value ? AppColors.white : AppColors.darkGrey, fontSize: 13, fontWeight: FontWeight.w500),
                            //                       ),
                            //                     ),
                            //                   ],
                            //                 ),
                            //           Align(
                            //             alignment: Alignment.centerRight,
                            //             child: Padding(
                            //               padding: const EdgeInsets.only(right: 20),
                            //               child: GestureDetector(
                            //                 onTap: () {
                            //                   Get.toNamed("/UserAddress");
                            //                 },
                            //                 child: Image(
                            //                   image: const AssetImage("assets/icons/Arrow---Right-Circle.png"),
                            //                   height: 20,
                            //                   color: AppColors.lightGrey,
                            //                 ),
                            //               ),
                            //             ),
                            //           )
                            //         ],
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // mobileNumber.isEmpty && isDemoSeller == false
                            //     ? Column(
                            //         crossAxisAlignment: CrossAxisAlignment.start,
                            //         children: [
                            //           Padding(
                            //             padding: const EdgeInsets.symmetric(vertical: 10),
                            //             child: SmallTitle(title: St.mobileNumberVerification.tr),
                            //           ),
                            //           Padding(
                            //             padding: const EdgeInsets.only(top: 5, bottom: 10),
                            //             child: SizedBox(
                            //               height: 60,
                            //               child: TextFormField(
                            //                 controller: editProfileController.mobileNumberController,
                            //                 maxLength: 15,
                            //                 keyboardType: TextInputType.phone,
                            //                 style: GoogleFonts.plusJakartaSans(
                            //                   color: isDark.value ? AppColors.white : AppColors.black,
                            //                 ),
                            //                 decoration: InputDecoration(
                            //                   counterText: "",
                            //                   filled: true,
                            //                   fillColor: isDark.value ? AppColors.lightBlack : Colors.transparent,
                            //                   prefixIcon: GestureDetector(
                            //                     onTap: () {
                            //                       showCountryPicker(
                            //                         context: context,
                            //                         exclude: <String>['KN', 'MF'],
                            //                         favorite: <String>['SE'],
                            //                         showPhoneCode: true,
                            //                         onSelect: (Country country) {
                            //                           setState(() {
                            //                             imoges = country.flagEmoji;
                            //                             editProfileController.mobileNumberController.text = "+${country.phoneCode} ";
                            //                             // sellerController.countryCode = country.phoneCode;
                            //                           });
                            //                         },
                            //                         countryListTheme: CountryListThemeData(
                            //                           borderRadius: const BorderRadius.only(
                            //                             topLeft: Radius.circular(40.0),
                            //                             topRight: Radius.circular(40.0),
                            //                           ),
                            //                           inputDecoration: InputDecoration(
                            //                             hintText: St.searchText.tr,
                            //                             prefixIcon: const Icon(Icons.search),
                            //                             border: OutlineInputBorder(
                            //                               borderSide: BorderSide(
                            //                                 color: const Color(0xFF8C98A8).withValues(alpha:0.2),
                            //                               ),
                            //                             ),
                            //                           ),
                            //                           // Optional. Styles the text in the search field
                            //                           searchTextStyle: const TextStyle(
                            //                             color: Colors.blue,
                            //                             fontSize: 18,
                            //                           ),
                            //                         ),
                            //                       );
                            //                     },
                            //                     child: SizedBox(
                            //                       height: 58,
                            //                       width: 75,
                            //                       child: Row(
                            //                         children: [
                            //                           const SizedBox(
                            //                             width: 15,
                            //                           ),
                            //                           imoges == null ? const Text("🇮🇳", style: TextStyle(fontSize: 25)) : Text(imoges, style: const TextStyle(fontSize: 25)),
                            //                           Icon(
                            //                             Icons.keyboard_arrow_down_sharp,
                            //                             color: Colors.grey.shade400,
                            //                           ),
                            //                         ],
                            //                       ),
                            //                     ),
                            //                   ),
                            //                   suffix: GestureDetector(
                            //                     onTap: () async {
                            //                       if (editProfileController.mobileNumberController.text.isBlank == true ||
                            //                           editProfileController.mobileNumberController.text.length < 10) {
                            //                         displayToast(message: "Invalid mobile number");
                            //                       } else {
                            //                         getCodeLoading(true);
                            //                         await FirebaseAuth.instance.verifyPhoneNumber(
                            //                           phoneNumber: editProfileController.mobileNumberController.text,
                            //                           verificationCompleted: (PhoneAuthCredential credential) async {
                            //                             displayToast(message: "Verification complete");
                            //                             getCodeLoading(false);
                            //                           },
                            //                           verificationFailed: (FirebaseAuthException e) {
                            //                             displayToast(message: "Mobile verification failed");
                            //                             getCodeLoading(false);
                            //                           },
                            //                           codeSent: (String verificationId, int? resendToken) {
                            //                             setState(() {
                            //                               otpVerificationId = verificationId;
                            //                               isMobileNumberValidate = true;
                            //                             });
                            //                             displayToast(message: "We sent code on\nyour mobile!");
                            //                             getCodeLoading(false);
                            //                           },
                            //                           codeAutoRetrievalTimeout: (String verificationId) {},
                            //                         );
                            //                       }
                            //                     },
                            //                     child: SizedBox(
                            //                       height: 25,
                            //                       child: Obx(
                            //                         () => getCodeLoading.value
                            //                             ? const CupertinoActivityIndicator()
                            //                             : Text(
                            //                                 St.getCode.tr,
                            //                                 style: GoogleFonts.plusJakartaSans(color: AppColors.primaryPink, fontWeight: FontWeight.w500),
                            //                               ),
                            //                       ),
                            //                     ),
                            //                   ),
                            //                   hintText: St.enterMobileNo.tr,
                            //                   hintStyle: TextStyle(color: Colors.grey.shade400),
                            //                   enabledBorder: OutlineInputBorder(
                            //                       borderSide: isDark.value ? BorderSide(color: Colors.grey.shade800) : BorderSide(color: AppColors.darkGrey.withValues(alpha:0.40)),
                            //                       borderRadius: BorderRadius.circular(10)),
                            //                   border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryPink), borderRadius: BorderRadius.circular(10)),
                            //                 ),
                            //               ),
                            //             ),
                            //           ),
                            //           isMobileNumberValidate == true
                            //               ? Row(
                            //                   children: [
                            //                     SizedBox(
                            //                       height: 60,
                            //                       width: 130,
                            //                       child: TextFormField(
                            //                         focusNode: focusNode,
                            //                         onChanged: (value) {
                            //                           setState(() {
                            //                             otpCode = value;
                            //                             checkOtpLength = value;
                            //                             checkOtpLength.length >= 6 ? focusNode.unfocus() : null;
                            //                           });
                            //                         },
                            //                         maxLength: 6,
                            //                         textAlign: TextAlign.center,
                            //                         textAlignVertical: TextAlignVertical.center,
                            //                         keyboardType: TextInputType.number,
                            //                         style: GoogleFonts.plusJakartaSans(
                            //                           letterSpacing: 5,
                            //                           color: isDark.value ? AppColors.white : AppColors.black,
                            //                         ),
                            //                         decoration: InputDecoration(
                            //                           counterText: "",
                            //                           filled: true,
                            //                           fillColor: isDark.value ? AppColors.lightBlack : Colors.transparent,
                            //                           hintText: "000000",
                            //                           hintStyle: TextStyle(color: Colors.grey.shade400, letterSpacing: 5),
                            //                           enabledBorder: OutlineInputBorder(
                            //                               borderSide:
                            //                                   isDark.value ? BorderSide(color: Colors.grey.shade800) : BorderSide(color: AppColors.darkGrey.withValues(alpha:0.40)),
                            //                               borderRadius: BorderRadius.circular(10)),
                            //                           border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryPink), borderRadius: BorderRadius.circular(10)),
                            //                         ),
                            //                       ),
                            //                     ),
                            //                     checkOtpLength.length >= 6
                            //                         ? TextButton(
                            //                             onPressed: () async {
                            //                               try {
                            //                                 PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: otpVerificationId, smsCode: otpCode);
                            //                                 await auth.signInWithCredential(credential);
                            //                                 setState(() {
                            //                                   mobileVerified = true;
                            //                                 });
                            //                                 editProfileController.editDataStorage();
                            //                               } catch (e) {
                            //                                 log("verify OTP Error:: $e");
                            //                                 displayToast(message: St.invalidOTP.tr);
                            //                               }
                            //                             },
                            //                             child: mobileVerified
                            //                                 ? Icon(
                            //                                     Icons.done_rounded,
                            //                                     color: AppColors.primaryGreen,
                            //                                   )
                            //                                 : Text(
                            //                                     St.done.tr,
                            //                                     style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: AppColors.primaryPink),
                            //                                   ))
                            //                         : TextButton(
                            //                             onPressed: () async {
                            //                               await FirebaseAuth.instance.verifyPhoneNumber(
                            //                                 phoneNumber: "+91 ${editProfileController.mobileNumberController.text}",
                            //                                 verificationCompleted: (PhoneAuthCredential credential) async {
                            //                                   displayToast(message: St.verificationComplete.tr);
                            //                                 },
                            //                                 verificationFailed: (FirebaseAuthException e) {
                            //                                   displayToast(message: St.mobileVerificationFailed.tr);
                            //                                 },
                            //                                 codeSent: (String verificationId, int? resendToken) {
                            //                                   setState(() {
                            //                                     isMobileNumberValidate = true;
                            //                                   });
                            //                                   displayToast(message: St.weSentCodeOnYourMobile.tr);
                            //                                 },
                            //                                 codeAutoRetrievalTimeout: (String verificationId) {},
                            //                               );
                            //                             },
                            //                             child: Text(
                            //                               St.resendCodeText.tr,
                            //                               style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: AppColors.primaryPink),
                            //                             ))
                            //                   ],
                            //                 )
                            //               : const SizedBox(),
                            //         ],
                            //       )
                            //     : const SizedBox(),

                            20.height,
                            Text(
                              St.orderInfo.tr,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: AppFontStyle.styleW700(AppColors.white, 18),
                            ),
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: getAllCartProductController.getAllCartProducts?.data!.items!.length,
                              itemBuilder: (context, index) {
                                int? productQuantity = getAllCartProductController.getAllCartProducts?.data!.items![index].productQuantity;
                                int? purchasedTimeProductPrice = getAllCartProductController.getAllCartProducts?.data!.items![index].purchasedTimeProductPrice?.toInt();
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "${getAllCartProductController.getAllCartProducts?.data!.items![index].productId?.productName} x $productQuantity",
                                          style: AppFontStyle.styleW700(AppColors.primary, 11),
                                        ),
                                      ),
                                      Text(
                                        "$currencySymbol${(productQuantity)! * (purchasedTimeProductPrice!.toInt())}",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: AppFontStyle.styleW700(AppColors.white, 14),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),

                            GestureDetector(
                              onTap: () {
                                getAllPromoCodeController.getAllPromoCodes();
                                promoCodeBottomSheet();
                              },
                              child: Container(
                                height: 58,
                                width: Get.width,
                                decoration: BoxDecoration(
                                  color: AppColors.transparent,
                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        // onTap: promoCodeBottomSheet,
                                        readOnly: true,
                                        controller: getAllPromoCodeController.promoCodeController,
                                        style: GoogleFonts.plusJakartaSans(
                                          color: AppColors.white,
                                        ),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: AppColors.tabBackground,
                                          suffixStyle: GoogleFonts.plusJakartaSans(color: AppColors.primaryPink, fontWeight: FontWeight.w500),
                                          hintText: St.applyPromoCode.tr,
                                          hintStyle: TextStyle(color: Colors.grey.shade400),
                                          enabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              bottomLeft: Radius.circular(15),
                                            ),
                                          ),
                                          border: const OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              bottomLeft: Radius.circular(15),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 53,
                                      width: 80,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(15),
                                          bottomRight: Radius.circular(15),
                                        ),
                                      ),
                                      child: Text(
                                        "ADD",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: AppFontStyle.styleW700(AppColors.black, 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            20.height,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(St.subTotal.tr, style: AppFontStyle.styleW500(AppColors.unselected, 14)),
                                Text("$currencySymbol${getAllCartProductController.getAllCartProducts?.data?.subTotal}", style: AppFontStyle.styleW700(AppColors.white, 14)),
                              ],
                            ),
                            if (userApplyPromoCheckController.userApplyPromoCheck?.status == true) ...[
                              10.height,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(St.discount.tr, style: AppFontStyle.styleW500(AppColors.unselected, 14)),
                                  if (discountType == 1)
                                    Text(
                                      "-$currencySymbol${getFinalDiscount.floor()} ($discountAmount%)",
                                      style: AppFontStyle.styleW500(AppColors.unselected, 14),
                                    ),
                                  if (discountType == 0)
                                    Text(
                                      // "-$currencySymbol$getFinalDiscount",
                                      "-$currencySymbol${discountAmount.toStringAsFixed(2)}",
                                      style: AppFontStyle.styleW500(AppColors.unselected, 14),
                                    ),
                                ],
                              ),
                            ],
                            10.height,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(St.shippingCharge.tr, style: AppFontStyle.styleW500(AppColors.unselected, 14)),
                                Text("$currencySymbol${getAllCartProductController.getAllCartProducts?.data!.totalShippingCharges}", style: AppFontStyle.styleW700(AppColors.primary, 14)),
                              ],
                            ),
                            15.height,
                            DottedLine(dashColor: AppColors.unselected.withValues(alpha: 0.3)),
                            15.height,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(St.total.tr, style: AppFontStyle.styleW500(AppColors.unselected, 14)),
                                userApplyPromoCheckController.userApplyPromoCheck?.status == true
                                    ? Text("$currencySymbol${createOrderByUserController.finalAmount}", style: AppFontStyle.styleW700(AppColors.primary, 14))
                                    : Text(
                                        "$currencySymbol${createOrderByUserController.total}",
                                        style: AppFontStyle.styleW700(AppColors.primary, 14),
                                      )
                              ],
                            ),
                            20.height,
                          ],
                        ),
                      ),
                    ),
            ),
          )),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(15),
            child: Obx(() {
              bool isLoading = getOnlySelectedUserAddressController.isLoading.value;
              bool isAddressSelected = getOnlySelectedUserAddressController.userAddressSelect?.address != null;
              bool isButtonEnabled = !isLoading && isAddressSelected;
              return MainButtonWidget(
                height: 60,
                width: Get.width,
                color: isButtonEnabled ? AppColors.primary : AppColors.tabBackground,
                callback: isButtonEnabled
                    ? () async {
                        log("Final amount :: ${createOrderByUserController.finalAmount}");
                        log("Final total :: ${createOrderByUserController.total}");
                        log("Final total :: ${createOrderByUserController.isPromoApplied}");

                        log("index:paymentSelect${getAllCartProductController.paymentSelect.value}");
                        log("index  promoCodeController:${getAllPromoCodeController.promoCodeController.text}");
                        log("index:  isPromoApplied${createOrderByUserController.isPromoApplied}");
                        log("index:  selectedPromoCodeId${getAllPromoCodeController.selectedPromoCodeId}");
                        log("index:  Final${(getAllCartProductController.getAllCartProducts?.data!.subTotal ?? 0).toInt() + (getAllCartProductController.getAllCartProducts?.data!.totalShippingCharges ?? 0).toInt()}");

                        num finalTotal = createOrderByUserController.isPromoApplied == true
                            ? createOrderByUserController.finalAmount.toInt()
                            : ((getAllCartProductController.getAllCartProducts?.data!.subTotal ?? 0).toInt() + (getAllCartProductController.getAllCartProducts?.data!.totalShippingCharges ?? 0).toInt());

                        Get.toNamed(
                          "/PaymentPage",
                          arguments: {
                            "finalTotal": finalTotal,
                            "promoCode": getAllPromoCodeController.promoCodeController.text,
                            "selectedPromoCodeId": getAllPromoCodeController.selectedPromoCodeId,
                            "isAuctionPayment": false,
                          },
                        );
                      }
                    : () {
                        if (!isLoading && !isAddressSelected) {
                          Fluttertoast.showToast(
                            msg: "Please select address",
                            backgroundColor: AppColors.grayLight,
                            textColor: AppColors.white,
                            gravity: ToastGravity.BOTTOM,
                          );
                        }
                      },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      St.continueText.tr,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: AppFontStyle.styleW700(isButtonEnabled ? AppColors.black : AppColors.unselected, 15),
                    ),
                    8.width,
                    Image.asset(AppAsset.icDoubleArrowRight, color: isButtonEnabled ? AppColors.black : AppColors.unselected, width: 14),
                  ],
                ),
              );
            }),
          ),
        ),
        // Obx(() => createOrderByUserController.isLoading.value || stripePayService.isStripeLoading.value || flutterWaveService.isFlutterWaveLoading.value ? ScreenCircular.blackScreenCircular() : const SizedBox.shrink())
      ],
    );
  }

  String _buildAddressString() {
    final addr = getOnlySelectedUserAddressController.addressDetails;
    final parts = [
      addr?.address,
      if (addr?.city?.isNotEmpty ?? false) addr?.city,
      if (addr?.state?.isNotEmpty ?? false) addr?.state,
      addr?.country,
      if (addr?.zipCode != null) addr!.zipCode.toString(),
    ].where((element) => element != null && element.isNotEmpty).toList();

    return parts.join(', ');
  }

  Future<dynamic> promoCodeBottomSheet() {
    return Get.bottomSheet(
        isScrollControlled: true,
        elevation: 10,
        Container(
          height: Get.height / 1.7,
          decoration: BoxDecoration(color: AppColors.background, borderRadius: const BorderRadius.vertical(top: Radius.circular(25))),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: Get.height / 1.9,
                  width: double.maxFinite,
                  child: Obx(
                    () => getAllPromoCodeController.isLoading.value
                        ? Shimmers.applyPromoCodeShimmer()
                        : getAllPromoCodeController.getAllPromoCode?.promoCode?.isEmpty ?? false
                            ? noDataFound(
                                image: "assets/no_data_found/basket.png",
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.only(top: 45),
                                scrollDirection: Axis.vertical,
                                physics: const BouncingScrollPhysics(),
                                itemCount: getAllPromoCodeController.getAllPromoCode?.promoCode?.length,
                                itemBuilder: (context, index) {
                                  final totalCartProducts = getAllCartProductController.getAllCartProducts?.data?.subTotal?.toInt();
                                  final minOrderValue = getAllPromoCodeController.getAllPromoCode?.promoCode?[index].minOrderValue?.toInt();
                                  return Container(
                                    width: Get.width,
                                    decoration: BoxDecoration(color: AppColors.tabBackground, borderRadius: const BorderRadius.all(Radius.circular(12))),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 52,
                                          width: 52,
                                          decoration: BoxDecoration(shape: BoxShape.circle, color: isDark.value ? AppColors.white.withValues(alpha: 0.40) : AppColors.grayLight),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: totalCartProducts! >= minOrderValue!
                                                ? getAllPromoCodeController.getAllPromoCode!.promoCode![index].discountType == 1
                                                    ? Image.asset(
                                                        "assets/icons/Frame.png",
                                                        color: AppColors.primaryPink,
                                                      )
                                                    : Image.asset(
                                                        "assets/icons/promo.png",
                                                        color: AppColors.primaryPink,
                                                      )
                                                : getAllPromoCodeController.getAllPromoCode!.promoCode![index].discountType == 1
                                                    ? Image.asset(
                                                        "assets/icons/Frame.png",
                                                        color: AppColors.mediumGrey,
                                                      )
                                                    : Image.asset("assets/icons/promo.png", color: AppColors.mediumGrey),
                                          ),
                                        ).paddingAll(12),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              getAllPromoCodeController.getAllPromoCode!.promoCode![index].promoCode.toString(),
                                              style: AppFontStyle.styleW700(AppColors.white, 11),
                                            ).paddingOnly(top: 12, bottom: 5),
                                            SizedBox(
                                              width: Get.width / 2.1,
                                              child: Text(
                                                getAllPromoCodeController.getAllPromoCode!.promoCode![index].discountType == 1
                                                    ? "${St.applyThisPromoAndGet.tr} ${getAllPromoCodeController.getAllPromoCode!.promoCode![index].discountAmount}% Discount."
                                                    : "${St.applyThisPromoAndGet.tr} $currencySymbol${getAllPromoCodeController.getAllPromoCode!.promoCode![index].discountAmount} Discount.",
                                                style: AppFontStyle.styleW700(AppColors.unselected, 12),
                                              ),
                                            ).paddingOnly(bottom: 16),
                                          ],
                                        ),
                                        const Spacer(),
                                        totalCartProducts >= minOrderValue
                                            ? GestureDetector(
                                                onTap: () async {
                                                  await userApplyPromoCheckController.getDataUserApplyPromoOrNot(promocodeId: getAllPromoCodeController.getAllPromoCode!.promoCode![index].id.toString());

                                                  if (userApplyPromoCheckController.userApplyPromoCheck?.status == true) {
                                                    var getPromoCode = getAllPromoCodeController.getAllPromoCode!.promoCode![index];

                                                    discountType = getPromoCode.discountType!.toInt();
                                                    discountAmount = getPromoCode.discountAmount!.toInt();
                                                    getAllPromoCodeController.promoCodeController.text = getPromoCode.promoCode.toString();
                                                    getAllPromoCodeController.selectedPromoCodeId = getPromoCode.id.toString();

                                                    //----------------------------------------------------
                                                    log("discount type 0 :: discountAmount: ${getPromoCode.discountAmount!}--type $discountType");
                                                    setState(() {
                                                      if (discountType == 0) {
                                                        final discount = ((getAllCartProductController.getAllCartProducts?.data?.subTotal!.toDouble())! - discountAmount.toDouble());

                                                        //-------------------------
                                                        log("discount type 0 :: discount $discount");
                                                        log("discount type 0 :: discountAmount: $discountAmount");
                                                        cutDiscount = discount.toInt();

                                                        /* getFinalDiscount =
                                                                                    ((getAllCartProductController
                                                                                            .getAllCartProducts
                                                                                            ?.data
                                                                                            ?.subTotal!
                                                                                            .toDouble())! -
                                                                                        discount.toDouble());*/
                                                      } else {
                                                        // getFinalDiscount =
                                                        //     ((getAllCartProductController
                                                        //             .getAllCartProducts
                                                        //             ?.data
                                                        //             ?.total!
                                                        //             .toDouble())! /
                                                        //         discountAmount
                                                        //             .toDouble());
                                                        /* getFinalDiscount = (discountAmount / 100) *
                                                                                    (getAllCartProductController
                                                                                        .getAllCartProducts!.data!.total!
                                                                                        .toDouble());*/
                                                        getFinalDiscount = (discountAmount / 100) * (getAllCartProductController.getAllCartProducts!.data!.subTotal!.toDouble());

                                                        cutDiscount = getAllCartProductController.getAllCartProducts!.data!.subTotal!.toInt() - getFinalDiscount.floor();

                                                        log("discount type 1 :: getFinalDiscount $getFinalDiscount");
                                                        log("discount type 1 :: discountAmount $discountAmount");
                                                      }
                                                    });
                                                    createOrderByUserController.isPromoApplied = true;
                                                    createOrderByUserController.finalAmount = (cutDiscount + (getAllCartProductController.getAllCartProducts?.data!.totalShippingCharges ?? 0)).toInt();
                                                    log('PLUS :: $cutDiscount == ${getAllCartProductController.getAllCartProducts?.data!.totalShippingCharges}');
                                                    log("finalAmount>>>>>>${createOrderByUserController.finalAmount}");
                                                    /*  createOrderByUserController.finalAmount =
                                                                                ((getAllCartProductController
                                                                                        .getAllCartProducts?.data?.total!
                                                                                        .toDouble())! -
                                                                                    getFinalDiscount.toDouble());*/

                                                    Get.back();
                                                  } else {
                                                    displayToast(message: St.youAreNotAbleToUseThisPromoCode.tr);
                                                    Get.back();
                                                  }
                                                },
                                                child: Container(
                                                  height: 36,
                                                  width: 80,
                                                  margin: EdgeInsets.only(right: 12),
                                                  decoration: BoxDecoration(color: AppColors.primaryPink, borderRadius: BorderRadius.circular(50)),
                                                  child: Center(
                                                    child: Text(St.apply.tr, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.black)),
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                height: 36,
                                                width: 80,
                                                decoration: BoxDecoration(color: AppColors.mediumGrey, borderRadius: BorderRadius.circular(50)),
                                                child: Center(
                                                  child: Text(St.apply.tr, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.white)),
                                                ),
                                              ).paddingOnly(top: 12, right: 13),
                                      ],
                                    ),
                                  ).paddingOnly(bottom: 10, left: 13, right: 13);
                                },
                              ),
                  ),
                ),
              ),
              Container(
                height: 80,
                width: Get.width,
                decoration: BoxDecoration(color: AppColors.tabBackground, borderRadius: const BorderRadius.vertical(top: Radius.circular(25))),
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        St.applyPromoCode.tr,
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.primaryPink,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: CircleAvatar(
                            backgroundColor: AppColors.grayLight,
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Obx(
                () => userApplyPromoCheckController.isLoading.value
                    ? Container(
                        width: Get.width,
                        decoration: BoxDecoration(color: AppColors.background.withValues(alpha: 0.50), borderRadius: const BorderRadius.vertical(top: Radius.circular(25))),
                        child: Center(
                            child: CircularProgressIndicator(
                          color: AppColors.primary,
                        )),
                      )
                    : const SizedBox(),
              ),
            ],
          ),
        ));
  }
}

// Discount Types
// 0.flat 1.percentage

class OrderConfirmDialogUi {
  static Future<void> onShow({required Callback callBack}) async {
    Get.dialog(
      barrierDismissible: false,
      barrierColor: AppColors.black.withValues(alpha: 0.9),
      Dialog(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        child: Container(
          // height: 450,
          width: 310,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(45),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 170,
                  width: 310,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.green,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(45),
                      topLeft: Radius.circular(45),
                    ),
                  ),
                  child: Image.asset(AppAsset.imgSuccessOrder, width: 140),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      10.height,
                      Text(
                        St.orderConformation.tr,
                        style: AppFontStyle.styleW700(AppColors.green, 14),
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        St.successfully.tr,
                        style: AppFontStyle.styleW900(AppColors.green, 26),
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        St.itIsLongEstablished.tr,
                        style: AppFontStyle.styleW500(AppColors.unselected, 12),
                      ),
                      20.height,
                      GestureDetector(
                        onTap: callBack,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: AppColors.green,
                          ),
                          height: 52,
                          width: Get.width,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(St.viewOrderDetails.tr, style: AppFontStyle.styleW700(AppColors.white, 16)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      10.height,
                      GestureDetector(
                        onTap: () {
                          // Get.back();
                          Get.offAllNamed("/BottomTabBar");
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: AppColors.unselected.withValues(alpha: 0.2),
                          ),
                          height: 52,
                          width: Get.width,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(St.goToHomePage.tr, style: AppFontStyle.styleW700(AppColors.unselected, 16)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      16.height,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

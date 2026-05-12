// ignore_for_file: library_prefixes

import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:get/get.dart';

String loginUserId = "";
String sellerId = "";
String fcmToken = "";
String identify = "";
String productId = "";
String addressId = "";
String mobileNumber = "";
//-----------------------------
var isDark = false.obs;
//------------------------------
File? imageXFile;
File? sellerImageXFile;
bool? isSeller;
bool? isSellerRequestSand;
bool firstTimeCheckSeller = false;

///------- Edit Profile ------------\\\

String editImage = "";
String editFirstName = "";
String editLastName = "";
String editEmail = "";
String editDateOfBirth = "";
String genderSelect = "Male";
String editLocation = "";
String editUserCountry = "";
String editUserAddress = "";
String uniqueID = "";

///------- Seller Edits ------------\\\

bool isDemoSeller = false;
String sellerFollower = "";
String sellerEditImage = "";
String editBusinessName = "";
String editPhoneNumber = "";
String editBusinessTag = "";
String editSellerAddress = "";
String editLandmark = "";
String editCity = "";
String editPinCode = "";
String editState = "";
String editCountry = "";
String editBankBusinessName = "";
String editBankName = "";
// Mobile-money payout details (replaces editAccNumber/editIfsc/editBranch).
// networkName is one of: MTN, Vodafone, AirtelTigo (or empty).
String editMomoNumber = "";
String editNetworkName = "";
String editMomoName = "";

///------- Setting Api Data ------------\\\

bool? isUpdateProductRequest;
int? cancelOrderCharges;

/// ====== Ai Key ======== \\\

String openAiKey = '';

/// ====== StripePey ======== \\\

bool stripActive = true;
String stripPublishableKey = '';
String stripeTestSecretKey = '';
const String stripeUrl = "https://api.stripe.com/v1/payment_intents";

/// ====== RazorPay ======= \\\
String razorPayKey = "";
String flutterWaveId = "";
bool isShowRazorPayPaymentMethod = false;
bool isShowStripePaymentMethod = false;
bool isShowFlutterWavePaymentMethod = false;
bool isShowCashOnDelivery = false;

/// ====== Paystack ======== \\\
String paystackPublicKey = "";
String paystackSecretKey = "";
bool isShowPaystackPaymentMethod = false;
int minPayout = 0;
int paymentReminderForLiveAuction = 0;
int paymentReminderForManualAuction = 0;
int paymentRe = 0;

/// =========== Verification ==========

bool isAddressProofActive = false;
bool isAddressProofRequired = false;
bool isGovIdActive = false;
bool isGovIdRequired = false;
bool isRegistrationCertActive = false;
bool isRegistrationCertRequired = false;
// Selfie verification (admin-issued blue tick). Mirrors the
// settingJSON.selfieVerification block. Reactive so the Profile tab's
// "Verify your account" row appears the moment /setting hydrates the
// flag — it's set both on splash (storageData) and on every
// BottomTabBar mount (settingApiCall), and the Profile tab is kept
// alive in the bottom-bar PageView, so a non-reactive bool that was
// read as `false` before /setting landed would stay hidden for the
// whole session.
RxBool isSelfieVerificationActive = false.obs;
bool isSelfieVerificationRequired = false;
// Latest known selfie verification status for the logged-in user
// ("none" / "pending_review" / "verified" / "rejected"). Captured
// from the WhoLoginApi profile after login + cached for badge reads
// across the app. Refresh by calling /verification/myStatus.
RxString verificationStatus = "none".obs;

String termsAndConditionsLink = '';
String privacyPolicyLink = '';

/// =========== Socket Manger ==========
IO.Socket? socket;

/// =========== Firebase Notification ==========
RxBool notificationVisit = false.obs;
FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

String? countryCode;
String? country;
String? dialCode;

String? currencySymbol;
String? currencyCode;

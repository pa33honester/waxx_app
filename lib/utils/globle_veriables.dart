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
String editAccNumber = "";
String editIfsc = "";
String editBranch = "";

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

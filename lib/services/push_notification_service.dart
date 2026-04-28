import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:waxxapp/ApiService/login/profile_edit_service.dart';
import 'package:waxxapp/View/MyApp/AppPages/dialog/payment_dialog.dart';
import 'package:waxxapp/services/app_link_service.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/database.dart';
import 'package:waxxapp/utils/globle_veriables.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log('FCM background message received: ${message.messageId}');
}

class PushNotificationService {
  PushNotificationService._();

  static final PushNotificationService instance = PushNotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  StreamSubscription<String>? _tokenRefreshSubscription;
  bool _isInitialized = false;
  bool _interactionHandlersRegistered = false;

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'waxxapp_high_importance',
    'Waxxapp Notifications',
    description: 'High priority notifications for Waxxapp',
    importance: Importance.max,
  );

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    await _initializeLocalNotifications();
    await _requestPermission();
    await _configureForegroundPresentation();

    final token = await _messaging.getToken();
    await _storeToken(token);

    _tokenRefreshSubscription ??= _messaging.onTokenRefresh.listen((token) async {
      log('FCM token refreshed');
      await _storeToken(token);
      await syncTokenToBackendIfPossible();
    });

    flutterLocalNotificationsPlugin = _localNotifications;
    _isInitialized = true;
  }

  Future<void> registerInteractionHandlers() async {
    if (_interactionHandlersRegistered) {
      return;
    }

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      await handleRemoteMessage(initialMessage, fromTap: true);
    }

    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      await handleRemoteMessage(message, fromTap: true);
    });

    FirebaseMessaging.onMessage.listen((message) async {
      log('FCM foreground message received: ${message.messageId}');
      await showForegroundNotification(message);
    });

    _interactionHandlersRegistered = true;
  }

  // [fromTap] is true when the user actively tapped a notification
  // (cold-start `getInitialMessage`, warm `onMessageOpenedApp`, or a tap on
  // the in-app local notification surfaced via flutter_local_notifications).
  // For tap-driven invocations LIVE_STARTED routes straight to the
  // broadcast — showing a snackbar that asks the user to tap again would
  // be a worse experience for someone who already tapped.
  Future<void> handleRemoteMessage(RemoteMessage message, {bool fromTap = false}) async {
    if (message.data.isEmpty) {
      return;
    }

    notificationVisit.value = !notificationVisit.value;

    final type = message.data['type'];

    if (type == 'AUCTION_SUCCESS') {
      final attributes = _decodeProductAttributes(message.data['productAttributes']);
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      Get.dialog(
        barrierColor: AppColors.black.withValues(alpha: 0.8),
        CongratulationsPaymentDialog(
          productName: message.data['productName'],
          orderId: message.data['orderId'],
          productId: message.data['productId'],
          amount: (message.data['amount'] ?? '').toString(),
          mainImage: message.data['mainImage'],
          shippingCharges: (message.data['shippingCharges'] ?? '').toString(),
          reminderMinutes: message.data['reminderMinutes'],
          productAttributes: attributes,
        ),
        barrierDismissible: true,
      );
    } else if (type == 'OUTBID') {
      final pId = message.data['productId'];
      final newBid = message.data['newBidAmount'];
      final productName = message.data['productName'] ?? 'item';
      Get.snackbar(
        'You\'ve been outbid!',
        'Someone bid $newBid on $productName. Tap to bid again.',
        backgroundColor: AppColors.tabBackground,
        colorText: AppColors.white,
        icon: Icon(Icons.gavel_rounded, color: AppColors.primary),
        duration: const Duration(seconds: 5),
        onTap: (_) {
          if (pId != null) {
            productId = pId;
            Get.toNamed('/ProductDetail');
          }
        },
      );
    } else if (type == 'PRODUCT_LIKED') {
      final userName = message.data['userName'] ?? 'Someone';
      final productName = message.data['productName'] ?? 'your product';
      final pId = message.data['productId'];
      Get.snackbar(
        '$userName liked $productName',
        'Tap to view the product',
        backgroundColor: AppColors.tabBackground,
        colorText: AppColors.white,
        icon: const Icon(Icons.favorite_rounded, color: Colors.red),
        duration: const Duration(seconds: 5),
        onTap: (_) {
          if (pId != null) {
            productId = pId;
            Get.toNamed('/SellerProductDetails');
          }
        },
      );
    } else if (type == 'LIVE_STARTED' || type == 'LIVE') {
      final sellerName = message.data['sellerName'] ?? 'A seller';
      // The new `notifyFollowersLiveStarted` helper and the legacy
      // path inside `liveSeller.controller.js` both emit
      // `liveSellingHistoryId` in the data payload — that's what the
      // tap handler routes on. `sellerId` is kept for diagnostics.
      final liveSellingHistoryId =
          (message.data['liveSellingHistoryId'] as String? ?? '').trim();

      if (fromTap) {
        if (liveSellingHistoryId.isNotEmpty) {
          AppLinkService.instance.openLive(liveSellingHistoryId);
        }
        return;
      }

      Get.snackbar(
        '$sellerName is live now!',
        'Tap to join the show',
        backgroundColor: AppColors.tabBackground,
        colorText: AppColors.white,
        icon: Icon(Icons.live_tv_rounded, color: AppColors.primary),
        duration: const Duration(seconds: 6),
        onTap: (_) {
          if (liveSellingHistoryId.isNotEmpty) {
            AppLinkService.instance.openLive(liveSellingHistoryId);
          }
        },
      );
    }
  }

  Future<void> showForegroundNotification(RemoteMessage message) async {
    final title = message.notification?.title ?? message.data['title'];
    final body = message.notification?.body ?? message.data['body'];

    if ((title == null || title.isEmpty) && (body == null || body.isEmpty)) {
      return;
    }

    await _localNotifications.show(
      message.hashCode,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }

  Future<void> syncTokenToBackendIfPossible() async {
    final currentToken = fcmToken;
    if (loginUserId.isEmpty || currentToken.isEmpty) {
      return;
    }

    final profile = Database.fetchLoginUserProfileModel?.user;
    if (profile == null) {
      return;
    }

    if (profile.fcmToken == currentToken) {
      return;
    }

    try {
      final response = await ProfileEditApi().updateUser(
        userId: loginUserId,
        firstName: profile.firstName ?? editFirstName,
        lastName: profile.lastName ?? editLastName,
        email: profile.email ?? editEmail,
        dob: profile.dob ?? editDateOfBirth,
        gender: profile.gender ?? genderSelect,
        location: profile.location ?? editLocation,
        mobileNumber: profile.mobileNumber,
        countryCode: profile.countryCode,
        fcmToken: currentToken,
      );

      if (response?.status == true) {
        Database.fetchLoginUserProfileModel = Database.fetchLoginUserProfileModel?.copyWith(
          user: profile.copyWith(fcmToken: currentToken),
        );
        log('FCM token synced to backend');
      }
    } catch (e) {
      log('FCM token sync failed: $e');
    }
  }

  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    await _localNotifications.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: (response) async {
        if ((response.payload ?? '').isEmpty) {
          return;
        }

        try {
          final data = Map<String, dynamic>.from(jsonDecode(response.payload!));
          await handleRemoteMessage(RemoteMessage(data: data), fromTap: true);
        } catch (e) {
          log('Failed to handle local notification tap: $e');
        }
      },
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    log('FCM permission status: ${settings.authorizationStatus}');
  }

  Future<void> _configureForegroundPresentation() async {
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: false,
      badge: true,
      sound: true,
    );
  }

  Future<void> _storeToken(String? token) async {
    if (token == null || token.isEmpty) {
      return;
    }

    fcmToken = token;
    await Database.onSetFcmToken(token);
    log('FCM token stored');
  }

  List<Map<String, dynamic>> _decodeProductAttributes(String? rawAttributes) {
    if (rawAttributes == null || rawAttributes.isEmpty) {
      return <Map<String, dynamic>>[];
    }

    try {
      return List<Map<String, dynamic>>.from(json.decode(rawAttributes));
    } catch (e) {
      log('Failed to decode productAttributes: $e');
      return <Map<String, dynamic>>[];
    }
  }
}

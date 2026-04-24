import 'dart:async';
import 'dart:developer';
import 'package:waxxapp/user_pages/bottom_bar_page/controller/bottom_bar_controller.dart';
import 'package:waxxapp/user_pages/preview_seller_profile_page/view/preview_seller_profile_view.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:get/get.dart';

class BranchIoServices {
  static BranchContentMetaData branchContentMetaData = BranchContentMetaData();
  static BranchUniversalObject? branchUniversalObject;
  static BranchLinkProperties branchLinkProperties = BranchLinkProperties();

  static String eventId = "";
  static String eventType = "";
  static String eventName = "";

  // This is Use to Splash Screen...
  static void onListenBranchIoLinks() async {
    StreamController<String> streamController = StreamController<String>();
    StreamSubscription<Map>? streamSubscription = FlutterBranchSdk.listSession().listen(
      (data) async {
        log('Click To Branch Io Link => $data');
        streamController.sink.add((data.toString()));

        if (data.containsKey('+clicked_branch_link') && data['+clicked_branch_link'] == true) {
          log("Click To Branch Io Link Page Routes => ${data['pageRoutes']}");

          eventId = data["id"] ?? "";
          eventType = data['pageRoutes'] ?? "";
          eventName = data['sellerName'] ?? "";

          await Future.delayed(const Duration(milliseconds: 500));

          BottomBarController controller;
          if (Get.isRegistered<BottomBarController>()) {
            controller = Get.find<BottomBarController>();
          } else {
            controller = Get.put(BottomBarController());
          }

          controller.init();
          // await Future.delayed(const Duration(milliseconds: 500));
          // final bottomBarController = Get.isRegistered<BottomBarController>() ? Get.find<BottomBarController>() : Get.put(BottomBarController());
          // bottomBarController.init();

          log("Event Id => $eventId");
        }
      },
      onError: (error) {
        log('Branch Io Listen Error => ${error.toString()}');
      },
    );
    log("Stream Subscription => $streamSubscription");
  }

  static Future<void> onCreateBranchIoLink({
    required String id,
    required String sellerName,
    // required String sellerImage,
    required String pageRoutes,
  }) async {
    branchContentMetaData = BranchContentMetaData()
      ..addCustomMetadata("id", id)
      ..addCustomMetadata('sellerName', sellerName)
      ..addCustomMetadata("pageRoutes", pageRoutes);

    branchUniversalObject = BranchUniversalObject(
      canonicalIdentifier: 'flutter/branch',
      canonicalUrl: 'https://flutter.dev',
      title: sellerName,
      // imageUrl: sellerImage,
      contentDescription: sellerName,
      contentMetadata: branchContentMetaData,
      keywords: ['Plugin', 'Branch', 'Flutter'],
      publiclyIndex: true,
      locallyIndex: true,
      expirationDateInMilliSec: DateTime.now().add(const Duration(days: 365)).millisecondsSinceEpoch,
    );

    branchLinkProperties =
        BranchLinkProperties(channel: 'facebook', feature: 'sharing', stage: 'new share', campaign: 'campaign', tags: ['one', 'two', 'three'])
          ..addControlParam('\$uri_redirect_mode', '1')
          ..addControlParam('\$ios_nativelink', true)
          ..addControlParam('\$match_duration', 7200)
          ..addControlParam('\$always_deeplink', true)
          ..addControlParam('\$android_redirect_timeout', 750)
          ..addControlParam('referring_user_id', 'user_id');
  }

  static Future<void> onCreateProductBranchIoLink({
    required String id,
    required List<String>? images,
    required String productName,
    required String description,
    required String pageRoutes,
  }) async {
    branchContentMetaData = BranchContentMetaData()
      ..addCustomMetadata("id", id)
      ..addCustomMetadata("images", images)
      ..addCustomMetadata("productName", productName)
      ..addCustomMetadata("description", description)
      ..addCustomMetadata("pageRoutes", pageRoutes);

    branchUniversalObject = BranchUniversalObject(
      canonicalIdentifier: 'flutter/branch',
      canonicalUrl: 'https://flutter.dev',
      title: productName,
      imageUrl: images![0],
      contentDescription: description,
      contentMetadata: branchContentMetaData,
      keywords: ['Plugin', 'Branch', 'Flutter'],
      publiclyIndex: true,
      locallyIndex: true,
      expirationDateInMilliSec: DateTime.now().add(const Duration(days: 365)).millisecondsSinceEpoch,
    );

    branchLinkProperties =
        BranchLinkProperties(channel: 'facebook', feature: 'sharing', stage: 'new share', campaign: 'campaign', tags: ['one', 'two', 'three'])
          ..addControlParam('\$uri_redirect_mode', '1')
          ..addControlParam('\$ios_nativelink', true)
          ..addControlParam('\$match_duration', 7200)
          ..addControlParam('\$always_deeplink', true)
          ..addControlParam('\$android_redirect_timeout', 750)
          ..addControlParam('referring_user_id', 'user_id');
  }

  static Future<String?> onGenerateLink() async {
    BranchResponse response = await FlutterBranchSdk.getShortUrl(buo: branchUniversalObject!, linkProperties: branchLinkProperties);
    if (response.success) {
      log("Generated Branch Io Link => ${response.result}");

      return response.result.toString();
    } else {
      log("Generating Branch Io Link Failed !! => ${response.errorCode} - ${response.errorMessage}");
      return null;
    }
  }

  static Future<void> onChangeRoutes() async {
    final bottomBarController = Get.isRegistered<BottomBarController>() ? Get.find<BottomBarController>() : Get.put(BottomBarController());
    if (BranchIoServices.eventType == "Video") {
      await Future.delayed(Duration(milliseconds: 800));
      // Reels lives at index 2 after the Live hub was inserted at index 1.
      bottomBarController.onChangeBottomBar(2);
    } else if (BranchIoServices.eventType == "Product") {
      await Future.delayed(Duration(milliseconds: 800));
      productId = BranchIoServices.eventId;
      Get.toNamed("/ProductDetail");
    } else if (BranchIoServices.eventType == "SellerProfile") {
      await Future.delayed(Duration(milliseconds: 800));
      Get.to(
        () => PreviewSellerProfileView(
          sellerName: BranchIoServices.eventName,
          sellerId: BranchIoServices.eventId,
        ),
      );
    }
  }

// static Future<void> onChangeRoutes() async {
//   if (eventType.isEmpty || eventId.isEmpty) return;
//
//   bool isInitialize = Get.isRegistered<BottomBarController>();
//   final bottomBarController = isInitialize ? Get.find<BottomBarController>() : Get.put(BottomBarController());
//
//   await 500.milliseconds.delay();
//
//   switch (eventType) {
//     case "Video":
//       if (Get.isRegistered<BottomBarController>()) {
//         bottomBarController.onChangeBottomBar(1);
//       }
//       break;
//     case "Product":
//       Get.toNamed("/ProductDetail");
//   }
// }
}

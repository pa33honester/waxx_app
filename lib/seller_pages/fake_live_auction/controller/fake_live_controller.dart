// lib/seller_pages/fake_live/simulated_auction_controller.dart
import 'dart:async';
import 'dart:math';

import 'package:era_shop/utils/globle_veriables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
//
// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import 'package:era_shop/seller_pages/select_product_for_streame/model/selected_product_model.dart';
// import 'package:era_shop/seller_pages/live_page/controller/live_controller.dart';
//
// class LocalChatMessage {
//   final String id;
//   final String userName;
//   final String userImage;
//   final String text;
//   LocalChatMessage({required this.id, required this.userName, required this.userImage, required this.text});
// }
//
// class SimulatedAuctionController extends LiveController {
//   // Local chat + presence simulation
//   final RxList<LocalChatMessage> chat = <LocalChatMessage>[].obs;
//   final RxInt localWatchCount = 1180.obs;
//   final scrollController = ScrollController();
//
//   final _rng = Random();
//   Timer? _fakeBidTimer;
//   Timer? _fakeCommentTimer;
//   Timer? _watchWobbleTimer;
//
//   // knobs
//   int minBidGap = 3; // seconds
//   int maxBidGap = 7;
//   int minNextAuctionGap = 3;
//   int maxNextAuctionGap = 6;
//   bool alwaysProduceWinner = true;
//
//   // fake users
//   List<FakeUser> fakeUsers = FakeCatalog.users;
//
//   // Entry point
//   void startSimulatedShow() {
//     isLivePage = true;
//     onChangeTime();
//
//     _startFakeComments();
//     _startWatchWobble();
//
//     Future.delayed(const Duration(seconds: 1), () {
//       if (currentProduct != null) startCurrentProductAuction();
//     });
//   }
//
//   @override
//   void startCurrentProductAuction() {
//     if (currentProduct == null) return;
//     sellerId = sellerId.isEmpty ? "SIM-SELLER" : sellerId;
//     startAuction(currentProduct!);
//   }
//
//   @override
//   void startAuction(SelectedProduct p) {
//     areAllProductsAuctioned = false;
//     lastAuctionedProduct = null;
//
//     isAuctionActive = true;
//     currentAuctionProductName = p.productName ?? "";
//     currentAuctionProductId = p.productId ?? "";
//     currentAuctionProductImage = p.mainImage ?? "";
//     currentAuctionProductAttributes = p.productAttributes ?? [];
//
//     currentHighestBid = (p.minimumBidPrice ?? 0).toDouble();
//     currentHighestBidderName = "";
//     currentHighestBidderImage = "";
//     minAuctionTime = p.minAuctionTime ?? 45;
//
//     update(["idAuctionProductView", "idUserPlaceBid"]);
//     _pushSys("Auction started for ${p.productName ?? 'Product'}!");
//
//     startAuctionTimer(durationInSeconds: minAuctionTime);
//     _scheduleNextFakeBid(ensureAtLeastOne: alwaysProduceWinner);
//   }
//
//   void _scheduleNextFakeBid({bool ensureAtLeastOne = false}) {
//     if (!isAuctionActive || !isAuctionTimerActive) return;
//
//     final delay = Duration(seconds: _rng.nextInt(maxBidGap - minBidGap + 1) + minBidGap);
//     _fakeBidTimer?.cancel();
//     _fakeBidTimer = Timer(delay, () {
//       if (!isAuctionActive || !isAuctionTimerActive) return;
//
//       final shouldBid = ensureAtLeastOne ? true : (_rng.nextDouble() < 0.7);
//       if (shouldBid) _placeFakeBid();
//
//       _scheduleNextFakeBid();
//     });
//   }
//
//   void _placeFakeBid() {
//     if (!isAuctionActive || !isAuctionTimerActive) return;
//
//     final u = fakeUsers[_rng.nextInt(fakeUsers.length)];
//     final extra = 1 + _rng.nextInt(5); // 1..5
//     final bidAmount = (currentHighestBid + defaultAuctionPlusBid + extra).toDouble();
//
//     currentHighestBid = bidAmount;
//     currentHighestBidderName = u.name;
//     currentHighestBidderImage = u.image;
//
//     // extend a little for drama
//     extendAuctionTimer(_rng.nextBool() ? 5 : 8);
//
//     _pushChat(u.name, u.image, "placed a bid of $currencySymbol${bidAmount.toStringAsFixed(0)}");
//     update(["auctionTimer", "idUserPlaceBid", "idAuctionProductView"]);
//   }
//
//   @override
//   void placeBid() {
//     if (!isAuctionActive || !isAuctionTimerActive) return;
//     final bidAmount = (currentHighestBid + defaultAuctionPlusBid);
//     final u = fakeUsers[_rng.nextInt(fakeUsers.length)];
//     currentHighestBid = bidAmount;
//     currentHighestBidderName = u.name;
//     currentHighestBidderImage = u.image;
//     extendAuctionTimer(5);
//     _pushChat(u.name, u.image, "placed a bid of $currencySymbol${bidAmount.toStringAsFixed(0)}");
//     update(["auctionTimer", "idUserPlaceBid", "idAuctionProductView"]);
//   }
//
//   @override
//   void placeCustomBid(double bidAmount) {
//     if (!isAuctionActive || !isAuctionTimerActive) return;
//     if (bidAmount <= currentHighestBid) return;
//     final u = fakeUsers[_rng.nextInt(fakeUsers.length)];
//     currentHighestBid = bidAmount;
//     currentHighestBidderName = u.name;
//     currentHighestBidderImage = u.image;
//     extendAuctionTimer(6);
//     _pushChat(u.name, u.image, "placed a bid of $currencySymbol${bidAmount.toStringAsFixed(0)}");
//     update(["auctionTimer", "idUserPlaceBid", "idAuctionProductView"]);
//   }
//
//   @override
//   void onAuctionEnd() {
//     final hasWinner = currentHighestBidderName.trim().isNotEmpty;
//     isAuctionActive = false;
//
//     if (hasWinner) {
//       onAuctionWinnerAnnounced({
//         "winnerId": "fake_${currentHighestBidderName.hashCode}",
//         "name": currentHighestBidderName,
//         "image": currentHighestBidderImage,
//       });
//
//       Future.delayed(const Duration(milliseconds: 700), () {
//         onAuctionWinnerPaymentView({
//           "orderId": "FAKE-${DateTime.now().millisecondsSinceEpoch}",
//           "productId": currentAuctionProductId,
//           "itemId": currentAuctionProductId,
//           "productName": currentAuctionProductName,
//           "amount": currentHighestBid.round(),
//           "mainImage": currentAuctionProductImage,
//           "shippingCharges": 0,
//           "productAttributes": currentAuctionProductAttributes,
//         });
//       });
//
//       _pushSys("$currentHighestBidderName won at $currencySymbol${currentHighestBid.toStringAsFixed(0)} 🎉");
//     } else {
//       lastAuctionedProduct = currentProduct;
//       onAuctionWinnerAnnounced({});
//       _pushSys("No winner. Item unsold.");
//     }
//
//     stopAuctionTimer();
//
//     isWaitingForNextProduct = true;
//     update(["idAuctionProductView"]);
//
//     final delay = Duration(seconds: _rng.nextInt(maxNextAuctionGap - minNextAuctionGap + 1) + minNextAuctionGap);
//     Future.delayed(delay, () {
//       if (hasMoreProducts) {
//         moveToNextProduct();
//         startCurrentProductAuction();
//       } else {
//         onAllProductsCompleted();
//       }
//     });
//   }
//
//   // comments & presence
//   void _startFakeComments() {
//     _fakeCommentTimer?.cancel();
//     _fakeCommentTimer = Timer.periodic(const Duration(seconds: 4), (_) {
//       if (!isLivePage) return;
//       final u = fakeUsers[_rng.nextInt(fakeUsers.length)];
//       const msgs = [
//         "Nice quality!",
//         "Any other colors?",
//         "Looks premium 🔥",
//         "Can I get a close-up?",
//         "What’s the weight?",
//         "Is it waterproof?",
//       ];
//       final msg = msgs[_rng.nextInt(msgs.length)];
//       _pushChat(u.name, u.image, msg);
//     });
//   }
//
//   void _startWatchWobble() {
//     _watchWobbleTimer?.cancel();
//     _watchWobbleTimer = Timer.periodic(const Duration(seconds: 3), (_) {
//       final diff = _rng.nextInt(11) - 5; // -5..+5
//       localWatchCount.value = (localWatchCount.value + diff).clamp(900, 3500);
//     });
//   }
//
//   void _pushChat(String name, String image, String text) {
//     chat.add(LocalChatMessage(
//       id: "m_${DateTime.now().millisecondsSinceEpoch}",
//       userName: name,
//       userImage: image,
//       text: text,
//     ));
//     Future.delayed(const Duration(milliseconds: 50), () {
//       if (!scrollController.hasClients) return;
//       scrollController.animateTo(
//         scrollController.position.maxScrollExtent,
//         duration: const Duration(milliseconds: 180),
//         curve: Curves.easeOut,
//       );
//     });
//   }
//
//   void _pushSys(String text) {
//     _pushChat("System", "https://i.pravatar.cc/100?img=64", text);
//   }
//
//   // user comment from input
//   void sendUserComment(String text, {String userName = "You", String userImage = "https://i.pravatar.cc/100?img=15"}) {
//     if (text.trim().isEmpty) return;
//     _pushChat(userName, userImage, text.trim());
//   }
//
//   @override
//   void onClose() {
//     _fakeBidTimer?.cancel();
//     _fakeCommentTimer?.cancel();
//     _watchWobbleTimer?.cancel();
//     scrollController.dispose();
//     super.onClose();
//   }
// }
//
// class FakeUser {
//   final String id;
//   final String name;
//   final String image;
//
//   const FakeUser({
//     required this.id,
//     required this.name,
//     required this.image,
//   });
// }
//
// class FakeCatalog {
//   static List<FakeUser> users = const [
//     FakeUser(
//       id: 'u1',
//       name: 'Avi Sharma',
//       image: 'https://i.pravatar.cc/150?img=1',
//     ),
//     FakeUser(
//       id: 'u2',
//       name: 'Kiran Mehta',
//       image: 'https://i.pravatar.cc/150?img=2',
//     ),
//     FakeUser(
//       id: 'u3',
//       name: 'Rhea Patel',
//       image: 'https://i.pravatar.cc/150?img=3',
//     ),
//     FakeUser(
//       id: 'u4',
//       name: 'Rohit Gupta',
//       image: 'https://i.pravatar.cc/150?img=4',
//     ),
//     FakeUser(
//       id: 'u5',
//       name: 'Maya Kapoor',
//       image: 'https://i.pravatar.cc/150?img=5',
//     ),
//     FakeUser(
//       id: 'u6',
//       name: 'Zara Nair',
//       image: 'https://i.pravatar.cc/150?img=6',
//     ),
//     FakeUser(
//       id: 'u7',
//       name: 'Dev Singh',
//       image: 'https://i.pravatar.cc/150?img=7',
//     ),
//     FakeUser(
//       id: 'u8',
//       name: 'Ananya Joshi',
//       image: 'https://i.pravatar.cc/150?img=8',
//     ),
//   ];
// }
/* ========================= Shared app “design” bits ========================= */

class ProductAttribute {
  final String name;
  final List<String> values;
  ProductAttribute({required this.name, required this.values});
}

class SelectedProduct {
  final String? productId;
  final String? productName;
  final int? price;

  // auction bits (already used in live)
  final int? minimumBidPrice;
  final int? minAuctionTime;

  // media
  final String? mainImage;
  final List<String>? images; // <— new

  // details
  final String? description; // <— new
  final int? shippingCharges; // <— new
  final String? categoryName; // <— new
  final bool? isNewCollection; // <— new

  // seller (flattened for UI)
  final String? sellerName; // <— new
  final String? sellerBusiness; // <— new
  final String? sellerImage; // <— new
  final String? sellerCity; // <— new
  final String? sellerState; // <— new
  final String? sellerCountry; // <— new

  // meta
  final int? sold; // <— new
  final double? ratingAvg; // <— new
  final int? ratingCount; // <— new

  final List<ProductAttribute>? productAttributes;

  SelectedProduct({
    required this.productId,
    required this.productName,
    required this.price,
    required this.minimumBidPrice,
    required this.minAuctionTime,
    required this.mainImage,
    required this.productAttributes,
    this.images,
    this.description,
    this.shippingCharges,
    this.categoryName,
    this.isNewCollection,
    this.sellerName,
    this.sellerBusiness,
    this.sellerImage,
    this.sellerCity,
    this.sellerState,
    this.sellerCountry,
    this.sold,
    this.ratingAvg,
    this.ratingCount,
  });
}

/* =========================== Live base controller ===========================
   Keeps the auction clock, product list, and state that your extended
   controller uses. This is a simplified version of your LiveController.
=============================================================================*/

class LiveController extends GetxController {
  // Public live flags
  bool isLivePage = false;
  bool isHost = false;
  int liveType = 2;

  // Seller and room
  String sellerId = "";
  String roomId = "";

  // Products
  List<SelectedProduct> liveSelectedProducts = [];
  int currentIndex = 0;

  // Current product derived fields
  String currentAuctionProductId = "";
  String currentAuctionProductName = "";
  String currentAuctionProductImage = "";
  List<ProductAttribute> currentAuctionProductAttributes = [];

  // Bidding
  double currentHighestBid = 0;
  String currentHighestBidderName = "";
  String currentHighestBidderImage = "";
  final double defaultAuctionPlusBid = 10;

  // Auction flags
  bool isAuctionActive = false;
  bool isAuctionTimerActive = false;
  bool areAllProductsAuctioned = false;
  bool isWaitingForNextProduct = false;

  // Timer (elapsed live and per-auction)
  int countTime = 0;
  Timer? _elapsedTimer;

  int minAuctionTime = 45;
  int _auctionRemaining = 0;
  Timer? _auctionTimer;

  // Winner UI
  bool isShowAnimationWinner = false;
  String auctionWinnerName = "";
  String auctionWinnerImage = "";
  bool isShowWinnerUserPayment = false;
  int winnerUserPaymentPosition = -300; // right offset anim
  String winnerUserPaymentProductName = "";
  String winnerUserPaymentProductImage = "";
  String winnerUserPaymentRemainingTime = "00:00";

  SelectedProduct? get currentProduct => (currentIndex >= 0 && currentIndex < liveSelectedProducts.length) ? liveSelectedProducts[currentIndex] : null;

  SelectedProduct? lastAuctionedProduct;

  bool get hasMoreProducts => currentIndex + 1 < liveSelectedProducts.length;

  void moveToNextProduct() {
    if (hasMoreProducts) {
      currentIndex += 1;
    }
  }

  // Elapsed live timer (top-right clock)
  void onChangeTime() {
    _elapsedTimer?.cancel();
    _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      countTime += 1;
      update(["onChangeTime"]);
    });
  }

  String onConvertSecondToHMS(int s) {
    final h = (s ~/ 3600).toString().padLeft(2, '0');
    final m = ((s % 3600) ~/ 60).toString().padLeft(2, '0');
    final ss = (s % 60).toString().padLeft(2, '0');
    return '$h:$m:$ss';
  }

  // Auction timer
  void startAuctionTimer({required int durationInSeconds}) {
    _auctionTimer?.cancel();
    _auctionRemaining = durationInSeconds;
    isAuctionTimerActive = true;

    _auctionTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      _auctionRemaining -= 1;
      if (_auctionRemaining <= 0) {
        stopAuctionTimer();
        onAuctionEnd();
      }
      update(["auctionTimer"]);
    });
  }

  void extendAuctionTimer(int bySeconds) {
    if (!isAuctionTimerActive) return;
    _auctionRemaining += bySeconds;
    update(["auctionTimer"]);
  }

  void stopAuctionTimer() {
    isAuctionTimerActive = false;
    _auctionTimer?.cancel();
    update(["auctionTimer"]);
  }

  int get auctionRemainingTime => _auctionRemaining;

  String formatAuctionTime(int s) {
    final m = (s ~/ 60).toString().padLeft(2, '0');
    final ss = (s % 60).toString().padLeft(2, '0');
    return "$m:$ss";
  }

  // Hooks to be overridden by child controller
  void startCurrentProductAuction() {}
  void startAuction(SelectedProduct p) {}
  void placeBid() {}
  void placeCustomBid(double bidAmount) {}
  void onAuctionEnd() {}

  void onAuctionWinnerAnnounced(Map data) {
    if (data.isEmpty) {
      isShowAnimationWinner = false;
      update(["auctionWinner"]);
      return;
    }
    auctionWinnerName = data["name"] ?? "";
    auctionWinnerImage = data["image"] ?? "";
    isShowAnimationWinner = true;
    update(["auctionWinner"]);
  }

  void onWinnerAnimationCompleted() {
    isShowAnimationWinner = false;
    update(["auctionWinner"]);
  }

  void onAuctionWinnerPaymentView(Map data) {
    // Show pay-now slider
    isShowWinnerUserPayment = true;
    winnerUserPaymentPosition = 0;
    winnerUserPaymentProductName = data["productName"] ?? "";
    winnerUserPaymentProductImage = data["mainImage"] ?? "";
    winnerUserPaymentRemainingTime = "00:45";
    update(["isShowWinnerUserPayment"]);
  }

  void onClickUserPayNow() {
    // Your pay logic here; for demo, just hide it.
    isShowWinnerUserPayment = false;
    winnerUserPaymentPosition = -300;
    update(["isShowWinnerUserPayment"]);
    Get.snackbar("Payment", "Opening checkout...", snackPosition: SnackPosition.BOTTOM);
  }

  void onAllProductsCompleted() {
    areAllProductsAuctioned = true;
    update(["idAuctionProductView"]);
  }

  @override
  void onClose() {
    _elapsedTimer?.cancel();
    _auctionTimer?.cancel();
    super.onClose();
  }
}

/* ========================== Simulated auction logic ========================= */

class LocalChatMessage {
  final String id;
  final String userName;
  final String userImage;
  final String text;
  LocalChatMessage({required this.id, required this.userName, required this.userImage, required this.text});
}

class SimulatedAuctionController extends LiveController {
  // Local chat + presence simulation
  final RxList<LocalChatMessage> chat = <LocalChatMessage>[].obs;
  final RxInt localWatchCount = 1180.obs;
  final scrollController = ScrollController();

  final _rng = Random();
  Timer? _fakeBidTimer;
  Timer? _fakeCommentTimer;
  Timer? _watchWobbleTimer;

  // knobs
  int minBidGap = 3; // seconds
  int maxBidGap = 7;
  int minNextAuctionGap = 3;
  int maxNextAuctionGap = 6;
  bool alwaysProduceWinner = true;
  bool _isCommentVisible = false;
  bool get isCommentVisible => _isCommentVisible;

  // Method to toggle comment visibility with animation
  void toggleCommentVisibility(bool show) {
    _isCommentVisible = show;
    update(["idUserPlaceBid"]);
  }

  // fake users
  List<FakeUser> fakeUsers = FakeCatalog.users;

  // Entry point
  void startSimulatedShow() {
    isLivePage = true;
    onChangeTime();

    _startFakeComments();
    _startWatchWobble();

    Future.delayed(const Duration(seconds: 1), () {
      if (currentProduct != null) startCurrentProductAuction();
    });
  }

  @override
  void startCurrentProductAuction() {
    if (currentProduct == null) return;
    sellerId = sellerId.isEmpty ? "SIM-SELLER" : sellerId;
    startAuction(currentProduct!);
  }

  @override
  void startAuction(SelectedProduct p) {
    areAllProductsAuctioned = false;
    lastAuctionedProduct = null;

    isAuctionActive = true;
    currentAuctionProductName = p.productName ?? "";
    currentAuctionProductId = p.productId ?? "";
    currentAuctionProductImage = p.mainImage ?? "";
    currentAuctionProductAttributes = p.productAttributes ?? [];

    currentHighestBid = (p.minimumBidPrice ?? 0).toDouble();
    currentHighestBidderName = "";
    currentHighestBidderImage = "";
    minAuctionTime = p.minAuctionTime ?? 45;

    update(["idAuctionProductView", "idUserPlaceBid"]);
    _pushSys("Auction started for ${p.productName ?? 'Product'}!");

    startAuctionTimer(durationInSeconds: minAuctionTime);
    _scheduleNextFakeBid(ensureAtLeastOne: alwaysProduceWinner);
  }

  void _scheduleNextFakeBid({bool ensureAtLeastOne = false}) {
    if (!isAuctionActive || !isAuctionTimerActive) return;

    final delay = Duration(seconds: _rng.nextInt(maxBidGap - minBidGap + 1) + minBidGap);
    _fakeBidTimer?.cancel();
    _fakeBidTimer = Timer(delay, () {
      if (!isAuctionActive || !isAuctionTimerActive) return;

      final shouldBid = ensureAtLeastOne ? true : (_rng.nextDouble() < 0.7);
      if (shouldBid) _placeFakeBid();

      _scheduleNextFakeBid();
    });
  }

  void _placeFakeBid() {
    if (!isAuctionActive || !isAuctionTimerActive) return;

    final u = fakeUsers[_rng.nextInt(fakeUsers.length)];
    final extra = 1 + _rng.nextInt(5); // 1..5
    final bidAmount = (currentHighestBid + defaultAuctionPlusBid + extra).toDouble();

    currentHighestBid = bidAmount;
    currentHighestBidderName = u.name;
    currentHighestBidderImage = u.image;

    // extend a little for drama
    extendAuctionTimer(_rng.nextBool() ? 5 : 8);

    _pushChat(u.name, u.image, "placed a bid of $currencySymbol${bidAmount.toStringAsFixed(0)}");
    update(["auctionTimer", "idUserPlaceBid", "idAuctionProductView"]);
  }

  @override
  void placeBid() {
    if (!isAuctionActive || !isAuctionTimerActive) return;
    final bidAmount = (currentHighestBid + defaultAuctionPlusBid);
    final u = fakeUsers[_rng.nextInt(fakeUsers.length)];
    currentHighestBid = bidAmount;
    currentHighestBidderName = u.name;
    currentHighestBidderImage = u.image;
    extendAuctionTimer(5);
    _pushChat(u.name, u.image, "placed a bid of $currencySymbol${bidAmount.toStringAsFixed(0)}");
    update(["auctionTimer", "idUserPlaceBid", "idAuctionProductView"]);
  }

  @override
  void placeCustomBid(double bidAmount) {
    if (!isAuctionActive || !isAuctionTimerActive) return;
    if (bidAmount <= currentHighestBid) return;
    final u = fakeUsers[_rng.nextInt(fakeUsers.length)];
    currentHighestBid = bidAmount;
    currentHighestBidderName = u.name;
    currentHighestBidderImage = u.image;
    extendAuctionTimer(6);
    _pushChat(u.name, u.image, "placed a bid of $currencySymbol${bidAmount.toStringAsFixed(0)}");
    update(["auctionTimer", "idUserPlaceBid", "idAuctionProductView"]);
  }

  @override
  void onAuctionEnd() {
    final hasWinner = currentHighestBidderName.trim().isNotEmpty;
    isAuctionActive = false;

    if (hasWinner) {
      onAuctionWinnerAnnounced({
        "winnerId": "fake_${currentHighestBidderName.hashCode}",
        "name": currentHighestBidderName,
        "image": currentHighestBidderImage,
      });

      Future.delayed(const Duration(milliseconds: 700), () {
        onAuctionWinnerPaymentView({
          "orderId": "FAKE-${DateTime.now().millisecondsSinceEpoch}",
          "productId": currentAuctionProductId,
          "itemId": currentAuctionProductId,
          "productName": currentAuctionProductName,
          "amount": currentHighestBid.round(),
          "mainImage": currentAuctionProductImage,
          "shippingCharges": 0,
          "productAttributes": currentAuctionProductAttributes,
        });
      });

      _pushSys("$currentHighestBidderName won at $currencySymbol${currentHighestBid.toStringAsFixed(0)} 🎉");
    } else {
      lastAuctionedProduct = currentProduct;
      onAuctionWinnerAnnounced({});
      _pushSys("No winner. Item unsold.");
    }

    stopAuctionTimer();

    isWaitingForNextProduct = true;
    update(["idAuctionProductView"]);

    final delay = Duration(seconds: _rng.nextInt(maxNextAuctionGap - minNextAuctionGap + 1) + minNextAuctionGap);
    Future.delayed(delay, () {
      if (hasMoreProducts) {
        moveToNextProduct();
        startCurrentProductAuction();
      } else {
        onAllProductsCompleted();
      }
    });
  }

  // comments & presence
  void _startFakeComments() {
    _fakeCommentTimer?.cancel();
    _fakeCommentTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!isLivePage) return;
      final u = fakeUsers[_rng.nextInt(fakeUsers.length)];
      const msgs = [
        "Nice quality!",
        "Any other colors?",
        "Looks premium 🔥",
        "Can I get a close-up?",
        "What’s the weight?",
        "Is it waterproof?",
      ];
      final msg = msgs[_rng.nextInt(msgs.length)];
      _pushChat(u.name, u.image, msg);
    });
  }

  void _startWatchWobble() {
    _watchWobbleTimer?.cancel();
    _watchWobbleTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      final diff = _rng.nextInt(11) - 5; // -5..+5
      localWatchCount.value = (localWatchCount.value + diff).clamp(900, 3500);
    });
  }

  void _pushChat(String name, String image, String text) {
    chat.add(LocalChatMessage(
      id: "m_${DateTime.now().millisecondsSinceEpoch}",
      userName: name,
      userImage: image,
      text: text,
    ));
    Future.delayed(const Duration(milliseconds: 50), () {
      if (!scrollController.hasClients) return;
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
      );
    });
  }

  void _pushSys(String text) {
    _pushChat("System", "https://i.pravatar.cc/100?img=64", text);
  }

  // user comment from input
  void sendUserComment(String text, {String userName = "You", String userImage = "https://i.pravatar.cc/100?img=15"}) {
    if (text.trim().isEmpty) return;
    _pushChat(userName, userImage, text.trim());
  }

  @override
  void onClose() {
    _fakeBidTimer?.cancel();
    _fakeCommentTimer?.cancel();
    _watchWobbleTimer?.cancel();
    scrollController.dispose();
    super.onClose();
  }
}

class FakeUser {
  final String id;
  final String name;
  final String image;

  const FakeUser({
    required this.id,
    required this.name,
    required this.image,
  });
}

class FakeCatalog {
  static List<FakeUser> users = const [
    FakeUser(id: 'u1', name: 'Avi Sharma', image: 'https://i.pravatar.cc/150?img=1'),
    FakeUser(id: 'u2', name: 'Kiran Mehta', image: 'https://i.pravatar.cc/150?img=2'),
    FakeUser(id: 'u3', name: 'Rhea Patel', image: 'https://i.pravatar.cc/150?img=3'),
    FakeUser(id: 'u4', name: 'Rohit Gupta', image: 'https://i.pravatar.cc/150?img=4'),
    FakeUser(id: 'u5', name: 'Maya Kapoor', image: 'https://i.pravatar.cc/150?img=5'),
    FakeUser(id: 'u6', name: 'Zara Nair', image: 'https://i.pravatar.cc/150?img=6'),
    FakeUser(id: 'u7', name: 'Dev Singh', image: 'https://i.pravatar.cc/150?img=7'),
    FakeUser(id: 'u8', name: 'Ananya Joshi', image: 'https://i.pravatar.cc/150?img=8'),
  ];
}

/// ------------------------------------------------------------
/// Minimal fake models (only fields used by the UI are included)
/// ------------------------------------------------------------

final Map<String, dynamic> fakeApiResponse = {
  "status": true,
  "message": "Product details Retrive Successfully.",
  "product": [
    {
      "_id": "68a961bf9c9be4fdff6d423f",
      "productName": "cheakIt",
      "productCode": "120487",
      "description": "testttttttt",
      "allowOffer": false,
      "minimumOfferPrice": 0,
      "price": 15000,
      "shippingCharges": 1500,
      "enableAuction": false,
      "scheduleTime": null,
      "auctionStartingPrice": 0,
      "enableReservePrice": false,
      "reservePrice": 0,
      "auctionDuration": 0,
      "auctionEndDate": null,
      "mainImage": "http://192.168.1.47:5087/storage\\1755931070502boat4.webp",
      "images": [
        "http://192.168.1.47:5087/storage\\1755931070509boat5.webp",
        "http://192.168.1.47:5087/storage\\1755931070496foot.jpeg",
        "http://192.168.1.47:5087/storage\\1755931070471boat1.jpg",
        "http://192.168.1.47:5087/storage\\1755931070450boat2.webp"
      ],
      "attributes": [
        {
          "image": "storage\\175583996649666051f5c567a27.862277711711611740.svg",
          "maxLength": null,
          "minLength": null,
          "name": "Size",
          "values": ["S", "M"]
        }
      ],
      "review": 0,
      "sold": 0,
      "isOutOfStock": false,
      "isNewCollection": false,
      "seller": {
        "_id": "68a961739c9be4fdff6d421a",
        "address": {"city": "egdfdfgd", "state": "dhgdghdgfd", "country": "India"},
        "firstName": "danny",
        "lastName": "fjhjfgdf",
        "businessTag": "bussiness",
        "businessName": "paper",
        "image": "http://192.168.1.47:5087/storage\\17559309950773-reasons-birding-is-badass-blog-header.jpeg"
      },
      "category": {"_id": "68a6f54f4a40b7c3b704d7b6", "name": "Fashion"},
      "subCategory": {"_id": "68a6f5a14a40b7c3b704d7f2", "name": "tshirt"},
      "createStatus": "Approved",
      "updateStatus": "Approved",
      "rating": [],
      "latestBidPrice": null,
      "isFollow": true,
      "isFavorite": false
    }
  ]
};

class FakeUserProductDetails {
  final List<FakeProduct> product;
  FakeUserProductDetails({required this.product});

  factory FakeUserProductDetails.fromMap(Map<String, dynamic> map) {
    final list = (map['product'] as List<dynamic>? ?? []).map((e) => FakeProduct.fromMap(e as Map<String, dynamic>)).toList();
    return FakeUserProductDetails(product: list);
  }
}

String fixUrl(String? url) => (url ?? '').replaceAll('\\', '/');

class FakeProduct {
  final String? id;
  final String? productName;
  final String? productCode;
  final String? description;
  final bool? allowOffer;
  final num? minimumOfferPrice;
  final num? price;
  final num? shippingCharges;
  final bool? enableAuction;
  final String? auctionEndDate;
  final String? mainImage;
  final List<String>? images;
  final List<FakeAttribute>? attributes;
  final int? sold;
  final bool? isNewCollection;
  final FakeSeller? seller;
  final FakeCategory? category;
  final List<dynamic>? rating;
  final num? latestBidPrice;
  final bool? isFollow;
  final bool? isFavorite;

  FakeProduct({
    this.id,
    this.productName,
    this.productCode,
    this.description,
    this.allowOffer,
    this.minimumOfferPrice,
    this.price,
    this.shippingCharges,
    this.enableAuction,
    this.auctionEndDate,
    this.mainImage,
    this.images,
    this.attributes,
    this.sold,
    this.isNewCollection,
    this.seller,
    this.category,
    this.rating,
    this.latestBidPrice,
    this.isFollow,
    this.isFavorite,
  });

  factory FakeProduct.fromMap(Map<String, dynamic> m) {
    return FakeProduct(
      id: m['_id'],
      productName: m['productName'],
      productCode: m['productCode'],
      description: m['description'],
      allowOffer: m['allowOffer'],
      minimumOfferPrice: m['minimumOfferPrice'],
      price: m['price'],
      shippingCharges: m['shippingCharges'],
      enableAuction: m['enableAuction'],
      auctionEndDate: m['auctionEndDate'],
      mainImage: fixUrl(m['mainImage']),
      images: (m['images'] as List<dynamic>? ?? []).map((e) => fixUrl(e as String)).toList(),
      attributes: (m['attributes'] as List<dynamic>? ?? []).map((e) => FakeAttribute.fromMap(e as Map<String, dynamic>)).toList(),
      sold: m['sold'],
      isNewCollection: m['isNewCollection'],
      seller: m['seller'] == null ? null : FakeSeller.fromMap(m['seller'] as Map<String, dynamic>),
      category: m['category'] == null ? null : FakeCategory.fromMap(m['category'] as Map<String, dynamic>),
      rating: m['rating'] as List<dynamic>? ?? [],
      latestBidPrice: m['latestBidPrice'],
      isFollow: m['isFollow'],
      isFavorite: m['isFavorite'],
    );
  }
}

class FakeAttribute {
  final String? name;
  final List<String>? values;
  final String? image; // keeping to match your addToCart mapping
  FakeAttribute({this.name, this.values, this.image});

  factory FakeAttribute.fromMap(Map<String, dynamic> m) => FakeAttribute(
        name: m['name'],
        values: (m['values'] as List<dynamic>? ?? []).map((e) => '$e').toList(),
        image: fixUrl(m['image']),
      );
}

class FakeSeller {
  final String? id;
  final String? businessName;
  final String? businessTag;
  final String? image;
  final FakeAddress? address;
  FakeSeller({this.id, this.businessName, this.businessTag, this.image, this.address});

  factory FakeSeller.fromMap(Map<String, dynamic> m) => FakeSeller(
        id: m['_id'],
        businessName: m['businessName'],
        businessTag: m['businessTag'],
        image: fixUrl(m['image']),
        address: m['address'] == null ? null : FakeAddress.fromMap(m['address'] as Map<String, dynamic>),
      );
}

class FakeAddress {
  final String? city;
  final String? state;
  final String? country;
  FakeAddress({this.city, this.state, this.country});

  factory FakeAddress.fromMap(Map<String, dynamic> m) => FakeAddress(city: m['city'], state: m['state'], country: m['country']);
}

class FakeCategory {
  final String? id;
  final String? name;
  FakeCategory({this.id, this.name});

  factory FakeCategory.fromMap(Map<String, dynamic> m) => FakeCategory(id: m['_id'], name: m['name']);
}

/// ------------------------------------------------------------
/// Fake “UserProductDetailsController” (API-less clone)
/// ------------------------------------------------------------

class FakeUserProductDetailsController extends GetxController {
  final isLoading = true.obs;
  final isDescriptionExpanded = false.obs;

  FakeUserProductDetails? userProductDetails;

  /// Map<attributeName, values>
  Map<String, List<String>> selectedValuesByType = {};

  /// mirror of attributes list for your add-to-cart mapping
  List<FakeAttribute>? selectedCategoryValues;

  /// Simulates your real `userProductDetailsData()` call
  Future<void> userProductDetailsData() async {
    isLoading(true);
    await Future.delayed(const Duration(milliseconds: 300));
    userProductDetails = FakeUserProductDetails.fromMap(fakeApiResponse);

    final first = userProductDetails!.product.first;

    selectedValuesByType = {
      for (final a in (first.attributes ?? [])) a.name ?? 'Attribute': a.values ?? [],
    };
    selectedCategoryValues = first.attributes;

    isLoading(false);
  }

  /// Stubbed—kept for compatibility with your screen flow
  Future<void> getProductWiseUserAuctionBidData() async {}

  void toggleDescription() => isDescriptionExpanded.toggle();
}

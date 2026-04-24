import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:waxxapp/seller_pages/select_product_for_streame/model/selected_product_model.dart';
import 'package:waxxapp/utils/database.dart';
import 'package:waxxapp/utils/socket_services.dart';

/// Snapshot of an in-flight live auction. The controller replaces this whole
/// object on each socket event — that way `Obx` rebuilds catch updates even
/// when a single field changes, without hand-wiring per-field reactives.
class ActiveLiveAuction {
  final String productId;
  final String productName;
  final String mainImage;
  final String liveStreamerId; // the seller's id on the server
  final String productVendorId; // required by placeBid payload
  final String liveHistoryId;
  final int minAuctionTime;
  final num startingBid;
  final num currentBid;
  final DateTime endsAt;
  final String? lastBidderId;

  const ActiveLiveAuction({
    required this.productId,
    required this.productName,
    required this.mainImage,
    required this.liveStreamerId,
    required this.productVendorId,
    required this.liveHistoryId,
    required this.minAuctionTime,
    required this.startingBid,
    required this.currentBid,
    required this.endsAt,
    this.lastBidderId,
  });

  ActiveLiveAuction copyWith({
    num? currentBid,
    DateTime? endsAt,
    String? lastBidderId,
  }) {
    return ActiveLiveAuction(
      productId: productId,
      productName: productName,
      mainImage: mainImage,
      liveStreamerId: liveStreamerId,
      productVendorId: productVendorId,
      liveHistoryId: liveHistoryId,
      minAuctionTime: minAuctionTime,
      startingBid: startingBid,
      currentBid: currentBid ?? this.currentBid,
      endsAt: endsAt ?? this.endsAt,
      lastBidderId: lastBidderId ?? this.lastBidderId,
    );
  }
}

class LiveAuctionWinnerEvent {
  final String productId;
  final String winnerId;
  final num currentBid;
  final String firstName;
  final String lastName;
  final String image;

  const LiveAuctionWinnerEvent({
    required this.productId,
    required this.winnerId,
    required this.currentBid,
    required this.firstName,
    required this.lastName,
    required this.image,
  });

  factory LiveAuctionWinnerEvent.fromJson(Map<String, dynamic> json) => LiveAuctionWinnerEvent(
        productId: json['productId']?.toString() ?? '',
        winnerId: json['winnerId']?.toString() ?? '',
        currentBid: (json['currentBid'] as num?) ?? 0,
        firstName: json['firstName']?.toString() ?? '',
        lastName: json['lastName']?.toString() ?? '',
        image: json['image']?.toString() ?? '',
      );
}

/// Holds the in-show auction state for viewers and hosts inside a live
/// broadcast. Listens to server events via [SocketServices] and exposes
/// reactives for the overlay widget to render.
class LiveAuctionController extends GetxController {
  final Rxn<ActiveLiveAuction> activeAuction = Rxn<ActiveLiveAuction>();
  final RxInt remainingSeconds = 0.obs;
  final RxBool isSubmitting = false.obs;
  final Rxn<LiveAuctionWinnerEvent> lastWinner = Rxn<LiveAuctionWinnerEvent>();
  final RxnString lastError = RxnString();

  /// Bid increment for the quick "BID $next" button. 10 currency units keeps
  /// the UI simple for MVP; can be driven off seller-configured minimum bid
  /// later if we want smarter increments.
  static const int defaultIncrement = 10;

  Timer? _countdownTimer;

  void onAuctionStarted(Map<String, dynamic> data) {
    try {
      final starting = (data['startingBid'] as num?) ?? 0;
      final minAuctionTime = (data['minAuctionTime'] as num?)?.toInt() ?? 60;
      final auction = ActiveLiveAuction(
        productId: data['productId']?.toString() ?? '',
        productName: data['productName']?.toString() ?? '',
        mainImage: data['mainImage']?.toString() ?? '',
        liveStreamerId: data['liveStreamerId']?.toString() ?? '',
        productVendorId: data['productVendorId']?.toString() ?? data['productId']?.toString() ?? '',
        liveHistoryId: data['liveHistoryId']?.toString() ?? '',
        minAuctionTime: minAuctionTime,
        startingBid: starting,
        currentBid: starting,
        endsAt: DateTime.now().add(Duration(seconds: minAuctionTime)),
      );
      activeAuction.value = auction;
      lastWinner.value = null;
      lastError.value = null;
      _startTimer();
    } catch (e) {
      log('onAuctionStarted parse error: $e');
    }
  }

  void onTopBidPlaced(Map<String, dynamic> data) {
    final current = activeAuction.value;
    if (current == null) return;
    final productId = data['productId']?.toString() ?? '';
    if (productId.isNotEmpty && productId != current.productId) return;

    final amount = (data['amount'] as num?) ?? current.currentBid;
    final minAuctionTime = (data['minAuctionTime'] as num?)?.toInt() ?? current.minAuctionTime;
    // Server extends the auction on every bid — mirror that locally so the
    // countdown stays in sync without a second round-trip.
    activeAuction.value = current.copyWith(
      currentBid: amount,
      endsAt: DateTime.now().add(Duration(seconds: minAuctionTime)),
      lastBidderId: data['userId']?.toString() ?? '',
    );
    if (isSubmitting.value && (data['userId']?.toString() == Database.loginUserId)) {
      isSubmitting.value = false;
    }
  }

  /// Server may send a plain string ("No bids were placed...") or a winner
  /// object. Both paths close the active auction.
  void onAuctionResult(dynamic data) {
    if (data is String) {
      activeAuction.value = null;
      _stopTimer();
      return;
    }
    if (data is Map) {
      final event = LiveAuctionWinnerEvent.fromJson(Map<String, dynamic>.from(data));
      lastWinner.value = event;
      activeAuction.value = null;
      _stopTimer();
      // Auto-clear the winner banner after a beat so the overlay disappears.
      Future.delayed(const Duration(seconds: 6), () {
        if (lastWinner.value?.productId == event.productId) {
          lastWinner.value = null;
        }
      });
    }
  }

  void onAuctionError(String message) {
    lastError.value = message;
    isSubmitting.value = false;
    Future.delayed(const Duration(seconds: 3), () {
      if (lastError.value == message) lastError.value = null;
    });
  }

  /// Viewer taps the quick-bid button. Fires the socket emit; the server will
  /// broadcast `announceTopBidPlaced` back to everyone in the room including
  /// us, which is what actually updates [activeAuction.currentBid].
  Future<void> placeBid({int? customAmount}) async {
    final auction = activeAuction.value;
    if (auction == null || isSubmitting.value) return;
    final nextAmount = customAmount ?? (auction.currentBid.toInt() + defaultIncrement);
    isSubmitting.value = true;
    try {
      await SocketServices.onPlaceBid(
        liveStreamerId: auction.liveStreamerId,
        liveHistoryId: auction.liveHistoryId,
        productVendorId: auction.productVendorId,
        productId: auction.productId,
        userId: Database.loginUserId,
        amount: nextAmount,
        minAuctionTime: auction.minAuctionTime,
      );
    } catch (e) {
      isSubmitting.value = false;
      lastError.value = 'Bid failed: $e';
    }
    // We don't clear isSubmitting here — it flips off when the server echoes
    // our bid back via `announceTopBidPlaced` in onTopBidPlaced.
    Future.delayed(const Duration(seconds: 4), () {
      if (isSubmitting.value) isSubmitting.value = false;
    });
  }

  /// Host-side: fire `initiateAuction` for the selected product.
  Future<void> startAuctionForProduct({
    required SelectedProduct product,
    required String liveStreamerId,
    required String liveHistoryId,
    required String sellerUserId,
  }) async {
    await SocketServices.onInitiateAuction(
      liveStreamerId: liveStreamerId,
      liveHistoryId: liveHistoryId,
      productId: product.productId ?? '',
      productName: product.productName ?? '',
      mainImage: product.mainImage ?? '',
      userId: sellerUserId,
      minAuctionTime: product.minAuctionTime ?? 60,
      startingBid: (product.minimumBidPrice ?? product.price ?? 0),
    );
  }

  // ---- Private helpers -----------------------------------------------------

  void _startTimer() {
    _stopTimer();
    _tick();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    final a = activeAuction.value;
    if (a == null) {
      remainingSeconds.value = 0;
      _stopTimer();
      return;
    }
    final r = a.endsAt.difference(DateTime.now()).inSeconds;
    remainingSeconds.value = r > 0 ? r : 0;
  }

  void _stopTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
  }

  @override
  void onClose() {
    _stopTimer();
    super.onClose();
  }

  /// Helper used by [SocketServices] when parsing the `initiateAuction`
  /// payload, which the server emits as a JSON-stringified object of the
  /// exact shape the host sent.
  static Map<String, dynamic>? decodeAuctionPayload(dynamic raw) {
    try {
      if (raw is Map) return Map<String, dynamic>.from(raw);
      if (raw is String) {
        final decoded = jsonDecode(raw);
        if (decoded is Map) return Map<String, dynamic>.from(decoded);
      }
    } catch (e) {
      log('decodeAuctionPayload error: $e');
    }
    return null;
  }
}

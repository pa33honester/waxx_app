import 'dart:async';

import 'package:get/get.dart';
import 'package:waxxapp/ApiModel/giveaway/giveaway_model.dart';
import 'package:waxxapp/ApiService/seller/giveaway_service.dart';
import 'package:waxxapp/user_pages/giveaway/controller/user_giveaway_controller.dart';
import 'package:waxxapp/utils/socket_services.dart';

/// Seller-side controller that launches and draws giveaways from inside the
/// live broadcast. Reuses the buyer-side [UserGiveawayController] for the
/// live countdown/entry-count state so seller and buyer see the exact same
/// socket-driven values.
class SellerGiveawayController extends GetxController {
  final SellerGiveawayService _service = SellerGiveawayService();
  final RxBool isStarting = false.obs;
  final RxBool isDrawing = false.obs;

  /// Start a giveaway. Returns the created model, or null on failure.
  Future<GiveawayModel?> startGiveaway({
    required String sellerId,
    required String liveSellingHistoryId,
    required String productId,
    required int type,
    required int entryWindowSeconds,
  }) async {
    if (isStarting.value) return null;
    isStarting.value = true;
    try {
      final model = await _service.startGiveaway(
        sellerId: sellerId,
        liveSellingHistoryId: liveSellingHistoryId,
        productId: productId,
        type: type,
        entryWindowSeconds: entryWindowSeconds,
      );
      if (model != null && Get.isRegistered<UserGiveawayController>()) {
        // Immediately drive the shared state so the seller's UI reflects the
        // new giveaway before the broadcast round-trips the socket event back.
        Get.find<UserGiveawayController>().onGiveawayStarted(model);
      }
      return model;
    } finally {
      isStarting.value = false;
    }
  }

  /// Force an early draw. Prefers the socket path so the room gets the winner
  /// reveal in the same channel as the other live events.
  Future<bool> drawGiveaway({required String giveawayId}) async {
    if (isDrawing.value) return false;
    isDrawing.value = true;
    try {
      // Socket path = same round-trip as auctions. Fall back to HTTP for
      // safety when the socket isn't connected.
      await SocketServices.emitDrawGiveaway(giveawayId: giveawayId);
      return await _service.drawGiveaway(giveawayId: giveawayId);
    } finally {
      isDrawing.value = false;
    }
  }

  Future<List<GiveawayModel>> fetchHistory(String sellerId) =>
      _service.fetchHistory(sellerId: sellerId);
}

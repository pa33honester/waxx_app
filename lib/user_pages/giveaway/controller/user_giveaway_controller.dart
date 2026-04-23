import 'dart:async';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:waxxapp/ApiModel/giveaway/giveaway_model.dart';
import 'package:waxxapp/ApiService/user/giveaway_service.dart';
import 'package:waxxapp/custom/winner_dialog.dart';
import 'package:waxxapp/utils/database.dart';

/// Holds the active giveaway state for buyers inside a live-watch view.
/// Driven by socket events in [SocketServices]; this controller never
/// reaches back into the socket layer, so live-watch screens can dispose
/// the controller cleanly when the viewer leaves the broadcast.
class UserGiveawayController extends GetxController {
  final UserGiveawayService _service = UserGiveawayService();

  final Rxn<GiveawayModel> activeGiveaway = Rxn<GiveawayModel>();
  final RxBool hasEntered = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxInt remainingSeconds = 0.obs;

  Timer? _countdownTimer;

  /// Hydrate on live-watch screen mount — picks up a giveaway that was
  /// already in-flight before the viewer joined.
  Future<void> loadActiveForLive(String liveSellingHistoryId) async {
    final all = await _service.fetchByLive(liveSellingHistoryId: liveSellingHistoryId);
    final open = all.where((g) => g.status == 1).toList();
    if (open.isNotEmpty) {
      _setActive(open.first);
      hasEntered.value = false;
    }
  }

  void onGiveawayStarted(GiveawayModel model) {
    _setActive(model);
    hasEntered.value = false;
  }

  void onEntryAdded({required String giveawayId, required int entryCount}) {
    final current = activeGiveaway.value;
    if (current == null || current.id != giveawayId) return;
    activeGiveaway.value = current.copyWith(entryCount: entryCount);
  }

  void onGiveawayClosed({required String giveawayId, required String reason}) {
    final current = activeGiveaway.value;
    if (current == null || current.id != giveawayId) return;
    activeGiveaway.value = current.copyWith(status: reason == 'cancelled_by_admin' ? 4 : 2);
    _stopTimer();
    // Dismiss after a short beat so viewers see the final state.
    Future.delayed(const Duration(seconds: 3), () {
      if (activeGiveaway.value?.id == giveawayId) {
        activeGiveaway.value = null;
      }
    });
  }

  void onWinnerRevealed(GiveawayWinnerEvent event) {
    final current = activeGiveaway.value;
    if (current == null || current.id != event.giveawayId) return;
    activeGiveaway.value = current.copyWith(
      status: 3,
      winnerUserId: event.winnerId,
      winnerFirstName: event.firstName,
      winnerLastName: event.lastName,
      winnerImage: event.image,
      winnerDrawnAt: DateTime.now(),
      orderId: event.orderId,
    );
    _stopTimer();
    _showWinnerDialog(event);
    Future.delayed(const Duration(seconds: 6), () {
      if (activeGiveaway.value?.id == event.giveawayId && activeGiveaway.value?.status == 3) {
        activeGiveaway.value = null;
      }
    });
  }

  /// Emitted only to the winning userId's own room — used to trigger a
  /// "claim shipping address" CTA on the winner's device.
  void onPrizeClaim(Map<String, dynamic> payload) {
    log('Giveaway prize claim received: $payload');
    // Surface handled inside [showGiveawayWinnerDialog] for the winner.
  }

  Future<void> enter() async {
    final giveaway = activeGiveaway.value;
    if (giveaway == null || isSubmitting.value || hasEntered.value) return;
    isSubmitting.value = true;
    try {
      final result = await _service.enter(userId: Database.loginUserId, giveawayId: giveaway.id);
      if (result.ok || result.alreadyEntered) {
        hasEntered.value = true;
        activeGiveaway.value = giveaway.copyWith(entryCount: result.entryCount);
      } else if (result.code == 'FOLLOW_REQUIRED') {
        Get.snackbar('Follow to enter', 'Follow this seller to enter the giveaway.',
            snackPosition: SnackPosition.BOTTOM);
      } else if (result.message.isNotEmpty) {
        Get.snackbar('Giveaway', result.message, snackPosition: SnackPosition.BOTTOM);
      }
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<List<GiveawayModel>> fetchMyWins() =>
      _service.fetchMyWins(userId: Database.loginUserId);

  // ---- Private helpers -------------------------------------------------------

  void _setActive(GiveawayModel model) {
    activeGiveaway.value = model;
    _startTimer();
  }

  void _startTimer() {
    _stopTimer();
    _tick();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    final g = activeGiveaway.value;
    if (g == null) {
      remainingSeconds.value = 0;
      _stopTimer();
      return;
    }
    final remaining = g.closesAt.difference(DateTime.now()).inSeconds;
    remainingSeconds.value = remaining > 0 ? remaining : 0;
  }

  void _stopTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
  }

  void _showWinnerDialog(GiveawayWinnerEvent event) {
    final context = Get.context;
    if (context == null) return;
    final isMe = event.winnerId == Database.loginUserId;
    showGiveawayWinnerDialog(context: context, event: event, isMe: isMe);
  }

  @override
  void onClose() {
    _stopTimer();
    super.onClose();
  }
}

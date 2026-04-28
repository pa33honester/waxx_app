import 'dart:async';
import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waxxapp/ApiService/user/fetch_live_by_history_id_service.dart';
import 'package:waxxapp/View/MyApp/AppPages/reels_page/view/reels_view.dart';
import 'package:waxxapp/custom/loading_ui.dart';
import 'package:waxxapp/seller_pages/live_page/view/live_view.dart';
import 'package:waxxapp/user_pages/bottom_bar_page/controller/bottom_bar_controller.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/globle_veriables.dart';

/// Listens for inbound App Links / Universal Links pointing at
/// `https://www.waxxapp.com/...` and routes the user to the right place
/// inside the app.
///
/// Currently handles:
///   `/short/{reelId}` — opens the Reels tab.
///
/// Designed so future content types (`/seller/{id}`, `/product/{id}`,
/// `/live/{id}`) plug in by extending [_handleUri].
class AppLinkService {
  AppLinkService._();
  static final AppLinkService instance = AppLinkService._();

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _subscription;
  bool _initialized = false;

  // The OS often hands the same URL to BOTH `getInitialLink()` (cold
  // start) and `uriLinkStream` (the warm-start listener fires once the
  // launching Intent is processed). Without this guard we'd route the
  // user twice — pushing two LivePageView widgets that race for the
  // singleton Zego engine, leaving the first one with a dead canvas.
  String? _lastHandledUri;
  DateTime? _lastHandledAt;

  /// Call once from main() after Flutter binding is ready. Idempotent.
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    // Cold start: did the OS launch us via a link?
    try {
      final initial = await _appLinks.getInitialLink();
      if (initial != null) {
        // Defer slightly so the home/bottom-nav stack exists before we navigate.
        Future.delayed(const Duration(milliseconds: 800), () => _handleUri(initial));
      }
    } catch (e) {
      log('AppLinkService.getInitialLink error: $e');
    }

    // Warm starts: links arriving while the app is already running.
    _subscription = _appLinks.uriLinkStream.listen(
      _handleUri,
      onError: (Object e) => log('AppLinkService stream error: $e'),
    );
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    _initialized = false;
  }

  void _handleUri(Uri uri) {
    final now = DateTime.now();
    final uriStr = uri.toString();
    if (_lastHandledUri == uriStr &&
        _lastHandledAt != null &&
        now.difference(_lastHandledAt!) < const Duration(seconds: 3)) {
      log('AppLinkService dedup: ignoring duplicate $uri');
      return;
    }
    _lastHandledUri = uriStr;
    _lastHandledAt = now;

    log('AppLinkService received: $uri');

    // Accept both forms:
    //   https://www.waxxapp.com/short/<id>   (App Links / Universal Links)
    //   waxxapp://short/<id>                  (custom scheme — used by the
    //                                          web preview's "Open in app"
    //                                          button when same-domain
    //                                          handoff would otherwise fail)
    final isHttps = uri.scheme == 'https' && (uri.host == 'www.waxxapp.com' || uri.host == 'waxxapp.com');
    final isCustom = uri.scheme == 'waxxapp';
    if (!isHttps && !isCustom) return;

    // For custom-scheme URLs, the "host" component is what looks like the
    // path's first segment (waxxapp://short/<id> → host=short, path=/<id>).
    // Normalise so the routing switch below is the same for both shapes.
    final firstSegment = isCustom ? (uri.host.isNotEmpty ? uri.host : (uri.pathSegments.isNotEmpty ? uri.pathSegments.first : ''))
                                  : (uri.pathSegments.isNotEmpty ? uri.pathSegments.first : '');
    final remainingSegments = isCustom
        ? (uri.host.isNotEmpty ? uri.pathSegments : (uri.pathSegments.length > 1 ? uri.pathSegments.sublist(1) : const <String>[]))
        : (uri.pathSegments.length > 1 ? uri.pathSegments.sublist(1) : const <String>[]);

    if (firstSegment.isEmpty) return;

    switch (firstSegment) {
      case 'short':
        if (remainingSegments.isNotEmpty) _openShort(remainingSegments.first);
        break;
      case 'live':
        if (remainingSegments.isNotEmpty) _openLive(remainingSegments.first);
        break;
      // Future:
      // case 'seller': _openSeller(remainingSegments.first); break;
      // case 'product': _openProduct(remainingSegments.first); break;
    }
  }

  void _openShort(String reelId) {
    // Switch to the Reels tab. Per-reel deep-linking inside the feed needs
    // the reel API to support a "start at id" lookup; for now we land the
    // user on the Reels tab and let them swipe.
    final ctl = Get.isRegistered<BottomBarController>() ? Get.find<BottomBarController>() : Get.put(BottomBarController());
    ctl.onChangeBottomBar(2);
    // If the Reels view is currently on screen we don't need to do anything
    // else; if it isn't, this navigation pushes it.
    if (Get.currentRoute != '/Reels') {
      Get.to(() => const ReelsView(), routeName: '/Reels');
    }
    log('AppLinkService → opened Reels tab for short $reelId');
  }

  Future<void> _openLive(String liveSellingHistoryId) async {
    log('AppLinkService → opening live $liveSellingHistoryId');

    // Show a brief loading dialog so the user gets immediate feedback
    // while we fetch the LiveSeller doc.
    Get.dialog(LoadingUi(), barrierDismissible: false);

    final result = await FetchLiveByHistoryIdService.fetch(liveSellingHistoryId: liveSellingHistoryId);

    if (Get.isDialogOpen ?? false) Get.back();

    if (!result.ok || result.live == null) {
      // Live ended OR network/parse error — both fall back to the Live
      // tab so the user still lands somewhere useful.
      _showSnack(
        title: result.ended ? 'This live show has ended' : 'Couldn\'t open this live',
        message: result.ended
            ? 'The seller is no longer broadcasting.'
            : 'Check your connection and try again.',
      );
      _gotoLiveTab();
      return;
    }

    final live = result.live!;

    // If the user IS the seller of this live (i.e. they tapped a link to
    // their own broadcast), pushing a viewer-side LivePageView would
    // collide with their host-side Zego session. Just route them to the
    // Live tab with a small explanation.
    final mySellerId = sellerId;
    if (mySellerId.isNotEmpty && live.sellerId == mySellerId) {
      _showSnack(
        title: 'You\'re broadcasting this live',
        message: 'Open your seller dashboard to manage the show.',
      );
      _gotoLiveTab();
      return;
    }

    // Make sure BottomBar is up so the back-button stack is sane.
    if (!Get.isRegistered<BottomBarController>()) Get.put(BottomBarController());

    // If a live page is already on top of the stack — most commonly the
    // user was watching a live, backgrounded the app, then tapped a
    // share link — replace it rather than stack a new one. Two
    // LivePageView instances would race for the singleton Zego engine
    // (loginRoom returns 1002001 on the second one, the first one's
    // dispose later kicks the second one out of the room).
    LivePageView buildLivePage() => LivePageView(
          key: ValueKey('live_${live.liveSellingHistoryId}'),
          liveUserList: live,
          isHost: false,
          isActive: true,
        );

    if (Get.currentRoute == '/LivePage') {
      Get.off(buildLivePage, routeName: '/LivePage');
    } else {
      Get.to(buildLivePage, routeName: '/LivePage');
    }
  }

  void _gotoLiveTab() {
    final ctl = Get.isRegistered<BottomBarController>() ? Get.find<BottomBarController>() : Get.put(BottomBarController());
    ctl.onChangeBottomBar(1);
  }

  void _showSnack({required String title, required String message}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.black.withValues(alpha: 0.85),
      colorText: AppColors.white,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    );
  }
}

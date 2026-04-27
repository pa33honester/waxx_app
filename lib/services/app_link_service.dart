import 'dart:async';
import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:get/get.dart';
import 'package:waxxapp/View/MyApp/AppPages/reels_page/view/reels_view.dart';
import 'package:waxxapp/user_pages/bottom_bar_page/controller/bottom_bar_controller.dart';

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
      // Future:
      // case 'seller': _openSeller(remainingSegments.first); break;
      // case 'product': _openProduct(remainingSegments.first); break;
      // case 'live': _openLive(remainingSegments.first); break;
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
}

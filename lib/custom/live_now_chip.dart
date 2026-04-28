import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waxxapp/Controller/GetxController/user/get_live_seller_list_controller.dart';
import 'package:waxxapp/seller_pages/live_page/util/live_swipe_resolver.dart';
import 'package:waxxapp/seller_pages/live_page/view/live_swipe_view.dart';

/// Small pulsing "LIVE NOW" chip surfaced on reels whose seller is currently
/// broadcasting. Reads the already-loaded `GetLiveSellerListController` state
/// — no extra network call — and deep-links into the live view on tap. The
/// chip hides itself whenever the seller isn't live, so callers can mount it
/// unconditionally.
class LiveNowChip extends StatefulWidget {
  const LiveNowChip({super.key, required this.sellerId});

  final String sellerId;

  @override
  State<LiveNowChip> createState() => _LiveNowChipState();
}

class _LiveNowChipState extends State<LiveNowChip> with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GetLiveSellerListController>(
      // Mount on-demand — a reel in the feed may render before the list has
      // been fetched, so we fall back to a lazyPut that stays for the app's
      // lifetime rather than spinning up a fresh controller per reel.
      init: Get.isRegistered<GetLiveSellerListController>() ? null : GetLiveSellerListController(),
      autoRemove: false,
      builder: (ctl) {
        if (!ctl.isSellerLive(widget.sellerId)) return const SizedBox.shrink();

        final liveSeller = ctl.getSellerLiveList.firstWhereOrNull(
          (s) => s.sellerId == widget.sellerId,
        );
        if (liveSeller == null) return const SizedBox.shrink();

        return GestureDetector(
          onTap: () => Get.to(
            () => LiveSwipeView(
              liveStreams: LiveSwipeResolver.swipeListFor(liveSeller),
              initialIndex: LiveSwipeResolver.swipeIndexFor(liveSeller),
            ),
            routeName: '/LivePage',
          ),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.7, end: 1.0).animate(_pulse),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFFF2D6A),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.circle, size: 7, color: Colors.white),
                  SizedBox(width: 5),
                  Text(
                    'LIVE NOW',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

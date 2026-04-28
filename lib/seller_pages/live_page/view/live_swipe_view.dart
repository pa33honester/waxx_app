import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:waxxapp/ApiModel/user/GetLiveSellerListModel.dart';
import 'package:waxxapp/Controller/GetxController/user/get_live_seller_list_controller.dart';
import 'package:waxxapp/seller_pages/live_page/view/live_view.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';

/// Reels-style vertical-swipe wrapper around [LivePageView]. The buyer can
/// swipe between currently-live shows without backing out to the grid.
///
/// Implementation note: only the **settled** page renders a real
/// [LivePageView]. Pages above and below render the cheap [_LivePeekTile]
/// placeholder so the swipe gesture / animation still feels right but we
/// never have two Zego rooms logged in at once. The `LivePageView`'s
/// existing defensive `await logoutRoom(roomID)` before `loginRoom` covers
/// the brief overlap when the previous page's dispose hasn't fully
/// landed before the new page mounts.
class LiveSwipeView extends StatefulWidget {
  final List<LiveSeller> liveStreams;
  final int initialIndex;

  const LiveSwipeView({
    super.key,
    required this.liveStreams,
    this.initialIndex = 0,
  });

  @override
  State<LiveSwipeView> createState() => _LiveSwipeViewState();
}

class _LiveSwipeViewState extends State<LiveSwipeView> {
  late final PreloadPageController _controller;
  late int _settledIndex;

  @override
  void initState() {
    super.initState();
    final safeInitial = widget.initialIndex.clamp(0, widget.liveStreams.length - 1).toInt();
    _settledIndex = safeInitial;
    _controller = PreloadPageController(initialPage: safeInitial);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    if (!mounted) return;
    setState(() => _settledIndex = index);
    _maybeLoadMore(index);
  }

  /// Mirrors the home grid pagination — when the settled index is within
  /// 2 of the end of the in-memory list, ask the controller to fetch the
  /// next page. Quiet-fail if the controller isn't registered (deep-link
  /// path with a fallback single-item list).
  void _maybeLoadMore(int index) {
    if (!Get.isRegistered<GetLiveSellerListController>()) return;
    final controller = Get.find<GetLiveSellerListController>();
    if (controller.moreLoading.value) return;
    if (controller.loadOrNot.value == false) return;
    if (index < widget.liveStreams.length - 2) return;
    controller.loadMoreData();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.liveStreams.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.black,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.black,
      body: PreloadPageView.builder(
        controller: _controller,
        scrollDirection: Axis.vertical,
        // Critical: don't preload Zego rooms. Only the settled page is
        // rendered as a real LivePageView (see itemBuilder below); peers
        // above and below are cheap placeholders.
        preloadPagesCount: 0,
        physics: const ClampingScrollPhysics(),
        itemCount: widget.liveStreams.length,
        onPageChanged: _onPageChanged,
        itemBuilder: (_, index) {
          final seller = widget.liveStreams[index];
          if (index == _settledIndex) {
            return LivePageView(
              key: ValueKey('live_${seller.liveSellingHistoryId}'),
              liveUserList: seller,
              isHost: false,
              isActive: true,
            );
          }
          return _LivePeekTile(seller: seller);
        },
      ),
    );
  }
}

/// Cheap full-screen placeholder shown for swipe-peers above and below the
/// settled page. The cover image gives the swipe gesture something to drag
/// against; the dim gradient + Loading hint signals "this is the next live"
/// without booting Zego or sockets.
class _LivePeekTile extends StatelessWidget {
  final LiveSeller seller;
  const _LivePeekTile({required this.seller});

  @override
  Widget build(BuildContext context) {
    final image = seller.image ?? '';
    final name = seller.businessName?.trim().isNotEmpty == true
        ? seller.businessName!
        : '${seller.firstName ?? ''} ${seller.lastName ?? ''}'.trim();

    return Container(
      color: AppColors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (image.isNotEmpty)
            CachedNetworkImage(
              imageUrl: image,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => Container(color: AppColors.tabBackground),
              placeholder: (_, __) => Container(color: AppColors.tabBackground),
            ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.black.withValues(alpha: 0.55),
                  AppColors.black.withValues(alpha: 0.85),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (name.isNotEmpty) ...[
                  Text(
                    name,
                    style: AppFontStyle.styleW700(AppColors.white, 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                ],
                Text(
                  St.liveText.tr,
                  style: AppFontStyle.styleW600(AppColors.primary, 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

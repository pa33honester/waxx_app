import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waxxapp/ApiModel/user/GetLiveSellerListModel.dart';
import 'package:waxxapp/Controller/GetxController/user/get_live_seller_list_controller.dart';
import 'package:waxxapp/seller_pages/live_page/util/live_swipe_resolver.dart';
import 'package:waxxapp/seller_pages/live_page/view/live_swipe_view.dart';
import 'package:waxxapp/seller_pages/select_product_for_streame/model/selected_product_model.dart';
import 'package:waxxapp/utils/CoustomWidget/App_theme_services/text_titles.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';

String _mmss(int totalSeconds) {
  if (totalSeconds <= 0) return '0:00';
  final m = (totalSeconds ~/ 60).toString();
  final s = (totalSeconds % 60).toString().padLeft(2, '0');
  return '$m:$s';
}

/// Whatnot-style "Live Right Now" rail — one card per live broadcast that has
/// an active auction, showing the product on the block, its current bid, and
/// a countdown. Driven entirely off [GetLiveSellerListController] data the
/// home page has already loaded — no extra network calls.
class HomeLiveProductsRail extends StatelessWidget {
  const HomeLiveProductsRail({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GetLiveSellerListController>(
      // Home registers this controller in its initState — we never create it
      // here. If for any reason it isn't registered yet (e.g. deep-link into
      // the home widget in isolation), GetBuilder surfaces an obvious error
      // rather than silently spinning up a duplicate.
      builder: (ctl) {
        final pairs = _activeAuctionPairs(ctl.getSellerLiveList);
        if (pairs.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.gavel_rounded, size: 16, color: Color(0xFFFFC43A)),
                  const SizedBox(width: 8),
                  const GeneralTitle(title: 'Live Right Now'),
                  const Spacer(),
                  Text(
                    '${pairs.length} auctioning',
                    style: AppFontStyle.styleW500(AppColors.unselected, 11),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 220,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                scrollDirection: Axis.horizontal,
                itemCount: pairs.length,
                itemBuilder: (_, i) => _LiveProductTile(
                  seller: pairs[i].seller,
                  product: pairs[i].product,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Flatten the live seller list into (seller, product) pairs where the
  /// product is the one currently being auctioned. Each show runs at most
  /// one auction at a time, so this effectively yields 0 or 1 pair per show.
  static List<_LivePair> _activeAuctionPairs(List<LiveSeller> sellers) {
    final out = <_LivePair>[];
    for (final s in sellers) {
      final product = (s.selectedProducts ?? []).firstWhereOrNull(
        (p) => p.hasAuctionStarted == true,
      );
      if (product != null) {
        out.add(_LivePair(seller: s, product: product));
      }
    }
    return out;
  }
}

class _LivePair {
  final LiveSeller seller;
  final SelectedProduct product;
  const _LivePair({required this.seller, required this.product});
}

class _LiveProductTile extends StatelessWidget {
  final LiveSeller seller;
  final SelectedProduct product;

  const _LiveProductTile({required this.seller, required this.product});

  @override
  Widget build(BuildContext context) {
    final highestBid = seller.currentHighestBid ?? 0;
    final fallbackBid = product.minimumBidPrice ?? (product.price?.toInt() ?? 0);
    final isStarting = highestBid <= 0;
    final bidValue = isStarting ? fallbackBid : highestBid;
    final remaining = seller.totalRemainingTime ?? 0;

    return GestureDetector(
      onTap: () => Get.to(
        () => LiveSwipeView(
          liveStreams: LiveSwipeResolver.swipeListFor(seller),
          initialIndex: LiveSwipeResolver.swipeIndexFor(seller),
        ),
        routeName: '/LivePage',
      ),
      child: Container(
        width: 160,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.tabBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: product.mainImage ?? '',
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Container(color: AppColors.tabBackground),
                placeholder: (_, __) => Container(color: AppColors.tabBackground),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.78),
                    ],
                    stops: const [0.4, 1.0],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF2D6A),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text('LIVE', style: AppFontStyle.styleW900(AppColors.white, 9)),
              ),
            ),
            if (remaining > 0)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.timer_outlined, size: 10, color: AppColors.white),
                      const SizedBox(width: 3),
                      Text(
                        _mmss(remaining),
                        style: AppFontStyle.styleW700(AppColors.white, 9),
                      ),
                    ],
                  ),
                ),
              ),
            Positioned(
              left: 10,
              right: 10,
              bottom: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.6)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.gavel_rounded, size: 12, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          isStarting ? 'Start' : 'Bid',
                          style: AppFontStyle.styleW700(AppColors.white, 9),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '$currencySymbol$bidValue',
                            overflow: TextOverflow.ellipsis,
                            style: AppFontStyle.styleW900(AppColors.primary, 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    product.productName ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppFontStyle.styleW700(AppColors.white, 12),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      ClipOval(
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CachedNetworkImage(
                            imageUrl: seller.image ?? '',
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) =>
                                Container(color: AppColors.tabBackground),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          (seller.businessName ?? '').isNotEmpty
                              ? seller.businessName!
                              : '${seller.firstName ?? ''} ${seller.lastName ?? ''}'.trim(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppFontStyle.styleW500(
                            AppColors.white.withValues(alpha: 0.85),
                            10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

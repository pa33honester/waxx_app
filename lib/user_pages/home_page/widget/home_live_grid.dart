import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waxxapp/ApiModel/user/GetLiveSellerListModel.dart';
import 'package:waxxapp/Controller/GetxController/user/get_live_seller_list_controller.dart';
import 'package:waxxapp/custom/preview_profile_image_widget.dart';
import 'package:waxxapp/seller_pages/live_page/view/live_view.dart';
import 'package:waxxapp/utils/CoustomWidget/App_theme_services/text_titles.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/shimmers.dart';

String _kcount(int n) {
  if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
  if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
  return '$n';
}

String _mmss(int totalSeconds) {
  if (totalSeconds <= 0) return '0:00';
  final m = (totalSeconds ~/ 60).toString();
  final s = (totalSeconds % 60).toString().padLeft(2, '0');
  return '$m:$s';
}

/// Whatnot-style Live Now grid. Big tile per broadcast with host avatar,
/// viewer count, and LIVE badge. Renders a 2-column grid sized for the
/// home screen header — scrolls horizontally when more than 4 fit.
class HomeLiveGrid extends StatefulWidget {
  const HomeLiveGrid({super.key});

  @override
  State<HomeLiveGrid> createState() => _HomeLiveGridState();
}

class _HomeLiveGridState extends State<HomeLiveGrid> {
  late final GetLiveSellerListController liveCtrl;

  @override
  void initState() {
    super.initState();
    liveCtrl = Get.isRegistered<GetLiveSellerListController>()
        ? Get.find<GetLiveSellerListController>()
        : Get.put(GetLiveSellerListController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (liveCtrl.getSellerLiveList.isEmpty) liveCtrl.getSellerList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (liveCtrl.isLoading.value) {
        return SizedBox(
          height: 240,
          child: Shimmers.liveSellerShow(),
        );
      }
      if (liveCtrl.getSellerLiveList.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF2D6A),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                GeneralTitle(title: St.liveSelling.tr),
                const Spacer(),
                Text(
                  '${liveCtrl.getSellerLiveList.length} live now',
                  style: AppFontStyle.styleW500(AppColors.unselected, 11),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          GetBuilder<GetLiveSellerListController>(
            builder: (_) => SizedBox(
              height: 230,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                scrollDirection: Axis.horizontal,
                itemCount: liveCtrl.getSellerLiveList.length,
                itemBuilder: (_, i) => _LiveTile(seller: liveCtrl.getSellerLiveList[i]),
              ),
            ),
          ),
        ],
      );
    });
  }
}

class _LiveTile extends StatelessWidget {
  final LiveSeller seller;

  const _LiveTile({required this.seller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(
        () => LivePageView(
          key: ValueKey('live_${seller.liveSellingHistoryId}'),
          liveUserList: seller,
          isHost: false,
          isActive: true,
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
                imageUrl: seller.image ?? '',
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
                      Colors.black.withValues(alpha: 0.75),
                    ],
                    stops: const [0.55, 1.0],
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
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.remove_red_eye_rounded, size: 10, color: AppColors.white),
                    const SizedBox(width: 3),
                    Text(
                      _kcount(seller.view ?? 0),
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
                  if ((seller.currentHighestBid ?? 0) > 0 || (seller.totalRemainingTime ?? 0) > 0)
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
                            '$currencySymbol${seller.currentHighestBid ?? 0}',
                            style: AppFontStyle.styleW900(AppColors.primary, 12),
                          ),
                          const Spacer(),
                          if ((seller.totalRemainingTime ?? 0) > 0) ...[
                            Icon(Icons.timer_outlined, size: 11, color: AppColors.white),
                            const SizedBox(width: 3),
                            Text(
                              _mmss(seller.totalRemainingTime ?? 0),
                              style: AppFontStyle.styleW700(AppColors.white, 11),
                            ),
                          ],
                        ],
                      ),
                    ),
                  Row(
                    children: [
                      ClipOval(
                        child: PreviewProfileImageWidget(
                          size: 28,
                          image: seller.image ?? '',
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              (seller.businessName ?? '').isNotEmpty
                                  ? seller.businessName!
                                  : '${seller.firstName ?? ''} ${seller.lastName ?? ''}'.trim(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppFontStyle.styleW700(AppColors.white, 12),
                            ),
                            if ((seller.businessTag ?? '').isNotEmpty)
                              Text(
                                seller.businessTag!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppFontStyle.styleW500(AppColors.white.withValues(alpha: 0.75), 10),
                              ),
                          ],
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

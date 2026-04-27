import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waxxapp/Controller/GetxController/user/get_live_seller_list_controller.dart';
import 'package:waxxapp/user_pages/home_page/widget/home_live_grid.dart';
import 'package:waxxapp/user_pages/home_page/widget/home_live_products_rail.dart';
import 'package:waxxapp/user_pages/upcoming_lives/view/upcoming_lives_widget.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';

/// Full-screen live-shopping hub. Promotes live discovery to a top-level
/// destination rather than leaving it buried on the home feed. Reuses the
/// three rails that already live on home so there's a single source of
/// truth for live-seller state.
class LiveHubView extends StatefulWidget {
  const LiveHubView({super.key});

  @override
  State<LiveHubView> createState() => _LiveHubViewState();
}

class _LiveHubViewState extends State<LiveHubView> {
  late final GetLiveSellerListController _liveCtl;

  @override
  void initState() {
    super.initState();
    _liveCtl = Get.isRegistered<GetLiveSellerListController>()
        ? Get.find<GetLiveSellerListController>()
        : Get.put(GetLiveSellerListController());
  }

  Future<void> _refresh() async {
    await _liveCtl.sellerListAfterLive();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        surfaceTintColor: AppColors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
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
            Text('Live shopping', style: AppFontStyle.styleW700(AppColors.white, 17)),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        // Plain GetBuilder (no id) so the controller's `update()` calls when
        // the live list finishes loading actually rebuild this body. The
        // previous `id: 'onChangeTab'` was never broadcast by the controller,
        // so the empty state never rendered after a load completed.
        child: GetBuilder<GetLiveSellerListController>(
          builder: (_) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 100, top: 4),
              children: [
                // "On air now" grid of live sellers
                const HomeLiveGrid(),

                // Whatnot-style "Live Right Now" product rail
                const HomeLiveProductsRail(),

                const SizedBox(height: 16),

                // Scheduled upcoming broadcasts. The widget owns its own title
                // and renders a "No upcoming shows" placeholder when empty.
                const UpcomingLivesSection(showEmptyState: true),

                // Empty state when no sellers are live. Wrapped in Obx so it
                // reacts to isLoading flipping false even if no GetX update()
                // happens to fire afterwards.
                Obx(() {
                  if (_liveCtl.isLoading.value) return const SizedBox.shrink();
                  if (_liveCtl.getSellerLiveList.isNotEmpty) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                    child: Column(
                      children: [
                        Icon(Icons.videocam_off_outlined, size: 48, color: AppColors.unselected),
                        const SizedBox(height: 12),
                        Text(
                          'No sellers are live right now',
                          style: AppFontStyle.styleW700(AppColors.white, 15),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Follow sellers to get notified the moment they go on air.',
                          textAlign: TextAlign.center,
                          style: AppFontStyle.styleW500(AppColors.unselected, 12),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waxxapp/ApiModel/search/search_results_model.dart';
import 'package:waxxapp/Controller/GetxController/user/get_live_seller_list_controller.dart';
import 'package:waxxapp/seller_pages/live_page/util/live_swipe_resolver.dart';
import 'package:waxxapp/seller_pages/live_page/view/live_swipe_view.dart';
import 'package:waxxapp/user_pages/preview_seller_profile_page/view/preview_seller_profile_view.dart';
import 'package:waxxapp/user_pages/search_page/controller/unified_search_controller.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';

/// Unified multi-scope search. Tabs switch between Products / Sellers /
/// Live shows / Reels results drawn from a single /search/all response.
class UnifiedSearchView extends StatefulWidget {
  const UnifiedSearchView({super.key});

  @override
  State<UnifiedSearchView> createState() => _UnifiedSearchViewState();
}

class _UnifiedSearchViewState extends State<UnifiedSearchView>
    with SingleTickerProviderStateMixin {
  final _textCtl = TextEditingController();
  late final TabController _tabCtl;
  late final UnifiedSearchController _searchCtl;

  static const _tabs = ['Products', 'Sellers', 'Live', 'Reels'];

  @override
  void initState() {
    super.initState();
    _searchCtl = Get.put(UnifiedSearchController());
    _tabCtl = TabController(length: _tabs.length, vsync: this);
    _tabCtl.addListener(() {
      if (_tabCtl.indexIsChanging) return;
      _searchCtl.activeTab.value = _tabCtl.index;
    });
  }

  @override
  void dispose() {
    _textCtl.dispose();
    _tabCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        // IconButton is 48 tall + 46-px TabBar = 94 content. Give the header
        // some breathing room so bigger status bars don't clip it.
        preferredSize: const Size.fromHeight(128),
        child: SafeArea(
          bottom: false,
          child: Container(
            color: Colors.black,
            padding: const EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Get.back(),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _textCtl,
                      autofocus: true,
                      style: AppFontStyle.styleW600(AppColors.white, 14),
                      cursorColor: AppColors.primary,
                      onChanged: _searchCtl.onQueryChanged,
                      decoration: InputDecoration(
                        hintText: 'Search products, sellers, live shows, reels…',
                        hintStyle: AppFontStyle.styleW500(AppColors.unselected, 13),
                        prefixIcon: Icon(Icons.search, color: AppColors.unselected, size: 20),
                        filled: true,
                        fillColor: Colors.white10,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      ),
                    ),
                  ),
                ],
              ),
              TabBar(
                controller: _tabCtl,
                isScrollable: true,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.unselected,
                indicatorColor: AppColors.primary,
                indicatorWeight: 2,
                labelStyle: AppFontStyle.styleW700(AppColors.primary, 13),
                unselectedLabelStyle: AppFontStyle.styleW500(AppColors.unselected, 13),
                tabs: _tabs.map((t) => Tab(text: t)).toList(),
              ),
            ],
          ),
          ),
        ),
      ),
      body: Obx(() {
        if (_searchCtl.query.value.trim().length < 2) {
          return Center(
            child: Text(
              'Start typing to search.',
              style: AppFontStyle.styleW500(AppColors.unselected, 13),
            ),
          );
        }
        if (_searchCtl.isLoading.value && _searchCtl.results.value.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        final r = _searchCtl.results.value;
        return TabBarView(
          controller: _tabCtl,
          children: [
            _ProductsTab(products: r.products),
            _SellersTab(sellers: r.sellers),
            _LiveTab(sellers: r.liveShows),
            _ReelsTab(reels: r.reels),
          ],
        );
      }),
    );
  }
}

class _EmptyScope extends StatelessWidget {
  final String label;
  const _EmptyScope({required this.label});
  @override
  Widget build(BuildContext context) => Center(
        child: Text(label, style: AppFontStyle.styleW500(AppColors.unselected, 13)),
      );
}

// --------------------------------------------------------------------- Products
class _ProductsTab extends StatelessWidget {
  final List<SearchProduct> products;
  const _ProductsTab({required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const _EmptyScope(label: 'No products match.');
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.72,
      ),
      itemCount: products.length,
      itemBuilder: (_, i) {
        final p = products[i];
        return GestureDetector(
          onTap: () {
            productId = p.id;
            Get.toNamed("/ProductDetail");
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.tabBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: CachedNetworkImage(
                    imageUrl: p.mainImage,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => Container(color: Colors.white12),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.productName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppFontStyle.styleW700(AppColors.white, 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$currencySymbol${p.price}',
                        style: AppFontStyle.styleW700(AppColors.primary, 13),
                      ),
                      if (p.sellerName.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Text(
                            p.sellerName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppFontStyle.styleW500(AppColors.unselected, 10),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// --------------------------------------------------------------------- Sellers
class _SellersTab extends StatelessWidget {
  final List<SearchSeller> sellers;
  const _SellersTab({required this.sellers});

  @override
  Widget build(BuildContext context) {
    if (sellers.isEmpty) return const _EmptyScope(label: 'No sellers match.');
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: sellers.length,
      separatorBuilder: (_, __) => const Divider(color: Colors.white12, height: 1),
      itemBuilder: (_, i) {
        final s = sellers[i];
        return InkWell(
          onTap: () => Get.to(
            () => PreviewSellerProfileView(sellerName: s.displayName, sellerId: s.id),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                ClipOval(
                  child: SizedBox(
                    width: 44,
                    height: 44,
                    child: CachedNetworkImage(
                      imageUrl: s.image,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(color: Colors.white12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              s.displayName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppFontStyle.styleW700(AppColors.white, 14),
                            ),
                          ),
                          if (s.isLive)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF2D6A),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text('LIVE', style: AppFontStyle.styleW900(AppColors.white, 8)),
                            ),
                        ],
                      ),
                      if (s.businessTag.isNotEmpty)
                        Text(
                          s.businessTag,
                          style: AppFontStyle.styleW500(AppColors.unselected, 11),
                        ),
                      Text(
                        '${s.followers} followers',
                        style: AppFontStyle.styleW500(AppColors.unselected, 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// --------------------------------------------------------------------- Live
class _LiveTab extends StatelessWidget {
  final List<SearchSeller> sellers;
  const _LiveTab({required this.sellers});

  @override
  Widget build(BuildContext context) {
    if (sellers.isEmpty) return const _EmptyScope(label: 'No live shows match.');
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: sellers.length,
      itemBuilder: (_, i) => _LiveShowCard(seller: sellers[i]),
    );
  }
}

class _LiveShowCard extends StatelessWidget {
  final SearchSeller seller;
  const _LiveShowCard({required this.seller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openLive(seller),
      child: Container(
        height: 180,
        margin: const EdgeInsets.only(bottom: 10),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.tabBackground,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: seller.image,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => Container(color: Colors.white12),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withValues(alpha: 0.78)],
                  stops: const [0.4, 1.0],
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
                child: Text('LIVE NOW', style: AppFontStyle.styleW900(AppColors.white, 9)),
              ),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Text(
                seller.displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppFontStyle.styleW700(AppColors.white, 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Finds the matching LiveSeller record (the live-view needs that full
  /// object) and routes into the broadcast. Falls back to the seller profile
  /// if the controller hasn't cached it yet.
  void _openLive(SearchSeller s) {
    final ctl = Get.isRegistered<GetLiveSellerListController>()
        ? Get.find<GetLiveSellerListController>()
        : Get.put(GetLiveSellerListController());
    final liveSeller = ctl.getSellerLiveList.firstWhereOrNull(
      (ls) => ls.sellerId == s.id,
    );
    if (liveSeller != null) {
      Get.to(
        () => LiveSwipeView(
          liveStreams: LiveSwipeResolver.swipeListFor(liveSeller),
          initialIndex: LiveSwipeResolver.swipeIndexFor(liveSeller),
        ),
        routeName: '/LivePage',
      );
    } else {
      Get.to(() => PreviewSellerProfileView(sellerName: s.displayName, sellerId: s.id));
    }
  }
}

// --------------------------------------------------------------------- Reels
class _ReelsTab extends StatelessWidget {
  final List<SearchReel> reels;
  const _ReelsTab({required this.reels});

  @override
  Widget build(BuildContext context) {
    if (reels.isEmpty) return const _EmptyScope(label: 'No reels match.');
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        childAspectRatio: 9 / 16,
      ),
      itemCount: reels.length,
      itemBuilder: (_, i) {
        final r = reels[i];
        return GestureDetector(
          onTap: () {
            // Deep-linking into a specific reel needs the full reels list
            // loaded; for now we just jump to the reels tab. A future
            // improvement could pass the reel id through and scroll to it.
            Get.toNamed('/ShortsView');
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: r.thumbnail,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Container(color: Colors.white12),
                ),
                Positioned(
                  left: 6,
                  right: 6,
                  bottom: 6,
                  child: Text(
                    r.sellerName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppFontStyle.styleW700(AppColors.white, 10),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

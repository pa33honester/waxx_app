import 'package:era_shop/user_pages/preview_seller_profile_page/controller/preview_seller_profile_controller.dart';
import 'package:era_shop/user_pages/preview_seller_profile_page/widget/store_product_widget.dart';
import 'package:era_shop/utils/app_asset.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreProductTabBarWidget extends StatefulWidget {
  final Function(int)? onTabChanged;

  const StoreProductTabBarWidget({super.key, this.onTabChanged});

  @override
  State<StoreProductTabBarWidget> createState() => _StoreProductTabBarWidgetState();
}

class _StoreProductTabBarWidgetState extends State<StoreProductTabBarWidget> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  final controller = Get.find<PreviewSellerProfileController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _currentIndex = _tabController.index;
        });
        if (widget.onTabChanged != null) {
          print("*********onTabChanged ${_tabController.index}");
          controller.selectedMainTabIndex = _tabController.index;
          widget.onTabChanged!(_tabController.index);
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Container(
        //   width: Get.width,
        //   color: AppColors.black,
        //   padding: const EdgeInsets.symmetric(horizontal: 15),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       15.height,
        //       Row(
        //         children: [
        //           Image.asset(AppAsset.icStoreProduct, width: 20),
        //           10.width,
        //           const GeneralTitle(title: "Store Product"),
        //         ],
        //       ),
        //       15.height,
        //     ],
        //   ),
        // ),

        Container(
          color: AppColors.black,
          child: TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            indicatorPadding: EdgeInsets.symmetric(horizontal: 10),
            dividerHeight: 1,
            dividerColor: AppColors.tabBackground,
            unselectedLabelColor: AppColors.unselected,
            tabs: <Tab>[
              Tab(
                icon: const ImageIcon(AssetImage(AppAsset.icCart), size: 20),
                text: "Products",
              ),
              Tab(
                icon: const ImageIcon(AssetImage(AppAsset.icReels), size: 20),
                text: "Reels",
              ),
              Tab(
                icon: const ImageIcon(AssetImage(AppAsset.icProfile), size: 20),
                text: "Followers",
              ),
            ],
          ),
        ),
        if (_currentIndex == 0) ...{const CategoryTabsWidget()},
      ],
    );
  }
}

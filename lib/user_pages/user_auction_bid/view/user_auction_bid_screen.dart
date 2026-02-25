import 'package:era_shop/custom/simple_app_bar_widget.dart';
import 'package:era_shop/user_pages/user_auction_bid/widget/user_auction_bid_item.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/shimmers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controller/user_auction_bid_controller.dart';
import 'package:era_shop/utils/app_constant.dart';

class UserAuctionBidScreen extends StatelessWidget {
  final controller = Get.put(UserAuctionBidController());

  UserAuctionBidScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.transparent,
          shadowColor: AppColors.black.withValues(alpha: 0.4),
          flexibleSpace: SimpleAppBarWidget(title: St.auctionBid.tr),
        ),
      ),
      body: SingleChildScrollView(
        child: GetBuilder<UserAuctionBidController>(
            id: AppConstant.idGetUserBid,
            builder: (controller) {
              return Column(
                children: [
                  controller.isLoading.value
                      ? Shimmers.auctionBidShimmer()
                      : controller.userAuctionBidModel?.products == null || controller.userAuctionBidModel!.products!.isEmpty
                          ? _buildEmptyState().paddingOnly(top: Get.height / 4)
                          : ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.all(16),
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: controller.userAuctionBidModel?.products?.length,
                              itemBuilder: (context, index) {
                                final productData = controller.userAuctionBidModel?.products?[index];
                                return UserAuctionBidItem(productData: productData);
                              },
                            )
                ],
              );
            }),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.gavel,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            St.noBidsFound.tr,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            St.youHaveNotPlacedAnyBidsYet.tr,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:era_shop/custom/simple_app_bar_widget.dart';
import 'package:era_shop/custom/timer_widget.dart';
import 'package:era_shop/user_pages/user_auction_bid/controller/user_auction_bid_controller.dart';
import 'package:era_shop/user_pages/user_auction_bid/model/product_wise_user_auction_bid_model.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_asset.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/app_constant.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:era_shop/utils/shimmers.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:era_shop/user_pages/user_auction_bid/model/user_auction_bid_model.dart';

class UserViewBiddingScreen extends StatefulWidget {
  const UserViewBiddingScreen({super.key});

  @override
  State<UserViewBiddingScreen> createState() => _UserViewBiddingScreenState();
}

class _UserViewBiddingScreenState extends State<UserViewBiddingScreen> {
  String formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy, HH:mm').format(date);
    } catch (e) {
      return dateString;
    }
  }

  final controller = Get.put(UserAuctionBidController());

  @override
  void initState() {
    final Product productData = Get.arguments;
    controller.getProductWiseUserAuctionBidData(productData.productId ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Product productData = Get.arguments;
    final product = productData;
    // final myBids = controller.productWiseUserAuctionBidModel?.bids ?? [];
    // Bid? highestBid;
    // if (myBids.isNotEmpty) {
    //   highestBid = myBids.reduce((a, b) => (a.currentBid ?? 0) > (b.currentBid ?? 0) ? a : b);
    // }
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.transparent,
          shadowColor: AppColors.black.withValues(alpha: 0.4),
          flexibleSpace: SimpleAppBarWidget(title: St.viewBidding.tr),
        ),
      ),
      body: GetBuilder<UserAuctionBidController>(
          id: AppConstant.idGetUserBid1,
          builder: (logic) {
            final myBids = logic.productWiseUserAuctionBidModel?.bids ?? [];
            Bid? highestBid;
            if (myBids.isNotEmpty) {
              highestBid = myBids.reduce((a, b) => (a.currentBid ?? 0) > (b.currentBid ?? 0) ? a : b);
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.tabBackground,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(
                                  imageUrl: product.mainImage ?? '',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Image.asset(
                                    AppAsset.categoryPlaceholder,
                                    height: 80,
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    width: 80,
                                    height: 80,
                                    color: Colors.grey[300],
                                    child: Icon(Icons.image, color: Colors.grey[600]),
                                  ),
                                ),
                              ),
                              12.width,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            product.productName?.capitalizeFirst ?? '',
                                            style: AppFontStyle.styleW700(AppColors.white, 14),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        4.width,
                                        Text(
                                          "#${product.productCode ?? ''}",
                                          style: AppFontStyle.styleW600(AppColors.unselected, 11),
                                        ),
                                      ],
                                    ),
                                    4.height,
                                    Text(
                                      product.categoryName ?? '',
                                      // '${product?.subCategoryName != null ? ' • ${product?.subCategoryName}' : ''}',
                                      style: AppFontStyle.styleW600(AppColors.unselected, 12),
                                    ),
                                    6.height,
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          for (int i = 0; i < (product.attributes?.isNotEmpty == true ? (product.attributes?[0].values?.length ?? 0) : 0); i++)
                                            Container(
                                              margin: EdgeInsets.only(right: 5),
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: AppColors.unselected.withValues(alpha: 0.3),
                                                  width: 1,
                                                ),
                                                // color: AppColors.unselected.withValues(alpha: 0.3),
                                              ),
                                              child: Text(
                                                product.attributes?.isNotEmpty == true ? (product.attributes?[0].values?[i] ?? "") : "",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: AppFontStyle.styleW500(AppColors.unselected, 12),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    2.height,
                                    Row(
                                      children: [
                                        Text(
                                          '${St.bidPrice.tr}: ',
                                          style: AppFontStyle.styleW700(AppColors.white, 12),
                                        ),
                                        Text(
                                          product.highestBidOnProduct == null ? 'No bid' : '$currencySymbol ${product.highestBidOnProduct ?? ''}',
                                          style: AppFontStyle.styleW700(AppColors.primary, 12),
                                        ),
                                        Spacer(),
                                        TimerWidget(
                                          endDate: productData.auctionEndTime,
                                          color: AppColors.lightGreen,
                                          containerColor: Color(0xFFD3FF34).withValues(alpha: .10),
                                          iconColor: AppColors.lightGreen,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: DottedLine(
                            dashColor: AppColors.unselected,
                          ),
                        ),
                        controller.isLoading1.value
                            ? Shimmers.viewBidShimmer()
                            : logic.productWiseUserAuctionBidModel?.bids == null || logic.productWiseUserAuctionBidModel!.bids!.isEmpty
                                ? _buildEmptyBidsState()
                                : Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          St.myBidAmount.tr,
                                          style: AppFontStyle.styleW700(AppColors.white, 16),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        10.height,
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemCount: logic.productWiseUserAuctionBidModel?.bids?.length,
                                          itemBuilder: (context, index) {
                                            final bid = logic.productWiseUserAuctionBidModel?.bids?[index];
                                            // final myBids = bid;
                                            final isHighest = bid == highestBid;
                                            return Padding(
                                              padding: const EdgeInsets.only(bottom: 12),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 50,
                                                    height: 50,
                                                    padding: EdgeInsets.all(1),
                                                    decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.tabBackground, border: Border.all(color: AppColors.white)),
                                                    child: ClipOval(
                                                      child: CachedNetworkImage(
                                                        imageUrl: bid?.userId?.image ?? '',
                                                        width: 50,
                                                        height: 50,
                                                        fit: BoxFit.cover,
                                                        placeholder: (context, url) => Image.asset(
                                                          AppAsset.categoryPlaceholder,
                                                          height: 22,
                                                        ).paddingAll(30),
                                                        errorWidget: (context, url, error) => Image.asset(
                                                          AppAsset.categoryPlaceholder,
                                                          height: 22,
                                                        ).paddingAll(30),
                                                      ),
                                                    ),
                                                  ),
                                                  8.width,
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              loginUserId == bid?.userId?.id ? "${bid?.userId?.firstName ?? ''} ${bid?.userId?.lastName ?? ''}" : Utils.maskNameControlled(bid?.userId?.firstName ?? '').trim(),
                                                              style: AppFontStyle.styleW700(AppColors.white, 14),
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                            Spacer(),
                                                            8.width,
                                                            if (isHighest) ...[
                                                              // Container(
                                                              //   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                              //   decoration: BoxDecoration(
                                                              //     color: AppColors.primary.withValues(alpha: .1),
                                                              //     borderRadius: BorderRadius.circular(10),
                                                              //   ),
                                                              //   child:
                                                              Text(
                                                                St.lastBid.tr,
                                                                style: AppFontStyle.styleW800(AppColors.primary, 12),
                                                              ),
                                                              // ),
                                                            ],
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              '$currencySymbol ${bid?.currentBid ?? ' '}'.trim(),
                                                              style: AppFontStyle.styleW700(AppColors.primary, 16),
                                                            ),
                                                            8.width,
                                                            Text(
                                                              '(${Utils.dateFormate(bid?.createdAt ?? '0')})',
                                                              style: AppFontStyle.styleW600(AppColors.unselected, 12),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  Widget _buildEmptyBidsState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: Get.height / 4, bottom: Get.height / 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.gavel_outlined,
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
              St.noOneHasPlacedBidsForThisProductYet.tr,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

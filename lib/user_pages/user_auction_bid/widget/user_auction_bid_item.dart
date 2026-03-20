import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:waxxapp/custom/main_button_widget.dart';
import 'package:waxxapp/custom/timer_widget.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_asset.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waxxapp/user_pages/user_auction_bid/model/user_auction_bid_model.dart';

class UserAuctionBidItem extends StatelessWidget {
  const UserAuctionBidItem({
    super.key,
    required this.productData,
  });

  final Product? productData;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.tabBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: productData?.mainImage ?? '',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Image.asset(AppAsset.categoryPlaceholder),
                    errorWidget: (context, url, error) => Container(
                      width: 110,
                      height: 110,
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
                              productData?.productName?.capitalizeFirst ?? '',
                              style: AppFontStyle.styleW700(AppColors.white, 14),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          4.width,
                          Text(
                            '#${productData?.productCode ?? ''}',
                            style: AppFontStyle.styleW600(AppColors.unselected, 11),
                          ),
                        ],
                      ),
                      4.height,
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              productData?.categoryName ?? '',
                              style: AppFontStyle.styleW600(AppColors.unselected, 12),
                            ),
                          ),
                          50.width,
                        ],
                      ),
                      4.height,
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (int i = 0; i < (productData?.attributes?.isNotEmpty == true ? (productData?.attributes?[0].values?.length ?? 0) : 0); i++)
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
                                  productData?.attributes?.isNotEmpty == true ? (productData?.attributes?[0].values?[i] ?? "") : "",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: AppFontStyle.styleW500(AppColors.unselected, 12),
                                ),
                              ),
                          ],
                        ),
                      ),
                      4.height,
                      Row(
                        children: [
                          Text(
                            '${St.bidPrice.tr} : ',
                            style: TextStyle(color: AppColors.white, fontSize: 12, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            '$currencySymbol ${productData?.highestBidOnProduct ?? ''} ',
                            style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w700),
                          ),
                          Spacer(),
                          TimerWidget(
                            endDate: productData?.auctionEndTime,
                            color: AppColors.lightGreen,
                            iconColor: AppColors.lightGreen,
                            containerColor: Color(0xFFD3FF34).withValues(alpha: .10),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                /*Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (bid?.isWinningBid ?? false) ? Colors.green : AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    (bid?.isWinningBid ?? false) ? 'Winning' : 'Active',
                    style: AppFontStyle.styleW600((bid?.isWinningBid ?? false) ? AppColors.white : Colors.black, 10),
                  ),
                ),*/
              ],
            ),
            16.height,
            DottedLine(
              dashColor: AppColors.unselected,
            ),
            16.height,
            MainButtonWidget(
              height: 52,
              color: AppColors.unselected.withValues(alpha: 0.3),
              borderRadius: 12,
              child: Text(
                St.viewAllBids.tr,
                style: AppFontStyle.styleW500(AppColors.white, 14),
              ),
              callback: () {
                Get.toNamed('/UserViewBidding', arguments: productData);
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:era_shop/ApiModel/login/SettingApiModel.dart';
import 'package:era_shop/custom/circle_button_widget.dart';
import 'package:era_shop/custom/preview_image_widget.dart';
import 'package:era_shop/custom/preview_profile_image_widget.dart';
import 'package:era_shop/seller_pages/fake_live_auction/controller/fake_live_controller.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/all_images.dart';
import 'package:era_shop/utils/app_asset.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class FakeProductDetail extends StatefulWidget {
  const FakeProductDetail({super.key, required this.product});
  final SelectedProduct product;

  @override
  State<FakeProductDetail> createState() => _FakeProductDetailState();
}

class _FakeProductDetailState extends State<FakeProductDetail> {
  final PageController _pager = PageController();
  final Map<String, String> _selectedValues = {};
  bool _areAllAttributesFilled = false;
  bool _descExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.transparent,
          surfaceTintColor: AppColors.transparent,
          flexibleSpace: SafeArea(
            child: Container(
              color: AppColors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        height: 48,
                        width: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(AppAsset.icBack, width: 15),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          St.productDetails.tr,
                          style: AppFontStyle.styleW900(AppColors.white, 18),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // onClickShare();
                      },
                      child: Container(
                        height: 38,
                        width: 38,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          AppAsset.icShare,
                          width: 20,
                          color: AppColors.unselected,
                        ),
                      ),
                    ),
                    16.width,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: 15),
                Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: AppColors.tabBackground,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 420,
                        decoration: BoxDecoration(
                          color: AppColors.tabBackground,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            PageView.builder(
                              controller: _pager,
                              itemCount: widget.product.images?.length,
                              itemBuilder: (_, i) => PreviewImageWidget(
                                height: 420,
                                width: Get.width,
                                image: widget.product.images?[i],
                                defaultHeight: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            if (widget.product.images!.length > 1)
                              Positioned(
                                bottom: 15,
                                child: SmoothPageIndicator(
                                  controller: _pager,
                                  count: widget.product.images!.length,
                                  effect: ExpandingDotsEffect(
                                    dotHeight: 8,
                                    dotWidth: 8,
                                    dotColor: Colors.grey.shade400,
                                    activeDotColor: AppColors.primary,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.product.productName ?? "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppFontStyle.styleW700(AppColors.white, 20),
                                ),
                              ),
                              Container(
                                height: 38,
                                width: 38,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColors.white.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(AppAsset.icLiked, width: 20),
                              ),
                            ],
                          ),
                          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                            Expanded(
                              child: Text(
                                widget.product.description ?? '',
                                maxLines: _descExpanded ? null : 2,
                                overflow: _descExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                                style: AppFontStyle.styleW500(AppColors.unselected, 14),
                              ),
                            ),
                            8.width,
                            GestureDetector(
                              onTap: () => setState(() => _descExpanded = !_descExpanded),
                              child: Text(
                                _descExpanded ? St.less.tr : St.more.tr,
                                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 14),
                              ),
                            ),
                          ]),
                          8.height,
                          Row(children: [
                            Image(
                              color: AppColors.unselected,
                              image: AssetImage(AppImage.location),
                              height: 15,
                            ),
                            5.width,
                            Text('${widget.product.sellerCity}, ${widget.product.sellerState}, ${widget.product.sellerCountry}', style: AppFontStyle.styleW500(Colors.white60, 12)),
                            10.width,
                            Image(
                              color: AppColors.unselected,
                              image: AssetImage(AppImage.cart),
                              height: 15,
                            ),
                            5.width,
                            Text(
                              "${widget.product.sold} ${St.sold.tr}",
                              style: AppFontStyle.styleW500(AppColors.unselected, 12),
                            ),
                            10.width,
                            const Icon(
                              Icons.star_rounded,
                              color: Color(0xffFACC15),
                              size: 20,
                            ),
                            5.width,
                            Text(
                              "${widget.product.ratingAvg}",
                              style: AppFontStyle.styleW500(AppColors.unselected, 12),
                            ),
                          ]),
                          8.height,
                          Row(children: [
                            Text("$currencySymbol ${widget.product.price}", style: AppFontStyle.styleW900(AppColors.primary, 20)),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Row(children: [
                                const Icon(Icons.local_shipping_outlined, color: Colors.black, size: 18),
                                const SizedBox(width: 6),
                                Text(St.freeShipping.tr, style: AppFontStyle.styleW700(Colors.black, 12)),
                              ]),
                            ),
                          ]),
                          6.height,
                        ]),
                      ),
                    ],
                  ),
                ),
                30.height,
                if ((widget.product.productAttributes ?? []).isNotEmpty) ...[
                  ...widget.product.productAttributes!.map((attr) {
                    final values = attr.values;
                    final key = attr.name;
                    final current = _selectedValues[key];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Text(
                            current == null ? key : "Select $key : $current",
                            style: AppFontStyle.styleW700(AppColors.white, 16),
                          ),
                        ),
                        8.height,
                        SizedBox(
                          height: 42,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: values.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 10),
                            itemBuilder: (_, i) {
                              final v = values[i];
                              final selected = current == v;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedValues[key] = v;
                                    _areAllAttributesFilled = widget.product.productAttributes!.every((a) => _selectedValues[a.name] != null);
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: selected ? AppColors.primary : AppColors.tabBackground,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    v,
                                    style: AppFontStyle.styleW600(
                                      selected ? Colors.black : Colors.white70,
                                      14,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        10.height,
                      ],
                    );
                  }),
                ],
                15.height,
                Text(
                  St.productDetails.tr,
                  style: AppFontStyle.styleW700(AppColors.white, 16),
                ),
                15.height,
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          St.product.tr,
                          overflow: TextOverflow.ellipsis,
                          style: AppFontStyle.styleW500(AppColors.unselected, 14),
                        ),
                        5.height,
                        Text(
                          St.category.tr,
                          overflow: TextOverflow.ellipsis,
                          style: AppFontStyle.styleW500(AppColors.unselected, 14),
                        ),
                      ],
                    ),
                    20.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ":",
                          overflow: TextOverflow.ellipsis,
                          style: AppFontStyle.styleW500(AppColors.unselected, 14),
                        ),
                        5.height,
                        Text(
                          ":",
                          overflow: TextOverflow.ellipsis,
                          style: AppFontStyle.styleW500(AppColors.unselected, 14),
                        ),
                      ],
                    ),
                    25.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.isNewCollection == true ? St.newCollection.tr : St.trendingCollection.tr,
                          overflow: TextOverflow.ellipsis,
                          style: AppFontStyle.styleW700(AppColors.white, 14),
                        ),
                        5.height,
                        Text(
                          widget.product.categoryName.toString(),
                          overflow: TextOverflow.ellipsis,
                          style: AppFontStyle.styleW700(AppColors.primary, 14),
                        ),
                      ],
                    ),
                  ],
                ),
                15.height,
                Text(widget.product.description ?? '', style: AppFontStyle.styleW500(AppColors.unselected, 12)),
                15.height,
                Divider(color: AppColors.unselected.withValues(alpha: 0.25)),
                10.height,
                Text(
                  St.aboutThisSeller.tr,
                  style: AppFontStyle.styleW700(AppColors.white, 16),
                ),
                15.height,
                Row(children: [
                  CircleButtonWidget(
                    size: 52,
                    color: AppColors.white,
                    child: PreviewProfileImageWidget(
                      size: 50,
                      image: widget.product.sellerImage,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(widget.product.sellerName ?? "", style: AppFontStyle.styleW700(AppColors.white, 14)),
                    const SizedBox(height: 5),
                    Text(widget.product.sellerBusiness ?? '', style: AppFontStyle.styleW500(Colors.white60, 11)),
                  ]),
                  const Spacer(),
                  Container(
                    height: 42,
                    width: 90,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(St.follow.tr, style: AppFontStyle.styleW700(Colors.black, 14)),
                  ),
                ]),
                20.height,
              ]),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 60,
        margin: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: _areAllAttributesFilled ? Colors.white : AppColors.tabBackground,
        ),
        child: Center(
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  AppAsset.icCart,
                  width: 22,
                  color: AppColors.black,
                ),
              ),
              Spacer(),
              Text(
                St.addToCartThisProduct.tr.toUpperCase(),
                style: AppFontStyle.styleW700(
                  _areAllAttributesFilled ? AppColors.black : AppColors.white,
                  15,
                ),
              ),
              Spacer(),
              SizedBox(width: 50),
            ],
          ).paddingOnly(left: 6),
        ),
      ),
    );
  }
}

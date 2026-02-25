import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:era_shop/Controller/GetxController/user/my_order_controller.dart';
import 'package:era_shop/utils/CoustomWidget/App_theme_services/no_data_found.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_asset.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:era_shop/utils/shimmers.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../Controller/GetxController/user/order_cancel_by_user_controller.dart';

class MyOrder extends StatefulWidget {
  const MyOrder({super.key});

  @override
  State<MyOrder> createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> with TickerProviderStateMixin {
  MyOrderController myOrderController = Get.put(MyOrderController());
  List productSize = [];

  // Updated categories to include auction statuses
  List<String> categories = [
    St.all.tr,
    St.pending.tr,
    St.confirmed.tr,
    St.outOfDelivery.tr,
    St.deliveredText.tr,
    St.cancelledText.tr,
  ];

  @override
  void initState() {
    myOrderController.orderTabController = TabController(length: categories.length, vsync: this);
    _handleTabChange();
    myOrderController.orderTabController.addListener(() {
      _handleTabChange();
    });
    super.initState();
  }

  void _handleTabChange() {
    setState(() {
      int selectedIndex = myOrderController.orderTabController.index;
      log("Selected Index :: $selectedIndex");
      String selectedCategory = categories[selectedIndex];
      myOrderController.getProductDetails(selectCategory: selectedCategory);
    });
  }

  OrderCancelByUserController orderCancelByUserController = Get.put(OrderCancelByUserController());

  @override
  void dispose() {
    myOrderController.orderTabController.dispose();
    super.dispose();
  }

  // Helper method to get status display text
  String getStatusDisplayText(String? status) {
    switch (status) {
      case "Pending":
        return St.pending.tr;
      case "Confirmed":
        return St.confirmed.tr;
      case "Out Of Delivery":
        return St.outOfDelivery.tr;
      case "Delivered":
        return St.deliveredText.tr;
      case "Cancelled":
        return St.cancelledText.tr;
      default:
        return status ?? "";
    }
  }

  // Helper method to get status background color
  Color getStatusBackgroundColor(String? status) {
    switch (status) {
      case "Pending":
        return const Color(0xffFFF2ED);
      case "Confirmed":
        return const Color(0xffE6F9F0);
      case "Out Of Delivery":
        return const Color(0xffFFFAE8);
      case "Delivered":
        return const Color(0xffF4F0FF);
      case "Cancelled":
        return const Color(0xffFFEDED);
      default:
        return Colors.transparent;
    }
  }

  // Helper method to get status text color
  Color getStatusTextColor(String? status) {
    switch (status) {
      case "Pending":
        return const Color(0xffFF784B);
      case "Confirmed":
        return const Color(0xff00C566);
      case "Out Of Delivery":
        return const Color(0xffFACC15);
      case "Delivered":
        return const Color(0xff936DFF);
      case "Cancelled":
        return const Color(0xffFF4747);
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.black,
          actions: [
            SizedBox(
              width: Get.width,
              height: double.maxFinite,
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      height: 40,
                      width: 40,
                      margin: EdgeInsets.only(left: 15, top: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(AppAsset.icBack, width: 15),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        St.myOrder.tr,
                        style: AppFontStyle.styleW900(AppColors.white, 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          flexibleSpace: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 60,
              child: TabBar(
                tabAlignment: TabAlignment.start,
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                indicatorPadding: const EdgeInsets.all(5),
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primary],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: AppColors.black,
                controller: myOrderController.orderTabController,
                labelStyle: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black,
                ),
                isScrollable: true,
                unselectedLabelColor: AppColors.white,
                unselectedLabelStyle: AppFontStyle.styleW600(AppColors.white, 12),
                tabs: categories.map((categories) => Tab(text: categories)).toList(),
              ),
            ).paddingOnly(bottom: 5),
          ),
        ),
      ),
      body: SafeArea(
        child: GetBuilder<MyOrderController>(
          builder: (MyOrderController controller) => controller.isLoading
              ? Shimmers.myOrderShimmer()
              : TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: controller.orderTabController,
                  children: categories.map(
                    (category) {
                      return GetBuilder(
                        builder: (MyOrderController myOrderController) {
                          return myOrderController.myOrdersData?.orderData?.isEmpty == true
                              ? noDataFound(image: "assets/no_data_found/closebox.png", text: St.noProductFound.tr)
                              : SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: myOrderController.myOrdersData?.orderData?.length,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, mainIndex) {
                                      var orderData = myOrderController.myOrdersData?.orderData?[mainIndex];
                                      return Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: AppColors.white.withValues(alpha: 0.05),
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(
                                            color: AppColors.white.withValues(alpha: 0.1),
                                            width: 1,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            // Order Header
                                            Container(
                                              padding: const EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: AppColors.white.withValues(alpha: 0.03),
                                                borderRadius: const BorderRadius.only(
                                                  topLeft: Radius.circular(16),
                                                  topRight: Radius.circular(16),
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Order ${myOrderController.myOrdersData?.orderData?[mainIndex].orderId.toString() ?? ""}",
                                                    style: AppFontStyle.styleW600(AppColors.white, 14),
                                                  ),
                                                  const Spacer(),
                                                  if (myOrderController.isAuctionStatus(orderData?.items?.first.status))
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color: AppColors.primary.withValues(alpha: 0.2),
                                                        borderRadius: BorderRadius.circular(12),
                                                        border: Border.all(color: AppColors.primary, width: 1),
                                                      ),
                                                      child: Text(
                                                        "AUCTION",
                                                        style: AppFontStyle.styleW600(AppColors.primary, 10),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),

                                            // Order Items
                                            ListView.separated(
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              itemCount: orderData!.items!.length,
                                              separatorBuilder: (context, index) => Divider(
                                                color: AppColors.white.withValues(alpha: 0.1),
                                                height: 1,
                                              ).paddingSymmetric(horizontal: 16),
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding: const EdgeInsets.all(16),
                                                  child: Column(
                                                    children: [
                                                      // Product Info Row
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          // Product Image
                                                          ClipRRect(
                                                            borderRadius: BorderRadius.circular(12),
                                                            child: CachedNetworkImage(
                                                              height: 80,
                                                              width: 80,
                                                              fit: BoxFit.cover,
                                                              imageUrl: orderData.items?[index].productId?.mainImage.toString() ?? "",
                                                              placeholder: (context, url) => Container(
                                                                height: 80,
                                                                width: 80,
                                                                decoration: BoxDecoration(
                                                                  color: AppColors.white.withValues(alpha: 0.1),
                                                                  borderRadius: BorderRadius.circular(12),
                                                                ),
                                                                child: Icon(
                                                                  Icons.image,
                                                                  color: AppColors.white.withValues(alpha: 0.5),
                                                                ),
                                                              ),
                                                              errorWidget: (context, url, error) => Container(
                                                                height: 80,
                                                                width: 80,
                                                                decoration: BoxDecoration(
                                                                  color: AppColors.white.withValues(alpha: 0.1),
                                                                  borderRadius: BorderRadius.circular(12),
                                                                ),
                                                                child: Icon(
                                                                  Icons.image,
                                                                  color: AppColors.white.withValues(alpha: 0.5),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          16.width,

                                                          // Product Details
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                // Product Name & Status
                                                                Row(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        orderData.items?[index].productId?.productName.toString() ?? "",
                                                                        style: AppFontStyle.styleW600(AppColors.white, 15),
                                                                        maxLines: 2,
                                                                        overflow: TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                    8.width,
                                                                    Container(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                                      decoration: BoxDecoration(
                                                                        color: getStatusBackgroundColor(orderData.items?[index].status),
                                                                        borderRadius: BorderRadius.circular(6),
                                                                      ),
                                                                      child: Text(
                                                                        getStatusDisplayText(orderData.items?[index].status),
                                                                        style: GoogleFonts.plusJakartaSans(
                                                                          color: getStatusTextColor(orderData.items?[index].status),
                                                                          fontSize: 11,
                                                                          fontWeight: FontWeight.w600,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                8.height,

                                                                // Price & Quantity
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      "$currencySymbol${orderData.items?[index].purchasedTimeProductPrice.toString()}",
                                                                      style: AppFontStyle.styleW700(AppColors.primary, 16),
                                                                    ),
                                                                    const Spacer(),
                                                                    Text(
                                                                      "Qty: ${orderData.items?[index].productQuantity}",
                                                                      style: AppFontStyle.styleW500(AppColors.white.withValues(alpha: 0.7), 13),
                                                                    ),
                                                                  ],
                                                                ),

                                                                // Discount if available
                                                                if (myOrderController.myOrdersData?.orderData?[mainIndex].promoCode?.discountAmount != null && myOrderController.myOrdersData?.orderData?[mainIndex].promoCode?.discountAmount != 0)
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(top: 4),
                                                                    child: Text(
                                                                      "Discount: ${orderData.promoCode?.discountAmount}"
                                                                      "${orderData.promoCode?.discountType == 0 ? "$currencySymbol" : "%"} ${St.off.tr}",
                                                                      style: AppFontStyle.styleW500(AppColors.primary, 12),
                                                                    ),
                                                                  ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      16.height,
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),

                                            // Order Total
                                            Container(
                                              padding: const EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: AppColors.white.withValues(alpha: 0.03),
                                                borderRadius: const BorderRadius.only(
                                                  bottomLeft: Radius.circular(16),
                                                  bottomRight: Radius.circular(16),
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    St.totalText.tr,
                                                    style: AppFontStyle.styleW600(AppColors.white, 14),
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    "$currencySymbol${myOrderController.myOrdersData?.orderData?[mainIndex].finalTotal}",
                                                    style: AppFontStyle.styleW700(AppColors.primary, 16),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                );
                        },
                      );
                    },
                  ).toList(),
                ),
        ),
      ),
    );
  }
}

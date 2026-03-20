import 'dart:convert';

import 'package:dotted_line/dotted_line.dart';
import 'package:waxxapp/Controller/GetxController/seller/seller_status_wise_order_details_controller.dart';
import 'package:waxxapp/View/MyApp/Seller/SellerOrder/PendingOrder/pending_order_proceed.dart';
import 'package:waxxapp/custom/custom_color_bg_widget.dart';
import 'package:waxxapp/custom/preview_image_widget.dart';
import 'package:waxxapp/custom/simple_app_bar_widget.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_asset.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/shimmers.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

import '../../../../../ApiModel/seller/SellerStatusWiseOrderDetailsModel.dart';
import '../../../../../Controller/GetxController/seller/update_status_wise_order_controller.dart';
import '../../../../../utils/CoustomWidget/App_theme_services/no_data_found.dart';

class PendingOrders extends StatefulWidget {
  final String? startDate;
  final String? endDate;
  final String? status;
  const PendingOrders({super.key, this.startDate, this.endDate, this.status});

  @override
  State<PendingOrders> createState() => _PendingOrdersState();
}

class _PendingOrdersState extends State<PendingOrders> {
  SellerStatusWiseOrderDetailsController sellerStatusWiseOrderDetailsController = Get.put(SellerStatusWiseOrderDetailsController());
  UpdateStatusWiseOrderController updateStatusWiseOrderController = Get.put(UpdateStatusWiseOrderController());

  @override
  void initState() {
    // TODO: implement initState
    sellerStatusWiseOrderDetailsController.sellerStatusWiseOrderDetailsData(status: widget.status!, startDate: widget.startDate!, endDate: widget.endDate!);
    updateStatusWiseOrderController.startDate = widget.startDate;
    updateStatusWiseOrderController.endDate = widget.endDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('$isDemoSeller');
    return CustomColorBgWidget(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.transparent,
            shadowColor: AppColors.transparent,
            surfaceTintColor: AppColors.transparent,
            flexibleSpace: SimpleAppBarWidget(title: St.pendingOrder.tr),
          ),
        ),
        body: SizedBox(
          height: Get.height,
          width: Get.width,
          child: Obx(
            () => sellerStatusWiseOrderDetailsController.isLoading.value
                ? Shimmers.sellerOrderShimmer()
                : (sellerStatusWiseOrderDetailsController.sellerStatusWiseOrderDetails?.orders?.isEmpty ?? true)
                    ? noDataFound(image: "assets/no_data_found/closebox.png", text: St.noOrderFound.tr)
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        itemCount: sellerStatusWiseOrderDetailsController.sellerStatusWiseOrderDetails?.orders!.length,
                        // itemCount: 2,
                        itemBuilder: (context, mainIndex) {
                          final Orders orders = sellerStatusWiseOrderDetailsController.sellerStatusWiseOrderDetails!.orders![mainIndex];
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: orders.items!.length,
                            // itemCount: 2,
                            itemBuilder: (context, index) {
                              return
                                  // OrderProductItemWidget(
                                  //   title: "Devils Wears",
                                  //   description: "Kendow Premium T-shirt Most Popular",
                                  //   sizes: const ["S", "M", "XL", "XXL"],
                                  //   price: "560.00",
                                  //   image: Utils.image,
                                  //   callback: () {},
                                  //   uniqueId: "INV #241548",
                                  //   date: "23 Nov 2022",
                                  // );

                                  GestureDetector(
                                onTap: () {
                                  updateStatusWiseOrderController.orderId = orders.id;
                                  updateStatusWiseOrderController.status = orders.items![index].status;
                                  updateStatusWiseOrderController.itemId = orders.items![index].id;

                                  final List<AttributesArray> attributesArray = orders.items![index].attributesArray!;
                                  Get.to(
                                      () => PendingOrderProceed(
                                            productImage: orders.items![index].productId!.mainImage,
                                            productName: orders.items![index].productId!.productName,
                                            shippingCharge: orders.items![index].purchasedTimeShippingCharges.toString(),
                                            itemDiscount: orders.items![index].itemDiscount.toString(),
                                            itemDiscountRate: orders.items![index].itemDiscountRate.toString(),
                                            userFirstName: orders.userFirstName,
                                            userLastName: orders.userLastName,
                                            userId: orders.userId,
                                            attributesArray: jsonDecode(jsonEncode(attributesArray)),
                                            mobileNumber: orders.userMobileNumber,
                                            shippingAddressCountry: orders.shippingAddress!.country,
                                            shippingAddressState: orders.shippingAddress!.state,
                                            shippingAddressCity: orders.shippingAddress!.city,
                                            shippingAddressZipCode: orders.shippingAddress!.zipCode?.toString(),
                                            shippingAddress: orders.shippingAddress!.address,
                                            orderId: orders.orderId,
                                            paymentGateway: orders.paymentGateway,
                                            orderDate: orders.items![index].date,
                                            productQuantity: orders.items![index].productQuantity!.toInt(),
                                            productPrice: orders.items![index].purchasedTimeProductPrice!.toInt(),
                                            deliveryStatus: orders.items![index].status,
                                          ),
                                      transition: Transition.rightToLeft);
                                },
                                child: OrderItemWidget(
                                  title: orders.items?[index].productId?.productName ?? "",
                                  description: "Kendow Premium T-shirt Most Popular",
                                  // sizes: const ["S", "M", "XL", "XXL"],
                                  price: (orders.items?[index].purchasedTimeProductPrice ?? "").toString(),
                                  image: orders.items?[index].productId?.mainImage ?? "",
                                  callback: () {},
                                  uniqueId: orders.orderId ?? "",
                                  date: orders.items?[index].date ?? "",
                                  paymentStatus: orders.paymentStatus,
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
        ),
      ),
    );
  }
}

class OrderItemWidget extends StatelessWidget {
  const OrderItemWidget(
      {super.key,
      required this.title,
      required this.description,
      // required this.sizes,
      required this.price,
      required this.image,
      required this.uniqueId,
      required this.date,
      required this.callback,
      required this.paymentStatus});

  final String title;
  final String uniqueId;
  final String date;
  final String description;
  final String image;
  // final List sizes;
  final String price;
  final Callback callback;
  final int? paymentStatus;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: AppColors.tabBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                uniqueId,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: AppFontStyle.styleW700(AppColors.unselected, 12),
              ),
              const Spacer(),
              Text(
                date,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: AppFontStyle.styleW500(AppColors.unselected, 10),
              ),
            ],
          ),
          15.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PreviewImageWidget(
                height: 85,
                width: 85,
                fit: BoxFit.cover,
                image: image,
                radius: 15,
              ),
              15.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: AppFontStyle.styleW700(AppColors.white, 13),
                    ),
                    6.height,
                    Text(
                      description,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: AppFontStyle.styleW500(AppColors.unselected, 11),
                    ),
                    6.height,
                    Row(
                      children: [
                        Text(
                          "$currencySymbol $price",
                          style: AppFontStyle.styleW900(AppColors.primary, 16),
                        ),
                        Spacer(),
                        paymentStatus == 1
                            ? Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: AppColors.red),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/icons/unpaid.png",
                                      height: 18,
                                    ),
                                    4.width,
                                    Text(
                                      St.unpaid.tr,
                                      style: AppFontStyle.styleW500(AppColors.white, 12),
                                    ),
                                  ],
                                ),
                              )
                            : Offstage()
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          20.height,
          DottedLine(dashColor: AppColors.unselected.withValues(alpha: 0.3)),
          15.height,
          Row(
            children: [
              Text(
                St.viewDetail.tr,
                style: AppFontStyle.styleW700(AppColors.unselected, 14),
              ),
              const Spacer(),
              Image.asset(AppAsset.icCircleArrowRight, width: 20),
            ],
          ),
          5.height,
        ],
      ),
    );
  }
}

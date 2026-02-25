import 'dart:convert';
import 'package:era_shop/View/MyApp/Seller/SellerOrder/PendingOrder/pending_orders.dart';
import 'package:era_shop/custom/custom_color_bg_widget.dart';
import 'package:era_shop/custom/simple_app_bar_widget.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/shimmers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../ApiModel/seller/SellerStatusWiseOrderDetailsModel.dart';
import '../../../../../Controller/GetxController/seller/seller_status_wise_order_details_controller.dart';
import '../../../../../Controller/GetxController/seller/update_status_wise_order_controller.dart';
import '../../../../../utils/CoustomWidget/App_theme_services/no_data_found.dart';
import 'cancelled_order_details.dart';

class CancelledOrder extends StatefulWidget {
  final String? startDate;
  final String? endDate;
  final String? status;

  const CancelledOrder({super.key, this.startDate, this.endDate, this.status});

  @override
  State<CancelledOrder> createState() => _CancelledOrderState();
}

class _CancelledOrderState extends State<CancelledOrder> {
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
    return CustomColorBgWidget(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.transparent,
            shadowColor: AppColors.transparent,
            surfaceTintColor: AppColors.transparent,
            flexibleSpace: SimpleAppBarWidget(title: St.cancelledOrderText.tr),
          ),
        ),
        body: SizedBox(
          height: Get.height,
          width: Get.width,
          child: Obx(
            () => sellerStatusWiseOrderDetailsController.isLoading.value
                ? Shimmers.sellerOrderShimmer()
                : (sellerStatusWiseOrderDetailsController.sellerStatusWiseOrderDetails?.orders?.isEmpty ?? true)
                    ? noDataFound(image: "assets/no_data_found/closebox.png", text: St.noProductFound.tr)
                    : ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        itemCount: sellerStatusWiseOrderDetailsController.sellerStatusWiseOrderDetails?.orders!.length,
                        // itemCount: 2,
                        itemBuilder: (context, mainIndex) {
                          var orders = sellerStatusWiseOrderDetailsController.sellerStatusWiseOrderDetails!.orders![mainIndex];
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: sellerStatusWiseOrderDetailsController.sellerStatusWiseOrderDetails?.orders![mainIndex].items!.length,
                            // itemCount: 2,
                            itemBuilder: (context, index) {
                              return
                                  //   OrderItemWidget(
                                  //   title: "Devils Wears",
                                  //   description: "Kendow Premium T-shirt Most Popular",
                                  //   sizes: const ["S", "M", "XL", "XXL"],
                                  //   price: "560.00",
                                  //   image: Utils.image,
                                  //   callback: () {},
                                  //   uniqueId: "INV #241548",
                                  //   date: "23 Nov 2022",
                                  // );
                                  //
                                  GestureDetector(
                                onTap: () {
                                  final List<AttributesArray> attributesArray = orders.items![index].attributesArray!;
                                  Get.to(
                                      () => CancelledOrderDetails(
                                            productImage: orders.items![index].productId!.mainImage,
                                            productName: orders.items![index].productId!.productName,
                                            shippingAddressName: orders.shippingAddress!.name,
                                            itemDiscount: orders.items![index].itemDiscount.toString(),
                                            itemDiscountRate: orders.items![index].itemDiscountRate.toString(),
                                            attributesArray: jsonDecode(jsonEncode(attributesArray)),
                                            shippingAddressCountry: orders.shippingAddress!.country,
                                            shippingAddressState: orders.shippingAddress!.state,
                                            shippingAddressCity: orders.shippingAddress!.city,
                                            shippingAddressZipCode: orders.shippingAddress!.zipCode!.toString(),
                                            shippingAddress: orders.shippingAddress!.address,
                                            shippingCharge: orders.items![index].purchasedTimeShippingCharges!.toString(),
                                            orderId: orders.orderId,
                                            paymentGateway: orders.paymentGateway,
                                            orderDate: orders.items![index].date,
                                            productQuantity: orders.items![index].productQuantity!.toInt(),
                                            productPrice: orders.items![index].purchasedTimeProductPrice!.toInt(),
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
                              // return Padding(
                              //   padding: const EdgeInsets.only(bottom: 8, top: 8),
                              //   child: Container(
                              //     height: 120,
                              //     width: double.maxFinite,
                              //     decoration: BoxDecoration(color: isDark.value ? AppColors.lightBlack : AppColors.dullWhite, borderRadius: BorderRadius.circular(24)),
                              //     child: Row(
                              //       children: [
                              //         Padding(
                              //           padding: const EdgeInsets.only(left: 15),
                              //           child: ClipRRect(
                              //             borderRadius: BorderRadius.circular(10),
                              //             child: CachedNetworkImage(
                              //               height: 95,
                              //               width: 95,
                              //               fit: BoxFit.cover,
                              //               imageUrl: orders!.items![index].productId!.mainImage.toString(),
                              //               placeholder: (context, url) => const Center(
                              //                   child: CupertinoActivityIndicator(
                              //                 animating: true,
                              //               )),
                              //               errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                              //             ),
                              //           ),
                              //         ),
                              //         // Padding(
                              //         //   padding: const EdgeInsets.only(left: 15),
                              //         //   child: Container(
                              //         //     height: 95,
                              //         //     width: 95,
                              //         //     decoration: BoxDecoration(
                              //         //         image: DecorationImage(
                              //         //             image:
                              //         //                 NetworkImage("${orders.items![index].productId!.mainImage}"),
                              //         //             fit: BoxFit.cover),
                              //         //         // color: Colors.indigo,
                              //         //         borderRadius: BorderRadius.circular(10)),
                              //         //   ),
                              //         // ),
                              //         SizedBox(
                              //           height: 95,
                              //           child: Padding(
                              //             padding: const EdgeInsets.only(left: 15, top: 5),
                              //             child: Column(
                              //               crossAxisAlignment: CrossAxisAlignment.start,
                              //               // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //               children: [
                              //                 Text(
                              //                   "${orders.items![index].productId!.productName}",
                              //                   style: GoogleFonts.plusJakartaSans(
                              //                     fontWeight: FontWeight.w600,
                              //                     fontSize: 16,
                              //                   ),
                              //                 ),
                              //                 const SizedBox(
                              //                   height: 10,
                              //                 ),
                              //                 Text(
                              //                   "${orders.orderId}",
                              //                   // "ZXV#1315",
                              //                   style: GoogleFonts.plusJakartaSans(color: AppColors.mediumGrey, fontSize: 11.5, fontWeight: FontWeight.w500),
                              //                 ),
                              //                 const Spacer(),
                              //                 GestureDetector(
                              //                   onTap: () {
                              //                     Get.to(
                              //                         () => CancelledOrderDetails(
                              //                               productImage: orders.items![index].productId!.mainImage,
                              //                               productName: orders.items![index].productId!.productName,
                              //                               shippingAddressName: orders.shippingAddress!.name,
                              //                               shippingAddressCountry: orders.shippingAddress!.country,
                              //                               shippingAddressState: orders.shippingAddress!.state,
                              //                               shippingAddressCity: orders.shippingAddress!.city,
                              //                               shippingAddressZipCode: orders.shippingAddress!.zipCode!.toInt(),
                              //                               shippingAddress: orders.shippingAddress!.address,
                              //                               orderId: orders.orderId,
                              //                               paymentGateway: orders.paymentGateway,
                              //                               orderDate: orders.items![index].date,
                              //                               productQuantity: orders.items![index].productQuantity!.toInt(),
                              //                               productPrice: orders.items![index].purchasedTimeProductPrice!.toInt(),
                              //                             ),
                              //                         transition: Transition.rightToLeft);
                              //                   },
                              //                   child: Container(
                              //                     height: 31,
                              //                     width: 92,
                              //                     decoration: BoxDecoration(color: AppColors.primaryPink, borderRadius: BorderRadius.circular(50)),
                              //                     child: Center(
                              //                       child: Text(St.viewDetails.tr,
                              //                           style: GoogleFonts.plusJakartaSans(color: AppColors.white, fontWeight: FontWeight.w600, fontSize: 10.5)),
                              //                     ),
                              //                   ),
                              //                 ),
                              //               ],
                              //             ),
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // );
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

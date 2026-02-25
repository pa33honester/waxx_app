import 'package:era_shop/custom/custom_color_bg_widget.dart';
import 'package:era_shop/custom/main_button_widget.dart';
import 'package:era_shop/custom/preview_image_widget.dart';
import 'package:era_shop/custom/simple_app_bar_widget.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import '../../../../Controller/GetxController/seller/seller_wallet_pending_amount_controller.dart';
import '../../../../utils/CoustomWidget/App_theme_services/no_data_found.dart';

class PaymentPending extends StatefulWidget {
  const PaymentPending({super.key});

  @override
  State<PaymentPending> createState() => _PaymentPendingState();
}

class _PaymentPendingState extends State<PaymentPending> {
  SellerWalletPendingAmountController sellerWalletPendingAmountController = Get.put(SellerWalletPendingAmountController());

  @override
  void initState() {
    // TODO: implement initState
    sellerWalletPendingAmountController.sellerWalletPendingAmountData();
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
            flexibleSpace: SimpleAppBarWidget(title: St.pendingOrderAmount.tr),
          ),
        ),
        body: Obx(
          () => sellerWalletPendingAmountController.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(
                  color: AppColors.primary,
                ))
              : (sellerWalletPendingAmountController.pendingOrderAmount!.sellerPendingAmount!.isEmpty)
                  ? noDataFound(image: "assets/no_data_found/No Data Clipboard.png", text: St.walletIsEmpty.tr)
                  : ListView.builder(
                      shrinkWrap: true,
                      cacheExtent: 1000,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                      itemCount: sellerWalletPendingAmountController.pendingOrderAmount!.sellerPendingAmount!.length,
                      // itemCount: 2,
                      itemBuilder: (context, index) {
                        var indexData = sellerWalletPendingAmountController.pendingOrderAmount?.sellerPendingAmount?[index];
                        return

                            //     PendingOrderItemWidget(
                            //   title: "Devils Wears",
                            //   description: "Kendow Premium T-shirt Most Popular",
                            //   date: "23 Nov 2022",
                            //   uniqueId: "INV #241548",
                            //   price: "560.00",
                            //   image: Utils.image,
                            //   callback: () {},
                            // );

                            PendingOrderItemWidget(
                          title: indexData?.productId?.productName ?? "",
                          description: "Kendow Premium T-shirt Most Popular",
                          price: "${indexData?.amount ?? 0}",
                          image: indexData?.productId?.mainImage ?? "",
                          uniqueId: indexData?.uniqueOrderId ?? "",
                          callback: () {},
                          date: indexData?.date ?? "",
                        );

                        //   Container(
                        //   height: 90,
                        //   width: double.maxFinite,
                        //   decoration: BoxDecoration(
                        //       color: isDark.value ? AppColors.lightBlack : AppColors.dullWhite,
                        //       borderRadius: BorderRadius.circular(15),
                        //       border: Border.all(width: 0.8, color: AppColors.mediumGrey)),
                        //   child: Padding(
                        //     padding: const EdgeInsets.only(left: 10, right: 14),
                        //     child: Row(
                        //       children: [
                        //         Container(
                        //           height: 68,
                        //           width: 68,
                        //           decoration: BoxDecoration(
                        //               image: DecorationImage(image: NetworkImage("${sellerPendingAmount![index].productId!.mainImage}"), fit: BoxFit.cover),
                        //               color: Colors.transparent,
                        //               borderRadius: BorderRadius.circular(10)),
                        //         ),
                        //         SizedBox(
                        //           height: 62,
                        //           child: Padding(
                        //             padding: const EdgeInsets.only(left: 15, top: 5),
                        //             child: Column(
                        //               crossAxisAlignment: CrossAxisAlignment.start,
                        //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //               children: [
                        //                 SizedBox(
                        //                   width: Get.width / 2.5,
                        //                   child: Text(
                        //                     overflow: TextOverflow.ellipsis,
                        //                     "${sellerPendingAmount[index].productId!.productName}",
                        //                     style: GoogleFonts.plusJakartaSans(
                        //                       fontWeight: FontWeight.w600,
                        //                       fontSize: 16,
                        //                     ),
                        //                   ),
                        //                 ),
                        //                 Text(
                        //                   "${sellerPendingAmount[index].uniqueOrderId}",
                        //                   style: GoogleFonts.plusJakartaSans(color: AppColors.darkGrey, fontSize: 10.5, fontWeight: FontWeight.w500),
                        //                 ),
                        //                 Text(
                        //                   "${St.date.tr} :- ${sellerPendingAmount[index].date}",
                        //                   style: GoogleFonts.plusJakartaSans(color: AppColors.darkGrey, fontSize: 10.5, fontWeight: FontWeight.w500),
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //         ),
                        //         const Spacer(),
                        //         Container(
                        //           height: 35,
                        //           decoration: BoxDecoration(color: AppColors.primaryPink, borderRadius: BorderRadius.circular(50)),
                        //           child: Center(
                        //             child: Padding(
                        //               padding: const EdgeInsets.symmetric(horizontal: 12),
                        //               child: Row(
                        //                 children: [
                        //                   Icon(Icons.add, color: AppColors.white, size: 19),
                        //                   Text("${sellerPendingAmount[index].amount}",
                        //                       style: GoogleFonts.plusJakartaSans(color: AppColors.white, fontWeight: FontWeight.w600, fontSize: 13.6)),
                        //                 ],
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ).paddingOnly(bottom: 12);
                      },
                    ),
        ),
      ),
    );
  }
}

class PendingOrderItemWidget extends StatelessWidget {
  const PendingOrderItemWidget({
    super.key,
    required this.title,
    required this.description,
    required this.price,
    required this.image,
    required this.callback,
    required this.date,
    required this.uniqueId,
  });

  final String title;
  final String description;
  final String date;
  final String uniqueId;
  final String image;

  final String price;
  final Callback callback;

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
              10.width,
              const Spacer(),
              Text(
                date,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: AppFontStyle.styleW500(AppColors.unselected, 10),
              ),
            ],
          ),
          10.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PreviewImageWidget(
                height: 80,
                width: 80,
                fit: BoxFit.cover,
                image: image,
                radius: 15,
              ),
              10.width,
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
                    3.height,
                    Text(
                      description,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: AppFontStyle.styleW500(AppColors.unselected, 11),
                    ),
                    5.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "$currencySymbol $price",
                          style: AppFontStyle.styleW900(AppColors.primary, 16),
                        ),
                        MainButtonWidget(
                          height: 24,
                          width: 100,
                          color: AppColors.redBackground,
                          borderRadius: 5,
                          child: Text(
                            "Pending Amount",
                            style: AppFontStyle.styleW500(AppColors.red, 10),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

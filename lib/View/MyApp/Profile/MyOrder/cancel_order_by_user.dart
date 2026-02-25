import 'package:cached_network_image/cached_network_image.dart';
import 'package:era_shop/Controller/GetxController/user/order_cancel_by_user_controller.dart';
import 'package:era_shop/custom/simple_app_bar_widget.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/Theme/theme_service.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/show_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../Controller/GetxController/user/my_order_controller.dart';
import '../../../../utils/CoustomWidget/App_theme_services/primary_buttons.dart';
import '../../../../utils/app_circular.dart';
import '../../../../utils/globle_veriables.dart';

class CancelOrderByUser extends StatefulWidget {
  final String? mainImage;
  final String? productName;
  final num? price;

  const CancelOrderByUser({
    super.key,
    this.mainImage,
    this.productName,
    this.price,
  });

  @override
  State<CancelOrderByUser> createState() => _CancelOrderByUserState();
}

class _CancelOrderByUserState extends State<CancelOrderByUser> {
  OrderCancelByUserController orderCancelByUserController = Get.put(OrderCancelByUserController());
  MyOrderController myOrderController = Get.put(MyOrderController());

  bool isConditionAccept = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: AppColors.transparent,
              shadowColor: AppColors.transparent,
              surfaceTintColor: AppColors.transparent,
              flexibleSpace: SimpleAppBarWidget(title: St.orderDetails.tr),
            ),
          ),
          body: SizedBox(
            height: Get.height,
            width: Get.width,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    height: 160,
                    width: 130,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: widget.mainImage!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const CupertinoActivityIndicator(),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ).paddingSymmetric(vertical: 10),
                  // Container(
                  //   height: 160,
                  //   width: 130,
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(15),
                  //     image: DecorationImage(image: NetworkImage("${widget.mainImage}"), fit: BoxFit.cover),
                  //   ),
                  // ).paddingSymmetric(vertical: 10),
                  Text(
                    "${widget.productName}",
                    overflow: TextOverflow.ellipsis,
                    style: AppFontStyle.styleW600(
                      Colors.white,
                      16,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 25, bottom: 15),
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: isDark.value ? AppColors.lightBlack : Colors.transparent,
                      border: Border.all(color: isDark.value ? Colors.grey.shade600.withValues(alpha: 0.30) : Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                      // color: Colors.grey,
                    ),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            St.cancelOrder.tr,
                            style: TextStyle(color: isDark.value ? AppColors.white : Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w600),
                          ).paddingOnly(top: 12, left: 10),
                        ),
                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            int refundAmount = (widget.price! - cancelOrderCharges!).round();
                            List priseTitle = [
                              St.orderAmount.tr,
                              St.cancellationOrderCharge.tr,
                              St.refundAmount.tr,
                            ];
                            List prices = [
                              "${widget.price}",
                              "$cancelOrderCharges",
                              "$refundAmount",
                            ];
                            return Row(
                              children: [
                                Text(
                                  "${priseTitle[index]}",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: AppColors.darkGrey,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  "$currencySymbol${prices[index]}",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.primaryPink,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                )
                              ],
                            ).paddingSymmetric(vertical: 17);
                          },
                          separatorBuilder: (context, index) {
                            return Divider(
                              height: 3,
                              color: AppColors.darkGrey.withValues(alpha: 0.40),
                            );
                          },
                          itemCount: 3,
                        )
                      ],
                    ),
                  ),

                  widget.price! <= cancelOrderCharges! == true
                      ? Text(
                          "Note: You can't cancel this order because your order price is lower than the cancellation charge.",
                          overflow: TextOverflow.fade,
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 14.5,
                            color: AppColors.red,
                          ),
                        )
                      : Row(
                          children: [
                            Transform.scale(
                              scale: 1.1,
                              child: Checkbox(
                                side: BorderSide(color: AppColors.lightGrey, style: BorderStyle.solid),
                                shape: const CircleBorder(),
                                checkColor: AppColors.black,
                                activeColor: AppColors.primaryPink,
                                value: isConditionAccept,
                                onChanged: (value) {
                                  setState(() {
                                    isConditionAccept = value!;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: Get.width / 1.3,
                              child: Text(
                                St.iAcceptAllTermsAndConditionForCancelOrderPolicy.tr,
                                overflow: TextOverflow.fade,
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.5,
                                  color: AppColors.darkGrey,
                                ),
                              ),
                            ),
                          ],
                        ),

                  widget.price! <= cancelOrderCharges! == true
                      ? SizedBox()
                      : isConditionAccept
                          ? PrimaryPinkButton(
                                  onTaped: getStorage.read("isDemoLogin") ?? false || isDemoSeller
                                      ? () => displayToast(message: St.thisIsDemoUser.tr)
                                      : () async {
                                          if (widget.price! <= cancelOrderCharges!) {
                                            displayToast(message: "You can't cancel this order because your order price is lower than the cancellation charge.");
                                          } else {
                                            await orderCancelByUserController.orderCancel();
                                            if (orderCancelByUserController.orderCancelByUser!.status == true) {
                                              displayToast(message: St.orderCancelled.tr);
                                              myOrderController.getProductDetails(selectCategory: "All");
                                              Get.back();
                                              Get.back();
                                            } else {
                                              displayToast(message: St.thisOrderIsAlreadyConfirmed.tr);
                                            }
                                          }
                                        },
                                  text: St.cancelOrder.tr)
                              .paddingOnly(top: 25)
                          : GestureDetector(
                              onTap: () => displayToast(message: St.acceptTermsAndConditions.tr),
                              child: Container(
                                height: 58,
                                decoration: BoxDecoration(color: AppColors.mediumGrey, borderRadius: BorderRadius.circular(24)),
                                child: Center(
                                  child: Text(
                                    St.cancelOrder.tr,
                                    style: GoogleFonts.plusJakartaSans(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ).paddingOnly(top: 25),
                ],
              ).paddingSymmetric(horizontal: 20),
            ),
          ),
        ),
        Obx(
          () => orderCancelByUserController.isLoading.value ? ScreenCircular.blackScreenCircular() : const SizedBox(),
        ),
      ],
    );
  }
}

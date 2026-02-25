import 'package:dotted_line/dotted_line.dart';
import 'package:era_shop/Controller/GetxController/user/my_order_controller.dart';
import 'package:era_shop/custom/main_button_widget.dart';
import 'package:era_shop/custom/preview_image_widget.dart';
import 'package:era_shop/user_pages/order_deatils_page/view/order_details_view.dart';
import 'package:era_shop/utils/CoustomWidget/App_theme_services/no_data_found.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_asset.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:era_shop/utils/globle_veriables.dart';

class ProcessingOrderView extends StatelessWidget {
  const ProcessingOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GetBuilder<MyOrderController>(builder: (MyOrderController myOrderController) {
        return myOrderController.myOrdersData?.orderData == null
            ? Center(child: noDataFound(image: "assets/no_data_found/closebox.png", text: St.noProductFound.tr))
            : ListView.builder(
                itemCount: myOrderController.myOrdersData?.orderData?.length ?? 0,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                itemBuilder: (context, index) {
                  final data = myOrderController.myOrdersData?.orderData?[index];
                  return GestureDetector(
                    onTap: () => Get.to(const OrderDetailsView()),
                    child: Container(
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
                                "INV #213546",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: AppFontStyle.styleW700(AppColors.unselected, 12),
                              ),
                              10.width,
                              MainButtonWidget(
                                height: 24,
                                width: 68,
                                color: AppColors.greyGreenBackground,
                                borderRadius: 5,
                                child: Text(
                                  "On Process",
                                  style: AppFontStyle.styleW500(AppColors.primary, 10),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                "24 Nov 2022",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: AppFontStyle.styleW500(AppColors.unselected, 10),
                              ),
                            ],
                          ),
                          for (int i = 0; i < index + 1; i++)
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: OrderProductItemWidget(
                                title: "Devils Wears",
                                description: "Kendow Premium T-shirt Most Popular",
                                sizes: const ["S", "M", "XL", "XXL"],
                                price: "560.00",
                                image: Utils.image,
                                callback: () {},
                              ),
                            ),
                          20.height,
                          DottedLine(dashColor: AppColors.unselected.withValues(alpha: 0.3)),
                          15.height,
                          Row(
                            children: [
                              Text(
                                "Total Amount",
                                style: AppFontStyle.styleW700(AppColors.unselected, 14),
                              ),
                              const Spacer(),
                              Text(
                                "$currencySymbol 640.00",
                                style: AppFontStyle.styleW900(AppColors.primary, 14),
                              ),
                            ],
                          ),
                          5.height,
                        ],
                      ),
                    ),
                  );
                },
              );
      }),
    );
  }
}

class OrderProductItemWidget extends StatelessWidget {
  const OrderProductItemWidget({
    super.key,
    required this.title,
    required this.description,
    required this.sizes,
    required this.price,
    required this.image,
    required this.callback,
  });

  final String title;
  final String description;
  final String image;
  final List sizes;
  final String price;
  final Callback callback;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        PreviewImageWidget(
          height: 95,
          width: 95,
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
              Text(
                description,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: AppFontStyle.styleW500(AppColors.unselected, 11),
              ),
              5.height,
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (int i = 0; i < sizes.length; i++)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        margin: const EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.unselected.withValues(alpha: 0.5)),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          sizes[i],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: AppFontStyle.styleW500(AppColors.unselected, 8),
                        ),
                      ),
                  ],
                ),
              ),
              7.height,
              Text(
                "$currencySymbol $price",
                style: AppFontStyle.styleW900(AppColors.primary, 16),
              ),
            ],
          ),
        ),
        Image.asset(AppAsset.icCircleArrowRight, width: 20),
      ],
    );
  }
}

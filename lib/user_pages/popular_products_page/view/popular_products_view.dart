import 'package:era_shop/user_pages/popular_products_page/controller/popular_products_controller.dart';
import 'package:era_shop/user_pages/popular_products_page/widget/popular_product_item.dart';
import 'package:era_shop/utils/CoustomWidget/App_theme_services/text_titles.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:era_shop/utils/shimmers.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PopularProductsView extends StatelessWidget {
  PopularProductsView({super.key});

  final controller = Get.put(PopularProductsController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (!controller.isLoading.value && controller.popularProducts.isEmpty) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GeneralTitle(title: St.popularProducts.tr),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed('/PopularProductViewAllScreen');
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Text(
                        St.viewAll.tr,
                        style: AppFontStyle.styleW700(AppColors.primary, 15),
                      ),
                    ),
                  )
                ],
              ),
              12.height,
              SizedBox(
                height: 230,
                width: Get.width,
                child: Obx(
                  () => controller.isLoading.value
                      ? Shimmers.listViewShortHomePage()
                      : controller.popularProducts.isEmpty
                          ? Container(
                              width: Get.width,
                              decoration: BoxDecoration(color: isDark.value ? AppColors.lightBlack : AppColors.dullWhite, borderRadius: BorderRadius.circular(15)),
                              child: Center(
                                child: Text(
                                  "No popular product available",
                                  style: AppFontStyle.styleW400(isDark.value ? AppColors.darkGrey : AppColors.mediumGrey, 15),
                                ),
                              ),
                            ).paddingSymmetric(horizontal: 15, vertical: 6)
                          : GetBuilder(
                              builder: (PopularProductsController controller) => ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: controller.popularProducts.take(10).length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final product = controller.popularProducts[index];
                                  return PopularProductItem(product: product);
                                },
                              ),
                            ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

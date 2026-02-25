import 'package:era_shop/Controller/GetxController/user/my_order_controller.dart';
import 'package:era_shop/custom/custom_color_bg_widget.dart';
import 'package:era_shop/custom/simple_app_bar_widget.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyOrderView extends StatelessWidget {
  const MyOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyOrderController());

    return CustomColorBgWidget(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.transparent,
            shadowColor: AppColors.transparent,
            surfaceTintColor: AppColors.transparent,
            flexibleSpace: SimpleAppBarWidget(title: St.myOrder.tr),
          ),
        ),
        body: Column(
          children: [
            15.height,
            Container(
              height: 45,
              width: Get.width,
              color: Colors.transparent,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 15),
              child: GetBuilder<MyOrderController>(
                id: "onChangeTab",
                builder: (controller) => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Align(
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.categories.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => controller.onChangeTab(index),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            margin: const EdgeInsets.only(right: 15),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: controller.selectedTabIndex == index ? AppColors.primary : AppColors.tabBackground,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              controller.categories[index],
                              overflow: TextOverflow.ellipsis,
                              style: AppFontStyle.styleW700(
                                  controller.selectedTabIndex == index ? AppColors.black : AppColors.unselected, 13),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            15.height,
            Expanded(
              child: GetBuilder<MyOrderController>(
                id: "onChangeTab",
                builder: (controller) => PageView.builder(
                  itemCount: controller.pages.length,
                  // onPageChanged: (value) => controller.onChangeTab(value),
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return controller.pages[controller.selectedTabIndex];
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

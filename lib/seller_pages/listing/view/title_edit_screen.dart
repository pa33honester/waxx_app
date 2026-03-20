import 'package:waxxapp/seller_pages/listing/controller/listing_controller.dart';
import 'package:waxxapp/seller_pages/listing/widget/listing_app_bar_widget.dart';
import 'package:waxxapp/seller_pages/listing/widget/title_form_filed.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TitleEditScreen extends StatelessWidget {
  const TitleEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: GetBuilder<ListingController>(
            builder: (controller) {
              return ListingAppBarWidget(
                title: St.title.tr,
                showCheckIcon: true,
                isCheckEnabled: controller.hasTitle,
                onCheckTap: () {
                  Get.back();
                },
              );
            },
          )),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: GetBuilder<ListingController>(
          builder: (controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  St.useWordsPeopleWouldSearchForWhenLookingForYourItem.tr,
                  style: AppFontStyle.styleW500(AppColors.unselected, 14),
                ),
                40.height,
                Text(
                  St.writeDescriptiveTitle.tr,
                  style: AppFontStyle.styleW500(AppColors.unselected, 12),
                ),
                8.height,
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: controller.titleController,
                  builder: (context, value, child) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      controller.update();
                    });
                    return TitleFormFiled(
                      controller: controller.titleController,
                      counterTextLength: controller.titleController.text.length,
                      maxLength: 80,
                    );
                  },
                ),
                8.height,
                // Text(
                //   "Subtitle (Optional)",
                //   style: AppFontStyle.styleW500(AppColors.unselected, 12),
                // ),
                // 12.height,
                // ValueListenableBuilder<TextEditingValue>(
                //   valueListenable: controller.subTitleController,
                //   builder: (context, value, child) {
                //     return TitleFormFiled(
                //       controller: controller.subTitleController,
                //       counterTextLength: controller.subTitleController.text.length,
                //       maxLength: 55,
                //     );
                //   },
                // ),
                // 10.height,
              ],
            );
          },
        ),
      ),
    );
  }
}

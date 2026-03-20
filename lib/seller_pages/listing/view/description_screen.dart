import 'package:waxxapp/seller_pages/listing/controller/listing_controller.dart';
import 'package:waxxapp/seller_pages/listing/widget/listing_app_bar_widget.dart';
import 'package:waxxapp/seller_pages/listing/widget/title_form_filed.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/app_constant.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DescriptionScreen extends StatelessWidget {
  const DescriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: GetBuilder<ListingController>(
            builder: (controller) {
              return ListingAppBarWidget(
                title: St.description.tr,
                showCheckIcon: true,
                isCheckEnabled: controller.hasDescription,
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
              children: [
                Text(
                  St.yourItemAndBeSureToIncludeAnyUniqueFeaturesOrFlaws.tr,
                  style: AppFontStyle.styleW500(AppColors.unselected, 14),
                ),
                10.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      St.productDescriptionAIAssisted.tr,
                      style: AppFontStyle.styleW500(AppColors.white, 14),
                    ),
                    6.width,
                    Obx(() {
                      return Switch(
                        value: controller.isAutoGenerateOn.value,
                        onChanged: (value) {
                          controller.toggleAutoGenerate(value);
                        },
                        activeColor: AppColors.primary,
                        inactiveThumbColor: AppColors.unselected,
                        inactiveTrackColor: AppColors.unselected.withValues(alpha: .45),
                      );
                    }),
                  ],
                ),
                10.height,
                GetBuilder<ListingController>(
                  id: AppConstant.idOpenAi,
                  builder: (controller) {
                    return
                        // controller.isLoading.value
                        //   ? Shimmers.description()
                        //   :
                        Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ValueListenableBuilder<TextEditingValue>(
                              valueListenable: controller.descriptionController,
                              builder: (context, value, child) {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  controller.update();
                                });
                                return TitleFormFiled(
                                  controller: controller.descriptionController,
                                  maxLines: controller.isAutoGenerateOn.value ? 8 : 6,
                                  hintText: St.theMoreDetailsTheBetterAGreatItemDescription.tr,
                                  onChanged: (value) async {
                                    if (controller.isAutoGenerateOn.value) {
                                      await Future.delayed(const Duration(milliseconds: 1500));
                                      if (controller.isAutoGenerateOn.value && controller.validateRequiredFieldsForDes()) {
                                        controller.generateDescription();
                                      }
                                    }
                                    controller.update();
                                    // if (controller.isAutoGenerateOn.value) {
                                    //   await Future.delayed(const Duration(milliseconds: 1000));
                                    //   if (controller.isAutoGenerateOn.value) {
                                    //     controller.generateDescription(value);
                                    //   }
                                    // }
                                  },
                                );
                              }),
                        ),
                        if (controller.isAutoGenerateOn.value) ...{
                          12.width,
                          Obx(
                            () {
                              return controller.isLoading.value && controller.isAutoGenerateOn.value
                                  ? SizedBox(
                                      width: 28,
                                      height: 28,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () async {
                                        if (controller.isAutoGenerateOn.value) {
                                          await Future.delayed(const Duration(milliseconds: 1500));
                                          if (controller.isAutoGenerateOn.value && controller.validateRequiredFieldsForDes()) {
                                            controller.generateDescription();
                                          }
                                        }
                                      },
                                      child: Icon(
                                        Icons.refresh,
                                        color: AppColors.unselected,
                                        size: 28,
                                      ),
                                    );
                            },
                          ),
                        },
                      ],
                    );
                  },
                ),
                // TitleFormFiled(
                //   controller: controller.descriptionController,
                //   maxLines: 4,
                //   hintText: St.theMoreDetailsTheBetterAGreatItemDescription.tr,
                // ),
              ],
            );
          },
        ),
      ),
    );
  }
}

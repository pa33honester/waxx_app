import 'package:waxxapp/seller_pages/listing/controller/listing_controller.dart';
import 'package:waxxapp/seller_pages/listing/widget/listing_app_bar_widget.dart';
import 'package:waxxapp/seller_pages/listing/widget/title_form_filed.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: ListingAppBarWidget(
          title: St.offers.tr,
        ),
      ),
      body: GetBuilder<ListingController>(builder: (controller) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(St.buyersInterestedInYourItemCanMakeYouOffers.tr, style: AppFontStyle.styleW500(AppColors.unselected, 13)),
              const SizedBox(height: 30),
              _buildOfferOption(
                isSelected: !controller.isOffersAllowed,
                title: St.dontAllowOffers.tr,
                description: St.allowingOffersIncreasesYourChance.tr,
                onTap: () => controller.setOffersAllowed(false),
              ),
              const SizedBox(height: 20),

              // Allow offers option
              _buildOfferOption(
                isSelected: controller.isOffersAllowed,
                title: St.allowOffers.tr,
                description: St.seeAllOffersOrIfYouWantSetUpRulesForWhenYouWillReviewOrAcceptOffers.tr,
                onTap: () => controller.setOffersAllowed(true),
              ),

              // Minimum offer amount section
              if (controller.isOffersAllowed) ...[
                const SizedBox(height: 30),
                _buildMinimumOfferSection(controller),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildOfferOption({
    required bool isSelected,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.unselected,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 24,
              height: 24,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.unselected,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Icon(
                      Icons.circle,
                      size: 14,
                      color: AppColors.primary,
                    )
                  : null,
            ),
            16.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppFontStyle.styleW600(Colors.white, 16),
                  ),
                  6.height,
                  Text(description, style: AppFontStyle.styleW500(AppColors.unselected, 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMinimumOfferSection(ListingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // GestureDetector(
        //   onTap: () => controller.toggleMinimumOfferAmount(!controller.hasMinimumOfferAmount),
        //   child: Row(
        //     children: [
        //       Container(
        //         width: 24,
        //         height: 24,
        //         decoration: BoxDecoration(
        //           color: controller.hasMinimumOfferAmount ? AppColors.primary : Colors.transparent,
        //           border: Border.all(
        //             color: controller.hasMinimumOfferAmount ? AppColors.primary : Colors.grey[500]!,
        //             width: 2,
        //           ),
        //           borderRadius: BorderRadius.circular(4),
        //         ),
        //         child: controller.hasMinimumOfferAmount
        //             ? const Icon(
        //                 Icons.check,
        //                 size: 16,
        //                 color: Colors.black,
        //               )
        //             : null,
        //       ),
        //       12.width,
        Text(St.offerPrice.tr, style: AppFontStyle.styleW600(Colors.white, 16)),
        //     ],
        //   ),
        // ),
        // if (controller.hasMinimumOfferAmount) ...[
        const SizedBox(height: 20),
        Row(
          children: [
            Container(
              height: 53,
              width: 55,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
              ),
              child: Text("$currencySymbol", style: AppFontStyle.styleW700(AppColors.black, 28)),
            ),
            Expanded(
              child: TextFormField(
                  cursorColor: AppColors.unselected,
                  style: AppFontStyle.styleW700(AppColors.white, 15),
                  controller: controller.minimumOfferAmountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.tabBackground,
                    hintText: St.enterOfferPrice.tr,
                    hintStyle: AppFontStyle.styleW500(AppColors.unselected.withValues(alpha: .6), 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  )),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waxxapp/ApiService/seller/promo_code_list_service.dart';
import 'package:waxxapp/seller_pages/listing/controller/listing_controller.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/utils.dart';

// Single source of truth for the multi-select promo code bottom sheet.
// Both the listing summary card and the pricing flow open this so the
// two stay in sync.
Future<void> openPromoCodePicker(ListingController controller) async {
  await controller.loadPromoCodes();

  Get.bottomSheet(
    Container(
      color: AppColors.black,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Promo Codes', style: AppFontStyle.styleW700(AppColors.white, 16)),
            8.height,
            Text(
              'Pick the promo codes that apply to this listing. Buyers using a code at checkout get the matching discount.',
              style: AppFontStyle.styleW400(AppColors.unselected, 12),
            ),
            16.height,
            Obx(() {
              if (controller.isLoadingPromoCodes.value) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final options = controller.availablePromoCodes;
              if (options.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Center(
                    child: Text(
                      'No promo codes are configured by the admin yet.',
                      style: AppFontStyle.styleW500(AppColors.unselected, 13),
                    ),
                  ),
                );
              }
              return ConstrainedBox(
                constraints: BoxConstraints(maxHeight: Get.height * 0.55),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: options.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.white10),
                  itemBuilder: (_, i) => PromoCodeRow(option: options[i], controller: controller),
                ),
              );
            }),
            12.height,
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Get.back(),
                child: Text('Done', style: AppFontStyle.styleW700(AppColors.primary, 14)),
              ),
            ),
          ],
        ),
      ),
    ),
    backgroundColor: AppColors.black,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
  );
}

class PromoCodeRow extends StatelessWidget {
  const PromoCodeRow({super.key, required this.option, required this.controller});

  final PromoCodeOption option;
  final ListingController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = controller.selectedPromoCodeIds.contains(option.id);
      return InkWell(
        onTap: () => controller.togglePromoCode(option.id),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Icon(
                selected ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                color: selected ? AppColors.primary : AppColors.unselected,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(option.code, style: AppFontStyle.styleW700(AppColors.white, 14)),
                    if (option.discountLabel.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(option.discountLabel, style: AppFontStyle.styleW500(AppColors.unselected, 11)),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

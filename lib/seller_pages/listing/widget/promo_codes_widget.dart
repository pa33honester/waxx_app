import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waxxapp/seller_pages/listing/controller/listing_controller.dart';
import 'package:waxxapp/seller_pages/listing/widget/container_widget.dart';
import 'package:waxxapp/seller_pages/listing/widget/list_title.dart';
import 'package:waxxapp/seller_pages/listing/widget/promo_code_picker.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/utils.dart';

class PromoCodesWidget extends StatelessWidget {
  const PromoCodesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: GetBuilder<ListingController>(
        builder: (controller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              15.height,
              ListTitle(
                title: 'Promo Codes',
                onTap: () => openPromoCodePicker(controller),
                showCheckIcon: controller.selectedPromoCodeIds.isNotEmpty,
              ),
              22.height,
              Obx(() {
                final ids = controller.selectedPromoCodeIds;
                if (ids.isEmpty) {
                  return ContainerWidget(
                    onTap: () => openPromoCodePicker(controller),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.local_offer_outlined, color: AppColors.unselected, size: 18),
                        10.width,
                        Expanded(
                          child: Text(
                            'Tap to attach promo codes (optional)',
                            style: AppFontStyle.styleW500(AppColors.unselected, 10),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final byId = {for (final p in controller.availablePromoCodes) p.id: p};
                final summary = ids.map((id) => byId[id]?.code ?? '…').join(', ');

                return ContainerDataWidget(
                  tap: () => openPromoCodePicker(controller),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Icon(Icons.local_offer, color: AppColors.primary, size: 18),
                      10.width,
                      Expanded(
                        child: Text(
                          summary,
                          style: AppFontStyle.styleW600(AppColors.white, 13),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      8.width,
                      Text(
                        '${ids.length}',
                        style: AppFontStyle.styleW700(AppColors.primary, 13),
                      ),
                    ],
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

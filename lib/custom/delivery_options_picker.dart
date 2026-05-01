import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waxxapp/ApiService/user/update_cart_delivery_option_service.dart';
import 'package:waxxapp/Controller/GetxController/user/get_all_cart_products_controller.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/database.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';

/// Shape B (v1.0.10/11) per-item shipping-option picker. One pill per
/// option offered by the seller with the option's price. Tapping a pill
/// optimistically marks it selected, calls cart/updateDeliveryOption,
/// and refetches the cart so totals re-aggregate.
///
/// Used by the Cart page (under each line item) and the Checkout page
/// (next to each Order Info row), so the buyer can flip their choice
/// at either step. The list is empty for legacy products with only
/// `shippingCharges` + `deliveryType`, in which case the widget renders
/// nothing.
class DeliveryOptionsPicker extends StatelessWidget {
  const DeliveryOptionsPicker({
    super.key,
    required this.deliveryOptions,
    required this.chosenDeliveryType,
    required this.productId,
    required this.attributesArray,
  });

  final List<dynamic>? deliveryOptions;
  final String? chosenDeliveryType;
  final String productId;
  final List<dynamic> attributesArray;

  @override
  Widget build(BuildContext context) {
    final options = deliveryOptions ?? const [];
    if (options.isEmpty) return const SizedBox.shrink();

    final cartCtrl = Get.find<GetAllCartProductController>();

    String label(String type) {
      switch (type) {
        case 'local':
          return St.deliveryLocal.tr;
        case 'nationwide':
          return St.deliveryNationwide.tr;
        case 'international':
          return St.deliveryInternational.tr;
      }
      return type;
    }

    // Wrapped in Obx so that taps re-enable as soon as the cart's
    // `updateLoading` flips back to false after the refetch — without
    // this the GetBuilder rebuild fires while updateLoading is still
    // true (the controller's `update()` call lands BEFORE the finally
    // block resets the flag), and the pills ended up frozen with
    // `onTap: null` until some other event triggered a rebuild.
    return Obx(() {
      final loading = cartCtrl.updateLoading.value;
      return Wrap(
        spacing: 6,
        runSpacing: 6,
        children: options.map<Widget>((opt) {
          final type = opt.type as String?;
          final price = opt.price;
          if (type == null) return const SizedBox.shrink();
          final isSelected = chosenDeliveryType == type;
          return GestureDetector(
            onTap: isSelected || loading
                ? null
                : () async {
                    cartCtrl.updateLoading.value = true;
                    final updated = await UpdateCartDeliveryOptionService.update(
                      userId: Database.loginUserId,
                      productId: productId,
                      chosenDeliveryType: type,
                      attributesArray: attributesArray,
                    );
                    if (updated != null) {
                      await cartCtrl.getCartProductData(updatedData: true);
                    } else {
                      cartCtrl.updateLoading.value = false;
                    }
                  },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary, width: 1),
              ),
              child: Text(
                "${label(type)} • $currencySymbol$price",
                style: AppFontStyle.styleW600(
                  isSelected ? AppColors.black : AppColors.primary,
                  11,
                ),
              ),
            ),
          );
        }).toList(),
      );
    });
  }
}

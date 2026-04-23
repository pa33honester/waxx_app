import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showAutoBidDialog({
  required String productId,
  required num currentHighestBid,
  required num minimumBidPrice,
  required List<dynamic> attributes,
  required Future<void> Function({
    required String userId,
    required String productId,
    required String maxBidAmount,
    required List<dynamic> attributes,
  }) onSetAutoBid,
  required Future<void> Function() onCancelAutoBid,
  num? existingMaxBid,
}) {
  final maxBidController = TextEditingController(
    text: existingMaxBid != null && existingMaxBid > 0 ? existingMaxBid.toString() : '',
  );
  final formKey = GlobalKey<FormState>();

  Get.dialog(
    Dialog(
      backgroundColor: AppColors.tabBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.bolt_rounded, color: AppColors.primary, size: 24),
                  const SizedBox(width: 8),
                  Text('Set Max Bid', style: AppFontStyle.styleW700(AppColors.white, 18)),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.black.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    _InfoRow(label: 'Current highest bid', value: '$currencySymbol $currentHighestBid'),
                    const SizedBox(height: 8),
                    _InfoRow(label: 'Minimum bid', value: '$currencySymbol $minimumBidPrice'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Your max bid',
                style: AppFontStyle.styleW700(AppColors.white, 14),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: maxBidController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: TextStyle(color: AppColors.white, fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Enter max bid amount',
                  hintStyle: TextStyle(color: AppColors.unselected),
                  prefixText: '$currencySymbol ',
                  prefixStyle: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                  filled: true,
                  fillColor: AppColors.black.withValues(alpha: 0.4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.unselected.withValues(alpha: 0.3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.unselected.withValues(alpha: 0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Enter an amount';
                  final amount = num.tryParse(val.trim());
                  if (amount == null) return 'Enter a valid number';
                  if (amount <= currentHighestBid) {
                    return 'Must be higher than current bid ($currencySymbol $currentHighestBid)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              Text(
                'We\'ll auto-bid on your behalf up to this amount.',
                style: AppFontStyle.styleW500(AppColors.unselected, 12),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  if (existingMaxBid != null && existingMaxBid > 0) ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          Get.back();
                          await onCancelAutoBid();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.red,
                          side: BorderSide(color: AppColors.red),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text('Cancel Auto-Bid', style: AppFontStyle.styleW700(AppColors.red, 13)),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState?.validate() != true) return;
                        Get.back();
                        await onSetAutoBid(
                          userId: loginUserId,
                          productId: productId,
                          maxBidAmount: maxBidController.text.trim(),
                          attributes: attributes,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text('Set Max Bid', style: AppFontStyle.styleW700(AppColors.black, 13)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppFontStyle.styleW500(AppColors.unselected, 13)),
        Text(value, style: AppFontStyle.styleW700(AppColors.white, 13)),
      ],
    );
  }
}

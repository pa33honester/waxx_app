import 'package:era_shop/utils/app_colors.dart';
import 'package:flutter/material.dart';

class SelectProductRadioBtnUi extends StatelessWidget {
  const SelectProductRadioBtnUi({super.key, required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      color: AppColors.transparent,
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? AppColors.primary : AppColors.transparent,
            ),
            child: Container(
              height: 24,
              width: 24,
              margin: const EdgeInsets.all(1.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? null : AppColors.coloGreyText,
                border: Border.all(
                  color: isSelected ? AppColors.white : AppColors.primary.withOpacity(0.5),
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

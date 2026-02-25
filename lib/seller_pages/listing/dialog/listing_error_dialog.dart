import 'package:era_shop/custom/main_button_widget.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListingErrorsDialog extends StatelessWidget {
  final List<String> missingFields;

  const ListingErrorsDialog({
    super.key,
    required this.missingFields,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                St.listingErrors.tr,
                style: AppFontStyle.styleW700(Colors.black, 24),
              ),
              16.height,
              Text(
                St.oopsLooksLikeYouMissedSomethingPleaseFixTheProblemBelow.tr,
                style: AppFontStyle.styleW400(Colors.grey[600]!, 16),
              ),
              20.height,
              Text(
                _buildMissingFieldsText(),
                style: AppFontStyle.styleW600(Colors.black, 18),
                textAlign: TextAlign.left,
              ),
              24.height,
              Align(
                alignment: Alignment.centerRight,
                child: MainButtonWidget(
                  height: 54,
                  callback: () {
                    Get.back();
                  },
                  child: Text(
                    St.ok.tr,
                    style: AppFontStyle.styleW700(AppColors.black, 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _buildMissingFieldsText() {
    if (missingFields.isEmpty) return '';

    if (missingFields.length == 1) {
      return missingFields.first;
    } else if (missingFields.length == 2) {
      return '${missingFields[0]} and ${missingFields[1]}';
    } else {
      String allButLast = missingFields.sublist(0, missingFields.length - 1).join(', ');
      return '$allButLast, and ${missingFields.last}';
    }
  }
}

// Helper function to show the dialog
void showListingErrorsDialog(List<String> missingFields) {
  Get.dialog(
    ListingErrorsDialog(missingFields: missingFields),
    barrierDismissible: true,
  );
}

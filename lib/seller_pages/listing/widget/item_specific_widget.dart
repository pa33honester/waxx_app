import 'package:waxxapp/seller_pages/listing/controller/listing_controller.dart';
import 'package:waxxapp/seller_pages/listing/widget/container_widget.dart';
import 'package:waxxapp/seller_pages/listing/widget/list_title.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemSpecificWidget extends StatelessWidget {
  const ItemSpecificWidget({super.key});

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
                title: St.itemSpecific.tr,
                onTap: () {
                  if (!controller.hasCategory) {
                    Utils.showToast(St.pleaseSelectTheCategoryFirst.tr);
                  } else {
                    Get.toNamed("/ItemSpecific")?.then(
                      (value) => controller.update(),
                    );
                  }
                },
                showCheckIcon: controller.hasItemSpecific,
              ),
              22.height,
              _buildAttributesSummary(controller),
              // controller.titleController.text.isNotEmpty
              //     ? Text(
              //         controller.titleController.text,
              //         style: AppFontStyle.styleW800(AppColors.white, 16),
              //       )
              //     : Row(
              //         children: [
              //           Icon(
              //             Icons.info,
              //             color: AppColors.unselected,
              //           ),
              //           10.width,
              //           Text(
              //             "Additional specific are required",
              //             style: AppFontStyle.styleW500(AppColors.unselected, 10),
              //           )
              //         ],
              //       ),
            ],
          );
        },
      ),
    );
  }

  _buildAttributesSummary(ListingController controller) {
    if (controller.attributeValues.isEmpty) {
      return ContainerWidget(
        onTap: () {
          if (!controller.hasCategory) {
            Utils.showToast(St.pleaseSelectTheCategoryFirst.tr);
          } else {
            Get.toNamed("/ItemSpecific")?.then(
              (value) => controller.update(),
            );
          }
        },
        child: Row(
          children: [
            Icon(
              Icons.info,
              color: AppColors.unselected,
              size: 18,
            ),
            10.width,
            Text(
              St.additionalSpecificAreRequired.tr,
              style: AppFontStyle.styleW500(AppColors.unselected, 10),
            )
          ],
        ),
      );
    }
    final selectedSubCategoryId = controller.selectedSubCategoryId;
    final relevantAttributes = controller.fetchCategorySubAttrModel?.attributes?.where((attr) => attr.subCategory == selectedSubCategoryId).toList() ?? [];

    List<Widget> attributeWidgets = [];

    for (var attributeData in relevantAttributes) {
      final attributes = attributeData.attributes ?? [];
      for (var attribute in attributes) {
        final attributeName = attribute.name ?? '';
        final attributeValue = controller.getAttributeValue(attributeName);

        if (controller.isAttributeValueValid(attributeValue)) {
          attributeWidgets.add(_buildAttributeItem(attributeName, attributeValue, attribute.fieldType ?? 1));
        }
      }
    }

    if (attributeWidgets.isEmpty) {
      return ContainerWidget(
        onTap: () {
          if (!controller.hasCategory) {
            Utils.showToast(St.pleaseSelectTheCategoryFirst.tr);
          } else {
            Get.toNamed("/ItemSpecific")?.then(
              (value) => controller.update(),
            );
          }
        },
        child: Row(
          children: [
            Icon(
              Icons.info,
              color: AppColors.unselected,
            ),
            10.width,
            Text(
              St.additionalSpecificAreRequired.tr,
              style: AppFontStyle.styleW500(AppColors.unselected, 10),
            )
          ],
        ),
      );
    }

    return ContainerDataWidget(
      tap: () {
        if (!controller.hasCategory) {
          Utils.showToast(St.pleaseSelectTheCategoryFirst.tr);
        } else {
          Get.toNamed("/ItemSpecific")?.then(
            (value) => controller.update(),
          );
        }
      },
      padding: EdgeInsets.only(top: 18, left: 16, right: 16, bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: attributeWidgets,
      ),
    );
  }

  Widget _buildAttributeItem(String attributeName, dynamic attributeValue, int fieldType) {
    String displayValue = '';

    switch (fieldType) {
      case 1: // Text Input
      case 2: // Number Input
      case 4: // Radio
      case 5: // Dropdown
        if (attributeValue is List) {
          displayValue = attributeValue.join(', ');
        } else {
          displayValue = attributeValue.toString();
        }
        break;
      case 3: // File Input
        displayValue = attributeValue.toString().split('/').last;
        break;
      case 6: // Checkboxes (List)
        if (attributeValue is List) {
          displayValue = attributeValue.join(', ');
        } else {
          displayValue = attributeValue.toString();
        }
        break;
      default:
        displayValue = attributeValue.toString();
    }

    if (displayValue.isEmpty || displayValue == 'null') {
      return SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              attributeName,
              style: AppFontStyle.styleW500(AppColors.unselected, 12),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              ":",
              style: AppFontStyle.styleW600(AppColors.white, 12),
            ),
          ),
          Expanded(
            flex: 3,
            child: fieldType == 6 // Checkboxes
                ? Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: _buildCheckboxTags(attributeValue),
                  )
                : Text(
                    displayValue,
                    style: AppFontStyle.styleW600(AppColors.white, 13),
                  ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCheckboxTags(dynamic attributeValue) {
    if (attributeValue is List) {
      return (attributeValue).map((value) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.4),
              width: 1,
            ),
          ),
          child: Text(
            value.toString(),
            style: AppFontStyle.styleW500(AppColors.primary, 11),
          ),
        );
      }).toList();
    }
    return [];
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:era_shop/seller_pages/listing/controller/listing_controller.dart';
import 'package:era_shop/seller_pages/listing/widget/listing_app_bar_widget.dart';
import 'package:era_shop/utils/CoustomWidget/App_theme_services/no_data_found.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/api_url.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemSpecificScreen extends StatefulWidget {
  const ItemSpecificScreen({super.key});

  @override
  State<ItemSpecificScreen> createState() => _ItemSpecificScreenState();
}

class _ItemSpecificScreenState extends State<ItemSpecificScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: GetBuilder<ListingController>(
            builder: (controller) {
              return ListingAppBarWidget(
                title: St.itemSpecific.tr,
                showCheckIcon: true,
                isCheckEnabled: controller.hasItemSpecific,
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
            controller.initializeTextControllers();

            final selectedSubCategoryId = controller.selectedSubCategoryId;
            final relevantAttributes = controller.fetchCategorySubAttrModel?.attributes?.where((attr) => attr.subCategory == selectedSubCategoryId).toList() ?? [];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                relevantAttributes.isEmpty
                    ? Expanded(
                        child: Center(
                            child: noDataFound(
                          image: "assets/no_data_found/basket.png",
                        )),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: relevantAttributes.length,
                          itemBuilder: (context, index) {
                            final attributeData = relevantAttributes[index];
                            final attributes = attributeData.attributes ?? [];

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: attributes.map((attribute) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 30),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (attribute.isActive == true)
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(22),
                                                  child: CachedNetworkImage(
                                                    imageUrl: '${Api.baseUrl}${attribute.image}',
                                                    height: 26,
                                                    width: 26,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                12.width,
                                                Text(
                                                  attribute.name ?? "",
                                                  style: AppFontStyle.styleW600(AppColors.white, 16),
                                                ),
                                                if (attribute.isRequired == true)
                                                  Text(
                                                    " *",
                                                    style: AppFontStyle.styleW600(Colors.red, 16),
                                                  ),
                                              ],
                                            ),
                                            10.height,
                                            _buildAttributeField(controller, attribute),
                                          ],
                                        ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAttributeField(ListingController controller, dynamic attribute) {
    final fieldType = attribute.fieldType;

    switch (fieldType) {
      case 1: // Text Input
        return TextFormField(
          controller: controller.getTextController(attribute.name),
          style: AppFontStyle.styleW500(AppColors.white, 15),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.tabBackground,
            hintText: "Enter ${attribute.name}",
            hintStyle: AppFontStyle.styleW500(AppColors.unselected.withValues(alpha: 0.5), 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          maxLength: attribute.maxLength > 0 ? attribute.maxLength : null,
          onChanged: (value) {
            controller.updateAttributeValue(attribute.name, value);
          },
        );

      case 2: // Number Input
        return TextFormField(
          controller: controller.getTextController(attribute.name),
          keyboardType: TextInputType.number,
          style: AppFontStyle.styleW500(AppColors.white, 15),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.tabBackground,
            hintText: "Enter ${attribute.name}",
            hintStyle: AppFontStyle.styleW500(AppColors.unselected.withValues(alpha: 0.5), 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (value) {
            controller.updateAttributeValue(attribute.name, value);
          },
        );

      case 3: // File Input
        final existingFileValue = controller.getAttributeValue(attribute.name);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () async {
                await controller.pickFile();
                if (controller.selectedFile != null) {
                  final fileName = controller.selectedFile!.name;
                  controller.updateAttributeValue(attribute.name, fileName);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(1),
                child: DottedBorder(
                  options: RoundedRectDottedBorderOptions(
                    strokeWidth: 1,
                    color: AppColors.unselected,
                    padding: EdgeInsets.all(14),
                    radius: Radius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        color: AppColors.unselected,
                      ),
                      Text(
                        'Add File',
                        style: AppFontStyle.styleW500(AppColors.unselected, 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (controller.selectedFile != null) ...{
              22.height,
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.unselected),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.insert_drive_file, color: Colors.blue, size: 34),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.selectedFile?.name ?? '',
                          style: AppFontStyle.styleW600(AppColors.white, 14),
                        ),
                        Text(
                          '${(controller.selectedFile?.size ?? 0 / 1024).toStringAsFixed(0)} KB',
                          style: AppFontStyle.styleW500(
                            AppColors.unselected,
                            10,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        controller.clearFile();
                        controller.updateAttributeValue(attribute.name, null);
                      },
                      child: Icon(
                        Icons.close,
                        color: AppColors.unselected,
                        size: 26,
                      ),
                    )
                  ],
                ),
              ),
            },
            8.height,
            Text(
              'Allowed file types: PNG, JPG, JPEG, SVG, PDF',
              style: TextStyle(fontSize: 12, color: AppColors.primaryRed),
            ),
          ],
        );

      case 4: // Radio Input with Expand/Collapse
        final selectedValue = controller.getAttributeValue(attribute.name);
        final isExpanded = controller.isPanelExpanded(attribute.name ?? '');

        return Container(
          decoration: BoxDecoration(
            color: AppColors.tabBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => controller.togglePanel(attribute.name ?? ''),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.tabBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Select ${attribute.name}",
                            style: AppFontStyle.styleW500(AppColors.unselected, 14),
                          ),
                          if (selectedValue != null && selectedValue.isNotEmpty) ...[
                            4.height,
                            Text(
                              selectedValue,
                              style: AppFontStyle.styleW400(AppColors.primary, 12),
                            ),
                          ],
                        ],
                      ),
                      AnimatedRotation(
                        turns: isExpanded ? 0.5 : 0,
                        duration: Duration(milliseconds: 300),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.unselected,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedSize(
                duration: Duration(milliseconds: 300),
                child: isExpanded
                    ? Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: (attribute.values as List<dynamic>?)?.map<Widget>((value) {
                                final valueStr = value.toString();
                                final isSelected = selectedValue == valueStr;

                                return GestureDetector(
                                  onTap: () {
                                    controller.updateAttributeValue(attribute.name, isSelected ? null : valueStr);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: isSelected ? AppColors.primary : AppColors.tabBackground.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: isSelected ? AppColors.primary : AppColors.unselected.withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      valueStr.capitalizeFirst ?? '',
                                      style: AppFontStyle.styleW500(
                                        isSelected ? AppColors.black : AppColors.unselected,
                                        14,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList() ??
                              [],
                        ),
                      )
                    : SizedBox.shrink(),
              ),
            ],
          ),
        );

      case 5: // Dropdown
        final currentValues = controller.getAttributeValue(attribute.name) as List<String>? ?? [];
        final isExpanded = controller.isPanelExpanded(attribute.name ?? '');
        return Container(
          decoration: BoxDecoration(
            color: AppColors.tabBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => controller.togglePanel(attribute.name ?? ''),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.tabBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Select ${attribute.name}",
                            style: AppFontStyle.styleW500(AppColors.unselected, 14),
                          ),
                          if (currentValues.isNotEmpty) ...[
                            4.height,
                            Text(
                              "${currentValues.length} selected",
                              style: AppFontStyle.styleW400(AppColors.primary, 12),
                            ),
                          ],
                        ],
                      ),
                      AnimatedRotation(
                        turns: isExpanded ? 0.5 : 0,
                        duration: Duration(milliseconds: 300),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.unselected,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedSize(
                duration: Duration(milliseconds: 300),
                child: isExpanded
                    ? Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        child: _buildAttributeContent(controller, attribute),
                      )
                    : SizedBox.shrink(),
              ),
            ],
          ),
        );

      /* return Container(
          decoration: BoxDecoration(
            color: AppColors.tabBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonFormField<String>(
            dropdownColor: AppColors.tabBackground,
            style: AppFontStyle.styleW500(AppColors.white, 15),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            hint: Text(
              "Select ${attribute.name}",
              style: AppFontStyle.styleW500(AppColors.unselected.withValues(alpha: 0.5), 15),
            ),
            value: controller.getAttributeValue(attribute.name),
            items: (attribute.values as List<dynamic>?)?.map<DropdownMenuItem<String>>((value) {
              return DropdownMenuItem<String>(
                value: value.toString(),
                child: Text(
                  value.toString(),
                  style: AppFontStyle.styleW500(AppColors.white, 15),
                ),
              );
            }).toList(),
            onChanged: (value) {
              controller.updateAttributeValue(attribute.name, value);
            },
          ),
        );*/

      case 6: // Checkboxes
        final currentValues = controller.getAttributeValue(attribute.name) as List<String>? ?? [];
        final isExpanded = controller.isPanelExpanded(attribute.name ?? '');

        return Container(
          decoration: BoxDecoration(
            color: AppColors.tabBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => controller.togglePanel(attribute.name ?? ''),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.tabBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Select ${attribute.name}",
                            style: AppFontStyle.styleW500(AppColors.unselected, 14),
                          ),
                          if (currentValues.isNotEmpty) ...[
                            4.height,
                            Text(
                              "${currentValues.length} selected",
                              style: AppFontStyle.styleW400(AppColors.primary, 12),
                            ),
                          ],
                        ],
                      ),
                      AnimatedRotation(
                        turns: isExpanded ? 0.5 : 0,
                        duration: Duration(milliseconds: 300),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.unselected,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedSize(
                duration: Duration(milliseconds: 300),
                child: isExpanded
                    ? Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        child: _buildAttributeContent(controller, attribute),
                      )
                    : SizedBox.shrink(),
              ),
            ],
          ),
        );

      default:
        return TextFormField(
          style: AppFontStyle.styleW500(AppColors.white, 15),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.tabBackground,
            hintText: "Enter ${attribute.name}",
            hintStyle: AppFontStyle.styleW500(AppColors.unselected.withValues(alpha: 0.5), 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (value) {
            controller.updateAttributeValue(attribute.name, value);
          },
        );
    }
  }

  Widget _buildAttributeContent(ListingController controller, dynamic attribute) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: (attribute.values as List<dynamic>?)?.map<Widget>((value) {
            return _buildTextChip(controller, value.toString(), attribute);
          }).toList() ??
          [],
    );
  }

  Widget _buildTextChip(ListingController controller, String value, dynamic attribute) {
    final currentValues = controller.getAttributeValue(attribute.name) as List<String>? ?? [];
    final isSelected = currentValues.contains(value);

    return GestureDetector(
      onTap: () {
        final updatedValues = List<String>.from(currentValues);
        if (isSelected) {
          updatedValues.remove(value);
        } else {
          // final maxSelections = attribute.maxSelections;
          final maxSelections = 4;
          // if (updatedValues.length < maxSelections) {
          updatedValues.add(value);
          // } else {
          //   Utils.showToast("You can select maximum $maxSelections options");
          //   return;
          // }
        }
        controller.updateAttributeValue(attribute.name, updatedValues);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.tabBackground.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.unselected.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // if (isSelected) ...[
            //   Icon(
            //     Icons.check_circle,
            //     size: 16,
            //     color: AppColors.black,
            //   ),
            //   6.width,
            // ],
            Text(
              value,
              style: AppFontStyle.styleW500(
                isSelected ? AppColors.black : AppColors.unselected,
                14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

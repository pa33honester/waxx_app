import 'dart:io';

import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:waxxapp/Controller/GetxController/seller/add_product_controller.dart';
import 'package:waxxapp/custom/custom_color_bg_widget.dart';
import 'package:waxxapp/custom/custom_step_widget.dart';
import 'package:waxxapp/custom/main_button_widget.dart';
import 'package:waxxapp/custom/simple_app_bar_widget.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_asset.dart';
import 'package:waxxapp/utils/app_circular.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/show_toast.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../Controller/GetxController/seller/attributes_add_product_controller.dart';
import '../../../Controller/GetxController/user/get_all_category_controller.dart';

class SellerVerifyProductView extends StatefulWidget {
  const SellerVerifyProductView({super.key});

  @override
  State<SellerVerifyProductView> createState() => _SellerVerifyProductViewState();
}

class _SellerVerifyProductViewState extends State<SellerVerifyProductView> {
  final bool? isNavigate = Get.arguments;
  AddProductController addProductController = Get.put(AddProductController());
  GetAllCategoryController getAllCategoryController = Get.put(GetAllCategoryController());
  AttributesAddProductController attributesAddProductController = Get.put(AttributesAddProductController());

  final categoryDropdownController = DropdownController();
  final subcategoryDropdownController = DropdownController();

  final pageController = PageController();

  int? productCurrentIndex;
  bool isOpen = false;

  /// IMAGE PICKER \\\
  XFile? xFiles;
  final ImagePicker productPick = ImagePicker();

  productPickFromGallery() async {
    xFiles = await productPick.pickImage(source: ImageSource.gallery, imageQuality: 100);
    setState(() {
      addProductController.productImageXFile = File(xFiles!.path);
      addProductController.addProductImages.add(addProductController.productImageXFile!);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      attributesAddProductController.getAttributesData();
      getAllCategoryController.getCategory();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getAllCategoryController.subcategoryDropdownItems = getAllCategoryController.subCategoryList.map<CoolDropdownItem<String>>((subCategory) {
      return CoolDropdownItem<String>(
        value: subCategory.id.toString(),
        label: subCategory.name.toString(),
      );
    }).toList();

    return Stack(
      children: [
        CustomColorBgWidget(
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: AppColors.transparent,
                surfaceTintColor: AppColors.transparent,
                flexibleSpace: const SimpleAppBarWidget(title: "Product Details"),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    15.height,
                    CustomStepWidget(
                      step: 3,
                      selectedColor: AppColors.primary,
                      unselectedColor: AppColors.tabBackground,
                    ),
                    15.height,
                    Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: AppColors.tabBackground,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            clipBehavior: Clip.antiAlias,
                            height: 420,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
                            child: Stack(
                              alignment: Alignment.center,
                              fit: StackFit.expand,
                              children: [
                                PageView.builder(
                                  controller: addProductController.pageController,
                                  itemCount: addProductController.addProductImages.length,
                                  onPageChanged: (value) {},
                                  itemBuilder: (context, index) {
                                    final indexData = addProductController.addProductImages[index];
                                    return SizedBox(
                                      height: 420,
                                      width: Get.width,
                                      child: Image.file(
                                        File(indexData.path),
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  },
                                ),
                                Positioned(
                                  bottom: 15,
                                  child: SmoothPageIndicator(
                                    effect: ExpandingDotsEffect(
                                        dotHeight: 8, dotWidth: 8, dotColor: Colors.grey.shade400, activeDotColor: AppColors.primaryPink),
                                    controller: addProductController.pageController,
                                    count: addProductController.addProductImages.length,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      addProductController.nameController.text,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppFontStyle.styleW700(AppColors.white, 20),
                                    ),
                                    Text(
                                      addProductController.descriptionController.text,
                                      maxLines: 2,
                                      style: AppFontStyle.styleW500(AppColors.unselected, 14),
                                    ),
                                  ],
                                ),
                                5.height,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "$currencySymbol ${addProductController.priceController.text}",
                                      overflow: TextOverflow.ellipsis,
                                      style: AppFontStyle.styleW900(AppColors.primary, 20),
                                    ),
                                    10.width,

                                    /// TODO
                                    /// Era 2.0
                                    // Text(
                                    //   "$currencySymbol 550.00",
                                    //   overflow: TextOverflow.ellipsis,
                                    //   style: TextStyle(
                                    //     fontWeight: FontWeight.w700,
                                    //     decoration: TextDecoration.lineThrough,
                                    //     fontFamily: AppConstant.appFontRegular,
                                    //     color: AppColors.unselected,
                                    //     fontSize: 14,
                                    //   ),
                                    // ),
                                  ],
                                ),
                                5.height,
                                (addProductController.shippingChargeController.text.trim() == "0")
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          color: AppColors.primary,
                                        ),
                                        child: Row(
                                          children: [
                                            Image.asset(AppAsset.icFreeDelivery, width: 20),
                                            5.width,
                                            Text(
                                              "FREE SHIPPING",
                                              style: AppFontStyle.styleW700(AppColors.black, 12),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          color: AppColors.primary,
                                        ),
                                        child: Text(
                                          "${St.deliveryCharge.tr} : $currencySymbol${addProductController.shippingChargeController.text}",
                                          style: AppFontStyle.styleW700(AppColors.black, 12),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    15.height,
                    // // Display all selected attributes dynamically
                    ...attributesAddProductController.selectedValuesByType.entries.map((entry) {
                      if (entry.value.isNotEmpty) {
                        return AttributeDisplayWidget(
                          attributeName: entry.key,
                          attributeValues: entry.value,
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),

                    // if (attributesAddProductController.selectedValuesByType?["sizes"]?.isNotEmpty ?? false) ...{
                    //   Text(
                    //     "Product Size",
                    //     style: AppFontStyle.styleW700(AppColors.white, 16),
                    //   ),
                    //   10.height,
                    //   SizedBox(
                    //     height: 35,
                    //     child: ListView.builder(
                    //       padding: EdgeInsets.zero,
                    //       scrollDirection: Axis.horizontal,
                    //       itemCount: attributesAddProductController.selectedValuesByType["sizes"]?.length,
                    //       itemBuilder: (context, index) {
                    //         final indexData = attributesAddProductController.selectedValuesByType["sizes"]?[index];
                    //
                    //         return Container(
                    //           height: 35,
                    //           padding: const EdgeInsets.symmetric(horizontal: 20),
                    //           margin: const EdgeInsets.only(right: 10),
                    //           alignment: Alignment.center,
                    //           decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(5),
                    //             color: AppColors.tabBackground,
                    //           ),
                    //           child: Text(
                    //             indexData ?? "".toUpperCase(),
                    //             style: AppFontStyle.styleW500(AppColors.unselected, 12),
                    //           ),
                    //         );
                    //       },
                    //     ),
                    //   ),
                    // },
                    // if (attributesAddProductController.selectedValuesByType?["colors"]?.isNotEmpty ?? false) ...{
                    //   15.height,
                    //   Text(
                    //     "Product Colors",
                    //     style: AppFontStyle.styleW700(AppColors.white, 16),
                    //   ),
                    //   10.height,
                    //   SizedBox(
                    //     height: 35,
                    //     child: ListView.builder(
                    //       padding: EdgeInsets.zero,
                    //       scrollDirection: Axis.horizontal,
                    //       itemCount: attributesAddProductController.selectedValuesByType["colors"]?.length,
                    //       itemBuilder: (context, index) {
                    //         final indexData = attributesAddProductController.selectedValuesByType["colors"]?[index];
                    //
                    //         return Container(
                    //           height: 30,
                    //           width: 50,
                    //           margin: const EdgeInsets.only(right: 10),
                    //           decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(5),
                    //             color: indexData?.replaceAll("#", "0xFF") != null
                    //                 ? Color(int.parse((indexData?.replaceAll("#", "0xFF"))!))
                    //                 : AppColors.transparent,
                    //           ),
                    //         );
                    //       },
                    //     ),
                    //   ),
                    // },
                    15.height,
                    Text(
                      St.productDetails.tr,
                      style: AppFontStyle.styleW700(AppColors.white, 16),
                    ),
                    15.height,
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              St.product.tr,
                              overflow: TextOverflow.ellipsis,
                              style: AppFontStyle.styleW500(AppColors.unselected, 14),
                            ),
                            5.height,
                            Text(
                              St.category.tr,
                              overflow: TextOverflow.ellipsis,
                              style: AppFontStyle.styleW500(AppColors.unselected, 14),
                            ),
                          ],
                        ),
                        50.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "In Stock",
                              overflow: TextOverflow.ellipsis,
                              style: AppFontStyle.styleW700(AppColors.white, 14),
                            ),
                            5.height,
                            Text(
                              getAllCategoryController.getLabelById(addProductController.category ?? "") ?? "",
                              overflow: TextOverflow.ellipsis,
                              style: AppFontStyle.styleW700(AppColors.primary, 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                    15.height,
                    Text(
                      addProductController.descriptionController.text,
                      style: AppFontStyle.styleW500(AppColors.unselected, 12),
                    ),
                    16.height,
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(15),
              child: MainButtonWidget(
                height: 60,
                width: Get.width,
                child: Text(
                  "UPLOAD PRODUCT",
                  style: AppFontStyle.styleW700(AppColors.black, 15),
                ),
                callback: () async {
                  isDemoSeller == true ? displayToast(message: St.thisIsDemoUser.tr).then((value) => Get.back()) : addProductController.addCatalog();
                },
              ),
            ),
          ),
        ),
        Obx(() => addProductController.isLoading.value ? ScreenCircular.blackScreenCircular() : const SizedBox()),
      ],
    );
  }
}

class AttributeDisplayWidget extends StatelessWidget {
  final String attributeName;
  final List<String> attributeValues;

  const AttributeDisplayWidget({
    super.key,
    required this.attributeName,
    required this.attributeValues,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Product ${attributeName.capitalizeFirst}",
          style: AppFontStyle.styleW700(AppColors.white, 16),
        ),
        10.height,
        if (attributeName.toLowerCase() == "colors")
          SizedBox(
            height: 35,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              itemCount: attributeValues.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 30,
                  width: 50,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color(int.parse(attributeValues[index].replaceAll("#", "0xFF"))),
                  ),
                );
              },
            ),
          )
        else
          SizedBox(
            height: 35,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              itemCount: attributeValues.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 35,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  margin: const EdgeInsets.only(right: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: AppColors.tabBackground,
                  ),
                  child: Text(
                    attributeValues[index].toUpperCase(),
                    style: AppFontStyle.styleW500(AppColors.unselected, 12),
                  ),
                );
              },
            ),
          ),
        15.height,
      ],
    );
  }
}

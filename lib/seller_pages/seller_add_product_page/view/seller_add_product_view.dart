import 'dart:io';
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:waxxapp/Controller/GetxController/seller/add_product_controller.dart';
import 'package:waxxapp/Controller/GetxController/seller/attributes_add_product_controller.dart';
import 'package:waxxapp/Controller/GetxController/user/get_all_category_controller.dart';
import 'package:waxxapp/custom/custom_color_bg_widget.dart';
import 'package:waxxapp/custom/custom_step_widget.dart';
import 'package:waxxapp/custom/main_button_widget.dart';
import 'package:waxxapp/custom/simple_app_bar_widget.dart';
import 'package:waxxapp/seller_pages/seller_add_product_page/view/seller_add_product_details_view.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_asset.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final bool? isNavigate = Get.arguments;
  AddProductController addProductController = Get.put(AddProductController());
  GetAllCategoryController getAllCategoryController = Get.put(GetAllCategoryController());
  AttributesAddProductController attributesAddProductController = Get.put(AttributesAddProductController());

  final categoryDropdownController = DropdownController();
  final subcategoryDropdownController = DropdownController();

  final List<bool> isExpandedOpen = List.generate(100000, (_) => false);

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
    attributesAddProductController.getAttributesData();
    getAllCategoryController.getCategory();
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

    return CustomColorBgWidget(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.transparent,
            surfaceTintColor: AppColors.transparent,
            flexibleSpace: SimpleAppBarWidget(title: St.addProduct.tr),
          ),
        ),
        body: Obx(
          () => (getAllCategoryController.isLoading.value || attributesAddProductController.isLoading.value)
              ? Center(child: CircularProgressIndicator(color: AppColors.primary))
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        CustomStepWidget(
                          step: addProductController.addProductImages.isEmpty ? 0 : 1,
                          selectedColor: AppColors.primary,
                          unselectedColor: AppColors.tabBackground,
                        ),
                        const SizedBox(height: 15),
                        GestureDetector(
                          onTap: () {
                            if (addProductController.addProductImages.length < 5) {
                              productPickFromGallery();
                            }
                          },
                          child: Container(
                            height: 200,
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              color: AppColors.tabBackground,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AppAsset.icUpload,
                                  height: 70,
                                  color: AppColors.mediumGrey,
                                ),
                                5.height,
                                Text(
                                  "Upload Files (max 5)",
                                  style: AppFontStyle.styleW500(AppColors.unselected, 12),
                                ),
                                5.height,
                                Text(
                                  "Maximum Upload 5 Images",
                                  style: AppFontStyle.styleW500(AppColors.unselected, 11),
                                ),
                              ],
                            ),
                          ),
                        ),
                        15.height,
                        GridView.builder(
                          shrinkWrap: true,
                          itemCount: addProductController.addProductImages.length,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            mainAxisExtent: 150,
                          ),
                          itemBuilder: (context, index) {
                            return Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: AppColors.tabBackground,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.file(
                                    File(addProductController.addProductImages[index].path),
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    top: 2,
                                    right: 2,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {});
                                        addProductController.addProductImages.removeAt(index);
                                        if (addProductController.addProductImages.isEmpty) {
                                          addProductController.productImageXFile = null;
                                        }
                                      },
                                      child: Container(
                                        height: 25,
                                        width: 25,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: AppColors.tabBackground.withValues(alpha: 0.8),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Image.asset(AppAsset.icRemoveProduct, width: 18, color: AppColors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(15),
          child: MainButtonWidget(
            height: 60,
            width: Get.width,
            color: addProductController.addProductImages.isEmpty ? AppColors.unselected.withValues(alpha: 0.8) : AppColors.primary,
            child: Text(
              "Upload Image",
              style: AppFontStyle.styleW700(AppColors.black, 15),
            ),
            callback: () async {
              if (addProductController.addProductImages.isEmpty) {
                Utils.showToast("Please upload product image");
              } else {
                Get.to(const SellerAddProductDetails());
              }
            },
          ),
        ),
      ),
    );
  }
}

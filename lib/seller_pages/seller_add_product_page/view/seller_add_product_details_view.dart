import 'dart:developer';
import 'dart:io';

import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:waxxapp/Controller/GetxController/seller/add_product_controller.dart';
import 'package:waxxapp/custom/custom_color_bg_widget.dart';
import 'package:waxxapp/custom/custom_step_widget.dart';
import 'package:waxxapp/custom/main_button_widget.dart';
import 'package:waxxapp/custom/simple_app_bar_widget.dart';
import 'package:waxxapp/seller_pages/seller_add_product_page/view/seller_verify_product_view.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/Zego/ZegoUtils/device_orientation.dart';
import 'package:waxxapp/utils/app_circular.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../ApiModel/seller/AttributeAddProductModel.dart';
import '../../../Controller/GetxController/seller/attributes_add_product_controller.dart';
import '../../../Controller/GetxController/user/get_all_category_controller.dart';

class SellerAddProductDetails extends StatefulWidget {
  const SellerAddProductDetails({super.key});

  @override
  State<SellerAddProductDetails> createState() => _SellerAddProductDetailsState();
}

class _SellerAddProductDetailsState extends State<SellerAddProductDetails> {
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
            body: SizedBox(
              height: Get.height,
              width: Get.width,
              child: Obx(
                () => getAllCategoryController.isLoading.value || attributesAddProductController.isLoading.value
                    ? Center(
                        child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ))
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 15),

                              // addProductController.productImageXFile == null
                              //     ? GestureDetector(
                              //         onTap: () {
                              //           productPickFromGallery();
                              //         },
                              //         child: Container(
                              //           height: 200,
                              //           width: double.maxFinite,
                              //           decoration: BoxDecoration(
                              //             color: AppColors.tabBackground,
                              //             borderRadius: BorderRadius.circular(12),
                              //           ),
                              //           child: Column(
                              //             mainAxisAlignment: MainAxisAlignment.center,
                              //             children: [
                              //               Image.asset(
                              //                 AppAsset.icUpload,
                              //                 height: 70,
                              //                 color: AppColors.mediumGrey,
                              //               ),
                              //               5.height,
                              //               Text(
                              //                 "Upload Files (max 6)",
                              //                 style: AppFontStyle.styleW500(AppColors.unselected, 12),
                              //               ),
                              //               5.height,
                              //               Text(
                              //                 "Maximum Upload 6 Images",
                              //                 style: AppFontStyle.styleW500(AppColors.unselected, 11),
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //       )
                              //     : SizedBox(
                              //         height: 230,
                              //         width: double.maxFinite,
                              //         child: Stack(
                              //           children: [
                              //             PageView.builder(
                              //               controller: pageController,
                              //               physics: const BouncingScrollPhysics(),
                              //               itemCount: addProductController.addProductImages.length,
                              //               itemBuilder: (context, index) {
                              //                 productCurrentIndex = index;
                              //                 return Container(
                              //                   height: 230,
                              //                   width: double.maxFinite,
                              //                   decoration: BoxDecoration(
                              //                     image: DecorationImage(
                              //                       image: FileImage(File(addProductController.addProductImages[index].path)),
                              //                       // image: AssetImage(addProduct[index]),
                              //                       fit: BoxFit.contain,
                              //                     ),
                              //                     borderRadius: BorderRadius.circular(12),
                              //                   ),
                              //                 );
                              //               },
                              //             ),
                              //             Align(
                              //               alignment: Alignment.bottomCenter,
                              //               child: Padding(
                              //                 padding: const EdgeInsets.only(bottom: 10),
                              //                 child: SmoothPageIndicator(
                              //                   effect: ExpandingDotsEffect(dotHeight: 8, dotWidth: 8, dotColor: AppColors.lightGrey, activeDotColor: AppColors.primaryPink),
                              //                   controller: pageController,
                              //                   count: addProductController.addProductImages.length,
                              //                 ),
                              //               ),
                              //             ),
                              //             Align(
                              //               alignment: Alignment.bottomRight,
                              //               child: Padding(
                              //                 padding: const EdgeInsets.only(bottom: 10, right: 10),
                              //                 child: GestureDetector(
                              //                   onTap: () {
                              //                     if (addProductController.addProductImages.length < 5) {
                              //                       productPickFromGallery();
                              //                     }
                              //                   },
                              //                   child: CircleAvatar(
                              //                     backgroundColor: isDark.value ? AppColors.white : AppColors.black,
                              //                     child: Icon(
                              //                       Icons.add,
                              //                       color: isDark.value ? AppColors.black : AppColors.white,
                              //                     ),
                              //                   ),
                              //                 ),
                              //               ),
                              //             ),
                              //             Padding(
                              //               padding: const EdgeInsets.only(left: 8, top: 8),
                              //               child: GestureDetector(
                              //                 onTap: () {
                              //                   setState(() {});
                              //                   addProductController.addProductImages.removeAt(productCurrentIndex!);
                              //                   if (addProductController.addProductImages.isEmpty) {
                              //                     addProductController.productImageXFile = null;
                              //                   }
                              //                 },
                              //                 child: Container(
                              //                   height: 27,
                              //                   width: 75,
                              //                   decoration: BoxDecoration(
                              //                     borderRadius: BorderRadius.circular(50),
                              //                     color: isDark.value ? AppColors.white : AppColors.black,
                              //                   ),
                              //                   child: Row(
                              //                     mainAxisAlignment: MainAxisAlignment.center,
                              //                     children: [
                              //                       Image.asset(AppAsset.icRemoveProduct, color: isDark.value ? AppColors.black : AppColors.white, height: 14),
                              //                       const SizedBox(
                              //                         width: 4,
                              //                       ),
                              //                       Text(
                              //                         St.remove.tr,
                              //                         style: GoogleFonts.plusJakartaSans(
                              //                           fontSize: 11,
                              //                           fontWeight: FontWeight.w500,
                              //                           color: isDark.value ? AppColors.black : AppColors.white,
                              //                         ),
                              //                       )
                              //                     ],
                              //                   ),
                              //                 ),
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //
                              // GridView.builder(
                              //   shrinkWrap: true,
                              //   itemCount: addProductController.addProductImages.length,
                              //   physics: const NeverScrollableScrollPhysics(),
                              //   padding: const EdgeInsets.symmetric(vertical: 10),
                              //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              //     crossAxisCount: 3,
                              //     mainAxisSpacing: 10,
                              //     crossAxisSpacing: 10,
                              //     mainAxisExtent: 150,
                              //   ),
                              //   itemBuilder: (context, index) {
                              //     return Container(
                              //       clipBehavior: Clip.antiAlias,
                              //       decoration: BoxDecoration(
                              //         color: AppColors.tabBackground,
                              //         borderRadius: BorderRadius.circular(10),
                              //       ),
                              //       child: Stack(
                              //         fit: StackFit.expand,
                              //         children: [
                              //           Image.file(
                              //             File(addProductController.addProductImages[index].path),
                              //             fit: BoxFit.cover,
                              //           ),
                              //           Positioned(
                              //             top: 2,
                              //             right: 2,
                              //             child: GestureDetector(
                              //               onTap: () {
                              //                 setState(() {});
                              //                 addProductController.addProductImages.removeAt(index);
                              //                 if (addProductController.addProductImages.isEmpty) {
                              //                   addProductController.productImageXFile = null;
                              //                 }
                              //               },
                              //               child: Container(
                              //                 height: 25,
                              //                 width: 25,
                              //                 alignment: Alignment.center,
                              //                 decoration: BoxDecoration(
                              //                   color: AppColors.tabBackground.withValues(alpha:0.8),
                              //                   shape: BoxShape.circle,
                              //                 ),
                              //                 child: Image.asset(AppAsset.icRemoveProduct, width: 18, color: AppColors.white),
                              //               ),
                              //             ),
                              //           ),
                              //         ],
                              //       ),
                              //     );
                              //   },
                              // ),

                              // PrimaryTextField(
                              //   titleText: St.productName.tr,
                              //   hintText: St.addProductName.tr,
                              //   controllerType: "ProductName",
                              // ),

                              // PrimaryTextField(
                              //   titleText: St.productPrice.tr,
                              //   hintText: St.addProductPrice.tr,
                              //   controllerType: "ProductPrice",
                              // ),

                              CustomStepWidget(
                                step: 2,
                                selectedColor: AppColors.primary,
                                unselectedColor: AppColors.tabBackground,
                              ),

                              15.height,
                              AddProductItemWidget(
                                title: St.productName.tr,
                                controller: addProductController.nameController,
                              ),
                              15.height,

                              Text(
                                St.productPrice.tr,
                                style: AppFontStyle.styleW500(AppColors.unselected, 12),
                              ),
                              10.height,
                              Container(
                                height: 58,
                                width: Get.width,
                                padding: const EdgeInsets.only(right: 15),
                                decoration: BoxDecoration(
                                  color: AppColors.tabBackground,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 58,
                                      width: 65,
                                      padding: const EdgeInsets.only(bottom: 5),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          bottomLeft: Radius.circular(15),
                                        ),
                                      ),
                                      child: Text("$currencySymbol", style: AppFontStyle.styleW700(AppColors.black, 28)),
                                    ),
                                    15.width,
                                    Expanded(
                                      child: TextFormField(
                                        controller: addProductController.priceController,
                                        cursorColor: AppColors.unselected,
                                        style: AppFontStyle.styleW700(AppColors.white, 14),
                                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: St.enterProductPrice.tr,
                                          hintStyle: AppFontStyle.styleW500(AppColors.unselected, 14),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              25.height,
                              AddProductItemWidget(
                                title: St.shippingCharge.tr,
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                controller: addProductController.shippingChargeController,
                              ),
                              25.height,

                              Text(
                                St.categories.tr,
                                style: AppFontStyle.styleW500(AppColors.unselected, 12),
                              ),
                              10.height,
                              CoolDropdown<dynamic>(
                                controller: categoryDropdownController,
                                dropdownList: getAllCategoryController.categoryDropdownItems,
                                onChange: (value) async {
                                  categoryDropdownController.close();
                                  if (categoryDropdownController.isError) {
                                    await categoryDropdownController.resetError();
                                  }
                                  setState(() {
                                    addProductController.category = value;
                                    log("Category select Value ::  $value");
                                    subcategoryDropdownController.resetValue();
                                    log("Subcategory null or not  ::  ${addProductController.subCategory}");
                                    getAllCategoryController.subCategoryList = getAllCategoryController.categoryList.firstWhere((category) => category.id == addProductController.category).subCategory!;
                                  });
                                },
                                resultOptions: ResultOptions(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  height: 58,
                                  width: Get.width,
                                  boxDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: AppColors.tabBackground,
                                  ),
                                  openBoxDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: AppColors.tabBackground,
                                  ),
                                  icon: const SizedBox(
                                    width: 10,
                                    height: 10,
                                    child: CustomPaint(painter: DropdownArrowPainter()),
                                  ),
                                  placeholder: St.selectCategories.tr.capitalizeFirst.toString(),
                                  placeholderTextStyle: AppFontStyle.styleW500(AppColors.unselected, 14),
                                  textStyle: AppFontStyle.styleW700(AppColors.white, 15),
                                ),
                                dropdownOptions: DropdownOptions(
                                  borderRadius: BorderRadius.circular(15),
                                  top: 10,
                                  height: 250,
                                  width: 200,
                                  selectedItemAlign: SelectedItemAlign.center,
                                  curve: Curves.bounceInOut,
                                  color: AppColors.tabBackground,
                                  align: DropdownAlign.right,
                                  animationType: DropdownAnimationType.scale,
                                ),
                                dropdownTriangleOptions: const DropdownTriangleOptions(
                                  width: 0,
                                  height: 0,
                                  align: DropdownTriangleAlign.right,
                                  borderRadius: 0,
                                  left: 0,
                                ),
                                dropdownItemOptions: DropdownItemOptions(
                                  textStyle: AppFontStyle.styleW500(AppColors.unselected, 14),
                                  selectedTextStyle: AppFontStyle.styleW700(AppColors.primary, 14),
                                  selectedBoxDecoration: BoxDecoration(color: AppColors.white.withValues(alpha: 0.08)),
                                  padding: const EdgeInsets.only(left: 20),
                                  selectedPadding: const EdgeInsets.only(left: 20),
                                ),
                              ),
                              const SizedBox(height: 25),
                              Text(
                                St.subCategories.tr,
                                style: AppFontStyle.styleW500(AppColors.unselected, 12),
                              ),
                              10.height,
                              CoolDropdown<dynamic>(
                                controller: subcategoryDropdownController,
                                dropdownList: getAllCategoryController.subcategoryDropdownItems,
                                onChange: (value) async {
                                  subcategoryDropdownController.close();
                                  if (subcategoryDropdownController.isError) {
                                    await subcategoryDropdownController.resetError();
                                  }
                                  setState(() {
                                    addProductController.subCategory = value;
                                    log("Sub Subcategory :: ${addProductController.subCategory}");
                                  });
                                },
                                resultOptions: ResultOptions(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  height: 58,
                                  width: Get.width,
                                  boxDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: AppColors.tabBackground,
                                  ),
                                  openBoxDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: AppColors.tabBackground,
                                  ),
                                  icon: const SizedBox(
                                    width: 10,
                                    height: 10,
                                    child: CustomPaint(painter: DropdownArrowPainter()),
                                  ),
                                  placeholder: "Select subcategory",
                                  placeholderTextStyle: AppFontStyle.styleW500(AppColors.unselected, 14),
                                  textStyle: AppFontStyle.styleW700(AppColors.white, 15),
                                ),
                                dropdownOptions: DropdownOptions(
                                  borderRadius: BorderRadius.circular(15),
                                  top: 10,
                                  height: 250,
                                  width: 200,
                                  selectedItemAlign: SelectedItemAlign.center,
                                  curve: Curves.bounceInOut,
                                  color: AppColors.tabBackground,
                                  align: DropdownAlign.right,
                                  animationType: DropdownAnimationType.scale,
                                ),
                                dropdownTriangleOptions: const DropdownTriangleOptions(
                                  width: 0,
                                  height: 0,
                                  align: DropdownTriangleAlign.right,
                                  borderRadius: 0,
                                  left: 0,
                                ),
                                dropdownItemOptions: DropdownItemOptions(
                                  textStyle: AppFontStyle.styleW500(AppColors.unselected, 14),
                                  selectedTextStyle: AppFontStyle.styleW700(AppColors.primary, 14),
                                  selectedBoxDecoration: BoxDecoration(color: AppColors.white.withValues(alpha: 0.08)),
                                  padding: const EdgeInsets.only(left: 20),
                                  selectedPadding: const EdgeInsets.only(left: 20),
                                ),
                              ),

                              25.height,
                              Text(
                                "Attributes",
                                style: AppFontStyle.styleW500(AppColors.unselected, 12),
                              ),
                              10.height,

                              GetBuilder<AttributesAddProductController>(
                                  init: AttributesAddProductController(),
                                  builder: (logic) {
                                    return ListView.separated(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: logic.attributeAddProduct?.attributes?.length ?? 0,
                                      separatorBuilder: (_, __) => SizedBox(height: 16),
                                      itemBuilder: (context, index) {
                                        final attribute = logic.attributeAddProduct?.attributes?[index];
                                        final isExpanded = logic.isExpandedOpen[index];

                                        return Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.tabBackground,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () => logic.togglePanel(index),
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      _buildHeader(attribute!),
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
                                                        child: _buildAttributeContent(attribute),
                                                      )
                                                    : SizedBox.shrink(),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  }),

                              // Wrap(
                              //   children: attributesAddProductController.attributeAddProduct!.attributes!.map((attributes) {
                              //     if (attributes.type!.isNotEmpty) {
                              //       print("************************* ${attributes.type}");
                              //       return Column(
                              //         crossAxisAlignment: CrossAxisAlignment.start,
                              //         children: [
                              //           Text(
                              //             attributes.name!.capitalizeFirst.toString(),
                              //             style: AppFontStyle.styleW500(AppColors.unselected, 12),
                              //           ),
                              //           10.height,
                              //           ExpansionPanelList(
                              //             expandIconColor: Colors.grey.shade700,
                              //             animationDuration: const Duration(milliseconds: 600),
                              //             elevation: 0,
                              //             expansionCallback: (int index, bool isExpanded) {
                              //               setState(() {
                              //                 isExpandedOpen[index] = !isExpandedOpen[index];
                              //                 if (isOpen == true) {
                              //                   isOpen = false;
                              //                 } else {
                              //                   isOpen = true;
                              //                 }
                              //               });
                              //             },
                              //             children: [
                              //               ExpansionPanel(
                              //                 isExpanded: isExpandedOpen[0],
                              //                 backgroundColor: Colors.transparent,
                              //                 headerBuilder: (BuildContext context, bool isExpanded) {
                              //                   return Container(
                              //                     height: 60,
                              //                     width: Get.width,
                              //                     padding: const EdgeInsets.symmetric(horizontal: 15),
                              //                     margin: EdgeInsets.only(bottom: 15),
                              //                     alignment: Alignment.centerLeft,
                              //                     decoration: BoxDecoration(
                              //                       borderRadius: BorderRadius.circular(12),
                              //                       color: AppColors.tabBackground,
                              //                     ),
                              //                     child: attributesAddProductController.selectedValuesByType[attributes.type] == null ||
                              //                             attributesAddProductController.selectedValuesByType[attributes.type]!.isEmpty
                              //                         ? Text(
                              //                             "${St.select.tr} ${attributes.name}",
                              //                             style: AppFontStyle.styleW500(AppColors.unselected, 14),
                              //                           )
                              //                         : attributes.name == "Colors"
                              //                             ? ListView.builder(
                              //                                 scrollDirection: Axis.horizontal,
                              //                                 itemCount: attributesAddProductController.selectedValuesByType[attributes.type]?.length,
                              //                                 itemBuilder: (context, index) {
                              //                                   print(
                              //                                       "selectedValuesByType${attributesAddProductController.selectedValuesByType[attributes.type]![index]}");
                              //                                   return Container(
                              //                                     width: 30,
                              //                                     height: 30,
                              //                                     margin: const EdgeInsets.only(top: 12, left: 8),
                              //                                     decoration: BoxDecoration(
                              //                                       shape: BoxShape.circle,
                              //                                       color: Color(int.parse(attributesAddProductController
                              //                                           .selectedValuesByType[attributes.type]![index]
                              //                                           .replaceAll("#", "0xFF"))),
                              //                                     ),
                              //                                   ).paddingOnly(bottom: 14);
                              //                                 },
                              //                               )
                              //                             : Text(
                              //                                 attributesAddProductController.selectedValuesByType[attributes.type]!
                              //                                     .map((e) => e.toString())
                              //                                     .toList()
                              //                                     .join(", ")
                              //                                     .toUpperCase(),
                              //                                 style: AppFontStyle.styleW700(AppColors.white, 14),
                              //                               ),
                              //                   );
                              //                 },
                              //                 body: Container(
                              //                   decoration: BoxDecoration(
                              //                     borderRadius: BorderRadius.circular(24),
                              //                   ),
                              //                   child: Column(
                              //                     children: [
                              //                       SizedBox(
                              //                         width: Get.width,
                              //                         child: Wrap(
                              //                           spacing: 10,
                              //                           children: attributes.value!.map((value) {
                              //                             return attributes.type.toString() == "colors"
                              //                                 ? GestureDetector(
                              //                                     onTap: () {
                              //                                       setState(() {
                              //                                         attributesAddProductController.toggleSelection(
                              //                                             value, attributes.type.toString());
                              //                                       });
                              //                                       log("SELECTED :: VALUE :: $value TYPE ::${attributes.type}");
                              //                                       log("SELECTED TYPE :: ${attributesAddProductController.selectedValuesByType}");
                              //                                     },
                              //                                     child: Container(
                              //                                       width: 45,
                              //                                       height: 45,
                              //                                       margin: const EdgeInsets.only(bottom: 5),
                              //                                       decoration: BoxDecoration(
                              //                                         shape: BoxShape.circle,
                              //                                         border: Border.all(
                              //                                           color: attributesAddProductController.selectedValuesByType
                              //                                                       .containsKey(attributes.type) &&
                              //                                                   attributesAddProductController.selectedValuesByType[attributes.type]!
                              //                                                       .contains(value)
                              //                                               ? AppColors.primary
                              //                                               : Colors.transparent,
                              //                                           width: 2,
                              //                                         ),
                              //                                       ),
                              //                                       child: Padding(
                              //                                         padding: const EdgeInsets.all(1.5),
                              //                                         child: Container(
                              //                                           decoration: BoxDecoration(
                              //                                             color: Color(
                              //                                               int.parse(value.replaceAll("#", "0xFF")),
                              //                                             ),
                              //                                             shape: BoxShape.circle,
                              //                                           ),
                              //                                         ),
                              //                                       ),
                              //                                     ),
                              //                                   )
                              //                                 : FilterChip(
                              //                                     padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
                              //                                     onSelected: (selected) {
                              //                                       setState(() {
                              //                                         attributesAddProductController.toggleSelection(
                              //                                             value, attributes.type.toString());
                              //                                       });
                              //                                       log("SELECTED :: $selected VALUE :: $value TYPE ::${attributes.type}");
                              //                                       log("SELECTED TYPE :: ${attributesAddProductController.selectedValuesByType}");
                              //                                     },
                              //                                     selectedColor: AppColors.primaryPink,
                              //                                     backgroundColor: attributesAddProductController.selectedValuesByType
                              //                                                 .containsKey(attributes.type) &&
                              //                                             attributesAddProductController.selectedValuesByType[attributes.type]!
                              //                                                 .contains(value)
                              //                                         ? AppColors.primary
                              //                                         : AppColors.tabBackground,
                              //                                     side: BorderSide(color: AppColors.tabBackground),
                              //                                     // side: BorderSide(
                              //                                     //   width: 0.8,
                              //                                     //   color: attributesAddProductController.selectedValuesByType.containsKey(attributes.type) &&
                              //                                     //           attributesAddProductController.selectedValuesByType[attributes.type]!.contains(value)
                              //                                     //       ? AppColors.primaryPink
                              //                                     //       : AppColors.tabBackground,
                              //                                     // ),
                              //                                     label: Padding(
                              //                                       padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                              //                                       child: Text(
                              //                                         value.toUpperCase(),
                              //                                         style: AppFontStyle.styleW500(
                              //                                           attributesAddProductController.selectedValuesByType
                              //                                                       .containsKey(attributes.type) &&
                              //                                                   attributesAddProductController.selectedValuesByType[attributes.type]!
                              //                                                       .contains(value)
                              //                                               ? AppColors.black
                              //                                               : AppColors.unselected,
                              //                                           14,
                              //                                         ),
                              //                                       ),
                              //                                     ),
                              //                                   );
                              //                           }).toList(),
                              //                         ),
                              //                       ),
                              //                     ],
                              //                   ),
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //           const SizedBox(height: 10),
                              //         ],
                              //       );
                              //     } else {
                              //       return Container();
                              //     }
                              //   }).toList(),
                              // ),

                              25.height,

                              AddProductItemWidget(
                                height: 125,
                                title: St.description.tr,
                                controller: addProductController.descriptionController,
                              ),
                              15.height,

                              // Padding(
                              //   padding: const EdgeInsets.only(bottom: 8),
                              //   child: Row(
                              //     children: [
                              //       Text(
                              //         St.description.tr,
                              //         style: GoogleFonts.plusJakartaSans(
                              //           fontSize: 14,
                              //           color: isDark.value ? AppColors.white : AppColors.mediumGrey,
                              //           fontWeight: FontWeight.w500,
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              // Obx(
                              //   () => TextField(
                              //     controller: addProductController.descriptionController,
                              //     maxLines: 15,
                              //     minLines: 7,
                              //     style: TextStyle(color: isDark.value ? AppColors.dullWhite : AppColors.black),
                              //     decoration: InputDecoration(
                              //       filled: true,
                              //       fillColor: isDark.value ? AppColors.blackBackground : AppColors.dullWhite,
                              //       enabledBorder: OutlineInputBorder(
                              //           borderSide: isDark.value ? BorderSide(color: Colors.grey.shade800) : BorderSide.none, borderRadius: BorderRadius.circular(24)),
                              //       border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryPink), borderRadius: BorderRadius.circular(26)),
                              //       hintText: St.addAboutYourProduct.tr,
                              //       hintStyle: GoogleFonts.plusJakartaSans(height: 1.6, color: AppColors.mediumGrey, fontSize: 15),
                              //     ),
                              //   ),
                              // ),

                              // Padding(
                              //   padding: const EdgeInsets.symmetric(vertical: 15),
                              //   child: PrimaryPinkButton(
                              //       onTaped: () {
                              //         isDemoSeller == true ? displayToast(message: St.thisIsDemoApp.tr).then((value) => Get.back()) : addProductController.addCatalog();
                              //       },
                              //       text: St.addCatalog.tr),
                              // )
                            ],
                          ),
                        ),
                      ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(15),
              child: MainButtonWidget(
                height: 60,
                width: Get.width,
                child: Text(
                  "VERIFY PRODUCT",
                  style: AppFontStyle.styleW700(AppColors.black, 15),
                ),
                callback: () {
                  bool hasAtLeastOneAttributeSelected() {
                    // Check if the map is not empty and at least one entry has non-empty values
                    return attributesAddProductController.selectedValuesByType.entries.any((entry) => entry.value.isNotEmpty);
                  }

                  // isDemoSeller == true ? displayToast(message: St.thisIsDemoApp.tr).then((value) => Get.back()) : addProductController.addCatalog();
                  if (addProductController.addProductImages.isEmpty) {
                    Utils.showToast("Please add product images");
                  } else if (addProductController.nameController.text.trim().isEmpty) {
                    Utils.showToast("Please enter product name");
                  } else if (addProductController.priceController.text.trim().isEmpty) {
                    Utils.showToast("Please enter product price");
                  } else if ((addProductController.category?.isEmpty ?? true)) {
                    Utils.showToast("Please select category");
                  } else if ((addProductController.subCategory?.isEmpty ?? true)) {
                    Utils.showToast("Please select sub-category");
                  } else if (addProductController.shippingChargeController.text.trim().isEmpty) {
                    Utils.showToast("Please enter shipping charge");
                  } else if (addProductController.descriptionController.text.trim().isEmpty) {
                    Utils.showToast("Please enter product description");
                  } else if (!hasAtLeastOneAttributeSelected()) {
                    Utils.showToast("Please select at least one attribute");
                  } else {
                    Get.to(SellerVerifyProductView());
                  }
                },
              ),
            ),
          ),
        ),
        Obx(() => addProductController.isLoading.value ? ScreenCircular.blackScreenCircular() : const SizedBox())
      ],
    );
  }

  Widget _buildHeader(Attributes attribute) {
    return Text("Select ${attribute.name}", style: AppFontStyle.styleW500(AppColors.unselected, 14));
  }

  Widget _buildAttributeContent(Attributes attribute) {
    return Wrap(
      spacing: 10,
      children: attribute.value!.map((value) {
        if (attribute.name?.toLowerCase() == "colors") {
          return _buildColorChip(value, attribute);
        }
        return _buildTextChip(value, attribute);
      }).toList(),
    );
  }

  Widget _buildColorChip(String value, Attributes attribute) {
    final controller = Get.find<AttributesAddProductController>();
    final isSelected = controller.selectedValuesByType[attribute.name]?.contains(value) ?? false;

    return GestureDetector(
      onTap: () => controller.toggleSelection(value, attribute.name ?? ""),
      child: Container(
        width: 45,
        height: 45,
        margin: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(1.5),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(int.parse(value.replaceAll("#", "0xFF"))),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextChip(String value, Attributes attribute) {
    final controller = Get.find<AttributesAddProductController>();
    final isSelected = controller.selectedValuesByType[attribute.name]?.contains(value) ?? false;

    return FilterChip(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
      onSelected: (selected) => controller.toggleSelection(value, attribute.name ?? ""),
      selected: isSelected,
      showCheckmark: false,
      avatar: null,
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.tabBackground.withValues(alpha: 0.2),
      // side: BorderSide(
      //   color: isSelected ? AppColors.primary : AppColors.tabBackground,
      //   width: 1.5,
      // ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      label: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Text(
          value.toUpperCase(),
          style: TextStyle(color: isSelected ? AppColors.black : AppColors.grayLight, fontSize: 14, fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400),
        ),
      ),
    );
  }
}

class AddProductItemWidget extends StatelessWidget {
  const AddProductItemWidget({super.key, required this.title, this.controller, this.keyboardType, this.height, this.inputFormatters});

  final String title;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final double? height;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppFontStyle.styleW500(AppColors.unselected, 12),
        ),
        10.height,
        Container(
          height: height ?? 55,
          width: Get.width,
          alignment: height != null ? Alignment.topLeft : null,
          decoration: BoxDecoration(
            color: AppColors.tabBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.only(left: 15),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  inputFormatters: inputFormatters,
                  cursorColor: AppColors.unselected,
                  keyboardType: keyboardType,
                  style: AppFontStyle.styleW700(AppColors.white, 15),
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

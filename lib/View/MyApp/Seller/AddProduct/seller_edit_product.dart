// ignore_for_file: depend_on_referenced_packages

import 'dart:developer' as log;
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:era_shop/utils/app_circular.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:era_shop/Controller/GetxController/seller/seller_product_detail_controller.dart';
import 'package:era_shop/utils/CoustomWidget/App_theme_services/primary_buttons.dart';
import 'package:era_shop/utils/CoustomWidget/App_theme_services/text_titles.dart';
import 'package:era_shop/utils/CoustomWidget/App_theme_services/textfields.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../Controller/GetxController/seller/add_product_controller.dart';
import '../../../../Controller/GetxController/seller/attributes_add_product_controller.dart';
import '../../../../Controller/GetxController/seller/edit_product_controller.dart';
import '../../../../Controller/GetxController/user/get_all_category_controller.dart';

class EditProduct extends StatefulWidget {
  const EditProduct({Key? key}) : super(key: key);

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  SellerProductDetailsController sellerProductDetailsController = Get.put(SellerProductDetailsController());
  EditProductController editProductController = Get.put(EditProductController());
  AddProductController addProductController = Get.put(AddProductController());
  GetAllCategoryController getAllCategoryController = Get.put(GetAllCategoryController());
  AttributesAddProductController attributesAddProductController = Get.put(AttributesAddProductController());

  final List<bool> isExpandedOpen = List.generate(100000, (_) => false);

  bool isOpen = false;

  List<File> files = [];

  Future<List<File>> convertURLsToFiles(List urls) async {
    var rng = Random();
    for (String url in urls) {
      Directory root = await getTemporaryDirectory();
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        String tempPath = '${root.path}/edited-${rng.nextInt(1000000)}photos-${rng.nextInt(1000000)}.jpg';
        File file = File(tempPath);
        await file.writeAsBytes(response.bodyBytes);
        setState(() {
          files.add(file);
        });
      }
    }
    log.log("Converted images :: $files");
    return files;
  }

  int? productCurrentIndex;
  final pageController = PageController();
  File? productImageXFile;
  XFile? xFiles;
  final ImagePicker productPick = ImagePicker();

  productPickFromGallery() async {
    xFiles = await productPick.pickImage(source: ImageSource.gallery, imageQuality: 100);
    setState(() {
      productImageXFile = File(xFiles!.path);
      files.add(productImageXFile!);
      log.log("Converted images List :: $files");
    });
  }

  final categoryDropdownController = DropdownController();
  final subcategoryDropdownController = DropdownController();

  @override
  void initState() {
    // TODO: implement initState
    getAllCategoryController.getCategory();
    convertURLsToFiles(sellerProductDetailsController.sellerProductDetails!.product![0].images!.toList());
    attributesAddProductController.getAttributesData();
    super.initState();
  }

  Widget getImageWidget(String imagePath) {
    if (imagePath.startsWith('http') || imagePath.startsWith('https')) {
      // It's a network URL
      return CachedNetworkImage(
        imageUrl: imagePath,
        height: 230,
        width: double.maxFinite,
        fit: BoxFit.contain,
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) {
          if (kDebugMode) {
            print('Error loading network image: $error');
          }
          return const Icon(Icons.error);
        },
      );
    } else {
      // It's a local file path
      return Image.file(
        File(imagePath),
        height: 230,
        width: double.maxFinite,
        fit: BoxFit.contain,
      );
    }
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
        Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              actions: [
                SizedBox(
                  width: Get.width,
                  height: double.maxFinite,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 10),
                        child: PrimaryRoundButton(
                          onTaped: () {
                            // Get.off(SellerProductDetails(),transition: Transition.leftToRight);
                            // Get.back();
                            Get.back(result: true);
                          },
                          icon: Icons.arrow_back_rounded,
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: GeneralTitle(title: St.editProduct.tr),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: Obx(() {
            return getAllCategoryController.isLoading.value || attributesAddProductController.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
                    height: Get.height,
                    width: Get.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            files.isBlank == true
                                ? GestureDetector(
                                    onTap: () {
                                      productPickFromGallery();
                                    },
                                    child: Container(
                                      height: 230,
                                      width: double.maxFinite,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.lightGrey)),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/icons/add_image.png",
                                            height: 30,
                                            color: AppColors.mediumGrey,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 10),
                                            child: Text(
                                              St.addProductImages.tr,
                                              style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.mediumGrey, fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : SizedBox(
                                    height: 230,
                                    width: double.maxFinite,
                                    child: Stack(
                                      children: [
                                        PageView.builder(
                                          controller: pageController,
                                          physics: const BouncingScrollPhysics(),
                                          itemCount: files.length,
                                          itemBuilder: (context, index) {
                                            productCurrentIndex = index;
                                            return Column(
                                              children: [
                                                Container(
                                                  height: 230,
                                                  width: double.maxFinite,
                                                  decoration: BoxDecoration(
                                                    // image: DecorationImage(
                                                    //   image: FileImage(File(files[index].path)),
                                                    //   // image: NetworkImage(
                                                    //   //     "${sellerProductDetailsController.editProductImages[index]}"),
                                                    //   fit: BoxFit.contain,
                                                    // ),
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: getImageWidget(files[index].path),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Padding(
                                            padding: const EdgeInsets.only(bottom: 10),
                                            child: SmoothPageIndicator(
                                              effect: ExpandingDotsEffect(dotHeight: 8, dotWidth: 8, dotColor: AppColors.lightGrey, activeDotColor: AppColors.primaryPink),
                                              controller: pageController,
                                              count: files.length,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: Padding(
                                            padding: const EdgeInsets.only(bottom: 10, right: 10),
                                            child: GestureDetector(
                                              onTap: () {
                                                productPickFromGallery();
                                              },
                                              child: CircleAvatar(
                                                backgroundColor: isDark.value ? AppColors.white : AppColors.black,
                                                child: Icon(
                                                  Icons.add,
                                                  color: isDark.value ? AppColors.black : AppColors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8, top: 8),
                                          child: GestureDetector(
                                            onTap: () async {
                                              setState(() {});
                                              files.removeAt(productCurrentIndex!);
                                            },
                                            child: Container(
                                              height: 27,
                                              width: 75,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(50),
                                                color: isDark.value ? AppColors.white : AppColors.black,
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Image.asset("assets/icons/remove_product.png", color: isDark.value ? AppColors.black : AppColors.white, height: 14),
                                                  const SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(
                                                    St.remove.tr,
                                                    style: GoogleFonts.plusJakartaSans(
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.w500,
                                                      color: isDark.value ? AppColors.black : AppColors.white,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            const SizedBox(height: 25),
                            PrimaryTextField(
                              titleText: St.productName.tr,
                              hintText: St.addProduct.tr,
                              controllerType: "ProductName",
                            ),
                            const SizedBox(height: 15),
                            PrimaryTextField(
                              titleText: St.productPrice.tr,
                              hintText: St.productPrice.tr,
                              controllerType: "ProductPrice",
                            ),

                            /// Category
                            // Padding(
                            //   padding: const EdgeInsets.only(bottom: 8),
                            //   child: Row(
                            //     children: [
                            //       Text(
                            //         St.categories,
                            //         style: GoogleFonts.plusJakartaSans(
                            //           fontSize: 14,
                            //           color: isDark.value ? AppColors.white : AppColors.mediumGrey,
                            //           fontWeight: FontWeight.w500,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // SizedBox(
                            //   height: 60,
                            //   child: DropdownButtonFormField<String>(
                            //     value: sellerProductDetailsController
                            //         .sellerProductDetails!.product![0].category!.name
                            //         .toString(),
                            //     onChanged: (value) {},
                            //     dropdownColor: isDark.value ? AppColors.blackBackground : AppColors.dullWhite,
                            //     style: TextStyle(color: isDark.value ? AppColors.dullWhite : AppColors.black),
                            //     decoration: InputDecoration(
                            //         hintText: "Select category",
                            //         filled: true,
                            //         fillColor: isDark.value ? AppColors.blackBackground : AppColors.dullWhite,
                            //         hintStyle:
                            //             GoogleFonts.plusJakartaSans(color: Colors.grey.shade400, fontSize: 16),
                            //         enabledBorder: OutlineInputBorder(
                            //             borderSide: isDark.value
                            //                 ? BorderSide(color: Colors.grey.shade800)
                            //                 : BorderSide.none,
                            //             borderRadius: BorderRadius.circular(24)),
                            //         border: OutlineInputBorder(
                            //             borderSide: BorderSide(color: AppColors.primaryPink),
                            //             borderRadius: BorderRadius.circular(26))),
                            //     icon: const Icon(Icons.expand_more_outlined),
                            //     items: getAllCategoryController.getAllCategory!.category!.map((category) {
                            //       return DropdownMenuItem(
                            //         onTap: () {
                            //           addProductController.category = category.id!;
                            //           // categoryWiseSubCategoryController.getSubcategory(categoryId: category.id!);
                            //           log.log("Category NAME :: ${category.name} ID  :: ${category.id}");
                            //         },
                            //         value: category.name,
                            //         child: Container(
                            //           height: 50,
                            //           color: isDark.value ? AppColors.blackBackground : AppColors.dullWhite,
                            //           child: Center(
                            //             child: Text(
                            //               category.name.toString(),
                            //               style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w500),
                            //             ),
                            //           ),
                            //         ),
                            //       );
                            //     }).toList(),
                            //   ),
                            // ),
                            /// Sub category
                            // Padding(
                            //   padding: const EdgeInsets.only(bottom: 8),
                            //   child: Row(
                            //     children: [
                            //       Text(
                            //         "Subcategory",
                            //         style: GoogleFonts.plusJakartaSans(
                            //           fontSize: 14,
                            //           color: isDark.value ? AppColors.white : AppColors.mediumGrey,
                            //           fontWeight: FontWeight.w500,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // SizedBox(
                            //   height: 60,
                            //   child: GestureDetector(
                            //     onTap: () {
                            //       Fluttertoast.showToast(
                            //           msg: "Please select a category first",
                            //           toastLength: Toast.LENGTH_LONG,
                            //           gravity: ToastGravity.CENTER,
                            //           timeInSecForIosWeb: 2,
                            //           backgroundColor: AppColors.primaryPink,
                            //           textColor: AppColors.white,
                            //           fontSize: 16.0);
                            //     },
                            //     child: DropdownButtonFormField<String>(
                            //       value: sellerProductDetailsController
                            //           .sellerProductDetails!.product![0].subCategory!.name
                            //           .toString(),
                            //       iconDisabledColor: Colors.grey.shade700,
                            //       hint: Text("Select Subcategory",
                            //           style: GoogleFonts.plusJakartaSans(
                            //               color: Colors.grey.shade400, fontSize: 16)),
                            //       onChanged: (value) {
                            //         // addProductController.categoryController.text = value!;
                            //       },
                            //       dropdownColor: isDark.value ? AppColors.blackBackground : AppColors.dullWhite,
                            //       style: TextStyle(color: isDark.value ? AppColors.dullWhite : AppColors.black),
                            //       decoration: InputDecoration(
                            //           hintText: "Select Subcategory",
                            //           filled: true,
                            //           fillColor: isDark.value ? AppColors.blackBackground : AppColors.dullWhite,
                            //           hintStyle:
                            //           GoogleFonts.plusJakartaSans(color: Colors.grey.shade400, fontSize: 16),
                            //           enabledBorder: OutlineInputBorder(
                            //               borderSide: isDark.value
                            //                   ? BorderSide(color: Colors.grey.shade800)
                            //                   : BorderSide.none,
                            //               borderRadius: BorderRadius.circular(24)),
                            //           border: OutlineInputBorder(
                            //               borderSide: BorderSide(color: AppColors.primaryPink),
                            //               borderRadius: BorderRadius.circular(26))),
                            //       icon: const Icon(Icons.expand_more_outlined),
                            //       items: controller.categoryWiseSubCategory?.data?.map((subCategory) {
                            //         return DropdownMenuItem(
                            //           onTap: () {
                            //             addProductController.subCategory = subCategory.id!;
                            //             log.log(
                            //                 "Subcategory NAME :: ${subCategory.name} ID  :: ${subCategory.id}");
                            //           },
                            //           value: subCategory.name,
                            //           child: Container(
                            //             height: 50,
                            //             color: isDark.value ? AppColors.blackBackground : AppColors.dullWhite,
                            //             child: Center(
                            //               child: Text(
                            //                 subCategory.name.toString(),
                            //                 style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w500),
                            //               ),
                            //             ),
                            //           ),
                            //         );
                            //       }).toList(),
                            //     ),
                            //   ),
                            // ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8, top: 15),
                              child: Row(
                                children: [
                                  Text(
                                    St.categories.tr,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 14,
                                      color: isDark.value ? AppColors.white : AppColors.mediumGrey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            CoolDropdown<dynamic>(
                              controller: categoryDropdownController,
                              dropdownList: getAllCategoryController.categoryDropdownItems,
                              defaultItem: CoolDropdownItem<String>(
                                value: '',
                                label: sellerProductDetailsController.sellerProductDetails!.product![0].category!.name.toString(),
                              ),
                              onChange: (value) async {
                                categoryDropdownController.close();
                                if (categoryDropdownController.isError) {
                                  await categoryDropdownController.resetError();
                                }
                                setState(() {
                                  subcategoryDropdownController.resetValue();
                                  sellerProductDetailsController.selectedCategoryId = value;
                                  log.log("Category Value ::  $value");
                                  addProductController.category = value;
                                  log.log("Category select Value ::  $value");
                                  subcategoryDropdownController.resetValue();
                                  log.log("Subcategory NUll Or Not  ::  ${addProductController.subCategory}");
                                  getAllCategoryController.subCategoryList = getAllCategoryController.categoryList.firstWhere((category) => category.id == addProductController.category).subCategory!;
                                });
                              },
                              resultOptions: ResultOptions(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  height: 60,
                                  width: Get.width,
                                  boxDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(26),
                                    border: Border.all(color: isDark.value ? Colors.grey.shade800 : Colors.transparent),
                                    // border: Border.all(color: AppColors.primaryPink),
                                    color: isDark.value ? AppColors.blackBackground : AppColors.dullWhite,
                                  ),
                                  icon: const SizedBox(
                                    width: 10,
                                    height: 10,
                                    child: CustomPaint(
                                      painter: DropdownArrowPainter(),
                                    ),
                                  ),
                                  // render: ResultRender.all,
                                  placeholder: St.selectCategories.tr,
                                  placeholderTextStyle: GoogleFonts.plusJakartaSans(color: Colors.grey.shade400, fontSize: 16),
                                  textStyle: GoogleFonts.plusJakartaSans(fontSize: 16),
                                  isMarquee: false,
                                  openBoxDecoration: BoxDecoration(borderRadius: BorderRadius.circular(26), border: Border.all(color: Colors.pink, width: 1.8))),
                              dropdownOptions: DropdownOptions(
                                  borderRadius: BorderRadius.circular(10),
                                  top: 10,
                                  height: 325,
                                  gap: const DropdownGap.all(5),
                                  borderSide: BorderSide(color: AppColors.mediumGrey),
                                  color: isDark.value ? AppColors.blackBackground : AppColors.dullWhite,
                                  align: DropdownAlign.left,
                                  animationType: DropdownAnimationType.size),
                              dropdownTriangleOptions: const DropdownTriangleOptions(
                                width: 0,
                                height: 0,
                                // align: DropdownTriangleAlign.left,
                                borderRadius: 5,
                                left: 0,
                              ),
                              dropdownItemOptions: DropdownItemOptions(
                                textStyle: TextStyle(
                                  color: isDark.value ? AppColors.white : AppColors.black,
                                  fontSize: 16,
                                ),
                                selectedTextStyle: TextStyle(color: isDark.value ? AppColors.white : AppColors.black, fontSize: 16, fontWeight: FontWeight.w600),
                                selectedBoxDecoration: BoxDecoration(color: AppColors.primaryPink.withValues(alpha: 0.20)),
                                isMarquee: true,
                                mainAxisAlignment: MainAxisAlignment.start,
                                render: DropdownItemRender.all,
                                height: 50,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8, top: 15),
                              child: Row(
                                children: [
                                  Text(
                                    St.subCategories.tr,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 14,
                                      color: isDark.value ? AppColors.white : AppColors.mediumGrey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            CoolDropdown<dynamic>(
                              controller: subcategoryDropdownController,
                              dropdownList: getAllCategoryController.subcategoryDropdownItems,
                              defaultItem: CoolDropdownItem<String>(
                                value: '',
                                label: sellerProductDetailsController.sellerProductDetails!.product![0].subCategory!.name.toString(),
                              ),
                              onChange: (value) async {
                                subcategoryDropdownController.close();
                                if (subcategoryDropdownController.isError) {
                                  await subcategoryDropdownController.resetError();
                                }
                                setState(() {
                                  sellerProductDetailsController.selectedSubCategoryId = value;
                                  addProductController.subCategory = value;
                                });
                              },
                              resultOptions: ResultOptions(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  height: 60,
                                  width: Get.width,
                                  boxDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(26),
                                    border: Border.all(color: isDark.value ? Colors.grey.shade800 : Colors.transparent),
                                    // border: Border.all(color: AppColors.primaryPink),
                                    color: isDark.value ? AppColors.blackBackground : AppColors.dullWhite,
                                  ),
                                  icon: const SizedBox(
                                    width: 10,
                                    height: 10,
                                    child: CustomPaint(
                                      painter: DropdownArrowPainter(),
                                    ),
                                  ),
                                  // render: ResultRender.all,
                                  placeholder: St.selectCategories.tr,
                                  placeholderTextStyle: GoogleFonts.plusJakartaSans(color: Colors.grey.shade400, fontSize: 16),
                                  textStyle: GoogleFonts.plusJakartaSans(fontSize: 16),
                                  isMarquee: false,
                                  openBoxDecoration: BoxDecoration(borderRadius: BorderRadius.circular(26), border: Border.all(color: Colors.pink, width: 1.8))),
                              dropdownOptions: DropdownOptions(
                                  borderRadius: BorderRadius.circular(10),
                                  top: 10,
                                  height: 325,
                                  gap: const DropdownGap.all(5),
                                  borderSide: BorderSide(color: AppColors.mediumGrey),
                                  color: isDark.value ? AppColors.blackBackground : AppColors.dullWhite,
                                  align: DropdownAlign.left,
                                  animationType: DropdownAnimationType.size),
                              dropdownTriangleOptions: const DropdownTriangleOptions(
                                width: 0,
                                height: 0,
                                // align: DropdownTriangleAlign.left,
                                borderRadius: 5,
                                left: 0,
                              ),
                              dropdownItemOptions: DropdownItemOptions(
                                textStyle: TextStyle(
                                  color: isDark.value ? AppColors.white : AppColors.black,
                                  fontSize: 16,
                                ),
                                selectedTextStyle: TextStyle(color: isDark.value ? AppColors.white : AppColors.black, fontSize: 16, fontWeight: FontWeight.w600),
                                selectedBoxDecoration: BoxDecoration(color: AppColors.primaryPink.withValues(alpha: 0.20)),
                                isMarquee: true,
                                mainAxisAlignment: MainAxisAlignment.start,
                                render: DropdownItemRender.all,
                                height: 50,
                              ),
                            ),
                            /*Column(
                              children: [
                                DropdownButtonFormField<String>(
                                  value: sellerProductDetailsController.selectedCategoryId,
                                  onChanged: (value) {
                                    setState(() {
                                      sellerProductDetailsController.selectedCategoryId = value!;
                                      log.log(
                                          "${sellerProductDetailsController.selectedCategoryId} Value ::  $value");

                                      bool isCategoryExists = getAllCategoryController.categoryList
                                          .any((category) => category.id == value);
                                      if (isCategoryExists) {
                                        sellerProductDetailsController.selectedSubCategoryId =
                                            getAllCategoryController.categoryList
                                                .firstWhere((category) => category.id == value)
                                                .subCategory![0]
                                                .id!;
                                      } else {
                                        sellerProductDetailsController.selectedSubCategoryId = '';
                                      }
                                    });
                                  },
                                  items: getAllCategoryController.categoryList
                                      .map<DropdownMenuItem<String>>((category) {
                                    return DropdownMenuItem<String>(
                                      // onTap: () {},
                                      value: category.id,
                                      child: Text(category.name.toString()),
                                    );
                                  }).toList(),
                                ),
                                DropdownButtonFormField<String>(
                                  value: sellerProductDetailsController.selectedSubCategoryId,
                                  onChanged: (value) {
                                    setState(() {
                                      sellerProductDetailsController.selectedSubCategoryId = value!;
                                    });
                                  },
                                  items: getAllCategoryController.categoryList
                                          .firstWhere(
                                            (category) =>
                                                category.id == sellerProductDetailsController.selectedCategoryId,
                                            orElse: () => Category(),
                                          )
                                          .subCategory
                                          ?.map<DropdownMenuItem<String>>((subcategory) {
                                        return DropdownMenuItem<String>(
                                          value: subcategory.id,
                                          child: Text(subcategory.name.toString()),
                                        );
                                      }).toList() ??
                                      [],
                                ),
                              ],
                            ),*/
                            const SizedBox(height: 15),
                            PrimaryTextField(
                              titleText: St.shippingCharge.tr,
                              hintText: St.shippingCharge.tr,
                              controllerType: "ShippingCharge",
                            ),
                            const SizedBox(height: 15),
                            // Wrap(
                            //   children: attributesAddProductController.attributeAddProduct!.attributes!.map((attributes) {
                            //     if (attributes.type!.isNotEmpty) {
                            //       // log.log(
                            //       //     "Selected Category Values :: ${sellerProductDetailsController.selectedCategoryValues!}");
                            //       return Column(
                            //         children: [
                            //           Padding(
                            //             padding: const EdgeInsets.only(bottom: 8),
                            //             child: Row(
                            //               children: [
                            //                 Text(
                            //                   attributes.name!.capitalizeFirst.toString(),
                            //                   style: GoogleFonts.plusJakartaSans(
                            //                     fontSize: 14,
                            //                     color: isDark.value ? AppColors.white : AppColors.mediumGrey,
                            //                     fontWeight: FontWeight.w500,
                            //                   ),
                            //                 ),
                            //               ],
                            //             ),
                            //           ),
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
                            //                     padding: const EdgeInsets.only(left: 10, top: 19),
                            //                     decoration: BoxDecoration(
                            //                       borderRadius: BorderRadius.circular(24),
                            //                       border: Border.all(width: 0.6, color: isDark.value ? Colors.grey.shade700 : Colors.transparent),
                            //                       color: isDark.value ? AppColors.blackBackground : AppColors.dullWhite,
                            //                     ),
                            //                     child: sellerProductDetailsController.selectedValuesByType[attributes.type] == null ||
                            //                             sellerProductDetailsController.selectedValuesByType[attributes.type]!.isEmpty
                            //                         ? Text(
                            //                             "${St.select.tr} ${attributes.name}",
                            //                             style: GoogleFonts.plusJakartaSans(
                            //                               fontSize: 16,
                            //                               color: AppColors.mediumGrey,
                            //                             ),
                            //                           )
                            //                         // : Text(sellerProductDetailsController
                            //                         //     .selectedValuesByType[attributes.type]!
                            //                         //     .map((e) => e.toString())
                            //                         //     .toList()
                            //                         //     .join(", ")),
                            //
                            //                         : attributes.name == "Colors"
                            //                             ? ListView.builder(
                            //                                 scrollDirection: Axis.horizontal,
                            //                                 itemCount: sellerProductDetailsController.selectedValuesByType[attributes.type]?.length,
                            //                                 itemBuilder: (context, index) {
                            //                                   print(
                            //                                       "selectedValuesByType${sellerProductDetailsController.selectedValuesByType[attributes.type]![index]}");
                            //                                   return Container(
                            //                                     width: 30,
                            //                                     height: 30,
                            //                                     decoration: BoxDecoration(
                            //                                       shape: BoxShape.circle,
                            //                                       color: Color(int.parse(sellerProductDetailsController
                            //                                           .selectedValuesByType[attributes.type]![index]
                            //                                           .replaceAll("#", "0xFF"))),
                            //                                     ),
                            //                                   ).paddingOnly(bottom: 14);
                            //                                 },
                            //                               )
                            //                             : Text(sellerProductDetailsController.selectedValuesByType[attributes.type]!
                            //                                 .map((e) => e.toString())
                            //                                 .toList()
                            //                                 .join(", ")),
                            //                   );
                            //                 },
                            //                 body: Container(
                            //                   decoration: BoxDecoration(
                            //                     borderRadius: BorderRadius.circular(24),
                            //                   ),
                            //                   child: Column(
                            //                     children: [
                            //                       /*     SizedBox(
                            //                         width: Get.width,
                            //                         child: Wrap(
                            //                           spacing: 10,
                            //                           children: attributes.value!.map((value) {
                            //                             return FilterChip(
                            //                               padding: const EdgeInsets.symmetric(
                            //                                   vertical: 3, horizontal: 4),
                            //                               onSelected: (selected) {
                            //                                 setState(() {
                            //                                   sellerProductDetailsController.toggleSelection(
                            //                                       value, attributes.type.toString());
                            //                                 });
                            //                                 log.log(
                            //                                     "SELECTED VALUE :: $value \n TYPE ::${attributes.type} \n ID ::${attributes.id}\n NAME ::${attributes.name}");
                            //                                 log.log(
                            //                                     "SELECTED EDIT PRODUCT:: ${sellerProductDetailsController.selectedValuesByType}");
                            //                               },
                            //                               selectedColor: AppColors.primaryPink,
                            //                               backgroundColor: isDark.value
                            //                                   ? AppColors.blackBackground
                            //                                   : AppColors.dullWhite,
                            //                               side: BorderSide(
                            //                                   width: 0.8,
                            //                                   color: sellerProductDetailsController
                            //                                               .selectedValuesByType
                            //                                               .containsKey(attributes.type) &&
                            //                                           sellerProductDetailsController
                            //                                               .selectedValuesByType[attributes.type]!
                            //                                               .contains(value)
                            //                                       ? AppColors.primaryPink
                            //                                       : Colors.grey.shade600.withValues(alpha:0.40)),
                            //                               label: Padding(
                            //                                 padding: const EdgeInsets.symmetric(
                            //                                     vertical: 6, horizontal: 15),
                            //                                 child: Text(
                            //                                   value,
                            //                                   style: GoogleFonts.plusJakartaSans(
                            //                                     color: sellerProductDetailsController
                            //                                                 .selectedValuesByType
                            //                                                 .containsKey(attributes.type) &&
                            //                                             sellerProductDetailsController
                            //                                                 .selectedValuesByType[attributes.type]!
                            //                                                 .contains(value)
                            //                                         ? AppColors.primaryPink
                            //                                         : Colors.grey.shade600.withValues(alpha:0.40),
                            //                                     fontWeight: FontWeight.w600,
                            //                                     fontSize: 15.5,
                            //                                   ),
                            //                                 ),
                            //                               ),
                            //                             );
                            //                           }).toList(),
                            //                         ),
                            //                       ),*/
                            //                       SizedBox(
                            //                         width: Get.width,
                            //                         child: Wrap(
                            //                           spacing: 10,
                            //                           children: attributes.value!.map((value) {
                            //                             return attributes.type.toString() == "colors"
                            //                                 ? GestureDetector(
                            //                                     onTap: () {
                            //                                       setState(() {
                            //                                         sellerProductDetailsController.toggleSelection(value, attributes.type.toString());
                            //                                       });
                            //                                       log.log("SELECTED :: VALUE :: $value TYPE ::${attributes.type}");
                            //                                       log.log("SELECTED TYPE :: ${sellerProductDetailsController.selectedValuesByType}");
                            //                                     },
                            //                                     child: Container(
                            //                                       width: 45,
                            //                                       height: 45,
                            //                                       decoration: BoxDecoration(
                            //                                           shape: BoxShape.circle,
                            //                                           border: Border.all(
                            //                                             color: sellerProductDetailsController.selectedValuesByType
                            //                                                         .containsKey(attributes.type) &&
                            //                                                     sellerProductDetailsController.selectedValuesByType[attributes.type]!
                            //                                                         .contains(value)
                            //                                                 ? AppColors.primaryPink
                            //                                                 : Colors.transparent,
                            //                                             width: 2,
                            //                                           )),
                            //                                       child: Padding(
                            //                                         padding: const EdgeInsets.all(1.5),
                            //                                         child: Container(
                            //                                           decoration: BoxDecoration(
                            //                                               color: Color(int.parse(value.replaceAll("#", "0xFF"))),
                            //                                               shape: BoxShape.circle),
                            //                                         ),
                            //                                       ),
                            //                                     ),
                            //                                   )
                            //                                 : FilterChip(
                            //                                     padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
                            //                                     onSelected: (selected) {
                            //                                       setState(() {
                            //                                         sellerProductDetailsController.toggleSelection(value, attributes.type.toString());
                            //                                       });
                            //                                       log.log("SELECTED :: $selected VALUE :: $value TYPE ::${attributes.type}");
                            //                                       log.log("SELECTED TYPE :: ${sellerProductDetailsController.selectedValuesByType}");
                            //                                     },
                            //                                     selectedColor: AppColors.primaryPink,
                            //                                     backgroundColor: isDark.value ? AppColors.blackBackground : AppColors.dullWhite,
                            //                                     side: BorderSide(
                            //                                         width: 0.8,
                            //                                         color: sellerProductDetailsController.selectedValuesByType
                            //                                                     .containsKey(attributes.type) &&
                            //                                                 sellerProductDetailsController.selectedValuesByType[attributes.type]!
                            //                                                     .contains(value)
                            //                                             ? AppColors.primaryPink
                            //                                             : Colors.grey.shade600.withValues(alpha: 0.40)),
                            //                                     label: Padding(
                            //                                       padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                            //                                       child: Text(
                            //                                         value,
                            //                                         style: GoogleFonts.plusJakartaSans(
                            //                                           color: sellerProductDetailsController.selectedValuesByType
                            //                                                       .containsKey(attributes.type) &&
                            //                                                   sellerProductDetailsController.selectedValuesByType[attributes.type]!
                            //                                                       .contains(value)
                            //                                               ? AppColors.primaryPink
                            //                                               : Colors.grey.shade600.withValues(alpha: 0.40),
                            //                                           fontWeight: FontWeight.w600,
                            //                                           fontSize: 15.5,
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
                            //           const SizedBox(
                            //             height: 10,
                            //           ),
                            //         ],
                            //       );
                            //     } else {
                            //       return Container();
                            //     }
                            //   }).toList(),
                            // ),
                            const SizedBox(height: 15),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Text(
                                    St.description.tr,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 14,
                                      color: isDark.value ? AppColors.white : AppColors.mediumGrey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Obx(
                              () => TextField(
                                onSubmitted: (value) {
                                  editProductController.descriptionController.text = value;
                                },
                                controller: sellerProductDetailsController.descriptionController,
                                onChanged: (value) {
                                  editProductController.descriptionController.text = value;
                                },
                                maxLines: 15,
                                minLines: 7,
                                style: TextStyle(color: isDark.value ? AppColors.dullWhite : AppColors.black),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: isDark.value ? AppColors.blackBackground : AppColors.dullWhite,
                                  enabledBorder: OutlineInputBorder(borderSide: isDark.value ? BorderSide(color: Colors.grey.shade800) : BorderSide.none, borderRadius: BorderRadius.circular(24)),
                                  border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryPink), borderRadius: BorderRadius.circular(26)),
                                  hintText: St.addAboutYourProduct.tr,
                                  hintStyle: GoogleFonts.plusJakartaSans(height: 1.6, color: AppColors.mediumGrey, fontSize: 15),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: PrimaryPinkButton(
                                  onTaped: () {
                                    editProductController.isLoading.value = true;
                                    editProductController.editCatalog(
                                      images: files,
                                      mainImage: files[0],
                                      productCode: sellerProductDetailsController.productCode.toString(),
                                      productName: addProductController.nameController.text.capitalizeFirst.toString(),
                                      price: addProductController.priceController.text,
                                      category: sellerProductDetailsController.selectedCategoryId,
                                      subCategory: sellerProductDetailsController.selectedSubCategoryId,
                                      shippingCharges: addProductController.shippingChargeController.text,
                                      description: editProductController.descriptionController.text,
                                    );
                                  },
                                  text: St.editCatalog.tr),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
          }),
        ),
        Obx(() => editProductController.isLoading.value ? ScreenCircular.blackScreenCircular() : const SizedBox()),
      ],
    );
  }
}

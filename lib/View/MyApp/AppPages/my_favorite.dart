import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:waxxapp/Controller/GetxController/user/new_collection_controller.dart';
import 'package:waxxapp/Controller/GetxController/user/show_favorite_controller.dart';
import 'package:waxxapp/custom/circle_button_widget.dart';
import 'package:waxxapp/utils/CoustomWidget/App_theme_services/no_data_found.dart';
import 'package:waxxapp/utils/CoustomWidget/App_theme_services/text_titles.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/Theme/theme_service.dart';
import 'package:waxxapp/utils/app_asset.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/app_constant.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/shimmers.dart';
import 'package:waxxapp/utils/show_toast.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controller/GetxController/user/get_all_category_controller.dart';

class MyFavorite extends StatefulWidget {
  const MyFavorite({super.key});

  @override
  State<MyFavorite> createState() => _MyFavoriteState();
}

class _MyFavoriteState extends State<MyFavorite> with TickerProviderStateMixin {
  ShowFavoriteController showFavoriteController = Get.put(ShowFavoriteController());
  GetAllCategoryController getAllCategoryController = Get.put(GetAllCategoryController());
  NewCollectionController addToFavoriteController = Get.put(NewCollectionController());

  // late final TabController tabController;

  @override
  void initState() {
    super.initState();
    showFavoriteController.getFavoriteData();
    // await getAllCategoryController.getCategory();
    //     .then((value) => tabBarLength())
    //     .then((value) => _handleTabChange());
    // tabController.addListener(() {
    //   _handleTabChange();
    // });
  }

  // void tabBarLength() {
  //   tabController = TabController(length: getAllCategoryController.getAllCategory!.category!.length, vsync: this);
  //   log("Category length :: ${getAllCategoryController.getAllCategory!.category!.length}");
  // }

  // void _handleTabChange() {
  //   setState(() {
  //     int selectedIndex = tabController.index;
  //     log("Selected Index :: $selectedIndex");
  //     String selectedCategory = getAllCategoryController.getAllCategory!.category![selectedIndex].id.toString();
  //     log("Selected category :: $selectedCategory");
  //     showFavoriteController.getFavoriteData(selectCategory: selectedCategory);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // Favorites/Wishlist used to be a bottom-nav root, which is why the
    // original build wrapped everything in a PopScope(canPop: false) that
    // routed system-back to the Home tab. Now it's pushed from the profile
    // menu, so we just use a normal back-arrow AppBar and let Navigator
    // handle pop as usual.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.black,
        surfaceTintColor: AppColors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text('Wishlist', style: AppFontStyle.styleW700(AppColors.white, 16)),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            15.height,
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 19,
              ),
              child: GeneralTitle(title: "Wishlist Collection"),
            ),
            Expanded(
              child: Obx(
              () => showFavoriteController.isLoading.value /*|| getAllCategoryController.isLoading.value*/
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      child: Shimmers.productGridviewShimmer(),
                    )
                  : showFavoriteController.favoriteProducts.isEmpty
                      ? noDataFound(image: "assets/no_data_found/basket.png", text: St.wishListIsEmpty.tr).paddingOnly(top: Get.height * .25)
                      /*: ListView.builder(
                          padding: const EdgeInsets.only(top: 10),
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: showFavoriteController.favoriteProducts.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                              child: SizedBox(
                                height: 120,
                                child: Stack(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: CachedNetworkImage(
                                            height: double.maxFinite,
                                            width: Get.width / 4.3,
                                            fit: BoxFit.cover,
                                            imageUrl: showFavoriteController.favoriteProducts[index].mainImage.toString(),
                                            placeholder: (context, url) => const Center(
                                                child: CupertinoActivityIndicator(
                                              animating: true,
                                            )),
                                            errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 15),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 10),
                                                child: SizedBox(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: Get.width / 2.3,
                                                        // color: Colors.amber,
                                                        child: Text(
                                                          showFavoriteController.favoriteProducts[index].productName,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w500),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "$currencySymbol${showFavoriteController.favoriteProducts[index].price}",
                                                    // "$currencySymbol${showFavoriteController.favoriteItems!.favorite![index].product![0].price}",
                                                    style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 12),
                                                    child: Text(
                                                      showFavoriteController.favoriteProducts[index].subCategory,
                                                      style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w300),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const Spacer(),
                                              Padding(
                                                padding: const EdgeInsets.only(bottom: 8),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    productId = showFavoriteController.favoriteProducts[index].id;
                                                    Get.toNamed("/ProductDetail");
                                                  },
                                                  child: Container(
                                                    height: 29,
                                                    width: Get.width / 3.6,
                                                    decoration: BoxDecoration(
                                                      color: AppColors.primaryPink,
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    child: Center(
                                                      child: Text("Add to cart", style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.white)),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 5, right: 15),
                                        child: GestureDetector(
                                          onTap: () async {
                                            setState(() {
                                              showFavoriteController.favoriteProducts.removeAt(index);

                                              log("Product ID ${showFavoriteController.favoriteItems!.favorite![index].product![0].id}");
                                              log("Category  ID ${showFavoriteController.favoriteItems!.favorite![index].categoryId}");

                                              addToFavoriteController.postFavoriteData(
                                                  productId: "${showFavoriteController.favoriteItems!.favorite![index].product![0].id}",
                                                  categoryId: "${showFavoriteController.favoriteItems!.favorite![index].categoryId}");
                                            });
                                          },
                                          child: Container(
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                              color: isDark.value ? Colors.white.withValues(alpha:0.30) : const Color(0xffeceded),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),*/
                      : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: GridView.builder(
                            // physics: const BouncingScrollPhysics(),
                            shrinkWrap: false,
                            itemCount: showFavoriteController.favoriteProducts.length,
                            padding: const EdgeInsets.only(bottom: 100),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              crossAxisCount: 2,
                              mainAxisExtent: 250,
                            ),
                            itemBuilder: (context, index) {
                              final product = showFavoriteController.favoriteProducts[index];
                              return GestureDetector(
                                onTap: () {
                                  productId = product.id;
                                  Get.toNamed("/ProductDetail");
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.tabBackground,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          clipBehavior: Clip.antiAlias,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15),
                                            ),
                                          ),
                                          child: Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              AspectRatio(
                                                aspectRatio: 1,
                                                child: CachedNetworkImage(
                                                    imageUrl: product.mainImage.toString(),
                                                    placeholder: (context, url) => Image.asset(
                                                          AppAsset.categoryPlaceholder,
                                                          height: 22,
                                                        ).paddingAll(30),
                                                    errorWidget: (context, url, error) => Image.asset(
                                                          AppAsset.categoryPlaceholder,
                                                          height: 22,
                                                        ).paddingAll(30),
                                                    fit: BoxFit.cover),
                                              ),

                                              Align(
                                                alignment: Alignment.topRight,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top: 5, right: 5, left: 5),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Offstage(),
                                                      CircleButtonWidget(
                                                          callback: () {
                                                            if (getStorage.read("isDemoLogin") ?? false || isDemoSeller) {
                                                              displayToast(message: St.thisIsDemoUser.tr);
                                                              return;
                                                            }
                                                            setState(() {
                                                              showFavoriteController.favoriteProducts.removeAt(index);

                                                              log("Product ID ${showFavoriteController.favoriteItems!.favorite![index].product![0].id}");
                                                              log("Category ID ${showFavoriteController.favoriteItems!.favorite![index].categoryId}");

                                                              addToFavoriteController.postFavoriteData(
                                                                  productId: "${showFavoriteController.favoriteItems!.favorite![index].product![0].id}", categoryId: "${showFavoriteController.favoriteItems!.favorite![index].categoryId}");
                                                            });
                                                          },
                                                          size: 30,
                                                          color: AppColors.black.withValues(alpha: 0.15),
                                                          child: const Icon(
                                                            Icons.remove_circle_outline,
                                                            color: Colors.white,
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                              /// TODO
                                              /// Era 2.0
                                              // Positioned(
                                              //   top: 5,
                                              //   right: 5,
                                              //   child: CircleButtonWidget(
                                              //     size: 30,
                                              //     color: AppColors.white,
                                              //     child: Image.asset(AppAsset.icHeart,
                                              //         width: 16, color: AppColors.black),
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product.productName,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontWeight: FontWeight.bold, fontFamily: AppConstant.appFontRegular, color: AppColors.white, fontSize: 11),
                                            ),
                                            2.height,
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "$currencySymbol ${product.price}",
                                                  overflow: TextOverflow.ellipsis,
                                                  style: AppFontStyle.styleW900(AppColors.primary, 15),
                                                ),
                                                5.width,

                                                /// TODO
                                                /// Era 2.0
                                                // Text(
                                                //   "$currencySymbol 550.00",
                                                //   overflow: TextOverflow.ellipsis,
                                                //   style: AppFontStyle.styleW900(
                                                //  AppColors.unselected,
                                                //   10,
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        width: Get.width,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(15),
                                            bottomRight: Radius.circular(15),
                                          ),
                                        ),
                                        child: Text(
                                          St.addToCart.tr,
                                          style: AppFontStyle.styleW900(AppColors.black, 14),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                              // return GestureDetector(
                              //   onTap: () {
                              //     productId = galleryCategoryController.galleryProducts[index].id!;
                              //     Get.toNamed("/ProductDetail");
                              //   },
                              //   child: SizedBox(
                              //     height: 150,
                              //     child: Stack(
                              //       children: [
                              //         Column(
                              //           crossAxisAlignment: CrossAxisAlignment.start,
                              //           children: [
                              //             ClipRRect(
                              //               borderRadius: BorderRadius.circular(10),
                              //               child: CachedNetworkImage(
                              //                 height: 180,
                              //                 width: double.maxFinite,
                              //                 fit: BoxFit.cover,
                              //                 imageUrl: galleryCategoryController.galleryProducts[index].mainImage.toString(),
                              //                 placeholder: (context, url) => const Center(
                              //                     child: CupertinoActivityIndicator(
                              //                   animating: true,
                              //                 )),
                              //                 errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                              //               ),
                              //             ),
                              //             Padding(
                              //               padding: const EdgeInsets.only(top: 7),
                              //               child: Text(
                              //                 "${galleryCategoryController.galleryProducts[index].productName}",
                              //                 overflow: TextOverflow.ellipsis,
                              //                 style: GoogleFonts.plusJakartaSans(
                              //                   fontSize: 14,
                              //                 ),
                              //               ),
                              //             ),
                              //             Padding(
                              //               padding: const EdgeInsets.only(top: 7),
                              //               child: Text(
                              //                 "$currencySymbol${galleryCategoryController.galleryProducts[index].price}",
                              //                 style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.bold),
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //         Align(
                              //           alignment: Alignment.topRight,
                              //           child: Padding(
                              //             padding: const EdgeInsets.all(8.0),
                              //             child: GestureDetector(
                              //               onTap: () {
                              //                 setState(() {
                              //                   _likes[index] = !_likes[index];
                              //                 });
                              //
                              //                 addToFavoriteController.postFavoriteData(
                              //                     productId: "${galleryCategoryController.galleryProducts[index].id}",
                              //                     categoryId: "${galleryCategoryController.galleryProducts[index].category!.id}");
                              //               },
                              //               child: Container(
                              //                 height: 32,
                              //                 width: 32,
                              //                 decoration: BoxDecoration(
                              //                   color: AppColors.white,
                              //                   shape: BoxShape.circle,
                              //                 ),
                              //                 child: Padding(
                              //                   padding: const EdgeInsets.all(8.0),
                              //                   child: Image(
                              //                     image:
                              //                         // galleryCategoryController.galleryCategory!.product![index].isFavorite
                              //                         galleryCategoryController.galleryProducts[index].isFavorite == true & _likes[index]
                              //                             ? AssetImage(AppImage.productLike)
                              //                             : AssetImage(AppImage.productDislike),
                              //                   ),
                              //                 ),
                              //               ),
                              //             ),
                              //           ),
                              //         )
                              //       ],
                              //     ),
                              //   ),
                              // );
                            },
                          ),
                        ),
            ),
            ),
          ],
        ),
    );
  }
}

/// if category wise show data in wishlist
// TabBarView(
// physics: const BouncingScrollPhysics(),
// controller: tabController,
// children: getAllCategoryController.getAllCategory!.category!.map((e) {
// return

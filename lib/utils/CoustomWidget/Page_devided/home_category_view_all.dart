import 'package:cached_network_image/cached_network_image.dart';
import 'package:era_shop/Controller/GetxController/user/gallery_catagory_controller.dart';
import 'package:era_shop/Controller/GetxController/user/get_all_category_controller.dart';
import 'package:era_shop/Controller/GetxController/user/new_collection_controller.dart';
import 'package:era_shop/utils/CoustomWidget/App_theme_services/no_data_found.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/Theme/theme_service.dart';
import 'package:era_shop/utils/app_asset.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/app_constant.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:era_shop/utils/shimmers.dart';
import 'package:era_shop/utils/show_toast.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeCategoryViewAll extends StatefulWidget {
  const HomeCategoryViewAll({super.key});

  @override
  State<HomeCategoryViewAll> createState() => _HomeCategoryViewAllState();
}

class _HomeCategoryViewAllState extends State<HomeCategoryViewAll> with SingleTickerProviderStateMixin {
  GalleryCategoryController galleryCategoryController = Get.put(GalleryCategoryController());
  GetAllCategoryController getAllCategoryController = Get.isRegistered<GetAllCategoryController>() ? Get.find<GetAllCategoryController>() : Get.put(GetAllCategoryController());
  NewCollectionController addToFavoriteController = Get.put(NewCollectionController());

  ScrollController scrollController = ScrollController();
  bool isApiCalling = true;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getAllCategoryController.selectedTabIndex = 0;

      if (getAllCategoryController.getAllCategory?.category?.isEmpty ?? true) {
        await getAllCategoryController.getCategory();
      }

      _initializeViewAllTabController();
      _handleTabChange();

      galleryCategoryController.viewAllTabController!.addListener(() {
        galleryCategoryController.galleryProducts.clear();
        _handleTabChange();
      });

      setState(() {});
    });
  }

  void _initializeViewAllTabController() {
    if (getAllCategoryController.getAllCategory?.category?.isNotEmpty ?? false) {
      final tabController = TabController(
        length: getAllCategoryController.getAllCategory!.category!.length,
        vsync: this,
        initialIndex: getAllCategoryController.selectedTabIndex.clamp(0, getAllCategoryController.getAllCategory!.category!.length - 1),
      );
      galleryCategoryController.viewAllTabController = tabController;
    }
  }

  Future<void> _handleTabChange() async {
    final tabController = galleryCategoryController.viewAllTabController;
    if (tabController == null) return;

    int selectedIndex = tabController.index;
    String selectedCategory = getAllCategoryController.getAllCategory!.category![selectedIndex].id.toString();

    if (selectedIndex == tabController.index) {
      galleryCategoryController.isLoading(true);
      await galleryCategoryController.getCategoryData(selectCategory: selectedCategory);
      syncLikesWithProducts();
      galleryCategoryController.update();
    }
  }

  void syncLikesWithProducts() {
    final products = galleryCategoryController.galleryProducts;
    galleryCategoryController.likes = List<bool>.generate(products.length, (i) => products[i].isFavorite == true);
    galleryCategoryController.update();
  }

  void _scrollListener() {
    final tabController = galleryCategoryController.viewAllTabController;
    if (tabController == null) return;

    if (scrollController.offset >= scrollController.position.maxScrollExtent && !scrollController.position.outOfRange) {
      int selectedIndex = tabController.index;
      String selectedCategory = getAllCategoryController.getAllCategory!.category![selectedIndex].id.toString();
      galleryCategoryController.loadMoreData(selectCategory: selectedCategory);
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.transparent,
          surfaceTintColor: AppColors.transparent,
          flexibleSpace: SafeArea(
            child: Container(
              color: AppColors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        height: 48,
                        width: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(AppAsset.icBack, width: 15),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          St.newCategories.tr,
                          style: AppFontStyle.styleW900(AppColors.white, 18),
                        ),
                      ),
                    ),
                    16.width,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        backgroundColor: AppColors.black,
        color: AppColors.primary,
        onRefresh: () async {
          await getAllCategoryController.getCategory();
          if (galleryCategoryController.viewAllTabController != null) {
            _handleTabChange();
          }
        },
        child: Column(
          children: [
            Container(
              width: Get.width,
              color: AppColors.black,
              padding: const EdgeInsets.only(left: 15, top: 10),
              child: GetBuilder<GetAllCategoryController>(
                id: "onChangeTab",
                builder: (controller) => Obx(
                  () {
                    final viewAllTabController = galleryCategoryController.viewAllTabController;

                    if (controller.isLoading.value && galleryCategoryController.isLoading.value) {
                      return _categoriesShimmer();
                    }

                    if (viewAllTabController == null) {
                      return const SizedBox.shrink();
                    }

                    return TabBar(
                      controller: viewAllTabController,
                      physics: const BouncingScrollPhysics(),
                      onTap: (value) {
                        galleryCategoryController.galleryProducts.clear();
                        galleryCategoryController.isLoading(true);
                        galleryCategoryController.update();
                        getAllCategoryController.onChangeTab(value);
                      },
                      indicator: BoxDecoration(
                        color: AppColors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      isScrollable: true,
                      unselectedLabelColor: AppColors.white,
                      unselectedLabelStyle: GoogleFonts.plusJakartaSans(
                        color: AppColors.white,
                      ),
                      dividerColor: AppColors.transparent,
                      padding: EdgeInsets.zero,
                      labelPadding: const EdgeInsets.only(right: 10),
                      indicatorPadding: EdgeInsets.zero,
                      tabAlignment: TabAlignment.start,
                      tabs: getAllCategoryController.getAllCategory?.category?.map<Tab>((category) {
                            bool isSelected = getAllCategoryController.getAllCategory?.category?[getAllCategoryController.selectedTabIndex].name == category.name;
                            return Tab(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.primary : AppColors.tabBackground,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  category.name.toString().capitalizeFirst ?? "",
                                  style: AppFontStyle.styleW700(
                                    isSelected ? AppColors.black : AppColors.unselected,
                                    13,
                                  ),
                                ),
                              ),
                            );
                          }).toList() ??
                          [],
                    );
                  },
                ),
              ),
            ),

            // Products Grid View
            Expanded(
              child: GetBuilder<GalleryCategoryController>(
                builder: (galleryCategoryController) => Obx(
                  () => galleryCategoryController.isLoading.value
                      ? Shimmers.productGridviewShimmer().paddingSymmetric(vertical: 12, horizontal: 12)
                      : galleryCategoryController.galleryProducts.isEmpty
                          ? noDataFound(
                              image: "assets/no_data_found/basket.png",
                              text: "No Product found !!",
                            )
                          : SingleChildScrollView(
                              controller: scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    GridView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 0.70,
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 12,
                                      ),
                                      itemCount: galleryCategoryController.galleryProducts.length,
                                      itemBuilder: (context, index) {
                                        final product = galleryCategoryController.galleryProducts[index];
                                        return _buildProductCard(product, index);
                                      },
                                    ),
                                    // Loading more indicator
                                    Obx(
                                      () => galleryCategoryController.moreLoading.value
                                          ? Container(
                                              margin: const EdgeInsets.symmetric(vertical: 20),
                                              child: const CircularProgressIndicator(),
                                            )
                                          : const SizedBox.shrink(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(dynamic product, int index) {
    final liked = (index < galleryCategoryController.likes.length ? galleryCategoryController.likes[index] : (product.isFavorite == true));

    return GestureDetector(
      onTap: () {
        productId = product.id ?? '';
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
                    CachedNetworkImage(
                      imageUrl: product.mainImage.toString(),
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Image.asset(
                        AppAsset.categoryPlaceholder,
                        height: 22,
                      ).paddingAll(40),
                      placeholder: (context, url) => Image.asset(
                        AppAsset.categoryPlaceholder,
                        height: 22,
                      ).paddingAll(40),
                    ),
                    // Timer and Favorite Button
                    Positioned(
                      top: 8,
                      left: 8,
                      right: 8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Favorite Button
                          GestureDetector(
                            onTap: () async {
                              if (getStorage.read("isDemoLogin") ?? false || isDemoSeller) {
                                displayToast(message: St.thisIsDemoUser.tr);
                                return;
                              }

                              final old = galleryCategoryController.likes[index];
                              galleryCategoryController.likes[index] = !old;
                              galleryCategoryController.update();
                              try {
                                await addToFavoriteController.postFavoriteData(
                                  productId: "${product.id}",
                                  categoryId: "${product.category!.id}",
                                );
                              } catch (e) {
                                galleryCategoryController.likes[index] = old;
                                galleryCategoryController.update();
                                displayToast(message: St.somethingWentWrong.tr);
                              }
                            },
                            child: Container(
                              height: 32,
                              width: 32,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image(
                                  image: liked ? AssetImage(AppAsset.icHeartFill) : AssetImage(AppAsset.icHeart),
                                  color: liked ? AppColors.red : null,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.productName ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: AppConstant.appFontRegular,
                      color: AppColors.white,
                      fontSize: 12,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "$currencySymbol ${product.price}",
                          style: AppFontStyle.styleW900(AppColors.primary, 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(
                        Icons.star_rounded,
                        color: Color(0xffFACC15),
                        size: 14,
                      ),
                      2.width,
                      Text(
                        product.rating!.isEmpty ? St.noReviews.tr : "${product.rating?[0].avgRating}.0",
                        style: AppFontStyle.styleW500(AppColors.unselected, 9),
                      ),
                    ],
                  ),

                  // Description
                  Text(
                    "${product.description}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppFontStyle.styleW500(AppColors.unselected, 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoriesShimmer() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int i = 0; i <= 3; i++)
            Container(
              height: 40,
              width: 120,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.darkGrey.withValues(alpha: 0.35),
              ),
            ),
        ],
      ),
    );
  }
}

// import 'dart:io';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:era_shop/Controller/GetxController/user/gallery_catagory_controller.dart';
// import 'package:era_shop/Controller/GetxController/user/get_all_category_controller.dart';
// import 'package:era_shop/Controller/GetxController/user/new_collection_controller.dart';
// import 'package:era_shop/custom/timer_widget.dart';
// import 'package:era_shop/utils/CoustomWidget/App_theme_services/no_data_found.dart';
// import 'package:era_shop/utils/CoustomWidget/App_theme_services/text_titles.dart';
// import 'package:era_shop/utils/Strings/strings.dart';
// import 'package:era_shop/utils/Theme/theme_service.dart';
// import 'package:era_shop/utils/app_asset.dart';
// import 'package:era_shop/utils/app_colors.dart';
// import 'package:era_shop/utils/app_constant.dart';
// import 'package:era_shop/utils/font_style.dart';
// import 'package:era_shop/utils/globle_veriables.dart';
// import 'package:era_shop/utils/shimmers.dart';
// import 'package:era_shop/utils/show_toast.dart';
// import 'package:era_shop/utils/utils.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class HomeCategoryViewAll extends StatefulWidget {
//   const HomeCategoryViewAll({super.key});
//
//   @override
//   State<HomeCategoryViewAll> createState() => _HomeCategoryViewAllState();
// }
//
// class _HomeCategoryViewAllState extends State<HomeCategoryViewAll> with SingleTickerProviderStateMixin {
//   GalleryCategoryController galleryCategoryController = Get.put(GalleryCategoryController());
//   GetAllCategoryController getAllCategoryController = Get.isRegistered<GetAllCategoryController>() ? Get.find<GetAllCategoryController>() : Get.put(GetAllCategoryController());
//   NewCollectionController addToFavoriteController = Get.put(NewCollectionController());
//
//   ScrollController scrollController = ScrollController();
//   bool isApiCalling = true;
//
//   @override
//   void initState() {
//     super.initState();
//     scrollController.addListener(_scrollListener);
//
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       getAllCategoryController.selectedTabIndex = 0;
//
//       if (getAllCategoryController.getAllCategory?.category?.isEmpty ?? true) {
//         await getAllCategoryController.getCategory();
//       }
//
//       _initializeViewAllTabController();
//       _handleTabChange();
//
//       galleryCategoryController.viewAllTabController!.addListener(() {
//         galleryCategoryController.galleryProducts.clear();
//         _handleTabChange();
//       });
//
//       setState(() {});
//     });
//   }
//
//   void _initializeViewAllTabController() {
//     if (getAllCategoryController.getAllCategory?.category?.isNotEmpty ?? false) {
//       final tabController = TabController(
//         length: getAllCategoryController.getAllCategory!.category!.length,
//         vsync: this,
//         // initialIndex: getAllCategoryController.selectedTabIndex.clamp(0, getAllCategoryController.getAllCategory!.category!.length - 1),
//       );
//       galleryCategoryController.viewAllTabController = tabController;
//     }
//   }
//
//   // Future<void> _handleTabChange() async {
//   //   final tabController = galleryCategoryController.viewAllTabController;
//   //   if (tabController == null) return;
//   //
//   //   int selectedIndex = tabController.index;
//   //   String selectedCategory = getAllCategoryController.getAllCategory!.category![selectedIndex].id.toString();
//   //
//   //   if (selectedIndex == tabController.index) {
//   //     galleryCategoryController.isLoading(true);
//   //     await galleryCategoryController.getCategoryData(selectCategory: selectedCategory);
//   //     galleryCategoryController.update();
//   //   }
//   // }
//
//   Future<void> _handleTabChange() async {
//     final tabController = galleryCategoryController.viewAllTabController;
//     if (tabController == null) return;
//
//     int selectedIndex = tabController.index;
//
//     getAllCategoryController.selectedTabIndex = selectedIndex;
//
//     String selectedCategory = getAllCategoryController.getAllCategory!.category![selectedIndex].id.toString();
//
//     galleryCategoryController.isLoading(true);
//     await galleryCategoryController.getCategoryData(selectCategory: selectedCategory);
//
//     _initializeLikesArray();
//
//     galleryCategoryController.update();
//   }
//
//   void _initializeLikesArray() {
//     // Initialize likes array with proper favorite states
//     if (galleryCategoryController.galleryProducts.isNotEmpty) {
//       galleryCategoryController.likes = galleryCategoryController.galleryProducts.map((product) => product.isFavorite ?? false).toList();
//     }
//   }
//
//   void _scrollListener() {
//     final tabController = galleryCategoryController.viewAllTabController;
//     if (tabController == null) return;
//
//     if (scrollController.offset >= scrollController.position.maxScrollExtent && !scrollController.position.outOfRange) {
//       int selectedIndex = tabController.index;
//       String selectedCategory = getAllCategoryController.getAllCategory!.category![selectedIndex].id.toString();
//       galleryCategoryController.loadMoreData(selectCategory: selectedCategory);
//     }
//   }
//
//   @override
//   void dispose() {
//     scrollController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.black,
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(60),
//         child: AppBar(
//           automaticallyImplyLeading: false,
//           backgroundColor: AppColors.transparent,
//           surfaceTintColor: AppColors.transparent,
//           flexibleSpace: SafeArea(
//             child: Container(
//               color: AppColors.transparent,
//               padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
//               child: Center(
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     GestureDetector(
//                       onTap: () => Get.back(),
//                       child: Container(
//                         height: 48,
//                         width: 48,
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           color: AppColors.white.withValues(alpha: 0.2),
//                           shape: BoxShape.circle,
//                         ),
//                         child: Image.asset(AppAsset.icBack, width: 15),
//                       ),
//                     ),
//                     Expanded(
//                       child: Align(
//                         alignment: Alignment.center,
//                         child: Text(
//                           St.newCategories.tr,
//                           style: AppFontStyle.styleW900(AppColors.white, 18),
//                         ),
//                       ),
//                     ),
//                     16.width,
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: RefreshIndicator(
//         backgroundColor: AppColors.black,
//         color: AppColors.primary,
//         onRefresh: () async {
//           await getAllCategoryController.getCategory();
//           if (galleryCategoryController.viewAllTabController != null) {
//             _handleTabChange();
//           }
//         },
//         child: Column(
//           children: [
//             Container(
//               width: Get.width,
//               color: AppColors.black,
//               padding: const EdgeInsets.only(left: 15, top: 10),
//               child: GetBuilder<GetAllCategoryController>(
//                 id: "onChangeTab",
//                 builder: (controller) => Obx(
//                       () {
//                     final viewAllTabController = galleryCategoryController.viewAllTabController;
//
//                     if (controller.isLoading.value) {
//                       return _categoriesShimmer();
//                     }
//
//                     if (viewAllTabController == null) {
//                       return const SizedBox.shrink();
//                     }
//
//                     return TabBar(
//                       controller: viewAllTabController,
//                       physics: const BouncingScrollPhysics(),
//                       onTap: (value) {
//                         galleryCategoryController.galleryProducts.clear();
//                         galleryCategoryController.isLoading(true);
//                         galleryCategoryController.update();
//                         getAllCategoryController.onChangeTab(value);
//                       },
//                       indicator: BoxDecoration(
//                         color: AppColors.transparent,
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                       isScrollable: true,
//                       unselectedLabelColor: AppColors.white,
//                       unselectedLabelStyle: GoogleFonts.plusJakartaSans(
//                         color: AppColors.white,
//                       ),
//                       dividerColor: AppColors.transparent,
//                       padding: EdgeInsets.zero,
//                       labelPadding: const EdgeInsets.only(right: 10),
//                       indicatorPadding: EdgeInsets.zero,
//                       tabAlignment: TabAlignment.start,
//                       tabs: getAllCategoryController.getAllCategory?.category?.map<Tab>((category) {
//                         bool isSelected = getAllCategoryController.getAllCategory?.category?[getAllCategoryController.selectedTabIndex].name == category.name;
//                         return Tab(
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 15,
//                               vertical: 10,
//                             ),
//                             decoration: BoxDecoration(
//                               color: isSelected ? AppColors.primary : AppColors.tabBackground,
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Text(
//                               category.name.toString().capitalizeFirst ?? "",
//                               style: AppFontStyle.styleW700(
//                                 isSelected ? AppColors.black : AppColors.unselected,
//                                 13,
//                               ),
//                             ),
//                           ),
//                         );
//                       }).toList() ??
//                           [],
//                     );
//                   },
//                 ),
//               ),
//             ),
//
//             // Products Grid View
//             Expanded(
//               child: GetBuilder<GalleryCategoryController>(
//                 builder: (galleryCategoryController) => Obx(
//                       () => galleryCategoryController.isLoading.value
//                       ? Shimmers.productGridviewShimmer().paddingSymmetric(vertical: 12, horizontal: 12)
//                       : galleryCategoryController.galleryProducts.isEmpty
//                       ? noDataFound(
//                     image: "assets/no_data_found/basket.png",
//                     text: "No Product found !!",
//                   )
//                       : RefreshIndicator(
//                     backgroundColor: AppColors.black,
//                     color: AppColors.primary,
//                     onRefresh: () async {
//                       await _handleTabChange();
//                     },
//                     child: SingleChildScrollView(
//                       controller: scrollController,
//                       physics: const AlwaysScrollableScrollPhysics(),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           children: [
//                             GridView.builder(
//                               shrinkWrap: true,
//                               physics: const NeverScrollableScrollPhysics(),
//                               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                                 crossAxisCount: 2,
//                                 childAspectRatio: 0.70,
//                                 crossAxisSpacing: 12,
//                                 mainAxisSpacing: 12,
//                               ),
//                               itemCount: galleryCategoryController.galleryProducts.length,
//                               itemBuilder: (context, index) {
//                                 final product = galleryCategoryController.galleryProducts[index];
//                                 return _buildProductCard(product, index);
//                               },
//                             ),
//                             // Loading more indicator
//                             Obx(
//                                   () => galleryCategoryController.moreLoading.value
//                                   ? Container(
//                                 margin: const EdgeInsets.symmetric(vertical: 20),
//                                 child: const CircularProgressIndicator(),
//                               )
//                                   : const SizedBox.shrink(),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildProductCard(dynamic product, int index) {
//     return GestureDetector(
//       onTap: () {
//         productId = product.id ?? '';
//         Get.toNamed("/ProductDetail");
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: AppColors.tabBackground,
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: Container(
//                 clipBehavior: Clip.antiAlias,
//                 decoration: const BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(15),
//                     topRight: Radius.circular(15),
//                   ),
//                 ),
//                 child: Stack(
//                   fit: StackFit.expand,
//                   children: [
//                     CachedNetworkImage(
//                       imageUrl: product.mainImage.toString(),
//                       fit: BoxFit.cover,
//                       errorWidget: (context, url, error) => Image.asset(
//                         AppAsset.categoryPlaceholder,
//                         height: 22,
//                       ).paddingAll(40),
//                       placeholder: (context, url) => Image.asset(
//                         AppAsset.categoryPlaceholder,
//                         height: 22,
//                       ).paddingAll(40),
//                     ),
//                     // Timer and Favorite Button
//                     Positioned(
//                       top: 8,
//                       left: 8,
//                       right: 8,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Timer for auction products
//                           product.productSaleType == 2 ? TimerWidget(endDate: product.auctionEndDate) : const SizedBox.shrink(),
//                           // Favorite Button
//                           GetBuilder<GalleryCategoryController>(builder: (logic) {
//                             if (logic.likes.length <= index) {
//                               logic.likes = List.generate(logic.galleryProducts.length, (i) => logic.galleryProducts[i].isFavorite ?? false);
//                             }
//
//                             bool isLiked = (product.isFavorite ?? false) || logic.likes[index];
//                             return GestureDetector(
//                               onTap: () {
//                                 if (getStorage.read("isDemoLogin") ?? false) {
//                                   displayToast(message: St.thisIsDemoUser.tr);
//                                   return;
//                                 }
//                                 galleryCategoryController.likes[index] = !logic.likes[index];
//                                 product.isFavorite = logic.likes[index];
//
//                                 logic.update();
//
//                                 addToFavoriteController.postFavoriteData(
//                                   productId: "${product.id}",
//                                   categoryId: "${product.category!.id}",
//                                 );
//                               },
//                               child: Container(
//                                 height: 32,
//                                 width: 32,
//                                 decoration: BoxDecoration(
//                                   color: AppColors.white,
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Image(
//                                     image: isLiked ? AssetImage(AppAsset.icHeartFill) : AssetImage(AppAsset.icHeart),
//                                     color: isLiked ? AppColors.red : null,
//                                   ),
//                                 ),
//                               ),
//                             );
//                           }),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     product.productName ?? '',
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontFamily: AppConstant.appFontRegular,
//                       color: AppColors.white,
//                       fontSize: 12,
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           "$currencySymbol ${product.price}",
//                           style: AppFontStyle.styleW900(AppColors.primary, 14),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       const Icon(
//                         Icons.star_rounded,
//                         color: Color(0xffFACC15),
//                         size: 14,
//                       ),
//                       2.width,
//                       Text(
//                         product.rating!.isEmpty ? St.noReviews.tr : "${product.rating?[0].avgRating}.0",
//                         style: AppFontStyle.styleW500(AppColors.unselected, 9),
//                       ),
//                     ],
//                   ),
//
//                   // Description
//                   Text(
//                     "${product.description}",
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: AppFontStyle.styleW500(AppColors.unselected, 10),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _categoriesShimmer() {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: [
//           for (int i = 0; i <= 3; i++)
//             Container(
//               height: 40,
//               width: 120,
//               margin: const EdgeInsets.only(right: 10),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: AppColors.darkGrey.withValues(alpha: 0.35),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

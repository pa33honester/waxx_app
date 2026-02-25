//ignore: must_be_immutable

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:era_shop/Controller/GetxController/user/gallery_catagory_controller.dart';
import 'package:era_shop/Controller/GetxController/user/get_all_category_controller.dart';
import 'package:era_shop/Controller/GetxController/user/new_collection_controller.dart';
import 'package:era_shop/user_pages/home_page/controller/home_controller.dart';
import 'package:era_shop/utils/CoustomWidget/App_theme_services/no_data_found.dart';
import 'package:era_shop/utils/CoustomWidget/App_theme_services/text_titles.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/all_images.dart';
import 'package:era_shop/utils/app_asset.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:era_shop/utils/shimmers.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class HomeCategoryTabBarWidget extends StatefulWidget {
  const HomeCategoryTabBarWidget({super.key});

  @override
  State<HomeCategoryTabBarWidget> createState() => _HomeCategoryTabBarWidgetState();
}

class _HomeCategoryTabBarWidgetState extends State<HomeCategoryTabBarWidget> with SingleTickerProviderStateMixin {
  GalleryCategoryController galleryCategoryController = Get.put(GalleryCategoryController());
  GetAllCategoryController getAllCategoryController = Get.put(GetAllCategoryController());
  NewCollectionController addToFavoriteController = Get.put(NewCollectionController());

  ScrollController scrollController = ScrollController();
  bool isApiCalling = true;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      _scrollListener();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getAllCategoryController.selectedTabIndex = 0;
      log("callll 1 ${getAllCategoryController.selectedTabIndex}");

      await getAllCategoryController.getCategory().then((value) => _initHomeTabController()).then((value) {
        log("getAllCategoryController.getAllCategory!.category!.length ${getAllCategoryController.getAllCategory!.category!.length}");
        _handleTabChange();
      });

      galleryCategoryController.homeTabController!.addListener(() async {
        galleryCategoryController.galleryProducts.clear();
        _handleTabChange();
      });
      setState(() {});
    });
  }

  void _initHomeTabController() {
    if (getAllCategoryController.getAllCategory?.category?.isNotEmpty ?? false) {
      final tabController = TabController(length: getAllCategoryController.getAllCategory!.category!.length, vsync: this);
      galleryCategoryController.homeTabController = tabController;
    }
  }

  Future _handleTabChange() async {
    final tabController = galleryCategoryController.homeTabController;
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
    final tabController = galleryCategoryController.homeTabController;
    if (tabController == null) return;

    if (scrollController.offset >= scrollController.position.maxScrollExtent && !scrollController.position.outOfRange) {
      setState(() {
        int selectedIndex = tabController.index;
        String selectedCategory = getAllCategoryController.getAllCategory!.category![selectedIndex].id.toString();
        galleryCategoryController.loadMoreData(selectCategory: selectedCategory);
      });
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeController = Get.put(HomeController());

    return Container(
      width: Get.width,
      color: AppColors.black,
      padding: const EdgeInsets.only(left: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                AppAsset.icCategory,
                width: 20,
                color: Colors.white,
              ),
              10.width,
              GeneralTitle(title: St.newCategories.tr),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Get.toNamed('/HomeCategoryViewAll');
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text(
                    St.viewAll.tr,
                    style: AppFontStyle.styleW700(AppColors.primary, 15),
                  ),
                ),
              )
            ],
          ),
          6.height,
          GetBuilder<GetAllCategoryController>(
            id: "onChangeTab",
            builder: (controller) {
              final cats = getAllCategoryController.getAllCategory?.category ?? [];
              final homeTabController = galleryCategoryController.homeTabController;

              if (cats.isEmpty || homeTabController == null) {
                return const SizedBox(height: 48);
              }

              Utils.showLog("HOME TAB CONTROLLER ${homeTabController.length}");
              Utils.showLog("HOME CATEGORIES ${getAllCategoryController.getAllCategory?.category ?? "NONE"}");

              return TabBar(
                controller: homeTabController,
                physics: const BouncingScrollPhysics(),
                onTap: (value) {
                  galleryCategoryController.galleryProducts.clear();
                  galleryCategoryController.isLoading(true);
                  getAllCategoryController.onChangeTab(value);
                },
                indicator: BoxDecoration(
                  color: AppColors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                isScrollable: true,
                unselectedLabelColor: isDark.value ? AppColors.white : AppColors.black,
                unselectedLabelStyle: GoogleFonts.plusJakartaSans(color: AppColors.white),
                dividerColor: AppColors.transparent,
                padding: EdgeInsets.zero,
                labelPadding: const EdgeInsets.only(right: 10),
                indicatorPadding: EdgeInsets.zero,
                tabAlignment: TabAlignment.start,
                tabs: getAllCategoryController.getAllCategory?.category?.map<Tab>((category) {
                      bool isSelected = getAllCategoryController.getAllCategory?.category?[getAllCategoryController.selectedTabIndex].name == category.name;
                      return Tab(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
              ).paddingSymmetric(vertical: 5);
            },
          ),
        ],
      ),
    );
  }

  static Shimmer categoriesShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.darkGrey.withValues(alpha: 0.35),
      highlightColor: AppColors.lightGrey.withValues(alpha: 0.35),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (int i = 0; i <= 3; i++)
              Container(
                height: 40,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red.withValues(alpha: 0.7),
                ),
              ).paddingOnly(left: 6),
          ],
        ),
      ),
    );
  }
}

class HomeCategoriesWidget extends StatelessWidget {
  HomeCategoriesWidget({super.key});

  GetAllCategoryController getAllCategoryController = Get.put(GetAllCategoryController());
  NewCollectionController addToFavoriteController = Get.put(NewCollectionController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GalleryCategoryController>(
      builder: (logic) {
        return Obx(
          () => logic.isLoading.value
              ? Shimmers.productGridviewShimmer().paddingSymmetric(vertical: 15, horizontal: 15)
              : Stack(
                  children: [
                    if (logic.galleryProducts.isEmpty)
                      noDataFound(image: "assets/no_data_found/closebox.png", text: St.thisCategoryIsEmpty.tr).paddingAll(20)
                    else
                      GridView.builder(
                        itemCount: logic.galleryProducts.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          mainAxisExtent: 230,
                        ),
                        itemBuilder: (context, index) {
                          final data = logic.galleryProducts[index];
                          return GestureDetector(
                            onTap: () {
                              productId = data.id ?? '';
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
                                              imageUrl: data.mainImage ?? "",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  logic.likes[index] = !logic.likes[index];
                                                  logic.update();

                                                  addToFavoriteController.postFavoriteData(productId: "${data.id}", categoryId: "${data.category!.id}");
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
                                                      image:
                                                          // galleryCategoryController.galleryCategory!.product![index].isFavorite
                                                          data.isFavorite == true & logic.likes[index] ? AssetImage(AppImage.productLike) : AssetImage(AppImage.productDislike),
                                                      color: data.isFavorite == true & logic.likes[index] ? AppColors.red : null,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
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
                                          data.productName ?? '',
                                          overflow: TextOverflow.ellipsis,
                                          style: AppFontStyle.styleW700(AppColors.white, 11),
                                        ),
                                        2.height,
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "$currencySymbol ${data.price ?? ""}",
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
                                            //     AppColors.unselected,
                                            //     10,
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                        2.height,
                                        Text(
                                          data.description ?? '',
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
                        },
                      ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Obx(
                          () => logic.moreLoading.value
                              ? Container(
                                  height: 55,
                                  width: 55,
                                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black.withValues(alpha: 0.40)),
                                  child: const Center(
                                    child: SizedBox(
                                      height: 25,
                                      width: 25,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

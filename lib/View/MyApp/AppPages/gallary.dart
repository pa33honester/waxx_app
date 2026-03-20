import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:waxxapp/Controller/GetxController/user/gallery_catagory_controller.dart';
import 'package:waxxapp/Controller/GetxController/user/get_all_category_controller.dart';
import 'package:waxxapp/Controller/GetxController/user/new_collection_controller.dart';
import 'package:waxxapp/user_pages/home_page/controller/home_controller.dart';
import 'package:waxxapp/user_pages/home_page/view/home_view.dart';
import 'package:waxxapp/utils/CoustomWidget/App_theme_services/no_data_found.dart';
import 'package:waxxapp/utils/CoustomWidget/App_theme_services/text_titles.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/Zego/ZegoUtils/device_orientation.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/app_constant.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/shimmers.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';

class Gallery extends StatefulWidget {
  const Gallery({super.key});

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> with SingleTickerProviderStateMixin {
  GalleryCategoryController galleryCategoryController = Get.put(GalleryCategoryController());
  GetAllCategoryController getAllCategoryController = Get.put(GetAllCategoryController());
  NewCollectionController addToFavoriteController = Get.put(NewCollectionController());

  //------------------------------------------------------------------------

  final List<bool> _likes = List.generate(100000, (_) => true);
  ScrollController scrollController = ScrollController();
  TabController? tabController;

  bool isApiCalling = true;

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      _scrollListener();
    });
    final tabChangeDebouncer = Debouncer(delay: const Duration(milliseconds: 500));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getAllCategoryController.getCategory().then((value) => tabBarLength()).then((value) => _handleTabChange());

      tabController!.addListener(() async {
        galleryCategoryController.galleryProducts.clear();
        //  if (isApiCalling) {
        //   galleryCategoryController.galleryProducts.clear();
        // }
        tabChangeDebouncer.call(() {
          _handleTabChange();
        });
      });
    });
  }

  void tabBarLength() {
    tabController = TabController(length: getAllCategoryController.getAllCategory!.category!.length, vsync: this);
  }

  // Future _handleTabChange() async {
  //   log("callll 3");
  //   int selectedIndex = tabController!.index;
  //   String selectedCategory = getAllCategoryController.getAllCategory!.category![selectedIndex].id.toString();
  //   isApiCalling = false;
  //   await galleryCategoryController.getCategoryData(selectCategory: selectedCategory);
  //   isApiCalling = true;
  // }
  Future _handleTabChange() async {
    int selectedIndex = tabController!.index;
    String selectedCategory = getAllCategoryController.getAllCategory!.category![selectedIndex].id.toString();
    // Store the latest selected tab index
    // int latestSelectedIndex = selectedIndex;
    if (selectedIndex == tabController!.index) {
      galleryCategoryController.isLoading(true);
      await galleryCategoryController.getCategoryData(selectCategory: selectedCategory);
    }
  }

  void _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange &&
        tabController!.indexIsChanging) {
      setState(() {
        int selectedIndex = tabController!.index;
        String selectedCategory = getAllCategoryController.getAllCategory!.category![selectedIndex].id.toString();
        galleryCategoryController.loadMoreData(selectCategory: selectedCategory);
      });
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeController = Get.put(HomeController());
    return Scaffold(
        backgroundColor: AppColors.transparent,
        body: SizedBox(
          height: Get.height,
          width: Get.width,
          child: Obx(
            () => getAllCategoryController.isLoading.value
                ? Shimmers.productGridviewShimmer().paddingSymmetric(vertical: 15, horizontal: 15)
                : NestedScrollView(
                    controller: homeController.scrollController,
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        Obx(
                          () => SliverAppBar(
                            expandedHeight: 120,
                            pinned: true,
                            floating: true,
                            foregroundColor: AppColors.transparent,
                            shadowColor: AppColors.transparent,
                            surfaceTintColor: AppColors.transparent,
                            backgroundColor: AppColors.transparent,
                            systemOverlayStyle:
                                SystemUiOverlayStyle(statusBarColor: homeController.isTabBarPinned.value ? AppColors.black : AppColors.transparent),
                            flexibleSpace: const FlexibleSpaceBar(
                              background: Align(alignment: Alignment.topCenter, child: HomeAppbarWidget()),
                            ),
                            bottom: PreferredSize(
                              preferredSize: const Size.fromHeight(110),
                              child: Container(
                                height: 40,
                                color: Color(0xff04050A),
                                // color: Colors.green,
                                padding: const EdgeInsets.only(left: 15, right: 15),
                                width: Get.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    15.height,
                                    GeneralTitle(title: "Wishlist Collection"),

                                    /// TODO
                                    /// Era 2.0
                                    /* 10.height,
                                    GetBuilder<GetAllCategoryController>(
                                      id: "onChangeTab",
                                      builder: (controller) => TabBar(
                                        indicatorColor: Colors.pink,
                                        controller: tabController,

                                        physics: const BouncingScrollPhysics(),
                                        onTap: (value) {
                                          log("message::::value:::$value");
                                          galleryCategoryController.galleryProducts.clear();
                                          galleryCategoryController.isLoading(true);
                                          getAllCategoryController.onChangeTab(value);
                                        },
                                        // padding: const EdgeInsets.only(left: 15, top: 10, right: 15),
                                        indicator: BoxDecoration(
                                          color: AppColors.transparent,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        // onTap: (value) {},
                                        isScrollable:
                                            getAllCategoryController.getAllCategory!.category!.length > 4 ? true : false,

                                        unselectedLabelColor: isDark.value ? AppColors.white : AppColors.black,
                                        unselectedLabelStyle: GoogleFonts.plusJakartaSans(color: AppColors.white),
                                        dividerColor: AppColors.transparent,
                                        padding: EdgeInsets.zero,
                                        labelPadding: const EdgeInsets.only(right: 10),
                                        indicatorPadding: EdgeInsets.zero,
                                        tabAlignment: TabAlignment.start,
                                        tabs: getAllCategoryController.getAllCategory!.category!.map<Tab>((category) {
                                          bool isSelected = getAllCategoryController
                                                  .getAllCategory!.category?[getAllCategoryController.selectedTabIndex].name ==
                                              category.name;
                                          return Tab(
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                              decoration: BoxDecoration(
                                                color: isSelected ? AppColors.primary : AppColors.tabBackground,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                category.name.toString().capitalizeFirst ?? "",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                  color: isSelected ? AppColors.black : AppColors.unselected,
                                                  fontFamily: AppConstant.appFontRegular,
                                                ),
                                              ),
                                            ),

                                            // text: category.name.toString().capitalizeFirst,
                                          );
                                        }).toList(),
                                      ).paddingSymmetric(vertical: 5),
                                    ),*/
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // SliverAppBar(
                        //   expandedHeight: 250,
                        //   pinned: true,
                        //   floating: true,
                        //   flexibleSpace: FlexibleSpaceBar(
                        //     background: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         const SizedBox(
                        //           height: 15,
                        //         ),
                        //         Padding(
                        //           padding: const EdgeInsets.symmetric(horizontal: 20),
                        //           child: GestureDetector(
                        //             onTap: () {
                        //               Get.toNamed("/SearchPage");
                        //             },
                        //             child: dummySearchField(),
                        //           ),
                        //         ),
                        //         Padding(
                        //           padding: EdgeInsets.only(top: Get.height / 40),
                        //           child: const HomePageLiveSelling(),
                        //         ),
                        //         // galleryFlashSale(),
                        //       ],
                        //     ),
                        //   ),
                        //   bottom: PreferredSize(
                        //     preferredSize: const Size.fromHeight(55),
                        //     child: Container(
                        //       height: 52,
                        //       color: isDark.value ? AppColors.blackBackground : AppColors.white,
                        //       width: Get.width,
                        //       child: TabBar(
                        //         controller: tabController,
                        //         physics: const BouncingScrollPhysics(),
                        //         onTap: (value) {
                        //           log("message::::value:::$value");
                        //           galleryCategoryController.galleryProducts.clear();
                        //           galleryCategoryController.isLoading(true);
                        //         },
                        //         padding: const EdgeInsets.only(left: 15, top: 10, right: 15),
                        //         indicator: BoxDecoration(
                        //           color: AppColors.primaryPink,
                        //           borderRadius: BorderRadius.circular(6),
                        //         ),
                        //         // onTap: (value) {},
                        //         isScrollable: getAllCategoryController.getAllCategory!.category!.length > 4 ? true : false,
                        //         unselectedLabelColor: isDark.value ? AppColors.white : AppColors.black,
                        //         unselectedLabelStyle: GoogleFonts.plusJakartaSans(
                        //           color: AppColors.white,
                        //         ),
                        //         tabs: getAllCategoryController.getAllCategory!.category!.map<Tab>((category) {
                        //           return Tab(
                        //             text: category.name.toString().capitalizeFirst,
                        //           );
                        //         }).toList(),
                        //       ).paddingSymmetric(vertical: 5),
                        //     ),
                        //   ),
                        // )
                      ];
                    },
                    body: GetBuilder<GalleryCategoryController>(
                      builder: (GalleryCategoryController galleryCategoryController) => Obx(() => galleryCategoryController.isLoading.value
                              ? Shimmers.productGridviewShimmer().paddingSymmetric(vertical: 15, horizontal: 15)
                              : Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                  child: Stack(
                                    children: [
                                      galleryCategoryController.galleryProducts.isEmpty
                                          ? noDataFound(image: "assets/no_data_found/closebox.png", text: St.thisCategoryIsEmpty.tr)
                                          : GridView.builder(
                                              physics: const BouncingScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: galleryCategoryController.galleryProducts.length,
                                              padding: const EdgeInsets.only(bottom: 100),
                                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisSpacing: 10,
                                                mainAxisSpacing: 10,
                                                crossAxisCount: 2,
                                                mainAxisExtent: 250,
                                              ),
                                              itemBuilder: (context, index) {
                                                final product = galleryCategoryController.galleryProducts[index];
                                                return GestureDetector(
                                                  onTap: () {
                                                    productId = product.id!;
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
                                                                  child:
                                                                      CachedNetworkImage(imageUrl: product.mainImage.toString(), fit: BoxFit.cover),
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
                                                                product.productName ?? '',
                                                                overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(
                                                                    fontWeight: FontWeight.bold,
                                                                    fontFamily: AppConstant.appFontRegular,
                                                                    color: AppColors.white,
                                                                    fontSize: 11),
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
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 15),
                                        child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Obx(
                                            () => galleryCategoryController.moreLoading.value
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
                                )

                          /*TabBarView(
                                physics: const NeverScrollableScrollPhysics(),
                                controller: tabController,
                                children: getAllCategoryController.getAllCategory!.category!.map((category) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                    child: Stack(
                                      children: [
                                        galleryCategoryController.galleryProducts.isEmpty
                                            ? noDataFound(
                                                image: "assets/no_data_found/closebox.png", text: St.thisCategoryIsEmpty.tr)
                                            : GridView.builder(
                                                physics: const BouncingScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: galleryCategoryController.galleryProducts.length,
                                                padding: const EdgeInsets.only(bottom: 100),
                                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisSpacing: 10,
                                                  mainAxisSpacing: 10,
                                                  crossAxisCount: 2,
                                                  mainAxisExtent: 250,
                                                ),
                                                itemBuilder: (context, index) {
                                                  final product = galleryCategoryController.galleryProducts[index];
                                                  return GestureDetector(
                                                    onTap: () {
                                                      productId = product.id!;
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
                                                                        fit: BoxFit.cover),
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
                                                                  product.productName ?? '',
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.bold,
                                                                      fontFamily: AppConstant.appFontRegular,
                                                                      color: AppColors.white,
                                                                      fontSize: 11),
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
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 15),
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Obx(
                                              () => galleryCategoryController.moreLoading.value
                                                  ? Container(
                                                      height: 55,
                                                      width: 55,
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape.circle, color: Colors.black.withValues(alpha:0.40)),
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
                                }).toList(),
                              ),*/
                          ),
                    ),
                  ),
          ),
        ));
  }
}

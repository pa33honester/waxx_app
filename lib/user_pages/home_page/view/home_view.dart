import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:waxxapp/Controller/GetxController/user/gallery_catagory_controller.dart';
import 'package:waxxapp/Controller/GetxController/user/get_live_seller_list_controller.dart';
import 'package:waxxapp/Controller/GetxController/user/just_for_you_prroduct_controller.dart';
import 'package:waxxapp/Controller/GetxController/user/new_collection_controller.dart';
import 'package:waxxapp/View/MyApp/AppPages/product_detail.dart';
import 'package:waxxapp/custom/circle_button_widget.dart';
import 'package:waxxapp/custom/exit_app_dialog.dart';
import 'package:waxxapp/user_pages/bottom_bar_page/controller/bottom_bar_controller.dart';
import 'package:waxxapp/user_pages/home_page/widget/home_category_widget.dart';
import 'package:waxxapp/user_pages/home_page/widget/home_live_grid.dart';
import 'package:waxxapp/user_pages/popular_products_page/controller/popular_products_controller.dart';
import 'package:waxxapp/user_pages/popular_products_page/view/popular_products_view.dart';
import 'package:waxxapp/user_pages/search_page/view/search_view.dart';
import 'package:waxxapp/utils/CoustomWidget/App_theme_services/no_data_found.dart';
import 'package:waxxapp/utils/CoustomWidget/App_theme_services/text_titles.dart';
import 'package:waxxapp/utils/CoustomWidget/Page_devided/home_page_divided.dart';
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
import 'package:waxxapp/user_pages/upcoming_lives/view/upcoming_lives_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final GetLiveSellerListController getLiveSellerListController;
  late final JustForYouProductController justForYouProductController;
  late final NewCollectionController newCollectionController;
  late final PopularProductsController popularProductsController;
  late final GalleryCategoryController galleryCategoryController;

  T _putOnce<T>(T Function() create) {
    if (Get.isRegistered<T>()) return Get.find<T>();
    return Get.put<T>(create());
  }

  @override
  void initState() {
    super.initState();
    getLiveSellerListController = _putOnce<GetLiveSellerListController>(() => GetLiveSellerListController());
    justForYouProductController = _putOnce<JustForYouProductController>(() => JustForYouProductController());
    newCollectionController = _putOnce<NewCollectionController>(() => NewCollectionController());
    popularProductsController = _putOnce<PopularProductsController>(() => PopularProductsController());
    galleryCategoryController = _putOnce<GalleryCategoryController>(() => GalleryCategoryController());
  }

  @override
  Widget build(BuildContext context) {
    Utils.onChangeSystemColor();
    final NewCollectionController addToFavoriteController = newCollectionController;
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => ExitAppDialog(),
        );
        if (didPop) {
          return;
        }
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            backgroundColor: AppColors.transparent,
            automaticallyImplyLeading: false,
            elevation: 1,
            shadowColor: AppColors.grayLight.withValues(alpha: 0.5),
            surfaceTintColor: AppColors.transparent,
            flexibleSpace: Center(
              child: HomeAppbarWidget(),
            ),
          ),
        ),
        body: RefreshIndicator(
          notificationPredicate: (notification) {
            return notification.depth == 1;
          },
          backgroundColor: AppColors.black,
          color: AppColors.primary,
          onRefresh: () {
            return Future.wait([getLiveSellerListController.getSellerList(), newCollectionController.getNewCollectionData(), justForYouProductController.getJustForYouProduct(), popularProductsController.onGetPopularProduct()]);
          },
          child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      15.height,
                      const HomeLiveGrid(),
                      20.height,
                      const HomePageShorts(),
                      20.height,
                      const UpcomingLivesSection(),
                      10.height,
                    ],
                  ),
                ),
                PreferredSize(
                  preferredSize: const Size.fromHeight(70),
                  child: SliverAppBar(
                    pinned: true,
                    floating: true,
                    automaticallyImplyLeading: false,
                    backgroundColor: AppColors.black,
                    surfaceTintColor: AppColors.transparent,
                    toolbarHeight: 0,
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(100),
                      child: HomeCategoryTabBarWidget(),
                    ),
                  ),
                ),
              ];
            },
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GetBuilder<GalleryCategoryController>(
                    builder: (GalleryCategoryController galleryCategoryController) => Obx(
                      () => galleryCategoryController.isLoading.value
                          ? Shimmers.productGridviewShimmer().paddingSymmetric(vertical: 12, horizontal: 12)
                          : Padding(
                              padding: const EdgeInsets.only(left: 16, top: 10),
                              child: Stack(
                                children: [
                                  galleryCategoryController.galleryProducts.isEmpty
                                      ? noDataFound(image: "assets/no_data_found/basket.png", text: "No products in this category")
                                      : SizedBox(
                                          height: 230,
                                          child: ListView.builder(
                                            physics: ClampingScrollPhysics(),
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: galleryCategoryController.galleryProducts.take(10).length,
                                            // padding: EdgeInsets.symmetric(horizontal: 10),
                                            itemBuilder: (context, index) {
                                              final product = galleryCategoryController.galleryProducts[index];
                                              final liked = (index < galleryCategoryController.likes.length ? galleryCategoryController.likes[index] : (product.isFavorite == true));
                                              return GestureDetector(
                                                onTap: () {
                                                  productId = product.id ?? '';
                                                  Get.to(() => ProductDetail());
                                                },
                                                child: Container(
                                                  width: 170,
                                                  margin: EdgeInsets.only(right: 12),
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
                                                              ),
                                                              Align(
                                                                alignment: Alignment.topRight,
                                                                child: Padding(
                                                                  padding: const EdgeInsets.all(8.0),
                                                                  child: Row(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                    children: [
                                                                      GestureDetector(
                                                                        onTap: () async {
                                                                          if (getStorage.read("isDemoLogin") ?? false || isDemoSeller) {
                                                                            displayToast(message: St.thisIsDemoUser.tr);
                                                                            return;
                                                                          } else {
                                                                            final old = galleryCategoryController.likes[index];
                                                                            galleryCategoryController.likes[index] = !old;
                                                                            galleryCategoryController.update();
                                                                            try {
                                                                              await addToFavoriteController.postFavoriteData(
                                                                                productId: "${product.id}",
                                                                                categoryId: "${product.category!.id}",
                                                                              );
                                                                            } catch (e) {
                                                                              // API fail -> rollback
                                                                              galleryCategoryController.likes[index] = old;
                                                                              galleryCategoryController.update();
                                                                              displayToast(message: St.somethingWentWrong.tr);
                                                                            }
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
                                                              product.productName ?? '',
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(fontWeight: FontWeight.bold, fontFamily: AppConstant.appFontRegular, color: AppColors.white, fontSize: 11),
                                                            ),
                                                            2.height,
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child: Text(
                                                                    "$currencySymbol ${product.price}",
                                                                    overflow: TextOverflow.ellipsis,
                                                                    style: AppFontStyle.styleW900(AppColors.primary, 15),
                                                                  ),
                                                                ),
                                                                const Icon(
                                                                  Icons.star_rounded,
                                                                  color: Color(0xffFACC15),
                                                                  size: 16,
                                                                ),
                                                                2.width,
                                                                Text(
                                                                  product.rating!.isEmpty ? St.noReviews.tr : "${product.rating?[0].avgRating}.0",
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: AppFontStyle.styleW500(AppColors.unselected, 9),
                                                                ),
                                                              ],
                                                            ),
                                                            5.height,
                                                            Text(
                                                              "${product.description}",
                                                              overflow: TextOverflow.ellipsis,
                                                              style: AppFontStyle.styleW600(AppColors.unselected, 12),
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
                            ),
                    ),
                  ),
                  26.height,
                  PopularProductsView(),
                  22.height,
                  const HomepageJustForYou(
                    isShowTitle: true,
                  ),
                  90.height,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeAppbarWidget extends StatelessWidget {
  const HomeAppbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 60,
        width: Get.width,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                final bottomBarController = Get.find<BottomBarController>();
                bottomBarController.onChangeBottomBar(4);
              },
              child: Row(
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white),
                    ),
                    child: Container(
                      height: 48,
                      width: 48,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: imageXFile == null
                          ? CachedNetworkImage(
                              imageUrl: editImage,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Image.asset(AppAsset.profilePlaceholder),
                              errorWidget: (context, url, error) => Image.asset(AppAsset.profilePlaceholder),
                            )
                          : Image.file(
                              File(imageXFile?.path ?? ""),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  10.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GeneralTitle(title: "${St.hi.tr},$editFirstName"),
                      Text(
                        St.exploreTheLatestLiveDeals.tr,
                        style: GoogleFonts.plusJakartaSans(color: AppColors.white, fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            10.width,
            CircleButtonWidget(
              callback: () => Get.to(SearchView()),
              size: 42,
              color: AppColors.white.withValues(alpha: 0.2),
              child: Image.asset(AppAsset.icSearch, width: 22),
            ),
            10.width,
            CircleButtonWidget(
              callback: () => Get.toNamed("/Notifications"),
              size: 42,
              color: AppColors.white.withValues(alpha: 0.2),
              child: Image.asset(AppAsset.icNotification, width: 22),
            ),
          ],
        ),
      ),
    );
  }
}

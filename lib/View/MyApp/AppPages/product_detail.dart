import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:era_shop/ApiModel/user/UserProductDetailsModel.dart';
import 'package:era_shop/Controller/GetxController/user/add_product_to_cart_controller.dart';
import 'package:era_shop/Controller/GetxController/user/follow_unfollow_controller.dart';
import 'package:era_shop/Controller/GetxController/user/gallery_catagory_controller.dart';
import 'package:era_shop/Controller/GetxController/user/get_all_cart_products_controller.dart';
import 'package:era_shop/Controller/GetxController/user/user_product_details_controller.dart';
import 'package:era_shop/custom/circle_button_widget.dart';
import 'package:era_shop/custom/custom_color_bg_widget.dart';
import 'package:era_shop/custom/custom_share.dart';
import 'package:era_shop/custom/loading_ui.dart';
import 'package:era_shop/custom/main_button_widget.dart';
import 'package:era_shop/custom/preview_image_widget.dart';
import 'package:era_shop/custom/preview_profile_image_widget.dart';
import 'package:era_shop/user_pages/bottom_bar_page/controller/bottom_bar_controller.dart';
import 'package:era_shop/user_pages/preview_seller_profile_page/view/preview_seller_profile_view.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/Theme/theme_service.dart';
import 'package:era_shop/utils/all_images.dart';
import 'package:era_shop/utils/app_asset.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/app_constant.dart';
import 'package:era_shop/utils/branch_io_services.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:era_shop/utils/show_toast.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/controllers/flip_card_controllers.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:vibration/vibration.dart';

import '../../../Controller/GetxController/seller/selected_product_for_live_controller.dart';
import '../../../Controller/GetxController/user/new_collection_controller.dart';
import '../../../Controller/GetxController/user/remove_all_product_from_cart_controller.dart';
import '../../../utils/shimmers.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  UserProductDetailsController userProductDetailsController = Get.put(UserProductDetailsController());
  FollowUnFollowController followUnFollowController = Get.put(FollowUnFollowController());
  AddProductToCartController addProductToCartController = Get.put(AddProductToCartController());
  NewCollectionController addToFavoriteController = Get.put(NewCollectionController());
  SelectedProductForLiveController selectedProductForLiveController = Get.put(SelectedProductForLiveController());
  RemoveAllProductFromCartController removeAllProductFromCartController = Get.put(RemoveAllProductFromCartController());
  GetAllCartProductController getAllCartProductController = Get.put(GetAllCartProductController());

  bool isFollow = false;
  bool isSwiped = false;
  bool isLiked = false;
  bool isOneTimePress = false;
  final productController = PageController();
  int click = 0;
  int click1 = 0;
  bool _isFlipped = false;

  final categoryDropdownController = DropdownController();

  Map<String, DropdownController> dropdownControllers = {};

  Map<String, dynamic> selectedValues = {};

  addToCart() async {
    addProductToCartController.isLoading.value = true;

    // List<Map<String, String>> attributesArray = selectedValues.entries.map((entry) {
    //   return {
    //     "name": entry.key,
    //     "value": entry.value,
    //   };
    // }).toList();

    final originalAttributes = userProductDetailsController.selectedCategoryValues;
    List<Map<String, dynamic>> attributesArray = selectedValues.entries.map((entry) {
      final originalAttribute = originalAttributes?.firstWhere(
        (attr) => attr.name == entry.key,
        orElse: () => Attribute(), // Fallback if not found
      );

      return {
        "name": entry.key,
        "values": [entry.value],
        "image": originalAttribute?.image,
      };
    }).toList();

    await addProductToCartController.addProductToCartData(
      productQuantity: 1,
      attributes: attributesArray,
    );
    return;
  }

  @override
  void initState() {
    userProductDetailsController.userProductDetailsData();
    // userProductDetailsController.getRelatedProducts(userProductDetailsController.userProductDetails?.product?[0].category?.id ?? '');
    super.initState();
  }

  bool areAllAttributesFilled = false;

  // double slidePosition = 0.0;
  // double maxSlide = 400.0;

  // void resetButtonPosition() {
  //   setState(() {
  //     slidePosition = 0.0; // Reset the button's position to its initial state
  //   });
  // }

  Future<void> onSubmit() async {
    if (!areAllAttributesFilled) {
      displayToast(message: St.pleaseFillAllAttributes.tr, isBottomToast: true);
      // resetButtonPosition();
    } else {
      await addToCart();

      if (await Vibration.hasVibrator()) {
        Vibration.vibrate();
      }
    }
  }

  Future<void> onBuyNow() async {
    if (!areAllAttributesFilled) {
      displayToast(message: St.pleaseFillAllAttributes.tr, isBottomToast: true);
      // resetButtonPosition();
    } else {
      await addToCart();

      Get.back();
      final controller = Get.put(BottomBarController());
      controller.onChangeBottomBar(2);

      if (await Vibration.hasVibrator()) {
        Vibration.vibrate();
      }
    }
  }

  Future<void> onClickShare() async {
    Get.dialog(LoadingUi(), barrierDismissible: false); // Start Loading...

    await BranchIoServices.onCreateProductBranchIoLink(
      id: userProductDetailsController.userProductDetails?.product?[0].id ?? "",
      images: userProductDetailsController.userProductDetails?.product?[0].images,
      productName: userProductDetailsController.userProductDetails?.product?[0].productName ?? "",
      description: userProductDetailsController.userProductDetails?.product?[0].description ?? "",
      pageRoutes: "Product",
    );

    final link = await BranchIoServices.onGenerateLink();

    Get.back(); // Stop Loading...

    if (link != null) {
      CustomShare.onShareLink(link: link);
    }
  }

  String? _getAddress() {
    final addr = userProductDetailsController.userProductDetails?.product?[0].seller?.address;

    if (addr?.state?.isNotEmpty == true && addr?.country?.isNotEmpty == true) {
      return "${addr?.state}, ${addr?.country}";
    }
    return addr?.state ?? addr?.country;
  }

  final cong = GestureFlipCardController();

  @override
  Widget build(BuildContext context) {
    return CustomColorBgWidget(
      child: Stack(
        children: [
          Scaffold(
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
                                  St.productDetails.tr,
                                  style: AppFontStyle.styleW900(AppColors.white, 18),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                onClickShare();
                              },
                              child: Container(
                                height: 38,
                                width: 38,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColors.white.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  AppAsset.icShare,
                                  width: 20,
                                  color: AppColors.unselected,
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
              body: SafeArea(
                child: SizedBox(
                  height: Get.height,
                  width: Get.width,
                  child: Obx(
                    () => userProductDetailsController.isLoading.value
                        ? Shimmers.productDetailsShimmer()
                        : SingleChildScrollView(
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
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
                                                    controller: productController,
                                                    itemCount: userProductDetailsController.userProductDetails?.product?[0].images?.length ?? 0,
                                                    onPageChanged: (value) {
                                                      click1 = value;
                                                      setState(() {});
                                                    },
                                                    itemBuilder: (context, index) {
                                                      final indexData = userProductDetailsController.userProductDetails?.product?[0].images?[index];
                                                      return PreviewImageWidget(height: 420, width: Get.width, image: indexData, defaultHeight: 100, fit: BoxFit.cover);
                                                    },
                                                  ),
                                                  Positioned(
                                                    bottom: 15,
                                                    child: SmoothPageIndicator(
                                                      effect: ExpandingDotsEffect(dotHeight: 8, dotWidth: 8, dotColor: Colors.grey.shade400, activeDotColor: AppColors.primary),
                                                      controller: productController,
                                                      count: userProductDetailsController.userProductDetails?.product?[0].images?.length.toInt() ?? 0,
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
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Expanded(
                                                                  child: Text(
                                                                    userProductDetailsController.userProductDetails?.product![0].productName ?? "",
                                                                    overflow: TextOverflow.ellipsis,
                                                                    style: AppFontStyle.styleW700(AppColors.white, 20),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                              children: [
                                                                Expanded(
                                                                  child: Text(
                                                                    (userProductDetailsController.userProductDetails?.product![0].description ?? "").trim(),
                                                                    maxLines: userProductDetailsController.isDescriptionExpanded.value ? null : 2,
                                                                    overflow: userProductDetailsController.isDescriptionExpanded.value ? TextOverflow.clip : TextOverflow.ellipsis,
                                                                    style: AppFontStyle.styleW500(AppColors.unselected, 14),
                                                                  ),
                                                                ),
                                                                GestureDetector(
                                                                  onTap: () => userProductDetailsController.toggleDescription(),
                                                                  child: Text(
                                                                    userProductDetailsController.isDescriptionExpanded.value ? St.less.tr : St.more.tr,
                                                                    style: TextStyle(
                                                                      color: AppColors.primary,
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.w500,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  8.height,
                                                  Row(
                                                    children: [
                                                      userProductDetailsController.userProductDetails?.product?[0].seller?.address?.city != null || userProductDetailsController.userProductDetails?.product?[0].seller?.address?.country != null
                                                          ? Row(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                Image(
                                                                  color: AppColors.unselected,
                                                                  image: AssetImage(AppImage.location),
                                                                  height: 15,
                                                                ),
                                                                5.width,
                                                                SizedBox(
                                                                  // width: Get.width / 2,
                                                                  child: Text(
                                                                    _getAddress() ?? '',
                                                                    maxLines: 1,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    style: AppFontStyle.styleW500(AppColors.unselected, 12),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          : const SizedBox.shrink(),
                                                      10.width,
                                                      Image(
                                                        color: AppColors.unselected,
                                                        image: AssetImage(AppImage.cart),
                                                        height: 15,
                                                      ),
                                                      5.width,
                                                      Text(
                                                        "${userProductDetailsController.userProductDetails?.product?[0].sold} ${St.sold.tr}",
                                                        style: AppFontStyle.styleW500(AppColors.unselected, 12),
                                                      ),
                                                      10.width,
                                                      const Icon(
                                                        Icons.star_rounded,
                                                        color: Color(0xffFACC15),
                                                        size: 20,
                                                      ),
                                                      5.width,
                                                      Text(
                                                        userProductDetailsController.userProductDetails!.product![0].rating!.isEmpty
                                                            ? St.noReviews.tr
                                                            : "${userProductDetailsController.userProductDetails!.product![0].rating?[0].avgRating}.0 (${userProductDetailsController.userProductDetails!.product![0].rating?[0].totalUser})",
                                                        style: AppFontStyle.styleW500(AppColors.unselected, 12),
                                                      ),
                                                    ],
                                                  ),
                                                  8.height,
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "$currencySymbol ${userProductDetailsController.userProductDetails?.product?[0].price}",
                                                        overflow: TextOverflow.ellipsis,
                                                        style: AppFontStyle.styleW900(AppColors.primary, 20),
                                                      ),
                                                      10.width,
                                                      if (userProductDetailsController.userProductDetails?.product?[0].minimumOfferPrice != null && userProductDetailsController.userProductDetails!.product?[0].minimumOfferPrice != 0) ...{
                                                        Text(
                                                          "\$${userProductDetailsController.userProductDetails?.product?[0].minimumOfferPrice}",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w600,
                                                            color: AppColors.unselected,
                                                            decoration: TextDecoration.lineThrough,
                                                            decorationColor: AppColors.unselected,
                                                          ),
                                                        ),
                                                      },
                                                      //delivery charge
                                                      /*const Spacer(),
                                                      (userProductDetailsController.userProductDetails?.product?[0].shippingCharges == 0)
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
                                                          : Text(
                                                              "${St.deliveryCharge.tr} : $currencySymbol ${userProductDetailsController.userProductDetails!.product![0].shippingCharges}",
                                                              style: AppFontStyle.styleW600(AppColors.unselected, 14),
                                                            ),*/
                                                    ],
                                                  ),
                                                  5.height,
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      30.height,
                                      Column(
                                        children: userProductDetailsController.selectedValuesByType.keys.map((key) {
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // key.capitalizeFirst.toString() == "Colors"
                                              //     ? Padding(
                                              //         padding: const EdgeInsets.symmetric(vertical: 3),
                                              //         child: Text(
                                              //           "Select ${key.capitalizeFirst.toString()}",
                                              //           overflow: TextOverflow.ellipsis,
                                              //           style: AppFontStyle.styleW700(AppColors.white, 16),
                                              //         ),
                                              //       ) :
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 3),
                                                child: Text(
                                                  selectedValues[key] != null ? "Select ${key.capitalizeFirst.toString()} : ${selectedValues[key]}" : key.capitalizeFirst.toString(),
                                                  overflow: TextOverflow.ellipsis,
                                                  style: AppFontStyle.styleW700(AppColors.white, 16),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 8),
                                                child: SizedBox(
                                                  height: Get.height * 0.05,
                                                  // height: Get.width * 0.11,
                                                  child: ListView.builder(
                                                    padding: EdgeInsets.zero,
                                                    scrollDirection: Axis.horizontal,
                                                    itemCount: userProductDetailsController.selectedValuesByType[key]!.length,
                                                    itemBuilder: (context, index) {
                                                      final value = userProductDetailsController.selectedValuesByType[key]![index];
                                                      final isSelected = selectedValues[key] == value;

                                                      return GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            selectedValues[key] = value;
                                                            bool allAttributesFilled = userProductDetailsController.selectedValuesByType.keys.every((key) => selectedValues[key] != null);
                                                            areAllAttributesFilled = allAttributesFilled;
                                                          });
                                                        },
                                                        child:
                                                            /* key.capitalizeFirst.toString() == "Colors" ? Container(
                                                              height: Get.width * 0.11,
                                                              width: Get.width * 0.13,
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(12),
                                                                border: Border.all(
                                                                  color: isSelected ? AppColors.primaryPink : Colors.transparent,
                                                                  width: 2,
                                                                ),
                                                              ),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(8),
                                                                  color: value.startsWith('#') ? Color(int.parse(value.replaceAll("#", "0xFF"))) : colorMap[value.toLowerCase()] ?? Colors.black,
                                                                ),
                                                              ).paddingAll(2),
                                                            ).paddingOnly(right: 6) :*/
                                                            Container(
                                                          alignment: Alignment.center,
                                                          width: Get.width * 0.14,
                                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(12),
                                                            color: isSelected ? AppColors.primaryPink : AppColors.tabBackground,
                                                          ),
                                                          child: FittedBox(
                                                            child: Text(
                                                              value,
                                                              style: AppFontStyle.styleW600(
                                                                  isDark.value
                                                                      ? AppColors.white
                                                                      : isSelected
                                                                          ? Colors.black
                                                                          : AppColors.unselected,
                                                                  14),
                                                            ),
                                                          ),
                                                        ).paddingOnly(right: 10),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                      /* Column(
                                      children: [
                                        ...userProductDetailsController.selectedAttributes.map((attr) => buildAttribute(attr)).toList(),
                                      ],
                                    ),*/
                                      // SingleChildScrollView(
                                      //   scrollDirection: Axis.horizontal,
                                      //   child: Row(
                                      //     children: [
                                      //       for (int i = 0;
                                      //           i < (userProductDetailsController.userProductDetails?.product![0].attributes?[0].value?.length ?? 0);
                                      //           i++)
                                      //         MainButtonWidget(
                                      //           color: AppColors.primary,
                                      //           padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                      //           margin: const EdgeInsets.only(right: 10),
                                      //           borderRadius: 8,
                                      //           child: Text(
                                      //             userProductDetailsController.userProductDetails?.product![0].attributes?[0].value?[i] ?? "",
                                      //             overflow: TextOverflow.ellipsis,
                                      //             style: AppFontStyle.styleW500(AppColors.black, 14),
                                      //           ),
                                      //         ),
                                      //     ],
                                      //   ),
                                      // ),
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
                                          20.width,
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                ":",
                                                overflow: TextOverflow.ellipsis,
                                                style: AppFontStyle.styleW500(AppColors.unselected, 14),
                                              ),
                                              5.height,
                                              Text(
                                                ":",
                                                overflow: TextOverflow.ellipsis,
                                                style: AppFontStyle.styleW500(AppColors.unselected, 14),
                                              ),
                                            ],
                                          ),
                                          25.width,
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                userProductDetailsController.userProductDetails!.product![0].isNewCollection == true ? St.newCollection.tr : St.trendingCollection.tr,
                                                overflow: TextOverflow.ellipsis,
                                                style: AppFontStyle.styleW700(AppColors.white, 14),
                                              ),
                                              5.height,
                                              Text(
                                                userProductDetailsController.userProductDetails!.product![0].category!.name.toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: AppFontStyle.styleW700(AppColors.primary, 14),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      15.height,
                                      Text(
                                        userProductDetailsController.userProductDetails?.product?[0].description.toString() ?? '',
                                        style: AppFontStyle.styleW500(AppColors.unselected, 12),
                                      ),
                                      18.height,
                                      Divider(color: AppColors.unselected.withValues(alpha: 0.25)),
                                      16.height,
                                      if (userProductDetailsController.relatedProductModel!.relatedProducts!.isNotEmpty) ...{
                                        Text(
                                          St.relatedProducts.tr,
                                          style: AppFontStyle.styleW700(AppColors.white, 16),
                                        ),
                                        16.height,
                                        buildRelatedProductsView(),
                                        16.height,
                                      },
                                      10.height,
                                      Text(
                                        St.aboutThisSeller.tr,
                                        style: AppFontStyle.styleW700(AppColors.white, 16),
                                      ),
                                      15.height,
                                      GestureDetector(
                                        onTap: () {
                                          userProductDetailsController.userProductDetails?.product?[0].seller?.id == sellerId
                                              ? null
                                              : Get.to(
                                                  PreviewSellerProfileView(
                                                    sellerName: userProductDetailsController.userProductDetails?.product?[0].seller?.businessName ?? "",
                                                    sellerId: userProductDetailsController.userProductDetails?.product?[0].seller?.id ?? "",
                                                  ),
                                                );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: AppColors.transparent,
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: Row(
                                            children: [
                                              CircleButtonWidget(
                                                size: 52,
                                                color: AppColors.white,
                                                child: PreviewProfileImageWidget(
                                                  size: 50,
                                                  image: userProductDetailsController.userProductDetails?.product?[0].seller?.image,
                                                ),
                                              ),
                                              15.width,
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${userProductDetailsController.userProductDetails?.product?[0].seller?.businessName}",
                                                    style: AppFontStyle.styleW700(AppColors.white, 14),
                                                  ),
                                                  5.height,
                                                  Text(
                                                    "Follower : ${userProductDetailsController.userProductDetails?.product?[0].followerCount}",
                                                    style: AppFontStyle.styleW500(AppColors.unselected, 11),
                                                  ),
                                                  // Text(
                                                  //   "${userProductDetailsController.userProductDetails!.product![0].seller?.businessTag}",
                                                  //   style: AppFontStyle.styleW500(AppColors.unselected, 11),
                                                  // ),
                                                ],
                                              ),
                                              const Spacer(),
                                              userProductDetailsController.userProductDetails?.product?[0].seller?.id == sellerId
                                                  ? SizedBox()
                                                  : MainButtonWidget(
                                                      height: 42,
                                                      width: 90,
                                                      color: (userProductDetailsController.userProductDetails?.product?[0].isFollow == true & isFollow) ? AppColors.tabBackground : AppColors.primary,
                                                      child: Text(
                                                        (userProductDetailsController.userProductDetails?.product![0].isFollow == true & isFollow) ? St.unFollow.tr : St.follow.tr,
                                                        style: AppFontStyle.styleW700((userProductDetailsController.userProductDetails?.product?[0].isFollow == true & isFollow) ? AppColors.white : AppColors.black, 14),
                                                      ),
                                                      callback: () {
                                                        if (getStorage.read("isDemoLogin") ?? false || isDemoSeller) {
                                                          displayToast(message: St.thisIsDemoUser.tr);
                                                        } else {
                                                          setState(() {});
                                                          isFollow = !isFollow;
                                                          followUnFollowController.followUnfollowData(sellerId: userProductDetailsController.userProductDetails!.product![0].seller!.id.toString());
                                                        }
                                                      },
                                                    ),
                                            ],
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
                ),
              ),
              bottomNavigationBar: GetBuilder<UserProductDetailsController>(builder: (context) {
                return userProductDetailsController.userProductDetails?.product?[0].seller?.id == sellerId
                    ? SizedBox()
                    : userProductDetailsController.isLoading.value
                        ? SizedBox()
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            child: Row(
                              children: [
                                // GestureDetector(
                                //   onTap: () async {
                                //   if (getStorage.read("isDemoLogin") ?? false) {
                                //     displayToast(message: St.thisIsDemoUser.tr);
                                //   } else {
                                //     setState(() {
                                //       isLiked = !isLiked;
                                //     });
                                //     addToFavoriteController.postFavoriteData(
                                //       productId: productId,
                                //       categoryId: "${userProductDetailsController.userProductDetails!.product![0].category!.id}",
                                //     );
                                //   }
                                //   },
                                //   child: Container(
                                //       height: 38,
                                //       width: 38,
                                //       alignment: Alignment.center,
                                //       decoration: BoxDecoration(color: Colors.transparent
                                //           // color: AppColors.white.withValues(alpha: 0.1),
                                //           // shape: BoxShape.circle,
                                //           ),
                                //       child: Image.asset(
                                //         userProductDetailsController.userProductDetails?.product?[0].isFavorite == true & isLiked ? AppAsset.icHeart : AppAsset.icLiked,
                                //         width: 22,
                                //       )),
                                // ),
                                GestureDetector(
                                  onTap: _toggleFavoriteFromDetail,
                                  child: Container(
                                    height: 38,
                                    width: 38,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        // color: AppColors.white.withValues(alpha: 0.2),
                                        // shape: BoxShape.circle,
                                        ),
                                    child: Builder(builder: (_) {
                                      final p = userProductDetailsController.userProductDetails?.product?[0];
                                      final isFav = p?.isFavorite == true;
                                      return Image.asset(
                                        isFav ? AppAsset.icHeartFill : AppAsset.icHeart,
                                        width: 20,
                                        color: isFav ? AppColors.red : AppColors.unselected,
                                      );
                                    }),
                                  ),
                                ),
                                const SizedBox(width: 10),

                                12.width,
                                Expanded(
                                  child: MainButtonWidget(
                                    height: 42,
                                    width: Get.width,
                                    borderRadius: 12,
                                    color: AppColors.black,
                                    border: Border.all(color: areAllAttributesFilled ? AppColors.primary : AppColors.unselected),
                                    callback: onBuyNow,
                                    child: Text(
                                      St.buyNow.tr,
                                      style: AppFontStyle.styleW700(areAllAttributesFilled ? AppColors.primary : AppColors.unselected, 12),
                                    ),
                                  ),
                                ),
                                12.width,
                                Expanded(
                                  child: GestureDetector(
                                    onTap: _handleButtonPress,
                                    child: AnimatedSwitcher(
                                      reverseDuration: Duration(milliseconds: 500),
                                      duration: Duration(milliseconds: 500),
                                      switchInCurve: Curves.ease,
                                      switchOutCurve: Curves.ease,
                                      transitionBuilder: transition,
                                      child: !_isFlipped
                                          ? Container(
                                              key: Key('first'),
                                              height: 42,
                                              decoration: BoxDecoration(
                                                color: areAllAttributesFilled ? AppColors.primary : AppColors.tabBackground,
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    AppAsset.icCart,
                                                    width: 16,
                                                    color: areAllAttributesFilled ? AppColors.black : AppColors.unselected,
                                                  ),
                                                  4.width,
                                                  Text(
                                                    St.addToCart.tr,
                                                    style: AppFontStyle.styleW700(areAllAttributesFilled ? AppColors.black : AppColors.unselected, 12),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(
                                              key: Key('second'),
                                              height: 42,
                                              decoration: BoxDecoration(
                                                color: AppColors.primary,
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    AppAsset.icCart,
                                                    width: 16,
                                                    color: AppColors.black,
                                                  ),
                                                  4.width,
                                                  Text(
                                                    St.goToCart.tr,
                                                    style: AppFontStyle.styleW700(AppColors.black, 12),
                                                  ),
                                                ],
                                              ),
                                            ),
                                    ),
                                  ),
                                )
                                // Expanded(
                                //   child: MainButtonWidget(
                                //     height: 42,
                                //     borderRadius: 12,
                                //     width: Get.width,
                                //     color: AppColors.primary,
                                //     callback: () => Get.back(),
                                //     child: Row(
                                //       mainAxisAlignment: MainAxisAlignment.center,
                                //       crossAxisAlignment: CrossAxisAlignment.center,
                                //       children: [
                                //         Image.asset(
                                //           AppAsset.icCart,
                                //           width: 18,
                                //           color: AppColors.black,
                                //         ),
                                //         6.width,
                                //         Text(
                                //           St.addToCart.tr,
                                //           style: AppFontStyle.styleW700(AppColors.black, 12),
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          );
              })
              /*  bottomNavigationBar: GetBuilder<UserProductDetailsController>(builder: (context) {
                return userProductDetailsController.userProductDetails?.product?[0].seller?.id == sellerId
                    ? SizedBox()
                    : userProductDetailsController.isLoading.value
                        ? SizedBox()
                        : isSwiped && areAllAttributesFilled
                            ? Container(
                                height: 80,
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: MainButtonWidget(
                                        color: AppColors.tabBackground,
                                        child: Text(St.shopMore.tr, style: AppFontStyle.styleW700(AppColors.white, 16)),
                                        callback: () {
                                          setState(() {
                                            isSwiped = false;
                                            // slidePosition = 0.0;
                                          });
                                          Get.back();
                                        },
                                      ),
                                    ),
                                    10.width,
                                    Expanded(
                                      child: MainButtonWidget(
                                        color: AppColors.primary,
                                        child: Text(St.goToCart.tr, style: AppFontStyle.styleW700(AppColors.black, 16)),
                                        callback: () {
                                          setState(() {
                                            isSwiped = false;
                                            // slidePosition = 0.0;
                                          });
                                          Get.back();
                                          final controller = Get.put(BottomBarController());
                                          controller.onChangeBottomBar(2);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : userProductDetailsController.userProductDetails?.product?[0].enableAuction == true
                                ? MainButtonWidget(
                                    height: 60,
                                    callback: () {
                                      if (hasAuctionEnded || userProductDetailsController.userProductDetails?.product?[0].productSaleType == 3) {
                                        Utils.showToast(St.auctionHasAlreadyEnded.tr);
                                      } else {
                                        if (areAllAttributesFilled) {
                                          showPlaceBidDialog(
                                            productName: userProductDetailsController.userProductDetails?.product?[0].productName,
                                            productDescription: userProductDetailsController.userProductDetails?.product?[0].description.toString(),
                                            currentPrice: userProductDetailsController.userProductDetails?.product?[0].price?.toString(),
                                            timeRemaining: userProductDetailsController.userProductDetails?.product?[0].auctionEndDate.toString() ?? '',
                                            location: _getAddress(),
                                            lastBidAmount: (userProductDetailsController.userProductDetails?.product?[0].latestBidPrice).toString(),
                                            productImage: userProductDetailsController.userProductDetails?.product?[0].images?[0],
                                            selectedAttributes: selectedValues,
                                          );
                                        } else {
                                          displayToast(message: St.pleaseFillAllAttributes.tr, isBottomToast: true);
                                        }
                                      }
                                    },
                                    border: Border.all(color: AppColors.primary),
                                    color: Colors.transparent,
                                    child: Text(
                                      St.placeBid.tr,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: AppFontStyle.styleW700(AppColors.primary, 15),
                                    ),
                                  ).paddingSymmetric(horizontal: 16, vertical: 10)
                                : GestureDetector(
                                    onTap: () {
                                      if (areAllAttributesFilled) {
                                        onSubmit().then((_) {
                                          if (addProductToCartController.isLoading.value == false) {
                                            setState(() {
                                              isSwiped = true;
                                            });
                                          }
                                        });
                                      } else {
                                        displayToast(message: St.pleaseFillAllAttributes.tr, isBottomToast: true);
                                      }
                                    },
                                    // onHorizontalDragUpdate: (details) {
                                    //   setState(() {
                                    //     slidePosition = details.localPosition.dx.clamp(0.0, maxSlide);
                                    //   });
                                    // },
                                    // onHorizontalDragEnd: (details) {
                                    //   if (slidePosition >= maxSlide * 0.8) {
                                    //     if (areAllAttributesFilled) {
                                    //       onSubmit().then((_) {
                                    //         if (addProductToCartController.isLoading.value == false) {
                                    //           setState(() {
                                    //             isSwiped = true; // Only set swiped if attributes were filled
                                    //           });
                                    //         }
                                    //       });
                                    //     } else {
                                    //       displayToast(message: St.pleaseFillAllAttributes.tr);
                                    //     }
                                    //   }
                                    //   setState(() => slidePosition = 0.0);
                                    // },
                                    child: Container(
                                      width: double.infinity,
                                      height: 60,
                                      margin: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: areAllAttributesFilled ? Colors.white : AppColors.tabBackground,
                                      ),
                                      child: Center(
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(14),
                                              decoration: BoxDecoration(
                                                color: AppColors.primary,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Image.asset(
                                                AppAsset.icCart,
                                                width: 22,
                                                color: AppColors.black,
                                              ),
                                            ),
                                            Spacer(),
                                            Text(
                                              St.addToCartThisProduct.tr.toUpperCase(),
                                              style: AppFontStyle.styleW700(
                                                areAllAttributesFilled ? AppColors.black : AppColors.white,
                                                15,
                                              ),
                                            ),
                                            Spacer(),
                                            SizedBox(width: 50),
                                          ],
                                        ).paddingOnly(left: 6),
                                      ),
                                    ),
                                  );
              })*/
              ),
          Obx(
            () => addProductToCartController.isLoading.value
                ? Container(
                    height: Get.height,
                    width: Get.width,
                    color: Colors.black54,
                    child: Center(
                        child: CircularProgressIndicator(
                      color: AppColors.primary,
                    )),
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }

  buildRelatedProductsView() {
    return SizedBox(
      height: 230,
      child: ListView.builder(
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: userProductDetailsController.relatedProductModel?.relatedProducts?.length,
        // padding: EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (context, index) {
          final product = userProductDetailsController.relatedProductModel?.relatedProducts?[index];
          return GestureDetector(
            onTap: () {
              productId = product.id ?? '';
              Get.delete<UserProductDetailsController>();

              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => ProductDetail(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0); // Right to left
                    const end = Offset.zero;
                    const curve = Curves.ease;

                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                  transitionDuration: Duration(milliseconds: 300),
                ),
              );
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => ProductDetail(),
              //     ));
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
                              imageUrl: product?.mainImage.toString() ?? "",
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // GestureDetector(
                                  //   onTap: () {
                                  //     // if (getStorage.read("isDemoLogin") ?? false) {
                                  //     //   displayToast(message: St.thisIsDemoUser.tr);
                                  //     //   return;
                                  //     // } else {
                                  //     //   galleryCategoryController.likes[index] = !galleryCategoryController.likes[index];
                                  //     //   galleryCategoryController.update();
                                  //     //
                                  //     //   addToFavoriteController.postFavoriteData(productId: "${product.id}", categoryId: "${product.category!.id}");
                                  //     // }
                                  //   },
                                  //   child: Container(
                                  //     height: 32,
                                  //     width: 32,
                                  //     decoration: BoxDecoration(
                                  //       color: AppColors.white,
                                  //       shape: BoxShape.circle,
                                  //     ),
                                  //     // child: Padding(
                                  //     //   padding: const EdgeInsets.all(8.0),
                                  //     //   child: Image(
                                  //     //     image: product?.isFavorite == true & galleryCategoryController.likes[index] ? AssetImage(AppAsset.icHeartFill) : AssetImage(AppAsset.icHeart),
                                  //     //     color: product?.isFavorite == true & galleryCategoryController.likes[index] ? AppColors.red : null,
                                  //     //   ),
                                  //     // ),
                                  //   ),
                                  // ),
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
                          product?.productName ?? '',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: AppConstant.appFontRegular, color: AppColors.white, fontSize: 11),
                        ),
                        2.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "$currencySymbol ${product?.price}",
                              overflow: TextOverflow.ellipsis,
                              style: AppFontStyle.styleW900(AppColors.primary, 15),
                            ),
                            Spacer(),
                            const Icon(
                              Icons.star_rounded,
                              color: Color(0xffFACC15),
                              size: 16,
                            ),
                            2.width,
                            Text(
                              product!.rating!.isEmpty ? St.noReviews.tr : "${product.rating?[0].avgRating}.0",
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
    );
  }

  Future<void> _toggleFavoriteFromDetail() async {
    if (getStorage.read("isDemoLogin") ?? false || isDemoSeller) {
      displayToast(message: St.thisIsDemoUser.tr);
      return;
    }

    final product = userProductDetailsController.userProductDetails?.product?[0];
    if (product == null) return;

    final newVal = !(product.isFavorite == true);

    setState(() => product.isFavorite = newVal);

    try {
      await addToFavoriteController.postFavoriteData(
        productId: "${product.id}",
        categoryId: "${product.category?.id}",
      );
      if (Get.isRegistered<GalleryCategoryController>()) {
        final galleryCtrl = Get.find<GalleryCategoryController>();

        final idx = galleryCtrl.galleryProducts.indexWhere((e) => e.id == product.id);
        if (idx != -1) {
          if (galleryCtrl.likes.length != galleryCtrl.galleryProducts.length) {
            galleryCtrl.likes = List<bool>.generate(
              galleryCtrl.galleryProducts.length,
              (i) => galleryCtrl.galleryProducts[i].isFavorite == true,
            );
          }
          galleryCtrl.likes[idx] = newVal;
          galleryCtrl.galleryProducts[idx].isFavorite = newVal;
          galleryCtrl.update();
        }
      }
    } catch (e) {
      setState(() => product.isFavorite = !newVal);
      displayToast(message: St.somethingWentWrong.tr);
    }
  }

  void _navigateToCart() async {
    Get.back();
    await Future.delayed(Duration(milliseconds: 50));
    BottomBarController controller;
    if (Get.isRegistered<BottomBarController>()) {
      controller = Get.find<BottomBarController>();
    } else {
      controller = Get.put(BottomBarController());
    }
    controller.onChangeBottomBar(2);
  }

  void _handleButtonPress() async {
    if (_isFlipped) {
      Get.back();
      _navigateToCart();
    } else {
      if (areAllAttributesFilled) {
        try {
          await onSubmit();
          setState(() {
            _isFlipped = true;
          });
        } catch (e) {
          displayToast(message: 'Failed to add to cart', isBottomToast: true);
        }
      } else {
        displayToast(message: St.pleaseFillAllAttributes.tr, isBottomToast: true);
      }
    }
  }

  Widget transition(Widget widget, Animation<double> animation) {
    final flipAnimation = Tween(begin: 5.0, end: 0.0).animate(animation);
    return AnimatedBuilder(
      animation: flipAnimation,
      builder: (BuildContext context, Widget? child) {
        final isUnder = (ValueKey(_isFlipped) != widget.key);
        final value = isUnder ? min(flipAnimation.value, pi / 2) : flipAnimation.value;
        return Transform(
          transform: Matrix4.rotationX(value),
          alignment: Alignment.center,
          child: widget,
        );
      },
    );
  }

  bool get hasAuctionEnded {
    try {
      final auctionEndDate = userProductDetailsController.userProductDetails?.product?[0].auctionEndDate;
      final endDate = DateTime.parse(auctionEndDate.toString());
      return DateTime.now().isAfter(endDate);
    } catch (e) {
      return true;
    }
  }
}

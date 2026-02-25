import 'dart:convert';
import 'dart:developer';
import 'package:dotted_line/dotted_line.dart';
import 'package:era_shop/Controller/GetxController/user/add_product_to_cart_controller.dart';
import 'package:era_shop/Controller/GetxController/user/gallery_catagory_controller.dart';
import 'package:era_shop/Controller/GetxController/user/get_all_cart_products_controller.dart';
import 'package:era_shop/Controller/GetxController/user/remove_product_to_cart_controller.dart';
import 'package:era_shop/custom/main_button_widget.dart';
import 'package:era_shop/custom/preview_image_widget.dart';
import 'package:era_shop/user_pages/bottom_bar_page/controller/bottom_bar_controller.dart';
import 'package:era_shop/utils/CoustomWidget/App_theme_services/no_data_found.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_asset.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:era_shop/utils/shimmers.dart';
import 'package:era_shop/utils/show_toast.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  GalleryCategoryController galleryCategoryController = Get.put(GalleryCategoryController());
  GetAllCartProductController getAllCartProductController = Get.put(GetAllCartProductController());
  AddProductToCartController addProductToCartController = Get.put(AddProductToCartController());
  RemoveProductToCartController removeProductToCartController = Get.put(RemoveProductToCartController());

  late int totalQuantity = 1;
  int counter = 0;
  double totalAmount = 0.0;

  checkOutButton() {
    Get.toNamed("/CheckOut") /*?.then((value) => getAllCartProductController.getAllCartProductData())*/; // open if need
  }

  @override
  void initState() {
    getAllCartProductController.getCartProductData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(GetAllCartProductController());
    return GetBuilder(builder: (GetAllCartProductController getAllCartProductController) {
      totalAmount = ((getAllCartProductController.getAllCartProducts?.data?.totalShippingCharges ?? 0) + (getAllCartProductController.getAllCartProducts?.data?.subTotal ?? 0)).toDouble();

      if (getAllCartProductController.firstLoading.value == true) {
        return Shimmers.cartShimmer();
      }

      return PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) {
          Get.find<BottomBarController>().onChangeBottomBar(0);
          if (didPop) {
            return;
          }
        },
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: AppColors.transparent,
              shadowColor: AppColors.black.withValues(alpha: 0.4),
              flexibleSpace: CartAppBarWidget(title: St.cartTitle.tr),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: getAllCartProductController.getAllCartProducts?.status == false && getAllCartProductController.getAllCartProducts?.message == "Cart does not found for this user." ||
                    getAllCartProductController.getAllCartProducts?.message == "No products found in the cart." //        "No products found in the cart."
                ? noDataFound(
                    image: "assets/no_data_found/basket.png",
                  ).paddingOnly(bottom: Get.height * .20)
                : Column(
                    children: [
                      // logic.isLoading1 ? LinearProgressIndicator(minHeight: 3) : SizedBox(height: 3),
                      Obx(
                        () => getAllCartProductController.updateLoading.value || addProductToCartController.isLoading.value || removeProductToCartController.isLoading.value
                            ? LinearProgressIndicator(
                                minHeight: 3,
                                color: AppColors.primary,
                                backgroundColor: AppColors.lightGrey,
                              )
                            : SizedBox(height: 3),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: ListView.builder(
                            itemCount: getAllCartProductController.getAllCartProducts?.data?.items?.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final List attributesArray = getAllCartProductController.getAllCartProducts?.data?.items?[index].attributesArray ?? [];
                              // List productCounts =
                              //     List.generate(getAllCartProductController.getAllCartProducts!.data!.items!.length, (index) => false);
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: CartListTileWidget(
                                  index: index,
                                  productImage: getAllCartProductController.getAllCartProducts?.data?.items?[index].productId!.mainImage.toString() ?? "",
                                  productName: getAllCartProductController.getAllCartProducts?.data?.items?[index].productId!.productName.toString() ?? "",
                                  attributesArray: jsonDecode(jsonEncode(attributesArray)),
                                  productPrice: getAllCartProductController.getAllCartProducts?.data?.items?[index].purchasedTimeProductPrice!.toInt() ?? 0,
                                  productId: "${getAllCartProductController.getAllCartProducts?.data?.items?[index].productId?.id}",
                                  productQuantity: getAllCartProductController.getAllCartProducts?.data?.items?[index].productQuantity?.toInt() ?? 0,
                                  productShippingCharge: getAllCartProductController.getAllCartProducts?.data?.items?[index].purchasedTimeShippingCharges?.toInt() ?? 0,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      DottedLine(dashColor: AppColors.unselected.withValues(alpha: 0.4)),
                      10.height,
                      Row(
                        children: [
                          Text(
                            St.amount.tr,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: AppFontStyle.styleW500(AppColors.unselected, 14),
                          ),
                          const Spacer(),
                          Obx(
                            () => TextOverlayShimmer(
                              shimmerTextStyle:
                                  AppFontStyle.styleW900(getAllCartProductController.updateLoading.value || addProductToCartController.isLoading.value || removeProductToCartController.isLoading.value ? AppColors.grayLight : AppColors.primary, 14),
                              textStyle:
                                  AppFontStyle.styleW900(getAllCartProductController.updateLoading.value || addProductToCartController.isLoading.value || removeProductToCartController.isLoading.value ? AppColors.grayLight : AppColors.primary, 14),
                              fontWeight: FontWeight.w900,
                              isLoading: getAllCartProductController.updateLoading.value,
                              // text: "$currencySymbol$totalAmount",
                              text: "$currencySymbol${getAllCartProductController.getAllCartProducts?.data?.subTotal?.toString() ?? "0.0"}",
                            ),
                          ),
                        ],
                      ),
                      20.height,
                      Obx(
                        () => MainButtonWidget(
                          height: 60,
                          width: Get.width,
                          color: getAllCartProductController.updateLoading.value || addProductToCartController.isLoading.value || removeProductToCartController.isLoading.value ? AppColors.primary.withValues(alpha: 0.4) : AppColors.primary,
                          callback: getAllCartProductController.updateLoading.value || addProductToCartController.isLoading.value || removeProductToCartController.isLoading.value
                              ? null
                              : () {
                                  if (getAllCartProductController.getAllCartProducts?.data != null) {
                                    checkOutButton();
                                  } else {
                                    displayToast(message: St.yourCartIsEmpty.tr);
                                  }
                                },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                St.checkOut.tr.toUpperCase(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: AppFontStyle.styleW700(AppColors.black, 15),
                              ),
                              8.width,
                              Image.asset(AppAsset.icDoubleArrowRight, width: 14),
                            ],
                          ),
                        ),
                      ),
                      100.height,
                    ],
                  ),
          ),
        ),
      );
    });
  }
}

class CartAppBarWidget extends StatelessWidget {
  const CartAppBarWidget({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        color: AppColors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: AppFontStyle.styleW900(AppColors.white, 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CartListTileWidget extends StatefulWidget {
  const CartListTileWidget({
    super.key,
    required this.productImage,
    required this.productName,
    required this.attributesArray,
    required this.productPrice,
    required this.productId,
    required this.productQuantity,
    required this.productShippingCharge,
    required this.index,
  });

  final String productImage;
  final String productName;
  final List<dynamic> attributesArray;
  final int productPrice;
  final int index;
  final String productId;
  final int productQuantity;
  final int productShippingCharge;

  @override
  State<CartListTileWidget> createState() => _CartListTileWidgetState();
}

class _CartListTileWidgetState extends State<CartListTileWidget> {
  GetAllCartProductController getAllCartProductController = Get.put(GetAllCartProductController());
  RemoveProductToCartController removeProductToCartController = Get.put(RemoveProductToCartController());
  AddProductToCartController addProductToCartController = Get.put(AddProductToCartController());

  List<dynamic> attributesId = [];
  int localQuantity = 0;

  @override
  void initState() {
    super.initState();
    localQuantity = widget.productQuantity;
  }

  increment() {
    setState(() {
      localQuantity++; // UI fast update thase
    });

    productId = widget.productId;
    log('product id >>>> $productId');

    addProductToCartController.addProductToCartData(productQuantity: 1, attributes: widget.attributesArray).then((value) {
      getAllCartProductController.getCartProductData(updatedData: true);
    });
  }

  decrement() {
    if (localQuantity > 1) {
      setState(() {
        localQuantity--;
      });

      productId = widget.productId;
      log("product id >>>> $productId");

      removeProductToCartController.removeProductToCartData(productQuantity: 1, attributes: widget.attributesArray).then((value) {
        getAllCartProductController.getCartProductData(updatedData: true);
      });
    } else if (localQuantity == 1) {
      // Remove last quantity
      productId = widget.productId;
      log("Removing last product >>>> $productId");

      removeProductToCartController.removeProductToCartData(productQuantity: 1, attributes: widget.attributesArray).then((value) {
        getAllCartProductController.getCartProductData(updatedData: true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Stack(
        children: [
          Container(
            // height: 120,
            width: Get.width,
            // margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: AppColors.tabBackground,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                1.width,
                PreviewImageWidget(
                  height: 110,
                  width: 110,
                  fit: BoxFit.cover,
                  image: widget.productImage,
                  radius: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.productName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: AppFontStyle.styleW700(AppColors.white, 14),
                      ),
                      5.height,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: Get.width / 2.6,
                            child: ListView.builder(
                              itemCount: widget.attributesArray.take(2).length,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final attribute = widget.attributesArray[index];
                                attributesId.add(attribute["_id"].toString());
                                log("message:::::${attribute["name"]}");
                                return Container(
                                  padding: EdgeInsets.only(bottom: index != 0 ? 0 : 6),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '${attribute["name"]} : '.capitalizeFirst,
                                          style: AppFontStyle.styleW500(AppColors.white.withValues(alpha: .5), 13),
                                        ),
                                        TextSpan(
                                          text: '${attribute["values"].join(", ")}',
                                          style: AppFontStyle.styleW500(AppColors.primaryPink, 13),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      5.height,
                      Text(
                        "$currencySymbol ${widget.productPrice}",
                        style: AppFontStyle.styleW900(AppColors.primary, 14),
                      ),
                    ],
                  ).paddingOnly(left: 10),
                ),
              ],
            ),
          ),
          Positioned(
            right: 8,
            bottom: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      log('product index ${widget.index}');
                      decrement();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.black,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(Icons.remove, color: AppColors.white, size: 14),
                    ),
                  ),
                  // Quantity Text
                  8.width,
                  // Obx(
                  //   () => getAllCartProductController
                  //               .updateLoading.value ||
                  //           addProductToCartController
                  //               .isLoading.value ||
                  //           removeProductToCartController
                  //               .isLoading.value
                  //       ? const SizedBox(
                  //           height: 10,
                  //           width: 10,
                  //           child: CupertinoActivityIndicator())
                  //       : Text(
                  //           '${widget.productQuantity}',
                  //           style: AppFontStyle.styleW500(
                  //             AppColors.black,
                  //             15,
                  //           ),
                  //         ),
                  // ),
                  Text(
                    localQuantity.toString(),
                    style: AppFontStyle.styleW500(AppColors.black, 15),
                  ),
                  8.width,
                  GestureDetector(
                    onTap: () {
                      increment();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.black,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(Icons.add, color: AppColors.white, size: 14),
                    ),
                  ),
                ],
              ),
            ).paddingOnly(bottom: 4, right: 4),
          ),
        ],
      ),
    );
  }
}

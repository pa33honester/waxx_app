import 'dart:convert';
import 'dart:developer';
import 'package:dotted_line/dotted_line.dart';
import 'package:waxxapp/Controller/GetxController/user/add_product_to_cart_controller.dart';
import 'package:waxxapp/Controller/GetxController/user/gallery_catagory_controller.dart';
import 'package:waxxapp/Controller/GetxController/user/get_all_cart_products_controller.dart';
import 'package:waxxapp/Controller/GetxController/user/remove_product_to_cart_controller.dart';
import 'package:waxxapp/custom/delivery_options_picker.dart';
import 'package:waxxapp/custom/main_button_widget.dart';
import 'package:waxxapp/custom/preview_image_widget.dart';
import 'package:waxxapp/user_pages/bottom_bar_page/controller/bottom_bar_controller.dart';
import 'package:waxxapp/utils/CoustomWidget/App_theme_services/no_data_found.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_asset.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/shimmers.dart';
import 'package:waxxapp/utils/show_toast.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  GalleryCategoryController galleryCategoryController = Get.put(GalleryCategoryController());
  // Guarded find-or-put: when entering Cart via Buy Now, Product
  // Detail's State already put GetAllCartProductController.
  // Re-putting here used to replace that singleton, killing the
  // GetBuilder subscription set up below and breaking the Amount
  // total recalc on +/-. Use the same pattern for the two cart
  // mutators so concurrent Cart tab + Buy Now flows don't fight.
  GetAllCartProductController getAllCartProductController = Get.isRegistered<GetAllCartProductController>()
      ? Get.find<GetAllCartProductController>()
      : Get.put(GetAllCartProductController());
  AddProductToCartController addProductToCartController = Get.isRegistered<AddProductToCartController>()
      ? Get.find<AddProductToCartController>()
      : Get.put(AddProductToCartController());
  RemoveProductToCartController removeProductToCartController = Get.isRegistered<RemoveProductToCartController>()
      ? Get.find<RemoveProductToCartController>()
      : Get.put(RemoveProductToCartController());

  late int totalQuantity = 1;
  int counter = 0;
  double totalAmount = 0.0;

  checkOutButton() {
    Get.toNamed("/CheckOut") /*?.then((value) => getAllCartProductController.getAllCartProductData())*/; // open if need
  }

  // Items the cart UI actually shows — anything at productQuantity 0
  // (a stale row the backend's $pull cleanup missed) is excluded so
  // it neither renders as a tile nor contributes to the displayed
  // Amount. Single source of truth for both the list and the total.
  List<dynamic> get _visibleCartItems {
    final allItems = getAllCartProductController.getAllCartProducts?.data?.items ?? [];
    return allItems.where((it) => (it.productQuantity?.toInt() ?? 0) > 0).toList();
  }

  // Client-side subtotal computed from the visible items only.
  // Trusting the backend's stored `subTotal` directly produced wrong
  // numbers when a stale qty-0 row left the stored value out of sync
  // (e.g. showing GH¢900 with the only item at quantity 0). Summing
  // purchasedTimeProductPrice × productQuantity over the visible rows
  // always matches what the user sees.
  num get _visibleSubTotal {
    num sum = 0;
    for (final it in _visibleCartItems) {
      final price = (it.purchasedTimeProductPrice ?? 0);
      final qty = (it.productQuantity ?? 0);
      sum += (price as num) * (qty as num);
    }
    return sum;
  }

  @override
  void initState() {
    getAllCartProductController.getCartProductData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // GetBuilder bound explicitly to the State's controller field via
    // init: — without this, GetBuilder falls back to Get.find each
    // rebuild, which can subscribe to a different instance than the
    // one increment/decrement callbacks hold (especially on the Buy
    // Now → Cart push, where Product Detail's State also put one).
    return GetBuilder<GetAllCartProductController>(
        init: getAllCartProductController,
        builder: (getAllCartProductController) {
      totalAmount = ((getAllCartProductController.getAllCartProducts?.data?.totalShippingCharges ?? 0) + (getAllCartProductController.getAllCartProducts?.data?.subTotal ?? 0)).toDouble();

      if (getAllCartProductController.firstLoading.value == true) {
        return Shimmers.cartShimmer();
      }

      // Cart is reachable two ways: as a bottom-tab (no previous route to
      // pop — back should switch to Home tab) and via Get.toNamed from
      // Buy Now (Product Detail is below — back should pop normally).
      // canPop reflects which mode we're in.
      final canPopNow = Navigator.of(context).canPop();
      return PopScope(
        canPop: canPopNow,
        onPopInvoked: (bool didPop) {
          if (didPop) return;
          Get.find<BottomBarController>().onChangeBottomBar(0);
        },
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: AppColors.transparent,
              shadowColor: AppColors.black.withValues(alpha: 0.4),
              flexibleSpace: CartAppBarWidget(
                title: St.cartTitle.tr,
                showBack: canPopNow,
              ),
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
                      Builder(builder: (context) {
                        // Defensive filter: hide any cart items the
                        // backend has left at productQuantity == 0.
                        // Those can occur if a previous decrement
                        // reduced the qty to 0 but the server-side
                        // $pull cleanup didn't run (race, error, or
                        // partial response). Without this filter the
                        // user sees a tile they can't decrement (the
                        // backend's 0 >= 1 precondition fails) and
                        // the cart total stays wrong. If the cart
                        // ends up entirely empty after the filter,
                        // render the no-data state inline so the user
                        // doesn't sit on a blank page with a stale
                        // Amount.
                        final visibleItems = _visibleCartItems;

                        if (visibleItems.isEmpty) {
                          return Expanded(
                            child: noDataFound(
                              image: "assets/no_data_found/basket.png",
                            ).paddingOnly(bottom: Get.height * .20),
                          );
                        }

                        return Expanded(
                          child: SingleChildScrollView(
                            child: ListView.builder(
                              itemCount: visibleItems.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final item = visibleItems[index];
                                final List attributesArray = item.attributesArray ?? [];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: CartListTileWidget(
                                    index: index,
                                    productImage: item.productId!.mainImage.toString(),
                                    productName: item.productId!.productName.toString(),
                                    attributesArray: jsonDecode(jsonEncode(attributesArray)),
                                    productPrice: item.purchasedTimeProductPrice!.toInt(),
                                    productId: "${item.productId?.id}",
                                    productQuantity: item.productQuantity?.toInt() ?? 0,
                                    productShippingCharge: item.purchasedTimeShippingCharges?.toInt() ?? 0,
                                    deliveryOptions: item.productId?.deliveryOptions,
                                    chosenDeliveryType: item.chosenDeliveryType,
                                    onCartChanged: () {
                                      if (mounted) setState(() {});
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }),
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
                              // Compute from the visible items rather than
                              // the backend's stored subTotal — see
                              // _visibleSubTotal for why.
                              text: "$currencySymbol${_visibleSubTotal.toString()}",
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
  const CartAppBarWidget({super.key, required this.title, this.showBack = false});

  final String title;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        color: AppColors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Text(
                title,
                style: AppFontStyle.styleW900(AppColors.white, 18),
              ),
            ),
            if (showBack)
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.arrow_back_ios_new, color: AppColors.white, size: 20),
                  tooltip: 'Back',
                ),
              ),
          ],
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
    this.deliveryOptions,
    this.chosenDeliveryType,
    this.onCartChanged,
  });

  final String productImage;
  final String productName;
  final List<dynamic> attributesArray;
  final int productPrice;
  final int index;
  final String productId;
  final int productQuantity;
  final int productShippingCharge;
  // Shape B (v1.0.10): the seller's offered scopes + the buyer's
  // current pick. Null/empty when the product is on legacy single-cost
  // shipping; the tile then renders no picker.
  final List<dynamic>? deliveryOptions;
  final String? chosenDeliveryType;
  // Fired after every successful +/- API refetch. The parent Cart
  // Page wires this to setState((){}) so the Amount / Sub Total
  // numbers redraw even when the GetBuilder subscription is in a
  // bad state (e.g. Buy Now → Cart push, where Product Detail's
  // State has already touched the controller registry).
  final VoidCallback? onCartChanged;

  @override
  State<CartListTileWidget> createState() => _CartListTileWidgetState();
}

class _CartListTileWidgetState extends State<CartListTileWidget> {
  // Guarded find-or-put — see _CartPageState for the rationale.
  // These tiles are rebuilt on every cart fetch; replacing the
  // singleton each time would invalidate the parent GetBuilder's
  // subscription and break +/- recalculations.
  GetAllCartProductController getAllCartProductController = Get.isRegistered<GetAllCartProductController>()
      ? Get.find<GetAllCartProductController>()
      : Get.put(GetAllCartProductController());
  RemoveProductToCartController removeProductToCartController = Get.isRegistered<RemoveProductToCartController>()
      ? Get.find<RemoveProductToCartController>()
      : Get.put(RemoveProductToCartController());
  AddProductToCartController addProductToCartController = Get.isRegistered<AddProductToCartController>()
      ? Get.find<AddProductToCartController>()
      : Get.put(AddProductToCartController());

  List<dynamic> attributesId = [];
  int localQuantity = 0;

  @override
  void initState() {
    super.initState();
    localQuantity = widget.productQuantity;
  }

  // After the cart refetch completes, fire the parent's
  // onCartChanged callback. That callback is wired in _CartPageState
  // to a plain setState((){}) so the Amount / Sub Total / line-item
  // totals redraw even when the GetBuilder subscription is in a
  // bad state. Without this, Buy Now → Cart left stale numbers on
  // the screen until the user navigated to Checkout, because the
  // GetBuilder's update() never reached the right subscription.
  Future<void> _refetchCart() async {
    await getAllCartProductController.getCartProductData(updatedData: true);
    widget.onCartChanged?.call();
  }

  increment() {
    setState(() {
      localQuantity++; // UI fast update thase
    });

    productId = widget.productId;
    log('product id >>>> $productId');

    addProductToCartController.addProductToCartData(productQuantity: 1, attributes: widget.attributesArray).then((value) {
      _refetchCart();
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
        _refetchCart();
      });
    } else if (localQuantity == 1) {
      // Remove last quantity. Optimistically hide the +/- by zeroing
      // localQuantity so the user doesn't see the tile flash "1" while
      // the API + refetch round-trips. The parent's onCartChanged
      // callback fires a setState((){}) after the refetch lands, at
      // which point the cart's tile list is rebuilt from the fresh
      // payload — this tile gets either reused with the new item (if
      // removal failed) or unmounted entirely (if cart is now empty).
      setState(() {
        localQuantity = 0;
      });

      productId = widget.productId;
      log("Removing last product >>>> $productId");

      removeProductToCartController.removeProductToCartData(productQuantity: 1, attributes: widget.attributesArray).then((value) {
        _refetchCart();
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
                      // Shape B (v1.0.10): per-item delivery picker. Renders
                      // pills only when the seller offered ≥1 option in
                      // their pricing-page panel; otherwise falls through
                      // to the legacy single-cost path silently.
                      if ((widget.deliveryOptions ?? const []).isNotEmpty) ...[
                        8.height,
                        _buildDeliveryOptionsPicker(),
                      ],
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

  Widget _buildDeliveryOptionsPicker() {
    return DeliveryOptionsPicker(
      deliveryOptions: widget.deliveryOptions,
      chosenDeliveryType: widget.chosenDeliveryType,
      productId: widget.productId,
      attributesArray: widget.attributesArray,
    );
  }
}

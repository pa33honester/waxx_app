import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:waxxapp/Controller/GetxController/user/add_product_to_cart_controller.dart';
import 'package:waxxapp/Controller/GetxController/user/get_all_cart_products_controller.dart';
import 'package:waxxapp/Controller/GetxController/user/remove_product_to_cart_controller.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class CartItems extends StatefulWidget {
  CartItems({
    Key? key,
    required this.productImage,
    required this.productName,
    required this.attributesArray,
    required this.productPrice,
    required this.productId,
    required this.productQuantity,
  }) : super(key: key);

  final String productImage;
  final String productName;
  final List<dynamic> attributesArray;
  final String productId;
  final int productPrice;
  late int productQuantity;

  @override
  State<CartItems> createState() => _CartItemsState();
}

class _CartItemsState extends State<CartItems> {
  GetAllCartProductController getAllCartProductController = Get.put(GetAllCartProductController());
  RemoveProductToCartController removeProductToCartController = Get.put(RemoveProductToCartController());
  AddProductToCartController addProductToCartController = Get.put(AddProductToCartController());

/*  bool _isDecrementButtonDisabled = false;
  void _handleDecrementButtonTap() {
    if (!_isDecrementButtonDisabled) {
      setState(() {
        _isDecrementButtonDisabled = true;
      });
      decrement();
    }
  }

  bool _isIncrementButtonDisabled = false;
  void _handleIncrementButtonTap() {
    log("_handleIncrementButtonTap");
    if (!_isIncrementButtonDisabled) {
      setState(() {
        _isIncrementButtonDisabled = true;
      });
      increment();
    }
  }*/

  increment() {
    setState(() {
      // widget.productQuantity++;
      productId = widget.productId;
      addProductToCartController.addProductToCartData(productQuantity: 1, attributes: widget.attributesArray).then((value) => getAllCartProductController.getCartProductData(updatedData: true));
    });
  }

  decrement() {
    setState(() {
      // widget.productQuantity--;
      productId = widget.productId;
      log("Product IDD :: $productId");
      removeProductToCartController.removeProductToCartData(productQuantity: 1, attributes: widget.attributesArray).then((value) => getAllCartProductController.getCartProductData(updatedData: true));
    });
  }

  List<dynamic> attributesId = [];

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.startToEnd,
      confirmDismiss: (DismissDirection direction) async {
        return Get.dialog(Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: AppColors.primaryPink,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(25),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Remove from Cart",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
                Image.asset("assets/icons/removeFromCart.png", height: 200).paddingSymmetric(vertical: 8),
                Text(
                  "Are you sure you wish to remove this Product?",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                    // fontSize: 1,
                    color: AppColors.darkGrey,
                  ),
                ).paddingSymmetric(horizontal: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        productId = widget.productId;
                        await removeProductToCartController.removeProductToCartData(productQuantity: widget.productQuantity, attributes: widget.attributesArray).then((value) => getAllCartProductController.getCartProductData(updatedData: true));
                        Get.back();
                      },
                      child: Container(
                        height: 50,
                        width: Get.width * 0.3,
                        decoration: BoxDecoration(color: AppColors.primaryPink, borderRadius: BorderRadius.circular(16)),
                        child: Center(
                          child: Obx(
                            () => removeProductToCartController.isLoading.value
                                ? CupertinoActivityIndicator(color: AppColors.white)
                                : Text(
                                    "Remove",
                                    style: GoogleFonts.plusJakartaSans(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w500),
                                  ),
                          ),
                        ),
                      ),
                    ).paddingOnly(right: 10),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        height: 50,
                        width: Get.width * 0.3,
                        decoration: BoxDecoration(color: AppColors.primaryPink, borderRadius: BorderRadius.circular(16)),
                        child: Center(
                          child: Text(
                            St.cancelText.tr,
                            style: GoogleFonts.plusJakartaSans(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    )
                  ],
                ).paddingSymmetric(vertical: 17)
              ],
            ),
          ),
        ));
      },
      background: Row(
        children: [
          SizedBox(
            width: Get.width / 7,
          ),
          const Image(
            image: AssetImage("assets/icons/Delete.png"),
            height: 23,
          ),
        ],
      ),
      key: UniqueKey(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: GestureDetector(
          onTap: () {
            productId = widget.productId;
            Get.toNamed("/ProductDetail");
          },
          child: Container(
            width: Get.width,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: isDark.value ? AppColors.lightBlack : AppColors.dullWhite),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 12),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                          height: 110,
                          width: 95,
                          fit: BoxFit.cover,
                          imageUrl: widget.productImage,
                          placeholder: (context, url) => const Center(
                              child: CupertinoActivityIndicator(
                            animating: true,
                          )),
                          errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                        ),
                      ),
                      SizedBox(
                        width: 95,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                // _handleDecrementButtonTap();
                                decrement();
                              },
                              child: Container(
                                height: 24,
                                width: 24,
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.mediumGrey),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Icon(
                                  Icons.remove,
                                  size: 18,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 24,
                              width: Get.width / 9,
                              child: Obx(
                                () => Center(
                                  child: getAllCartProductController.updateLoading.value || addProductToCartController.isLoading.value || removeProductToCartController.isLoading.value
                                      ? const CupertinoActivityIndicator()
                                      : Text("${widget.productQuantity}", style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w500)),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // _handleIncrementButtonTap();
                                increment();
                              },
                              child: Container(
                                height: 24,
                                width: 24,
                                decoration: BoxDecoration(border: Border.all(color: AppColors.mediumGrey), borderRadius: BorderRadius.circular(5)),
                                child: const Icon(
                                  Icons.add,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ).paddingSymmetric(vertical: 15),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 14, left: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: Get.width / 1.9,
                        child: Text(
                          widget.productName,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(fontSize: 17.5, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Text(
                        "$currencySymbol${widget.productPrice}",
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w800,
                          fontSize: 18.5,
                          color: AppColors.primaryPink,
                        ),
                      ).paddingOnly(top: 8, bottom: 6),
                      /*           SizedBox(
                        width: Get.width / 2,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 13),
                          itemCount: 1,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: widget.attributesArray.keys.map((attributeName) {
                                final attributeValue = widget.attributesArray[attributeName];
                                return Container(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '$attributeName : '.capitalizeFirst,
                                          style: GoogleFonts.plusJakartaSans(
                                              fontWeight: FontWeight.w500,
                                              color: isDark.value ? AppColors.white : AppColors.black),
                                        ),
                                        TextSpan(
                                          text: '$attributeValue'.toUpperCase(),
                                          style: GoogleFonts.plusJakartaSans(
                                              fontWeight: FontWeight.w500, color: AppColors.primaryPink),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ),*/
                      SizedBox(
                        width: Get.width / 2,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 13),
                          itemCount: widget.attributesArray.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final attribute = widget.attributesArray[index];
                            attributesId.add(attribute["_id"].toString());
                            log("message:::::${attribute["name"]}");
                            return attribute["name"] == "Colors"
                                ? Container(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                      Text(
                                        '${attribute["name"]} : '.capitalizeFirst ?? "",
                                        style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w500, fontSize: 16, color: isDark.value ? AppColors.white : AppColors.black),
                                      ),
                                      Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(color: Color(int.parse(attribute["values"].replaceAll("#", "0xFF"))), shape: BoxShape.circle),
                                      )
                                    ]),
                                  )
                                : Container(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '${attribute["name"]} : '.capitalizeFirst,
                                            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w500, color: isDark.value ? AppColors.white : AppColors.black),
                                          ),
                                          TextSpan(
                                            text: '${attribute["values"]}'.toUpperCase(),
                                            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w500, color: AppColors.primaryPink),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

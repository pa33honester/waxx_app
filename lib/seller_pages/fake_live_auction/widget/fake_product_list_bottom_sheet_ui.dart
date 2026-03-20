import 'package:waxxapp/custom/preview_image_widget.dart';
import 'package:waxxapp/seller_pages/fake_live_auction/controller/fake_live_controller.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_asset.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view/fake_product_detail.dart';

class FakeProductListBottomSheet {
  static void show({
    required BuildContext context,
    required SimulatedAuctionController controller,
    String? title,
  }) {
    // Create some dummy products for the fake auction
    final List<SelectedProduct> fakeProducts = [
      SelectedProduct(
        productId: "1",
        productName: "Leather Crossbody Bag",
        price: 1999,
        minimumBidPrice: 999,
        minAuctionTime: 20,
        mainImage: "https://images.unsplash.com/photo-1548036328-c9fa89d128fa",
        images: [
          "https://images.unsplash.com/photo-1548036328-c9fa89d128fa",
          "https://i.etsystatic.com/19476521/r/il/eab70f/3918801745/il_570xN.3918801745_o9xm.jpg",
          "https://i.etsystatic.com/58518780/r/il/5e5933/6840785764/il_fullxfull.6840785764_69fz.jpg",
        ],
        description: "Premium leather crossbody with adjustable strap and magnetic closure. Compact, lightweight, and perfect for daily carry.",
        shippingCharges: 0,
        categoryName: "Fashion",
        isNewCollection: true,
        sellerName: "John",
        sellerBusiness: "CartZone",
        sellerImage: "https://images.unsplash.com/photo-1544005313-94ddf0286df2",
        sellerCity: "Mumbai",
        sellerState: "Maharashtra",
        sellerCountry: "India",
        sold: 42,
        ratingAvg: 4.6,
        ratingCount: 127,
        productAttributes: [
          ProductAttribute(name: "Color", values: ["Tan", "Brown"]),
          ProductAttribute(name: "Material", values: ["Leather"]),
        ],
      ),
      SelectedProduct(
        productId: "2",
        productName: "Analog Wrist Watch",
        price: 2499,
        minimumBidPrice: 1199,
        minAuctionTime: 25,
        mainImage: "https://5.imimg.com/data5/ANDROID/Default/2024/8/447441317/CK/FO/OA/211159205/product-jpeg.jpg",
        images: [
          "https://5.imimg.com/data5/ANDROID/Default/2024/8/447441317/CK/FO/OA/211159205/product-jpeg.jpg",
          "https://m.media-amazon.com/images/I/41P5sLX46fL._UY900_.jpg",
          "https://images.unsplash.com/photo-1523170335258-f5ed11844a49",
        ],
        description: "Classic analog watch with 42mm dial, stainless steel case, and mineral glass. 3 ATM splash resistance.",
        shippingCharges: 99,
        categoryName: "Accessories",
        isNewCollection: true,
        sellerName: "Time & Co.",
        sellerBusiness: "Zencart",
        sellerImage: "https://images.unsplash.com/photo-1547425260-76bcadfb4f2c",
        sellerCity: "Ahmedabad",
        sellerState: "Gujarat",
        sellerCountry: "India",
        sold: 85,
        ratingAvg: 4.3,
        ratingCount: 210,
        productAttributes: [
          ProductAttribute(name: "Color", values: ["Black", "Silver"]),
          ProductAttribute(name: "Dial", values: ["42mm"]),
          ProductAttribute(name: "Strap", values: ["Leather", "Steel"]),
        ],
      ),
      SelectedProduct(
        productId: '3',
        productName: 'Wireless Headphones',
        price: 1999,
        minimumBidPrice: 500,
        minAuctionTime: 45,
        mainImage: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e',
        images: [
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e',
          'https://www.leafstudios.in/cdn/shop/files/1_a43c5e0b-3a47-497d-acec-b4764259b10e_800x.png?v=1750486829',
        ],
        description: "Over-ear Bluetooth headphones with 30-hour battery, deep bass, and passive noise isolation. USB-C fast charging.",
        shippingCharges: 0,
        categoryName: "Electronics",
        isNewCollection: true,
        sellerName: "SoundHub",
        sellerBusiness: "Shopera",
        sellerImage: "https://images.unsplash.com/photo-1527980965255-d3b416303d12",
        sellerCity: "Bengaluru",
        sellerState: "Karnataka",
        sellerCountry: "India",
        sold: 310,
        ratingAvg: 4.5,
        ratingCount: 980,
        productAttributes: [
          ProductAttribute(name: 'Color', values: ['Black', 'Blue']),
          ProductAttribute(name: 'Brand', values: ['Sony']),
        ],
      ),
      SelectedProduct(
        productId: '4',
        productName: 'Smart Watch Series 5',
        price: 8999,
        minimumBidPrice: 2000,
        minAuctionTime: 60,
        mainImage: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30',
        images: [
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30',
          'https://image.made-in-china.com/2f0j00gMfbCtHRJqck/Smart-Watch-5-PRO-Round-Shape-LCD-Screen-Dial-Display-Face-Sports-Smart-Luxury-Touch-Wrist-Watch-Smartwatch-for-Ladies-Women-Men-F8-F10-K65-L66-HS16-Kr66.webp',
        ],
        description: "AMOLED display, heart-rate and SpO₂ monitoring, GPS, 5-day battery, waterproof design, and advanced workout modes.",
        shippingCharges: 149,
        categoryName: "Wearables",
        isNewCollection: false,
        sellerName: "FitTrend",
        sellerBusiness: "Shopsy",
        sellerImage: "https://images.unsplash.com/photo-1542596768-5d1d21f1cf98",
        sellerCity: "Delhi",
        sellerState: "Delhi",
        sellerCountry: "India",
        sold: 190,
        ratingAvg: 4.4,
        ratingCount: 640,
        productAttributes: [
          ProductAttribute(name: 'Size', values: ['42mm', '44mm']),
          ProductAttribute(name: 'Color', values: ['Silver', 'Midnight']),
        ],
      ),
      SelectedProduct(
        productId: '5',
        productName: 'Running Shoes',
        price: 3999,
        minimumBidPrice: 1000,
        minAuctionTime: 30,
        mainImage: 'https://rukminim2.flixcart.com/image/704/844/xif0q/shoe/k/5/s/-original-imah852ukrhqxfk3.jpeg?q=90&crop=false',
        images: [
          'https://rukminim2.flixcart.com/image/704/844/xif0q/shoe/k/5/s/-original-imah852ukrhqxfk3.jpeg?q=90&crop=false',
          'https://media.self.com/photos/682cb217ac8edf4bf1a42da1/3:4/w_748%2Cc_limit/Puma%2520Velocity%2520Nitro%25203%2520A.png',
          'https://rukminim2.flixcart.com/image/292/326/xif0q/shoe/p/u/y/-original-imah9mgem9tx7ufj.jpeg?q=90&crop=false',
        ],
        description: "Lightweight road runners with breathable mesh upper, cushioned midsole, and durable rubber outsole.",
        shippingCharges: 0,
        categoryName: "Footwear",
        isNewCollection: true,
        sellerName: "Stride Sports",
        sellerBusiness: "Shop Nova",
        sellerImage: "https://images.unsplash.com/photo-1544717305-996b815c338c",
        sellerCity: "Pune",
        sellerState: "Maharashtra",
        sellerCountry: "India",
        sold: 520,
        ratingAvg: 4.7,
        ratingCount: 1500,
        productAttributes: [
          ProductAttribute(name: 'Size', values: ['US 8', 'US 9', 'US 10']),
          ProductAttribute(name: 'Color', values: ['Blue', 'White', 'Black']),
        ],
      ),
      SelectedProduct(
        productId: '6',
        productName: 'Leather Wallet',
        price: 1499,
        minimumBidPrice: 500,
        minAuctionTime: 30,
        mainImage: 'https://urbanforest.co.in/cdn/shop/files/A7402041.jpg?v=1733571068',
        images: [
          'https://urbanforest.co.in/cdn/shop/files/A7402041.jpg?v=1733571068',
          'https://redhorns.in/cdn/shop/files/720NW_F_4.jpg?v=1705145431&width=3000',
        ],
        description: "Slim bi-fold wallet made from genuine leather with RFID protection and 6 card slots.",
        shippingCharges: 49,
        categoryName: "Accessories",
        isNewCollection: true,
        sellerName: "Craft & Hide",
        sellerBusiness: "Smart marts",
        sellerImage: "https://images.unsplash.com/photo-1548142813-c348350df52b",
        sellerCity: "Jaipur",
        sellerState: "Rajasthan",
        sellerCountry: "India",
        sold: 260,
        ratingAvg: 4.2,
        ratingCount: 350,
        productAttributes: [
          ProductAttribute(name: 'Material', values: ['Genuine Leather']),
          ProductAttribute(name: 'Color', values: ['Brown', 'Black']),
        ],
      ),
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      builder: (context) => Container(
        height: Get.height * 0.70,
        decoration: BoxDecoration(
          color: AppColors.black,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(40),
          ),
        ),
        child: Column(
          children: [
            10.height,
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      10.height,
                      Text(
                        title ?? "Available Products",
                        style: AppFontStyle.styleW700(AppColors.white, 16),
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        AppAsset.icClose,
                        height: 16,
                        color: AppColors.unselected,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 1,
              color: AppColors.unselected.withValues(alpha: 0.5),
            ),
            Expanded(
              child: fakeProducts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_bag_outlined,
                            size: 64,
                            color: AppColors.coloGreyText,
                          ),
                          16.height,
                          Text(
                            St.txtNoProductFound.tr,
                            style: AppFontStyle.styleW600(
                              AppColors.coloGreyText,
                              16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      child: ListView.builder(
                        itemCount: fakeProducts.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(
                          top: 20,
                          left: 16,
                          right: 16,
                          bottom: 20,
                        ),
                        itemBuilder: (context, index) {
                          final data = fakeProducts[index];
                          return GestureDetector(
                            onTap: () {
                              Get.to(() => FakeProductDetail(product: data));
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.unselected.withValues(alpha: 0.2),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(16),
                                ),
                              ),
                              child: FakeProductUi(
                                selectedProduct: data,
                                controller: controller,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class FakeProductUi extends StatelessWidget {
  const FakeProductUi({
    super.key,
    required this.selectedProduct,
    required this.controller,
  });

  final SelectedProduct selectedProduct;
  final SimulatedAuctionController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PreviewImageWidget(
          height: 70,
          width: 70,
          fit: BoxFit.cover,
          image: selectedProduct.mainImage ?? "",
          radius: 12,
          errorWidget: Padding(
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              AppAsset.categoryPlaceholder,
            ),
          ),
        ),
        12.width,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                selectedProduct.productName ?? "Product Name",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppFontStyle.styleW700(AppColors.white, 16),
              ),
              Text(
                "$currencySymbol ${selectedProduct.price ?? 0}",
                style: AppFontStyle.styleW900(AppColors.primary, 16),
              ),
              if (selectedProduct.productAttributes != null && selectedProduct.productAttributes!.isNotEmpty) ...[
                Column(
                  children: selectedProduct.productAttributes!
                      .take(1)
                      .map((attribute) => Row(
                            children: [
                              Text(
                                "${attribute.name} : ",
                                style: AppFontStyle.styleW500(AppColors.white, 12),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColors.unselected.withValues(alpha: 0.3),
                                    width: 1,
                                  ),
                                  color: AppColors.unselected.withValues(alpha: 0.3),
                                ),
                                child: Text(
                                  attribute.values.join(", "),
                                  style: AppFontStyle.styleW500(AppColors.white, 12),
                                ),
                              )
                            ],
                          ))
                      .toList(),
                ),
              ],

              // Select Product Button for Host
              if (controller.liveType != 2) ...{
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 32,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.liveSelectedProducts = [selectedProduct];
                      controller.currentIndex = 0;
                      controller.startCurrentProductAuction();
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    child: Text(
                      "BUY NOW",
                      style: AppFontStyle.styleW700(AppColors.black, 12),
                    ),
                  ),
                ),
              }
            ],
          ),
        ),
      ],
    );
  }
}

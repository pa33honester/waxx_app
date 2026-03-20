// import 'dart:io';
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:waxxapp/Controller/GetxController/user/user_product_details_controller.dart';
// import 'package:waxxapp/custom/main_button_widget.dart';
// import 'package:waxxapp/utils/Strings/strings.dart';
// import 'package:waxxapp/utils/app_asset.dart';
// import 'package:waxxapp/utils/app_colors.dart';
// import 'package:waxxapp/utils/app_constant.dart';
// import 'package:waxxapp/utils/font_style.dart';
// import 'package:waxxapp/utils/globle_veriables.dart';
// import 'package:waxxapp/utils/utils.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shimmer/shimmer.dart';
//
// class ProductDetailNew extends StatelessWidget {
//   ProductDetailNew({super.key});
//
//   UserProductDetailsController userProductDetailsController = Get.put(UserProductDetailsController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
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
//                           color: AppColors.white.withValues(alpha: 0.07),
//                           shape: BoxShape.circle,
//                         ),
//                         child: Image.asset(AppAsset.icBack, width: 15),
//                       ),
//                     ),
//                     16.width,
//                     Expanded(
//                       child: Text(
//                         St.productDetails.tr,
//                         style: AppFontStyle.styleW900(AppColors.white, 18),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           actions: [
//             Row(
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     // onClickShare();
//                   },
//                   child: Container(
//                     padding: EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: AppColors.white.withValues(alpha: 0.07),
//                       shape: BoxShape.circle,
//                     ),
//                     child: Image.asset(
//                       AppAsset.icShare,
//                       // width: 18,
//                       height: 18,
//                       color: AppColors.unselected,
//                     ),
//                   ),
//                 ),
//                 16.width,
//               ],
//             ),
//           ],
//         ),
//       ),
//       body: Obx(() {
//         if (userProductDetailsController.isLoading.value) {
//           return ProductDetailShimmer.productDetailShimmer();
//         }
//         return GetBuilder<UserProductDetailsController>(
//           id: AppConstant.idSelectImage,
//           builder: (controller) {
//             final product = controller.userProductDetails?.product?.first;
//             return Padding(
//               padding: const EdgeInsets.all(16),
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     if (controller.imageList.isNotEmpty)
//                       Container(
//                         height: 300,
//                         width: Get.width,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: CachedNetworkImage(
//                           imageUrl: controller.imageList[controller.selectedImageIndex.value],
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     20.height,
//                     if (controller.imageList.isNotEmpty)
//                       SizedBox(
//                         height: 80,
//                         child: ListView.builder(
//                           scrollDirection: Axis.horizontal,
//                           itemCount: controller.imageList.length,
//                           itemBuilder: (context, index) {
//                             return GestureDetector(
//                               onTap: () {
//                                 controller.onSelectImage(index);
//                               },
//                               child: Container(
//                                 width: 80,
//                                 height: 80,
//                                 margin: const EdgeInsets.only(right: 6),
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(8),
//                                   border: Border.all(
//                                     color: controller.selectedImageIndex.value == index ? AppColors.primary : Colors.transparent,
//                                     width: 2,
//                                   ),
//                                 ),
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(2),
//                                   child: ClipRRect(
//                                     borderRadius: BorderRadius.circular(6),
//                                     child: CachedNetworkImage(
//                                       imageUrl: controller.imageList[index],
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     30.height,
//                     Text(
//                       product?.productName ?? '',
//                       style: AppFontStyle.styleW800(AppColors.white, 20),
//                     ),
//                     10.height,
//                     Row(
//                       children: [
//                         Text(
//                           "\$${product?.price}",
//                           style: TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.w800,
//                             color: AppColors.white,
//                             decoration: TextDecoration.lineThrough,
//                             decorationColor: Colors.white,
//                           ),
//                         ),
//                         10.width,
//                         Text(
//                           "\$${product?.price}",
//                           style: AppFontStyle.styleW600(AppColors.primary, 13),
//                         ),
//                       ],
//                     ),
//                     30.height,
//                     Text(
//                       St.aboutThisItem.tr,
//                       style: AppFontStyle.styleW700(AppColors.white, 16),
//                     ),
//                     20.height,
//                     Row(
//                       children: [
//                         Expanded(
//                           flex: 2,
//                           child: Text(
//                             St.category.tr,
//                             style: AppFontStyle.styleW500(AppColors.unselected, 14),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 3,
//                           child: Text(
//                             'Fashion & Apparel',
//                             style: AppFontStyle.styleW600(AppColors.white, 14),
//                           ),
//                         ),
//                       ],
//                     ),
//                     10.height,
//                     Row(
//                       children: [
//                         Expanded(
//                           flex: 2,
//                           child: Text(
//                             St.subCategory.tr,
//                             style: AppFontStyle.styleW500(AppColors.unselected, 14),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 3,
//                           child: Text(
//                             "Men's Clothing",
//                             style: AppFontStyle.styleW600(AppColors.white, 14),
//                           ),
//                         ),
//                       ],
//                     ),
//                     30.height,
//                     Text(
//                       St.itemSpecific.tr,
//                       style: AppFontStyle.styleW700(AppColors.white, 16),
//                     ),
//                     20.height,
//                     ...controller.displayAttributes.map((attr) {
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 12),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               flex: 2,
//                               child: Text(
//                                 attr.name,
//                                 style: AppFontStyle.styleW500(AppColors.unselected, 12),
//                               ),
//                             ),
//                             30.width,
//                             Expanded(
//                               flex: 3,
//                               child: Text(
//                                 attr.value,
//                                 style: AppFontStyle.styleW600(AppColors.white, 13),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }).toList(),
//                     30.height,
//                     Text(
//                       St.itemDescriptionFromTheSeller.tr,
//                       style: AppFontStyle.styleW700(AppColors.white, 16),
//                     ),
//                     20.height,
//                     Text(
//                       product?.description ?? '',
//                       style: AppFontStyle.styleW500(AppColors.unselected, 14),
//                     ),
//                     30.height,
//                     Text(
//                       St.aboutThisSeller.tr,
//                       style: AppFontStyle.styleW700(AppColors.white, 16),
//                     ),
//                     20.height,
//                     Row(
//                       children: [
//                         Container(
//                           height: 52,
//                           width: 52,
//                           clipBehavior: Clip.antiAlias,
//                           decoration: BoxDecoration(shape: BoxShape.circle),
//                           child: imageXFile == null
//                               ? CachedNetworkImage(
//                                   imageUrl: editImage,
//                                   placeholder: (context, url) => Image.asset(AppAsset.profilePlaceholder),
//                                   errorWidget: (context, url, error) => Image.asset(AppAsset.profilePlaceholder),
//                                 )
//                               : Image.file(File(imageXFile?.path ?? '')),
//                         ),
//                         16.width,
//                         Text(
//                           'jems_bond',
//                           style: AppFontStyle.styleW700(AppColors.white, 16),
//                         ),
//                       ],
//                     ),
//                     30.height,
//                     MainButtonWidget(
//                       height: 60,
//                       callback: () {
//                         // Add to cart logic
//                       },
//                       border: Border.all(color: AppColors.primary),
//                       color: Colors.transparent,
//                       child: Text(
//                         St.addToCart.tr,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 1,
//                         style: AppFontStyle.styleW700(AppColors.primary, 15),
//                       ),
//                     ),
//                     20.height,
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       }),
//     );
//   }
// }
//
// class ProductDetailShimmer {
//   static Widget productDetailShimmer() {
//     return Shimmer.fromColors(
//       baseColor: AppColors.darkGrey.withValues(alpha: 0.15),
//       highlightColor: AppColors.lightGrey.withValues(alpha: 0.15),
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               height: 300,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.grey,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             20.height,
//
//             // Thumbnail placeholders
//             SizedBox(
//               height: 80,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: 3,
//                 itemBuilder: (context, index) {
//                   return Container(
//                     width: 80,
//                     height: 80,
//                     margin: const EdgeInsets.only(right: 6),
//                     decoration: BoxDecoration(
//                       color: Colors.grey,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             30.height,
//             Container(
//               width: double.infinity,
//               height: 24,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: Colors.grey,
//               ),
//             ),
//             16.height,
//             Row(
//               children: [
//                 Container(
//                   width: 100,
//                   height: 24,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: Colors.grey,
//                   ),
//                 ),
//                 10.width,
//                 Container(
//                   width: 70,
//                   height: 18,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//             30.height,
//             Container(
//               width: 150,
//               height: 18,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: Colors.grey,
//               ),
//             ),
//             20.height,
//             _buildShimmerRow(),
//             10.height,
//             _buildShimmerRow(),
//             30.height,
//
//             // Section title
//             Container(
//               width: 150,
//               height: 18,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: Colors.grey,
//               ),
//             ),
//             20.height,
//
//             // Item specifics
//             _buildShimmerAttribute(),
//             _buildShimmerAttribute(),
//             30.height,
//
//             // Section title
//             Container(
//               width: 200,
//               height: 18,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: Colors.grey,
//               ),
//             ),
//             20.height,
//
//             // Description
//             Container(
//               width: double.infinity,
//               height: 14,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: Colors.grey,
//               ),
//             ),
//             8.height,
//             Container(
//               width: double.infinity,
//               height: 14,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: Colors.grey,
//               ),
//             ),
//             8.height,
//             Container(
//               width: 200,
//               height: 14,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: Colors.grey,
//               ),
//             ),
//             30.height,
//
//             // Section title
//             Container(
//               width: 150,
//               height: 18,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: Colors.grey,
//               ),
//             ),
//             20.height,
//
//             // Seller info
//             Row(
//               children: [
//                 Container(
//                   width: 52,
//                   height: 52,
//                   decoration: const BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.grey,
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Container(
//                   width: 100,
//                   height: 18,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//             20.height,
//
//             // Add to cart button
//             Container(
//               height: 52,
//               decoration: BoxDecoration(
//                 color: Colors.grey,
//                 borderRadius: BorderRadius.circular(30),
//               ),
//             ),
//             20.height,
//           ],
//         ),
//       ),
//     );
//   }
//
//   static Widget _buildShimmerRow() {
//     return Row(
//       children: [
//         Expanded(
//           flex: 2,
//           child: Container(
//             height: 14,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               color: Colors.grey,
//             ),
//           ),
//         ),
//         30.width,
//         Expanded(
//           flex: 3,
//           child: Container(
//             height: 14,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               color: Colors.grey,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   static Widget _buildShimmerAttribute() {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             flex: 2,
//             child: Container(
//               height: 12,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: Colors.grey,
//               ),
//             ),
//           ),
//           const SizedBox(width: 30),
//           Expanded(
//             flex: 3,
//             child: Container(
//               height: 12,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: Colors.grey,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

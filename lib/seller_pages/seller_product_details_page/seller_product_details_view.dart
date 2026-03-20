import 'dart:developer';

import 'package:waxxapp/Controller/GetxController/seller/delete_catalog_controller.dart';
import 'package:waxxapp/Controller/GetxController/seller/seller_product_detail_controller.dart';
import 'package:waxxapp/custom/preview_image_widget.dart';
import 'package:waxxapp/custom/simple_app_bar_widget.dart';
import 'package:waxxapp/utils/CoustomWidget/App_theme_services/primary_buttons.dart';
import 'package:waxxapp/utils/CoustomWidget/App_theme_services/text_titles.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/shimmers.dart';
import 'package:waxxapp/utils/show_toast.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../utils/all_images.dart';

class SellerProductDetailsView extends StatefulWidget {
  const SellerProductDetailsView({super.key});

  @override
  State<SellerProductDetailsView> createState() => _SellerProductDetailsViewState();
}

class _SellerProductDetailsViewState extends State<SellerProductDetailsView> {
  SellerProductDetailsController sellerProductDetailsController = Get.put(SellerProductDetailsController());
  DeleteCatalogController deleteCatalogController = Get.put(DeleteCatalogController());

  final productController = PageController();
  int click = 0;
  int click1 = 0;

  @override
  void initState() {
    // TODO: implement initState
    // sellerProductDetailsController.selectedSize.clear();
    sellerProductDetailsController.getProductDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.transparent,
          surfaceTintColor: AppColors.transparent,
          flexibleSpace: SimpleAppBarWidget(title: St.productDetails.tr),
          actions: [
            GestureDetector(
              onTap: () {
                if (isUpdateProductRequest == true) {
                  if ((sellerProductDetailsController.sellerProductDetails!.product![0].createStatus == "Pending") || (sellerProductDetailsController.sellerProductDetails!.product![0].updateStatus == "Pending")) {
                    displayToast(message: St.yourProductIsInPendingMode.tr);
                  } else if ((sellerProductDetailsController.sellerProductDetails!.product![0].createStatus == "Rejected") || (sellerProductDetailsController.sellerProductDetails!.product![0].updateStatus == "Rejected")) {
                    displayToast(message: St.oppsYourProductHasBeenRejected.tr);
                  } else {
                    Get.toNamed("/ListingSummary", arguments: true)?.then((value) {
                      if (value != null) {
                        sellerProductDetailsController.getProductDetails();
                      }
                    });
                  }
                } else {
                  Get.toNamed("/ListingSummary", arguments: true)?.then((value) {
                    if (value != null) {
                      log("Then Called");
                      sellerProductDetailsController.getProductDetails();
                      // Perform any actions or update data if necessary
                    }
                  });
                }
              },
              child: Icon(
                Icons.mode_edit_outline_outlined,
                color: AppColors.white,
              ),
            ).paddingOnly(right: 16),
          ],
        ),
      ),
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Obx(
          () => sellerProductDetailsController.isLoading.value
              ? Shimmers.productDetailsShimmer()
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 15),
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
                                          itemCount: sellerProductDetailsController.sellerProductDetails!.product![0].images?.length,
                                          onPageChanged: (value) {},
                                          itemBuilder: (context, index) {
                                            final indexData = sellerProductDetailsController.sellerProductDetails!.product![0].images?[index];
                                            return Container(
                                              height: 420,
                                              width: Get.width,
                                              child: PreviewImageWidget(
                                                height: 420,
                                                width: Get.width,
                                                fit: BoxFit.cover,
                                                defaultHeight: 150,
                                                image: sellerProductDetailsController.sellerProductDetails!.product![0].images![index].toString(),
                                              ),
                                            );
                                          },
                                        ),
                                        Positioned(
                                          bottom: 15,
                                          child: SmoothPageIndicator(
                                            effect: ExpandingDotsEffect(dotHeight: 8, dotWidth: 8, dotColor: Colors.grey.shade400, activeDotColor: AppColors.primaryPink),
                                            controller: productController,
                                            count: sellerProductDetailsController.sellerProductDetails!.product![0].images!.length,
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
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              sellerProductDetailsController.sellerProductDetails?.product?[0].productName.toString() ?? '',
                                              overflow: TextOverflow.ellipsis,
                                              style: AppFontStyle.styleW700(AppColors.white, 20),
                                            ),
                                            Obx(() {
                                              final description = sellerProductDetailsController.sellerProductDetails?.product?[0].description.toString() ?? '';
                                              return Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          description,
                                                          maxLines: sellerProductDetailsController.isDescriptionExpanded.value ? null : 2,
                                                          overflow: sellerProductDetailsController.isDescriptionExpanded.value ? TextOverflow.clip : TextOverflow.ellipsis,
                                                          style: AppFontStyle.styleW500(AppColors.unselected, 14),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () => sellerProductDetailsController.toggleDescription(),
                                                        child: Text(
                                                          sellerProductDetailsController.isDescriptionExpanded.value ? St.less.tr : St.more.tr,
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
                                              );
                                            }),
                                          ],
                                        ),
                                        5.height,
                                        sellerProductDetailsController.sellerProductDetails?.product?[0].recipientAddress != null || sellerProductDetailsController.sellerProductDetails!.product![0].recipientAddress!.isNotEmpty
                                            ? Row(
                                                children: [
                                                  Image(
                                                    color: AppColors.unselected,
                                                    image: AssetImage(AppImage.location),
                                                    height: 15,
                                                  ),
                                                  5.width,
                                                  Expanded(
                                                    child: Text(
                                                      sellerProductDetailsController.sellerProductDetails!.product![0].recipientAddress ?? '',
                                                      style: AppFontStyle.styleW500(AppColors.unselected, 12),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Offstage(),
                                        5.height,
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "$currencySymbol ${sellerProductDetailsController.sellerProductDetails?.product?[0].enableAuction == true ? sellerProductDetailsController.sellerProductDetails!.product![0].auctionStartingPrice.toString() : sellerProductDetailsController.sellerProductDetails!.product![0].price.toString()}",
                                              overflow: TextOverflow.ellipsis,
                                              style: AppFontStyle.styleW900(AppColors.primary, 20),
                                            ),
                                            // Spacer(),
                                            // (sellerProductDetailsController.sellerProductDetails?.product?[0].shippingCharges == 0)
                                            //     ? Container(
                                            //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                            //         decoration: BoxDecoration(
                                            //           borderRadius: BorderRadius.circular(50),
                                            //           color: AppColors.primary,
                                            //         ),
                                            //         child: Row(
                                            //           children: [
                                            //             Image.asset(AppAsset.icFreeDelivery, width: 20),
                                            //             5.width,
                                            //             Text(
                                            //               "FREE SHIPPING",
                                            //               style: AppFontStyle.styleW700(AppColors.black, 12),
                                            //             ),
                                            //           ],
                                            //         ),
                                            //       )
                                            //     : Container(
                                            //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                            //         decoration: BoxDecoration(
                                            //           borderRadius: BorderRadius.circular(50),
                                            //           color: AppColors.primary,
                                            //         ),
                                            //         child: Row(
                                            //           children: [
                                            //             Text(
                                            //               "${St.deliveryCharge.tr} : $currencySymbol${sellerProductDetailsController.sellerProductDetails!.product![0].shippingCharges.toString()}",
                                            //               style: AppFontStyle.styleW700(AppColors.black, 12),
                                            //             ),
                                            //           ],
                                            //         ),
                                            //       ),
                                          ],
                                        ),
                                        5.height,
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            25.height,
                            ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: sellerProductDetailsController.sellerProductDetails!.product![0].attributes!.length,
                              itemBuilder: (context, index) {
                                final attribute = sellerProductDetailsController.sellerProductDetails!.product![0].attributes![index];
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GeneralTitle(
                                      title: '${St.product.tr} ${attribute.name.toString().capitalizeFirst ?? "Unknown Key"}',
                                    ).paddingOnly(bottom: 5),
                                    10.height,
                                    Row(
                                      children: [
                                        for (int i = 0; i < sellerProductDetailsController.sellerProductDetails!.product![0].attributes![index].values!.length; i++)
                                          Container(
                                            height: Get.width * 0.11,
                                            decoration: BoxDecoration(
                                              color: AppColors.tabBackground,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            width: Get.width * 0.14,
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            margin: const EdgeInsets.only(right: 10),
                                            child: Center(
                                              child: FittedBox(
                                                child: Text(
                                                  sellerProductDetailsController.sellerProductDetails?.product?[0].attributes?[index].values?[i] ?? "",
                                                  overflow: TextOverflow.ellipsis,
                                                  style: AppFontStyle.styleW600(AppColors.unselected, 13),
                                                ),
                                              ),
                                            ),
                                          ).paddingOnly(bottom: 16),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                            15.height,
                            GeneralTitle(
                              title: St.productDetails.tr,
                            ),
                            15.height,
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      St.product.tr,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppFontStyle.styleW400(AppColors.unselected, 14),
                                    ),
                                    Text(
                                      St.category.tr,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppFontStyle.styleW400(AppColors.unselected, 14),
                                    ).paddingSymmetric(vertical: 10),
                                    Text(
                                      St.availability.tr,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppFontStyle.styleW400(AppColors.unselected, 14),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      sellerProductDetailsController.sellerProductDetails!.product![0].isNewCollection == true ? St.newCollection.tr : St.trendingCollection.tr,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppFontStyle.styleW600(AppColors.primaryPink, 14),
                                    ),
                                    Text(
                                      sellerProductDetailsController.sellerProductDetails!.product![0].category!.name.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: AppFontStyle.styleW600(AppColors.primaryPink, 14),
                                    ).paddingSymmetric(vertical: 10),
                                    Text(
                                      sellerProductDetailsController.sellerProductDetails!.product![0].isOutOfStock == true ? St.outOfStock.tr : St.inStock.tr,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppFontStyle.styleW600(AppColors.primaryPink, 14),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                              ],
                            ),
                            15.height,
                            GeneralTitle(
                              title: St.description.tr,
                            ),
                            10.height,
                            SizedBox(
                              child: Text(
                                sellerProductDetailsController.sellerProductDetails!.product![0].description.toString(),
                                style: AppFontStyle.styleW400(AppColors.unselected, 14),
                              ),
                            ),
                            20.height,
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: PrimaryPinkButton(
                                  onTaped: isDemoSeller == true
                                      ? () => displayToast(message: St.thisIsDemoUser.tr)
                                      : () {
                                          if (isUpdateProductRequest == true) {
                                            if ((sellerProductDetailsController.sellerProductDetails!.product![0].createStatus == "Pending") || (sellerProductDetailsController.sellerProductDetails!.product![0].updateStatus == "Pending")) {
                                              displayToast(message: St.yourProductIsInPendingMode.tr);
                                            } else if ((sellerProductDetailsController.sellerProductDetails!.product![0].createStatus == "Rejected") || (sellerProductDetailsController.sellerProductDetails!.product![0].updateStatus == "Rejected")) {
                                              displayToast(message: St.oppsYourProductHasBeenRejected.tr);
                                            } else {
                                              Get.toNamed("/ListingSummary", arguments: true)?.then((value) {
                                                if (value != null) {
                                                  sellerProductDetailsController.getProductDetails();
                                                }
                                              });
                                            }
                                          } else {
                                            Get.toNamed("/ListingSummary", arguments: true)?.then((value) {
                                              if (value != null) {
                                                log("Then Called");
                                                sellerProductDetailsController.getProductDetails();
                                                // Perform any actions or update data if necessary
                                              }
                                            });
                                          }
                                        },
                                  text: St.editDetails.tr),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(horizontal: 15),
                            //   child: PrimaryWhiteButton(
                            //       onTaped: isDemoSeller == true
                            //           ? () => displayToast(message: St.thisIsDemoApp.tr)
                            //           : () {
                            //               Get.defaultDialog(
                            //                 backgroundColor: isDark.value ? AppColors.blackBackground : AppColors.white,
                            //                 title: St.doYouReallyWantToRemoveThisProduct.tr,
                            //                 titlePadding: const EdgeInsets.only(top: 45, left: 20, right: 20),
                            //                 titleStyle: GoogleFonts.plusJakartaSans(
                            //                     color: isDark.value ? AppColors.white : AppColors.black,
                            //                     height: 1.4,
                            //                     fontSize: 18,
                            //                     fontWeight: FontWeight.w600),
                            //                 content: Column(
                            //                   children: [
                            //                     SizedBox(
                            //                       height: Get.height / 30,
                            //                     ),
                            //                     Padding(
                            //                       padding: const EdgeInsets.symmetric(horizontal: 30),
                            //                       child: PrimaryPinkButton(
                            //                           onTaped: () {
                            //                             Get.back();
                            //                           },
                            //                           text: St.cancelSmallText.tr),
                            //                     ),
                            //                     Padding(
                            //                       padding: const EdgeInsets.only(top: 20, bottom: 10),
                            //                       child: GestureDetector(
                            //                         onTap: () {
                            //                           deleteCatalogController.getDeleteData();
                            //                           Get.back();
                            //                           // Get.offNamed("/SellerCatalogScreen");
                            //                         },
                            //                         child: Text(
                            //                           St.remove.tr,
                            //                           style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.red),
                            //                         ),
                            //                       ),
                            //                     ),
                            //                   ],
                            //                 ),
                            //               );
                            //             },
                            //       text: St.removeCatalog),
                            // ),
                            // MainButtonWidget(
                            //     height: 55,
                            //     width: Get.width,
                            //     // margin: const EdgeInsets.symmetric(horizontal: 15),
                            //     color: AppColors.primary,
                            //     callback: isDemoSeller == true
                            //         ? () => displayToast(message: St.thisIsDemoApp.tr)
                            //         : () {
                            //             if (isUpdateProductRequest == true) {
                            //               if ((sellerProductDetailsController.sellerProductDetails!.product![0].createStatus == "Pending") || (sellerProductDetailsController.sellerProductDetails!.product![0].updateStatus == "Pending")) {
                            //                 displayToast(message: St.yourProductIsInPendingMode.tr);
                            //               } else if ((sellerProductDetailsController.sellerProductDetails!.product![0].createStatus == "Rejected") || (sellerProductDetailsController.sellerProductDetails!.product![0].updateStatus == "Rejected")) {
                            //                 displayToast(message: St.oppsYourProductHasBeenRejected.tr);
                            //               } else {
                            //                 Get.toNamed("/ListingSummary", arguments: true)?.then((value) {
                            //                   if (value != null) {
                            //                     sellerProductDetailsController.getProductDetails();
                            //                   }
                            //                 });
                            //               }
                            //             } else {
                            //               Get.toNamed("/ListingSummary", arguments: true)?.then((value) {
                            //                 if (value != null) {
                            //                   log("Then Called");
                            //                   sellerProductDetailsController.getProductDetails();
                            //                   // Perform any actions or update data if necessary
                            //                 }
                            //               });
                            //             }
                            //           },
                            //     child: Text(
                            //       St.editDetails.tr.toUpperCase(),
                            //       style: AppFontStyle.styleW700(AppColors.black, 16),
                            //     )),
                            // const SizedBox(height: 15),
                            // MainButtonWidget(
                            //   height: 55,
                            //   width: Get.width,
                            //   color: AppColors.red,
                            //   child: Text(
                            //     St.removeCatalog.tr.toUpperCase(),
                            //     style: AppFontStyle.styleW700(AppColors.white, 16),
                            //   ),
                            //   callback: () {
                            //     isDemoSeller == true
                            //         ? displayToast(message: St.thisIsDemoApp.tr)
                            //         : Get.defaultDialog(
                            //             backgroundColor: isDark.value ? AppColors.blackBackground : AppColors.white,
                            //             title: St.doYouReallyWantToRemoveThisProduct.tr,
                            //             titlePadding: const EdgeInsets.only(top: 45, left: 20, right: 20),
                            //             titleStyle: GoogleFonts.plusJakartaSans(color: isDark.value ? AppColors.white : AppColors.black, height: 1.4, fontSize: 18, fontWeight: FontWeight.w600),
                            //             content: Column(
                            //               children: [
                            //                 SizedBox(
                            //                   height: Get.height / 30,
                            //                 ),
                            //                 Padding(
                            //                   padding: const EdgeInsets.symmetric(horizontal: 30),
                            //                   child: PrimaryPinkButton(
                            //                       onTaped: () {
                            //                         Get.back();
                            //                       },
                            //                       text: St.cancelSmallText.tr),
                            //                 ),
                            //                 Padding(
                            //                   padding: const EdgeInsets.only(top: 20, bottom: 10),
                            //                   child: GestureDetector(
                            //                     onTap: () {
                            //                       deleteCatalogController.getDeleteData();
                            //                       Get.back();
                            //                       // Get.offNamed("/SellerCatalogScreen");
                            //                     },
                            //                     child: Text(
                            //                       St.remove.tr,
                            //                       style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.red),
                            //                     ),
                            //                   ),
                            //                 ),
                            //               ],
                            //             ),
                            //           );
                            //   },
                            // ),
                          ],
                        ),
                      ),
                      // Align(
                      //   alignment: Alignment.topRight,
                      //   child: Padding(
                      //       padding: EdgeInsets.only(top: Get.height / 8.5, right: 8),
                      //       child: SizedBox(
                      //         width: 80,
                      //         height: 240,
                      //         child: ListView.builder(
                      //           physics: const BouncingScrollPhysics(),
                      //           itemCount: sellerProductDetailsController.sellerProductDetails!.product![0].images?.length,
                      //           itemBuilder: (context, index) {
                      //             // attributes =  sellerProductDetailsController.sellerProductDetails!.product![0].attributes![index];
                      //             return Padding(
                      //               padding: const EdgeInsets.all(8.0),
                      //               child: GestureDetector(
                      //                 onTap: () {
                      //                   setState(() {});
                      //                   click = index;
                      //                   productController.jumpToPage(index);
                      //                 },
                      //                 child: Column(
                      //                   children: [
                      //                     Container(
                      //                       height: 65,
                      //                       width: 65,
                      //                       decoration: BoxDecoration(
                      //                           border: Border.all(
                      //                               width: 2,
                      //                               color: click1 == index ? AppColors.primaryPink : Colors.transparent),
                      //                           borderRadius: BorderRadius.circular(12)),
                      //                       child: ClipRRect(
                      //                         borderRadius: BorderRadius.circular(10),
                      //                         child: CachedNetworkImage(
                      //                           height: 65,
                      //                           width: 65,
                      //                           fit: BoxFit.cover,
                      //                           imageUrl: sellerProductDetailsController
                      //                               .sellerProductDetails!.product![0].images![index],
                      //                           placeholder: (context, url) => const Center(
                      //                               child: CupertinoActivityIndicator(
                      //                             radius: 7,
                      //                             animating: true,
                      //                           )),
                      //                           errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                      //                         ),
                      //                       ),
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ),
                      //             );
                      //           },
                      //         ),
                      //       )),
                      // ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

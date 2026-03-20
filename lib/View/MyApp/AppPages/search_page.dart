// ignore_for_file: must_be_immutable
import 'package:waxxapp/custom/custom_color_bg_widget.dart';
import 'package:waxxapp/custom/preview_image_widget.dart';
import 'package:waxxapp/utils/CoustomWidget/App_theme_services/text_titles.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/all_images.dart';
import 'package:waxxapp/utils/app_asset.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/app_constant.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/shimmers.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Controller/GetxController/user/previous_search_product_controller.dart';
import '../../../Controller/GetxController/user/user_search_product_controller.dart';
import '../../../utils/CoustomWidget/Page_devided/filter_bottem_shit.dart';
import '../../../utils/globle_veriables.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  UserSearchProductController userSearchProductController = Get.put(UserSearchProductController());
  PreviousSearchController previousSearchController = Get.put(PreviousSearchController());

  final TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  bool isLoading = true;

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      FocusScope.of(context).requestFocus(_focusNode);
    }
  }

  void searchProducts() async {
    final String searchTerm = searchController.text;
    if (searchTerm.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await userSearchProductController.userSearchProductDetailsData(productName: searchTerm);
      setState(() {
        userSearchProductController.isLoading.value = false;
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomColorBgWidget(
      child: Scaffold(
        backgroundColor: AppColors.black,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.transparent,
            shadowColor: AppColors.black.withValues(alpha: 0.4),
            surfaceTintColor: AppColors.transparent,
            flexibleSpace: SearchAppBarWidget(
              controller: searchController,
              callback: () => Get.bottomSheet(
                isScrollControlled: true,
                const FilterBottomShirt(),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                15.height,
                Text(
                  "Last Seen",
                  style: AppFontStyle.styleW700(AppColors.white, 18),
                ),
                15.height,
                SizedBox(
                  height: 130,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 10,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return PreviewImageWidget(
                          height: 130,
                          width: 110,
                          radius: 15,
                          color: AppColors.transparent,
                          fit: BoxFit.cover,
                          margin: const EdgeInsets.only(right: 15),
                          image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRTZ7bsRaWHA9BmrqLFBkdbK6OczzmbIncpzA&s",
                        );
                      },
                    ),
                  ),
                ),
                15.height,
                Text(
                  "Last Seen",
                  style: AppFontStyle.styleW700(AppColors.white, 18),
                ),
                5.height,

                ListView.builder(
                  shrinkWrap: true,
                  itemCount: 5,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return SearchHistoryItemWidget(
                      title: "Modern clothes",
                      callback: () {},
                      onClose: () {},
                    );
                  },
                ),
                5.height,
                Text(
                  St.popularSearch.tr,
                  style: AppFontStyle.styleW700(AppColors.white, 18),
                ),

                ListView.builder(
                  shrinkWrap: true,
                  itemCount: userSearchProductController.userSearchProductModel?.products?.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    final indexData = userSearchProductController.userSearchProductModel?.products?[index];
                    return Container(
                      height: 120,
                      width: Get.width,
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: AppColors.tabBackground,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          1.width,
                          PreviewImageWidget(
                            height: 110,
                            width: 110,
                            fit: BoxFit.cover,
                            image: indexData?.images?[0],
                            radius: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 13, color: AppColors.white, fontFamily: AppConstant.appFontRegular, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Kendow Premium T-shirt Most Popular",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize: 12, fontFamily: AppConstant.appFontRegular, color: AppColors.unselected, fontWeight: FontWeight.w500),
                                ),
                                5.height,
                                Text(
                                  "$currencySymbol ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900, fontFamily: AppConstant.appFontRegular, fontSize: 14, color: AppColors.primary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                // Padding(
                //   padding: EdgeInsets.symmetric(vertical: Get.height / 35, horizontal: 15),
                //   child: SizedBox(
                //     height: 56,
                //     child: Obx(
                //       () => TextFormField(
                //         textInputAction: TextInputAction.search,
                //         // keyboardType: TextInputType.none,
                //         focusNode: _focusNode,
                //         autofocus: true,
                //         onFieldSubmitted: (value) {
                //           searchProducts();
                //         },
                //         controller: searchController,
                //         style: TextStyle(color: isDark.value ? AppColors.dullWhite : AppColors.black),
                //         decoration: InputDecoration(
                //             filled: true,
                //             suffixIcon: Padding(
                //               padding: const EdgeInsets.all(17),
                //               child: GestureDetector(
                //                 onTap: () {
                //                   Get.bottomSheet(
                //                     isScrollControlled: true,
                //                     const FilterBottomShirt(),
                //                   );
                //                 },
                //                 child: Container(
                //                   height: 100,
                //                   width: 40,
                //                   color: Colors.transparent,
                //                   child: Padding(
                //                     padding: const EdgeInsets.all(3.5),
                //                     child: Image(
                //                       image: AssetImage(AppImage.filterImage),
                //                       color: isDark.value ? AppColors.white : AppColors.black,
                //                       height: 15,
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //             ),
                //             prefixIcon: Padding(
                //               padding: const EdgeInsets.only(left: 10, top: 15, bottom: 15),
                //               child: Image(
                //                 image: AssetImage(AppImage.searchImage),
                //                 height: 8,
                //                 width: 10,
                //               ),
                //             ),
                //             hintText: "${St.searchTitle.tr}...",
                //             hintStyle: GoogleFonts.plusJakartaSans(color: const Color(0xff9CA4AB), fontSize: 17),
                //             fillColor: isDark.value ? AppColors.blackBackground : AppColors.dullWhite,
                //             enabledBorder:
                //                 OutlineInputBorder(borderSide: isDark.value ? BorderSide(color: Colors.grey.shade800) : BorderSide.none, borderRadius: BorderRadius.circular(30)),
                //             border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryPink), borderRadius: BorderRadius.circular(30))),
                //       ),
                //     ),
                //   ),
                // ),
                Column(
                  children: [
                    userSearchProductController.userSearchProductModel?.products != null
                        ? userSearchProductController.isLoading.value
                            ? const Center(child: CircularProgressIndicator())
                            : userSearchProductController.userSearchProductModel!.products!.isNotEmpty
                                ? /*GridView.builder(
                                    controller: scrollController,
                                    padding: const EdgeInsets.only(left: 15, right: 15),
                                    cacheExtent: 5000,
                                    physics: const BouncingScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount:
                                        userSearchProductController.userSearchProductModel?.products?.length,
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      mainAxisSpacing: 2,
                                      crossAxisSpacing: 14,
                                      crossAxisCount: 2,
                                      mainAxisExtent: 49.2 * 5,
                                    ),
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          productId =
                                              "${userSearchProductController.userSearchProductModel?.products![index].id}";
                                          Get.toNamed("/ProductDetail");
                                        },
                                        child: SizedBox(
                                          child: Stack(
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height: 190,
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: NetworkImage(userSearchProductController
                                                                .userSearchProductModel!.products![index].mainImage
                                                                .toString()),
                                                            fit: BoxFit.cover),
                                                        borderRadius: BorderRadius.circular(10)),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 7),
                                                    child: Text(
                                                      userSearchProductController.userSearchProductModel!
                                                          .products![index].productName!.capitalizeFirst
                                                          .toString(),
                                                      style: GoogleFonts.plusJakartaSans(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 7),
                                                    child: Text(
                                                      "$currencySymbol${userSearchProductController.userSearchProductModel!.products![index].price}",
                                                      style: GoogleFonts.plusJakartaSans(
                                                          fontSize: 14, fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  )*/
                                ListView.builder(
                                    controller: scrollController,
                                    // padding: const EdgeInsets.only(left: 15, right: 15),
                                    // cacheExtent: 5000,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: userSearchProductController.userSearchProductModel?.products?.length,
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                        child: InkWell(
                                          onTap: () {
                                            productId = "${userSearchProductController.userSearchProductModel?.products![index].id}";
                                            Get.toNamed("/ProductDetail");
                                          },
                                          child: SizedBox(
                                            height: Get.height / 8.2,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: Get.width / 4.3,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: NetworkImage(userSearchProductController
                                                              .userSearchProductModel!.products![index].mainImage
                                                              .toString()),
                                                          fit: BoxFit.cover),
                                                      borderRadius: BorderRadius.circular(15)),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 15),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      SizedBox(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              "${userSearchProductController.userSearchProductModel!.products![index].productName!.capitalizeFirst}",
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w500),
                                                            ),
                                                            // Padding(
                                                            //   padding: const EdgeInsets.only(top: 5),
                                                            //   child: SizedBox(
                                                            //       width: Get.width / 1.7,
                                                            //       child: Text(
                                                            //         "Size  ${justForYouProductController.justForYouProduct!.justForYouProducts![index].attributes![0].value!.join(", ")}",
                                                            //         overflow: TextOverflow.ellipsis,
                                                            //         style: GoogleFonts.plusJakartaSans(
                                                            //             fontWeight: FontWeight.w300),
                                                            //       )),
                                                            // ),
                                                          ],
                                                        ),
                                                      ),
                                                      Text(
                                                        "$currencySymbol${userSearchProductController.userSearchProductModel!.products![index].price}",
                                                        style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Text(St.productNotFound.tr),
                                      ),
                                    ],
                                  )
                        : Visibility(
                            visible: userSearchProductController.isLoading.value,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                  child: SmallTitle(title: St.lastSearch.tr),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15, right: 15, top: 6),
                                  child: SizedBox(
                                    child: Obx(
                                      () => previousSearchController.isLoading.value
                                          ? Shimmers.lastSearchProductShimmer()
                                          : ListView.builder(
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              itemCount: previousSearchController.previousSearchProduct!.products!.lastSearchedProducts!.length,
                                              scrollDirection: Axis.vertical,
                                              itemBuilder: (context, index) {
                                                return Row(
                                                  children: [
                                                    Image(
                                                      image: AssetImage(AppImage.clockIcon),
                                                      height: 20,
                                                    ),
                                                    const SizedBox(
                                                      width: 7,
                                                    ),
                                                    Text(
                                                      previousSearchController
                                                          .previousSearchProduct!.products!.lastSearchedProducts![index].productName
                                                          .toString(),
                                                      style: GoogleFonts.plusJakartaSans(),
                                                    ),
                                                    /*     const Icon(
                                                Icons.close,
                                                size: 20,
                                                color: Colors.grey,
                                              )*/
                                                  ],
                                                ).paddingOnly(bottom: 20);
                                              },
                                            ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                  child: SmallTitle(title: St.popularSearch.tr),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: SizedBox(
                                    child: Obx(
                                      () => previousSearchController.isLoading.value
                                          ? Shimmers.popularSearchProductShimmer()
                                          : ListView.builder(
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              itemCount: previousSearchController.previousSearchProduct!.products!.popularSearchedProducts!.length,
                                              scrollDirection: Axis.vertical,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 7),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      productId = previousSearchController
                                                          .previousSearchProduct!.products!.popularSearchedProducts![index].id!;
                                                      Get.toNamed("/ProductDetail");
                                                    },
                                                    child: SizedBox(
                                                      height: Get.height / 11,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                            width: Get.width / 5.5,
                                                            decoration: BoxDecoration(
                                                                image: DecorationImage(
                                                                    image: NetworkImage(previousSearchController
                                                                        .previousSearchProduct!.products!.popularSearchedProducts![index].mainImage
                                                                        .toString()),
                                                                    fit: BoxFit.cover),
                                                                borderRadius: BorderRadius.circular(15)),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.only(left: 15),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                              children: [
                                                                SizedBox(
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Text(
                                                                        previousSearchController.previousSearchProduct!.products!
                                                                            .popularSearchedProducts![index].productName
                                                                            .toString(),
                                                                        style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w500),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(top: 7),
                                                                        child: Text(
                                                                          "${previousSearchController.previousSearchProduct!.products!.popularSearchedProducts![index].searchCount} ${St.searches.tr}",
                                                                          style:
                                                                              GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w300),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SearchAppBarWidget extends StatelessWidget {
  const SearchAppBarWidget({super.key, required this.controller, this.callback});

  final TextEditingController controller;
  final Callback? callback;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        color: AppColors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
            5.width,
            Expanded(
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: [
                    Image.asset(AppAsset.icSearch, width: 20, color: AppColors.unselected.withValues(alpha: 0.5)),
                    10.width,
                    Expanded(
                      child: TextFormField(
                        cursorColor: AppColors.unselected,
                        controller: controller,
                        style: AppFontStyle.styleW500(AppColors.white, 15),
                        decoration: InputDecoration(
                          hintText: St.searchText.tr,
                          hintStyle: AppFontStyle.styleW500(AppColors.unselected.withValues(alpha: 0.5), 15),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.only(bottom: 5),
                        ),
                      ),
                    ),
                    VerticalDivider(
                      color: AppColors.unselected.withValues(alpha: 0.5),
                      indent: 10,
                      endIndent: 10,
                    ),
                    GestureDetector(
                      onTap: callback,
                      child: Container(
                        height: 48,
                        width: 25,
                        alignment: Alignment.center,
                        color: AppColors.transparent,
                        child: Image.asset(AppAsset.icFilter, width: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchHistoryItemWidget extends StatelessWidget {
  const SearchHistoryItemWidget({super.key, required this.title, required this.callback, required this.onClose});

  final String title;
  final Callback callback;
  final Callback onClose;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        color: Colors.transparent,
        height: 40,
        width: Get.width,
        child: Row(
          children: [
            5.width,
            Image.asset(AppAsset.icHistory, width: 20, color: AppColors.unselected),
            10.width,
            Text(
              title,
              style: AppFontStyle.styleW500(AppColors.unselected, 14),
            ),
            const Spacer(),
            GestureDetector(
              onTap: onClose,
              child: Container(
                height: 40,
                width: 40,
                color: AppColors.transparent,
                alignment: Alignment.center,
                child: Image.asset(AppAsset.icClose, color: AppColors.unselected, width: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

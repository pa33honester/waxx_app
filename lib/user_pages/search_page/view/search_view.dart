import 'package:waxxapp/Controller/GetxController/user/previous_search_product_controller.dart';
import 'package:waxxapp/Controller/GetxController/user/user_search_product_controller.dart';
import 'package:waxxapp/custom/custom_color_bg_widget.dart';
import 'package:waxxapp/custom/preview_image_widget.dart';
import 'package:waxxapp/user_pages/search_page/widget/search_app_bar_widget.dart';
import 'package:waxxapp/user_pages/search_page/widget/search_history_item_widget.dart';
import 'package:waxxapp/utils/CoustomWidget/App_theme_services/no_data_found.dart';
import 'package:waxxapp/utils/CoustomWidget/Page_devided/filter_bottem_shit.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_asset.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/shimmers.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  PreviousSearchController previousSearchController = Get.put(PreviousSearchController());
  UserSearchProductController userSearchProductController = Get.put(UserSearchProductController());

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
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.transparent,
            shadowColor: AppColors.black.withValues(alpha: 0.4),
            surfaceTintColor: AppColors.transparent,
            flexibleSpace: SearchAppBarWidget(
              onChanged: (p0) {
                userSearchProductController.searchContent(searchController.text);
              },
              callback: () => Get.bottomSheet(
                isScrollControlled: true,
                barrierColor: AppColors.tabBackground.withValues(alpha: 0.8),
                const FilterBottomShirt(),
              ),
              controller: searchController,
            ),
          ),
        ),
        body: GetBuilder<UserSearchProductController>(
            id: 'searchResults',
            builder: (context) {
              return searchController.text.isEmpty
                  ? SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /* 15.height,
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
                    ),*/
                            15.height,
                            Text(
                              St.lastSeen.tr,
                              style: AppFontStyle.styleW700(AppColors.white, 18),
                            ),
                            5.height,
                            Obx(
                              () => previousSearchController.isLoading.value
                                  ? Shimmers.lastSearchProductShimmer()
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: previousSearchController.previousSearchProduct?.products?.lastSearchedProducts?.length,
                                      padding: EdgeInsets.zero,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return SearchHistoryItemWidget(
                                          title: previousSearchController.previousSearchProduct?.products?.lastSearchedProducts?[index].productName ?? '',
                                          callback: () {},
                                          onClose: () {},
                                        );
                                      },
                                    ),
                            ),
                            5.height,
                            Text(
                              St.popularSearch.tr,
                              style: AppFontStyle.styleW700(AppColors.white, 18),
                            ),
                            15.height,
                            Obx(
                              () => previousSearchController.isLoading.value
                                  ? Shimmers.popularSearchProductShimmer()
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: previousSearchController.previousSearchProduct?.products?.popularSearchedProducts?.length,
                                      padding: EdgeInsets.zero,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            productId = previousSearchController.previousSearchProduct?.products?.popularSearchedProducts?[index].id ?? '';
                                            Get.toNamed("/ProductDetail");
                                          },
                                          child: Container(
                                            width: Get.width,
                                            margin: const EdgeInsets.only(bottom: 10),
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: AppColors.tabBackground,
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                PreviewImageWidget(
                                                  height: 80,
                                                  width: 80,
                                                  fit: BoxFit.cover,
                                                  image: previousSearchController.previousSearchProduct?.products?.popularSearchedProducts?[index].mainImage ?? "",
                                                  radius: 10,
                                                ),
                                                10.width,
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              previousSearchController.previousSearchProduct?.products?.popularSearchedProducts?[index].productName ?? '',
                                                              overflow: TextOverflow.ellipsis,
                                                              maxLines: 1,
                                                              style: AppFontStyle.styleW700(AppColors.white, 13),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      4.height,
                                                      Text(
                                                        previousSearchController.previousSearchProduct?.products?.popularSearchedProducts?[index].description ?? "",
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 2,
                                                        style: AppFontStyle.styleW500(AppColors.unselected, 12),
                                                      ),
                                                      5.height,
                                                      Row(
                                                        children: [
                                                          Image.asset(AppAsset.icEye, width: 15, color: AppColors.primary),
                                                          5.width,
                                                          Text(
                                                            "${previousSearchController.previousSearchProduct?.products?.popularSearchedProducts![index].searchCount.toString()} Views",
                                                            style: AppFontStyle.styleW700(AppColors.primary, 10),
                                                          ),
                                                        ],
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
                          ],
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: userSearchProductController.userSearchProductModel!.products != null && userSearchProductController.userSearchProductModel!.products!.isEmpty
                                ? noDataFound(
                                    image: "assets/no_data_found/basket.png",
                                  ).paddingOnly(top: Get.height * .25)
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: userSearchProductController.userSearchProductModel?.products?.length,
                                    padding: EdgeInsets.zero,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          productId = "${userSearchProductController.userSearchProductModel?.products?[index].id}";
                                          Get.toNamed("/ProductDetail");
                                        },
                                        child: Container(
                                          height: 90,
                                          width: Get.width,
                                          margin: const EdgeInsets.only(bottom: 10),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: AppColors.tabBackground,
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              PreviewImageWidget(
                                                height: 70,
                                                width: 70,
                                                fit: BoxFit.cover,
                                                image: userSearchProductController.userSearchProductModel?.products?[index].mainImage.toString(),
                                                radius: 10,
                                              ),
                                              10.width,
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          userSearchProductController.userSearchProductModel?.products?[index].productName ?? '',
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 1,
                                                          style: AppFontStyle.styleW700(AppColors.white, 13),
                                                        ),
                                                      ],
                                                    ),
                                                    Flexible(
                                                      fit: FlexFit.loose,
                                                      child: Text(
                                                        userSearchProductController.userSearchProductModel?.products?[index].productName?.capitalizeFirst ?? '',
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 2,
                                                        style: AppFontStyle.styleW500(AppColors.unselected, 12),
                                                      ),
                                                    ),
                                                    5.height,
                                                    Row(
                                                      children: [
                                                        Image.asset(AppAsset.icEye, width: 15, color: AppColors.primary),
                                                        5.width,
                                                        Text(
                                                          "$currencySymbol${userSearchProductController.userSearchProductModel?.products?[index].price}",
                                                          style: AppFontStyle.styleW700(AppColors.primary, 10),
                                                        ),
                                                      ],
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
                        ],
                      ),
                    );
            }),
      ),
    );
  }
}

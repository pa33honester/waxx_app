// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:preload_page_view/preload_page_view.dart';
import '../../../ApiModel/seller/GetReelsForUserModel.dart';
import '../../../Controller/GetxController/user/get_reels_controller.dart';
import '../../../utils/CoustomWidget/Page_devided/show_reels.dart';

class ShortsView extends StatefulWidget {
  const ShortsView({super.key});

  @override
  State<ShortsView> createState() => _ShortsViewState();
}

class _ShortsViewState extends State<ShortsView> {
  GetReelsForUserController getReelsForUserController = Get.put(GetReelsForUserController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getReelsForUserController.pageController.addListener(() {
      _scrollListener();
    });
    // getReelsForUserController.getAllReels();
  }

  // void _scrollListener() {
  //   if (getReelsForUserController.pageController.offset >=
  //           getReelsForUserController.pageController.position.maxScrollExtent &&
  //       !getReelsForUserController.pageController.position.outOfRange) {
  //     setState(() {});
  //     getReelsForUserController.reelsPagination();
  //   }

  void _scrollListener() {
    if (getReelsForUserController.pageController.offset >= getReelsForUserController.pageController.position.maxScrollExtent && !getReelsForUserController.pageController.position.outOfRange && getReelsForUserController.loadOrNot.value) {
      // Calculate the next start value for pagination
      // int nextStart = (getReelsForUserController.start - 1) * getReelsForUserController.limit + 1;

      // Call reelsPagination with the updated start value
      getReelsForUserController.reelsPagination();
    }
  } // }

  @override
  void dispose() {
    // TODO: implement dispose
    // getReelsForUserController.likeDislikes.clear();
    getReelsForUserController.start = 1;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final getAllReels = getReelsForUserController.allReels;
      if (getReelsForUserController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else if (getAllReels.isNotEmpty) {
        return PreloadPageView.builder(
          controller: getReelsForUserController.preloadPageController,
          itemCount: getAllReels.length,
          preloadPagesCount: 1,
          scrollDirection: Axis.vertical,
          onPageChanged: (value) async {
            // controller.onPagination(value);
            getReelsForUserController.onChangePage(value);
          },
          itemBuilder: (context, index) {
            final shorts = getAllReels[index];
            // Guard: skip reels with no associated products
            final hasProduct = shorts.productId != null && shorts.productId!.isNotEmpty;
            final product = hasProduct ? shorts.productId![0] : null;
            List<Attribute>? attributesArray = product?.attributes;
            return ShowShorts(
              videoUrl: "${shorts.video}",
              productName: product?.productName ?? "",
              productPrice: "${product?.price ?? ""}",
              productImage: product?.mainImage ?? "",
              productId: product?.id ?? "",
              productDescription: product?.description ?? "",
              attributeArray: jsonDecode(jsonEncode(attributesArray ?? [])),
              businessName: "${shorts.sellerId?.businessName ?? ""}",
              sellerId: shorts.sellerId?.id ?? "",
              reelId: "${shorts.id}",
              isLikeOrNot: getReelsForUserController.likeDislikes[index],
              selectedIndex: index,
              likeCount: getReelsForUserController.likeCounts[index]!,
              currentPageIndex: getReelsForUserController.currentPageIndex,
              index: index,
            );
          },
        );

        ///k
        // return PageView.builder(
        //   physics: const BouncingScrollPhysics(),
        //   // preloadPagesCount: 3,
        //   scrollDirection: Axis.vertical,
        //   controller: getReelsForUserController.pageController,
        //   itemCount: getAllReels.length,
        //   itemBuilder: (context, index) {
        //     final shorts = getAllReels[index];
        //     List<Attributes>? attributesArray = shorts.productId!.attributes;
        //     return ShowShorts(
        //       videoUrl: "${shorts.video}",
        //       productName: "${shorts.productId!.productName}",
        //       productPrice: "${shorts.productId!.price}",
        //       productImage: "${shorts.productId!.mainImage}",
        //       productId: "${shorts.productId!.id}",
        //       productDescription: "${shorts.productId!.description}",
        //       attributeArray: jsonDecode(jsonEncode(attributesArray)),
        //       businessName: "${shorts.sellerId!.businessName}",
        //       reelId: "${shorts.id}",
        //       isLikeOrNot: getReelsForUserController.likeDislikes[index],
        //       selectedIndex: index,
        //       likeCount: getReelsForUserController.likeCounts[index]!,
        //     );
        //   },
        // );
      }

      // else if (getAllReels != null && getAllReels.shorts!.isNotEmpty) {
      //
      //   final reel = getAllReels.shorts!.map((shorts) {
      //     List<Attribute>? attributesArray = shorts.productId!.attributes;
      //     return ShowReels(
      //       videoUrl: "${shorts.video}",
      //       productName: "${shorts.productId!.productName}",
      //       productPrice: "${shorts.productId!.price}",
      //       productImage: "${shorts.productId!.mainImage}",
      //       productId: "${shorts.productId!.id}",
      //       productDescription: "${shorts.productId!.description}",
      //       attributeArray: jsonDecode(jsonEncode(attributesArray)),
      //       businessName: "${shorts.sellerId!.businessName}",
      //       reelId: "${shorts.id}",
      //       isLikeOrNot: shorts.isLike!,
      //     );
      //   }).toList();
      //   return PageView(
      //     physics: const BouncingScrollPhysics(),
      //     scrollDirection: Axis.vertical,
      //     controller: controller,
      //     children: reel,
      //   );
      // }

      else {
        return Center(child: Text(St.noVideosAvailable.tr));
      }
    });
  }
}

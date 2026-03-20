import 'dart:developer';

import 'package:waxxapp/ApiModel/user/GalleryCategoryModel.dart';
import 'package:waxxapp/ApiService/user/gallery_catagory_service.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/show_toast.dart';

class GalleryCategoryController extends GetxController {
  GalleryCategoryModel? galleryCategory;
  RxBool isLoading = true.obs;
  RxBool isRefreshLoading = true.obs;
  RxBool moreLoading = false.obs;
  TabController? homeTabController;
  TabController? viewAllTabController;

  int start = 1;
  int limit = 12;
  List<Product> galleryProducts = [];
  List<bool> likes = [];

  @override
  void onClose() {
    homeTabController?.dispose();
    viewAllTabController?.dispose();
    super.onClose();
  }

  Future getCategoryData({String? selectCategory}) async {
    try {
      isLoading(true);
      isRefreshLoading(true);
      galleryProducts.clear();
      start = 1;

      galleryCategory = await GalleryCategoryApi().showCategory(
        userId: loginUserId,
        categoryId: selectCategory.toString(),
        start: "$start",
        limit: "$limit",
      );
      update();
      // galleryCategory = data;
      if (galleryCategory!.status == true) {
        galleryProducts.clear();
        galleryProducts.addAll(galleryCategory?.product?.toList() ?? []);
        update();
        log("galleryProducts.length ${galleryProducts.length}");
        likes = List.generate(galleryProducts.length, (_) => true);
        start++;
      }
    } finally {
      isLoading(false);
      isRefreshLoading(false);
    }
  }

  void resetForTabChange() {
    galleryProducts.clear();
    isLoading(true);
    update(); // Force immediate UI update
  }

  Future loadMoreData({String? selectCategory}) async {
    try {
      moreLoading(true);
      var data = await GalleryCategoryApi().showCategory(userId: loginUserId, categoryId: selectCategory.toString(), start: "$start", limit: "$limit");
      galleryCategory = data;

      if (data!.status == true) {
        galleryProducts.addAll(data.product!);
        start++;
        update(['category']);
      }
      if (data.product!.isEmpty) {
        displayToast(message: "No more products");
      }
    } finally {
      moreLoading(false);
    }
  }
}

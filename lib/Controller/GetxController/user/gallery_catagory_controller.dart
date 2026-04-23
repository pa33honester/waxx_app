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

      if (galleryCategory?.status == true) {
        galleryProducts.clear();
        galleryProducts.addAll(galleryCategory?.product?.toList() ?? []);
        log("galleryProducts.length ${galleryProducts.length}");
        likes = List.generate(galleryProducts.length, (_) => true);
        start++;
      } else {
        log("getCategoryData: status=${galleryCategory?.status}, products=${galleryCategory?.product?.length}");
      }
    } catch (e, st) {
      log("getCategoryData error: $e\n$st");
    } finally {
      isLoading(false);
      isRefreshLoading(false);
      update();
    }
  }

  void resetForTabChange() {
    galleryProducts.clear();
    isLoading(true);
    update(); // Force immediate UI update
  }

  /// Returns the index (within [categoryIds]) of the first category that has
  /// at least one product, or null if all are empty. Checks in parallel using
  /// limit=1 to keep requests lightweight.
  Future<int?> findFirstNonEmptyCategoryIndex(List<String?> categoryIds, {int startFrom = 0}) async {
    final futures = <Future<int?>>[];
    for (int i = startFrom; i < categoryIds.length; i++) {
      final catId = categoryIds[i];
      final idx = i;
      if (catId == null) {
        futures.add(Future.value(null));
        continue;
      }
      futures.add(_checkCategoryHasProducts(catId, idx));
    }
    final results = await Future.wait(futures);
    return results.firstWhere((r) => r != null, orElse: () => null);
  }

  Future<int?> _checkCategoryHasProducts(String catId, int idx) async {
    try {
      final r = await GalleryCategoryApi().showCategory(
        userId: loginUserId,
        categoryId: catId,
        start: "1",
        limit: "1",
      );
      return (r?.product?.isNotEmpty ?? false) ? idx : null;
    } catch (_) {
      return null;
    }
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

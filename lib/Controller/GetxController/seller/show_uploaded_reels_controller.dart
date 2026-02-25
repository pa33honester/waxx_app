import 'dart:developer';

import 'package:era_shop/utils/show_toast.dart';
import 'package:get/get.dart';

import '../../../ApiModel/seller/ShowUploadedReelsModel.dart';
import '../../../ApiService/seller/show_uploaded_reels_service.dart';

class ShowUploadedShortsController extends GetxController {
  ShowUploadedReelsModel? showCatalogData;
  RxBool isLoading = true.obs;
  RxBool moreLoading = false.obs;
  RxBool loadOrNot = true.obs;

  int start = 1;
  int limit = 14;

  List<Reels> reelsItems = [];

  Future getReels() async {
    try {
      isLoading(true);
      loadOrNot(true);
      var data = await ShowUploadedReelsApi().showUploadedReels(start: "$start", limit: "$limit");
      showCatalogData = data;
      reelsItems.clear();
      if (showCatalogData!.status == true) {
        reelsItems.addAll(showCatalogData!.reels!);
        start++;
        update();
      }
      if (showCatalogData!.reels!.isEmpty) {
        loadOrNot(false);
      }
    } finally {
      isLoading(false);
      log('Show Short finally');
    }
  }

  Future loadMoreData() async {
    try {
      moreLoading(true);
      loadOrNot(true);
      var data = await ShowUploadedReelsApi().showUploadedReels(
        start: "$start",
        limit: "$limit",
      );
      if (data.status == true) {
        reelsItems.addAll(data.reels!);
        start++;
        update();
      }
      if (data.reels!.isEmpty) {
        loadOrNot(false);
        displayToast(message: "No more products");
      }
    } finally {
      moreLoading(false);
      log('Load more data finally');
    }
  }

  Future afterDeleteReels() async {
    try {
      var data = await ShowUploadedReelsApi().showUploadedReels(start: "1", limit: "16");
      showCatalogData = data;
      reelsItems.clear();
      if (showCatalogData!.status == true) {
        reelsItems.addAll(showCatalogData!.reels!);
        start++;
        update();
      }
      if (showCatalogData!.reels!.isEmpty) {
        loadOrNot(false);
      }
    } finally {
      isLoading(false);
      log('Show Short finally');
    }
  }

  void deleteReelLocally(String reelId) {
    final index = reelsItems.indexWhere((reel) => reel.id == reelId);
    if (index != -1) {
      reelsItems.removeAt(index);
      update();
      log('Reel with ID $reelId deleted locally.');
      displayToast(message: "Reel deleted successfully");
    } else {
      log('Reel with ID $reelId not found in the list.');
    }
  }
}

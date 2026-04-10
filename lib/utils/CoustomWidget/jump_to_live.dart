import 'dart:async';

import 'package:flutter/material.dart';

Future<void> jumpToLivePage(
  BuildContext context, {
  required String roomID,
  required bool isHost,
  required String localUserID,
  required String localUserName,
}) async {
  /// if in future add product method when seller live so use this committed code
  // ShowCatalogController showCatalogController = Get.put(ShowCatalogController());
  // callApi() {
  //   showCatalogController.catalogItemsForLive.clear();
  //   showCatalogController.start = 1;
  //   showCatalogController.getCatalogData();
  // }

  // GetLiveSellerListController getLiveSellerListController = Get.put(GetLiveSellerListController());
  //
  // Get.to(
  //       () => LivePage(
  //     isHost: isHost,
  //     localUserID: localUserID,
  //     localUserName: localUserName,
  //     roomID: roomID,
  //   ),
  // )!
  //     .then(
  //       (value) {
  //     return Timer(const Duration(seconds: 1), () {
  //       getLiveSellerListController.sellerListAfterLive();
  //     });
  //   },
  // ) /*!
  //     .then((value) => isHost ? callApi() : null)*/
  // ;
}

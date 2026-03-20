import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:waxxapp/ApiModel/seller/ShowCatalogModel.dart';
import 'package:waxxapp/ApiService/seller/show_catalog_service.dart';
import 'package:waxxapp/utils/show_toast.dart';

class ShowCatalogController extends GetxController {
  ShowCatalogModel? showCatalogData;

  final searchController = TextEditingController();

  // Loading state
  RxBool isLoading = true.obs;
  RxBool moreLoading = false.obs;
  RxBool loadOrNot = true.obs;

  // Pagination
  int start = 1;
  int limit = 14;

  RxInt currentTab = 0.obs;

  List<Products> catalogItems = [];

  final Map<int, RxString> searchByTab = {
    0: ''.obs,
    1: ''.obs,
    2: ''.obs,
    3: ''.obs,
  };

  final Map<int, String> saleTypeByTab = const {
    0: 'All',
    1: '1',
    2: '2',
    3: '3',
  };

  List selectedCatalogId = [];
  List<Map<String, dynamic>> selectedProducts = [];

  void onSearchChangedForTab(int tabIndex, String text) {
    searchByTab[tabIndex]!.value = text;
  }

  void submitSearchForTab(int tabIndex) {
    currentTab.value = tabIndex;
    refreshFirstPage();
  }

  void refreshFirstPage() {
    start = 1;
    catalogItems.clear();
    getCatalogData(
      search: searchByTab[currentTab.value]!.value,
      saleType: saleTypeByTab[currentTab.value]!,
    );
  }

  Future getCatalogData({required String search, required String saleType}) async {
    try {
      isLoading(true);
      loadOrNot(true);

      final data = await ShowCatalogApi().showCatalogs(
        start: "$start",
        limit: "$limit",
        search: search,
        saleType: saleType,
      );

      showCatalogData = data;
      if (data.status == true) {
        catalogItems.addAll(data.products ?? []);
        start++;
        update();
      }
      if ((data.products ?? []).isEmpty) {
        loadOrNot(false);
      }
    } finally {
      isLoading(false);
      log('Show catalog finally');
    }
  }

  Future loadMoreData() async {
    try {
      if (!loadOrNot.value || moreLoading.value) return;

      moreLoading(true);
      loadOrNot(true);

      final data = await ShowCatalogApi().showCatalogs(
        start: "$start",
        limit: "$limit",
        search: searchByTab[currentTab.value]!.value,
        saleType: saleTypeByTab[currentTab.value]!,
      );

      if (data.status == true) {
        catalogItems.addAll(data.products ?? []);
        start++;
        update();
      }
      if ((data.products ?? []).isEmpty) {
        loadOrNot(false);
        // displayToast(message: "No more products");
      }
    } finally {
      moreLoading(false);
      log('Load more data finally');
    }
  }

  // (unchanged) selection helper
  void toggleProductSelection(Products product, bool isSelected) {
    if (isSelected) {
      final formattedAttributes = <Map<String, dynamic>>[];
      if (product.attributes != null && product.attributes!.isNotEmpty) {
        for (var attr in product.attributes!) {
          formattedAttributes.add({
            'name': attr.name ?? '',
            'values': attr.values?.map((v) => v.toString()).toList() ?? [],
          });
        }
      }
      selectedProducts.add({
        'productId': product.id,
        'productName': product.productName,
        'mainImage': product.mainImage,
        'price': product.price,
        'productAttributes': formattedAttributes,
      });
    } else {
      selectedProducts.removeWhere((p) => p['productId'] == product.id);
    }
    update();
  }
}

// import 'dart:developer';
// import 'package:waxxapp/ApiModel/seller/ShowCatalogModel.dart';
// import 'package:waxxapp/ApiService/seller/show_catalog_service.dart';
// import 'package:waxxapp/utils/show_toast.dart';
// import 'package:get/get.dart';
//
// class ShowCatalogController extends GetxController {
//   ShowCatalogModel? showCatalogData;
//   RxBool isLoading = true.obs;
//   RxBool moreLoading = false.obs;
//   RxBool loadOrNot = true.obs;
//
//   int start = 1;
//   int limit = 14;
//
//   List<Products> catalogItems = [];
//   List<Products> catalogItemsForLive = [];
//   List selectedCatalogId = [];
//
//   List<Map<String, dynamic>> selectedProducts = [];
//
//   void toggleProductSelection(Products product, bool isSelected) {
//     if (isSelected) {
//       List<Map<String, dynamic>> formattedAttributes = [];
//
//       if (product.attributes != null && product.attributes!.isNotEmpty) {
//         for (var attr in product.attributes!) {
//           formattedAttributes.add({
//             'name': attr.name ?? '',
//             'values': attr.values?.map((v) => v.toString()).toList() ?? [],
//           });
//         }
//       }
//
//       selectedProducts.add({
//         'productId': product.id,
//         'productName': product.productName,
//         'mainImage': product.mainImage,
//         'price': product.price,
//         'productAttributes': formattedAttributes,
//       });
//     } else {
//       selectedProducts.removeWhere((p) => p['productId'] == product.id);
//     }
//     update();
//   }
//
//   Future getCatalogData() async {
//     try {
//       isLoading(true);
//       loadOrNot(true);
//       var data = await ShowCatalogApi().showCatalogs(start: "$start", limit: "$limit");
//       showCatalogData = data;
//       catalogItems.clear();
//       if (showCatalogData!.status == true) {
//         catalogItems.addAll(showCatalogData!.products!);
//         start++;
//         update();
//       }
//       if (showCatalogData!.products!.isEmpty) {
//         loadOrNot(false);
//       }
//     } finally {
//       isLoading(false);
//       log('Show catalog finally');
//     }
//   }
//
//   Future loadMoreData() async {
//     try {
//       moreLoading(true);
//       loadOrNot(true);
//       var data = await ShowCatalogApi().showCatalogs(
//         start: "$start",
//         limit: "$limit",
//       );
//       if (data.status == true) {
//         catalogItems.addAll(data.products!);
//         start++;
//         update();
//       }
//       if (data.products!.isEmpty) {
//         loadOrNot(false);
//         displayToast(message: "No more products");
//       }
//     } finally {
//       moreLoading(false);
//       log('Load more data finally');
//     }
//   }
//
// /*  Future getCatalogDataForLive() async {
//     try {
//       isLoading(true);
//       var data = await ShowCatalogApi().showCatalogs(start: "1", limit: "30");
//       showCatalogData = data;
//       catalogItemsForLive.clear();
//       if (showCatalogData!.status == true) {
//         catalogItemsForLive.addAll(showCatalogData!.products!);
//         update();
//       }
//     } finally {
//       isLoading(false);
//       log('Show catalog finally');
//     }
//   }*/
// }

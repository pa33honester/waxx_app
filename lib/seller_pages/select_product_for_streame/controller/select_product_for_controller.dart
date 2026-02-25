import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:era_shop/ApiModel/seller/LiveSellerForSellingModel.dart';
import 'package:era_shop/ApiModel/user/GetLiveSellerListModel.dart';
import 'package:era_shop/ApiService/seller/live_seller_for_selling_service.dart';
import 'package:era_shop/seller_pages/live_page/view/live_view.dart';
import 'package:era_shop/seller_pages/select_product_for_streame/api/fetch_seller_products_api.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:era_shop/seller_pages/select_product_for_streame/model/fetch_product_model.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../utils/database.dart' show Database;

class SelectProductsForStreamerController extends GetxController {
  ScrollController scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  Timer? searchDebounce;

  FetchProductInventoryModel? fetchProductInventoryModel;
  List<InventoryProduct> productList = [];
  List<InventoryProduct> allProductsList = []; // Store all products for search
  bool isLoading = false;
  bool isPaginationLoading = false;
  bool isSearching = false;
  bool isSearchVisible = false;
  String currentSearchQuery = '';

  // Updated: Store selected products in the required format
  List<Map<String, dynamic>> selectedProductsArray = [];
  List<String> staticproductList = [];
  String staticproduct = '';

  @override
  void onInit() {
    init();
    scrollController.addListener(onPagination);
    log("SSSSSSSSSSSSSSSSSSSSSeller ID ${Database.sellerId} ");
    log("SSSSSSSSSSSSSSSSSSSSSeller ID ${sellerId} ");
    super.onInit();
  }

  @override
  void onClose() {
    searchController.dispose();
    searchDebounce?.cancel();
    scrollController.dispose();
    super.onClose();
  }

  Future<void> init() async {
    isLoading = true;
    productList.clear();
    allProductsList.clear();
    selectedProductsArray.clear();
    staticproductList.clear();
    staticproduct = '';
    currentSearchQuery = '';
    searchController.clear();
    update(["onGetProducts"]);
    FetchProductInventoryApi.startPagination = 1;
    await fetchProductInventory();
    isLoading = false;
  }

  // Search functionality
  void onSearchChanged(String query) {
    if (searchDebounce?.isActive ?? false) searchDebounce!.cancel();

    searchDebounce = Timer(const Duration(milliseconds: 500), () {
      if (query.trim() != currentSearchQuery) {
        currentSearchQuery = query.trim();
        performSearch();
      }
    });
  }

  void performSearch() async {
    if (currentSearchQuery.isEmpty) {
      // If search is empty, load all products
      isSearching = false;
      FetchProductInventoryApi.startPagination = 1;
      productList.clear();
      await fetchProductInventory();
    } else {
      // Perform search with API
      isSearching = true;
      isLoading = true;
      update(["onGetProducts"]);

      FetchProductInventoryApi.startPagination = 1;
      productList.clear();
      await fetchProductInventory();

      isLoading = false;
      update(["onGetProducts"]);
    }
  }

  void clearSearch() {
    searchController.clear();
    currentSearchQuery = '';
    isSearching = false;
    FetchProductInventoryApi.startPagination = 1;
    productList.clear();
    fetchProductInventory();
    update(["onGetProducts"]);
  }

  bool isProductSelectedfirst = false;
  Future<void> onRequestPermissions() async {
    final camera = await Permission.camera.request();
    final microphone = await Permission.microphone.request();
    if (camera.isGranted && microphone.isGranted) {
      onClickGoLive();
    } else {
      Utils.showToast(St.txtPleaseAllowPermission.tr);
    }
  }

  void onClickGoLive() async {
    // Log the selected products array before navigation

    log("Seller Id: ${Database.sellerId}");
    log("Selected Products Array: $selectedProductsArray");

    if (selectedProductsArray.isEmpty) {
      Utils.showToast("Please select at least one product");
      return;
    } else {
      // Check if any product has auction enabled
      bool hasAuctionEnabled = selectedProductsArray.any((item) => item['isAuctionEnabled'] == true);

      // Determine live type based on auction status
      int liveType = hasAuctionEnabled ? 2 : 1; // AUCTION: 2, NORMAL: 1

      // Transform the selected products array to the required format
      List<Map<String, dynamic>> transformedProducts = selectedProductsArray.map((item) {
        List<Map<String, dynamic>> attributes = [];
        final selectedAttrs = item['selectedAttributes'] as Map<String, dynamic>? ?? {};

        selectedAttrs.forEach((attrName, attrValue) {
          attributes.add({
            "name": attrName,
            "values": [attrValue] // Values must be in array
          });
        });
        return {"productId": item['productId'], "minimumBidPrice": item['minimumBidPrice'], "minAuctionTime": item['minAuctionTime'], "productAttributes": attributes};
      }).toList();
      LiveSellerForSellingModel? createLiveSellerModel;
      log("Transformed Products: $transformedProducts");
      log("Live Type: $liveType");
      createLiveSellerModel = await CreateLiveSellerWithProductApi.callApi(sellerId: Database.sellerId, selectedProducts: transformedProducts, liveType: liveType);
      Get.back(); // Stop Loading...

      if (createLiveSellerModel?.status == true) {
        Utils.showLog("Live Seller Room Id => ${createLiveSellerModel?.liveseller?.selectedProducts}");
        Get.to(
          () => LivePageView(
              key: ValueKey("live_${createLiveSellerModel?.liveseller?.liveSellingHistoryId}_0"),
              liveUserList: LiveSeller(
                firstName: createLiveSellerModel?.liveseller?.firstName,
                lastName: createLiveSellerModel?.liveseller?.lastName,
                businessName: createLiveSellerModel?.liveseller?.businessName,
                businessTag: createLiveSellerModel?.liveseller?.businessTag,
                image: createLiveSellerModel?.liveseller?.image,
                liveSellingHistoryId: createLiveSellerModel?.liveseller?.liveSellingHistoryId ?? '',
                view: createLiveSellerModel?.liveseller?.view,
                liveType: createLiveSellerModel?.liveseller?.liveType,
                selectedProducts: createLiveSellerModel?.liveseller?.selectedProducts,
                sellerId: createLiveSellerModel?.liveseller?.sellerId,
              ),
              isHost: true,
              isActive: true),
          routeName: '/LivePage',
        );
      } else {
        Utils.showToast(createLiveSellerModel?.message ?? "Something went wrong");
      }

      /*Get.toNamed(AppRoutes.goLivePage, arguments: {
        "isUserLive": false,
        "selectedProducts": transformedProducts, // Pass transformed products (not selectedProductsArray)
        "liveType": liveType,
      })?.then(
        (value) {
          log("message--------------");
          Get.back();
          FetchProductInventoryApi.startPagination = 1;
          productList.clear();
          fetchProductInventory();
        },
      );*/
    }
  }

  // New method to validate mixed auction/non-auction products
  bool validateMixedProducts(Map<String, dynamic> newProductData) {
    if (selectedProductsArray.isEmpty) {
      return true; // First product, no validation needed
    }

    // Check if new product has auction enabled
    bool newProductHasAuction = newProductData['isAuctionEnabled'] == true;

    // Check existing products
    bool hasAuctionProducts = selectedProductsArray.any((product) => product['isAuctionEnabled'] == true);
    bool hasNonAuctionProducts = selectedProductsArray.any((product) => product['isAuctionEnabled'] != true);

    // If adding auction product and we have non-auction products
    if (newProductHasAuction && hasNonAuctionProducts) {
      return false;
    }

    // If adding non-auction product and we have auction products
    if (!newProductHasAuction && hasAuctionProducts) {
      return false;
    }

    return true;
  }

  // New method to add product to selection
  void addProductToSelection(Map<String, dynamic> productData, InventoryProduct catalogItems) {
    String productId = catalogItems.id ?? '';

    // Remove if already exists
    // selectedProductsArray.removeWhere((product) => product['productId'] == productId);
    // staticproductList.remove(productId);

    // Add new product data
    selectedProductsArray.add(productData);
    staticproductList.add(productId);

    update(["onChangeCheckBox"]);

    log("Product added: $productId");
    log("Total selected products: ${selectedProductsArray.length}");
    log("Selected Products Array: $selectedProductsArray");
  }

  void onClickToggle(String productId, InventoryProduct catalogItems) async {
    // Check if product is already selected
    bool isSelected = selectedProductsArray.any((product) => product['productId'] == productId);

    if (isSelected) {
      // Remove product from selected array
      selectedProductsArray.removeWhere((product) => product['productId'] == productId);
      staticproductList.remove(productId);
      log("Product removed: $productId");
    } else {
      // Add product to selected array with required format
      Map<String, dynamic> productData = {
        "productId": productId,
        "minimumBidPrice": 0,
        "minAuctionTime": 0,
        "productAttributes": catalogItems.attributes ?? [],
        "price": catalogItems.price,
        "isAuctionEnabled": false, // Default to non-auction for simple toggle
      };

      selectedProductsArray.add(productData);
      staticproductList.add(productId);
      log("Product added: $productId");
    }

    log("Total selected products: ${selectedProductsArray.length}");
    log("Selected Products Array: $selectedProductsArray");

    update(["onChangeCheckBox"]);
  }

  void onPagination() async {
    // Don't paginate during search mode
    if (isSearching) return;

    if (scrollController.position.pixels == scrollController.position.maxScrollExtent && isPaginationLoading == false) {
      isPaginationLoading = true;
      update(["onPagination"]);
      await fetchProductInventory();
      isPaginationLoading = false;
      update(["onPagination"]);
    }
  }

  Future<void> fetchProductInventory() async {
    fetchProductInventoryModel = null;

    // Include search parameter in API call
    fetchProductInventoryModel = await FetchProductInventoryApi.callApi(
      sellerId: sellerId,
      search: currentSearchQuery.isNotEmpty ? currentSearchQuery : "",
      saleType: 1,
    );

    if (fetchProductInventoryModel?.products != null) {
      if (fetchProductInventoryModel!.products!.isNotEmpty) {
        final paginationData = fetchProductInventoryModel?.products ?? [];

        // Clear current list to avoid duplication
        if (FetchProductInventoryApi.startPagination == 1) {
          productList.clear();
          if (!isSearching) {
            // Don't clear selected products array here to maintain selections
            staticproductList.clear();
          }
        }

        productList.addAll(paginationData);

        // If not searching, store all products for potential local filtering
        if (!isSearching) {
          if (FetchProductInventoryApi.startPagination == 1) {
            allProductsList.clear();
          }
          allProductsList.addAll(paginationData);
        }

        // Rebuild staticproductList from selectedProductsArray to maintain consistency
        if (!isSearching) {
          staticproductList.clear();
          for (var selectedProduct in selectedProductsArray) {
            staticproductList.add(selectedProduct['productId']);
          }
        }

        // Also check for pre-selected products from API
        for (var product in paginationData) {
          log("product.isSelect------------ ${product.isSelect}");

          if (product.isSelect == true && !staticproductList.contains(product.id)) {
            // Add to both arrays
            staticproductList.add(product.id ?? "");

            Map<String, dynamic> productData = {
              "productId": product.id ?? "",
              "minimumBidPrice": 0,
              "minAuctionTime": 0,
              "productAttributes": [],
              "isAuctionEnabled": false,
            };
            selectedProductsArray.add(productData);
          }
        }

        log("staticproductList------------ $staticproductList");
        log("selectedProductsArray------------ $selectedProductsArray");

        update(["onGetProducts"]);
      } else {
        FetchProductInventoryApi.startPagination--;
      }
    }

    if (productList.isEmpty) {
      update(["onGetProducts"]);
    }
  }

  Future<void> onRefresh() async {
    FetchProductInventoryApi.startPagination = 1;
    productList.clear();
    allProductsList.clear();

    // Maintain search state during refresh
    if (currentSearchQuery.isNotEmpty) {
      isSearching = true;
    } else {
      isSearching = false;
    }

    await fetchProductInventory();
  }

  void showMixedProductToast(Map<String, dynamic> newProductData, InventoryProduct catalogItems) {
    bool newProductHasAuction = newProductData['isAuctionEnabled'] == true;

    int auctionCount = selectedProductsArray.where((product) => product['isAuctionEnabled'] == true).length;
    int nonAuctionCount = selectedProductsArray.where((product) => product['isAuctionEnabled'] != true).length;

    String message;
    if (newProductHasAuction) {
      message = "You have $nonAuctionCount product(s) without auction. Add bid price and duration for all products or remove this one";
    } else {
      message = "You have $auctionCount product(s) with auction enabled. Add bid price and duration for all products or remove this one";
    }

    Utils.showToast(message);
  }

// Updated method to handle product addition with toast validation
  void onAddProductFromBottomSheet(Map<String, dynamic> productData, InventoryProduct catalogItems) {
    // Prepare the complete product data
    Map<String, dynamic> completeProductData = {
      'productId': catalogItems.id ?? '',
      'product': catalogItems,
      'selectedAttributes': productData['selectedAttributes'] ?? {},
      'isAuctionEnabled': productData['isAuctionEnabled'] ?? false,
      'minimumBidPrice': productData['isAuctionEnabled'] == true ? (double.tryParse(productData['minimumBidPrice'] ?? '0') ?? 0) : 0,
      'minAuctionTime': productData['isAuctionEnabled'] == true ? (double.tryParse(productData['minAuctionTime'] ?? '0') ?? 0) : 0,
      'productAttributes': catalogItems.attributes ?? [],
      'price': catalogItems.price,
    };

    if (!validateMixedProducts(completeProductData)) {
      showMixedProductToast(completeProductData, catalogItems);
      return;
    }

    // If validation passes, add the product directly
    addProductToSelection(completeProductData, catalogItems);

    Get.back(); // Close bottom sheet

    Utils.showToast(
      "Product added successfully",
    );

    update(["onGetProducts", "onGetSelectedProducts"]);
  }

  void removeSelectedProduct(int index) {
    staticproductList.remove(selectedProductsArray[index]['productId']);
    selectedProductsArray.removeAt(index);
    Get.back(); // Close the selected products sheet
    update(["onChangeCheckBox", "onGetSelectedProducts"]);
    Utils.showToast(
      "Product removed from selection",
    );
  }

  // Add this method to your SelectProductsForStreamerController class

  /// Update an existing selected product with new data
  void updateSelectedProduct(int index, Map<String, dynamic> updatedData, dynamic product) {
    if (index >= 0 && index < selectedProductsArray.length) {
      // Update the existing product data
      selectedProductsArray[index] = {
        'productId': product.id ?? '', // Add this line
        'product': product,
        'selectedAttributes': updatedData['selectedAttributes'],
        'isAuctionEnabled': updatedData['isAuctionEnabled'],
        'minAuctionTime': updatedData['minAuctionTime'],
        'minimumBidPrice': updatedData['minimumBidPrice'],
      };

      // Trigger UI update
      update(["onGetSelectedProducts", "onChangeCheckBox"]);

      // Optional: Log the update for debugging
      print("Product updated at index $index: ${selectedProductsArray[index]}");
    }
  }

  /// Alternative method if you want to update by product ID instead of index
  void updateSelectedProductById(String productId, Map<String, dynamic> updatedData, dynamic product) {
    int index = selectedProductsArray.indexWhere((item) => (item['product'] as dynamic)?.id == productId);

    if (index != -1) {
      updateSelectedProduct(index, updatedData, product);
    }
  }
// New method to show selected products list
}

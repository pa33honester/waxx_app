import 'package:waxxapp/ApiModel/seller/SellerFollowersModel.dart';
import 'package:waxxapp/ApiModel/seller/SellerReelsModel.dart';
import 'package:waxxapp/Controller/GetxController/user/follow_unfollow_controller.dart';
import 'package:waxxapp/Controller/GetxController/user/new_collection_controller.dart';
import 'package:waxxapp/user_pages/preview_seller_profile_page/api/fetch_seller_profile_api.dart';
import 'package:waxxapp/user_pages/preview_seller_profile_page/model/fetch_seller_profile_model.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class PreviewSellerProfileController extends GetxController with GetTickerProviderStateMixin {
  final followUnFollowController = Get.put(FollowUnFollowController());
  final newCollectionController = Get.put(NewCollectionController());

  RxBool isTabBarPinned = false.obs;
  TabController? tabController;
  bool isChangingTab = false;
  bool isLoadingPost = true;
  bool isLoadingVideo = true;
  bool isLoadingFollower = true;

  ScrollController scrollController = ScrollController();

  int selectedMainTabIndex = 0;

  String sellerId = "";
  bool isLoading = true;
  bool isFollowing = false;
  FetchSellerProfileModel? fetchSellerProfileModel;
  SellerReelsModel? fetchSellerReels;
  SellerFollowersModel? fetchSellerFollowers;

  List<ProductsByCategory> productsByCategory = [];
  List<Product> products = [];
  int selectedTabIndex = 0;
  List<Reel> reels = [];
  List<FollowerList> followersList = [];

  @override
  void onInit() {
    scrollController.addListener(onScrolling);
    // Don't fetch here — setSellerId, which the view calls on every build,
    // is the single entry point for kicking off the profile/reels/followers
    // requests once we know which seller to query.
    super.onInit();
  }

  /// Called by the view on every build with the seller currently being
  /// viewed. On a fresh instance this kicks off the initial fetches; on a
  /// re-entry where Get.put returned a controller still holding the previous
  /// seller's data, this clears state and re-fetches for the new seller.
  void setSellerId(String id) {
    if (id.isEmpty || id == sellerId) return;
    sellerId = id;
    products.clear();
    productsByCategory.clear();
    reels.clear();
    followersList.clear();
    onGetSellerProfile();
    onGetSellerReels();
    onGetSellerFollowers();
  }

  void onScrolling() {
    isTabBarPinned.value = scrollController.hasClients && scrollController.offset > (kToolbarHeight);
  }

  TabController? categoryTabController;

  void onGetSellerProfile() async {
    isLoading = true;
    await 100.milliseconds.delay();
    fetchSellerProfileModel = await FetchSellerProfileApi.callApi(sellerId: sellerId, loginUserId: loginUserId);

    // Clear and populate category-wise data
    productsByCategory.clear();
    productsByCategory.addAll(fetchSellerProfileModel?.data?.productsByCategory ?? []);

    // Set products from first category by default
    products.clear();
    if (productsByCategory.isNotEmpty) {
      products.addAll(productsByCategory[0].products ?? []);
    }

    // Initialize tab controller
    if (productsByCategory.isNotEmpty && tabController == null) {
      categoryTabController = TabController(length: productsByCategory.length, vsync: this);
    }

    isLoading = false;
    isFollowing = fetchSellerProfileModel?.data?.isFollow ?? false;
    update(["onGetSellerProfile"]);
  }

  // Method to handle tab change
  void onChangeTab(int index) {
    selectedTabIndex = index;
    products.clear();
    if (index < productsByCategory.length) {
      products.addAll(productsByCategory[index].products ?? []);
    }
    update(["onGetSellerProfile"]);
  }

  @override
  void onClose() {
    tabController?.dispose();
    super.onClose();
  }

  // void updateProductsForCategory(int categoryIndex) {
  //   selectedCategoryIndex = categoryIndex;
  //   product.clear();
  //
  //   if (productsByCategory.isNotEmpty && categoryIndex < productsByCategory.length) {
  //     product.addAll(productsByCategory[categoryIndex].products ?? []);
  //   }
  //
  //   update(["onGetSellerProfile"]);
  // }

  List<String> getCategoryNames() {
    return productsByCategory.map((category) => category.categoryName ?? "").toList();
  }

  int getTotalProductsCount() {
    int totalCount = 0;
    for (var category in productsByCategory) {
      totalCount += category.products?.length ?? 0;
    }
    return totalCount;
  }

  void onGetSellerReels() async {
    isLoading = true;
    await 100.milliseconds.delay();
    // Reset pagination + clear so this method is idempotent. Without this,
    // calling it again (e.g. to refresh after the user likes a reel in the
    // full-screen viewer) would duplicate the existing entries via addAll.
    FetchSellerProfileApi.startPagination = 1;
    fetchSellerReels = await FetchSellerProfileApi.sellerReelsApi(sellerId: sellerId);
    reels.clear();
    reels.addAll(fetchSellerReels?.reels ?? []);
    print('reels: ${reels.length}');
    isLoading = false;
    // isFollowing = fetchSellerReels?.data?.isFollow ?? false;
    update(["onGetSellerReels"]);
  }

  // Future<void> onGetSellerReels() async {
  //   fetchSellerReels = null;
  //   fetchSellerReels =
  //       await FetchSellerProfileApi.sellerReelsApi(sellerId: sellerId);
  //
  //   if (fetchSellerReels?.reels != null) {
  //     if (fetchSellerReels!.reels!.isNotEmpty) {
  //       reels.addAll(fetchSellerReels?.reels ?? []);
  //       update(["onGetSellerReels"]);
  //     }
  //   }
  //   if (reels.isEmpty) {
  //     update(["onGetSellerReels"]);
  //   }
  // }

  void onGetSellerFollowers() async {
    isLoading = true;
    await 100.milliseconds.delay();
    fetchSellerFollowers = await FetchSellerProfileApi.sellerFollowersApi(sellerId: sellerId);
    followersList.addAll(fetchSellerFollowers?.followerList ?? []);
    isLoading = false;
    // isFollowing = fetchSellerReels?.data?.isFollow ?? false;
    update(["onGetSellerFollowers"]);
  }

  void onChangeFollowButton() async {
    isFollowing = !isFollowing;
    update(["onChangeFollowButton"]);
    followUnFollowController.followUnfollowData(sellerId: sellerId);
  }

  void onClickFavoriteProduct(int index) {
    products[index].isFavorite = !(products[index].isFavorite ?? false);
    update(["onGetSellerProfile"]);
    newCollectionController.postFavoriteData(
      productId: products[index].id ?? "",
      categoryId: products[index].category ?? "",
    );
  }
}

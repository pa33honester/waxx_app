import 'dart:developer';
import 'package:era_shop/ApiModel/user/FavoriteItemsModel.dart';
import 'package:era_shop/ApiService/user/favorite_item_service.dart';
import 'package:get/get.dart';

class ShowFavoriteController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    getFavoriteData();
    super.onInit();
  }

  FavoriteItemsModel? favoriteItems;
  RxBool isLoading = false.obs;

  List<Products> favoriteProducts = [];

  getFavoriteData() async {
    try {
      isLoading(true);
      var data = await FavoriteItemApi().showFavoriteItem();
      favoriteItems = data;
      favoriteProducts.clear();

      for (int i = 0; i < favoriteItems!.favorite!.length; i++) {
        var product = favoriteItems!.favorite![i].product![0];
        log("Category :: ${product.category}");
        favoriteProducts.add(
          Products(
              mainImage: product.mainImage.toString(),
              productName: product.productName.toString(),
              price: product.price.toString(),
              id: product.id.toString(),
              subCategory: product.subCategory.toString()),
        );
      }
    } catch (e) {
      log("Show Favorite Error :: $e");
    } finally {
      isLoading(false);
      log('Show Favorite Data');
    }
  }
}

class Products {
  final String mainImage;
  final String productName;
  final String price;
  final String id;
  final String subCategory;

  Products(
      {required this.productName,
      required this.price,
      required this.mainImage,
      required this.id,
      required this.subCategory});
}

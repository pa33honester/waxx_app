import 'dart:developer';
import 'package:waxxapp/ApiModel/user/AddToFavoriteModel.dart';
import 'package:waxxapp/ApiService/user/add_to_favorite_service.dart';
import 'package:get/get.dart';
import 'package:waxxapp/ApiModel/user/GetNewCollectionModel.dart';
import 'package:waxxapp/ApiService/user/get_new_collection_service.dart';

class NewCollectionController extends GetxController {
  GetNewCollectionModel? getNewCollection;
  AddToFavoriteModel? addToFavorite;
  RxBool isLoading = false.obs;

  final List<bool> likes = List.generate(1000000, (_) => true);

  Future getNewCollectionData() async {
    try {
      isLoading(true);
      getNewCollection = await GetNewCollectionApi().showCategory();
      update();
    } catch (e) {
      log('New Collection Error: $e');
    } finally {
      isLoading(false);
      update();
      log('New Collection finally');
    }
  }

  postFavoriteData({
    required String productId,
    required String categoryId,
  }) async {
    try {
      var data = await AddToFavoriteApi().addToFavorite(
        productId: productId,
        categoryId: categoryId,
      );
      addToFavorite = data;
    } finally {
      log('Add to Favorite finally');
    }
  }

  likeDislike(index) {
    likes[index] = !likes[index];
    update();
  }
}

import 'package:era_shop/user_pages/popular_products_page/model/popular_product_model.dart';
import 'package:era_shop/user_pages/popular_products_page/api/popular_products_api.dart';
import 'package:get/get.dart';

class PopularProductsController extends GetxController {
  PopularProductModel? popularProductModel;
  List<PopularProducts> popularProducts = [];
  RxBool isLoading = false.obs;

  Future<void> onGetPopularProduct() async {
    try {
      isLoading.value = true;

      popularProductModel = null;
      popularProductModel = await PopularProductApi.callApi();

      print('POPLAR PRODUCTS :: ${popularProductModel}');

      if (popularProductModel?.data != null) {
        if (popularProductModel!.data!.isNotEmpty) {
          popularProducts.clear();
          popularProducts.addAll(popularProductModel?.data ?? []);
        }
      }
    } catch (e) {
      print('Error fetching popular products: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    onGetPopularProduct();
    super.onInit();
  }
}

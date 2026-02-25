import 'package:era_shop/ApiModel/seller/LiveProductSelect.dart';
import 'package:era_shop/ApiService/seller/live_product_select_service.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:get/get.dart';

class LiveSelectProductController extends GetxController {
  LiveProductSelect? liveProductSelect;
  var isLoading = true.obs;

  getSelectedProductData() async {
    try {
      isLoading(true);
      update();
      var data = await LiveProductSelectApi().liveProductSelect(productId: productId);
      liveProductSelect = data;
    } finally {
      isLoading(false);
    }
  }
}

import 'dart:developer';
import 'package:era_shop/ApiModel/seller/DeleteCatalogBySellerModel.dart';
import 'package:era_shop/ApiService/seller/delete_catalog_api.dart';
import 'package:era_shop/seller_pages/seller_catalogs_page/view/seller_catalogs_view.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:era_shop/utils/show_toast.dart';
import 'package:get/get.dart';

class DeleteCatalogController extends GetxController {
  DeleteCatalogBySellerModel? deleteCatalogBySeller;
  RxBool isLoading = true.obs;

  getDeleteData() async {
    try {
      displayToast(message: St.pleaseWaitToast.tr);
      isLoading(true);
      var data = await DeleteCatalogApi().deleteCatalog(productId: productId);
      deleteCatalogBySeller = data;
      if (deleteCatalogBySeller!.status == true) {
        displayToast(message: "Catalog Delete Successfully");
        Get.off(const SellerCatalogsView(), transition: Transition.leftToRight);
      } else {
        displayToast(message: St.somethingWentWrong.tr);
      }
    } finally {
      isLoading(false);
      log('Delete Catalog finally');
    }
  }
}

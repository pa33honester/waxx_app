import 'dart:developer';
import 'package:waxxapp/ApiModel/seller/DeleteCatalogBySellerModel.dart';
import 'package:waxxapp/ApiService/seller/delete_catalog_api.dart';
import 'package:waxxapp/seller_pages/seller_catalogs_page/view/seller_catalogs_view.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/show_toast.dart';
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

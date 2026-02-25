import 'dart:developer';
import 'package:era_shop/ApiService/seller/seller_data_service.dart';
import 'package:era_shop/utils/database.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:get/get.dart';

import '../../../ApiModel/seller/seller_data_model.dart';
import '../../GetxController/user/SocketManager/socket_manager_controller.dart';

class SellerDataController extends GetxController {
  SellerDataModel? sellerAllData;
  var isLoading = false.obs;
  RxBool loadingForDemoSeller = false.obs;

  getSellerAllData() async {
    try {
      isLoading(true);
      var data = await SellerDataApi().sellerData();
      sellerAllData = data;
      print('SELLER DATA :: ${sellerAllData?.seller?.businessName ?? ''}');
      if (sellerAllData!.isAccepted == true) {
        sellerEditImage = sellerAllData!.seller!.image.toString();
        sellerFollower = sellerAllData!.seller!.followers.toString();
        //------------------------------------------------------------------------
        editBusinessName = sellerAllData?.seller?.businessName ?? '';
        editBusinessTag = sellerAllData?.seller?.businessTag ?? '';
        editPhoneNumber = sellerAllData?.seller?.mobileNumber ?? '';
        editSellerAddress = sellerAllData?.seller?.address?.address ?? '';
        editLandmark = sellerAllData?.seller?.address?.landMark ?? '';
        editCity = sellerAllData?.seller?.address?.city ?? '';
        editPinCode = sellerAllData?.seller?.address?.pinCode.toString() ?? '';
        editState = sellerAllData?.seller?.address?.state ?? '';
        editCountry = sellerAllData?.seller?.address?.country ?? '';
        editBankName = sellerAllData?.seller?.bankDetails?.bankName ?? '';
        editAccNumber = sellerAllData?.seller?.bankDetails?.accountNumber.toString() ?? '';
        editIfsc = sellerAllData?.seller?.bankDetails?.iFSCCode ?? '';
        editBranch = sellerAllData?.seller?.bankDetails?.branchName ?? '';
        //--------------------------------------------------------------------------
        sellerId = sellerAllData!.seller!.id.toString();
        Database.onSetSellerId(sellerAllData?.seller?.id ?? "");
        log("SSSSSSSSSSSSSSSSSSSSSeller ID $sellerId ");
        log("SSSSSSSSSSSSSSSSSSSSSeller ID ${Database.sellerId} ");
      }
    } finally {
      isLoading(false);
    }
  }

  getDemoSellerData() async {
    try {
      loadingForDemoSeller(true);
      var data = await SellerDataApi().sellerData();
      sellerAllData = data;
      if (sellerAllData!.isAccepted == true) {
        Get.toNamed("/SellerProfile");
        sellerEditImage = sellerAllData!.seller!.image.toString();
        sellerFollower = sellerAllData!.seller!.followers.toString();
        //------------------------------------------------------------------------
        editBusinessName = sellerAllData!.seller!.businessName.toString();
        editBusinessTag = sellerAllData!.seller!.businessTag.toString();
        editPhoneNumber = sellerAllData!.seller!.mobileNumber.toString();
        editSellerAddress = sellerAllData!.seller!.address!.address.toString();
        editLandmark = sellerAllData!.seller!.address!.landMark.toString();
        editCity = sellerAllData!.seller!.address!.city.toString();
        editPinCode = sellerAllData!.seller!.address!.pinCode.toString();
        editState = sellerAllData!.seller!.address!.state.toString();
        editCountry = sellerAllData!.seller!.address!.country.toString();
        editBankName = sellerAllData!.seller!.bankDetails!.bankName.toString();
        editAccNumber = sellerAllData!.seller!.bankDetails!.accountNumber.toString();
        editIfsc = sellerAllData!.seller!.bankDetails!.iFSCCode.toString();
        editBranch = sellerAllData!.seller!.bankDetails!.branchName.toString();
        //--------------------------------------------------------------------------
        sellerId = sellerAllData!.seller!.id.toString();
        Database.onSetSellerId(sellerAllData?.seller?.id ?? "");
        log("SSSSSSSSSSSSSSSSSSSSSeller ID $sellerId ");
      }
    } finally {
      loadingForDemoSeller(false);
    }
  }
}

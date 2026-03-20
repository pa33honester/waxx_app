import 'dart:developer';
import 'package:waxxapp/ApiModel/seller/get_all_bank_model.dart';
import 'package:waxxapp/Controller/ApiControllers/seller/api_seller_edit_profile_controller.dart';
import 'package:waxxapp/Controller/GetxController/user/user_add_address_controller.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/show_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../ApiService/seller/get_bank_name_service.dart';

class SellerEditProfileController extends GetxController {
  GetAllBankModel? getAllBankModel;
  List<String> bankList = [];

  SellerEditController sellerEditController = Get.put(SellerEditController());

  TextEditingController editBusinessNameController = TextEditingController(text: editBusinessName);
  TextEditingController editBusinessTagController = TextEditingController(text: editBusinessTag);
  TextEditingController editSellerAddressController = TextEditingController(text: editSellerAddress);
  TextEditingController editLandmarkController = TextEditingController(text: editLandmark);
  TextEditingController editCityController = TextEditingController(text: editCity);
  TextEditingController editPinCodeController = TextEditingController(text: editPinCode);
  TextEditingController editStateController = TextEditingController(text: editState);
  TextEditingController editCountryController = TextEditingController(text: editCountry);
  // final TextEditingController editBankBusinessNameController = TextEditingController();
  TextEditingController editBankNameController = TextEditingController(text: editBankName);
  TextEditingController editAccNumberController = TextEditingController(text: editAccNumber);
  TextEditingController editIfscController = TextEditingController(text: editIfsc);
  TextEditingController editBranchController = TextEditingController(text: editBranch);

  final UserAddAddressController userAddAddressController = Get.put(UserAddAddressController());

  TextEditingController countryController = TextEditingController(text: editCountry);
  TextEditingController stateCountroller = TextEditingController(text: editState);
  TextEditingController cityCountroller = TextEditingController(text: editCity);

  @override
  void onInit() {
    // TODO: implement onInit
    getBankName();
    super.onInit();
  }

  getBankName() async {
    getAllBankModel = await GetBankService().getBank();
    if (getAllBankModel != null) {
      for (var element in getAllBankModel!.bank!) {
        bankList.add(element.name!);
        log("message${element.name!}");
      }
      update();
    }
  }

  sellerEditProfile() async {
    editBusinessName = editBusinessNameController.text;
    editBusinessTag = editBusinessTagController.text;
    editSellerAddress = editSellerAddressController.text;
    editLandmark = editLandmarkController.text;
    editCity = cityCountroller.text;
    editPinCode = editPinCodeController.text;
    editState = stateCountroller.text;
    editCountry = countryController.text;
    editBankName = editBankNameController.text;
    editAccNumber = editAccNumberController.text;
    editIfsc = editIfscController.text;
    editBranch = editBranchController.text;
    displayToast(message: St.pleaseWaitToast.tr);

    await sellerEditController.getEditProfileData(
        // image: sellerImageXFile == null ? sellerEditImage : sellerImageXFile.toString(),
        businessName: editBusinessName,
        businessTag: editBusinessTag,
        address: editSellerAddress,
        landMark: editLandmark,
        city: editCity,
        pinCode: editPinCode,
        state: editState,
        country: editCountry,
        bankName: editBankName,
        accountNumber: editAccNumber,
        IFSCCode: editIfsc,
        branchName: editBranch);
    log("status:${sellerEditController.sellerEditProfileData?.status}");
    if (sellerEditController.sellerEditProfileData?.status == true) {
      // sellerEditImage = sellerEditController.sellerEditProfileData!.seller!.image.toString();
      // update();
      displayToast(message: St.saveChanges.tr);
    } else {
      displayToast(message: St.somethingWentWrong.tr);
    }
  }
}

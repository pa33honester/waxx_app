import 'package:era_shop/custom/loading_ui.dart';
import 'package:era_shop/seller_pages/seller_wallet_page/api/fetch_withdraw_method_api.dart';
import 'package:era_shop/seller_pages/seller_wallet_page/api/seller_create_withdraw_request_api.dart';
import 'package:era_shop/seller_pages/seller_wallet_page/api/seller_wallet_history_api.dart';
import 'package:era_shop/seller_pages/seller_wallet_page/dialog/confirm_withdraw_dialog.dart';
import 'package:era_shop/seller_pages/seller_wallet_page/model/create_withdraw_request_model.dart';
import 'package:era_shop/seller_pages/seller_wallet_page/model/fetch_seller_history_model.dart';
import 'package:era_shop/seller_pages/seller_wallet_page/model/fetch_withdraw_list_model.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/Theme/theme_service.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/show_toast.dart';

class SellerWalletController extends GetxController {
  TextEditingController amountController = TextEditingController();
  bool isLoading = false;
  List<Withdraw> withdrawMethods = [];
  FetchWithdrawListModel? fetchWithdrawListModel;

  int? selectedPaymentMethod;
  bool isShowPaymentMethod = false;

  List<TextEditingController> withdrawPaymentDetails = [];

  CreateWithdrawRequestModel? createWithdrawRequestModel;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  Future<void> init() async {
    await onGetWithdrawMethods();
    onGetWalletHistory();
    update(["onGetWithdrawMethods"]);
  }

  Future<void> onGetWithdrawMethods() async {
    isLoading = true;
    fetchWithdrawListModel = await FetchWithdrawMethodApi.callApi();
    if (fetchWithdrawListModel?.withdraw != null) {
      withdrawMethods.addAll(fetchWithdrawListModel?.withdraw ?? []);
      isLoading = false;
      update(["onGetWithdrawMethods"]);
    }
  }

  Future<void> onSwitchWithdrawMethod() async {
    isShowPaymentMethod = !isShowPaymentMethod;
    update(["onSwitchWithdrawMethod", "onChangePaymentMethod"]);
  }

  Future<void> onChangePaymentMethod(int index) async {
    selectedPaymentMethod = index;
    if (isShowPaymentMethod) {
      onSwitchWithdrawMethod();
    }
    withdrawPaymentDetails = List<TextEditingController>.generate(withdrawMethods[index].details?.length ?? 0, (counter) => TextEditingController());

    update(["onChangePaymentMethod"]);
  }

  Future<void> onClickWithdraw() async {
    if (getStorage.read("isDemoLogin") ?? false || isDemoSeller) {
      displayToast(message: St.thisIsDemoUser.tr);
      return;
    }
    bool isWithdrawDetailsEmpty = false;
    for (int i = 0; i < withdrawPaymentDetails.length; i++) {
      if (withdrawPaymentDetails[i].text.isEmpty) {
        isWithdrawDetailsEmpty = true;
      } else {
        isWithdrawDetailsEmpty = false;
      }
    }

    if (amountController.text.trim().isEmpty) {
      Utils.showToast(St.pleaseEnterWithdrawCoin.tr);
    } else if (int.parse(amountController.text) < (minPayout)) {
      Utils.showToast(St.withdrawalRequestedCoinMustBeGreaterThanSpecifiedByTheAdmin.tr);
    } else if (int.parse(amountController.text) > (totalAmount ?? 0)) {
      Utils.showToast(St.theUserDoesNotHaveSufficientFundsToMakeTheWithdrawal.tr);
    } else if (selectedPaymentMethod == null) {
      Utils.showToast(St.pleaseSelectWithdrawMethod.tr);
    } else if (isWithdrawDetailsEmpty) {
      Utils.showToast(St.pleaseEnterAllPaymentDetails.tr);
    } else {
      ConfirmWithdrawDialogUi.onShow(() => onWithdraw());
    }
  }

  Future<void> onWithdraw() async {
    Get.dialog(const LoadingUi(), barrierDismissible: false); // Start Loading...
    List<String> details = [];

    for (int i = 0; i < withdrawMethods[selectedPaymentMethod ?? 0].details!.length; i++) {
      details.add("${withdrawMethods[selectedPaymentMethod ?? 0].details![i]}:${withdrawPaymentDetails[i].text}");
    }

    await 1.seconds.delay();

    createWithdrawRequestModel = await SellerCreateWithdrawRequestApi.callApi(
      sellerId: sellerId,
      amount: amountController.text,
      paymentGateway: withdrawMethods[selectedPaymentMethod ?? 0].name ?? "",
      paymentDetails: details,
    );

    if (createWithdrawRequestModel?.status ?? false) {
      Utils.showToast(createWithdrawRequestModel?.message ?? "");
    } else {
      Utils.showToast(createWithdrawRequestModel?.message ?? "");
    }

    Get.close(3); // Stop Loading / Close Dialog / Close Withdraw Page...
  }

  //---------- Seller Wallet History ---------

  bool isLoading1 = false;
  List<Datum> walletHistory = [];
  FetchSellerWalletHistoryModel? fetchSellerWalletHistory;
  int? totalAmount = 0;

  String startDate = "All";
  String endDate = "All"; // This is Send on Api....

  String rangeDate = "All"; // This is Show on UI....

  Future<void> onGetWalletHistory() async {
    isLoading1 = true;
    walletHistory.clear();
    update(["onGetWalletHistory", "onGetWithdrawMethods"]);
    fetchSellerWalletHistory = await FetchSellerWalletHistoryApi.callApi(sellerId: sellerId, startDate: startDate, endDate: endDate);
    totalAmount = fetchSellerWalletHistory?.totalAmount;
    print('TotalAmount ${totalAmount}');

    if (fetchSellerWalletHistory?.data != null) {
      walletHistory.clear();
      walletHistory.addAll(fetchSellerWalletHistory?.data ?? []);
      isLoading1 = false;
      update(["onGetWalletHistory", "onGetWithdrawMethods"]);
    }
  }

  Future<void> onChangeDate({required String startDate, required String endDate, required String rangeDate}) async {
    this.startDate = startDate;
    this.endDate = endDate;
    this.rangeDate = rangeDate;
    update(["onChangeDate"]);
  }
}

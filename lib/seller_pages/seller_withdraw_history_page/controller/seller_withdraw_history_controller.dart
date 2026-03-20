import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:get/get.dart';
import '../../seller_wallet_page/model/fetch_withdraw_history_model.dart';
import '../api/fetch_seller_withdraw_history_api.dart';

class SellerWithdrawHistoryController extends GetxController {
  bool isLoading = false;
  List<Datum> withdrawHistory = [];
  FetchSellerWithdrawHistory? fetchSellerWithdrawHistory;

  String startDate = "All";
  String endDate = "All"; // This is Send on Api....

  String rangeDate = "All"; // This is Show on UI....

  @override
  void onInit() {
    init();
    super.onInit();
  }

  Future<void> init() async {
    onGetWithdrawHistory();
    Utils.showLog("My Wallet Page Controller Initialize Success");
  }

  Future<void> onGetWithdrawHistory() async {
    isLoading = true;
    withdrawHistory.clear();
    update(["onGetWithdrawHistory"]);
    fetchSellerWithdrawHistory = await FetchSellerWithdrawHistoryApi.callApi(sellerId: sellerId, startDate: startDate, endDate: endDate);

    if (fetchSellerWithdrawHistory?.data != null) {
      withdrawHistory.clear();
      withdrawHistory.addAll(fetchSellerWithdrawHistory?.data ?? []);
      isLoading = false;
      update(["onGetWithdrawHistory"]);
    }
  }

  Future<void> onChangeDate({required String startDate, required String endDate, required String rangeDate}) async {
    this.startDate = startDate;
    this.endDate = endDate;
    this.rangeDate = rangeDate;
    update(["onChangeDate"]);
  }
}

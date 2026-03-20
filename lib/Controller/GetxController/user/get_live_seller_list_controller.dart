import 'dart:developer';
import 'package:waxxapp/ApiModel/user/GetLiveSellerListModel.dart';
import 'package:waxxapp/ApiService/user/get_live_seller_list_service.dart';
import 'package:waxxapp/utils/database.dart';
import 'package:get/get.dart';

class GetLiveSellerListController extends GetxController {
  SellerLiveStreamListModel? getLiveSeller;
  RxBool isLoading = true.obs;
  RxBool moreLoading = false.obs;
  RxBool loadOrNot = true.obs;

  int start = 1;
  int limit = 12;

  List<LiveSeller> getSellerLiveList = [];

  Future getSellerList() async {
    try {
      isLoading(true);
      loadOrNot(true);
      start = 1;
      getLiveSeller = await LiveSellerListService().getLiveSellerList(start: "$start", limit: "$limit", userId: Database.loginUserId);

      if (getLiveSeller!.status == true) {
        getSellerLiveList.clear();
        getSellerLiveList.addAll(getLiveSeller?.liveSeller ?? []);

        print("LIVE SELLER :: ${getSellerLiveList.length}");
        start++;
        update();
      }
      if (getLiveSeller!.status == false) {
        loadOrNot(false);
      }
    } finally {
      isLoading(false);
      log('Get Live Seller List Finally(Service)');
    }
  }

  Future sellerListAfterLive() async {
    try {
      isLoading(true);
      var data = await LiveSellerListService().getLiveSellerList(start: "1", limit: "12", userId: Database.loginUserId);
      getLiveSeller = data;
      if (getLiveSeller!.status == true) {
        log("list 2");
        getSellerLiveList.clear();
        getSellerLiveList.addAll(getLiveSeller!.liveSeller ?? []);
        update();
      } else {
        getSellerLiveList.clear();
      }
    } finally {
      isLoading(false);
      log('Get Live Seller List Finally(Service)');
    }
  }

  Future loadMoreData() async {
    try {
      moreLoading(true);
      loadOrNot(true);
      var data = await LiveSellerListService().getLiveSellerList(start: "$start", limit: "$limit", userId: Database.loginUserId);
      if (data!.status == true) {
        log("list 3");
        getSellerLiveList.addAll(data.liveSeller ?? []);
        start++;
        update();
      }
      if (data.liveSeller!.isEmpty) {
        loadOrNot(false);
      }
    } finally {
      moreLoading(false);
      log('Load more data finally');
    }
  }
}

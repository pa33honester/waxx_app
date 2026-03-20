import 'package:waxxapp/Controller/GetxController/user/user_product_details_controller.dart';
import 'package:waxxapp/user_pages/user_auction_bid/api/user_auction_bid_api.dart';
import 'package:waxxapp/user_pages/user_auction_bid/model/product_wise_user_auction_bid_model.dart';
import 'package:waxxapp/user_pages/user_auction_bid/model/user_auction_bid_model.dart';
import 'package:waxxapp/utils/app_constant.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/show_toast.dart';
import 'package:get/get.dart';

class UserAuctionBidController extends GetxController {
  UserAuctionBidModel? userAuctionBidModel;
  List<Product>? bids;
  RxBool isLoading = true.obs;
  RxBool isLoading1 = true.obs;
  UserProductDetailsController userProductDetailsController = Get.put(UserProductDetailsController());

  ProductWiseUserAuctionBidModel? productWiseUserAuctionBidModel;
  List<Bid>? bidList;

  getUserAuctionBidData() async {
    try {
      isLoading(true);
      update([AppConstant.idGetUserBid]);
      var data = await UserAuctionBidApi().userAuctionBid(userId: loginUserId);
      userAuctionBidModel = data;
      bids?.addAll(userAuctionBidModel?.products ?? []);
      print('USER AUCTION BID DATA SUCCESS :: ${userAuctionBidModel?.products}\n $bids');
    } catch (e) {
      displayToast(message: e.toString());
    } finally {
      isLoading(false);
      update([AppConstant.idGetUserBid]);
      print('USER AUCTION BID DATA :: ${userAuctionBidModel?.products}');
    }
  }

  getProductWiseUserAuctionBidData(String productId) async {
    try {
      isLoading1(true);
      update([AppConstant.idGetUserBid1]);
      var data = await UserAuctionBidApi().productWiseUserAuctionBid(productId: productId);
      productWiseUserAuctionBidModel = data;
      bidList?.addAll(productWiseUserAuctionBidModel?.bids ?? []);
      print('PRODUCT WISE USER AUCTION BID LIST SUCCESS :: ${productWiseUserAuctionBidModel?.bids}\n $bidList');
    } catch (e) {
      displayToast(message: e.toString());
    } finally {
      isLoading1(false);
      update([AppConstant.idGetUserBid1]);
      print('PRODUCT WISE USER AUCTION BID DATA :: ${productWiseUserAuctionBidModel?.bids}');
    }
  }

  @override
  void onInit() {
    getUserAuctionBidData();
    // getProductWiseUserAuctionBidData();
    super.onInit();
  }
}

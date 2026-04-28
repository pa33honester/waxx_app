import 'package:get/get.dart';
import 'package:waxxapp/ApiModel/user/GetLiveSellerListModel.dart';
import 'package:waxxapp/Controller/GetxController/user/get_live_seller_list_controller.dart';

/// Helpers for entry points that want to open the buyer-side live page in
/// Reels-style swipe mode. Resolve the surrounding peer list (and starting
/// index) for a single tapped [LiveSeller] so the user can swipe vertically
/// between currently-live shows.
///
/// The peer list comes from [GetLiveSellerListController.getSellerLiveList],
/// which the home grid + home rail + live hub already keep populated. If the
/// tapped live isn't in that list (e.g. a deep-link share-tap to a show the
/// fetched page didn't include), fall back to a single-item list so the
/// swipe view degrades to the same UX as today (one show, no peers).
class LiveSwipeResolver {
  static List<LiveSeller> swipeListFor(LiveSeller tapped) {
    if (Get.isRegistered<GetLiveSellerListController>()) {
      final list = Get.find<GetLiveSellerListController>().getSellerLiveList;
      if (list.isNotEmpty &&
          list.any((e) => e.liveSellingHistoryId == tapped.liveSellingHistoryId)) {
        return list;
      }
    }
    return [tapped];
  }

  static int swipeIndexFor(LiveSeller tapped) {
    if (!Get.isRegistered<GetLiveSellerListController>()) return 0;
    final list = Get.find<GetLiveSellerListController>().getSellerLiveList;
    final idx = list.indexWhere(
      (e) => e.liveSellingHistoryId == tapped.liveSellingHistoryId,
    );
    return idx >= 0 ? idx : 0;
  }
}

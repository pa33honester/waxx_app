import 'dart:developer';
import 'package:waxxapp/ApiModel/seller/GetReelsForUserModel.dart';
import 'package:waxxapp/ApiModel/user/report_reason_model.dart';
import 'package:waxxapp/ApiModel/user/report_reel_model.dart';
import 'package:waxxapp/ApiService/user/report_service.dart';
import 'package:waxxapp/View/MyApp/AppPages/reels_page/api/fetch_reels_api.dart';
import 'package:waxxapp/utils/branch_io_services.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:get/get.dart';
import 'package:preload_page_view/preload_page_view.dart';

class ReelsController extends GetxController {
  PreloadPageController preloadPageController = PreloadPageController();

  bool isLoadingReels = false;
  GetReelsForUserModel? getReelsForUserModel;

  //==== Report Reason ======
  ReportReasonModel? reportReasonModel;
  Report? selectedReport;
  ReportReelModel? reportReelModel;

  bool isPaginationLoading = false;

  List<Reel> mainReels = [];

  int currentPageIndex = 0;

  /// App-wide reels audio mute preference. Mirrors the TikTok / IG Reels
  /// pattern: once a viewer mutes, every subsequent reel stays muted until
  /// they explicitly unmute. Each reel widget reads this on init and on
  /// every change, calling `videoPlayerController.setVolume(...)` accordingly.
  RxBool isMuted = false.obs;

  void toggleReelsMute() {
    isMuted.value = !isMuted.value;
  }

  bool isInitAlreadyCall = false;

  // Future<void> init() async {
  //   currentPageIndex = 0;
  //   mainReels.clear();
  //   FetchReelsApi.startPagination = 0;
  //   isLoadingReels = true;
  //   await onGetReels();
  //   isLoadingReels = false;
  // }

  Future<void> init({int initialIndex = 0}) async {
    if (isInitAlreadyCall) return;
    isInitAlreadyCall = true;
    log('ENIT :: ');
    currentPageIndex = initialIndex;

    // Warm-cache path: if we already loaded reels in a previous visit
    // (controller is permanent, so the in-memory list survives tab
    // switches), reuse them. The user sees the feed instantly; we
    // refresh in the background so a stale list converges to fresh data.
    if (mainReels.isNotEmpty) {
      preloadPageController = PreloadPageController(
        initialPage: initialIndex.clamp(0, mainReels.length - 1).toInt(),
      );
      // Don't flip isLoadingReels — the page renders straight away.
      isInitAlreadyCall = false;
      // Background refresh: refetch the first page silently and replace
      // the cached list when the response lands. Quiet-fail on error.
      _refreshFirstPageInBackground();
      return;
    }

    // Cold path: full shimmer until the first response lands.
    mainReels.clear();
    FetchReelsApi.startPagination = 0;
    preloadPageController = PreloadPageController(initialPage: initialIndex);
    isLoadingReels = true;

    await onGetReels();
    isLoadingReels = false;
    isInitAlreadyCall = false;
  }

  Future<void> _refreshFirstPageInBackground() async {
    try {
      final saved = FetchReelsApi.startPagination;
      FetchReelsApi.startPagination = 0;
      final fresh = await FetchReelsApi.callApi(
        loginUserId: loginUserId,
        reelId: BranchIoServices.eventId,
      );
      if (fresh?.reels != null && fresh!.reels!.isNotEmpty) {
        mainReels
          ..clear()
          ..addAll(fresh.reels!);
        update(["onGetReels"]);
      } else {
        // Restore prior pagination cursor if the silent refresh failed.
        FetchReelsApi.startPagination = saved;
      }
    } catch (e) {
      log('reels background refresh error: $e');
    }
  }

  void onPagination(int value) async {
    log("************** $value  - --------- ${mainReels.length - 1}");

    if ((mainReels.length - 1) == value) {
      if (isPaginationLoading == false) {
        isPaginationLoading = true;
        update(["onPagination"]);
        await onGetReels();
        isPaginationLoading = false;
        update(["onPagination"]);
      }
    }
  }

  void onChangePage(int index) async {
    currentPageIndex = index;
    update(["onChangePage"]);
  }

  Future<void> onGetReels() async {
    getReelsForUserModel = null;
    getReelsForUserModel = await FetchReelsApi.callApi(loginUserId: loginUserId, reelId: BranchIoServices.eventId);

    log("Get Reels Pagination Shorts Video Length => ${getReelsForUserModel?.reels?.length} ");

    if (getReelsForUserModel?.reels != null) {
      if (getReelsForUserModel!.reels!.isNotEmpty) {
        mainReels.addAll(getReelsForUserModel?.reels ?? []);
        update(["onGetReels"]);
      }
    }
    if (mainReels.isEmpty) {
      update(["onGetReels"]);
    }

    if (getReelsForUserModel?.reels?.isEmpty == true) {
      FetchReelsApi.startPagination--;
    }
  }

  getReportReason() async {
    try {
      // isLoading(true);
      var data = await ReportService().getReportReason();
      reportReasonModel = data;
    } catch (e) {
      log('Previous Api controller Error: $e');
    } finally {
      // isLoading(false);
      log('Get Review Details finally');
    }
  }

  void selectReportReason(Report? report) {
    selectedReport = report;
    update();
  }

  Future reportReel({
    required String userId,
    required String reelId,
    required String description,
  }) async {
    try {
      var data = await ReportService().reportReel(
        userId: loginUserId,
        reelId: reelId,
        description: description,
      );
      reportReelModel = data;
      if (reportReelModel!.status == true) {
        Utils.showToast(reportReelModel?.message ?? '');
        Get.back();
      } else {
        Utils.showToast(reportReelModel?.message ?? '');
      }
    } catch (e) {
      log('User Add Address Error: $e');
    } finally {
      log('User Add Address Finally');
    }
  }

  @override
  void onInit() {
    getReportReason();
    super.onInit();
  }
}

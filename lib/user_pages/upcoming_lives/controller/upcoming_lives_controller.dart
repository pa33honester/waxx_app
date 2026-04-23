import 'dart:developer';

import 'package:waxxapp/ApiModel/user/upcoming_lives_model.dart';
import 'package:waxxapp/ApiService/user/upcoming_lives_service.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:get/get.dart';

class UpcomingLivesController extends GetxController {
  RxList<UpcomingLive> upcomingLives = <UpcomingLive>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUpcomingLives();
  }

  Future<void> fetchUpcomingLives() async {
    try {
      isLoading(true);
      final result = await UpcomingLivesService().getUpcomingLives(userId: loginUserId);
      if (result.status == true) {
        upcomingLives.value = result.data ?? [];
      }
    } catch (e) {
      log('FetchUpcomingLives error: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> toggleReminder(UpcomingLive live) async {
    final idx = upcomingLives.indexWhere((l) => l.id == live.id);
    if (idx == -1) return;

    final wasSet = upcomingLives[idx].hasReminder == true;
    upcomingLives[idx] = UpcomingLive(
      id: live.id,
      sellerId: live.sellerId,
      sellerName: live.sellerName,
      sellerImage: live.sellerImage,
      title: live.title,
      description: live.description,
      scheduledAt: live.scheduledAt,
      hasReminder: !wasSet,
    );
    upcomingLives.refresh();

    final service = UpcomingLivesService();
    final success = wasSet
        ? await service.cancelReminder(userId: loginUserId, scheduleId: live.id ?? '')
        : await service.setReminder(userId: loginUserId, scheduleId: live.id ?? '');

    if (!success) {
      upcomingLives[idx] = UpcomingLive(
        id: live.id,
        sellerId: live.sellerId,
        sellerName: live.sellerName,
        sellerImage: live.sellerImage,
        title: live.title,
        description: live.description,
        scheduledAt: live.scheduledAt,
        hasReminder: wasSet,
      );
      upcomingLives.refresh();
      Utils.showToast('Something went wrong');
    } else {
      Utils.showToast(wasSet ? 'Reminder cancelled' : 'Reminder set!');
    }
  }
}

import 'dart:developer';

import 'package:waxxapp/ApiModel/seller/scheduled_live_model.dart';
import 'package:waxxapp/ApiService/seller/schedule_live_service.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScheduleLiveController extends GetxController {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  RxBool isLoading = false.obs;
  Rx<DateTime?> selectedDateTime = Rx<DateTime?>(null);
  RxList<ScheduledLive> scheduledLives = <ScheduledLive>[].obs;
  RxBool isListLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchScheduledLives();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  Future<void> fetchScheduledLives() async {
    try {
      isListLoading(true);
      final result = await ScheduleLiveService().getScheduledLivesBySeller(sellerId: sellerId);
      if (result.status == true) {
        scheduledLives.value = result.data ?? [];
      }
    } catch (e) {
      log('FetchScheduledLives error: $e');
    } finally {
      isListLoading(false);
    }
  }

  Future<void> scheduleShow() async {
    if (titleController.text.trim().isEmpty) {
      Utils.showToast('Please enter a title');
      return;
    }
    if (selectedDateTime.value == null) {
      Utils.showToast('Please select a date and time');
      return;
    }
    if (selectedDateTime.value!.isBefore(DateTime.now())) {
      Utils.showToast('Please select a future date and time');
      return;
    }

    try {
      isLoading(true);
      final result = await ScheduleLiveService().scheduleLive(
        sellerId: sellerId,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        scheduledAt: selectedDateTime.value!,
      );
      if (result.status == true) {
        Utils.showToast('Show scheduled successfully!');
        titleController.clear();
        descriptionController.clear();
        selectedDateTime.value = null;
        await fetchScheduledLives();
        Get.back();
      } else {
        Utils.showToast(result.message ?? 'Failed to schedule show');
      }
    } catch (e) {
      Utils.showToast('Something went wrong');
      log('ScheduleShow error: $e');
    } finally {
      isLoading(false);
    }
  }
}

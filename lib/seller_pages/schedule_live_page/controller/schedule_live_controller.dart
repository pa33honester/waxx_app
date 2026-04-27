import 'dart:developer';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
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
  // Optional cover image picked by the seller. Multipart-uploaded by the
  // service when present; the backend stores the URL on the ScheduledLive
  // doc and returns it in the upcoming-shows feed.
  Rx<File?> selectedImage = Rx<File?>(null);
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

  Future<void> pickCoverImage({required bool fromGallery}) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: fromGallery ? ImageSource.gallery : ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1280,
      );
      if (picked == null) return;
      selectedImage.value = File(picked.path);
    } catch (e) {
      log('pickCoverImage error: $e');
      Utils.showToast('Could not pick image');
    }
  }

  void clearCoverImage() {
    selectedImage.value = null;
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
        coverImage: selectedImage.value,
      );
      if (result.status == true) {
        Utils.showToast('Show scheduled successfully!');
        titleController.clear();
        descriptionController.clear();
        selectedDateTime.value = null;
        selectedImage.value = null;
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

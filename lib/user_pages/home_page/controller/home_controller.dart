import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxBool isTabBarPinned = false.obs;

  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    scrollController.addListener(onScrolling);
    super.onInit();
  }

  void onScrolling() {
    isTabBarPinned.value = scrollController.hasClients && scrollController.offset > (kToolbarHeight);
  }
}

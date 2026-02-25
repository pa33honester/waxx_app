import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    scrollController.addListener(onScrolling);
    super.onInit();
  }

  void onScrolling() {}
}

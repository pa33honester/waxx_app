import 'dart:async';
import 'dart:math';

import 'package:waxxapp/user_pages/fake_live_page/widget/fake_comment_data.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FakeLiveController extends GetxController {
  ScrollController scrollController = ScrollController();

  // ChewieController? chewieController;
  // VideoPlayerController? videoPlayerController;

  TextEditingController commentController = TextEditingController();

  List<FakeCommentModel> fakeComments = [];

  Timer? timer;

  bool isLike = false;

  @override
  void onInit() {
    scrollController.addListener(onScrolling);
    // initializeVideoPlayer();
    onAutoAddComment();
    super.onInit();
  }

  @override
  void onClose() {
    // onDisposeVideoPlayer();
    timer?.cancel();
    super.onClose();
  }

  void onScrolling() {}

  void onAutoAddComment() async {
    fakeComments.clear();
    timer = Timer.periodic(
      const Duration(seconds: 2),
      (timer) {
        fakeComments.add(fakeCommentData[Random().nextInt(fakeCommentData.length)]);
        onScrollDown();
      },
    );
  }

  Future<void> onScrollDown() async {
    try {
      await 100.milliseconds.delay();
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 50),
        curve: Curves.easeOut,
      );
      update(["onUpdateComment"]);
    } catch (e) {
      Utils.showLog("Scroll Down Error => $e");
    }
  }

  void onSendComment() async {
    if (commentController.text.trim().isNotEmpty) {
      fakeComments.add(
        FakeCommentModel(
          message: commentController.text.trim(),
          user:"$editFirstName",
          image: "$editImage",
        ),
      );
      commentController.clear();
      await onScrollDown();
    }
  }

  void onClickLike() async {
    isLike = !isLike;
    update(["onClickLike"]);
  }
}

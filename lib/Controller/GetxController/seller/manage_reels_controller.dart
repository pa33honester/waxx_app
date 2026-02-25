import 'dart:developer';
import 'dart:io';

import 'package:era_shop/Controller/GetxController/seller/show_uploaded_reels_controller.dart';
import 'package:era_shop/seller_pages/listing/controller/chat_gpt_controller.dart';
import 'package:era_shop/utils/app_constant.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:era_shop/utils/show_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_video_thumbnail/get_video_thumbnail.dart';
import 'package:get_video_thumbnail/index.dart';

// import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../../ApiModel/seller/ShowUploadedReelsModel.dart';
import '../../../ApiService/seller/reel_delete_service.dart';
import '../../../ApiService/seller/upload_reels_service.dart';
import '../../../utils/utils.dart';

class ManageShortsController extends GetxController {
  ShowUploadedShortsController showUploadedShortsController = Get.put(ShowUploadedShortsController());

  File? reelVideo;
  XFile? reelsXFiles;
  VideoPlayerController? videoPlayerController;
  final ImagePicker reelsPick = ImagePicker();

  String? productId;

  // String? sellerId;
  RxBool isTextExpanded = false.obs;

  int? selectedIndex;
  List<dynamic>? attributesArray;
  String productImage = "";
  XFile? thumbnailPath;

  TextEditingController selectProductName = TextEditingController();
  TextEditingController selectedProductDescription = TextEditingController();
  String productPrice = "";

  RxBool isLoading = false.obs;
  bool isReelLoading = false;
  RxBool deleteReelLoading = false.obs;

  // int? lastSelectedIndex;
  List<int> selectedIndices = <int>[]; // Multiple selected indices
  List<String> selectedProductIds = <String>[]; // Multiple product IDs
  List<ProductId> selectedProducts = <ProductId>[];

  @override
  void onInit() {
    print('ON INIT -----');
    isAutoGenerateOn.value = false;
    super.onInit();
  }

  final isAutoGenerateOn = false.obs;
  final chatGptController = Get.put(ChatGptController());

  void toggleAutoGenerate(bool value) {
    if (value) {
      isAutoGenerateOn.value = true;
      generateDescription();
    } else {
      isAutoGenerateOn.value = false;
    }
  }

  Future<void> generateDescription() async {
    isLoading.value = true;
    update([AppConstant.idAutoReelDes]);

    try {
      String prompt;

      if (selectedProducts.isNotEmpty) {
        String productNames = selectedProducts.map((product) => product.productName ?? 'Product').join(', ');

        prompt = """
      Generate a product reel description in 30-40 words for these products: $productNames
      
      Product details:    
      Make it engaging and highlight key features of these specific products.
      Use a professional tone suitable for e-commerce reels.
      Focus on benefits and what makes these products special.
      Make it compelling for viewers to want to learn more or purchase.
      """;
      } else {
        prompt = """
      Generate a product description in 40-50 words for a general product reel.   
      Make it engaging and highlight key features.
      Use a professional tone suitable for e-commerce reels.
      Focus on benefits rather than just features.
      """;
      }

      final generatedText = await chatGptController.generateDescription(prompt);
      selectedProductDescription.text = generatedText;
    } catch (e) {
      Utils.showToast('Failed to generate description: ${e.toString()}');
      isAutoGenerateOn.value = false;
    } finally {
      isLoading.value = false;
      update([AppConstant.idAutoReelDes]);
    }
  }

  void addProductToSelection(int index, String productId, ProductId product) {
    if (!selectedIndices.contains(index)) {
      selectedIndices.add(index);
      selectedProductIds.add(productId);
      selectedProducts.add(product);
      update();
    }
  }

  // Method to remove product from selection
  void removeProductFromSelection(int index, String productId) {
    int selectionIndex = selectedIndices.indexOf(index);
    if (selectionIndex != -1) {
      selectedIndices.removeAt(selectionIndex);
      selectedProductIds.removeAt(selectionIndex);
      selectedProducts.removeAt(selectionIndex);
      update();
    }
  }

  void toggleSelection(int index, String productId, ProductId product) {
    if (selectedIndices.contains(index)) {
      removeProductFromSelection(index, productId);
    } else {
      addProductToSelection(index, productId, product);
    }

    // Update last selected for maintaining other functionality
    if (selectedIndices.isNotEmpty) {
      // lastSelectedIndex = selectedIndices.last;
      this.productId = selectedProductIds.last;
    } else {
      // lastSelectedIndex = null;
      this.productId = null;
    }
  }

  // Method to check if item is selected
  bool isSelected(int index) {
    return selectedIndices.contains(index);
  }

  // Clear all selections
  void clearSelections() {
    selectedIndices.clear();
    selectedProductIds.clear();
    selectedProducts.clear();
    // lastSelectedIndex = null;
    productId = null;
    selectProductName.clear();
    selectedProductDescription.clear();
    update();
  }

  // reelsPickFromGallery() async {
  //   // reelsXFiles = await reelsPick.pickVideo(source: ImageSource.gallery);
  //   // reelVideo = File(reelsXFiles!.path);
  //   // videoPlayerController = VideoPlayerController.file(reelVideo!);
  //   // await videoPlayerController!.initialize();
  //   // update();
  //
  //   reelsXFiles = await reelsPick.pickVideo(source: ImageSource.gallery);
  //   reelVideo = File(reelsXFiles!.path);
  //
  //   thumbnailPath = await VideoThumbnail.thumbnailFile(
  //     video: reelVideo!.path,
  //     imageFormat: ImageFormat.JPEG,
  //     maxWidth: 360,
  //     maxHeight: 550,
  //     quality: 100,
  //   );
  //
  //   log("Thumbnail path :: $thumbnailPath");
  //
  //   videoPlayerController = VideoPlayerController.file(reelVideo!);
  //   await videoPlayerController!.initialize();
  //
  //   update();
  // }

  reelsPickFromGallery() async {
    try {
      // Set loading state to true
      isReelLoading = true;
      update(); // This will refresh the UI to show loader

      reelsXFiles = await reelsPick.pickVideo(source: ImageSource.gallery);

      if (reelsXFiles != null) {
        reelVideo = File(reelsXFiles!.path);

        // Generate thumbnail
        thumbnailPath = await VideoThumbnail.thumbnailFile(
          video: reelVideo!.path,
          imageFormat: ImageFormat.JPEG,
          maxWidth: 360,
          maxHeight: 550,
          quality: 100,
        );

        log("Thumbnail path :: $thumbnailPath");

        // Initialize video player
        videoPlayerController = VideoPlayerController.file(reelVideo!);
        await videoPlayerController!.initialize();
      }
    } catch (e) {
      log("Error picking video: $e");
    } finally {
      isReelLoading = false;
      update();
    }
  }

  uploadReels(String description) async {
    try {
      isLoading(true);
      var data = await UploadReelsApi().uploadReelApi(
        sellerId: sellerId,
        productId: selectedProductIds,
        video: reelVideo!,
        thumbnailPath: "${thumbnailPath?.path}",
        description: description,
      );
      if (data.status == true) {
        showUploadedShortsController.afterDeleteReels();
        displayToast(message: data.message.toString());
        Get.back();
        Get.back();
      } else {
        displayToast(message: data.message.toString());
      }
    } finally {
      isLoading(false);
    }
  }

  void removeVideo() {
    Utils.showLog("Removing video");
    reelVideo = null;
    reelsXFiles = null;
    thumbnailPath = null;
    videoPlayerController?.dispose();
    videoPlayerController = null;
    update();
  }

  deleteReel({required String reelId}) async {
    try {
      deleteReelLoading(true);
      var data = await ReelDeleteService().deleteReel(reelId: reelId);
      Get.back();
      if (data?.status == true) {
        // showUploadedShortsController.afterDeleteReels();
        Get.find<ShowUploadedShortsController>().deleteReelLocally(reelId);
        displayToast(message: "Short deleted!");
      } else {
        displayToast(message: "Something went wrong!");
      }
    } finally {
      deleteReelLoading(false);
    }
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    super.dispose();
  }
}

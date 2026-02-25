import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:era_shop/seller_pages/listing/controller/listing_controller.dart';
import 'package:era_shop/seller_pages/listing/widget/listing_app_bar_widget.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/app_constant.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhotosDetailScreen extends StatelessWidget {
  const PhotosDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: GetBuilder<ListingController>(
          id: AppConstant.idPickImage,
          builder: (controller) {
            return ListingAppBarWidget(
              title: St.photos.tr,
              showCheckIcon: true,
              isCheckEnabled: controller.imageFileList.isNotEmpty,
              onCheckTap: () {
                Get.back();
              },
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: GetBuilder<ListingController>(
          id: AppConstant.idPickImage,
          builder: (controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                16.height,
                Text(
                  St.youCanAddUpToPhotosBuyersWantToSeeAllDetailsAndAngles.tr,
                  style: AppFontStyle.styleW500(AppColors.unselected, 14),
                ),
                22.height,
                Text(
                  "${controller.imageFileList.length}/10",
                  style: AppFontStyle.styleW500(AppColors.white, 16),
                ),
                18.height,
                _buildImageList(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildImageList() {
    Widget getImageWidget(String imagePath) {
      if (imagePath.startsWith('http') || imagePath.startsWith('https')) {
        // It's a network URL
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: imagePath,
            height: 230,
            width: double.maxFinite,
            fit: BoxFit.cover,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) {
              if (kDebugMode) {
                print('Error loading network image: $error');
              }
              return const Icon(Icons.error);
            },
          ),
        );
      } else {
        // It's a local file path
        return ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(12),
          child: Image.file(
            File(imagePath),
            height: 230,
            width: double.maxFinite,
            fit: BoxFit.cover,
          ),
        );
      }
    }

    return GetBuilder<ListingController>(
      id: AppConstant.idPickImage,
      builder: (controller) {
        return Expanded(
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 6, mainAxisSpacing: 6),
            itemCount: controller.imageFileList.length + 1,
            itemBuilder: (context, index) {
              // If index == 0, show the "Add Image" button FIRST
              if (index == 0) {
                return GestureDetector(
                  onTap: () {
                    if (controller.imageFileList.length >= 10) {
                      Utils.showToast('Maximum upload 10 images');
                    } else {
                      controller.productPickFromGallery();
                    }
                  },
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: AppColors.tabBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_outlined,
                          color: AppColors.unselected,
                        ),
                        10.height,
                        Text(
                          St.add.tr.capitalizeFirst ?? '',
                          style: AppFontStyle.styleW500(AppColors.unselected, 12),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final imageIndex = index - 1;
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      // image: DecorationImage(
                      //   image: FileImage(controller.imageFileList[imageIndex]),
                      //   fit: BoxFit.cover,
                      // ),
                    ),
                    child: getImageWidget(controller.imageFileList[imageIndex].path),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: PopupMenuButton<String>(
                      onSelected: (value) {
                        // if (value == 'edit') onEditImage(index - 1);
                        // if (value == 'delete') removeImage(index - 1);
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                            onTap: () {
                              controller.onRemoveImage(imageIndex);
                            },
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, size: 18, color: Colors.red),
                                SizedBox(width: 8),
                                Text(St.delete.tr, style: TextStyle(color: Colors.red)),
                              ],
                            )),
                      ],
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.more_vert,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  index == 1
                      ? Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(16)),
                          child: Text(
                            St.main.tr,
                            style: AppFontStyle.styleW600(AppColors.white, 14),
                          ),
                        ).paddingOnly(bottom: 6)
                      : Offstage(),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:era_shop/seller_pages/listing/controller/listing_controller.dart';
import 'package:era_shop/seller_pages/listing/view/photos_edit_screen.dart';
import 'package:era_shop/seller_pages/listing/widget/list_title.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/app_constant.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhotosWidget extends StatelessWidget {
  const PhotosWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: GetBuilder<ListingController>(
          id: AppConstant.idPickImage,
          builder: (controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                15.height,
                ListTitle(
                  title: St.photos.tr,
                  onTap: () {
                    Get.toNamed("/PhotosEdit");
                  },
                  showCheckIcon: controller.hasPhotos,
                ),
                26.height,
                /* Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info,
                      color: AppColors.unselected,
                    ),
                    10.width,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            St.addPhotos.tr,
                            style: AppFontStyle.styleW700(AppColors.white, 12),
                          ),
                          4.height,
                          Text(
                            St.addAtLeaseImages.tr,
                            style: AppFontStyle.styleW500(AppColors.unselected, 10),
                          ),
                        ],
                      ).paddingOnly(right: 30),
                    ),
                  ],
                ),*/
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info,
                      color: AppColors.unselected,
                    ),
                    10.width,
                    Text(
                      St.pleaseProvidePhotosForYourItem.tr,
                      style: AppFontStyle.styleW500(AppColors.unselected, 10),
                    ).paddingOnly(right: 30),
                  ],
                ),
                26.height,
                controller.imageFileList.isBlank == false
                    ? _buildImageList(controller)
                    : Column(
                        children: [
                          buildPhotosContainer(
                              title: St.uploadPhotos.tr,
                              icon: Icons.upload,
                              onTap: () {
                                if (controller.imageFileList.length >= 10) {
                                  Utils.showToast('Maximum upload 10 images');
                                } else {
                                  controller.productPickFromGallery();
                                }
                              }),
                          16.height,
                          buildPhotosContainer(
                              title: St.takePhotos.tr,
                              icon: Icons.camera_alt_outlined,
                              onTap: () {
                                controller.takePhoto();
                              }),
                        ],
                      ),
              ],
            );
          }),
    );
  }

  buildPhotosContainer({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(color: AppColors.tabBackground.withValues(alpha: .7), border: Border.all(color: AppColors.unselected.withValues(alpha: 0.5)), borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Text(
              title,
              style: AppFontStyle.styleW600(AppColors.white, 14),
            ),
            Spacer(),
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.unselected.withValues(alpha: .2),
              child: Icon(
                icon,
                size: 20,
                color: AppColors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildImageList(ListingController controller) {
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

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
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
                margin: const EdgeInsets.only(right: 10),
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
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {
                Get.to(() => PhotosDetailScreen());
              },
              child: Stack(
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
                    top: 4,
                    right: 4,
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
                          decoration: BoxDecoration(color: Colors.black.withValues(alpha: .6), borderRadius: BorderRadius.circular(16)),
                          child: Text(
                            St.main.tr,
                            style: AppFontStyle.styleW600(AppColors.white, 14),
                          ),
                        ).paddingOnly(bottom: 6)
                      : Offstage(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

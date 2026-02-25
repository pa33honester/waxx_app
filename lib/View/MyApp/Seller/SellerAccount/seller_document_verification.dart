import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:era_shop/Controller/GetxController/seller/seller_common_controller.dart';
import 'package:era_shop/custom/main_button_widget.dart';
import 'package:era_shop/custom/simple_app_bar_widget.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_asset.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/app_constant.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SellerDocumentVerification extends StatelessWidget {
  SellerDocumentVerification({super.key});

  final controller = Get.put(SellerCommonController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.transparent,
          surfaceTintColor: AppColors.transparent,
          elevation: 0,
          flexibleSpace: SimpleAppBarWidget(title: St.sellerAccount.tr),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Header Section
                  _buildHeaderSection(),

                  // Progress Indicator
                  _buildProgressIndicator(),

                  // Document Sections
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        if (isGovIdActive)
                          _buildDocumentSection(
                              title: St.governmentID.tr,
                              subtitle: St.uploadAPhotoOfYourGovernmentIssuedID.tr,
                              icon: Icons.badge_outlined,
                              docType: DocumentType.govId,
                              imageList: controller.govIdImageList,
                              updateId: AppConstant.idVerifyProof,
                              isRequired: isGovIdRequired),
                        if (isRegistrationCertActive)
                          _buildDocumentSection(
                              title: St.businessRegistration.tr,
                              subtitle: St.uploadYourBusinessRegistrationCertificate.tr,
                              icon: Icons.business_outlined,
                              docType: DocumentType.businessRegistration,
                              imageList: controller.businessRegisImageFileList,
                              updateId: AppConstant.idBusinessRegCertificate,
                              isRequired: isRegistrationCertRequired),
                        if (isAddressProofActive)
                          _buildDocumentSection(
                              title: St.addressProof.tr,
                              subtitle: St.uploadUtilityBillOrBankStatement.tr,
                              icon: Icons.location_on_outlined,
                              docType: DocumentType.addressProof,
                              imageList: controller.addressProofImageList,
                              updateId: AppConstant.idAddressProof,
                              isRequired: isAddressProofRequired),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Bottom Button
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.verified_user_outlined,
              size: 40,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            St.completeSellerAccount.tr,
            style: AppFontStyle.styleW900(AppColors.primary, 20),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            St.securelyProcessYourPayment.tr,
            style: AppFontStyle.styleW500(AppColors.unselected, 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              St.pleaseUploadAllRequiredDocumentsToProceed.tr,
              style: AppFontStyle.styleW500(AppColors.primary, 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentSection({
    required String title,
    required String subtitle,
    required IconData icon,
    required DocumentType docType,
    required List<File> imageList,
    required String updateId,
    required bool isRequired,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.tabBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: AppFontStyle.styleW600(AppColors.white, 16),
                          ),
                          if (isRequired)
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Text(
                                '*',
                                style: AppFontStyle.styleW600(Colors.red, 16),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: AppFontStyle.styleW400(AppColors.unselected, 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GetBuilder<SellerCommonController>(
              id: updateId,
              builder: (controller) {
                return imageList.isNotEmpty ? _buildImageGrid(controller, imageList, docType) : _buildEmptyUploadArea(docType);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyUploadArea(DocumentType docType) {
    return GestureDetector(
      onTap: () => controller.getImageFromGallery(docType),
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.tabBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.3),
            width: 1.5,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppAsset.icUpload,
              width: 40,
              height: 40,
              color: AppColors.primary,
            ),
            // Icon(
            //   Icons.cloud_upload_outlined,
            //   size: 32,
            //   color: AppColors.primary,
            // ),
            const SizedBox(height: 8),
            Text(
              St.uploadDocuments.tr,
              style: AppFontStyle.styleW600(AppColors.primary, 14),
            ),
            const SizedBox(height: 4),
            Text(
              St.tapToSelectFiles.tr,
              style: AppFontStyle.styleW400(AppColors.unselected, 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGrid(SellerCommonController controller, List<File> imageList, DocumentType docType) {
    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1,
          ),
          itemCount: imageList.length + (imageList.length < 10 ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == 0 && imageList.length < 10) {
              return _buildAddMoreButton(docType);
            }

            final imageIndex = imageList.length < 10 ? index - 1 : index;
            return _buildImageCard(imageList[imageIndex], imageIndex, docType);
          },
        ),
        if (imageList.isNotEmpty) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                '${imageList.length} document${imageList.length > 1 ? 's' : ''} uploaded',
                style: AppFontStyle.styleW500(Colors.green, 14),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildAddMoreButton(DocumentType docType) {
    return GestureDetector(
      onTap: () {
        switch (docType) {
          case DocumentType.govId:
            controller.getGovIdImage();
            break;
          case DocumentType.businessRegistration:
            controller.getBusinessRegImage();
            break;
          case DocumentType.addressProof:
            controller.getAddressProofImage();
            break;
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.unselected.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.unselected.withValues(alpha: 0.3),
            width: 1.5,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              color: AppColors.unselected,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              St.addMore.tr,
              style: AppFontStyle.styleW500(AppColors.unselected, 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCard(File imageFile, int imageIndex, DocumentType docType) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _getImageWidget(imageFile.path),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => _removeImage(imageIndex, docType),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.primaryRed,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 14,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _getImageWidget(String imagePath) {
    if (imagePath.startsWith('http') || imagePath.startsWith('https')) {
      return CachedNetworkImage(
        imageUrl: imagePath,
        height: double.infinity,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: AppColors.tabBackground,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: AppColors.tabBackground,
          child: const Icon(Icons.error),
        ),
      );
    } else {
      return Image.file(
        File(imagePath),
        height: double.infinity,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }
  }

  void _removeImage(int imageIndex, DocumentType docType) {
    switch (docType) {
      case DocumentType.govId:
        controller.onRemoveGovIdImage(imageIndex);
        break;
      case DocumentType.businessRegistration:
        controller.onRemoveBusinessRegImage(imageIndex);
        break;
      case DocumentType.addressProof:
        controller.onRemoveAddressProofImage(imageIndex);
        break;
    }
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.black,
      ),
      child: MainButtonWidget(
        height: 56,
        width: Get.width,
        color: AppColors.primary,
        borderRadius: 16,
        child: Text(
          St.nextText.tr.toUpperCase(),
          style: AppFontStyle.styleW700(AppColors.black, 16),
        ),
        callback: () => controller.onSubmitDocumentsDetails(),
      ),
    );
  }
}

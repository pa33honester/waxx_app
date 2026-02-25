import 'package:era_shop/Controller/GetxController/seller/seller_common_controller.dart';
import 'package:era_shop/custom/custom_color_bg_widget.dart';
import 'package:era_shop/custom/main_button_widget.dart';
import 'package:era_shop/custom/simple_app_bar_widget.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/Theme/theme_service.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:era_shop/utils/show_toast.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({super.key});

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  SellerCommonController sellerController = Get.put(SellerCommonController());

  @override
  Widget build(BuildContext context) {
    return CustomColorBgWidget(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.transparent,
            surfaceTintColor: AppColors.transparent,
            flexibleSpace: SimpleAppBarWidget(title: St.sellerAccount.tr),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                15.height,
                Center(
                  child: Text(
                    St.termsAndCondition.tr,
                    style: AppFontStyle.styleW900(AppColors.primary, 20),
                  ),
                ),
                5.height,
                Center(
                  child: Text(
                    St.agreeToSelling.tr,
                    style: AppFontStyle.styleW500(AppColors.unselected, 12),
                  ),
                ),
                Html(
                  data: termsAndConditionsLink,
                  style: {
                    "body": Style(fontSize: FontSize(18), color: Colors.white),
                    "h4": Style(fontSize: FontSize(24), fontWeight: FontWeight.bold),
                    "h5": Style(fontSize: FontSize(22)),
                    "h6": Style(fontSize: FontSize(20)),
                    "p": Style(
                      fontSize: FontSize(18),
                    ),
                  },
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        sellerController.toggleTermsAndCondition();
                      },
                      child: Obx(
                        () => sellerController.isTermsAndCondition.value
                            ? Container(
                                height: 24,
                                width: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primary,
                                ),
                                child: Icon(Icons.done_outlined, color: Colors.black, size: 15),
                              )
                            : Container(
                                height: 24,
                                width: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.grey.shade400),
                                ),
                              ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          sellerController.toggleTermsAndCondition();
                        },
                        child: Text(
                          'I have read and agree to the Terms and Conditions',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // ListView.builder(
                //   padding: const EdgeInsets.only(top: 20, left: 6),
                //   physics: const BouncingScrollPhysics(),
                //   shrinkWrap: true,
                //   itemCount: sellerController.termsList.length,
                //   itemBuilder: (context, index) {
                //     return Padding(
                //       padding: const EdgeInsets.only(bottom: 17),
                //       child: GestureDetector(
                //         onTap: () {
                //           setState(() {});
                //           sellerController.termsList[index].isSelectedTerms.isFalse ? sellerController.termsList[index].isSelectedTerms(true) : sellerController.termsList[index].isSelectedTerms(false);
                //         },
                //         child: SizedBox(
                //           child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Row(
                //                 children: [
                //                   Padding(
                //                     padding: const EdgeInsets.only(right: 10),
                //                     child: Obx(
                //                       () => sellerController.termsList[index].isSelectedTerms.value
                //                           ? Container(
                //                               height: 24,
                //                               width: 24,
                //                               decoration: BoxDecoration(
                //                                 shape: BoxShape.circle,
                //                                 color: AppColors.primaryPink,
                //                               ),
                //                               child: Icon(Icons.done_outlined, color: AppColors.black, size: 15),
                //                             )
                //                           : Container(
                //                               height: 24,
                //                               width: 24,
                //                               decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade400)),
                //                             ),
                //                     ),
                //                   ),
                //                   Text(
                //                     sellerController.termsList[index].title,
                //                     style: AppFontStyle.styleW900(AppColors.white, 15),
                //                   ),
                //                 ],
                //               ),
                //               Padding(
                //                 padding: const EdgeInsets.only(left: 34, top: 8, bottom: 10),
                //                 child: Text(
                //                   sellerController.termsList[index].description,
                //                   style: AppFontStyle.styleW500(AppColors.unselected, 12),
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     );
                //   },
                // )
              ],
            ),
          ),
        ),
        bottomNavigationBar: MainButtonWidget(
          height: 55,
          width: Get.width,
          margin: const EdgeInsets.all(15),
          color: AppColors.primary,
          child: Text(
            St.continueText.tr.toUpperCase(),
            style: AppFontStyle.styleW700(AppColors.black, 16),
          ),
          callback: () {
            if (sellerController.isTermsAndCondition.value) {
              if (getStorage.read("isDemoLogin") ?? false || isDemoSeller) {
                displayToast(message: St.thisIsDemoUser.tr);
              } else {
                // return;
                sellerController.onSubmitTermsAndCondition();
              }
            } else {
              displayToast(message: St.termsAndConditionsNotAccepted.tr, isBottomToast: true);
            }
            // if (sellerController.termsList.every((term) => term.isSelectedTerms.value)) {
            //   if (getStorage.read("isDemoLogin") ?? false) {
            //     displayToast(message: St.thisIsDemoUser.tr);
            //   } else {
            //     sellerController.onSubmitTermsAndCondition();
            //   }
            // } else {
            //   displayToast(message: St.termsAndConditionsNotAccepted.tr);
            // }
          },
        ),
      ),
    );
  }
}

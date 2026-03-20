// import 'package:waxxapp/utils/app_colors.dart';
// import 'package:waxxapp/utils/font_style.dart';
// import 'package:waxxapp/utils/utils.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class StopLiveStreamingDialogUi {
//   static Future<void> onShow({required VoidCallback onClickStop}) async {
//     Get.dialog(
//       barrierColor: AppColors.black.withOpacity(0.9),
//       Dialog(
//         backgroundColor: AppColors.transparent,
//         elevation: 0,
//         child: Container(
//           height: 385,
//           width: 310,
//           decoration: BoxDecoration(
//             color: AppColors.white,
//             borderRadius: BorderRadius.circular(45),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   10.height,
//                   Image.asset(AppAsset.icLogOut, width: 90),
//                   10.height,
//                   Text(
//                     EnumLocal.txtStopLive.name.tr,
//                     style: AppFontStyle.styleW700(AppColors.black, 24),
//                   ),
//                   10.height,
//                   Text(
//                     textAlign: TextAlign.center,
//                     EnumLocal.txtStopLiveDialogText.name.tr,
//                     style: AppFontStyle.styleW400(AppColors.colorTextGrey, 12),
//                   ),
//                   20.height,
//                   GestureDetector(
//                     onTap: () => onClickStop(),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(100),
//                         color: AppColors.colorLightRedBg,
//                       ),
//                       height: 52,
//                       width: Get.width,
//                       child: Center(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(EnumLocal.txtStop.name.tr, style: AppFontStyle.styleW700(AppColors.colorTextRed, 16)),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   10.height,
//                   GestureDetector(
//                     onTap: () => Get.back(),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(100),
//                         color: AppColors.coloGreyText,
//                       ),
//                       height: 52,
//                       width: Get.width,
//                       child: Center(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(EnumLocal.txtCancel.name.tr, style: AppFontStyle.styleW700(AppColors.coloGreyText, 16)),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

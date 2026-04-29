// ignore_for_file: must_be_immutable

import 'package:waxxapp/custom/custom_color_bg_widget.dart';
import 'package:waxxapp/custom/preview_profile_image_widget.dart';
import 'package:waxxapp/custom/simple_app_bar_widget.dart';
import 'package:waxxapp/utils/CoustomWidget/App_theme_services/no_data_found.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/shimmers.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../Controller/GetxController/user/user_all_notification_controller.dart';

class Notifications extends StatelessWidget {
  Notifications({super.key});

  NotificationController notificationController = Get.put(NotificationController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return CustomColorBgWidget(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.transparent,
            shadowColor: AppColors.black.withValues(alpha: 0.4),
            flexibleSpace: Stack(
              children: [
                SimpleAppBarWidget(title: St.notification.tr),
                // Clear-all action — only renders when there's at least
                // one notification to wipe. Sits at the top-right of the
                // app bar so the back chevron + title stay centered.
                Positioned(
                  right: 4,
                  top: 0,
                  bottom: 0,
                  child: GetBuilder<NotificationController>(
                    builder: (controller) {
                      if (controller.isLoading.value || controller.notificationList.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return Center(
                        child: TextButton(
                          onPressed: () => _confirmClearAll(controller),
                          child: Text(
                            'Clear all',
                            style: AppFontStyle.styleW600(AppColors.primary, 13),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
            child: SizedBox(
          height: Get.height,
          width: Get.width,
          child: Obx(
            () => notificationController.isLoading.value
                ? Shimmers.notificationShimmer()
                : RefreshIndicator(
                    color: AppColors.primary,
                    backgroundColor: AppColors.black,
                    onRefresh: () => notificationController.notifications(),
                    child: GetBuilder<NotificationController>(builder: (NotificationController notificationController) {
                      return notificationController.notificationList.isEmpty
                          ? Padding(padding: const EdgeInsets.only(bottom: 50), child: noDataFound(image: "assets/no_data_found/notification.png", text: St.noNotification.tr))
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                              itemCount: notificationController.notificationList.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                var notificationData = notificationController.notificationList[index];
                                String inputDate = notificationData.date.toString();
                                DateTime dateTime = DateFormat('M/d/yyyy, hh:mm:ss a').parse(inputDate);
                                String formattedDate = DateFormat('d MMM, hh:mm a').format(dateTime);

                                // Stable id for the Dismissible key —
                                // falls back to the index when a row
                                // arrives without an id (defensive).
                                final dismissKey = ValueKey(
                                  (notificationData.id?.isNotEmpty ?? false)
                                      ? notificationData.id!
                                      : 'notif-$index',
                                );
                                return Dismissible(
                                  key: dismissKey,
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    margin: const EdgeInsets.only(bottom: 15),
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: AppColors.red.withValues(alpha: 0.18),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: AppColors.red.withValues(alpha: 0.6)),
                                    ),
                                    child: Icon(Icons.delete_outline_rounded, color: AppColors.red, size: 22),
                                  ),
                                  onDismissed: (_) async {
                                    final ok = await notificationController.deleteNotification(index);
                                    if (!ok) {
                                      Utils.showToast("Couldn't delete. Please try again.");
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 15),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 48,
                                          width: 48,
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: AppColors.white),
                                          ),
                                          child: PreviewProfileImageWidget(size: 48, image: notificationData.image, fit: BoxFit.cover),
                                        ),
                                        10.width,
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                notificationData.message ?? "",
                                                style: AppFontStyle.styleW500(AppColors.white, 14),
                                              ),
                                              5.height,
                                              Text(
                                                formattedDate,
                                                style: AppFontStyle.styleW500(AppColors.unselected, 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Trailing trash icon — duplicates the
                                        // swipe affordance so users who don't
                                        // know to swipe still have a clear way
                                        // to delete a single row.
                                        IconButton(
                                          tooltip: 'Delete',
                                          icon: Icon(
                                            Icons.delete_outline_rounded,
                                            color: AppColors.unselected,
                                            size: 20,
                                          ),
                                          onPressed: () async {
                                            final ok = await notificationController.deleteNotification(index);
                                            if (!ok) {
                                              Utils.showToast("Couldn't delete. Please try again.");
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                                // return Row(
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   children: [
                                //     ClipRRect(
                                //       borderRadius: BorderRadius.circular(50),
                                //       child: CachedNetworkImage(
                                //         height: 42,
                                //         width: 42,
                                //         fit: BoxFit.cover,
                                //         imageUrl: "${notificationData.image}",
                                //         placeholder: (context, url) => const Center(
                                //             child: CupertinoActivityIndicator(
                                //           radius: 7,
                                //           animating: true,
                                //         )),
                                //         errorWidget: (context, url, error) => Center(child: Image.asset("assets/Home_page_image/profile.png")),
                                //       ),
                                //     ).paddingOnly(top: 7),
                                //     Expanded(
                                //       child: Padding(
                                //         padding: const EdgeInsets.only(left: 13),
                                //         child: Column(
                                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //           crossAxisAlignment: CrossAxisAlignment.start,
                                //           children: [
                                //             Text(
                                //               "${notificationData.message}",
                                //               style: GoogleFonts.plusJakartaSans(
                                //                 height: 1.6,
                                //                 fontWeight: FontWeight.w500,
                                //                 fontSize: 14,
                                //               ),
                                //             ),
                                //             Padding(
                                //               padding: const EdgeInsets.only(top: 6),
                                //               child: Text(
                                //                 formattedDate,
                                //                 style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w500, fontSize: 11.5, color: Colors.grey.shade600),
                                //               ),
                                //             )
                                //           ],
                                //         ),
                                //       ),
                                //     ),
                                //   ],
                                // ).paddingOnly(bottom: 25);
                              },
                            );
                    }),
                  ),
          ),
        )),
      ),
    );
  }

  /// Confirmation dialog for the AppBar's Clear-all action — bulk
  /// deletes are destructive and easy to fat-finger, so we always gate
  /// behind a confirm step. The controller's `clearAllNotifications`
  /// already does the optimistic-empty + restore-on-failure dance.
  Future<void> _confirmClearAll(NotificationController controller) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: AppColors.tabBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Clear all notifications?", style: AppFontStyle.styleW700(AppColors.white, 16)),
        content: Text(
          "This will remove every notification from your list. You can't undo this.",
          style: AppFontStyle.styleW500(AppColors.unselected, 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text("Cancel", style: AppFontStyle.styleW600(AppColors.unselected, 13)),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text("Clear all", style: AppFontStyle.styleW700(AppColors.red, 13)),
          ),
        ],
      ),
      barrierDismissible: true,
    );

    if (confirmed != true) return;

    final ok = await controller.clearAllNotifications();
    if (!ok) {
      Utils.showToast("Couldn't clear notifications. Please try again.");
    }
  }
}

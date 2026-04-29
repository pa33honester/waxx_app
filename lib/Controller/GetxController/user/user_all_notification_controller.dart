import 'dart:developer';
import 'package:get/get.dart';
import '../../../ApiModel/user/get_all_notifications_model.dart';
import '../../../ApiService/user/delete_notification_service.dart';
import '../../../ApiService/user/user_all_notification_service.dart';

class NotificationController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    notificationList.isEmpty ? notifications() : null;
    super.onInit();
  }

  GetAllNotificationsModel? getAllNotifications;
  RxBool isLoading = true.obs;

  List<Notification> notificationList = [];

  notifications() async {
    try {
      isLoading(true);
      notificationList.clear();
      var data = await GetAllNotifications().getNotification();
      getAllNotifications = data;
      notificationList.addAll(getAllNotifications!.notification!);
      log("Notification List :: $notificationList");
    } finally {
      isLoading(false);
      log('Notification finally');
    }
  }

  /// Optimistic delete — drops the row from the in-memory list (and
  /// repaints the GetBuilder) before the network call. On failure the
  /// row is reinserted at its original position so the UI stays
  /// consistent with the server.
  Future<bool> deleteNotification(int index) async {
    if (index < 0 || index >= notificationList.length) return false;
    final removed = notificationList.removeAt(index);
    update();

    final id = removed.id ?? "";
    if (id.isEmpty) {
      // No id to act on — don't bother the backend; the row is already
      // gone from the UI. Defensive: every persisted notification has a
      // Mongo _id so this branch shouldn't actually fire.
      return true;
    }

    final ok = await DeleteNotificationService.deleteOne(id);
    if (!ok) {
      // Reinsert at the original index so a transient failure doesn't
      // silently drop a row from the user's view.
      final safeIndex = index <= notificationList.length ? index : notificationList.length;
      notificationList.insert(safeIndex, removed);
      update();
    }
    return ok;
  }

  /// Wipes every notification — Clear all action in the AppBar. The
  /// list is optimistically emptied; on failure the prior list is
  /// restored.
  Future<bool> clearAllNotifications() async {
    if (notificationList.isEmpty) return true;
    final snapshot = List<Notification>.from(notificationList);
    notificationList.clear();
    update();

    final ok = await DeleteNotificationService.clearAll();
    if (!ok) {
      notificationList.addAll(snapshot);
      update();
    }
    return ok;
  }
}

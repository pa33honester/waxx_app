import 'dart:developer';
import 'package:get/get.dart';
import '../../../ApiModel/user/get_all_notifications_model.dart';
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
}

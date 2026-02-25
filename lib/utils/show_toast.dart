import 'package:era_shop/utils/app_colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<bool?> displayToast({required String message, bool? isBottomToast}) {
  return Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: isBottomToast == true ? ToastGravity.BOTTOM : ToastGravity.CENTER,
    timeInSecForIosWeb: 2,
    backgroundColor: AppColors.grayLight,
    textColor: AppColors.white,
    fontSize: 16.0,
  );
}

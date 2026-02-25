import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:era_shop/utils/utils.dart';
 import 'package:flutterwave_standard/flutterwave.dart';
 import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

class FlutterWaveService {
  static Future<void> init({required String amount, required Callback onPaymentComplete}) async {
    final Customer customer = Customer(name: "Flutter wave Developer", email: "customer@customer.com", phoneNumber: '');
    final Flutterwave flutterWave = Flutterwave(
        publicKey: flutterWaveId,
        currency: currencyCode??"",
        redirectUrl: "https://www.google.com/",
        txRef: DateTime.now().microsecond.toString(),
        amount: amount,
        customer: customer,
        paymentOptions: "ussd, card, barter, payattitude",
        customization: Customization(title: St.appName.tr),
        isTestMode: true);

    Utils.showLog("Flutter Wave Payment Finish");

    final ChargeResponse response = await flutterWave.charge(Get.context!);

    Utils.showLog("Flutter Wave Payment Status => ${response.status.toString()}");

    if (response.success == true) {
      onPaymentComplete.call();
    }
    Utils.showLog("Flutter Wave Response => ${response.toString()}");
  }
}

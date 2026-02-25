import 'dart:developer';
import 'package:get/get.dart';
import '../../../ApiModel/user/FAQModel.dart';
import '../../../ApiService/user/faq_service.dart';

class FAQController extends GetxController {
  FaqModel? faqs;
  RxBool isLoading = true.obs;

  getFaqData() async {
    try {
      isLoading(true);
      var data = await FAQApi().showFAQ();
      faqs = data;
    } finally {
      isLoading(false);
      log('FAQ finally');
    }
  }
}

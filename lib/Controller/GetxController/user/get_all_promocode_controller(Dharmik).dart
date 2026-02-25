import 'package:get/get.dart';

import '../../../ApiModel/user/GetAllPromoCodeModel.dart';

class GetAllPromoCodesController extends GetxController {
  GetAllPromoCodeModel? getAllPromoCodeModel;
  RxBool isLoading = true.obs;

  var promoCodes = <PromoCode>[].obs;
  var discountedPrice = 0.0.obs;
  var enteredPromoCode = ''.obs;
  var isPromoApplied = false.obs;

  // Future<GetAllPromoCodeModel?> fetchPromoCodes() async {
  //   final url = Uri.parse(Constant.BASE_URL + Constant.allPromoCode);
  //
  //   final headers = {
  //     'key': Constant.SECRET_KEY,
  //     'Content-Type': 'application/json; charset=UTF-8',
  //   };
  //
  //   final response = await http.get(url, headers: headers);
  //
  //   log('Get All PromoCode Api URL :: $url \n STATUS CODE :: ${response.statusCode} \n RESPONSE :: ${response.body}');
  //
  //   if (response.statusCode == 200) {
  //     final jsonData = json.decode(response.body);
  //     if (jsonData['status'] == true) {
  //       List<PromoCode> codes = [];
  //       for (var promo in jsonData['promoCode']) {
  //         PromoCode promoCode = PromoCode(
  //           id: promo['_id'],
  //           discountAmount: promo['discountAmount'],
  //           conditions: List<String>.from(promo['conditions']),
  //           promoCode: promo['promoCode'],
  //           discountType: promo['discountType'],
  //           createdAt: promo['createdAt'],
  //           updatedAt: promo['updatedAt'],
  //         );
  //         codes.add(promoCode);
  //       }
  //       promoCodes.value = codes;
  //     }
  //   }
  //   return null;
  // }

  void applyPromoCode() {
    final enteredCode = enteredPromoCode.value;
    if (enteredCode.isNotEmpty) {
      final matchedPromoCode = promoCodes.firstWhere(
        (promoCode) => promoCode.promoCode == enteredCode,
        orElse: () => PromoCode(
          id: '',
          discountAmount: 0,
          conditions: [],
          promoCode: '',
          discountType: 0,
          createdAt: '',
          updatedAt: '',
        ),
      );

      if (matchedPromoCode.promoCode!.isNotEmpty) {
        if (!isPromoApplied.value) {
          // Promo code is valid and matches
          applyDiscount(matchedPromoCode);
          isPromoApplied.value = true;
          Get.snackbar('Promo Code Applied', 'Discount has been applied.');
        } else {
          // Promo code has already been applied
          Get.snackbar('Promo Code Already Applied', 'You have already applied this promo code.',
              snackPosition: SnackPosition.BOTTOM);
        }
      } else {
        // Promo code is invalid or doesn't match,  and it hasn't been applied before
        Get.snackbar('Invalid Promo Code', 'Please enter a valid promo code.',
            snackPosition: SnackPosition.BOTTOM);
      }
    } else {
      // Promo code is empty
      Get.snackbar('Empty Promo Code', 'Please enter a promo code.', snackPosition: SnackPosition.BOTTOM);
    }
  }

  void applyDiscount(PromoCode promoCode) {
    if (promoCode.discountType == 0) {
      // Fixed amount discount
      discountedPrice.value -= int.parse(promoCode.discountAmount.toString());
    } else if (promoCode.discountType == 1) {
      // Percentage discount
      final discountPercentage = promoCode.discountAmount! / 100;
      discountedPrice.value -= discountedPrice.value * discountPercentage;
    }
  }
}

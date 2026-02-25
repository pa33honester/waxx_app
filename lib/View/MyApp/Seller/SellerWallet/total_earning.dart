import 'package:era_shop/utils/CoustomWidget/App_theme_services/primary_buttons.dart';
import 'package:era_shop/utils/CoustomWidget/App_theme_services/text_titles.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../Controller/GetxController/seller/seller_total_earning_controller.dart';
import '../../../../utils/CoustomWidget/App_theme_services/no_data_found.dart';

class TotalEarning extends StatefulWidget {
  const TotalEarning({Key? key}) : super(key: key);

  @override
  State<TotalEarning> createState() => _TotalEarningState();
}

class _TotalEarningState extends State<TotalEarning> {
  SellerTotalEarningController sellerTotalEarningController = Get.put(SellerTotalEarningController());

  @override
  void initState() {
    // TODO: implement initState
    sellerTotalEarningController.sellerWalletTotalAmount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            SizedBox(
              width: Get.width,
              height: double.maxFinite,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 10),
                    child: PrimaryRoundButton(
                      onTaped: () {
                        Get.back();
                        // Get.off(MyOrders(), transition: Transition.leftToRight);
                      },
                      icon: Icons.arrow_back_rounded,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: GeneralTitle(title: St.totalEarning.tr),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Obx(
          () => sellerTotalEarningController.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : sellerTotalEarningController.sellerTotalEarning!.sellerEarningAmount!.isEmpty
                  ? noDataFound(image: "assets/no_data_found/No Data Clipboard.png", text: St.walletIsEmpty.tr)
                  : ListView.builder(
                      shrinkWrap: true,
                      cacheExtent: 1000,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      itemCount: sellerTotalEarningController.sellerTotalEarning!.sellerEarningAmount!.length,
                      itemBuilder: (context, index) {
                        var sellerEarningAmount = sellerTotalEarningController.sellerTotalEarning!.sellerEarningAmount;
                        return Container(
                          height: 77,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                              color: isDark.value ? AppColors.lightBlack : AppColors.dullWhite,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(width: 0.8, color: AppColors.mediumGrey)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 14),
                            child: Row(
                              children: [
                                Container(
                                  height: 57,
                                  width: 57,
                                  decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(10)),
                                  child: Image.asset("assets/icons/credit.png").paddingAll(18),
                                ),
                                SizedBox(
                                  height: 57,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 15,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        SizedBox(
                                          width: Get.width / 2.5,
                                          child: Text(
                                            // overflow: TextOverflow.ellipsis,
                                            St.withdrawal.tr,
                                            style: GoogleFonts.plusJakartaSans(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "${St.date.tr} :- ${sellerEarningAmount![index].date}",
                                          style: GoogleFonts.plusJakartaSans(color: AppColors.darkGrey, fontSize: 11, fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  height: 35,
                                  decoration: BoxDecoration(color: AppColors.primaryGreen, borderRadius: BorderRadius.circular(50)),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 25),
                                      child: Text("${sellerEarningAmount[index].amount}",
                                          style: GoogleFonts.plusJakartaSans(color: AppColors.white, fontWeight: FontWeight.w600, fontSize: 13.6)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ).paddingOnly(bottom: 12);
                      },
                    ),
        ),
      ),
    );
  }
}

import 'package:waxxapp/utils/CoustomWidget/App_theme_services/primary_buttons.dart';
import 'package:waxxapp/utils/CoustomWidget/App_theme_services/text_titles.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MyPayment extends StatefulWidget {
  const MyPayment({Key? key}) : super(key: key);

  @override
  State<MyPayment> createState() => _MyPaymentState();
}

class _MyPaymentState extends State<MyPayment> {
  int selected = 0;
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: PrimaryRoundButton(
                          onTaped: () {
                            Get.back();
                          },
                          icon: Icons.arrow_back_rounded),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: GeneralTitle(title: St.myPayment.tr),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed("/AddNewCard");
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.darkGrey.withValues(alpha: 0.30))),
                          child: const Icon(
                            Icons.add,
                            // size: 22,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 15),
        child: PrimaryPinkButton(
            onTaped: () {
              Get.back();
            },
            text: St.selectPayment.tr),
      ),
      body: SafeArea(
          child: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {});
                        selected = 0;
                      },
                      child: Container(
                        height: 75,
                        width: double.maxFinite,
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                  height: 48,
                                  width: 48,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.grey, width: 0.5),
                                    // image: DecorationImage(
                                    //     image: AssetImage(
                                    //         "assets/icons/Group 1000003269.png"))
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(6),
                                    child: Image(image: AssetImage('assets/icons/Group 1000003269.png')),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SmallTitle(title: "BCA (Bank Central Asia)"),
                                  Text(
                                    "•••• •••• •••• 87652",
                                    style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 13.4, color: Colors.grey.shade600),
                                  ),
                                  Text(
                                    "Brooklyn Simmons",
                                    style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 13.4, color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15, right: 7),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {});
                            selected = 0;
                          },
                          child: SizedBox(
                            child: selected == 0
                                ? Container(
                                    height: 24,
                                    width: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.primaryPink,
                                    ),
                                    child: const Icon(Icons.done_outlined, color: Colors.white, size: 15),
                                  )
                                : Container(
                                    height: 24,
                                    width: 24,
                                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade400)),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: Get.width / 1.3,
                        child: Divider(
                          color: isDark.value ? AppColors.white : AppColors.darkGrey.withValues(alpha: 0.30),
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {});
                        selected = 1;
                      },
                      child: Container(
                        height: 75,
                        width: double.maxFinite,
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                  height: 48,
                                  width: 48,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.grey, width: 0.5),
                                    // image: DecorationImage(
                                    //     image: AssetImage(
                                    //         "assets/icons/Group 1000003269.png"))
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(7),
                                    child: Image(image: AssetImage('assets/icons/Logo.png')),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SmallTitle(title: "BCA (Bank Central Asia)"),
                                  Text(
                                    "•••• •••• •••• 87652",
                                    style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 13.4, color: Colors.grey.shade600),
                                  ),
                                  Text(
                                    "Brooklyn Simmons",
                                    style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 13.4, color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15, right: 7),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {});
                            selected = 1;
                          },
                          child: SizedBox(
                            child: selected == 1
                                ? Container(
                                    height: 24,
                                    width: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.primaryPink,
                                    ),
                                    child: const Icon(Icons.done_outlined, color: Colors.white, size: 15),
                                  )
                                : Container(
                                    height: 24,
                                    width: 24,
                                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade400)),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: Get.width / 1.3,
                        child: Divider(
                          color: isDark.value ? AppColors.white : AppColors.darkGrey.withValues(alpha: 0.30),
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}

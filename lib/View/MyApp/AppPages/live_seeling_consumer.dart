import 'package:era_shop/utils/CoustomWidget/App_theme_services/text_titles.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/all_images.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LiveSellingConsumer extends StatefulWidget {
  const LiveSellingConsumer({Key? key}) : super(key: key);

  @override
  State<LiveSellingConsumer> createState() => _LiveSellingConsumerState();
}

class _LiveSellingConsumerState extends State<LiveSellingConsumer> {
  bool isLiked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const Image(
              image: AssetImage("assets/Live_page_image/bgImage.jpg"),
              fit: BoxFit.cover,
            ),
            Column(
              children: [
                SizedBox(
                  height: Get.height / 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 20,
                              backgroundImage: AssetImage("assets/Live_page_image/profile.jpg"),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Jhone Arture",
                                    style: GoogleFonts.plusJakartaSans(color: AppColors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Love what you do",
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 38,
                        width: Get.width / 2.8,
                        decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.50), borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image(
                              image: AssetImage(AppImage.eyeImage),
                              height: 15.5,
                            ),
                            Text(
                              "1.25k",
                              style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.bold, color: AppColors.white),
                            ),
                            Container(
                              height: 26,
                              width: Get.width / 8,
                              decoration: BoxDecoration(color: AppColors.primaryRed, borderRadius: BorderRadius.circular(20)),
                              child: Center(
                                child: Text(
                                  St.liveText.tr,
                                  style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  // height: Get.height / (1.1) - 8,
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: Get.height / 1.6,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            child: Container(
                              height: 110,
                              width: Get.width / 1.4,
                              decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(9)),
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Icon(
                                        size: 20,
                                        Icons.highlight_remove_rounded,
                                        color: AppColors.black,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Padding(
                                      padding: const EdgeInsets.all(11),
                                      child: Container(
                                        height: 30,
                                        width: 75,
                                        decoration: BoxDecoration(color: AppColors.primaryPink, borderRadius: BorderRadius.circular(6)),
                                        child: Center(
                                            child: Text(
                                          "Buy Now",
                                          style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.white, fontWeight: FontWeight.bold),
                                        )),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        child: Container(
                                          height: 85,
                                          width: 80,
                                          decoration: BoxDecoration(
                                              image: const DecorationImage(image: AssetImage("assets/Live_page_image/trd.png"), fit: BoxFit.cover),
                                              borderRadius: BorderRadius.circular(10)),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          SizedBox(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Kendow Premium...",
                                                  style:
                                                      GoogleFonts.plusJakartaSans(color: AppColors.black, fontSize: 13, fontWeight: FontWeight.w500),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 5),
                                                  child: Text(
                                                    "Size S,M,L,XL",
                                                    style: GoogleFonts.plusJakartaSans(
                                                        color: AppColors.black, fontSize: 11, fontWeight: FontWeight.w300),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            "$currencySymbol 95",
                                            style: GoogleFonts.plusJakartaSans(color: Colors.black, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.bottomSheet(
                                      barrierColor: Colors.transparent,
                                      isScrollControlled: true,
                                      Container(
                                        height: Get.height / 1.5,
                                        decoration: BoxDecoration(
                                            color: isDark.value ? AppColors.blackBackground : const Color(0xffffffff),
                                            borderRadius: const BorderRadius.vertical(top: Radius.circular(25))),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                          child: SizedBox(
                                            child: Stack(
                                              children: [
                                                SingleChildScrollView(
                                                  physics: const BouncingScrollPhysics(),
                                                  child: Column(
                                                    children: [
                                                      const SizedBox(
                                                        height: 60,
                                                      ),
                                                      SizedBox(
                                                        child: ListView.builder(
                                                          shrinkWrap: true,
                                                          physics: const NeverScrollableScrollPhysics(),
                                                          itemCount: justForYouImage.length,
                                                          scrollDirection: Axis.vertical,
                                                          itemBuilder: (context, index) {
                                                            return Padding(
                                                              padding: const EdgeInsets.symmetric(vertical: 7),
                                                              child: SizedBox(
                                                                height: Get.height / 8.2,
                                                                child: Stack(
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      children: [
                                                                        Container(
                                                                          width: Get.width / 4.3,
                                                                          decoration: BoxDecoration(
                                                                              image: DecorationImage(
                                                                                  image: AssetImage(justForYouImage[index]), fit: BoxFit.cover),
                                                                              borderRadius: BorderRadius.circular(15)),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(left: 15),
                                                                          child: Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                            children: [
                                                                              SizedBox(
                                                                                child: Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      justForYouName[index],
                                                                                      style: GoogleFonts.plusJakartaSans(
                                                                                          fontSize: 16, fontWeight: FontWeight.w500),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.only(top: 5),
                                                                                      child: Text(
                                                                                        "Size S,M,L,XL",
                                                                                        style:
                                                                                            GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w300),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                "$currencySymbol${justForYouPrise[index]}",
                                                                                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    Align(
                                                                      alignment: Alignment.bottomRight,
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.all(11),
                                                                        child: Container(
                                                                          height: 30,
                                                                          width: 75,
                                                                          decoration: BoxDecoration(
                                                                              color: AppColors.primaryPink, borderRadius: BorderRadius.circular(6)),
                                                                          child: Center(
                                                                              child: Text(
                                                                            "Buy Now",
                                                                            style: GoogleFonts.plusJakartaSans(
                                                                                fontSize: 12, color: AppColors.white, fontWeight: FontWeight.bold),
                                                                          )),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.topCenter,
                                                  child: Container(
                                                    height: 62,
                                                    decoration: BoxDecoration(
                                                      color: isDark.value ? AppColors.blackBackground : const Color(0xffffffff),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        const SizedBox(
                                                          height: 18,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            SmallTitle(title: St.liveSelling.tr),
                                                            Padding(
                                                              padding: const EdgeInsets.only(right: 5),
                                                              child: Obx(
                                                                () => Image(
                                                                  image:
                                                                      isDark.value ? AssetImage(AppImage.lightcart) : AssetImage(AppImage.darkcart),
                                                                  height: 22,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 6,
                                                        ),
                                                        Obx(
                                                          () => Divider(
                                                            color: isDark.value ? AppColors.white : AppColors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 49,
                                    width: 49,
                                    decoration: const BoxDecoration(
                                      color: Colors.grey,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Image(image: AssetImage(AppImage.redCart)),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 49,
                                  width: Get.width / 1.7,
                                  child: TextFormField(
                                    cursorColor: AppColors.unselected,
                                    maxLines: null,
                                    // style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                                    decoration: InputDecoration(
                                        filled: true,
                                        suffixIcon: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Image(image: AssetImage(AppImage.sendMessage)),
                                        ),
                                        hintText: St.writeHereTF.tr,
                                        fillColor: const Color(0xffF6F8FE),
                                        hintStyle: const TextStyle(color: Color(0xff9CA4AB), fontSize: 13),
                                        enabledBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(30)),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(color: AppColors.primaryPink), borderRadius: BorderRadius.circular(30))),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {});
                                    isLiked = !isLiked;
                                  },
                                  child: Container(
                                    height: 49,
                                    width: 49,
                                    decoration: const BoxDecoration(
                                      color: Color(0xffF6F8FE),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(13),
                                      child: Image(
                                        image: isLiked ? AssetImage(AppImage.productDislike) : AssetImage(AppImage.productLike),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List justForYouImage = [
    "assets/Home_page_image/just_for_you/Rectangle 22431.png",
    "assets/Home_page_image/just_for_you/Rectangle 22431 (1).png",
    "assets/Home_page_image/just_for_you/Rectangle 22431 (2).png",
    "assets/Home_page_image/just_for_you/Group 1000003097.png",
    "assets/Home_page_image/just_for_you/Rectangle 22431.png",
  ];
  List justForYouName = [
    "Kendow Premium T-shirt",
    "Bondera Premium T-shirt",
    "Degra Premium T-shirt",
    "Dress Rehia",
    "Kendow Premium T-shirt",
  ];
  List justForYouPrise = [
    "95",
    "95",
    "89",
    "85",
    "95",
  ];
}

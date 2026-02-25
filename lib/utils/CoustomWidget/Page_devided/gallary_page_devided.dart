import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

galleryFlashSale() {
  List flashSaleImage = [
    "assets/gallary_image/flash_sale/Rectangle 22436.png",
    "assets/gallary_image/flash_sale/Rectangle 22436 (1).png",
    "assets/gallary_image/flash_sale/Rectangle 22436 (2).png",
    "assets/gallary_image/flash_sale/Rectangle 22436 (3).png",
    "assets/gallary_image/flash_sale/Rectangle 22436 (4).png",
  ];
  List flashSaleName = [
    "Alexy T shirt",
    "Potentia Dress",
    "Londia Dress",
    "Aloy t shirt",
    "Denim t shirt",
  ];
  List flashSalePrise = [
    "23",
    "23",
    "28",
    "15",
    "17",
  ];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              St.flashSale.tr,
              style: GoogleFonts.plusJakartaSans(color: AppColors.primaryPink, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Container(
              height: 32,
              width: 80,
              decoration: BoxDecoration(color: AppColors.black, borderRadius: BorderRadius.circular(7)),
              child: Center(
                child: Text(
                  "02:30:43",
                  style: GoogleFonts.plusJakartaSans(fontSize: 14, color: AppColors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: SizedBox(
          height: Get.height / 5.6,
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 15),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: flashSaleImage.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: SizedBox(
                  width: Get.width / 4.4,
                  // color: Colors.blue,
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: Get.height / 8,
                            decoration: BoxDecoration(
                                image: DecorationImage(image: AssetImage(flashSaleImage[index]), fit: BoxFit.cover),
                                // color: Colors.black,
                                borderRadius: BorderRadius.circular(6)),
                          ),
                          Text(
                            flashSaleName[index],
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            "$currencySymbol ${flashSalePrise[index]}",
                            style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    ],
  );
}

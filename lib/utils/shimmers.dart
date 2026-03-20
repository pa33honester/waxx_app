import 'package:waxxapp/seller_pages/listing/controller/listing_controller.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class Shimmers {
  static Shimmer productGridviewShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.darkGrey.withValues(alpha: 0.15),
      highlightColor: AppColors.lightGrey.withValues(alpha: 0.15),
      child: GridView.builder(
        padding: const EdgeInsets.only(top: 10),
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: 10,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 2,
          crossAxisSpacing: 14,
          crossAxisCount: 2,
          mainAxisExtent: 49.2 * 5,
        ),
        itemBuilder: (context, index) {
          return SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 190,
                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 7),
                    child: Container(
                      height: 15,
                      width: 110,
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(50)),
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 7),
                    child: Container(
                      height: 15,
                      width: 70,
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(50)),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }

  static Shimmer wishListShimmer() {
    return Shimmer.fromColors(
        baseColor: AppColors.darkGrey.withValues(alpha: 0.15),
        highlightColor: AppColors.lightGrey.withValues(alpha: 0.15),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: 7,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SizedBox(
                // color: Colors.deepPurple.shade200,
                height: 120,
                child: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: Get.width / 4.3,
                          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(15)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 7, bottom: 15),
                                child: Container(
                                  height: 30,
                                  width: 150,
                                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(50)),
                                ),
                              ),
                              Container(
                                height: 20,
                                width: 90,
                                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(50)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5, right: 15),
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }

  static Shimmer justForYouProductsShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.darkGrey.withValues(alpha: 0.35),
      highlightColor: AppColors.lightGrey.withValues(alpha: 0.35),
      child: ListView.builder(
        itemCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            height: 132,
            width: Get.width,
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.tabBackground.withValues(alpha: .7),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                1.width,
                Container(
                  height: 110,
                  width: 110,
                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 16,
                        width: 170,
                        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                      ),
                      10.height,
                      Container(
                        height: 16,
                        width: 130,
                        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                      ),
                      10.height,
                      Container(
                        height: 16,
                        width: 90,
                        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                      ),
                      10.height,
                      Row(
                        children: [
                          Container(
                            height: 16,
                            width: 120,
                            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                          ),
                          Spacer(),
                          Container(
                            height: 20,
                            width: 60,
                            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(8)),
                          ),
                        ],
                      ),
                      5.height,
                    ],
                  ).paddingOnly(left: 10),
                ),
              ],
            ),
          );
        },
      ).paddingOnly(top: 22),
    );
  }

  static Shimmer cartShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.darkGrey.withValues(alpha: 0.35),
      highlightColor: AppColors.lightGrey.withValues(alpha: 0.35),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              height: 132,
              width: Get.width,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.tabBackground.withValues(alpha: .7),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  1.width,
                  Container(
                    height: 110,
                    width: 110,
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 16,
                          width: 170,
                          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                        ),
                        10.height,
                        Container(
                          height: 16,
                          width: 130,
                          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                        ),
                        10.height,
                        Container(
                          height: 16,
                          width: 90,
                          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                        ),
                        10.height,
                        Row(
                          children: [
                            Container(
                              height: 16,
                              width: 120,
                              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                            ),
                            Spacer(),
                            Container(
                              height: 20,
                              width: 60,
                              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(8)),
                            ),
                          ],
                        ),
                        5.height,
                      ],
                    ).paddingOnly(left: 10),
                  ),
                ],
              ),
            );
          },
        ).paddingOnly(top: 22),
      ),
    );
  }

  static Shimmer catalogProductShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.darkGrey.withValues(alpha: 0.35),
      highlightColor: AppColors.lightGrey.withValues(alpha: 0.35),
      child: ListView.builder(
        itemCount: 7,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            height: 120,
            width: Get.width,
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.tabBackground.withValues(alpha: .7),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                1.width,
                Container(
                  height: 110,
                  width: 110,
                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 16,
                        width: 170,
                        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                      ),
                      10.height,
                      Container(
                        height: 16,
                        width: 130,
                        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                      ),
                      10.height,
                      Container(
                        height: 16,
                        width: 90,
                        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                      ),
                      10.height,
                      Container(
                        height: 16,
                        width: 120,
                        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                      ),
                      5.height,
                    ],
                  ).paddingOnly(left: 10),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static Shimmer myOrderShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.darkGrey.withValues(alpha: 0.15),
      highlightColor: AppColors.lightGrey.withValues(alpha: 0.15),
      child: ListView.builder(
        itemCount: 7,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            width: Get.width,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.tabBackground.withValues(alpha: .7),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                8.height,
                Container(
                  // padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.03),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 20,
                        width: 100,
                        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                      ),
                      const Spacer(),
                      Container(
                        height: 20,
                        width: 80,
                        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                      ),
                    ],
                  ),
                ),
                22.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    1.width,
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 16,
                            width: Get.width / 2,
                            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                          ),
                          10.height,
                          Container(
                            height: 16,
                            width: 150,
                            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                          ),
                          10.height,
                          Row(
                            children: [
                              Container(
                                height: 16,
                                width: 100,
                                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                              ),
                              Spacer(),
                              Container(
                                height: 20,
                                width: 60,
                                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                              ),
                            ],
                          ),
                        ],
                      ).paddingOnly(left: 10),
                    ),
                  ],
                ),
                22.height,
                Container(
                  height: 50,
                  width: Get.width,
                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(30)),
                ),
                20.height,
                Row(
                  children: [
                    Container(
                      height: 20,
                      width: 100,
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                    ),
                    const Spacer(),
                    Container(
                      height: 20,
                      width: 80,
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                    ),
                  ],
                ),
                10.height,
              ],
            ),
          );
        },
      ),
    );
  }

  static Shimmer sellerOrderShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.darkGrey.withValues(alpha: 0.15),
      highlightColor: AppColors.lightGrey.withValues(alpha: 0.15),
      child: ListView.builder(
        itemCount: 7,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            width: Get.width,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.tabBackground.withValues(alpha: .7),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                8.height,
                Container(
                  // padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.03),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 20,
                        width: 100,
                        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                      ),
                      const Spacer(),
                      Container(
                        height: 20,
                        width: 80,
                        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                      ),
                    ],
                  ),
                ),
                22.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    1.width,
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 16,
                            width: Get.width / 2,
                            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                          ),
                          10.height,
                          Container(
                            height: 16,
                            width: 150,
                            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                          ),
                          10.height,
                          Row(
                            children: [
                              Container(
                                height: 16,
                                width: 100,
                                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                              ),
                              Spacer(),
                              Container(
                                height: 20,
                                width: 60,
                                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                              ),
                            ],
                          ),
                        ],
                      ).paddingOnly(left: 10),
                    ),
                  ],
                ),
                20.height,
                Row(
                  children: [
                    Container(
                      height: 20,
                      width: 100,
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                    ),
                    const Spacer(),
                    Container(
                      height: 20,
                      width: 80,
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                    ),
                  ],
                ),
                10.height,
              ],
            ),
          );
        },
      ),
    );
  }

  static Shimmer listViewProductHorizontal() {
    return Shimmer.fromColors(
      baseColor: AppColors.darkGrey.withValues(alpha: 0.15),
      highlightColor: AppColors.lightGrey.withValues(alpha: 0.15),
      child: SizedBox(
        height: 150,
        child: ListView.builder(
          padding: const EdgeInsets.only(left: 18),
          cacheExtent: 1000,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: 3,
          itemBuilder: (context, index) {
            return SizedBox(
              width: 152,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 170,
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: Container(
                        height: 15,
                        width: 110,
                        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(50)),
                      )),
                  Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: Container(
                        height: 15,
                        width: 70,
                        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(50)),
                      )),
                ],
              ),
            ).paddingOnly(right: 18);
          },
        ),
      ),
    );
  }

  static Shimmer listViewShortHomePage() {
    return Shimmer.fromColors(
      baseColor: AppColors.darkGrey.withValues(alpha: 0.15),
      highlightColor: AppColors.lightGrey.withValues(alpha: 0.15),
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 12),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: 4,
        itemBuilder: (context, index) {
          return Container(
            height: 200,
            width: 140,
            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
          ).paddingOnly(right: 18);
        },
      ),
    );
  }

  static Shimmer productDetailsShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.darkGrey.withValues(alpha: 0.15),
      highlightColor: AppColors.lightGrey.withValues(alpha: 0.15),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 400,
                      decoration: BoxDecoration(
                        color: AppColors.tabBackground.withValues(alpha: .7),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 420,
                            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(25)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 20,
                                  width: Get.width / 2,
                                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(15)),
                                ),
                                14.height,
                                Container(
                                  height: 12,
                                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(15)),
                                ),
                                8.height,
                                Container(
                                  height: 12,
                                  width: Get.width / 1.5,
                                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(15)),
                                ),
                                12.height,
                                Container(
                                  height: 14,
                                  width: Get.width / 1.6,
                                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(15)),
                                ),
                                12.height,
                                Container(
                                  height: 20,
                                  width: Get.width / 4,
                                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(15)),
                                ),
                                10.height,
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Container(
                        height: 24,
                        width: 170,
                        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                    14.height,
                    Container(
                      height: 40,
                      width: 80,
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 22),
                      child: Container(
                        height: 24,
                        width: 170,
                        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                    14.height,
                    Container(
                      height: 40,
                      width: 80,
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                ),
                24.width,
                Expanded(
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                12.width,
                Expanded(
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  static Shimmer sellerMyOrderShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.darkGrey.withValues(alpha: 0.15),
      highlightColor: AppColors.lightGrey.withValues(alpha: 0.15),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 22,
                          width: Get.width / 3,
                          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                        ),
                        Spacer(),
                        Container(
                          height: 40,
                          width: Get.width / 3.5,
                          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                        ),
                      ],
                    ),
                    36.height,
                    Container(
                      width: 400,
                      decoration: BoxDecoration(
                        color: AppColors.tabBackground.withValues(alpha: .7),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 22,
                                  width: Get.width / 3,
                                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(15)),
                                ),
                                22.height,
                                Container(
                                  height: 2,
                                  width: Get.width,
                                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(15)),
                                ),
                                22.height,
                                Row(
                                  children: [
                                    Container(
                                      height: 18,
                                      width: Get.width / 4,
                                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(15)),
                                    ),
                                    Spacer(),
                                    Container(
                                      height: 18,
                                      width: 60,
                                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(15)),
                                    ),
                                  ],
                                ),
                                22.height,
                                Container(
                                  height: 2,
                                  width: Get.width,
                                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(15)),
                                ),
                                22.height,
                                Row(
                                  children: [
                                    Container(
                                      height: 18,
                                      width: Get.width / 3,
                                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(15)),
                                    ),
                                    Spacer(),
                                    Container(
                                      height: 18,
                                      width: 60,
                                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(15)),
                                    ),
                                  ],
                                ),
                                22.height,
                                Container(
                                  height: 2,
                                  width: Get.width,
                                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(15)),
                                ),
                                22.height,
                                Row(
                                  children: [
                                    Container(
                                      height: 18,
                                      width: Get.width / 2.3,
                                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(15)),
                                    ),
                                    Spacer(),
                                    Container(
                                      height: 18,
                                      width: 60,
                                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(15)),
                                    ),
                                  ],
                                ),
                                22.height,
                                Container(
                                  height: 2,
                                  width: Get.width,
                                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(15)),
                                ),
                                22.height,
                                Row(
                                  children: [
                                    Container(
                                      height: 18,
                                      width: Get.width / 3,
                                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(15)),
                                    ),
                                    Spacer(),
                                    Container(
                                      height: 18,
                                      width: 60,
                                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(15)),
                                    ),
                                  ],
                                ),
                                22.height,
                                Container(
                                  height: 2,
                                  width: Get.width,
                                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(15)),
                                ),
                                22.height,
                                Row(
                                  children: [
                                    Container(
                                      height: 18,
                                      width: Get.width / 4,
                                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(15)),
                                    ),
                                    Spacer(),
                                    Container(
                                      height: 18,
                                      width: 60,
                                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(15)),
                                    ),
                                  ],
                                ),
                                10.height,
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    30.height,
                    Container(
                      width: 400,
                      decoration: BoxDecoration(
                        color: AppColors.tabBackground.withValues(alpha: .7),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              height: 18,
                              width: Get.width / 4.4,
                              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(15)),
                            ),
                            Spacer(),
                            Container(
                              height: 18,
                              width: 40,
                              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(15)),
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
        ],
      ),
    );
  }

  static Shimmer checkoutShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.darkGrey.withValues(alpha: 0.15),
      highlightColor: AppColors.lightGrey.withValues(alpha: 0.15),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.tabBackground.withValues(alpha: .7),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 20,
                                  width: Get.width / 2,
                                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(15)),
                                ),
                                15.height,
                                Container(
                                  height: 1.5,
                                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(15)),
                                ),
                                15.height,
                                Container(
                                  height: 20,
                                  width: Get.width / 4,
                                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(15)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Container(
                        height: 24,
                        width: 170,
                        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                    18.height,
                    Container(
                      height: 16,
                      width: Get.width / 1.7,
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                    ),
                    16.height,
                    Container(
                      height: 50,
                      width: Get.width,
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                    ),
                    24.height,
                    // for (int i = 0; i <= 3; i++)
                    Row(
                      children: [
                        Container(
                          height: 20,
                          width: Get.width / 3.8,
                          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                        ),
                        Spacer(),
                        Container(
                          height: 20,
                          width: Get.width / 3.5,
                          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                        ),
                      ],
                    ),
                    12.height,
                    Row(
                      children: [
                        Container(
                          height: 20,
                          width: Get.width / 2.8,
                          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                        ),
                        Spacer(),
                        Container(
                          height: 20,
                          width: Get.width / 4.8,
                          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                        ),
                      ],
                    ),
                    15.height,
                    Container(
                      height: 1.5,
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(15)),
                    ),
                    15.height,
                    Row(
                      children: [
                        Container(
                          height: 20,
                          width: Get.width / 4,
                          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                        ),
                        Spacer(),
                        Container(
                          height: 20,
                          width: Get.width / 4.2,
                          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  height: 50,
                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  static Shimmer lastSearchProductShimmer() {
    return Shimmer.fromColors(
        baseColor: AppColors.darkGrey.withValues(alpha: 0.15),
        highlightColor: AppColors.lightGrey.withValues(alpha: 0.15),
        child: SizedBox(
          height: Get.height / 6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 20,
                    width: 20,
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  ).paddingOnly(right: 10),
                  Container(
                    height: 15,
                    width: 125,
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(15)),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    height: 20,
                    width: 20,
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  ).paddingOnly(right: 10),
                  Container(
                    height: 15,
                    width: 170,
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(15)),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    height: 20,
                    width: 20,
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  ).paddingOnly(right: 10),
                  Container(
                    height: 15,
                    width: 145,
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(15)),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    height: 20,
                    width: 20,
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  ).paddingOnly(right: 10),
                  Container(
                    height: 15,
                    width: 145,
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(15)),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    height: 20,
                    width: 20,
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  ).paddingOnly(right: 10),
                  Container(
                    height: 15,
                    width: 145,
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(15)),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  static Shimmer notificationShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.darkGrey.withValues(alpha: 0.15),
      highlightColor: AppColors.lightGrey.withValues(alpha: 0.15),
      child: ListView.builder(
        itemCount: 7,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            width: Get.width,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.tabBackground.withValues(alpha: .7),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    1.width,
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                    ),
                    4.width,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 16,
                            width: Get.width / 2,
                            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                          ),
                          10.height,
                          Container(
                            height: 16,
                            width: 150,
                            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                          ),
                        ],
                      ).paddingOnly(left: 10),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static Shimmer popularSearchProductShimmer() {
    return Shimmer.fromColors(
        baseColor: AppColors.darkGrey.withValues(alpha: 0.15),
        highlightColor: AppColors.lightGrey.withValues(alpha: 0.15),
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 5,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: SizedBox(
                height: Get.height / 11,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: Get.width / 5.5,
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(15)),
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  height: 14,
                                  width: 140,
                                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(15)),
                                ),
                                Container(
                                  height: 11,
                                  width: 90,
                                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(15)),
                                ).paddingOnly(top: 7),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ));
  }

  static Shimmer sellerLiveStreamingBottomSheetShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.darkGrey.withValues(alpha: 0.60),
      highlightColor: AppColors.lightGrey.withValues(alpha: 0.50),
      child: SizedBox(
        width: 100,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: 3,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
              height: 110,
              width: 75,
              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(6)),
            ).paddingSymmetric(vertical: 6, horizontal: 5);
          },
        ),
      ),
    );
  }

  static Shimmer liveSellerShow() {
    return Shimmer.fromColors(
      baseColor: AppColors.darkGrey.withValues(alpha: 0.15),
      highlightColor: AppColors.lightGrey.withValues(alpha: 0.15),
      child: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: SizedBox(
          height: Get.height / 10,
          width: Get.width,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: 7,
            padding: const EdgeInsets.only(left: 20),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: Get.width / 23),
                child: Container(
                  height: 56,
                  width: 56,
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  static Shimmer addToCartBottomSheet() {
    return Shimmer.fromColors(
        baseColor: AppColors.darkGrey.withValues(alpha: 0.15),
        highlightColor: AppColors.lightGrey.withValues(alpha: 0.15),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 20,
                  width: 75,
                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(50)),
                ).paddingOnly(top: 25),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Container(
                    height: 60,
                    width: Get.width,
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(50)),
                  ),
                ),
                Container(
                  height: 20,
                  width: 75,
                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(50)),
                ).paddingOnly(top: 18),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Container(
                    height: 60,
                    width: Get.width,
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(50)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Container(
                    height: 60,
                    width: Get.width,
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(50)),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  static Shimmer reelsView() {
    return Shimmer.fromColors(
        baseColor: AppColors.darkGrey.withValues(alpha: 0.35),
        highlightColor: AppColors.lightGrey.withValues(alpha: 0.35),
        child: SizedBox(
          height: Get.height,
          width: Get.width,
          child: Stack(
            children: [
              GestureDetector(
                child: Container(
                  color: Colors.red.withValues(alpha: 0.18),
                  height: (Get.height - 60),
                  width: Get.width,
                  child: SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Container(
                        width: Get.width,
                        height: Get.height,
                        color: Colors.red.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 12,
                child: Container(
                  padding: const EdgeInsets.only(top: 30, bottom: 100),
                  height: Get.height,
                  child: Column(
                    children: [
                      const Spacer(),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 90,
                    width: Get.width / 1.40,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.red.withValues(alpha: 0.5)),
                    child: Row(
                      children: [
                        Container(
                          clipBehavior: Clip.antiAlias,
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.red.withValues(alpha: 0.7)),
                        ).paddingOnly(left: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                clipBehavior: Clip.antiAlias,
                                height: 10,
                                width: 90,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.red.withValues(alpha: 0.7)),
                              ),
                              Container(
                                clipBehavior: Clip.antiAlias,
                                height: 10,
                                width: 110,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.red.withValues(alpha: 0.7)),
                              ).paddingOnly(top: 6),
                              const Spacer(),
                              Row(
                                children: [
                                  Container(
                                    clipBehavior: Clip.antiAlias,
                                    height: 16,
                                    width: 60,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.red.withValues(alpha: 0.7)),
                                  ),
                                ],
                              )
                            ],
                          ).paddingSymmetric(vertical: 13, horizontal: 7),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 43,
                        width: 43,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red.withValues(alpha: 0.7)),
                      ).paddingOnly(right: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 16,
                                width: 110,
                                decoration: BoxDecoration(
                                  color: Colors.red.withValues(alpha: 0.7),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ).paddingOnly(right: 8),
                              Container(
                                height: 25,
                                width: 60,
                                decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.7), borderRadius: BorderRadius.circular(8)),
                              ),
                            ],
                          ).paddingOnly(bottom: 10),
                          Container(
                            width: Get.width * 0.3,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ).paddingOnly(bottom: 16),
                        ],
                      ),
                    ],
                  ),
                  10.height,
                  Container(
                    width: Get.width * 0.6,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ).paddingOnly(bottom: 6),
                  Container(
                    width: Get.width * 0.3,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ).paddingOnly(bottom: 16),
                  90.height
                ],
              ).paddingOnly(left: 16),
            ],
          ),
        ));
  }

  static Shimmer auctionBidShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.darkGrey.withValues(alpha: 0.35),
      highlightColor: AppColors.lightGrey.withValues(alpha: 0.35),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              // height: 132,
              width: Get.width,
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.tabBackground.withValues(alpha: .7),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      1.width,
                      Container(
                        height: 110,
                        width: 110,
                        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 16,
                              width: 100,
                              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                            ),
                            10.height,
                            Container(
                              height: 16,
                              width: 170,
                              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                            ),
                            10.height,
                            Container(
                              height: 22,
                              width: 50,
                              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(8)),
                            ),
                            10.height,
                            Row(
                              children: [
                                Container(
                                  height: 16,
                                  width: 120,
                                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                                ),
                                Spacer(),
                                Container(
                                  height: 20,
                                  width: 60,
                                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(8)),
                                ),
                              ],
                            ),
                            5.height,
                          ],
                        ).paddingOnly(left: 10),
                      ),
                    ],
                  ),
                  Utils.buildDivider(),
                  Container(
                    height: 44,
                    width: Get.width,
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  static Shimmer withdrawShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.darkGrey.withValues(alpha: 0.15),
      highlightColor: AppColors.lightGrey.withValues(alpha: 0.15),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            15.height,
            Container(
              width: 400,
              decoration: BoxDecoration(
                color: AppColors.tabBackground.withValues(alpha: .7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        6.height,
                        Container(
                          height: 20,
                          width: Get.width / 2,
                          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(15)),
                        ),
                        16.height,
                        Container(
                          height: 20,
                          width: Get.width / 4,
                          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(15)),
                        ),
                        6.height,
                      ],
                    ),
                  ),
                ],
              ),
            ),
            24.height,
            Container(
              height: 18,
              width: Get.width / 3,
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(color: AppColors.tabBackground.withValues(alpha: .7), borderRadius: BorderRadius.circular(30)),
            ),
            Container(
              height: 54,
              width: Get.width,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(color: AppColors.tabBackground.withValues(alpha: .7), borderRadius: BorderRadius.circular(15)),
            ),
            20.height,
            Container(
              height: 18,
              width: Get.width / 3,
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(color: AppColors.tabBackground.withValues(alpha: .7), borderRadius: BorderRadius.circular(30)),
            ),
            Container(
              height: 54,
              width: Get.width,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(color: AppColors.tabBackground.withValues(alpha: .7), borderRadius: BorderRadius.circular(15)),
            ),
            Spacer(),
            Container(
              height: 54,
              width: Get.width,
              margin: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
              decoration: BoxDecoration(color: AppColors.tabBackground.withValues(alpha: .7), borderRadius: BorderRadius.circular(50)),
            ),
          ],
        ),
      ),
    );
  }

  static Shimmer coinHistoryShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.darkGrey.withValues(alpha: 0.15),
      highlightColor: AppColors.lightGrey.withValues(alpha: 0.15),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            15.height,
            Container(
              height: 148,
              width: Get.width,
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(color: AppColors.black, borderRadius: BorderRadius.circular(30)),
            ),
            Container(
              height: 25,
              width: 150,
              margin: const EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(color: AppColors.black, borderRadius: BorderRadius.circular(8)),
            ),
            Container(
              height: 54,
              width: Get.width,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(color: AppColors.black, borderRadius: BorderRadius.circular(15)),
            ),
            Container(
              height: 25,
              width: 150,
              margin: const EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(color: AppColors.black, borderRadius: BorderRadius.circular(8)),
            ),
            Container(
              height: 54,
              width: Get.width,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(color: AppColors.black, borderRadius: BorderRadius.circular(15)),
            ),
            Spacer(),
            Container(
              height: 54,
              width: Get.width,
              margin: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
              decoration: BoxDecoration(color: AppColors.black, borderRadius: BorderRadius.circular(50)),
            ),
          ],
        ),
      ),
    );
  }

  static Shimmer viewBidShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.darkGrey.withValues(alpha: 0.15),
      highlightColor: AppColors.lightGrey.withValues(alpha: 0.15),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            15.height,
            Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(color: AppColors.black, borderRadius: BorderRadius.circular(60)),
                ),
                10.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 16,
                      width: Get.width / 2,
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(color: AppColors.black, borderRadius: BorderRadius.circular(10)),
                    ),
                    // 2.height,
                    Container(
                      height: 16,
                      width: Get.width / 3,
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(color: AppColors.black, borderRadius: BorderRadius.circular(10)),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  static description() {
    final controller = Get.find<ListingController>();
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.tabBackground),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Shimmer.fromColors(
                        baseColor: AppColors.darkGrey.withValues(alpha: 0.15),
                        highlightColor: AppColors.lightGrey.withValues(alpha: 0.15),
                        child: Container(
                          width: double.infinity,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Shimmer.fromColors(
                        baseColor: AppColors.darkGrey.withValues(alpha: 0.15),
                        highlightColor: AppColors.lightGrey.withValues(alpha: 0.15),
                        child: Container(
                          width: double.infinity,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Shimmer.fromColors(
                        baseColor: AppColors.darkGrey.withValues(alpha: 0.15),
                        highlightColor: AppColors.lightGrey.withValues(alpha: 0.15),
                        child: Container(
                          width: double.infinity,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Shimmer.fromColors(
                        baseColor: AppColors.darkGrey.withValues(alpha: 0.15),
                        highlightColor: AppColors.lightGrey.withValues(alpha: 0.15),
                        child: Container(
                          width: double.infinity,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Shimmer.fromColors(
                        baseColor: AppColors.darkGrey.withValues(alpha: 0.15),
                        highlightColor: AppColors.lightGrey.withValues(alpha: 0.15),
                        child: Container(
                          width: 150,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (controller.isAutoGenerateOn.value) 40.width,
      ],
    );
  }

  static Shimmer applyPromoCodeShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.darkGrey.withValues(alpha: 0.15),
      highlightColor: AppColors.lightGrey.withValues(alpha: 0.15),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: 7,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              // height: 120,
              width: Get.width,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.tabBackground.withValues(alpha: .7),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  1.width,
                  Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 16,
                          width: 150,
                          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                        ),
                        10.height,
                        Container(
                          height: 12,
                          width: Get.width / 2,
                          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                        ),
                        8.height,
                        Container(
                          height: 12,
                          width: 120,
                          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                        ),
                        5.height,
                      ],
                    ).paddingOnly(left: 10),
                  ),
                  Container(
                    height: 30,
                    width: 60,
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(16)),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class TextOverlayShimmer extends StatelessWidget {
  final bool isLoading;
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final TextStyle? textStyle;
  final TextStyle? shimmerTextStyle;

  const TextOverlayShimmer({
    super.key,
    required this.isLoading,
    required this.text,
    this.textStyle,
    this.shimmerTextStyle,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w500,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          text,
          // overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: shimmerTextStyle ??
              TextStyle(
                fontSize: fontSize,
                fontWeight: fontWeight,
                color: isLoading ? AppColors.shimmer : AppColors.black,
              ),
        ),
        if (isLoading)
          Positioned.fill(
            child: Shimmer.fromColors(
              baseColor: AppColors.shimmer,
              highlightColor: AppColors.white,
              child: Text(text, overflow: TextOverflow.ellipsis, maxLines: 1, style: textStyle ?? AppFontStyle.styleW700(AppColors.shimmer, fontSize)
                  // TextStyle(
                  //   fontSize: fontSize,
                  //   fontWeight: fontWeight,
                  //   color: AppColors.shimmer,
                  // ),
                  ),
            ),
          ),
      ],
    );
  }
}

class ProductListViewShimmer extends StatelessWidget {
  const ProductListViewShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.darkGrey.withValues(alpha: 0.15),
      highlightColor: AppColors.lightGrey.withValues(alpha: 0.15),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: 6,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              color: AppColors.grayLight.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: AppColors.grayLight),
            ),
            child: Column(
              children: [
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Image shimmer placeholder
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(12)),
                    ),
                    // Content shimmer placeholder
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Product name shimmer
                                Container(
                                  height: 14,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  height: 14,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      height: 10,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      height: 20,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Container(
                                      height: 20,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // Price shimmer
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 1,
                  color: AppColors.unselected.withValues(alpha: .5),
                  margin: const EdgeInsets.symmetric(vertical: 12),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 18,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Container(
                      height: 18,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

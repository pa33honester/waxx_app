import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomStepWidget extends StatelessWidget {
  const CustomStepWidget({super.key, required this.step, required this.selectedColor, required this.unselectedColor});

  final int step;
  final Color selectedColor;
  final Color unselectedColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 80,
      width: Get.width,
      color: Colors.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 5,
            width: 5,
            margin: const EdgeInsets.only(top: 15),
            decoration: BoxDecoration(
              color: step < 1 ? unselectedColor : selectedColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
          ),
          Container(
            width: 100,
            color: Colors.transparent,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: Container(height: 5, color: step < 1 ? unselectedColor : selectedColor)),
                    Container(
                      height: 35,
                      width: 35,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: step < 1 ? AppColors.transparent : selectedColor,
                        border: Border.all(color: step < 1 ? unselectedColor : AppColors.black, width: 2),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        "1",
                        style: AppFontStyle.styleW700(step < 1 ? AppColors.white : AppColors.black, 15),
                      ),
                    ),
                    Expanded(child: Container(height: 5, color: step < 1 ? unselectedColor : selectedColor)),
                  ],
                ),
                5.height,
                Text(
                  textAlign: TextAlign.center,
                  "Upload Product Images",
                  style: AppFontStyle.styleW700(step < 1 ? AppColors.white : selectedColor, 13),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 15),
              height: 5,
              color: step < 1 ? unselectedColor : selectedColor,
            ),
          ),
          Container(
            width: 110,
            color: Colors.transparent,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: Container(height: 5, color: step < 2 ? unselectedColor : selectedColor)),
                    Container(
                      height: 35,
                      width: 35,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: step < 2 ? AppColors.transparent : selectedColor,
                        border: Border.all(color: step < 2 ? unselectedColor : AppColors.black, width: 2),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        "2",
                        style: AppFontStyle.styleW700(step < 2 ? AppColors.white : AppColors.black, 15),
                      ),
                    ),
                    Expanded(child: Container(height: 5, color: step < 2 ? unselectedColor : selectedColor)),
                  ],
                ),
                5.height,
                Text(
                  textAlign: TextAlign.center,
                  "Upload Product Images",
                  style: AppFontStyle.styleW700(step < 2 ? AppColors.white : selectedColor, 13),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 15),
              height: 5,
              color: step < 2 ? unselectedColor : selectedColor,
            ),
          ),
          Container(
            width: 110,
            color: Colors.transparent,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: Container(height: 5, color: step < 3 ? unselectedColor : selectedColor)),
                    Container(
                      height: 35,
                      width: 35,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: step < 3 ? AppColors.transparent : selectedColor,
                        border: Border.all(color: step < 3 ? unselectedColor : AppColors.black, width: 2),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        "3",
                        style: AppFontStyle.styleW700(step < 3 ? AppColors.white : AppColors.black, 15),
                      ),
                    ),
                    Expanded(child: Container(height: 5, color: step < 3 ? unselectedColor : selectedColor)),
                  ],
                ),
                5.height,
                Text(
                  textAlign: TextAlign.center,
                  "Upload Product Images",
                  style: AppFontStyle.styleW700(step < 3 ? AppColors.white : selectedColor, 13),
                ),
              ],
            ),
          ),
          Container(
            height: 5,
            width: 5,
            margin: const EdgeInsets.only(top: 15),
            decoration: BoxDecoration(
              color: step < 3 ? unselectedColor : selectedColor,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

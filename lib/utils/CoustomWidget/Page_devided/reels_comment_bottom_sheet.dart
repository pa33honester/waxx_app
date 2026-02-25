import 'package:era_shop/utils/CoustomWidget/App_theme_services/primary_buttons.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../all_images.dart';
import '../../globle_veriables.dart';
import '../App_theme_services/text_titles.dart';

reelsCommentBottomSheet() {
  final TextEditingController commentText = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final List<String> messages = [
    "This dress is incredible, especially for the price! Such a steal.",
    "I'm thrilled with this dress! The elegant design and quality materials make it a standout piece in my wardrobe. It's both stylish and affordable, which is a rare find. I can't wait to show it off at my friend's wedding",
    "The quality of these jeans is top-notch, and the cost is unbeatable.",
    "I'm so thrilled with.",
    "In love with this sweater! It's fantastic and budget-friendly.",
    "Great",
    "I feel like a million bucks in this outfit, and it didn't break the bank!",
    "This sweater exceeded my expectations. It's incredibly soft and cozy, perfect for the chilly weather. The price was a pleasant surprise for such high-quality knitwear. I'm definitely getting another one in a different color.",
    "Such a chic blouse at an incredibly reasonable price. I'm impressed.",
    "The fit of these pants is superb, and the cost is a real win.",
    "These shoes are amazing, and they didn't cost a fortune. Can't be happier!",
  ];

  return StatefulBuilder(
    builder: (BuildContext context, void Function(void Function()) setState) {
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          height: Get.height / 1.3,
          decoration: BoxDecoration(
            color: isDark.value ? AppColors.blackBackground : const Color(0xffffffff),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 70,
                  width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                    color: isDark.value ? AppColors.blackBackground : AppColors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SmallTitle(title: "Comments"),
                      const Spacer(),
                      PrimaryRoundButton(
                        onTaped: () {
                          Get.back();
                        },
                        icon: Icons.close,
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 15),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: messages.length,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.black54,
                          radius: 20,
                          backgroundImage: AssetImage("assets/icons/Avatar.png"),
                        ).paddingOnly(right: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryPink,
                                    borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(24),
                                      bottomLeft: Radius.circular(24),
                                      topRight: Radius.circular(24),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Text(
                                      messages[index],
                                      textAlign: TextAlign.start,
                                      style: GoogleFonts.plusJakartaSans(fontSize: 14, color: AppColors.white),
                                    ).paddingSymmetric(vertical: 10),
                                  ),
                                ),
                              ),
                              Text(
                                "15:42 PM",
                                style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.darkGrey),
                              ).paddingOnly(top: 8, right: 15),
                            ],
                          ).paddingOnly(top: 10),
                        ),
                      ],
                    ).paddingOnly(bottom: 8);
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 70,
                  width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                    color: isDark.value ? AppColors.blackBackground : AppColors.white,
                  ),
                  child: TextFormField(
                    controller: commentText,
                    maxLines: 3,
                    minLines: 2,
                    style: TextStyle(color: isDark.value ? AppColors.dullWhite : AppColors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: isDark.value ? AppColors.blackBackground : AppColors.dullWhite,
                      hintText: St.writeComment.tr,
                      hintStyle: GoogleFonts.plusJakartaSans(color: Colors.grey.shade400, fontSize: 13),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          if (commentText.text.isNotEmpty) {
                            setState(() {
                              messages.add(commentText.text);
                              commentText.clear();
                              scrollController.animateTo(
                                scrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            });
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: SizedBox(
                            height: 16,
                            width: 16,
                            child: Image(image: AssetImage(AppImage.sendMessage)),
                          ),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: isDark.value ? BorderSide(color: Colors.grey.shade800) : BorderSide.none,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primaryPink),
                        borderRadius: BorderRadius.circular(26),
                      ),
                    ),
                  ).paddingSymmetric(vertical: 5).paddingSymmetric(horizontal: 18),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

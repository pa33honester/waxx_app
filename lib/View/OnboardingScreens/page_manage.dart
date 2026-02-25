import 'package:era_shop/View/OnboardingScreens/on_boarding.dart';
import 'package:era_shop/custom/exit_app_dialog.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PageManage extends StatefulWidget {
  const PageManage({super.key});

  @override
  State<PageManage> createState() => _PageManageState();
}

class _PageManageState extends State<PageManage> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        showDialog(
          context: context,
          builder: (context) => const ExitAppDialog(),
        );
        if (didPop) {
          return;
        }
      },
      child: Scaffold(
        body: SizedBox(
          height: Get.height,
          width: Get.width,
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              PageView.builder(
                controller: pageController,
                physics: const BouncingScrollPhysics(),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return onBoardingImage[index];
                },
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
                  child: Row(
                    children: [
                      Container(
                        height: 50,
                        color: Colors.transparent,
                        child: Center(
                          child: SmoothPageIndicator(
                            effect:
                                ExpandingDotsEffect(dotHeight: 8, dotWidth: 8, dotColor: AppColors.lightGrey, activeDotColor: AppColors.primaryPink),
                            controller: pageController,
                            count: 3,
                          ),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          if (pageController.page!.toInt() < 2) {
                            pageController.nextPage(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.linear,
                            );
                          } else {
                            // Navigate to the next screen after onboarding
                            Get.offAllNamed("/SignIn");
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(color: AppColors.primaryPink, shape: BoxShape.circle),
                            child: Center(
                                child: Icon(
                              Icons.arrow_forward_rounded,
                              color: AppColors.black,
                            )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              20.height
            ],
          ),
        ),
      ),
    );
  }
}

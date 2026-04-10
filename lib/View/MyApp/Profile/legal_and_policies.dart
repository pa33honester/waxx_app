import 'package:waxxapp/custom/simple_app_bar_widget.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';


class LegalAndPolicies extends StatelessWidget {
  const LegalAndPolicies({super.key});

  @override
  Widget build(BuildContext context) {
    // final ScrollController _scrollController = ScrollController();
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.transparent,
          shadowColor: AppColors.black.withValues(alpha: 0.4),
          flexibleSpace: SimpleAppBarWidget(title: St.legalAndPolicies.tr),
        ),
      ),
      body: SafeArea(
          child: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Expanded(
                  child: RawScrollbar(
                trackRadius: const Radius.circular(10),
                trackColor: Colors.grey.shade300,
                thumbColor: AppColors.primaryPink,
                radius: const Radius.circular(10),
                thumbVisibility: true,
                interactive: true,
                thickness: 2,
                trackVisibility: true,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 7),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Html(
                          data: privacyPolicyLink,
                          style: {
                            "body": Style(fontSize: FontSize(18), color: Colors.white),
                            "h4": Style(fontSize: FontSize(24), fontWeight: FontWeight.bold),
                            "h5": Style(fontSize: FontSize(22)),
                            "h6": Style(fontSize: FontSize(20)),
                            "p": Style(fontSize: FontSize(18)),
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              )),
            ],
          ),
        ),
      )),
    );
  }
}

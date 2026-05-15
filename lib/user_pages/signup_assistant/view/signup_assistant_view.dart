import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waxxapp/custom/simple_app_bar_widget.dart';
import 'package:waxxapp/user_pages/signup_assistant/controller/signup_assistant_controller.dart';
import 'package:waxxapp/user_pages/signup_assistant/view/signup_assistant_body.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_colors.dart';

/// Full-screen host for the in-app help assistant chatbot.
///
/// Route: `/SignupAssistant` — see lib/utils/routes_pages.dart. The primary
/// entry point is now the floating bottom-right launcher
/// ([SignupAssistantLauncher]); this route is kept as a deep-link / fallback
/// surface and shares the same body widget ([SignupAssistantBody]).
class SignupAssistantView extends StatelessWidget {
  const SignupAssistantView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SignupAssistantController());

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.transparent,
          surfaceTintColor: AppColors.transparent,
          flexibleSpace: SimpleAppBarWidget(title: St.signupAssistantTitle.tr),
        ),
      ),
      body: const SafeArea(child: SignupAssistantBody()),
    );
  }
}

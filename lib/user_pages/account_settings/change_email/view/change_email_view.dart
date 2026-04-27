import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waxxapp/custom/simple_app_bar_widget.dart';
import 'package:waxxapp/user_pages/account_settings/change_email/controller/change_email_controller.dart';
import 'package:waxxapp/utils/CoustomWidget/App_theme_services/primary_buttons.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';

/// Two-step screen: enter new email → enter 6-digit code → done.
/// Pops with `result == true` on a successful verify so callers can refresh
/// the displayed email immediately.
class ChangeEmailView extends StatelessWidget {
  ChangeEmailView({super.key});

  final ChangeEmailController c = Get.put(ChangeEmailController());

  InputDecoration _decoration(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: AppFontStyle.styleW500(AppColors.unselected, 13),
        filled: true,
        fillColor: AppColors.tabBackground,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.transparent)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.transparent)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.transparent)),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.transparent,
          flexibleSpace: SimpleAppBarWidget(title: 'Change email'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Obx(() {
            return c.step.value == 0 ? _stepEnterEmail() : _stepEnterCode();
          }),
        ),
      ),
    );
  }

  Widget _stepEnterEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          'Enter your new email',
          style: AppFontStyle.styleW700(AppColors.white, 16),
        ),
        const SizedBox(height: 8),
        Text(
          "We'll send a 6-digit confirmation code so we know it's really you.",
          style: AppFontStyle.styleW500(AppColors.unselected, 13),
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: c.emailController,
          style: AppFontStyle.styleW700(AppColors.white, 14),
          cursorColor: Colors.white,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          textCapitalization: TextCapitalization.none,
          decoration: _decoration("you@example.com"),
        ),
        const Spacer(),
        Obx(() => PrimaryPinkButton(
              onTaped: c.isBusy.value ? () {} : c.sendCode,
              text: c.isBusy.value ? 'Sending…' : 'Send code',
            )),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _stepEnterCode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          'Enter the 6-digit code',
          style: AppFontStyle.styleW700(AppColors.white, 16),
        ),
        const SizedBox(height: 8),
        Text(
          "Sent to ${c.emailController.text.trim()}.",
          style: AppFontStyle.styleW500(AppColors.unselected, 13),
        ),
        const SizedBox(height: 24),
        Obx(() {
          if (c.devCode.value == null) return const SizedBox.shrink();
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.tabBackground,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
              ),
              child: Text(
                "Email isn't configured on this server — code: ${c.devCode.value}",
                style: AppFontStyle.styleW500(AppColors.primary, 12),
              ),
            ),
          );
        }),
        TextFormField(
          controller: c.codeController,
          style: AppFontStyle.styleW700(AppColors.white, 18),
          cursorColor: Colors.white,
          keyboardType: TextInputType.number,
          maxLength: 6,
          decoration: _decoration("123456"),
        ),
        const Spacer(),
        Obx(() => PrimaryPinkButton(
              onTaped: c.isBusy.value
                  ? () {}
                  : () async {
                      final ok = await c.verifyCode();
                      if (ok) Get.back(result: true);
                    },
              text: c.isBusy.value ? 'Verifying…' : 'Confirm',
            )),
        const SizedBox(height: 8),
        Center(
          child: TextButton(
            onPressed: () => c.step.value = 0,
            child: Text('Use a different email', style: AppFontStyle.styleW500(AppColors.unselected, 13)),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

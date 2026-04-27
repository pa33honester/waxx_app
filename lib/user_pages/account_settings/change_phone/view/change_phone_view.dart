import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:waxxapp/custom/simple_app_bar_widget.dart';
import 'package:waxxapp/user_pages/account_settings/change_phone/controller/change_phone_controller.dart';
import 'package:waxxapp/utils/CoustomWidget/App_theme_services/primary_buttons.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart' as globals;

/// Two-step Change Phone screen. Pops with `result == true` once the new
/// number has been verified via Firebase OTP and committed on the backend.
class ChangePhoneView extends StatelessWidget {
  ChangePhoneView({super.key});

  final ChangePhoneController c = Get.put(ChangePhoneController());

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
          flexibleSpace: SimpleAppBarWidget(title: 'Change phone'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Obx(() => c.step.value == 0 ? _stepEnterPhone() : _stepEnterCode()),
        ),
      ),
    );
  }

  Widget _stepEnterPhone() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          'Enter your new phone number',
          style: AppFontStyle.styleW700(AppColors.white, 16),
        ),
        const SizedBox(height: 8),
        Text(
          "We'll text a verification code to make sure it's yours.",
          style: AppFontStyle.styleW500(AppColors.unselected, 13),
        ),
        const SizedBox(height: 24),
        IntlPhoneField(
          controller: c.phoneController,
          showCountryFlag: true,
          dropdownIconPosition: IconPosition.trailing,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          keyboardType: TextInputType.number,
          dropdownTextStyle: AppFontStyle.styleW700(AppColors.unselected, 15),
          style: AppFontStyle.styleW600(AppColors.white, 16),
          dropdownIcon: Icon(Icons.arrow_drop_down, color: AppColors.unselected),
          decoration: _decoration("Phone number"),
          initialCountryCode: globals.countryCode,
          onCountryChanged: (country) => c.dialCode.value = '+${country.dialCode}',
          onChanged: (phone) => c.dialCode.value = phone.countryCode,
        ),
        const Spacer(),
        Obx(() => PrimaryPinkButton(
              onTaped: c.isBusy.value ? () {} : c.sendOtp,
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
          'Enter the SMS code',
          style: AppFontStyle.styleW700(AppColors.white, 16),
        ),
        const SizedBox(height: 8),
        Text(
          "Sent to ${c.dialCode.value}${c.phoneController.text.trim()}.",
          style: AppFontStyle.styleW500(AppColors.unselected, 13),
        ),
        const SizedBox(height: 24),
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
                      final ok = await c.verifyCodeAndCommit();
                      if (ok) Get.back(result: true);
                    },
              text: c.isBusy.value ? 'Verifying…' : 'Confirm',
            )),
        const SizedBox(height: 8),
        Center(
          child: TextButton(
            onPressed: () => c.step.value = 0,
            child: Text('Use a different number', style: AppFontStyle.styleW500(AppColors.unselected, 13)),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

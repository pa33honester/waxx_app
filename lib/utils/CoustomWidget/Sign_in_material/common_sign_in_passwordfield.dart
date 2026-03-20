import 'package:waxxapp/Controller/GetxController/login/user_login_controller.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonSignInPasswordField extends StatefulWidget {
  final String titleText;
  final String hintText;
  final String? controllerType;

  const CommonSignInPasswordField({
    super.key,
    required this.titleText,
    required this.hintText,
    this.controllerType,
  });

  @override
  State<CommonSignInPasswordField> createState() => _CommonSignInPasswordFieldState();
}

class _CommonSignInPasswordFieldState extends State<CommonSignInPasswordField> {
  UserLoginController userLogin = Get.put(UserLoginController());
  var _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.titleText,
            style: AppFontStyle.styleW600(AppColors.darkGrey, 13),
            // style: GoogleFonts.plusJakartaSans(
            //   color: isDark.value ? AppColors.white : AppColors.darkGrey,
            //   fontSize: 14,
            //   fontWeight: FontWeight.w500,
            // ),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 10),
              child: GetBuilder<UserLoginController>(
                builder: (controller) => TextFormField(
                  controller: (widget.controllerType == "Password")
                      ? userLogin.passwordController
                      : (widget.controllerType == "ConfirmPassword")
                          ? userLogin.confirmPasswordController
                          : (widget.controllerType == "SignInPassword")
                              ? userLogin.signInPasswordController
                              : (widget.controllerType == "CreateNewPassword")
                                  ? userLogin.createPasswordController
                                  : (widget.controllerType == "CreateConfirmPassword")
                                      ? userLogin.createConfirmPasswordController
                                      : null,
                  style: TextStyle(color: AppColors.white),
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                      errorText: (userLogin.passwordValidate.value && widget.controllerType == "Password")
                          ? "Password cannot be empty"
                          : (userLogin.signUpPasswordLength.value && widget.controllerType == "Password")
                              ? "Password must be 8 digits"
                              : (userLogin.confirmPasswordValidate.value &&
                                      widget.controllerType == "ConfirmPassword")
                                  ? "Confirm Password cannot be empty"
                                  : (userLogin.signUpConfirmPasswordLength.value &&
                                          widget.controllerType == "ConfirmPassword")
                                      ? "Password must be 8 digits"
                                      : (userLogin.signInPasswordValidate.value &&
                                              widget.controllerType == "SignInPassword")
                                          ? "Password cannot be empty"
                                          : (userLogin.signInPasswordLength.value &&
                                                  widget.controllerType == "SignInPassword")
                                              ? "Password must be 8 digits"
                                              : (userLogin.createPasswordValidate.value && widget.controllerType == "CreateNewPassword")
                                                  ? "Password cannot be empty"
                                                  : (userLogin.newPasswordLength.value && widget.controllerType == "CreateNewPassword")
                                                      ? "Password must be 8 digits"
                                                      : (userLogin.createConfirmPasswordValidate.value && widget.controllerType == "CreateConfirmPassword")
                                                          ? "Confirm Password cannot be empty"
                                                          : (userLogin.newConfirmPasswordLength.value && widget.controllerType == "CreateConfirmPassword")
                                                              ? "Password must be 8 digits"
                                                              : null,
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {});
                          _obscureText = !_obscureText;
                        },
                        child: Icon(
                          _obscureText ? Icons.remove_red_eye_rounded : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                      ),
                      filled: true,
                      fillColor: AppColors.tabBackground,
                      hintText: widget.hintText,
                      hintStyle:AppFontStyle.styleW600(AppColors.mediumGrey, 13),
                      enabledBorder: OutlineInputBorder(
                          borderSide: isDark.value
                              ? BorderSide(color: Colors.grey.shade800)
                              : BorderSide.none,
                          borderRadius: BorderRadius.circular(14)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary),
                          borderRadius: BorderRadius.circular(14)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary),
                          borderRadius: BorderRadius.circular(14))),
                ),
              )),
        ],
      ),
    );
  }
}

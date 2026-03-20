import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInBackButton extends StatelessWidget {
  final void Function() onTaped;
  const SignInBackButton({
    super.key,
    required this.onTaped,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTaped,
      child: Container(
        height: 42,
        width: 42,
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: .2),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.arrow_back_rounded,
          color: Colors.white,
        ),
      ),
    );
  }
}

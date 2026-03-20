import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:flutter/cupertino.dart';

class CommonSignInButton extends StatelessWidget {
  final void Function() onTaped;
  final String text;
  const CommonSignInButton({
    super.key,
    required this.onTaped,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTaped,
      child: Container(
        height: 55,
        decoration: BoxDecoration(color: AppColors.primaryPink, borderRadius: BorderRadius.circular(24)),
        child: Center(
          child: Text(
            text,
            style: AppFontStyle.styleW700(AppColors.black, 16),
          ),
        ),
      ),
    );
  }
}

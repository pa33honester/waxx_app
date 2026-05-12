import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';

/// Small "Need help signing up?" pill shown on the entry / login screens.
/// Tapping it opens the in-app sign-up assistant chatbot (`/SignupAssistant`).
/// Styled to read on dark backgrounds; pass [floating] for the translucent
/// variant used overlaid on the onboarding pager's full-bleed images.
class SignupAssistantChip extends StatelessWidget {
  const SignupAssistantChip({super.key, this.floating = false});

  /// When true, uses a translucent black background suitable for sitting on
  /// top of imagery rather than inside a dark panel.
  final bool floating;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () => Get.toNamed("/SignupAssistant"),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: floating ? AppColors.black.withValues(alpha: 0.55) : AppColors.tabBackground,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.6), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.support_agent_rounded, color: AppColors.primary, size: 18),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                St.signupAssistantChip.tr,
                style: AppFontStyle.styleW600(AppColors.primary, 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

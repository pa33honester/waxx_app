import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waxxapp/utils/CoustomWidget/App_theme_services/primary_buttons.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';

/// Shown at app start for users who have not yet submitted a selfie for
/// identity verification. Mirrors [EmailBackfillDialog] in shape: routes
/// the user into the existing `/SelfieVerification` flow.
///
/// Re-prompts on every cold start until [verificationStatus] becomes
/// `verified` or `pending_review`. Within a single session the
/// in-memory [_promptedThisSession] guard prevents re-show if the
/// BottomBar controller gets re-initialised (deep-link navigations,
/// hot-reload, etc.) — not persisted, so the next launch re-prompts.
class SelfieRequiredDialog extends StatelessWidget {
  const SelfieRequiredDialog({super.key});

  static bool _promptedThisSession = false;

  static Future<bool> showIfNeeded() async {
    if (!isSelfieVerificationActive.value) return false;

    // QA / app-review accounts (Firebase test phone numbers) shouldn't
    // be forced through real identity verification. Single source of
    // truth for the list lives in [kTestPhoneNumbers].
    if (isTestPhoneUser()) return false;

    final status = verificationStatus.value;
    if (status == "verified" || status == "pending_review") return false;

    if (_promptedThisSession) return false;
    _promptedThisSession = true;

    await Future.delayed(const Duration(milliseconds: 1500));

    await Get.dialog(
      const SelfieRequiredDialog(),
      barrierDismissible: false,
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final isRejected = verificationStatus.value == "rejected";
    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: AppColors.tabBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                isRejected
                    ? Icons.error_outline_rounded
                    : Icons.verified_user_outlined,
                size: 32,
                color: AppColors.primary,
              ),
              const SizedBox(height: 12),
              Text(
                isRejected ? 'Re-verify your account' : 'Verify your account',
                style: AppFontStyle.styleW700(AppColors.white, 18),
              ),
              const SizedBox(height: 8),
              Text(
                isRejected
                    ? "Your previous selfie didn't pass review. Please take a clear, well-lit selfie to retry verification."
                    : "We need a quick selfie to verify your identity. It keeps your account secure and unlocks the full app experience.",
                style: AppFontStyle.styleW500(AppColors.unselected, 13),
              ),
              const SizedBox(height: 20),
              PrimaryPinkButton(
                onTaped: () {
                  Get.back();
                  Get.toNamed("/SelfieVerification");
                },
                text: isRejected ? 'Retry verification' : 'Verify now',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

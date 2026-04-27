import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waxxapp/user_pages/account_settings/change_email/view/change_email_view.dart';
import 'package:waxxapp/utils/CoustomWidget/App_theme_services/primary_buttons.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/Theme/theme_service.dart';
import 'package:waxxapp/utils/database.dart';
import 'package:waxxapp/utils/font_style.dart';

/// Shown once per session for users who signed up via phone before the
/// "email required at signup" change landed and therefore have an empty
/// email on file. Routes them to the existing Change Email flow so they
/// end up with a verified email on the account.
///
/// Non-dismissable: tapping outside or pressing back is suppressed via
/// PopScope. The only way out is to complete the flow or kill the app.
class EmailBackfillDialog extends StatelessWidget {
  const EmailBackfillDialog({super.key});

  static const _storageKey = 'emailBackfillPromptedThisSession';

  /// Returns true if the prompt was shown (and the user completed it),
  /// false if it was suppressed because conditions don't apply or it's
  /// already been shown this session.
  static Future<bool> showIfNeeded() async {
    final user = Database.fetchLoginUserProfileModel?.user;
    if (user == null) return false;
    final isPhoneSignup = user.loginType == 5;
    final hasEmail = (user.email ?? '').trim().isNotEmpty;
    if (!isPhoneSignup || hasEmail) return false;

    if (getStorage.read(_storageKey) == true) return false;
    getStorage.write(_storageKey, true);

    // Wait for the bottom-tab UI to mount before dropping a modal on top.
    await Future.delayed(const Duration(milliseconds: 1500));

    await Get.dialog(
      const EmailBackfillDialog(),
      barrierDismissible: false,
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
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
              Icon(Icons.alternate_email_rounded, size: 32, color: AppColors.primary),
              const SizedBox(height: 12),
              Text('Add your email', style: AppFontStyle.styleW700(AppColors.white, 18)),
              const SizedBox(height: 8),
              Text(
                "We need your email to keep your account secure and to send you order updates and receipts. It only takes a minute.",
                style: AppFontStyle.styleW500(AppColors.unselected, 13),
              ),
              const SizedBox(height: 20),
              PrimaryPinkButton(
                onTaped: () async {
                  final ok = await Get.to(() => ChangeEmailView());
                  // Only close the prompt once the user has actually
                  // verified an email — otherwise leave it up.
                  if (ok == true) Get.back();
                },
                text: 'Add my email',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

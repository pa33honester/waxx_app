import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:waxxapp/user_pages/signup_assistant/controller/signup_assistant_controller.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart' as gv;

/// The chat transcript + quick-reply chips + composer for the in-app help
/// assistant. Pure presentation bound to a [SignupAssistantController] that the
/// host (the floating [SignupAssistantLauncher] panel, or the full-screen
/// `/SignupAssistant` route) is responsible for `Get.put`-ing first.
///
/// On [BotStep.askWhatsapp] the bottom area swaps the free-text composer for a
/// dial-code phone field ([_WhatsappComposer]); otherwise it shows the text
/// composer ([_TextComposer]) when the current step accepts typed input, and
/// nothing when only quick-reply chips apply.
class SignupAssistantBody extends StatelessWidget {
  const SignupAssistantBody({super.key, this.compact = false});

  /// Tighter paddings / slightly smaller text — used inside the narrow floating
  /// panel. The full-screen route leaves it `false`.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final c = Get.find<SignupAssistantController>();
    return Column(
      children: [
        Expanded(
          child: Obx(
            () => ListView.builder(
              controller: c.scrollController,
              padding: EdgeInsets.symmetric(horizontal: compact ? 12 : 14, vertical: 14),
              itemCount: c.messages.length,
              itemBuilder: (context, index) => _Bubble(message: c.messages[index], compact: compact),
            ),
          ),
        ),
        // Quick-reply chips for menu / choice steps.
        Obx(
          () => c.quickReplies.isEmpty
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.end,
                    children: c.quickReplies
                        .map((label) => _QuickReplyChip(label: label, onTap: () => c.onQuickReply(label)))
                        .toList(),
                  ),
                ),
        ),
        // Composer: phone field on the WhatsApp step, free text on text steps.
        Obx(() {
          if (c.step.value == BotStep.askWhatsapp) return const _WhatsappComposer();
          if (c.acceptsText.value) return const _TextComposer();
          return const SizedBox.shrink();
        }),
      ],
    );
  }
}

class _QuickReplyChip extends StatelessWidget {
  const _QuickReplyChip({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.tabBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.6), width: 1),
        ),
        child: Text(label, style: AppFontStyle.styleW600(AppColors.primary, 13)),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.message, this.compact = false});
  final BotMessage message;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == BotSender.user;
    final bubbleColor = isUser ? AppColors.primary : AppColors.tabBackground;
    final textColor = isUser ? AppColors.black : AppColors.white;
    final radius = isUser
        ? const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(4),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(16),
          );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: LayoutBuilder(
        builder: (context, constraints) => Row(
          mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.82),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(color: bubbleColor, borderRadius: radius),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isUser)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(St.botAssistantLabel.tr, style: AppFontStyle.styleW700(AppColors.primary, 11)),
                      ),
                    Text(message.text, style: AppFontStyle.styleW500(textColor, compact ? 13 : 14)),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('HH:mm').format(message.time.toLocal()),
                      style: AppFontStyle.styleW400(textColor.withValues(alpha: 0.7), 10),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TextComposer extends StatelessWidget {
  const _TextComposer();

  @override
  Widget build(BuildContext context) {
    final c = Get.find<SignupAssistantController>();
    return Container(
      decoration: BoxDecoration(
        color: AppColors.tabBackground,
        border: Border(top: BorderSide(color: AppColors.unselected.withValues(alpha: 0.2), width: 0.5)),
      ),
      padding: const EdgeInsets.fromLTRB(12, 8, 8, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: c.inputController,
              minLines: 1,
              maxLines: 3,
              maxLength: 200,
              textCapitalization: TextCapitalization.sentences,
              style: AppFontStyle.styleW500(AppColors.white, 14),
              cursorColor: AppColors.primary,
              decoration: InputDecoration(
                isDense: true,
                counterText: "",
                hintText: St.botComposeHint.tr,
                hintStyle: AppFontStyle.styleW400(AppColors.unselected, 14),
                filled: true,
                fillColor: AppColors.black,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: AppColors.primary, width: 1),
                ),
              ),
              onSubmitted: (_) => c.onUserText(),
            ),
          ),
          const SizedBox(width: 6),
          _SendButton(onTap: c.onUserText),
        ],
      ),
    );
  }
}

class _WhatsappComposer extends StatelessWidget {
  const _WhatsappComposer();

  void _submit(SignupAssistantController c) {
    c.onWhatsappSubmitted(localNumber: c.currentWhatsappLocal.value, dialCode: c.currentDialCode.value);
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<SignupAssistantController>();
    return Container(
      decoration: BoxDecoration(
        color: AppColors.tabBackground,
        border: Border(top: BorderSide(color: AppColors.unselected.withValues(alpha: 0.2), width: 0.5)),
      ),
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: IntlPhoneField(
              initialCountryCode: gv.countryCode,
              disableLengthCheck: true,
              showCountryFlag: true,
              dropdownIconPosition: IconPosition.trailing,
              flagsButtonPadding: const EdgeInsets.only(left: 6),
              cursorColor: AppColors.primary,
              keyboardType: TextInputType.phone,
              style: AppFontStyle.styleW600(AppColors.white, 15),
              dropdownTextStyle: AppFontStyle.styleW700(AppColors.white, 14),
              dropdownIcon: Icon(Icons.arrow_drop_down, color: AppColors.white),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                isDense: true,
                counterText: "",
                hintText: "WhatsApp number",
                hintStyle: AppFontStyle.styleW400(AppColors.unselected, 14),
                filled: true,
                fillColor: AppColors.black,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: AppColors.primary, width: 1),
                ),
              ),
              onCountryChanged: (country) {
                c.currentDialCode.value = country.dialCode.startsWith('+') ? country.dialCode : '+${country.dialCode}';
              },
              onChanged: (phone) {
                c.currentDialCode.value = phone.countryCode;
                c.currentWhatsappLocal.value = phone.number;
              },
              onSubmitted: (_) => _submit(c),
            ),
          ),
          const SizedBox(width: 6),
          _SendButton(onTap: () => _submit(c)),
        ],
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(Icons.send_rounded, color: AppColors.black, size: 20),
        ),
      ),
    );
  }
}

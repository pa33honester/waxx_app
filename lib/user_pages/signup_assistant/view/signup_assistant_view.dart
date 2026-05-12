import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:waxxapp/custom/simple_app_bar_widget.dart';
import 'package:waxxapp/user_pages/signup_assistant/controller/signup_assistant_controller.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';

/// In-app sign-up assistant chatbot. A fixed, step-by-step conversation
/// (no AI) that greets new users, asks whether they're stuck on sign-up or
/// login, and — for sign-up — collects their details and submits a pending
/// account request for an admin to approve. The login branch hands off to
/// the existing Forgot Password flow / in-app Support Chat.
///
/// Route: `/SignupAssistant` — see lib/utils/routes_pages.dart.
class SignupAssistantView extends StatelessWidget {
  const SignupAssistantView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupAssistantController());

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
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => ListView.builder(
                  controller: controller.scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) => _Bubble(message: controller.messages[index]),
                ),
              ),
            ),
            // Quick-reply chips for menu/choice steps.
            Obx(
              () => controller.quickReplies.isEmpty
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.end,
                        children: controller.quickReplies
                            .map((label) => _QuickReplyChip(
                                  label: label,
                                  onTap: () => controller.onQuickReply(label),
                                ))
                            .toList(),
                      ),
                    ),
            ),
            // Free-text composer for steps that expect a typed answer.
            Obx(() => controller.acceptsText.value ? _composer(controller) : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }

  Widget _composer(SignupAssistantController controller) {
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
              controller: controller.inputController,
              minLines: 1,
              maxLines: 3,
              maxLength: 200,
              textCapitalization: TextCapitalization.sentences,
              style: AppFontStyle.styleW500(AppColors.white, 14),
              decoration: InputDecoration(
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
              onSubmitted: (_) => controller.onUserText(),
            ),
          ),
          const SizedBox(width: 6),
          Material(
            color: AppColors.primary,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: controller.onUserText,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Icon(Icons.send_rounded, color: AppColors.black, size: 20),
              ),
            ),
          ),
        ],
      ),
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
  const _Bubble({required this.message});
  final BotMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == BotSender.user;
    final bubbleColor = isUser ? AppColors.primary : AppColors.tabBackground;
    final textColor = isUser ? AppColors.black : AppColors.white;
    final align = isUser ? MainAxisAlignment.end : MainAxisAlignment.start;
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
      child: Row(
        mainAxisAlignment: align,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(color: bubbleColor, borderRadius: radius),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isUser)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          St.botAssistantLabel.tr,
                          style: AppFontStyle.styleW700(AppColors.primary, 11),
                        ),
                      ),
                    Text(message.text, style: AppFontStyle.styleW500(textColor, 14)),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('HH:mm').format(message.time.toLocal()),
                      style: AppFontStyle.styleW400(textColor.withValues(alpha: 0.7), 10),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

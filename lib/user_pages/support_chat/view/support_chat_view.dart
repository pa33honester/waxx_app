import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:waxxapp/ApiModel/user/support_conversation_model.dart';
import 'package:waxxapp/custom/simple_app_bar_widget.dart';
import 'package:waxxapp/user_pages/support_chat/controller/support_chat_controller.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';

/// Buyer-side live customer-support chat. Two-column UX modeled after
/// any common 1:1 chat panel — admin bubbles on the left, user bubbles
/// on the right, the composer pinned to the bottom with a send button
/// that disables while a send is in flight.
///
/// Routes: `/SupportChat` — see lib/utils/routes_pages.dart.
class SupportChatView extends StatelessWidget {
  const SupportChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SupportChatController());

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.transparent,
          surfaceTintColor: AppColors.transparent,
          flexibleSpace: SimpleAppBarWidget(title: St.helpAndSupport.tr),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Presence banner — visible only while an admin has this
            // conversation open in the support panel. Reactive: flips
            // automatically when the admin closes the thread.
            Obx(() => controller.adminPresent.value
                ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    color: AppColors.primary.withValues(alpha: 0.18),
                    child: Row(
                      children: [
                        Container(
                          height: 8,
                          width: 8,
                          decoration: BoxDecoration(
                            color: const Color(0xFF22C55E), // green dot
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${controller.adminName.value} is online",
                          style: AppFontStyle.styleW600(AppColors.white, 12),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink()),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }
                if (controller.messages.isEmpty) {
                  return _emptyState();
                }
                return ListView.builder(
                  controller: controller.scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final msg = controller.messages[index];
                    return _MessageBubble(message: msg);
                  },
                );
              }),
            ),
            _composer(controller),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.support_agent_rounded, color: AppColors.primary, size: 64),
            const SizedBox(height: 16),
            Text(
              St.supportEmptyTitle.tr,
              style: AppFontStyle.styleW700(AppColors.white, 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              St.supportEmptySubtitle.tr,
              style: AppFontStyle.styleW500(AppColors.unselected, 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _composer(SupportChatController controller) {
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
              maxLines: 4,
              maxLength: 2000,
              textCapitalization: TextCapitalization.sentences,
              style: AppFontStyle.styleW500(AppColors.white, 14),
              decoration: InputDecoration(
                counterText: "",
                hintText: St.supportComposeHint.tr,
                hintStyle: AppFontStyle.styleW400(AppColors.unselected, 14),
                filled: true,
                fillColor: AppColors.black,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: AppColors.primary, width: 1),
                ),
              ),
              onSubmitted: (_) => controller.sendMessage(),
            ),
          ),
          const SizedBox(width: 6),
          Obx(
            () => Material(
              color: controller.isSending.value
                  ? AppColors.primary.withValues(alpha: 0.4)
                  : AppColors.primary,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: controller.isSending.value ? null : controller.sendMessage,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    Icons.send_rounded,
                    color: AppColors.black,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});
  final SupportMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.senderType == "user";
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
                    if (!isUser && (message.senderName ?? '').isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          message.senderName ?? '',
                          style: AppFontStyle.styleW700(AppColors.primary, 11),
                        ),
                      ),
                    Text(
                      message.text ?? '',
                      style: AppFontStyle.styleW500(textColor, 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatTime(message.createdAt),
                      style: AppFontStyle.styleW400(
                        textColor.withValues(alpha: 0.7),
                        10,
                      ),
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

  String _formatTime(DateTime? ts) {
    if (ts == null) return '';
    return DateFormat('HH:mm').format(ts.toLocal());
  }
}

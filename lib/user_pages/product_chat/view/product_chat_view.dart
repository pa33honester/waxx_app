import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:waxxapp/custom/simple_app_bar_widget.dart';
import 'package:waxxapp/user_pages/product_chat/controller/product_chat_controller.dart';
import 'package:waxxapp/user_pages/product_chat/model/product_chat_model.dart';
import 'package:waxxapp/utils/api_url.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';

class ProductChatView extends StatelessWidget {
  const ProductChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductChatController());

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.transparent,
          surfaceTintColor: AppColors.transparent,
          flexibleSpace: const SimpleAppBarWidget(title: "Chat"),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _ProductHeaderCard(controller: controller),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator(color: AppColors.primary));
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
                    final isOwn = msg.senderType == controller.role;
                    return _MessageBubble(message: msg, isOwn: isOwn);
                  },
                );
              }),
            ),
            _Composer(controller: controller),
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
            Icon(Icons.chat_bubble_outline_rounded, color: AppColors.primary, size: 64),
            const SizedBox(height: 16),
            Text(
              "No messages yet",
              style: AppFontStyle.styleW700(AppColors.white, 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "Start the conversation about this product.",
              style: AppFontStyle.styleW500(AppColors.unselected, 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductHeaderCard extends StatelessWidget {
  const _ProductHeaderCard({required this.controller});
  final ProductChatController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final snap = controller.productSnapshot.value;
      if (snap == null) return const SizedBox.shrink();
      return Container(
        color: AppColors.tabBackground,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: "${Api.baseUrl}${snap.image ?? ''}",
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Container(
                  width: 56,
                  height: 56,
                  color: AppColors.black,
                  child: Icon(Icons.image_not_supported_outlined,
                      color: AppColors.unselected, size: 24),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snap.name ?? '',
                    style: AppFontStyle.styleW700(AppColors.white, 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "GH₵ ${snap.price?.toStringAsFixed(2) ?? '0.00'}",
                    style: AppFontStyle.styleW600(AppColors.primary, 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _Composer extends StatelessWidget {
  const _Composer({required this.controller});
  final ProductChatController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(() {
          if (controller.filterError.value.isEmpty) return const SizedBox.shrink();
          return Container(
            width: double.infinity,
            color: Colors.red.withValues(alpha: 0.12),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            child: Text(
              controller.filterError.value,
              style: AppFontStyle.styleW500(Colors.redAccent, 12),
            ),
          );
        }),
        Container(
          decoration: BoxDecoration(
            color: AppColors.tabBackground,
            border: Border(
                top: BorderSide(color: AppColors.unselected.withValues(alpha: 0.2), width: 0.5)),
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
                  onChanged: (_) {
                    if (controller.filterError.value.isNotEmpty) {
                      controller.filterError.value = "";
                    }
                  },
                  decoration: InputDecoration(
                    counterText: "",
                    hintText: "Write your message here",
                    hintStyle: AppFontStyle.styleW400(AppColors.unselected, 14),
                    filled: true,
                    fillColor: AppColors.black,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                    child: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Icon(Icons.send_rounded, color: Colors.black, size: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.isOwn});
  final ProductChatMessage message;
  final bool isOwn;

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isOwn ? AppColors.primary : AppColors.tabBackground;
    final textColor = isOwn ? AppColors.black : AppColors.white;
    final align = isOwn ? MainAxisAlignment.end : MainAxisAlignment.start;
    final radius = isOwn
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
              constraints:
                  BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(color: bubbleColor, borderRadius: radius),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isOwn && (message.senderName ?? '').isNotEmpty)
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
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment:
                          isOwn ? MainAxisAlignment.end : MainAxisAlignment.start,
                      children: [
                        Text(
                          _formatTime(message.createdAt),
                          style: AppFontStyle.styleW400(
                              textColor.withValues(alpha: 0.7), 10),
                        ),
                        if (isOwn) ...[
                          const SizedBox(width: 4),
                          Text(
                            (message.isRead ?? false) ? "✓✓" : "✓",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: (message.isRead ?? false)
                                  ? const Color(0xFF0EA5E9)
                                  : textColor.withValues(alpha: 0.6),
                              height: 1.0,
                            ),
                          ),
                        ],
                      ],
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

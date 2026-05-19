import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:waxxapp/custom/simple_app_bar_widget.dart';
import 'package:waxxapp/seller_pages/seller_chat/controller/seller_chat_inbox_controller.dart';
import 'package:waxxapp/seller_pages/seller_chat/model/seller_chat_inbox_model.dart';
import 'package:waxxapp/utils/api_url.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';

class SellerChatInboxView extends StatelessWidget {
  const SellerChatInboxView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SellerChatInboxController());

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.transparent,
          surfaceTintColor: AppColors.transparent,
          flexibleSpace: const SimpleAppBarWidget(title: "Chat Inbox"),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: AppColors.primary));
        }
        if (controller.tiles.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline_rounded,
                      color: AppColors.primary, size: 64),
                  const SizedBox(height: 16),
                  Text("No buyer messages yet",
                      style: AppFontStyle.styleW700(AppColors.white, 18),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text(
                      "When buyers message you about your products,\nthey will appear here.",
                      style: AppFontStyle.styleW500(AppColors.unselected, 13),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
          );
        }
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: controller.reload,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: controller.tiles.length,
            separatorBuilder: (_, __) =>
                Divider(color: AppColors.unselected.withValues(alpha: 0.15), height: 1),
            itemBuilder: (context, index) {
              final tile = controller.tiles[index];
              return _InboxTileWidget(
                tile: tile,
                onTap: () => controller.openConversation(tile),
              );
            },
          ),
        );
      }),
    );
  }
}

class _InboxTileWidget extends StatelessWidget {
  const _InboxTileWidget({required this.tile, required this.onTap});
  final SellerChatInboxTile tile;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final unread = tile.unreadBySeller ?? 0;
    final lastText = tile.lastMessage?.text ?? "";
    final buyerName = tile.buyerInfo?.displayName ?? "Buyer";

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Product thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: "${Api.baseUrl}${tile.productSnapshot?.image ?? ''}",
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Container(
                  width: 48,
                  height: 48,
                  color: AppColors.tabBackground,
                  child: Icon(Icons.image_not_supported_outlined,
                      color: AppColors.unselected, size: 20),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          tile.productSnapshot?.name ?? "Product",
                          style: AppFontStyle.styleW700(AppColors.white, 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatTime(tile.lastActivityAt),
                        style: AppFontStyle.styleW400(AppColors.unselected, 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "$buyerName: $lastText",
                          style: AppFontStyle.styleW500(
                            unread > 0 ? AppColors.white : AppColors.unselected,
                            12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (unread > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            unread > 99 ? "99+" : unread.toString(),
                            style: AppFontStyle.styleW700(AppColors.black, 11),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime? ts) {
    if (ts == null) return '';
    final now = DateTime.now();
    final local = ts.toLocal();
    if (local.year == now.year && local.month == now.month && local.day == now.day) {
      return DateFormat('HH:mm').format(local);
    }
    return DateFormat('MMM d').format(local);
  }
}

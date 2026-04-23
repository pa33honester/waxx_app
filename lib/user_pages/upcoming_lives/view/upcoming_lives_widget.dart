import 'package:cached_network_image/cached_network_image.dart';
import 'package:waxxapp/ApiModel/user/upcoming_lives_model.dart';
import 'package:waxxapp/user_pages/upcoming_lives/controller/upcoming_lives_controller.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UpcomingLivesSection extends StatelessWidget {
  const UpcomingLivesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpcomingLivesController());
    return Obx(() {
      if (controller.isLoading.value) {
        return const SizedBox(height: 130, child: Center(child: CircularProgressIndicator()));
      }
      if (controller.upcomingLives.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.live_tv_rounded, color: AppColors.primary, size: 18),
                const SizedBox(width: 8),
                Text('Upcoming Shows', style: AppFontStyle.styleW700(AppColors.white, 16)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 130,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 16),
              itemCount: controller.upcomingLives.length,
              itemBuilder: (context, index) {
                final live = controller.upcomingLives[index];
                return _UpcomingLiveCard(live: live, controller: controller);
              },
            ),
          ),
        ],
      );
    });
  }
}

class _UpcomingLiveCard extends StatelessWidget {
  final UpcomingLive live;
  final UpcomingLivesController controller;

  const _UpcomingLiveCard({required this.live, required this.controller});

  String _formatTime(DateTime? dt) {
    if (dt == null) return '';
    return DateFormat('MMM d, h:mm a').format(dt.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final hasReminder = live.hasReminder == true;
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.tabBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: live.sellerImage ?? '',
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                    child: Icon(Icons.person, size: 18, color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  live.sellerName ?? '',
                  overflow: TextOverflow.ellipsis,
                  style: AppFontStyle.styleW700(AppColors.white, 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            live.title ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppFontStyle.styleW700(AppColors.white, 13),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.access_time_rounded, size: 12, color: AppColors.unselected),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  _formatTime(live.scheduledAt),
                  style: AppFontStyle.styleW500(AppColors.unselected, 11),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => controller.toggleReminder(live),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: hasReminder ? AppColors.primary.withValues(alpha: 0.15) : AppColors.primary,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primary),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    hasReminder ? Icons.notifications_active_rounded : Icons.notifications_none_rounded,
                    size: 13,
                    color: hasReminder ? AppColors.primary : AppColors.black,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      hasReminder ? 'Reminded' : 'Remind Me',
                      overflow: TextOverflow.ellipsis,
                      style: AppFontStyle.styleW700(hasReminder ? AppColors.primary : AppColors.black, 11),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

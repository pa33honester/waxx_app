import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:waxxapp/seller_pages/schedule_live_page/controller/schedule_live_controller.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';

class ScheduleLiveView extends StatelessWidget {
  const ScheduleLiveView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ScheduleLiveController());
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        surfaceTintColor: AppColors.transparent,
        leading: GestureDetector(
          onTap: Get.back,
          child: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.white, size: 20),
        ),
        title: Text('Schedule a Show', style: AppFontStyle.styleW700(AppColors.white, 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionLabel('Show Title'),
            const SizedBox(height: 8),
            _InputField(
              controller: controller.titleController,
              hint: 'e.g. Weekend Deals Drop',
              maxLines: 1,
            ),
            const SizedBox(height: 20),
            _SectionLabel('Description (optional)'),
            const SizedBox(height: 8),
            _InputField(
              controller: controller.descriptionController,
              hint: 'Tell buyers what to expect...',
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            _SectionLabel('Cover Image (optional)'),
            const SizedBox(height: 8),
            _CoverImagePicker(controller: controller),
            const SizedBox(height: 20),
            _SectionLabel('Date & Time'),
            const SizedBox(height: 8),
            Obx(() {
              final dt = controller.selectedDateTime.value;
              return GestureDetector(
                onTap: () => _pickDateTime(context, controller),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.tabBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: dt != null ? AppColors.primary : AppColors.unselected.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today_rounded, color: AppColors.primary, size: 20),
                      const SizedBox(width: 12),
                      Text(
                        dt != null
                            ? DateFormat('MMM d, yyyy  h:mm a').format(dt)
                            : 'Select date and time',
                        style: AppFontStyle.styleW500(
                          dt != null ? AppColors.white : AppColors.unselected,
                          14,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 32),
            Obx(() => SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value ? null : controller.scheduleShow,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: controller.isLoading.value
                        ? SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              color: AppColors.black,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Text('Schedule Show', style: AppFontStyle.styleW700(AppColors.black, 15)),
                  ),
                )),
            const SizedBox(height: 32),
            Obx(() {
              if (controller.scheduledLives.isEmpty) return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Upcoming Shows', style: AppFontStyle.styleW700(AppColors.white, 16)),
                  const SizedBox(height: 12),
                  ...controller.scheduledLives.map((live) => _ScheduledLiveItem(live: live)),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDateTime(BuildContext context, ScheduleLiveController controller) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(hours: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.dark(
            primary: AppColors.primary,
            onPrimary: AppColors.black,
          ),
        ),
        child: child!,
      ),
    );
    if (date == null || !context.mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.dark(
            primary: AppColors.primary,
            onPrimary: AppColors.black,
          ),
        ),
        child: child!,
      ),
    );
    if (time == null) return;

    controller.selectedDateTime.value =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) =>
      Text(text, style: AppFontStyle.styleW700(AppColors.white, 14));
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;

  const _InputField({required this.controller, required this.hint, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: AppColors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.unselected),
        filled: true,
        fillColor: AppColors.tabBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.unselected.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.unselected.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}

class _ScheduledLiveItem extends StatelessWidget {
  final dynamic live;
  const _ScheduledLiveItem({required this.live});

  @override
  Widget build(BuildContext context) {
    final dt = live.scheduledAt as DateTime?;
    final coverUrl = (live.image as String?)?.trim() ?? '';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.tabBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          // Cover thumbnail when the seller uploaded one; falls back to
          // the live-tv icon for older shows scheduled before this feature.
          if (coverUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: coverUrl,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Icon(Icons.live_tv_rounded, color: AppColors.primary, size: 22),
              ),
            )
          else
            Icon(Icons.live_tv_rounded, color: AppColors.primary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  live.title ?? '',
                  style: AppFontStyle.styleW700(AppColors.white, 14),
                ),
                if (dt != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMM d, yyyy  h:mm a').format(dt),
                    style: AppFontStyle.styleW500(AppColors.unselected, 12),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Square-ish cover image picker. Tap to choose from gallery; small overlay
/// "Change" / "Remove" buttons appear once an image is selected.
class _CoverImagePicker extends StatelessWidget {
  final ScheduleLiveController controller;
  const _CoverImagePicker({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final file = controller.selectedImage.value;
      if (file == null) {
        return GestureDetector(
          onTap: () => _showSourceSheet(context),
          child: Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.tabBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.unselected.withValues(alpha: 0.3)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_photo_alternate_rounded, size: 32, color: AppColors.primary),
                const SizedBox(height: 8),
                Text('Add a cover image', style: AppFontStyle.styleW600(AppColors.white, 13)),
                const SizedBox(height: 2),
                Text(
                  'Buyers see this on the upcoming-shows card.',
                  style: AppFontStyle.styleW500(AppColors.unselected, 11),
                ),
              ],
            ),
          ),
        );
      }
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              file,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Row(
              children: [
                _PickerOverlayButton(
                  icon: Icons.refresh_rounded,
                  label: 'Change',
                  onTap: () => _showSourceSheet(context),
                ),
                const SizedBox(width: 6),
                _PickerOverlayButton(
                  icon: Icons.close_rounded,
                  label: 'Remove',
                  onTap: controller.clearCoverImage,
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  void _showSourceSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.black,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library_rounded, color: AppColors.primary),
                title: Text('Choose from gallery', style: AppFontStyle.styleW600(AppColors.white, 14)),
                onTap: () {
                  Navigator.pop(context);
                  controller.pickCoverImage(fromGallery: true);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera_rounded, color: AppColors.primary),
                title: Text('Take a photo', style: AppFontStyle.styleW600(AppColors.white, 14)),
                onTap: () {
                  Navigator.pop(context);
                  controller.pickCoverImage(fromGallery: false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PickerOverlayButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PickerOverlayButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.black.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.white, size: 14),
            const SizedBox(width: 4),
            Text(label, style: AppFontStyle.styleW700(AppColors.white, 11)),
          ],
        ),
      ),
    );
  }
}

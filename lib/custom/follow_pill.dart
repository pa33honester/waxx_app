import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waxxapp/Controller/GetxController/user/follow_unfollow_controller.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';

/// Compact "+ Follow" / "✓ Following" pill for overlay use (live-watch,
/// reels, small seller cards). Handles optimistic toggle + API call via
/// [FollowUnFollowController].
class FollowPill extends StatefulWidget {
  final String sellerId;
  final bool initiallyFollowing;
  final ValueChanged<bool>? onChanged;

  const FollowPill({
    super.key,
    required this.sellerId,
    this.initiallyFollowing = false,
    this.onChanged,
  });

  @override
  State<FollowPill> createState() => _FollowPillState();
}

class _FollowPillState extends State<FollowPill> {
  late bool _following = widget.initiallyFollowing;
  bool _inFlight = false;

  Future<void> _toggle() async {
    if (_inFlight) return;
    final next = !_following;
    setState(() {
      _following = next;
      _inFlight = true;
    });
    widget.onChanged?.call(next);
    try {
      final ctrl = Get.isRegistered<FollowUnFollowController>()
          ? Get.find<FollowUnFollowController>()
          : Get.put(FollowUnFollowController());
      await ctrl.followUnfollowData(sellerId: widget.sellerId);
    } catch (_) {
      if (!mounted) return;
      setState(() => _following = !next);
      widget.onChanged?.call(!next);
    } finally {
      if (mounted) setState(() => _inFlight = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = _following ? AppColors.white.withValues(alpha: 0.18) : AppColors.primary;
    final fg = _following ? AppColors.white : AppColors.black;
    final border = _following ? Border.all(color: AppColors.white.withValues(alpha: 0.4)) : null;

    return GestureDetector(
      onTap: _toggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
          border: border,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _following ? Icons.check_rounded : Icons.add_rounded,
              size: 14,
              color: fg,
            ),
            const SizedBox(width: 4),
            Text(
              _following ? 'Following' : 'Follow',
              style: AppFontStyle.styleW700(fg, 12),
            ),
          ],
        ),
      ),
    );
  }
}

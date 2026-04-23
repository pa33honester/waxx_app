import 'package:flutter/material.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';

/// Wraps a circular avatar with a pulsing pink ring + "LIVE" chip when
/// [isLive] is true. When the seller is not live it renders [child] unchanged.
class LiveAvatarRing extends StatefulWidget {
  final Widget child;
  final bool isLive;
  final double size;
  final bool showLiveChip;

  const LiveAvatarRing({
    super.key,
    required this.child,
    required this.isLive,
    required this.size,
    this.showLiveChip = true,
  });

  @override
  State<LiveAvatarRing> createState() => _LiveAvatarRingState();
}

class _LiveAvatarRingState extends State<LiveAvatarRing> with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    if (widget.isLive) _pulse.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant LiveAvatarRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLive && !_pulse.isAnimating) {
      _pulse.repeat(reverse: true);
    } else if (!widget.isLive && _pulse.isAnimating) {
      _pulse.stop();
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLive) return widget.child;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _pulse,
            builder: (_, __) {
              final t = _pulse.value;
              return Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFFF2D6A).withValues(alpha: 0.85),
                    width: 2.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF2D6A).withValues(alpha: 0.35 + 0.25 * t),
                      blurRadius: 8 + 8 * t,
                      spreadRadius: 1 + 2 * t,
                    ),
                  ],
                ),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.all(widget.size * 0.08),
            child: ClipOval(child: widget.child),
          ),
          if (widget.showLiveChip)
            Positioned(
              bottom: -4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF2D6A),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppColors.black, width: 1),
                ),
                child: Text(
                  'LIVE',
                  style: AppFontStyle.styleW900(AppColors.white, 8),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

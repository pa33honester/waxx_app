import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/socket_services.dart';

// TikTok-style floating hearts. Listens to the room-wide
// SocketServices.liveLikeCount RxInt and, every time the count goes
// up (i.e. someone in the room — including the local viewer — taps
// like), spawns an animated heart that drifts up and fades out.
//
// Mounted as a Positioned layer inside LiveUi's root Stack so it
// sits above the live video / gradient but below the right-side
// action column, comments, and product overlays. The widget itself
// is wrapped in IgnorePointer so taps fall through to the layers
// behind it.
class FloatingHeartsOverlay extends StatefulWidget {
  const FloatingHeartsOverlay({super.key, this.bottomInset = 90});

  // Distance from the bottom of the screen where hearts spawn.
  // Default leaves room for the comment-input bar.
  final double bottomInset;

  @override
  State<FloatingHeartsOverlay> createState() => _FloatingHeartsOverlayState();
}

class _FloatingHeartsOverlayState extends State<FloatingHeartsOverlay>
    with TickerProviderStateMixin {
  final List<_Heart> _hearts = [];
  final Random _rand = Random();
  Worker? _worker;
  int _lastSeenCount = 0;

  @override
  void initState() {
    super.initState();
    _lastSeenCount = SocketServices.liveLikeCount.value;
    // ever() fires on every RxInt mutation; we only spawn hearts on
    // increases, and we cap the burst at 5 hearts per delta so a
    // jump of N (e.g. catching up on history) doesn't flood the
    // scene with N hearts.
    _worker = ever<int>(SocketServices.liveLikeCount, (next) {
      if (next > _lastSeenCount) {
        final delta = (next - _lastSeenCount).clamp(1, 5);
        for (int i = 0; i < delta; i++) {
          // Stagger the burst over ~150ms so multiple hearts don't
          // overlap into one blob.
          Future.delayed(Duration(milliseconds: i * 50), _spawn);
        }
      }
      _lastSeenCount = next;
    });
  }

  @override
  void dispose() {
    _worker?.dispose();
    for (final h in _hearts) {
      h.controller.dispose();
    }
    _hearts.clear();
    super.dispose();
  }

  void _spawn() {
    if (!mounted) return;
    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    final heart = _Heart(
      controller: controller,
      color: _randomHeartColor(),
      // Horizontal jitter at the spawn point so hearts don't all
      // stack on the same vertical column.
      startDx: _rand.nextDouble() * 50 - 25,
      // Wave amplitude for the lateral drift on the way up.
      sway: _rand.nextDouble() * 30 + 10,
      sizePx: 26 + _rand.nextDouble() * 14,
    );
    setState(() {
      _hearts.add(heart);
    });
    controller.forward().whenComplete(() {
      if (!mounted) {
        controller.dispose();
        return;
      }
      setState(() {
        _hearts.remove(heart);
      });
      controller.dispose();
    });
  }

  Color _randomHeartColor() {
    // A small palette so the screen looks lively without going
    // full-rainbow.
    const palette = [
      Color(0xFFE91E63), // pink
      Color(0xFFF44336), // red
      Color(0xFFFF6F00), // orange-red
      Color(0xFFFFC107), // amber
      Color(0xFF1D9BF0), // brand blue (verification badge tone)
    ];
    return palette[_rand.nextInt(palette.length)];
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: _hearts
            .map((h) => AnimatedBuilder(
                  animation: h.controller,
                  builder: (context, _) => _buildHeart(h),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildHeart(_Heart h) {
    final t = h.controller.value;
    // Vertical rise: full screen-ish height minus the bottom inset
    // and a bit of headroom near the top.
    final maxRise = MediaQuery.of(context).size.height * 0.55;
    final dy = -t * maxRise;
    // Lateral wave — sin curve, amplitude h.sway.
    final dx = h.startDx + sin(t * pi * 3) * h.sway;
    // Fade out in the back half + scale in then settle.
    final opacity = (1.0 - (t * 1.1)).clamp(0.0, 1.0);
    final scale = t < 0.15 ? (t / 0.15) : 1.0;

    return Positioned(
      right: 28,
      bottom: widget.bottomInset,
      child: Transform.translate(
        offset: Offset(dx, dy),
        child: Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: opacity,
            child: Icon(
              Icons.favorite_rounded,
              color: h.color,
              size: h.sizePx,
              shadows: [
                Shadow(
                  color: AppColors.black.withValues(alpha: 0.4),
                  blurRadius: 6,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Heart {
  _Heart({
    required this.controller,
    required this.color,
    required this.startDx,
    required this.sway,
    required this.sizePx,
  });

  final AnimationController controller;
  final Color color;
  final double startDx;
  final double sway;
  final double sizePx;
}

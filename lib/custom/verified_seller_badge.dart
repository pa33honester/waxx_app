import 'package:flutter/material.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';

/// Whatnot-style blue check badge. Use next to a seller name when
/// [isVerified] is true; renders nothing when false so it can be dropped
/// in unconditionally.
class VerifiedSellerBadge extends StatelessWidget {
  final bool isVerified;
  final double size;
  final bool showLabel;

  const VerifiedSellerBadge({
    super.key,
    required this.isVerified,
    this.size = 14,
    this.showLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVerified) return const SizedBox.shrink();

    final check = Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFF1D9BF0),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(Icons.check, color: AppColors.white, size: size * 0.7),
    );

    if (!showLabel) return check;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        check,
        const SizedBox(width: 4),
        Text(
          'Verified',
          style: AppFontStyle.styleW700(const Color(0xFF1D9BF0), size * 0.9),
        ),
      ],
    );
  }
}

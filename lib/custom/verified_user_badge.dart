import 'package:flutter/material.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';

/// Whatnot-style blue check badge driven by a verification status
/// string. Renders only when [status] is exactly `"verified"` so it
/// can be dropped into any Row unconditionally — `pending_review`,
/// `rejected`, `none`, and `null` all produce a zero-size widget.
///
/// Used for both buyers and sellers — selfie verification is a
/// user-level signal, not a seller-only one. The (legacy)
/// `VerifiedSellerBadge` widget delegates here so existing call
/// sites compile unchanged while their semantics get tightened.
class VerifiedUserBadge extends StatelessWidget {
  final String? status;
  final double size;
  final bool showLabel;

  const VerifiedUserBadge({
    super.key,
    required this.status,
    this.size = 14,
    this.showLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    if (status != "verified") return const SizedBox.shrink();

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

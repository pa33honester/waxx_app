import 'package:flutter/material.dart';
import 'package:waxxapp/custom/verified_user_badge.dart';

/// Legacy badge — kept for backwards compatibility with existing call
/// sites. Internally delegates to [VerifiedUserBadge]. New code should
/// use [VerifiedUserBadge] directly with the user/seller's
/// `verificationStatus` string.
///
/// `isVerified: true` is mapped to `status: "verified"` so the
/// rendering output is identical.
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
    return VerifiedUserBadge(
      status: isVerified ? "verified" : null,
      size: size,
      showLabel: showLabel,
    );
  }
}

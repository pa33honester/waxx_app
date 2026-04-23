import 'package:flutter/material.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';

/// System messages rendered inline in the live chat rail — sold, new bid,
/// giveaway winner, new follower. Each has its own icon + accent color so
/// viewers can spot them at a glance against regular chat.
///
/// Server-side emission format on the `mainLiveComments` socket stream:
///   {"type": "SYSTEM", "systemType": "SOLD" | "BID" | "GIVEAWAY_WIN" | "FOLLOW",
///    "userName": "...", "text": "..."}
class LiveSystemMessage extends StatelessWidget {
  final String systemType;
  final String userName;
  final String text;

  const LiveSystemMessage({
    super.key,
    required this.systemType,
    required this.userName,
    required this.text,
  });

  ({IconData icon, Color color, String label}) get _style {
    switch (systemType) {
      case 'SOLD':
        return (icon: Icons.shopping_bag_rounded, color: const Color(0xFFB1FF1F), label: 'SOLD');
      case 'BID':
        return (icon: Icons.gavel_rounded, color: AppColors.primary, label: 'BID');
      case 'GIVEAWAY_WIN':
        return (icon: Icons.card_giftcard_rounded, color: const Color(0xFFFF2D6A), label: 'WINNER');
      case 'FOLLOW':
        return (icon: Icons.person_add_alt_1_rounded, color: const Color(0xFF1D9BF0), label: 'FOLLOW');
      default:
        return (icon: Icons.info_outline_rounded, color: AppColors.white, label: 'INFO');
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = _style;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: s.color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: s.color.withValues(alpha: 0.6), width: 1),
      ),
      child: Row(
        children: [
          Icon(s.icon, size: 14, color: s.color),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            decoration: BoxDecoration(
              color: s.color,
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(s.label, style: AppFontStyle.styleW900(AppColors.black, 9)),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: RichText(
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              text: TextSpan(
                children: [
                  if (userName.isNotEmpty)
                    TextSpan(
                      text: '$userName ',
                      style: AppFontStyle.styleW700(s.color, 11.5),
                    ),
                  TextSpan(
                    text: text,
                    style: AppFontStyle.styleW500(AppColors.white, 11.5),
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

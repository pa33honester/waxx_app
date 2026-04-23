import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waxxapp/seller_pages/live_page/controller/seller_giveaway_controller.dart';
import 'package:waxxapp/user_pages/giveaway/controller/user_giveaway_controller.dart';

/// Seller-side overlay shown on top of the stream while a giveaway is running.
/// Mirrors the buyer pill but swaps the "Enter" CTA for a "Draw now" CTA.
class SellerGiveawayOverlay extends StatelessWidget {
  const SellerGiveawayOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final userCtl = Get.isRegistered<UserGiveawayController>()
        ? Get.find<UserGiveawayController>()
        : Get.put(UserGiveawayController(), permanent: false);
    final sellerCtl = Get.isRegistered<SellerGiveawayController>()
        ? Get.find<SellerGiveawayController>()
        : Get.put(SellerGiveawayController(), permanent: false);

    return Obx(() {
      final giveaway = userCtl.activeGiveaway.value;
      if (giveaway == null || giveaway.status != 1) return const SizedBox.shrink();

      final remaining = userCtl.remainingSeconds.value;
      final mm = (remaining ~/ 60).toString().padLeft(2, '0');
      final ss = (remaining % 60).toString().padLeft(2, '0');

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.72),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFDEF213), width: 1.4),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '🎁 Giveaway live',
                    style: TextStyle(color: Color(0xFFDEF213), fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    giveaway.productName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '${giveaway.entryCount} entered · $mm:$ss left',
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: sellerCtl.isDrawing.value
                  ? null
                  : () => sellerCtl.drawGiveaway(giveawayId: giveaway.id),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDEF213),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: sellerCtl.isDrawing.value
                  ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Draw now'),
            ),
          ],
        ),
      );
    });
  }
}

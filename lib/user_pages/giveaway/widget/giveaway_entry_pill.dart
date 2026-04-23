import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waxxapp/user_pages/giveaway/controller/user_giveaway_controller.dart';
import 'package:waxxapp/utils/api_url.dart';

/// Buyer-side pill that surfaces the active giveaway inside a live-watch view.
/// Drop it into the existing live view alongside chat/bid widgets. When there
/// is no active giveaway, the widget collapses to an empty [SizedBox].
class GiveawayEntryPill extends StatelessWidget {
  const GiveawayEntryPill({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<UserGiveawayController>()
        ? Get.find<UserGiveawayController>()
        : Get.put(UserGiveawayController(), permanent: false);

    return Obx(() {
      final giveaway = controller.activeGiveaway.value;
      if (giveaway == null || giveaway.status != 1) return const SizedBox.shrink();

      final remaining = controller.remainingSeconds.value;
      final mm = (remaining ~/ 60).toString().padLeft(2, '0');
      final ss = (remaining % 60).toString().padLeft(2, '0');

      final entered = controller.hasEntered.value;
      final submitting = controller.isSubmitting.value;

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.72),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFDEF213), width: 1.2),
        ),
        child: Row(
          children: [
            if (giveaway.mainImage.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  giveaway.mainImage.startsWith('http')
                      ? giveaway.mainImage
                      : '${Api.baseUrl}storage/${giveaway.mainImage}',
                  width: 36,
                  height: 36,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox(width: 36, height: 36),
                ),
              ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '🎁 Giveaway',
                    style: const TextStyle(
                      color: Color(0xFFDEF213),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    giveaway.productName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '${giveaway.entryCount} entered · $mm:$ss',
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: entered || submitting ? null : controller.enter,
              style: ElevatedButton.styleFrom(
                backgroundColor: entered ? Colors.green : const Color(0xFFDEF213),
                foregroundColor: Colors.black,
                disabledBackgroundColor: Colors.green.withValues(alpha: 0.8),
                disabledForegroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              ),
              child: submitting
                  ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(entered ? 'Entered ✓' : 'Enter'),
            ),
          ],
        ),
      );
    });
  }
}

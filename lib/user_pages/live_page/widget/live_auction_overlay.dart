import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waxxapp/user_pages/live_page/controller/live_auction_controller.dart';
import 'package:waxxapp/user_pages/live_page/widget/set_max_bid_sheet.dart';
import 'package:waxxapp/utils/globle_veriables.dart';

/// In-stream auction pill. Visible to both the host and viewers when an
/// auction is active; viewers get a "BID $next" tap target, hosts get a
/// read-only view (starting the auction lives on a separate host control).
class LiveAuctionOverlay extends StatelessWidget {
  const LiveAuctionOverlay({super.key, this.isHost = false});

  final bool isHost;

  @override
  Widget build(BuildContext context) {
    final ctl = Get.isRegistered<LiveAuctionController>()
        ? Get.find<LiveAuctionController>()
        : Get.put(LiveAuctionController(), permanent: false);

    return Obx(() {
      final winner = ctl.lastWinner.value;
      final auction = ctl.activeAuction.value;

      if (auction == null && winner == null) return const SizedBox.shrink();

      if (winner != null) {
        return _buildWinnerBanner(winner);
      }

      final remaining = ctl.remainingSeconds.value;
      final mm = (remaining ~/ 60).toString().padLeft(2, '0');
      final ss = (remaining % 60).toString().padLeft(2, '0');
      final nextBid = auction!.currentBid.toInt() + LiveAuctionController.defaultIncrement;

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.74),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFFFC43A), width: 1.4),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 44,
                height: 44,
                child: auction.mainImage.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: auction.mainImage,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => _placeholderThumb(),
                      )
                    : _placeholderThumb(),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.gavel_rounded, size: 13, color: Color(0xFFFFC43A)),
                      const SizedBox(width: 4),
                      const Text(
                        'AUCTION',
                        style: TextStyle(
                          color: Color(0xFFFFC43A),
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$mm:$ss',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    auction.productName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Current bid: $currencySymbol${auction.currentBid}',
                        style: const TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                      if (ctl.myMaxBid.value != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFC43A).withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: const Color(0xFFFFC43A), width: 1),
                          ),
                          child: Text(
                            'Max $currencySymbol${ctl.myMaxBid.value}',
                            style: const TextStyle(
                              color: Color(0xFFFFC43A),
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            if (!isHost)
              GestureDetector(
                onLongPress: () => SetMaxBidSheet.show(context),
                child: ElevatedButton(
                  onPressed: ctl.isSubmitting.value ? null : () => ctl.placeBid(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFC43A),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                  ),
                  child: ctl.isSubmitting.value
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                        )
                      : Text(
                          'BID $currencySymbol$nextBid',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                        ),
                ),
              ),
            if (!isHost && ctl.myMaxBid.value == null)
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: IconButton(
                  onPressed: () => SetMaxBidSheet.show(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                  tooltip: 'Set max bid',
                  icon: const Icon(Icons.auto_awesome, size: 18, color: Color(0xFFFFC43A)),
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildWinnerBanner(LiveAuctionWinnerEvent winner) {
    final name = '${winner.firstName} ${winner.lastName}'.trim();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.74),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF4ADE80), width: 1.4),
      ),
      child: Row(
        children: [
          const Icon(Icons.emoji_events_rounded, color: Color(0xFF4ADE80), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'SOLD',
                  style: TextStyle(
                    color: Color(0xFF4ADE80),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                  ),
                ),
                Text(
                  '${name.isEmpty ? "Winner" : name} · $currencySymbol${winner.currentBid}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholderThumb() {
    return Container(
      color: Colors.white12,
      alignment: Alignment.center,
      child: const Icon(Icons.image_outlined, color: Colors.white38, size: 20),
    );
  }
}

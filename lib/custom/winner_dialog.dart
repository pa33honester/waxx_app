import 'package:flutter/material.dart';
import 'package:waxxapp/ApiModel/giveaway/giveaway_model.dart';
import 'package:waxxapp/utils/api_url.dart';

/// Fullscreen-ish giveaway winner reveal. Shown to every viewer in the room;
/// the winning viewer additionally sees a "Claim" CTA to confirm shipping.
void showGiveawayWinnerDialog({
  required BuildContext context,
  required GiveawayWinnerEvent event,
  required bool isMe,
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.6),
    builder: (ctx) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(24),
        child: _WinnerDialogBody(event: event, isMe: isMe),
      );
    },
  );
}

class _WinnerDialogBody extends StatelessWidget {
  final GiveawayWinnerEvent event;
  final bool isMe;

  const _WinnerDialogBody({required this.event, required this.isMe});

  String get _winnerName {
    final name = '${event.firstName} ${event.lastName}'.trim();
    return name.isEmpty ? 'A lucky viewer' : name;
  }

  String? get _productImageUrl {
    if (event.mainImage.isEmpty) return null;
    if (event.mainImage.startsWith('http')) return event.mainImage;
    return '${Api.baseUrl}storage/${event.mainImage}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFDEF213), Color(0xFFFFFFFF)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🎉', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 8),
          Text(
            isMe ? 'You won!' : 'Winner drawn',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 16),
          if (_productImageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                _productImageUrl!,
                height: 140,
                width: 140,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox(height: 140, width: 140),
              ),
            ),
          const SizedBox(height: 12),
          Text(
            event.productName,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            isMe ? 'Confirm your shipping address to claim.' : 'Congrats to $_winnerName!',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Close', style: TextStyle(color: Colors.black87)),
                ),
              ),
              if (isMe) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed('/MyOrder');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Claim'),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

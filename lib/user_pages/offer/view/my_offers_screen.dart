import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waxxapp/ApiModel/offer/offer_model.dart';
import 'package:waxxapp/ApiService/offer/offer_service.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/database.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';

/// Buyer-facing offer history. Lists every offer the signed-in user has sent,
/// grouped by lifecycle status with quick CTAs for the pending / countered
/// rows (accept a counter, decline, or retract a still-pending offer).
class MyOffersScreen extends StatefulWidget {
  const MyOffersScreen({super.key});

  @override
  State<MyOffersScreen> createState() => _MyOffersScreenState();
}

class _MyOffersScreenState extends State<MyOffersScreen> {
  List<OfferModel> _offers = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final offers = await OfferService.getSent(buyerId: Database.loginUserId);
    if (!mounted) return;
    setState(() {
      _offers = offers;
      _loading = false;
    });
  }

  Future<void> _acceptCounter(OfferModel o) async {
    final r = await OfferService.accept(offerId: o.id);
    if (!mounted) return;
    Get.snackbar('Offer', r.message.isNotEmpty ? r.message : (r.ok ? 'Accepted' : 'Failed'),
        snackPosition: SnackPosition.BOTTOM);
    if (r.ok) _load();
  }

  Future<void> _decline(OfferModel o) async {
    final r = await OfferService.decline(offerId: o.id, declinedBy: 'buyer');
    if (!mounted) return;
    Get.snackbar('Offer', r.message.isNotEmpty ? r.message : (r.ok ? 'Declined' : 'Failed'),
        snackPosition: SnackPosition.BOTTOM);
    if (r.ok) _load();
  }

  Future<void> _withdraw(OfferModel o) async {
    final r = await OfferService.withdraw(offerId: o.id, buyerId: Database.loginUserId);
    if (!mounted) return;
    Get.snackbar('Offer', r.message.isNotEmpty ? r.message : (r.ok ? 'Withdrawn' : 'Failed'),
        snackPosition: SnackPosition.BOTTOM);
    if (r.ok) _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('My Offers', style: AppFontStyle.styleW700(AppColors.white, 16)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _offers.isEmpty
              ? Center(
                  child: Text(
                    "You haven't made any offers yet.",
                    style: AppFontStyle.styleW500(AppColors.unselected, 13),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: _offers.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (_, i) => _OfferRow(
                      offer: _offers[i],
                      onAcceptCounter: () => _acceptCounter(_offers[i]),
                      onDecline: () => _decline(_offers[i]),
                      onWithdraw: () => _withdraw(_offers[i]),
                    ),
                  ),
                ),
    );
  }
}

class _OfferRow extends StatelessWidget {
  final OfferModel offer;
  final VoidCallback onAcceptCounter;
  final VoidCallback onDecline;
  final VoidCallback onWithdraw;

  const _OfferRow({
    required this.offer,
    required this.onAcceptCounter,
    required this.onDecline,
    required this.onWithdraw,
  });

  @override
  Widget build(BuildContext context) {
    final prod = offer.product;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.tabBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 54,
                  height: 54,
                  child: prod != null && prod.mainImage.isNotEmpty
                      ? CachedNetworkImage(imageUrl: prod.mainImage, fit: BoxFit.cover)
                      : Container(color: Colors.white12),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      prod?.productName ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppFontStyle.styleW700(AppColors.white, 13),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _buildAmountLine(),
                      style: AppFontStyle.styleW500(AppColors.white, 12),
                    ),
                    if (offer.listedPrice > 0)
                      Text(
                        'Listed $currencySymbol${offer.listedPrice}',
                        style: AppFontStyle.styleW500(AppColors.unselected, 11),
                      ),
                  ],
                ),
              ),
              _StatusPill(status: offer.status, awaitingBuyer: offer.awaitingBuyer),
            ],
          ),
          if (offer.isActive) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                if (offer.awaitingBuyer) ...[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onAcceptCounter,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(
                        'Accept $currencySymbol${offer.counterAmount}',
                        style: AppFontStyle.styleW700(AppColors.black, 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onDecline,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white24),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text('Decline',
                          style: AppFontStyle.styleW600(AppColors.white, 12)),
                    ),
                  ),
                ] else
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onWithdraw,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white24),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text('Withdraw offer',
                          style: AppFontStyle.styleW600(AppColors.white, 12)),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _buildAmountLine() {
    if (offer.awaitingBuyer) {
      return 'Countered $currencySymbol${offer.counterAmount}  ·  You offered $currencySymbol${offer.offerAmount}';
    }
    return 'You offered $currencySymbol${offer.offerAmount}';
  }
}

class _StatusPill extends StatelessWidget {
  final String status;
  final bool awaitingBuyer;
  const _StatusPill({required this.status, required this.awaitingBuyer});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      'accepted' => ('Accepted', const Color(0xFF4ADE80)),
      'declined' => ('Declined', const Color(0xFFFF5A5F)),
      'withdrawn' => ('Withdrawn', const Color(0xFF94A3B8)),
      'expired' => ('Expired', const Color(0xFF94A3B8)),
      'countered' => (awaitingBuyer ? 'Counter' : 'Countered', const Color(0xFFFFC43A)),
      _ => ('Pending', const Color(0xFFFFC43A)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        label,
        style: AppFontStyle.styleW700(color, 10),
      ),
    );
  }
}

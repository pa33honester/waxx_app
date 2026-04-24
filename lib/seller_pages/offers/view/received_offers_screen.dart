import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:waxxapp/ApiModel/offer/offer_model.dart';
import 'package:waxxapp/ApiService/offer/offer_service.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/database.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';

/// Seller inbox of incoming offers, filterable by lifecycle status. Lets the
/// seller accept, counter, or decline pending offers; countered ones wait on
/// the buyer and are displayed read-only.
class ReceivedOffersScreen extends StatefulWidget {
  const ReceivedOffersScreen({super.key});

  @override
  State<ReceivedOffersScreen> createState() => _ReceivedOffersScreenState();
}

class _ReceivedOffersScreenState extends State<ReceivedOffersScreen> {
  // Tabs: All / Pending / Countered / Accepted / Declined.
  final _tabs = const ['all', 'pending', 'countered', 'accepted', 'declined'];
  String _activeTab = 'pending';

  List<OfferModel> _offers = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final offers = await OfferService.getReceived(
      sellerId: Database.sellerId,
      status: _activeTab == 'all' ? null : _activeTab,
    );
    if (!mounted) return;
    setState(() {
      _offers = offers;
      _loading = false;
    });
  }

  Future<void> _accept(OfferModel o) async {
    final confirmed = await _confirm(
      'Accept offer?',
      'An order at $currencySymbol${o.activeAmount} will be created for the buyer to check out.',
      confirmLabel: 'Accept',
    );
    if (!confirmed) return;
    final r = await OfferService.accept(offerId: o.id);
    _after(r.ok, r.message.isNotEmpty ? r.message : (r.ok ? 'Accepted' : 'Failed'));
  }

  Future<void> _decline(OfferModel o) async {
    final confirmed = await _confirm(
      'Decline offer?',
      'The buyer will be notified.',
      confirmLabel: 'Decline',
      destructive: true,
    );
    if (!confirmed) return;
    final r = await OfferService.decline(offerId: o.id, declinedBy: 'seller');
    _after(r.ok, r.message.isNotEmpty ? r.message : (r.ok ? 'Declined' : 'Failed'));
  }

  Future<void> _counter(OfferModel o) async {
    final amount = await _askCounterAmount(o);
    if (amount == null) return;
    final r = await OfferService.counter(offerId: o.id, counterAmount: amount);
    _after(r.ok, r.message.isNotEmpty ? r.message : (r.ok ? 'Counter sent' : 'Failed'));
  }

  void _after(bool ok, String msg) {
    if (!mounted) return;
    Get.snackbar('Offer', msg, snackPosition: SnackPosition.BOTTOM);
    if (ok) _load();
  }

  Future<bool> _confirm(String title, String body,
      {required String confirmLabel, bool destructive = false}) async {
    final res = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.tabBackground,
        title: Text(title, style: AppFontStyle.styleW700(AppColors.white, 15)),
        content: Text(body, style: AppFontStyle.styleW500(AppColors.unselected, 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('Cancel', style: AppFontStyle.styleW600(AppColors.white, 13)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              confirmLabel,
              style: AppFontStyle.styleW700(
                destructive ? const Color(0xFFFF5A5F) : AppColors.primary,
                13,
              ),
            ),
          ),
        ],
      ),
    );
    return res == true;
  }

  Future<num?> _askCounterAmount(OfferModel o) async {
    final ctl = TextEditingController(text: (o.offerAmount + 5).toString());
    String? err;
    final result = await showDialog<num>(
      context: context,
      builder: (ctx) => StatefulBuilder(builder: (ctx, setSt) {
        return AlertDialog(
          backgroundColor: AppColors.tabBackground,
          title: Text('Counter with', style: AppFontStyle.styleW700(AppColors.white, 15)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Buyer offered $currencySymbol${o.offerAmount} on ${o.product?.productName ?? 'this item'}',
                style: AppFontStyle.styleW500(AppColors.unselected, 12),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: ctl,
                autofocus: true,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                style: AppFontStyle.styleW700(AppColors.white, 16),
                decoration: InputDecoration(
                  prefixText: '$currencySymbol ',
                  prefixStyle: AppFontStyle.styleW700(AppColors.white, 16),
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              if (err != null) ...[
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(err!, style: AppFontStyle.styleW500(const Color(0xFFFF5A5F), 12)),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Cancel', style: AppFontStyle.styleW600(AppColors.white, 13)),
            ),
            TextButton(
              onPressed: () {
                final v = num.tryParse(ctl.text.trim());
                if (v == null || v <= 0) {
                  setSt(() => err = 'Enter a valid amount.');
                  return;
                }
                Navigator.of(ctx).pop(v);
              },
              child: Text('Send', style: AppFontStyle.styleW700(AppColors.primary, 13)),
            ),
          ],
        );
      }),
    );
    ctl.dispose();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Received Offers', style: AppFontStyle.styleW700(AppColors.white, 16)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _tabs.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final tab = _tabs[i];
                final active = tab == _activeTab;
                return Center(
                  child: InkWell(
                    onTap: () {
                      setState(() => _activeTab = tab);
                      _load();
                    },
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: active ? AppColors.primary : Colors.white10,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        tab[0].toUpperCase() + tab.substring(1),
                        style: AppFontStyle.styleW700(
                          active ? AppColors.black : AppColors.white,
                          12,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _offers.isEmpty
                    ? Center(
                        child: Text(
                          'No offers here yet.',
                          style: AppFontStyle.styleW500(AppColors.unselected, 13),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _load,
                        child: ListView.separated(
                          padding: const EdgeInsets.all(12),
                          itemCount: _offers.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 8),
                          itemBuilder: (_, i) => _ReceivedRow(
                            offer: _offers[i],
                            onAccept: () => _accept(_offers[i]),
                            onCounter: () => _counter(_offers[i]),
                            onDecline: () => _decline(_offers[i]),
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

class _ReceivedRow extends StatelessWidget {
  final OfferModel offer;
  final VoidCallback onAccept;
  final VoidCallback onCounter;
  final VoidCallback onDecline;

  const _ReceivedRow({
    required this.offer,
    required this.onAccept,
    required this.onCounter,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    final prod = offer.product;
    final buyer = offer.buyer;
    final canAct = offer.status == 'pending';

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
                      '${buyer?.displayName ?? 'Buyer'} offered $currencySymbol${offer.offerAmount}',
                      style: AppFontStyle.styleW500(AppColors.white, 12),
                    ),
                    if (offer.counterAmount != null)
                      Text(
                        'You countered $currencySymbol${offer.counterAmount}',
                        style: AppFontStyle.styleW500(AppColors.unselected, 11),
                      ),
                    if (offer.listedPrice > 0)
                      Text(
                        'Listed $currencySymbol${offer.listedPrice}',
                        style: AppFontStyle.styleW500(AppColors.unselected, 11),
                      ),
                  ],
                ),
              ),
              _StatusPill(status: offer.status),
            ],
          ),
          if (offer.buyerMessage.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '"${offer.buyerMessage}"',
                style: AppFontStyle.styleW500(AppColors.white, 12),
              ),
            ),
          ],
          if (canAct) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('Accept', style: AppFontStyle.styleW700(AppColors.black, 12)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCounter,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white38),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('Counter', style: AppFontStyle.styleW600(AppColors.white, 12)),
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
                    child: Text(
                      'Decline',
                      style: AppFontStyle.styleW600(const Color(0xFFFF5A5F), 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String status;
  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      'accepted' => ('Accepted', const Color(0xFF4ADE80)),
      'declined' => ('Declined', const Color(0xFFFF5A5F)),
      'withdrawn' => ('Withdrawn', const Color(0xFF94A3B8)),
      'countered' => ('Awaiting buyer', const Color(0xFFFFC43A)),
      _ => ('Pending', const Color(0xFFFFC43A)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(label, style: AppFontStyle.styleW700(color, 10)),
    );
  }
}

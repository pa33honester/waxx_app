import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waxxapp/ApiModel/giveaway/giveaway_model.dart';
import 'package:waxxapp/seller_pages/live_page/controller/seller_giveaway_controller.dart';
import 'package:waxxapp/utils/api_url.dart';
import 'package:waxxapp/utils/database.dart';

/// Product option passed by the seller's live view — matches the fields of
/// `LiveSeller.selectedProducts[]` that the existing live flow already has.
class GiveawayProductOption {
  final String productId;
  final String productName;
  final String? mainImage;

  GiveawayProductOption({required this.productId, required this.productName, this.mainImage});
}

/// Bottom sheet that lets a live seller configure and launch a giveaway.
/// Supply the live-broadcast id + an iterable of products the seller has
/// already queued for the show.
Future<GiveawayModel?> showStartGiveawaySheet({
  required BuildContext context,
  required String liveSellingHistoryId,
  required List<GiveawayProductOption> products,
}) {
  return showModalBottomSheet<GiveawayModel>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) => _StartGiveawaySheet(
      liveSellingHistoryId: liveSellingHistoryId,
      products: products,
    ),
  );
}

class _StartGiveawaySheet extends StatefulWidget {
  final String liveSellingHistoryId;
  final List<GiveawayProductOption> products;

  const _StartGiveawaySheet({required this.liveSellingHistoryId, required this.products});

  @override
  State<_StartGiveawaySheet> createState() => _StartGiveawaySheetState();
}

class _StartGiveawaySheetState extends State<_StartGiveawaySheet> {
  GiveawayProductOption? _selectedProduct;
  int _type = 1; // 1 = standard, 2 = followerOnly
  int _windowSeconds = 60;

  static const _windowOptions = [30, 60, 180, 300];

  @override
  void initState() {
    super.initState();
    if (widget.products.isNotEmpty) _selectedProduct = widget.products.first;
  }

  Future<void> _submit() async {
    if (_selectedProduct == null) return;
    final controller = Get.isRegistered<SellerGiveawayController>()
        ? Get.find<SellerGiveawayController>()
        : Get.put(SellerGiveawayController(), permanent: false);

    final model = await controller.startGiveaway(
      sellerId: Database.sellerId,
      liveSellingHistoryId: widget.liveSellingHistoryId,
      productId: _selectedProduct!.productId,
      type: _type,
      entryWindowSeconds: _windowSeconds,
    );
    if (!mounted) return;
    if (model != null) {
      Navigator.of(context).pop(model);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not start giveaway. Check wallet balance and try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).viewInsets;

    return Padding(
      padding: EdgeInsets.only(bottom: padding.bottom),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const Text('Start a giveaway', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              const Text('Prize product', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              if (widget.products.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('Queue at least one product for the live show before launching a giveaway.'),
                )
              else
                SizedBox(
                  height: 90,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (ctx, idx) {
                      final p = widget.products[idx];
                      final selected = p.productId == _selectedProduct?.productId;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedProduct = p),
                        child: Container(
                          width: 84,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: selected ? const Color(0xFFDEF213) : Colors.black12,
                              width: selected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: p.mainImage != null && p.mainImage!.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                                        child: Image.network(
                                          p.mainImage!.startsWith('http')
                                              ? p.mainImage!
                                              : '${Api.baseUrl}storage/${p.mainImage!}',
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          errorBuilder: (_, __, ___) => const SizedBox(),
                                        ),
                                      )
                                    : const SizedBox(),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                child: Text(
                                  p.productName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemCount: widget.products.length,
                  ),
                ),
              const SizedBox(height: 16),
              const Text('Audience', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Row(children: [
                Expanded(child: _choiceChip('Anyone', _type == 1, () => setState(() => _type = 1))),
                const SizedBox(width: 8),
                Expanded(child: _choiceChip('Followers only', _type == 2, () => setState(() => _type = 2))),
              ]),
              const SizedBox(height: 16),
              const Text('Entry window', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _windowOptions
                    .map((s) => _choiceChip(_formatWindow(s), _windowSeconds == s, () => setState(() => _windowSeconds = s)))
                    .toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _selectedProduct == null ? null : _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Start giveaway', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _choiceChip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFDEF213) : Colors.white,
          border: Border.all(color: selected ? const Color(0xFFDEF213) : Colors.black26),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }

  String _formatWindow(int seconds) {
    if (seconds < 60) return '${seconds}s';
    final m = seconds ~/ 60;
    return '${m}m';
  }
}

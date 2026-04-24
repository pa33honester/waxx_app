import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:waxxapp/user_pages/live_page/controller/live_auction_controller.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';

/// Max-bid (auto-bid) entry sheet for a live auction viewer. Reads the
/// currently-active auction off [LiveAuctionController] so we don't have
/// to thread state through the caller. Surfaces the server's rejection
/// message inline when the supplied max is too low.
class SetMaxBidSheet extends StatefulWidget {
  const SetMaxBidSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) => const SetMaxBidSheet(),
    );
  }

  @override
  State<SetMaxBidSheet> createState() => _SetMaxBidSheetState();
}

class _SetMaxBidSheetState extends State<SetMaxBidSheet> {
  final _amountCtl = TextEditingController();
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _amountCtl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final raw = _amountCtl.text.trim();
    final amount = num.tryParse(raw);
    final ctl = Get.find<LiveAuctionController>();
    final auction = ctl.activeAuction.value;
    if (auction == null) {
      Navigator.of(context).pop();
      return;
    }

    if (amount == null || amount <= 0) {
      setState(() => _error = 'Enter a valid amount.');
      return;
    }
    final minAccept = auction.currentBid + auction.bidIncrement;
    if (amount < minAccept) {
      setState(() => _error = 'Max bid must be at least $currencySymbol$minAccept.');
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
    });

    final resp = await ctl.setMaxBid(amount);

    if (!mounted) return;
    setState(() => _submitting = false);

    if (resp != null && resp.status == true) {
      Navigator.of(context).pop();
      Get.snackbar(
        'Max bid set',
        'We\'ll auto-bid on your behalf up to $currencySymbol$amount.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      final msg = resp?.message;
      setState(() => _error = (msg != null && msg.isNotEmpty) ? msg : 'Could not set max bid.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final ctl = Get.find<LiveAuctionController>();
    final auction = ctl.activeAuction.value;
    final minSuggested = (auction?.currentBid ?? 0) + (auction?.bidIncrement ?? 5) * 2;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: Color(0xFFFFC43A), size: 20),
              const SizedBox(width: 8),
              Text('Set max bid', style: AppFontStyle.styleW700(AppColors.white, 18)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "We'll bid on your behalf up to this amount and stop if someone else goes higher.",
            style: AppFontStyle.styleW500(AppColors.unselected, 12),
          ),
          const SizedBox(height: 16),
          if (auction != null)
            Text(
              'Current bid $currencySymbol${auction.currentBid}  ·  increment $currencySymbol${auction.bidIncrement}',
              style: AppFontStyle.styleW500(AppColors.unselected, 11),
            ),
          const SizedBox(height: 8),
          TextField(
            controller: _amountCtl,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: false),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: AppFontStyle.styleW700(AppColors.white, 16),
            decoration: InputDecoration(
              hintText: 'e.g. $minSuggested',
              hintStyle: AppFontStyle.styleW500(AppColors.unselected, 14),
              prefixText: '$currencySymbol ',
              prefixStyle: AppFontStyle.styleW700(AppColors.white, 16),
              filled: true,
              fillColor: Colors.white10,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(_error!, style: AppFontStyle.styleW500(const Color(0xFFFF5A5F), 12)),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitting ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFC43A),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: _submitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                    )
                  : Text('Set max bid', style: AppFontStyle.styleW700(AppColors.black, 14)),
            ),
          ),
        ],
      ),
    );
  }
}

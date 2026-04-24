import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:waxxapp/ApiService/offer/offer_service.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/database.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';

/// Bottom sheet for a buyer to propose an offer on a static listing. Shows
/// the listed price, current minimum offer (if seller set one), accepts an
/// amount + optional short message, and calls the backend.
class MakeOfferSheet extends StatefulWidget {
  const MakeOfferSheet({
    super.key,
    required this.productId,
    required this.productName,
    required this.listedPrice,
    this.minimumOfferPrice = 0,
  });

  final String productId;
  final String productName;
  final num listedPrice;
  final num minimumOfferPrice;

  static Future<void> show(
    BuildContext context, {
    required String productId,
    required String productName,
    required num listedPrice,
    num minimumOfferPrice = 0,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) => MakeOfferSheet(
        productId: productId,
        productName: productName,
        listedPrice: listedPrice,
        minimumOfferPrice: minimumOfferPrice,
      ),
    );
  }

  @override
  State<MakeOfferSheet> createState() => _MakeOfferSheetState();
}

class _MakeOfferSheetState extends State<MakeOfferSheet> {
  final _amountCtl = TextEditingController();
  final _messageCtl = TextEditingController();
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _amountCtl.dispose();
    _messageCtl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final raw = _amountCtl.text.trim();
    final amount = num.tryParse(raw);
    if (amount == null || amount <= 0) {
      setState(() => _error = 'Enter a valid amount.');
      return;
    }
    if (widget.minimumOfferPrice > 0 && amount < widget.minimumOfferPrice) {
      setState(() => _error = 'Minimum offer is $currencySymbol${widget.minimumOfferPrice}.');
      return;
    }
    if (amount >= widget.listedPrice) {
      setState(() => _error = 'Offer should be below the listed price — otherwise just Buy Now.');
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
    });

    final result = await OfferService.createOffer(
      productId: widget.productId,
      buyerId: Database.loginUserId,
      offerAmount: amount,
      buyerMessage: _messageCtl.text.trim(),
    );

    if (!mounted) return;
    setState(() => _submitting = false);

    if (result.ok) {
      Navigator.of(context).pop();
      Get.snackbar(
        'Offer sent',
        'The seller will respond soon.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      setState(() => _error = result.message.isNotEmpty ? result.message : 'Something went wrong.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
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
          Text('Make an offer', style: AppFontStyle.styleW700(AppColors.white, 18)),
          const SizedBox(height: 4),
          Text(
            widget.productName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppFontStyle.styleW500(AppColors.unselected, 13),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _chip('Listed $currencySymbol${widget.listedPrice}'),
              if (widget.minimumOfferPrice > 0) ...[
                const SizedBox(width: 8),
                _chip('Min $currencySymbol${widget.minimumOfferPrice}'),
              ],
            ],
          ),
          const SizedBox(height: 20),
          Text('Your offer', style: AppFontStyle.styleW600(AppColors.white, 13)),
          const SizedBox(height: 8),
          TextField(
            controller: _amountCtl,
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
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _messageCtl,
            maxLength: 200,
            maxLines: 2,
            style: AppFontStyle.styleW500(AppColors.white, 13),
            decoration: InputDecoration(
              hintText: 'Add a note (optional)',
              hintStyle: AppFontStyle.styleW500(AppColors.unselected, 13),
              counterStyle: AppFontStyle.styleW500(AppColors.unselected, 10),
              filled: true,
              fillColor: Colors.white10,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                backgroundColor: AppColors.primary,
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
                  : Text('Send offer', style: AppFontStyle.styleW700(AppColors.black, 14)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(text, style: AppFontStyle.styleW600(AppColors.white, 11)),
      );
}

import 'package:era_shop/custom/main_button_widget.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_asset.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../controller/fake_live_controller.dart';

class FakeCustomBidBottomSheet extends StatefulWidget {
  final SimulatedAuctionController controller;
  final double? initialIncrement;

  const FakeCustomBidBottomSheet({
    super.key,
    required this.controller,
    this.initialIncrement,
  });

  @override
  State<FakeCustomBidBottomSheet> createState() => _FakeCustomBidBottomSheetState();
}

class _FakeCustomBidBottomSheetState extends State<FakeCustomBidBottomSheet> {
  late final TextEditingController _tc;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _valid = false;
  String? _errorText;

  num get _current => widget.controller.currentHighestBid;

  @override
  void initState() {
    super.initState();
    // _tc = TextEditingController(text: _start.toStringAsFixed(0));
    _tc = TextEditingController();
    // _validate(_tc.text);
    _tc.addListener(() => _validate(_tc.text));
  }

  @override
  void dispose() {
    _tc.removeListener(() {});
    _tc.dispose();
    super.dispose();
  }

  void _validate(String value) {
    final cleanedValue = value.replaceAll(',', '');
    final parsedValue = double.tryParse(cleanedValue);

    if (cleanedValue.isEmpty) {
      setState(() {
        _valid = false;
        _errorText = St.pleaseEnterBidAmount.tr;
      });
      return;
    }

    if (parsedValue == null) {
      setState(() {
        _valid = false;
        _errorText = St.pleaseEnterAValidNumber.tr;
      });
      return;
    }

    if (parsedValue <= _current) {
      setState(() {
        _valid = false;
        _errorText = St.bidAmountMustBeHigherThanCurrentPrice.tr;
      });
      return;
    }

    setState(() {
      _valid = true;
      _errorText = null;
    });
  }

  void _place() {
    if (!_valid) return;
    final v = double.parse(_tc.text.replaceAll(',', ''));
    widget.controller.placeCustomBid(v);
    Get.back();
  }

  String? _validator(String? value) {
    if (value == null || value.isEmpty) {
      return St.pleaseEnterBidAmount.tr;
    }

    final cleanedValue = value.replaceAll(',', '');
    double? bidAmount = double.tryParse(cleanedValue);

    if (bidAmount == null) {
      return St.pleaseEnterAValidNumber.tr;
    }

    if (bidAmount <= _current) {
      return St.bidAmountMustBeHigherThanCurrentPrice.tr;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                St.placeCustomBid.tr,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () => Get.back(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    AppAsset.icClose,
                    height: 16,
                    color: AppColors.unselected,
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 1,
            color: AppColors.unselected.withValues(alpha: .5),
            margin: EdgeInsets.symmetric(vertical: 16),
          ),
          8.height,
          Container(
            width: Get.width,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.tabBackground.withValues(alpha: .8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Lottie.asset(
                  AppAsset.trendingAnimation,
                  fit: BoxFit.cover,
                  height: 30,
                  width: 25,
                ),
                10.width,
                Text(
                  St.currentHighestBid.tr,
                  style: AppFontStyle.styleW600(AppColors.white, 14),
                ),
                Spacer(),
                Text(
                  "$currencySymbol${_current.toStringAsFixed(0)}",
                  style: AppFontStyle.styleW900(AppColors.primary, 16),
                ),
              ],
            ),
          ),
          14.height,
          Form(
            key: formKey,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _errorText != null ? AppColors.red : AppColors.white.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "$currencySymbol",
                        style: AppFontStyle.styleW700(AppColors.primary, 16),
                      ),
                      10.width,
                      Expanded(
                        child: TextFormField(
                          controller: _tc,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                          ],
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                          decoration: InputDecoration(
                            hintText: 'Enter your amount',
                            hintStyle: TextStyle(color: Colors.white54, fontWeight: FontWeight.w500),
                            border: InputBorder.none,
                            errorStyle: TextStyle(height: 0, fontSize: 0), // Hide default error
                          ),
                          validator: _validator,
                          onChanged: (value) {
                            _validate(value);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                if (_errorText != null) ...[
                  8.height,
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      _errorText!,
                      style: TextStyle(color: AppColors.red, fontSize: 12),
                    ),
                  ),
                ],
              ],
            ),
          ),
          12.height,
          // // Quick increment buttons
          // Row(
          //   children: [
          //     _incChip('+$currencySymbol${10}', () => _applyIncrement(10)),
          //     const SizedBox(width: 8),
          //     _incChip('+$currencySymbol${20}', () => _applyIncrement(20)),
          //     const SizedBox(width: 8),
          //     _incChip('+$currencySymbol${50}', () => _applyIncrement(50)),
          //     const Spacer(),
          //     IconButton(
          //       onPressed: () {
          //         _tc.text = _start.toStringAsFixed(0);
          //         _validate(_tc.text);
          //       },
          //       icon: Icon(Icons.refresh, color: Colors.white60),
          //       tooltip: 'Reset to suggested',
          //     ),
          //   ],
          // ),
          16.height,
          // Action buttons
          Row(
            children: [
              Expanded(
                child: MainButtonWidget(
                  height: 50,
                  width: Get.width,
                  color: AppColors.red,
                  callback: () => Get.back(),
                  child: Text(
                    St.cancelText.tr,
                    style: AppFontStyle.styleW700(AppColors.white, 16),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MainButtonWidget(
                  height: 50,
                  width: Get.width,
                  color: _valid ? AppColors.primary : AppColors.unselected.withValues(alpha: 0.3),
                  callback: _valid ? _place : null,
                  child: Text(
                    St.placeBid.tr,
                    style: AppFontStyle.styleW700(_valid ? AppColors.black : AppColors.unselected, 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

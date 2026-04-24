import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:waxxapp/utils/api_url.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/database.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';

/// Buyer's "settle up" queue. Lists every unpaid bundle Order grouped per
/// seller with aggregate totals, so a viewer who won 4 items across a show
/// can finish checkout once. Uses the existing /order/ordersOfUser endpoint
/// filtered client-side to pending-payment statuses.
class PendingWinsScreen extends StatefulWidget {
  const PendingWinsScreen({super.key});

  @override
  State<PendingWinsScreen> createState() => _PendingWinsScreenState();
}

class _PendingWinsScreenState extends State<PendingWinsScreen> {
  List<_BundleOrder> _bundles = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);

    final url = Uri.parse("${Api.baseUrl}${Api.myOrdersList}").replace(queryParameters: {
      'userId': Database.loginUserId,
      'start': '1',
      'limit': '50',
      'status': 'All',
    });

    try {
      final resp = await http.get(url, headers: {'key': Api.secretKey});
      if (resp.statusCode != 200) {
        setState(() {
          _bundles = const [];
          _loading = false;
        });
        return;
      }
      final data = jsonDecode(resp.body);
      final orders = (data['orderData'] as List? ?? const []);
      final bundles = <_BundleOrder>[];
      for (final raw in orders) {
        final o = Map<String, dynamic>.from(raw);
        final items = (o['items'] as List? ?? const [])
            .map((e) => Map<String, dynamic>.from(e))
            .where((it) => _isPendingPayment(it['status']?.toString()))
            .toList();
        if (items.isEmpty) continue;
        bundles.add(_BundleOrder.fromJson(o, items));
      }
      setState(() {
        _bundles = bundles;
        _loading = false;
      });
    } catch (e) {
      log('PendingWins load error: $e');
      setState(() {
        _bundles = const [];
        _loading = false;
      });
    }
  }

  bool _isPendingPayment(String? status) =>
      status == 'Bundle Pending Payment' ||
      status == 'Auction Pending Payment' ||
      status == 'Manual Auction Pending Payment';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Pending Wins', style: AppFontStyle.styleW700(AppColors.white, 16)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _bundles.isEmpty
              ? Center(
                  child: Text(
                    'No unpaid wins. Win an auction or get an offer accepted to see it here.',
                    textAlign: TextAlign.center,
                    style: AppFontStyle.styleW500(AppColors.unselected, 13),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: _bundles.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) => _BundleCard(bundle: _bundles[i]),
                  ),
                ),
    );
  }
}

class _BundleCard extends StatelessWidget {
  final _BundleOrder bundle;
  const _BundleCard({required this.bundle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.tabBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  bundle.sellerName.isNotEmpty ? bundle.sellerName : 'Seller',
                  style: AppFontStyle.styleW700(AppColors.white, 14),
                ),
              ),
              Text(
                '${bundle.items.length} item${bundle.items.length == 1 ? '' : 's'}',
                style: AppFontStyle.styleW500(AppColors.unselected, 11),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...bundle.items.map((it) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        width: 48,
                        height: 48,
                        child: it.image.isNotEmpty
                            ? CachedNetworkImage(imageUrl: it.image, fit: BoxFit.cover)
                            : Container(color: Colors.white10),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        it.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppFontStyle.styleW600(AppColors.white, 12),
                      ),
                    ),
                    Text(
                      '$currencySymbol${it.price}',
                      style: AppFontStyle.styleW700(AppColors.primary, 12),
                    ),
                  ],
                ),
              )),
          const Divider(color: Colors.white12, height: 14),
          _totalsRow('Subtotal', '$currencySymbol${bundle.subTotal}'),
          _totalsRow('Shipping (combined)', '$currencySymbol${bundle.shipping}'),
          _totalsRow('Total', '$currencySymbol${bundle.total}', bold: true),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.toNamed(
                "/OrderDetail",
                arguments: {'orderId': bundle.orderId},
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text('Settle up', style: AppFontStyle.styleW700(AppColors.black, 13)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _totalsRow(String label, String value, {bool bold = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppFontStyle.styleW500(
                bold ? AppColors.white : AppColors.unselected,
                12,
              ),
            ),
            Text(
              value,
              style: bold
                  ? AppFontStyle.styleW700(AppColors.white, 13)
                  : AppFontStyle.styleW500(AppColors.white, 12),
            ),
          ],
        ),
      );
}

class _BundleItemRow {
  final String name;
  final String image;
  final num price;
  _BundleItemRow({required this.name, required this.image, required this.price});
}

class _BundleOrder {
  final String orderId;
  final String sellerName;
  final List<_BundleItemRow> items;
  final num subTotal;
  final num shipping;
  final num total;

  const _BundleOrder({
    required this.orderId,
    required this.sellerName,
    required this.items,
    required this.subTotal,
    required this.shipping,
    required this.total,
  });

  factory _BundleOrder.fromJson(Map<String, dynamic> o, List<Map<String, dynamic>> pendingItems) {
    // Attempt to pull the first item's populated seller for the card label.
    String sellerName = '';
    final firstItem = pendingItems.isNotEmpty ? pendingItems.first : null;
    if (firstItem != null && firstItem['sellerId'] is Map) {
      final s = Map<String, dynamic>.from(firstItem['sellerId']);
      sellerName = (s['businessName']?.toString() ?? '').trim();
      if (sellerName.isEmpty) {
        sellerName = '${s['firstName'] ?? ''} ${s['lastName'] ?? ''}'.trim();
      }
    }

    return _BundleOrder(
      orderId: o['_id']?.toString() ?? '',
      sellerName: sellerName,
      items: pendingItems.map((it) {
        final pid = it['productId'];
        final prod = pid is Map ? Map<String, dynamic>.from(pid) : null;
        return _BundleItemRow(
          name: prod?['productName']?.toString() ?? '',
          image: prod?['mainImage']?.toString() ?? '',
          price: (it['purchasedTimeProductPrice'] as num?) ?? 0,
        );
      }).toList(),
      subTotal: (o['subTotal'] as num?) ?? 0,
      shipping: (o['totalShippingCharges'] as num?) ?? 0,
      total: (o['finalTotal'] as num?) ?? 0,
    );
  }
}

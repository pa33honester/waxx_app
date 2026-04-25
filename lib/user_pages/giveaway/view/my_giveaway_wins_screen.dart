import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waxxapp/ApiModel/giveaway/giveaway_model.dart';
import 'package:waxxapp/ApiService/user/giveaway_service.dart';
import 'package:waxxapp/utils/api_url.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/database.dart';
import 'package:waxxapp/utils/font_style.dart';

/// Buyer-side list of giveaways this user has won. Themed to match the rest
/// of the app's dark surfaces (MyOffers, PendingWins) — earlier revision
/// inherited a light Material theme that made text invisible on the dark
/// background.
class MyGiveawayWinsScreen extends StatefulWidget {
  const MyGiveawayWinsScreen({super.key});

  @override
  State<MyGiveawayWinsScreen> createState() => _MyGiveawayWinsScreenState();
}

class _MyGiveawayWinsScreenState extends State<MyGiveawayWinsScreen> {
  final UserGiveawayService _service = UserGiveawayService();
  late Future<List<GiveawayModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.fetchMyWins(userId: Database.loginUserId);
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _service.fetchMyWins(userId: Database.loginUserId);
    });
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        surfaceTintColor: AppColors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text('Giveaway Wins', style: AppFontStyle.styleW700(AppColors.white, 16)),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<GiveawayModel>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            final wins = snapshot.data ?? [];
            if (wins.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
                children: [
                  Icon(Icons.card_giftcard, size: 64, color: AppColors.unselected),
                  const SizedBox(height: 12),
                  Text(
                    'No giveaway wins yet',
                    textAlign: TextAlign.center,
                    style: AppFontStyle.styleW700(AppColors.white, 15),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Enter live giveaways to land here.',
                    textAlign: TextAlign.center,
                    style: AppFontStyle.styleW500(AppColors.unselected, 12),
                  ),
                ],
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemBuilder: (ctx, idx) => _GiveawayWinTile(model: wins[idx]),
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemCount: wins.length,
            );
          },
        ),
      ),
    );
  }
}

class _GiveawayWinTile extends StatelessWidget {
  final GiveawayModel model;
  const _GiveawayWinTile({required this.model});

  String? get _imageUrl {
    if (model.mainImage.isEmpty) return null;
    if (model.mainImage.startsWith('http')) return model.mainImage;
    return '${Api.baseUrl}storage/${model.mainImage}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.tabBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 56,
              height: 56,
              child: _imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: _imageUrl!,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(color: Colors.white12),
                    )
                  : Container(color: Colors.white12),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  model.productName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppFontStyle.styleW700(AppColors.white, 13),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.emoji_events_rounded, size: 14, color: Color(0xFF4ADE80)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        model.winnerDrawnAt != null
                            ? 'Won ${model.winnerDrawnAt!.toLocal().toString().split('.').first}'
                            : 'Won',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppFontStyle.styleW500(AppColors.unselected, 11),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (model.orderId != null)
            TextButton(
              onPressed: () => Get.toNamed('/MyOrder'),
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
              child: Text('View', style: AppFontStyle.styleW700(AppColors.primary, 12)),
            ),
        ],
      ),
    );
  }
}

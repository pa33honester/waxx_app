import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waxxapp/ApiModel/giveaway/giveaway_model.dart';
import 'package:waxxapp/ApiService/user/giveaway_service.dart';
import 'package:waxxapp/utils/api_url.dart';
import 'package:waxxapp/utils/database.dart';

/// Buyer-side list of giveaways this user has won.
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
      appBar: AppBar(title: const Text('Giveaway Wins')),
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
                children: const [
                  SizedBox(height: 120),
                  Icon(Icons.card_giftcard, size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Center(child: Text('No giveaway wins yet')),
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            if (_imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  _imageUrl!,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox(width: 56, height: 56),
                ),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(model.productName, style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(
                    model.winnerDrawnAt != null
                        ? 'Won ${model.winnerDrawnAt!.toLocal().toString().split('.').first}'
                        : 'Won',
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
            if (model.orderId != null)
              TextButton(
                onPressed: () => Get.toNamed('/MyOrder'),
                child: const Text('View'),
              ),
          ],
        ),
      ),
    );
  }
}

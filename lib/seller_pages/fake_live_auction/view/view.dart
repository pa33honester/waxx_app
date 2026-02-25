// // lib/seller_pages/fake_live/video/simulated_live_screen.dart
// import 'package:chewie/chewie.dart';
// import 'package:era_shop/seller_pages/fake_live_auction/view/controller/fake_live_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import 'dart:convert';
// import 'dart:ui';
// import 'package:blurrycontainer/blurrycontainer.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:era_shop/seller_pages/live_page/widget/flip_profile_animation_widget.dart';
// import 'package:era_shop/seller_pages/select_product_for_streame/model/selected_product_model.dart';
// import 'package:era_shop/utils/app_colors.dart';
// import 'package:era_shop/utils/app_asset.dart';
// import 'package:era_shop/utils/font_style.dart';
// import 'package:era_shop/utils/globle_veriables.dart';
// import 'package:era_shop/utils/socket_services.dart';
//
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
//
// class SimulatedLiveScreen extends StatefulWidget {
//   const SimulatedLiveScreen({
//     super.key,
//     required this.videoUrlOrAsset,
//     this.isAsset = false,
//     this.autoplay = true,
//     this.loop = true,
//     this.fallbackImage,
//   });
//
//   final String videoUrlOrAsset;
//   final bool isAsset;
//   final bool autoplay;
//   final bool loop;
//   final String? fallbackImage;
//
//   @override
//   State<SimulatedLiveScreen> createState() => _SimulatedLiveScreenState();
// }
//
// class _SimulatedLiveScreenState extends State<SimulatedLiveScreen> {
//   VideoPlayerController? _controller;
//   bool _failed = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initPlayer();
//   }
//
//   Future<void> _initPlayer() async {
//     try {
//       final c = widget.isAsset ? VideoPlayerController.asset(widget.videoUrlOrAsset) : VideoPlayerController.networkUrl(Uri.parse(widget.videoUrlOrAsset));
//       _controller = c;
//       await c.initialize();
//       if (widget.loop) c.setLooping(true);
//       await c.play();
//       if (mounted) setState(() {});
//     } catch (_) {
//       setState(() => _failed = true);
//     }
//   }
//
//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_failed) {
//       // Fallback: show an image or a gradient instead of black.
//       if (widget.fallbackImage != null) {
//         return Image.network(widget.fallbackImage!, fit: BoxFit.cover, width: double.infinity, height: double.infinity);
//       }
//       return Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFF1f1f1f), Color(0xFF0d0d0d)],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//       );
//     }
//
//     if (_controller == null || !_controller!.value.isInitialized) {
//       // While loading, show a neutral background (not black)
//       return Container(color: const Color(0xFF101010));
//     }
//
//     return FittedBox(
//       fit: BoxFit.cover,
//       clipBehavior: Clip.hardEdge,
//       child: SizedBox(
//         width: _controller!.value.size.width,
//         height: _controller!.value.size.height,
//         child: VideoPlayer(_controller!),
//       ),
//     );
//   }
// }
//
// // lib/seller_pages/fake_live/fake_live_ui.dart
//
// class FakeLiveUi extends StatelessWidget {
//   const FakeLiveUi({
//     super.key,
//     required this.controller,
//     required this.videoUrl,
//   });
//
//   final SimulatedAuctionController controller;
//   final String videoUrl;
//
//   @override
//   Widget build(BuildContext context) {
//     // start the show once widget is on tree
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       controller.startSimulatedShow();
//     });
//     final ctrl = Get.put(SimulatedAuctionController()); // same IDs used by LiveUi
//
//     return Scaffold(
//       body: Stack(
//         children: [
//           // 1) VIDEO BACKGROUND
//           Positioned.fill(
//             child: SimulatedLiveScreen(
//               videoUrlOrAsset: videoUrl,
//               isAsset: false,
//               autoplay: true,
//               loop: true,
//             ),
//           ),
//
//           // 2) GRADIENT OVERLAY (bottom)
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: IgnorePointer(
//               child: Container(
//                 height: 380,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.transparent, Colors.black.withOpacity(0.9)],
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//
//           // 3) TOP BAR (simple, fake)
//           Positioned(
//             top: Get.mediaQuery.padding.top + 12,
//             left: 16,
//             right: 16,
//             child: Row(
//               children: [
//                 _pill(icon: AppAsset.icEye, text: "1,2K"),
//                 const Spacer(),
//                 _pill(icon: AppAsset.icClock, child: _ElapsedTimer()),
//                 const SizedBox(width: 8),
//                 _roundIcon(AppAsset.icClose, onTap: () => Get.back()),
//               ],
//             ),
//           ),
//
//           // 4) CHAT + INPUT + PRODUCT
//           Positioned(
//             left: 12,
//             right: 12,
//             bottom: 14,
//             child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               _ChatList(ctrl: ctrl),
//               const SizedBox(height: 6),
//               _BidderBadge(ctrl: ctrl),
//               const SizedBox(height: 6),
//               Center(child: _ProductCard(ctrl: ctrl)),
//               const SizedBox(height: 8),
//               _BidButtons(ctrl: ctrl),
//               const SizedBox(height: 8),
//               _CommentInput(ctrl: ctrl),
//             ]),
//           ),
//
//           // 5) WINNER OVERLAY
//           GetBuilder<SimulatedAuctionController>(
//             id: "auctionWinner",
//             builder: (logic) => Positioned(
//               top: 160,
//               left: 0,
//               right: 0,
//               child: Visibility(
//                 visible: logic.isShowAnimationWinner,
//                 child: Center(
//                   child: FlipProfileAnimationWidget(
//                     name: logic.auctionWinnerName,
//                     imageUrl: logic.auctionWinnerImage,
//                     message: 'Won the auction!',
//                     onFlipCompleted: logic.onWinnerAnimationCompleted,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//
//           // 6) “Pay Now” SLIDER
//           _WinnerPayNow(
//             ctrl: ctrl,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _pill({required String icon, String? text, Widget? child}) {
//     return Container(
//       height: 32,
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       decoration: BoxDecoration(
//         color: Colors.black.withOpacity(0.45),
//         borderRadius: BorderRadius.circular(100),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Image.asset(icon, width: 18, color: Colors.white),
//           const SizedBox(width: 6),
//           if (child != null) child,
//           if (text != null) Text(text, style: AppFontStyle.styleW700(Colors.white, 12)),
//         ],
//       ),
//     );
//   }
//
//   Widget _roundIcon(String icon, {VoidCallback? onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         height: 36,
//         width: 36,
//         decoration: BoxDecoration(
//           color: Colors.black.withOpacity(0.45),
//           shape: BoxShape.circle,
//         ),
//         child: Center(child: Image.asset(icon, width: 18, color: Colors.white)),
//       ),
//     );
//   }
// }
//
// /// elapsed timer (reuses controller.countTime)
// class _ElapsedTimer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<SimulatedAuctionController>(
//       id: "onChangeTime",
//       builder: (c) => Text(
//         c.onConvertSecondToHMS(c.countTime),
//         style: AppFontStyle.styleW600(Colors.white, 12),
//       ),
//     );
//   }
// }
//
// /*/// chat list (uses SocketServices.mainLiveComments)
// class _ChatList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 180,
//       width: Get.width * 0.6,
//       child: Obx(
//         () => SingleChildScrollView(
//           controller: SocketServices.scrollController,
//           child: ListView.builder(
//             itemCount: SocketServices.mainLiveComments.length,
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             padding: EdgeInsets.zero,
//             itemBuilder: (context, index) {
//               final raw = SocketServices.mainLiveComments[index];
//               Map<String, dynamic> data;
//               try {
//                 data = raw is String ? json.decode(raw) : (raw as Map<String, dynamic>);
//               } catch (_) {
//                 return const SizedBox.shrink();
//               }
//               return _ChatItem(
//                 name: data["userName"] ?? "User",
//                 text: data["commentText"] ?? data["comment"] ?? "",
//                 image: data["userImage"] ?? "",
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _ChatItem extends StatelessWidget {
//   const _ChatItem({required this.name, required this.text, required this.image});
//   final String name, text, image;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipOval(
//             child: CachedNetworkImage(
//               imageUrl: image,
//               width: 32,
//               height: 32,
//               fit: BoxFit.cover,
//               errorWidget: (_, __, ___) => const CircleAvatar(radius: 16),
//             ),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: RichText(
//               text: TextSpan(
//                 children: [
//                   TextSpan(text: "$name  ", style: AppFontStyle.styleW600(Colors.white, 12)),
//                   TextSpan(text: text, style: AppFontStyle.styleW500(Colors.white, 13)),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// /// shows current highest bidder
// class _BidderBadge extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<SimulatedAuctionController>(
//       id: "idAuctionProductView",
//       builder: (c) => Visibility(
//         visible: c.isAuctionActive && c.currentHighestBidderName.trim().isNotEmpty,
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//           decoration: BoxDecoration(
//             color: Colors.black.withOpacity(0.35),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ClipOval(
//                 child: CachedNetworkImage(
//                   imageUrl: c.currentHighestBidderImage,
//                   width: 22,
//                   height: 22,
//                   fit: BoxFit.cover,
//                   errorWidget: (_, __, ___) => const CircleAvatar(radius: 11),
//                 ),
//               ),
//               const SizedBox(width: 6),
//               Text(c.currentHighestBidderName, style: AppFontStyle.styleW600(Colors.white, 12)),
//               const SizedBox(width: 6),
//               Text("Winning", style: AppFontStyle.styleW600(AppColors.primary, 11)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// /// the product/timer/bid card
// class _ProductCard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<SimulatedAuctionController>(
//       id: "idAuctionProductView",
//       builder: (c) {
//         if (c.areAllProductsAuctioned) {
//           return _doneCard();
//         }
//
//         if (c.isAuctionActive) {
//           return _activeAuction(c);
//         }
//
//         if (c.lastAuctionedProduct != null) {
//           return _lastItem(c.lastAuctionedProduct!);
//         }
//
//         return _waiting();
//       },
//     );
//   }
//
//   Widget _waiting() => _glass(
//         child: Column(
//           children: [
//             const Icon(Icons.access_time, size: 30, color: Colors.white),
//             const SizedBox(height: 6),
//             Text("Waiting for Next Auction...", style: AppFontStyle.styleW700(Colors.white, 16)),
//             Text("Stay tuned!", style: AppFontStyle.styleW500(Colors.white70, 13)),
//           ],
//         ),
//       );
//
//   Widget _doneCard() => _glass(
//         child: Column(
//           children: [
//             const Icon(Icons.celebration, size: 36, color: Colors.white),
//             const SizedBox(height: 6),
//             Text("All Auctions Complete!", style: AppFontStyle.styleW700(Colors.white, 16)),
//             Text("Thanks for watching.", style: AppFontStyle.styleW500(Colors.white70, 13)),
//           ],
//         ),
//       );
//
//   Widget _activeAuction(SimulatedAuctionController c) => _glass(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _livePill(),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 _thumb(c.currentAuctionProductImage),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(c.currentAuctionProductName, maxLines: 2, overflow: TextOverflow.ellipsis, style: AppFontStyle.styleW700(Colors.white, 14)),
//                       const SizedBox(height: 6),
//                       _attrs(c.currentAuctionProductAttributes),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Column(
//                   children: [
//                     Text("BIDDING", style: AppFontStyle.styleW600(AppColors.primary, 12)),
//                     const SizedBox(height: 4),
//                     GetBuilder<SimulatedAuctionController>(
//                       id: "auctionTimer",
//                       builder: (ctl) {
//                         final t = ctl.auctionRemainingTime;
//                         final warn = t <= 10 ? Colors.red : AppColors.colorClosedGreen;
//                         return Text(ctl.formatAuctionTime(t), style: AppFontStyle.styleW700(warn, 12));
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 Text("BID $currencySymbol${c.currentHighestBid}", style: AppFontStyle.styleW700(AppColors.primary, 16)),
//               ],
//             ),
//           ],
//         ),
//       );
//
//   Widget _lastItem(SelectedProduct p) => _glass(
//         child: Row(
//           children: [
//             _thumb(p.mainImage ?? ""),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Text(p.productName ?? "", maxLines: 2, overflow: TextOverflow.ellipsis, style: AppFontStyle.styleW700(Colors.white, 14)),
//             ),
//             const SizedBox(width: 10),
//             Text("Last Item", style: AppFontStyle.styleW600(Colors.white, 12)),
//           ],
//         ),
//       );
//
//   Widget _livePill() => Container(
//         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//         decoration: BoxDecoration(color: Colors.red.withOpacity(0.85), borderRadius: BorderRadius.circular(12)),
//         child: Row(mainAxisSize: MainAxisSize.min, children: [
//           Container(width: 7, height: 7, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
//           const SizedBox(width: 6),
//           Text("LIVE AUCTION", style: AppFontStyle.styleW600(Colors.white, 12)),
//         ]),
//       );
//
//   Widget _thumb(String url) => ClipRRect(
//         borderRadius: BorderRadius.circular(10),
//         child: CachedNetworkImage(
//           imageUrl: url,
//           width: 58,
//           height: 58,
//           fit: BoxFit.cover,
//           placeholder: (_, __) => const SizedBox(
//             width: 58,
//             height: 58,
//             child: CupertinoActivityIndicator(),
//           ),
//           errorWidget: (_, __, ___) => Container(width: 58, height: 58, color: Colors.white10),
//         ),
//       );
//
//   Widget _attrs(List<ProductAttribute>? attrs) {
//     if (attrs == null || attrs.isEmpty) return const SizedBox.shrink();
//     return Wrap(
//       spacing: 4,
//       runSpacing: 4,
//       children: attrs
//           .take(2)
//           .map((a) => Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                 decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(4)),
//                 child: Text("${a.name}: ${a.values.join(", ")}", style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
//               ))
//           .toList(),
//     );
//   }
//
//   Widget _glass({required Widget child}) => BlurryContainer(
//         color: Colors.white.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//         blur: 2,
//         padding: const EdgeInsets.all(10),
//         child: child,
//       );
// }
//
// /// bottom “Custom” & “Quick Bid” buttons
// class _BidButtons extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<SimulatedAuctionController>(
//       id: "idUserPlaceBid",
//       builder: (c) => Visibility(
//         visible: c.isAuctionActive,
//         child: Row(
//           children: [
//             Expanded(
//               child: _chipButton("Custom", onTap: () {
//                 // example: place a custom bid +10
//                 final custom = (c.currentHighestBid + 10).toDouble();
//                 c.placeCustomBid(custom);
//               }),
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: _chipButton("BID $currencySymbol${(c.currentHighestBid + c.defaultAuctionPlusBid).toString()}", filled: true, onTap: c.placeBid),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _chipButton(String text, {bool filled = false, VoidCallback? onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         height: 50,
//         decoration: BoxDecoration(
//           color: filled ? AppColors.primary : Colors.white24,
//           borderRadius: BorderRadius.circular(100),
//         ),
//         child: Center(
//           child: Text(text,
//               style: TextStyle(
//                 color: filled ? Colors.black : Colors.white,
//                 fontWeight: FontWeight.w700,
//                 fontSize: 16,
//               )),
//         ),
//       ),
//     );
//   }
// }
//
// /// winner “Pay Now” slider using controller’s state
// class _WinnerPayNow extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<SimulatedAuctionController>(
//       id: "isShowWinnerUserPayment",
//       builder: (c) {
//         if (!c.isShowWinnerUserPayment) return const SizedBox.shrink();
//         return AnimatedPositioned(
//           duration: const Duration(milliseconds: 900),
//           curve: Curves.easeInOut,
//           right: c.winnerUserPaymentPosition.toDouble(),
//           top: Get.height * 0.2,
//           child: Container(
//             height: 74,
//             width: Get.width * 0.75,
//             padding: const EdgeInsets.all(6),
//             decoration: BoxDecoration(
//               color: Colors.black54,
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(100),
//                 bottomLeft: Radius.circular(100),
//               ),
//               border: Border.all(color: Colors.white70, width: 1.2),
//             ),
//             child: Row(
//               children: [
//                 const SizedBox(width: 6),
//                 CircleAvatar(
//                   radius: 28,
//                   backgroundImage: NetworkImage(c.winnerUserPaymentProductImage),
//                   onBackgroundImageError: (_, __) {},
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(c.winnerUserPaymentProductName, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppFontStyle.styleW700(Colors.white, 14)),
//                       const SizedBox(height: 4),
//                       Text("YOU WINNING BID!", style: AppFontStyle.styleW600(AppColors.primary, 11)),
//                       const SizedBox(height: 4),
//                       Row(
//                         children: [
//                           Image.asset(AppAsset.icClock, height: 14, color: Colors.white),
//                           const SizedBox(width: 6),
//                           Text(c.winnerUserPaymentRemainingTime, style: AppFontStyle.styleW600(Colors.white, 11)),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 GestureDetector(
//                   onTap: c.OnClickUserPayNow,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                     decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(18)),
//                     child: Text("Pay Now", style: AppFontStyle.styleW700(Colors.black, 12)),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
// // lib/seller_pages/fake_live/fake_auction_page.dart
// */
// class FakeAuctionPage extends StatefulWidget {
//   const FakeAuctionPage({super.key});
//
//   @override
//   State<FakeAuctionPage> createState() => _FakeAuctionPageState();
// }
//
// class _FakeAuctionPageState extends State<FakeAuctionPage> {
//   late final SimulatedAuctionController ctrl;
//
//   @override
//   void initState() {
//     super.initState();
//     ctrl = Get.put(SimulatedAuctionController());
//
//     // seed local data
//     ctrl.sellerId = "SIM-SELLER";
//     ctrl.roomId = "SIM-ROOM";
//     ctrl.liveType = 2; // auction mode
//     ctrl.isHost = false;
//
//     ctrl.liveSelectedProducts = [
//       SelectedProduct(
//         productId: "p1",
//         productName: "Leather Crossbody Bag",
//         price: 1999,
//         minimumBidPrice: 999,
//         minAuctionTime: 45,
//         mainImage: "https://picsum.photos/seed/bag/600/600",
//         productAttributes: [
//           ProductAttribute(name: "Color", values: ["Tan"]),
//           ProductAttribute(name: "Material", values: ["Leather"]),
//         ],
//       ),
//       SelectedProduct(
//         productId: "p2",
//         productName: "Analog Wrist Watch",
//         price: 2499,
//         minimumBidPrice: 1199,
//         minAuctionTime: 50,
//         mainImage: "https://picsum.photos/seed/watch/600/600",
//         productAttributes: [
//           ProductAttribute(name: "Color", values: ["Black"]),
//           ProductAttribute(name: "Dial", values: ["42mm"]),
//         ],
//       ),
//     ];
//
//     // start after first frame
//     WidgetsBinding.instance.addPostFrameCallback((_) => ctrl.startSimulatedShow());
//   }
//
//   @override
//   void dispose() {
//     if (Get.isRegistered<SimulatedAuctionController>()) {
//       Get.delete<SimulatedAuctionController>();
//     }
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(children: [
//         // background video with fallback image (prevents pure black)
//         const Positioned.fill(
//           child: SimulatedLiveScreen(
//             videoUrlOrAsset: "https://shortie.codderlab.com/uploads/10.mp4",
//             isAsset: false,
//             autoplay: true,
//             loop: true,
//             fallbackImage: "https://images.unsplash.com/photo-1542831371-d531d36971e6?q=80&w=1600",
//           ),
//         ),
//
//         // bottom gradient
//         Positioned(
//           left: 0,
//           right: 0,
//           bottom: 0,
//           child: IgnorePointer(
//             child: Container(
//               height: 340,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Colors.transparent, Colors.black.withOpacity(0.9)],
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                 ),
//               ),
//             ),
//           ),
//         ),
//
//         // top bar
//         Positioned(
//           top: Get.mediaQuery.padding.top + 12,
//           left: 16,
//           right: 16,
//           child: Row(children: [
//             Obx(() => _pill(icon: AppAsset.icEye, text: _fmt(ctrl.localWatchCount.value))),
//             const Spacer(),
//             GetBuilder<SimulatedAuctionController>(
//               id: "onChangeTime",
//               builder: (c) => _pill(icon: AppAsset.icClock, text: c.onConvertSecondToHMS(c.countTime)),
//             ),
//             const SizedBox(width: 8),
//             _roundIcon(AppAsset.icClose, onTap: () => Get.back()),
//           ]),
//         ),
//
//         // chat + product card + buttons + input
//         Positioned(
//           left: 12,
//           right: 12,
//           bottom: 14,
//           child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             _ChatList(ctrl: ctrl),
//             const SizedBox(height: 6),
//             _BidderBadge(ctrl: ctrl),
//             const SizedBox(height: 6),
//             Center(child: _ProductCard(ctrl: ctrl)),
//             const SizedBox(height: 8),
//             _BidButtons(ctrl: ctrl),
//             const SizedBox(height: 8),
//             _CommentInput(ctrl: ctrl),
//           ]),
//         ),
//
//         // winner overlay
//         GetBuilder<SimulatedAuctionController>(
//           id: "auctionWinner",
//           builder: (c) => Positioned(
//             top: 160,
//             left: 0,
//             right: 0,
//             child: Visibility(
//               visible: c.isShowAnimationWinner,
//               child: Center(
//                 child: FlipProfileAnimationWidget(
//                   name: c.auctionWinnerName,
//                   imageUrl: c.auctionWinnerImage,
//                   message: 'Won the auction!',
//                   onFlipCompleted: c.onWinnerAnimationCompleted,
//                 ),
//               ),
//             ),
//           ),
//         ),
//
//         // winner pay-now slider (uses inherited flags)
//         _WinnerPayNow(ctrl: ctrl),
//       ]),
//     );
//   }
//
//   String _fmt(int v) => v >= 1000 ? "${(v / 1000).toStringAsFixed(v % 1000 == 0 ? 0 : 1)}K" : "$v";
//
//   Widget _pill({required String icon, required String text}) => Container(
//         height: 32,
//         padding: const EdgeInsets.symmetric(horizontal: 10),
//         decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(100)),
//         child: Row(mainAxisSize: MainAxisSize.min, children: [
//           Image.asset(icon, width: 18, color: Colors.white),
//           const SizedBox(width: 6),
//           Text(text, style: AppFontStyle.styleW700(Colors.white, 12)),
//         ]),
//       );
//
//   Widget _roundIcon(String icon, {VoidCallback? onTap}) => GestureDetector(
//         onTap: onTap,
//         child: Container(
//           height: 36,
//           width: 36,
//           decoration: const BoxDecoration(color: Colors.black45, shape: BoxShape.circle),
//           child: Center(child: Image.asset(icon, width: 18, color: Colors.white)),
//         ),
//       );
// }
// // ======== UI bits (local only) ========
//
// class _ChatList extends StatelessWidget {
//   const _ChatList({required this.ctrl});
//   final SimulatedAuctionController ctrl;
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final items = ctrl.chat;
//       return SizedBox(
//         height: 180,
//         width: Get.width * 0.6,
//         child: ListView.builder(
//           controller: ctrl.scrollController,
//           itemCount: items.length,
//           padding: EdgeInsets.zero,
//           itemBuilder: (_, i) {
//             final m = items[i];
//             return Container(
//               margin: const EdgeInsets.symmetric(vertical: 8),
//               child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                 ClipOval(
//                   child: CachedNetworkImage(imageUrl: m.userImage, width: 32, height: 32, fit: BoxFit.cover),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                     child: RichText(
//                         text: TextSpan(children: [
//                   TextSpan(text: "${m.userName}  ", style: AppFontStyle.styleW600(Colors.white, 12)),
//                   TextSpan(text: m.text, style: AppFontStyle.styleW500(Colors.white, 13)),
//                 ]))),
//               ]),
//             );
//           },
//         ),
//       );
//     });
//   }
// }
//
// class _BidderBadge extends StatelessWidget {
//   const _BidderBadge({required this.ctrl});
//   final SimulatedAuctionController ctrl;
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<SimulatedAuctionController>(
//       id: "idAuctionProductView",
//       builder: (c) => Visibility(
//         visible: c.isAuctionActive && c.currentHighestBidderName.trim().isNotEmpty,
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//           decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(12)),
//           child: Row(mainAxisSize: MainAxisSize.min, children: [
//             ClipOval(
//               child: CachedNetworkImage(imageUrl: c.currentHighestBidderImage, width: 22, height: 22, fit: BoxFit.cover),
//             ),
//             const SizedBox(width: 6),
//             Text(c.currentHighestBidderName, style: AppFontStyle.styleW600(Colors.white, 12)),
//             const SizedBox(width: 6),
//             Text("Winning", style: AppFontStyle.styleW600(AppColors.primary, 11)),
//           ]),
//         ),
//       ),
//     );
//   }
// }
//
// class _ProductCard extends StatelessWidget {
//   const _ProductCard({required this.ctrl});
//   final SimulatedAuctionController ctrl;
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<SimulatedAuctionController>(
//       id: "idAuctionProductView",
//       builder: (c) {
//         if (c.areAllProductsAuctioned) return _glass(const Text("All Auctions Complete!", style: TextStyle(color: Colors.white)));
//         if (c.isAuctionActive) return _active(c);
//         if (c.lastAuctionedProduct != null) return _last(c.lastAuctionedProduct!);
//         return _glass(const Text("Waiting for Next Auction...", style: TextStyle(color: Colors.white)));
//       },
//     );
//   }
//
//   Widget _active(SimulatedAuctionController c) => _glass(Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             decoration: BoxDecoration(color: Colors.red.withOpacity(0.85), borderRadius: BorderRadius.circular(12)),
//             child: Row(mainAxisSize: MainAxisSize.min, children: const [
//               SizedBox(width: 7, height: 7, child: DecoratedBox(decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle))),
//               SizedBox(width: 6),
//               Text("LIVE AUCTION", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12)),
//             ]),
//           ),
//           const SizedBox(height: 8),
//           Row(children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: CachedNetworkImage(imageUrl: c.currentAuctionProductImage, width: 58, height: 58, fit: BoxFit.cover),
//             ),
//             const SizedBox(width: 10),
//             Expanded(child: Text(c.currentAuctionProductName, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700))),
//             const SizedBox(width: 10),
//             Column(children: [
//               const Text("BIDDING", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w600, fontSize: 12)),
//               const SizedBox(height: 4),
//               GetBuilder<SimulatedAuctionController>(
//                 id: "auctionTimer",
//                 builder: (ctl) {
//                   final t = ctl.auctionRemainingTime;
//                   final color = t <= 10 ? Colors.red : AppColors.colorClosedGreen;
//                   return Text(ctl.formatAuctionTime(t), style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12));
//                 },
//               ),
//             ]),
//           ]),
//           const SizedBox(height: 8),
//           Text("BID $currencySymbol${c.currentHighestBid}", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 16)),
//         ],
//       ));
//
//   Widget _last(SelectedProduct p) => _glass(Row(children: [
//         ClipRRect(
//           borderRadius: BorderRadius.circular(10),
//           child: CachedNetworkImage(imageUrl: p.mainImage ?? "", width: 58, height: 58, fit: BoxFit.cover),
//         ),
//         const SizedBox(width: 10),
//         Expanded(child: Text(p.productName ?? "", maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700))),
//         const SizedBox(width: 10),
//         const Text("Last Item", style: TextStyle(color: Colors.white)),
//       ]));
//
//   Widget _glass(Widget child) => Container(
//         decoration: BoxDecoration(color: Colors.white.withOpacity(0.10), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white24, width: 0.5)),
//         padding: const EdgeInsets.all(10),
//         child: child,
//       );
// }
//
// class _BidButtons extends StatelessWidget {
//   const _BidButtons({required this.ctrl});
//   final SimulatedAuctionController ctrl;
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<SimulatedAuctionController>(
//       id: "idUserPlaceBid",
//       builder: (c) => Visibility(
//         visible: c.isAuctionActive,
//         child: Row(children: [
//           Expanded(
//               child: _chip("Custom", onTap: () {
//             final custom = (c.currentHighestBid + 10).toDouble();
//             c.placeCustomBid(custom);
//           })),
//           const SizedBox(width: 10),
//           Expanded(child: _chip("BID $currencySymbol${(c.currentHighestBid + c.defaultAuctionPlusBid)}", filled: true, onTap: c.placeBid)),
//         ]),
//       ),
//     );
//   }
//
//   Widget _chip(String text, {bool filled = false, VoidCallback? onTap}) => GestureDetector(
//         onTap: onTap,
//         child: Container(
//           height: 50,
//           decoration: BoxDecoration(color: filled ? AppColors.primary : Colors.white24, borderRadius: BorderRadius.circular(100)),
//           child: Center(child: Text(text, style: TextStyle(color: filled ? Colors.black : Colors.white, fontWeight: FontWeight.w700, fontSize: 16))),
//         ),
//       );
// }
//
// class _CommentInput extends StatefulWidget {
//   const _CommentInput({required this.ctrl});
//   final SimulatedAuctionController ctrl;
//
//   @override
//   State<_CommentInput> createState() => _CommentInputState();
// }
//
// class _CommentInputState extends State<_CommentInput> {
//   final _tc = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 48,
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
//       padding: const EdgeInsets.only(left: 14, right: 6),
//       child: Row(children: [
//         Expanded(
//             child: TextField(
//           controller: _tc,
//           maxLines: 1,
//           decoration: const InputDecoration(border: InputBorder.none, hintText: "Type a comment..."),
//         )),
//         GestureDetector(
//           onTap: () {
//             widget.ctrl.sendUserComment(_tc.text);
//             _tc.clear();
//           },
//           child: Container(
//             height: 36,
//             width: 36,
//             decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
//             child: const Icon(Icons.send, size: 18, color: Colors.white),
//           ),
//         ),
//       ]),
//     );
//   }
// }
//
// class _WinnerPayNow extends StatelessWidget {
//   const _WinnerPayNow({required this.ctrl});
//   final SimulatedAuctionController ctrl;
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<SimulatedAuctionController>(
//       id: "isShowWinnerUserPayment",
//       builder: (c) {
//         if (!c.isShowWinnerUserPayment) return const SizedBox.shrink();
//         return AnimatedPositioned(
//           duration: const Duration(milliseconds: 900),
//           curve: Curves.easeInOut,
//           right: c.winnerUserPaymentPosition.toDouble(),
//           top: Get.height * 0.2,
//           child: Container(
//             height: 74,
//             width: Get.width * 0.75,
//             padding: const EdgeInsets.all(6),
//             decoration: BoxDecoration(
//               color: Colors.black54,
//               borderRadius: const BorderRadius.only(topLeft: Radius.circular(100), bottomLeft: Radius.circular(100)),
//               border: Border.all(color: Colors.white70, width: 1.2),
//             ),
//             child: Row(children: [
//               const SizedBox(width: 6),
//               CircleAvatar(radius: 28, backgroundImage: NetworkImage(c.winnerUserPaymentProductImage)),
//               const SizedBox(width: 10),
//               Expanded(
//                   child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
//                 Text(c.winnerUserPaymentProductName, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppFontStyle.styleW700(Colors.white, 14)),
//                 const SizedBox(height: 4),
//                 Text("YOU WINNING BID!", style: AppFontStyle.styleW600(AppColors.primary, 11)),
//                 const SizedBox(height: 4),
//                 Row(children: [
//                   Image.asset(AppAsset.icClock, height: 14, color: Colors.white),
//                   const SizedBox(width: 6),
//                   Text(c.winnerUserPaymentRemainingTime, style: AppFontStyle.styleW600(Colors.white, 11)),
//                 ]),
//               ])),
//               const SizedBox(width: 8),
//               GestureDetector(
//                 onTap: c.OnClickUserPayNow,
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(18)),
//                   child: Text("Pay Now", style: AppFontStyle.styleW700(Colors.black, 12)),
//                 ),
//               ),
//               const SizedBox(width: 10),
//             ]),
//           ),
//         );
//       },
//     );
//   }
// }

import 'dart:async';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:era_shop/custom/preview_image_widget.dart';
import 'package:era_shop/seller_pages/fake_live_auction/controller/fake_live_controller.dart';
import 'package:era_shop/seller_pages/fake_live_auction/widget/fake_custom_bid_bottom_sheet.dart';
import 'package:era_shop/seller_pages/fake_live_auction/widget/fake_product_list_bottom_sheet_ui.dart';
import 'package:era_shop/seller_pages/live_page/widget/flip_profile_animation_widget.dart';
import 'package:era_shop/utils/CoustomWidget/App_theme_services/primary_buttons.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_asset.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

/* ============================== Video background ============================== */

class SimulatedLiveScreen extends StatefulWidget {
  const SimulatedLiveScreen({
    super.key,
    required this.videoUrlOrAsset,
    this.isAsset = false,
    this.autoplay = true,
    this.loop = true,
    this.fallbackImage,
  });

  final String videoUrlOrAsset;
  final bool isAsset;
  final bool autoplay;
  final bool loop;
  final String? fallbackImage;

  @override
  State<SimulatedLiveScreen> createState() => _SimulatedLiveScreenState();
}

class _SimulatedLiveScreenState extends State<SimulatedLiveScreen> {
  VideoPlayerController? _controller;
  bool _failed = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    try {
      final c = widget.isAsset ? VideoPlayerController.asset(widget.videoUrlOrAsset) : VideoPlayerController.networkUrl(Uri.parse(widget.videoUrlOrAsset));
      _controller = c;

      // Surface runtime errors from the plugin
      c.addListener(() {
        final err = c.value.errorDescription;
        if (err != null && mounted) {
          setState(() {
            _error = err;
            _failed = true;
          });
        }
      });

      await c.initialize();
      c.setLooping(true);

      await c.play();

      if (mounted) setState(() {});
    } catch (e) {
      setState(() {
        _failed = true;
        _error = e.toString();
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_failed) {
      return Stack(
        fit: StackFit.expand,
        children: [
          if (widget.fallbackImage != null)
            Image.network(widget.fallbackImage!, fit: BoxFit.cover)
          else
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1f1f1f), Color(0xFF0d0d0d)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          if (_error != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(8),
                color: Colors.red.withValues(alpha: 0.75),
                child: Text(
                  "Video error: $_error",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
        ],
      );
    }

    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(
        child: SizedBox(
          width: 36,
          height: 36,
          child: CircularProgressIndicator(strokeWidth: 2.4),
        ),
      );
    }

    return FittedBox(
      fit: BoxFit.cover,
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: _controller!.value.size.width,
        height: _controller!.value.size.height,
        child: VideoPlayer(_controller!),
      ),
    );
  }
}

/* =============================== Auction UI page ============================== */

class FakeAuctionPage extends StatefulWidget {
  const FakeAuctionPage({super.key, this.videoUrl});

  final String? videoUrl;

  @override
  State<FakeAuctionPage> createState() => _FakeAuctionPageState();
}

class _FakeAuctionPageState extends State<FakeAuctionPage> {
  late final SimulatedAuctionController ctrl;

  @override
  void initState() {
    super.initState();
    ctrl = Get.put(SimulatedAuctionController());

    // seed local data
    ctrl.sellerId = "SIM-SELLER";
    ctrl.roomId = "SIM-ROOM";
    ctrl.liveType = 2; // auction mode
    ctrl.isHost = false;

    ctrl.liveSelectedProducts = [
      SelectedProduct(
        productId: "p1",
        productName: "Leather Crossbody Bag",
        price: 1999,
        minimumBidPrice: 999,
        minAuctionTime: 20,
        mainImage: "https://images.unsplash.com/photo-1548036328-c9fa89d128fa",
        productAttributes: [
          ProductAttribute(name: "Color", values: ["Tan"]),
          ProductAttribute(name: "Material", values: ["Leather"]),
        ],
      ),
      SelectedProduct(
        productId: "p2",
        productName: "Analog Wrist Watch",
        price: 2499,
        minimumBidPrice: 1199,
        minAuctionTime: 25,
        mainImage: "https://5.imimg.com/data5/ANDROID/Default/2024/8/447441317/CK/FO/OA/211159205/product-jpeg.jpg",
        productAttributes: [
          ProductAttribute(name: "Color", values: ["Black"]),
          ProductAttribute(name: "Dial", values: ["42mm"]),
        ],
      ),
      SelectedProduct(
        productId: '3',
        productName: 'Wireless Headphones',
        price: 1999,
        minimumBidPrice: 500,
        minAuctionTime: 45,
        mainImage: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e',
        productAttributes: [
          ProductAttribute(name: 'Color', values: ['Black']),
          ProductAttribute(name: 'Brand', values: ['Sony']),
        ],
      ),
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) => ctrl.startSimulatedShow());
  }

  @override
  void dispose() {
    if (Get.isRegistered<SimulatedAuctionController>()) {
      Get.delete<SimulatedAuctionController>();
    }
    super.dispose();
  }

  String _fmt(int v) => v >= 1000 ? "${(v / 1000).toStringAsFixed(v % 1000 == 0 ? 0 : 1)}K" : "$v";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Positioned.fill(
          child: SimulatedLiveScreen(
            videoUrlOrAsset: '${widget.videoUrl}',
            isAsset: false,
            autoplay: true,
            loop: true,
            fallbackImage: "https://images.unsplash.com/photo-1542831371-d531d36971e6?q=80&w=1600",
          ),
        ),

        // bottom gradient
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: IgnorePointer(
            child: Container(
              height: 340,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black.withValues(alpha: 0.9)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ),

        // top bar
        Positioned(
          top: MediaQuery.of(context).padding.top + 12,
          left: 16,
          right: 16,
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => _pill(icon: AppAsset.icEye, text: _fmt(ctrl.localWatchCount.value))),
              const Spacer(),
              GetBuilder<SimulatedAuctionController>(
                id: "onChangeTime",
                builder: (c) => _pill(icon: AppAsset.icClock, text: c.onConvertSecondToHMS(c.countTime)),
              ),
              const Spacer(),
              const SizedBox(width: 8),
              _roundIcon(AppAsset.icClose, onTap: () => Get.back()),
            ],
          ),
        ),

        // chat + product card + buttons + input
        Positioned(
          left: 12,
          right: 12,
          bottom: 14,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ChatList(ctrl: ctrl),
                    6.height,
                    _BidderBadge(ctrl: ctrl),
                  ],
                ),
                _Products(ctrl: ctrl),
              ],
            ),
            // 10.height,
            // _CommentInput(ctrl: ctrl),
            12.height,
            Center(child: _ProductCard(ctrl: ctrl)),
            8.height,
            _BidButtons(ctrl: ctrl),
            8.height,
          ]),
        ),

        // winner overlay (simple text, you can plug in your FlipProfileAnimationWidget)
        GetBuilder<SimulatedAuctionController>(
          id: "auctionWinner",
          builder: (c) => Positioned(
            top: 160,
            left: 0,
            right: 0,
            child: Visibility(
              visible: c.isShowAnimationWinner,
              child: Center(
                child: FlipProfileAnimationWidget(
                  name: c.auctionWinnerName,
                  imageUrl: c.auctionWinnerImage,
                  message: 'Won the auction!',
                  onFlipCompleted: c.onWinnerAnimationCompleted,
                ),
              ),
            ),
          ),
        ),
        // winner pay-now slider
        // _WinnerPayNow(ctrl: ctrl),
      ]),
    );
  }

  Widget _pill({required String icon, required String text}) => Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(100)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          _simpleIcon(icon),
          const SizedBox(width: 6),
          Text(text, style: AppFontStyle.styleW700(Colors.white, 12)),
        ]),
      );

  Widget _roundIcon(String icon, {VoidCallback? onTap}) => GestureDetector(
        onTap: onTap,
        child: Container(
          height: 36,
          width: 36,
          decoration: const BoxDecoration(color: Colors.black45, shape: BoxShape.circle),
          child: Center(child: _simpleIcon(icon)),
        ),
      );

  Widget _simpleIcon(String id) {
    if (id == AppAsset.icEye) return const Icon(Icons.remove_red_eye, size: 18, color: Colors.white);
    if (id == AppAsset.icClock) return const Icon(Icons.schedule, size: 18, color: Colors.white);
    if (id == AppAsset.icClose) return const Icon(Icons.close, size: 18, color: Colors.white);
    return const SizedBox.shrink();
  }
}

/* ============================== UI subwidgets ============================== */

class _ChatList extends StatelessWidget {
  const _ChatList({required this.ctrl});

  final SimulatedAuctionController ctrl;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black, Colors.transparent, Colors.transparent, Colors.transparent],
          stops: [0.0, 0.1, 0.8, 8.0], // 10% purple, 80% transparent, 10% purple
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstOut,
      child: Obx(() {
        final items = ctrl.chat;
        return SizedBox(
          height: 186,
          width: Get.width * 0.6,
          child: ListView.builder(
            controller: ctrl.scrollController,
            itemCount: items.length,
            padding: EdgeInsets.zero,
            itemBuilder: (_, i) {
              final m = items[i];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  ClipOval(
                    child: CachedNetworkImage(imageUrl: m.userImage, width: 32, height: 32, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                      child: RichText(
                          text: TextSpan(children: [
                    TextSpan(text: "${m.userName} ", style: AppFontStyle.styleW700(AppColors.primary, 12)),
                    TextSpan(text: m.text, style: AppFontStyle.styleW500(Colors.white, 13)),
                  ]))),
                ]),
              );
            },
          ),
        );
      }),
    );
  }
}

class _BidderBadge extends StatelessWidget {
  const _BidderBadge({required this.ctrl});

  final SimulatedAuctionController ctrl;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SimulatedAuctionController>(
      id: "idAuctionProductView",
      builder: (c) => Visibility(
        visible: c.isAuctionActive && c.currentHighestBidderName.trim().isNotEmpty,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(12)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            ClipOval(
              child: CachedNetworkImage(imageUrl: c.currentHighestBidderImage, width: 22, height: 22, fit: BoxFit.cover),
            ),
            const SizedBox(width: 6),
            Text(c.currentHighestBidderName, style: AppFontStyle.styleW600(Colors.white, 12)),
            const SizedBox(width: 6),
            Text(St.winning.tr, style: AppFontStyle.styleW600(AppColors.primary, 11)),
          ]),
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.ctrl});

  final SimulatedAuctionController ctrl;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SimulatedAuctionController>(
      id: "idAuctionProductView",
      builder: (c) {
        if (c.areAllProductsAuctioned) {
          return _glass(
            child: Column(
              children: [
                const Icon(Icons.celebration, size: 36, color: Colors.white),
                const SizedBox(height: 6),
                Text(St.allAuctionsComplete.tr, style: AppFontStyle.styleW700(Colors.white, 16)),
              ],
            ),
          );
        }
        if (c.isAuctionActive) return _active(c);
        if (c.lastAuctionedProduct != null) return _last(c.lastAuctionedProduct!);
        return _glass(
          child: Column(
            children: [
              const Icon(Icons.access_time, size: 30, color: Colors.white),
              6.height,
              Text(St.waitingForNextAuction.tr, style: AppFontStyle.styleW700(Colors.white, 16)),
              Text(St.stayTuned.tr, style: AppFontStyle.styleW500(Colors.white70, 13)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProductAttributes(List<ProductAttribute>? attributes) {
    if (attributes == null || attributes.isEmpty) return SizedBox.shrink();

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: attributes
          .take(2)
          .map((attribute) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.coloGreyText.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  "${attribute.name}: ${attribute.values.join(", ")}",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _active(SimulatedAuctionController c) => _glass(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _livePill(),
            const SizedBox(height: 8),
            Row(
              children: [
                _thumb(c.currentAuctionProductImage),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c.currentAuctionProductName, maxLines: 2, overflow: TextOverflow.ellipsis, style: AppFontStyle.styleW700(Colors.white, 14)),
                      _buildProductAttributes(c.currentAuctionProductAttributes),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  children: [
                    Text(St.bidding.tr.toUpperCase(), style: AppFontStyle.styleW600(AppColors.primary, 12)),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppAsset.icAuctionTime,
                          height: 12,
                          width: 12,
                        ),
                        4.width,
                        GetBuilder<SimulatedAuctionController>(
                          id: "auctionTimer",
                          builder: (ctl) {
                            final t = ctl.auctionRemainingTime;
                            final warn = t <= 10 ? Colors.red : AppColors.colorClosedGreen;
                            return Text(ctl.formatAuctionTime(t), style: AppFontStyle.styleW700(warn, 12));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text("${St.bid.tr.toUpperCase()} $currencySymbol${c.currentHighestBid.toStringAsFixed(0)}", style: AppFontStyle.styleW700(AppColors.primary, 16)),
          ],
        ),
      );

  Widget _last(SelectedProduct p) => _glass(
        child: Row(
          children: [
            _thumb(p.mainImage ?? ""),
            const SizedBox(width: 10),
            Expanded(
              child: Text(p.productName ?? "", maxLines: 2, overflow: TextOverflow.ellipsis, style: AppFontStyle.styleW700(Colors.white, 14)),
            ),
            const SizedBox(width: 10),
            Text(St.lastItem.tr, style: AppFontStyle.styleW600(Colors.white, 12)),
          ],
        ),
      );

  Widget _livePill() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.85), borderRadius: BorderRadius.circular(12)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 7, height: 7, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text(St.liveAuction.tr.toUpperCase(), style: AppFontStyle.styleW600(Colors.white, 12)),
        ]),
      );

  Widget _thumb(String url) => ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CachedNetworkImage(
          imageUrl: url,
          width: 58,
          height: 58,
          fit: BoxFit.cover,
          placeholder: (_, __) => const SizedBox(
            width: 58,
            height: 58,
            child: CupertinoActivityIndicator(),
          ),
          errorWidget: (_, __, ___) => Container(width: 58, height: 58, color: Colors.white10),
        ),
      );

  Widget _glass({required Widget child}) => BlurryContainer(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        blur: 2,
        padding: const EdgeInsets.all(10),
        child: child,
      );
}

// class _BidButtons extends StatelessWidget {
//   const _BidButtons({required this.ctrl});
//
//   final SimulatedAuctionController ctrl;
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<SimulatedAuctionController>(
//       id: "idUserPlaceBid",
//       builder: (c) => Visibility(
//         visible: c.isAuctionActive,
//         child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Expanded(child: _CommentInput(ctrl: ctrl).paddingOnly(right: 20)),
//           Expanded(
//             child: Padding(
//               padding: EdgeInsets.only(bottom: 16, left: 10),
//               child: AppButtonUi(
//                 height: 50,
//                 title: "Custom",
//                 color: AppColors.coloGreyText.withValues(alpha: 0.2),
//                 fontColor: AppColors.white,
//                 callback: () {
//                   // final custom = (c.currentHighestBid + 10).toDouble();
//                   // c.placeCustomBid(custom);
//                   Get.bottomSheet(
//                     FakeCustomBidBottomSheet(
//                       controller: ctrl,
//                       initialIncrement: 10,
//                     ),
//                     isScrollControlled: true,
//                     backgroundColor: Colors.transparent,
//                     barrierColor: Colors.black54,
//                     useRootNavigator: true,
//                   );
//                 },
//               ),
//             ),
//           ),
//           const SizedBox(width: 10),
//           // Expanded(
//           //   child: Bounce(
//           //     duration: Duration(milliseconds: 200),
//           //     onPressed: () {
//           //       c.placeBid;
//           //       // logic.placeBid();
//           //       // log("BID ${logic.currentHighestBid + logic.defaultAuctionPlusBid}");
//           //     },
//           //     child: Padding(
//           //       padding: EdgeInsets.only(bottom: 16, left: 10),
//           //       child: Container(
//           //         decoration: BoxDecoration(
//           //           borderRadius: BorderRadius.circular(100),
//           //           color: AppColors.primary,
//           //         ),
//           //         height: 50,
//           //         width: Get.width,
//           //         child: Center(
//           //           child: Row(
//           //             mainAxisAlignment: MainAxisAlignment.center,
//           //             children: [
//           //               Text(
//           //                 "BID $currencySymbol${(c.currentHighestBid + c.defaultAuctionPlusBid).toString()}",
//           //                 style: TextStyle(
//           //                   color: AppColors.black,
//           //                   fontFamily: AppConstant.appFontSemiBold,
//           //                   fontSize: 18,
//           //                   letterSpacing: 0.3,
//           //                   fontWeight: FontWeight.w600,
//           //                 ),
//           //               ),
//           //             ],
//           //           ),
//           //         ),
//           //       ),
//           //     ),
//           //   ),
//           // ),
//           Expanded(
//             child: Bounce(duration: Duration(milliseconds: 200), onPressed: c.placeBid, child: _chip("BID $currencySymbol${(c.currentHighestBid + c.defaultAuctionPlusBid).toStringAsFixed(0)}", filled: true)),
//           ),
//         ]),
//       ),
//     );
//   }
//
//   Widget _chip(
//     String text, {
//     bool filled = false,
//   }) =>
//       GestureDetector(
//         // onTap: onTap,
//         child: Container(
//           height: 50,
//           decoration: BoxDecoration(color: filled ? AppColors.primary : Colors.white24, borderRadius: BorderRadius.circular(100)),
//           child: Center(
//               child: Text(text,
//                   style: TextStyle(
//                     color: filled ? Colors.black : Colors.white,
//                     fontWeight: FontWeight.w700,
//                     fontSize: 16,
//                   ))),
//         ),
//       );
// }
class _BidButtons extends StatelessWidget {
  const _BidButtons({required this.ctrl});
  final SimulatedAuctionController ctrl;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SimulatedAuctionController>(
      id: "idUserPlaceBid",
      builder: (c) => Visibility(
        visible: c.isAuctionActive,
        child: AnimatedCrossFade(
          duration: Duration(milliseconds: 300),
          crossFadeState: c.isCommentVisible ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: // Comment Input Row (Full Width)
              Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _CommentInput(ctrl: ctrl),
                ),
                10.width,
                GestureDetector(
                  onTap: () {
                    c.toggleCommentVisibility(false);
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                    child: Icon(
                      Icons.gavel,
                      color: AppColors.black,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
          secondChild: // Normal Button Row
              Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  c.toggleCommentVisibility(true);
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: AppColors.coloGreyText.withValues(alpha: 0.2),
                  ),
                  child: Icon(
                    Icons.comment_outlined,
                    color: AppColors.white,
                    size: 24,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 16, left: 10),
                  child: AppButtonUi(
                    height: 50,
                    title: St.custom.tr,
                    color: AppColors.coloGreyText.withValues(alpha: 0.2),
                    fontColor: AppColors.white,
                    callback: () {
                      Get.bottomSheet(
                        FakeCustomBidBottomSheet(
                          controller: ctrl,
                          initialIncrement: 10,
                        ),
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        barrierColor: Colors.black54,
                        useRootNavigator: true,
                      );
                    },
                  ),
                ),
              ),
              10.width,
              Expanded(
                child: Bounce(
                  duration: Duration(milliseconds: 200),
                  onPressed: () {
                    c.placeBid();
                  },
                  child: _chip("${St.bid.tr.toUpperCase()} $currencySymbol${(c.currentHighestBid + c.defaultAuctionPlusBid).toStringAsFixed(0)}", filled: true),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(
    String text, {
    bool filled = false,
  }) =>
      GestureDetector(
        // onTap: onTap,
        child: Container(
          height: 50,
          decoration: BoxDecoration(color: filled ? AppColors.primary : Colors.white24, borderRadius: BorderRadius.circular(100)),
          child: Center(
              child: Text(text,
                  style: TextStyle(
                    color: filled ? Colors.black : Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ))),
        ),
      );
}

class _Products extends StatefulWidget {
  const _Products({required this.ctrl});

  final SimulatedAuctionController ctrl;

  @override
  State<_Products> createState() => _ProductsState();
}

class _ProductsState extends State<_Products> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SimulatedAuctionController>(
      builder: (controller) {
        return Visibility(visible: controller.liveSelectedProducts.isNotEmpty, child: _buildShopViewSection());
      },
    );
  }
}

Widget _buildShopViewSection() {
  return GetBuilder<SimulatedAuctionController>(
    builder: (controller) {
      // log("controller.products.length: ${controller.liveSelectedProducts.length}");
      return GestureDetector(
        onTap: () {
          // log("onTap");
          FakeProductListBottomSheet.show(context: Get.context!, controller: controller);
        },
        child: Column(
          children: [
            Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.white),
              ),
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: PreviewImageWidget(
                  height: 55,
                  width: 55,
                  fit: BoxFit.cover,
                  image: controller.liveSelectedProducts.first.mainImage ?? "",
                  radius: 10,
                ),
              ),
            ),
            5.height,
            Text(St.txtShop.tr, style: AppFontStyle.styleW500(AppColors.white, 12)),
          ],
        ),
      );
    },
  );
}

class _CommentInput extends StatefulWidget {
  const _CommentInput({required this.ctrl});

  final SimulatedAuctionController ctrl;

  @override
  State<_CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<_CommentInput> {
  final _tc = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.only(left: 15, right: 5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Expanded(
            child: TextField(
          controller: _tc,
          maxLines: 1,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: const EdgeInsets.only(bottom: 3),
            hintText: St.txtTypeComment.tr,
            hintStyle: AppFontStyle.styleW400(AppColors.coloGreyText, 15),
          ),
        )),
        GestureDetector(
          onTap: () {
            widget.ctrl.sendUserComment(_tc.text);
            _tc.clear();
          },
          child: Container(
            height: 36,
            width: 36,
            decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
            child: Center(
              child: Image.asset(width: 20, AppAsset.icSend, color: AppColors.primary),
            ),
          ),
        ),
      ]),
    );
  }
}

class _WinnerPayNow extends StatelessWidget {
  const _WinnerPayNow({required this.ctrl});

  final SimulatedAuctionController ctrl;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SimulatedAuctionController>(
      id: "isShowWinnerUserPayment",
      builder: (c) {
        final isVisible = c.isShowWinnerUserPayment;
        final panelWidth = Get.width * 0.75;
        final offscreenRight = -(panelWidth + 24);

        return AnimatedPositioned(
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeOutCubic,
          // right: isVisible ? 16 : offscreenRight,
          right: 0,
          top: Get.height * 0.2,
          child: IgnorePointer(
            ignoring: !isVisible,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              opacity: isVisible ? 1 : 0,
              child: Container(
                height: 75,
                width: panelWidth,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(100),
                    bottomLeft: Radius.circular(100),
                  ),
                  border: Border.all(color: Colors.white70, width: 1.2),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 6),
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: NetworkImage(c.winnerUserPaymentProductImage),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.winnerUserPaymentProductName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppFontStyle.styleW700(Colors.white, 14),
                          ),
                          const SizedBox(height: 4),
                          Text(St.youWinningBid.tr.toUpperCase(), style: AppFontStyle.styleW600(AppColors.primary, 11)),
                          const SizedBox(height: 4),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.schedule, size: 14, color: Colors.white),
                              const SizedBox(width: 6),
                              Text(
                                c.winnerUserPaymentRemainingTime,
                                style: AppFontStyle.styleW600(Colors.white, 11),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: c.onClickUserPayNow,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(St.payNow.tr, style: AppFontStyle.styleW700(Colors.black, 12)),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

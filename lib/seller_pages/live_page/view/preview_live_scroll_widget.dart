// import 'dart:async';
// import 'dart:developer';
// import 'package:era_shop/seller_pages/live_page/view/live_view.dart';
// import 'package:era_shop/utils/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:wakelock_plus/wakelock_plus.dart';
// import 'package:zego_express_engine/zego_express_engine.dart';
//
// class LiveScrollWidget extends StatefulWidget {
//   const LiveScrollWidget({
//     super.key,
//     required this.initialIndex,
//     required this.liveStreams,
//   });
//
//   final int initialIndex;
//   final List<dynamic> liveStreams;
//
//   @override
//   State<LiveScrollWidget> createState() => _LiveScrollWidgetState();
// }
//
// class _LiveScrollWidgetState extends State<LiveScrollWidget> {
//   PageController? pageController;
//   int _currentActiveIndex = 0;
//   bool _isScrolling = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _currentActiveIndex = widget.initialIndex;
//     pageController = PageController(initialPage: widget.initialIndex);
//   }
//
//   @override
//   void dispose() {
//     log("Live Scroll Widget Disposed");
//     pageController?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.black,
//       body: NotificationListener<ScrollNotification>(
//         onNotification: (notification) {
//           if (notification is ScrollEndNotification) {
//             _isScrolling = false;
//             final newPage = (pageController?.page ?? 0).round();
//             if (newPage != _currentActiveIndex) {
//               _currentActiveIndex = newPage;
//               log("Page fully settled: $_currentActiveIndex");
//               if (mounted) setState(() {});
//             }
//           } else if (notification is ScrollUpdateNotification) {
//             _isScrolling = true;
//           }
//           return false;
//         },
//         child: PageView.builder(
//           controller: pageController,
//           scrollDirection: Axis.vertical,
//           itemCount: widget.liveStreams.length,
//           physics: const ClampingScrollPhysics(),
//           onPageChanged: (index) {
//             if (!_isScrolling) {
//               _currentActiveIndex = index;
//               log("Live Stream Page Changed to: $index");
//               if (mounted) setState(() {});
//             }
//           },
//           allowImplicitScrolling: false,
//           itemBuilder: (context, index) {
//             final liveData = widget.liveStreams[index];
//
//             return LivePageView(
//               key: ValueKey("live_${liveData.liveHistoryId}_$index"),
//               liveUserList: liveData,
//               isHost: false,
//               isActive: index == _currentActiveIndex,
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

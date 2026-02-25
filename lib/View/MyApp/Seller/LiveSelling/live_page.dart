// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
//
// import 'package:blurrycontainer/blurrycontainer.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:era_shop/utils/Strings/strings.dart';
// import 'package:era_shop/utils/Zego/ZegoUtils/device_orientation.dart';
// import 'package:era_shop/utils/app_asset.dart';
// import 'package:era_shop/utils/app_colors.dart';
// import 'package:era_shop/utils/font_style.dart';
// import 'package:era_shop/utils/utils.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:zego_express_engine/zego_express_engine.dart';
//
// import '../../../../Controller/GetxController/seller/live_seller_for_selling_controller.dart';
// import '../../../../Controller/GetxController/socket controller/user_get_selected_product_controller.dart';
// import '../../../../Controller/GetxController/user/SocketManager/socket_manager_controller.dart';
// import '../../../../Controller/GetxController/user/user_product_details_controller.dart';
// import '../../../../utils/CoustomWidget/App_theme_services/primary_buttons.dart';
// import '../../../../utils/CoustomWidget/App_theme_services/text_titles.dart';
// import '../../../../utils/CoustomWidget/Page_devided/add_to_cart_bottom_sheet.dart';
// import '../../../../utils/all_images.dart';
// import '../../../../utils/globle_veriables.dart';
// import '../../../../utils/shimmers.dart';
//
// class LivePage extends StatefulWidget {
//   const LivePage({
//     Key? key,
//     required this.isHost,
//     required this.localUserID,
//     required this.localUserName,
//     required this.roomID,
//   }) : super(key: key);
//
//   final bool isHost;
//   final String localUserID;
//   final String localUserName;
//   final String roomID;
//
//   @override
//   State<LivePage> createState() => _LivePageState();
// }
//
// class _LivePageState extends State<LivePage> {
//   Widget? hostCameraView;
//   int? hostCameraViewID;
//
//   Widget? hostScreenView;
//   int? hostScreenViewID;
//
//   bool isCameraEnabled = true;
//   bool isSharingScreen = false;
//   ZegoScreenCaptureSource? screenSharingSource;
//
//   bool isLandscape = false;
//
//   List<StreamSubscription> subscriptions = [];
//
//   LiveSellerForSellingController liveSellerForSellingController = Get.put(LiveSellerForSellingController());
//   UserGetSelectedProductController userGetSelectedProductController = Get.put(UserGetSelectedProductController());
//   UserProductDetailsController userProductDetailsController = Get.put(UserProductDetailsController());
//
//   @override
//   void initState() {
//     // selectedProductForLiveController.getSelectedProduct();
//     startListenEvent();
//     loginRoom();
//     subscriptions.addAll([
//       NativeDeviceOrientationCommunicator().onOrientationChanged().listen((NativeDeviceOrientation orientation) {
//         updateAppOrientation(orientation);
//       }),
//     ]);
//     Timer.periodic(const Duration(seconds: 1), (timer) {
//       _scrollToBottom();
//     });
//     super.initState();
//   }
//
//   void _scrollToBottom() {
//     // _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
//     _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
//   }
//
//   @override
//   void dispose() {
//     for (var sub in subscriptions) {
//       sub.cancel();
//     }
//     stopListenEvent();
//     logoutRoom();
//     resetAppOrientation();
//     super.dispose();
//   }
//
//   Widget get screenView => isSharingScreen ? (hostScreenView ?? const SizedBox()) : const SizedBox();
//
//   Widget get cameraView => isCameraEnabled ? (hostCameraView ?? const SizedBox()) : const SizedBox();
//
//   void updateAppOrientation(NativeDeviceOrientation orientation) async {
//     if (isLandscape != orientation.isLandscape) {
//       isLandscape = orientation.isLandscape;
//       debugPrint('updateAppOrientation: ${orientation.name}');
//       final videoConfig = await ZegoExpressEngine.instance.getVideoConfig();
//       if (isLandscape && (videoConfig.captureWidth > videoConfig.captureHeight)) return;
//
//       final oldValues = {
//         'captureWidth': videoConfig.captureWidth,
//         'captureHeight': videoConfig.captureHeight,
//         'encodeWidth': videoConfig.encodeWidth,
//         'encodeHeight': videoConfig.encodeHeight,
//       };
//       videoConfig
//         ..captureHeight = oldValues['captureWidth']!
//         ..captureWidth = oldValues['captureHeight']!
//         ..encodeHeight = oldValues['encodeWidth']!
//         ..encodeWidth = oldValues['encodeHeight']!;
//       ZegoExpressEngine.instance.setAppOrientation(orientation.toZegoType);
//       ZegoExpressEngine.instance.setVideoConfig(videoConfig);
//     }
//   }
//
//   void resetAppOrientation() => updateAppOrientation(NativeDeviceOrientation.portraitUp);
//
//   final ScrollController _scrollController = ScrollController();
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         widget.isHost
//             ? Get.defaultDialog(
//                 backgroundColor: isDark.value ? AppColors.blackBackground : AppColors.white,
//                 title: St.doYouReallyWantToExitLiveStreaming.tr,
//                 titlePadding: const EdgeInsets.only(top: 45, left: 20, right: 20),
//                 titleStyle: GoogleFonts.plusJakartaSans(color: isDark.value ? AppColors.white : AppColors.black, fontSize: 18, height: 1.5, fontWeight: FontWeight.w600),
//                 content: Column(
//                   children: [
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 30),
//                       child: PrimaryPinkButton(
//                           onTaped: () {
//                             Get.back();
//                           },
//                           text: St.cancelSmallText.tr),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         // Get.off(() => const LiveStreaming(), transition: Transition.leftToRight);
//                         var userData = jsonEncode({
//                           "userId": userId,
//                           "liveSellingHistoryId": widget.roomID,
//                         });
//                         log("userData :: $userData");
//                         socket!.emit("lessView", userData);
//                         Get.back();
//                         Get.back();
//                       },
//                       child: Container(
//                         height: 30,
//                         decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(24)),
//                         child: Center(
//                           child: Text(
//                             St.exit.tr,
//                             style: GoogleFonts.plusJakartaSans(color: AppColors.primaryRed, fontSize: 16, fontWeight: FontWeight.w500),
//                           ),
//                         ),
//                       ).paddingOnly(top: 12),
//                     ),
//                   ],
//                 ),
//               )
//             : Get.back();
//         return false;
//       },
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         body: SizedBox(
//           height: Get.height,
//           width: Get.width,
//           child: Stack(
//             children: [
//               Container(color: Colors.black),
//               Builder(builder: (context) {
//                 if (!isSharingScreen) return cameraView;
//                 if (!widget.isHost) return screenView;
//                 return Center(child: Text(St.youAreSharingYourScreen.tr, style: const TextStyle(color: Colors.white)));
//               }),
//               widget.isHost
//                   ? SizedBox(
//                       height: Get.height,
//                       width: Get.width,
//                       child: Column(
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 20, vertical: Get.height / 25),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 GestureDetector(
//                                   onTap: () {
//                                     // Get.defaultDialog(
//                                     //   backgroundColor: isDark.value ? AppColors.blackBackground : AppColors.white,
//                                     //   title: St.doYouReallyWantToExitLiveStreaming.tr,
//                                     //   titlePadding: const EdgeInsets.only(top: 45, left: 20, right: 20),
//                                     //   titleStyle: GoogleFonts.plusJakartaSans(
//                                     //       color: isDark.value ? AppColors.white : AppColors.black,
//                                     //       fontSize: 18,
//                                     //       height: 1.5,
//                                     //       fontWeight: FontWeight.w600),
//                                     //   content: Column(
//                                     //     children: [
//                                     //       const SizedBox(
//                                     //         height: 20,
//                                     //       ),
//                                     //       Padding(
//                                     //         padding: const EdgeInsets.symmetric(horizontal: 30),
//                                     //         child: PrimaryPinkButton(
//                                     //             onTaped: () {
//                                     //               Get.back();
//                                     //             },
//                                     //             text: St.cancelSmallText.tr),
//                                     //       ),
//                                     //       GestureDetector(
//                                     //         onTap: () {
//                                     //           // Get.off(() => const LiveStreaming(), transition: Transition.leftToRight);
//                                     //           Get.back();
//                                     //           Get.back();
//                                     //         },
//                                     //         child: Container(
//                                     //           height: 30,
//                                     //           decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(24)),
//                                     //           child: Center(
//                                     //             child: Text(
//                                     //               St.exit.tr,
//                                     //               style: GoogleFonts.plusJakartaSans(
//                                     //                   color: AppColors.primaryRed, fontSize: 16, fontWeight: FontWeight.w500),
//                                     //             ),
//                                     //           ),
//                                     //         ).paddingOnly(top: 12),
//                                     //       ),
//                                     //     ],
//                                     //   ),
//                                     // );
//                                     ExitLiveDialogUi.onShow(
//                                       callBack: () {
//                                         Get.close(2);
//                                       },
//                                     );
//                                   },
//                                   child: BlurryContainer(
//                                     height: 42,
//                                     width: 42,
//                                     blur: 4.5,
//                                     color: AppColors.white.withValues(alpha: 0.2),
//                                     // decoration: BoxDecoration(
//                                     //   shape: BoxShape.circle,
//                                     //   color: Colors.grey.withValues(alpha:0.50),
//                                     // ),
//                                     child: const Padding(
//                                       padding: EdgeInsets.all(4),
//                                       child: Image(image: AssetImage("assets/icons/on_off.png")),
//                                     ),
//                                   ),
//                                 ),
//                                 BlurryContainer(
//                                   height: 38,
//                                   width: 122,
//                                   blur: 4.5,
//                                   color: AppColors.white.withValues(alpha: 0.2),
//                                   borderRadius: BorderRadius.circular(50),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                     children: [
//                                       Image(
//                                         image: AssetImage(AppImage.eyeImage),
//                                         height: 15.5,
//                                       ),
//                                       Obx(() => Text(
//                                             "${SocketManage.liveWatchCount.value}",
//                                             style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.bold, color: AppColors.white),
//                                           )),
//                                       Container(
//                                         height: 26,
//                                         width: Get.width / 8,
//                                         decoration: BoxDecoration(color: AppColors.primaryRed, borderRadius: BorderRadius.circular(20)),
//                                         child: Center(
//                                           child: Text(
//                                             St.liveText.tr,
//                                             style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.white),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 // if (widget.isHost) ...[
//                                 //   DemoButton(
//                                 //     text: isCameraEnabled ? 'Disable Camera' : 'Enable Camera',
//                                 //     onPressed: () {
//                                 //       setState(() {
//                                 //         isCameraEnabled = !isCameraEnabled;
//                                 //         ZegoExpressEngine.instance
//                                 //             .setStreamExtraInfo(jsonEncode({'isCameraEnabled': isCameraEnabled}));
//                                 //         ZegoExpressEngine.instance.enableCamera(isCameraEnabled);
//                                 //       });
//                                 //     },
//                                 //   ),
//                                 // ]
//                               ],
//                             ),
//                           ),
//                           Expanded(
//                             child: Scaffold(
//                               backgroundColor: Colors.transparent,
//                               body: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(horizontal: 15),
//                                     child: SizedBox(
//                                       height: Get.height / 2.8,
//                                       child: Row(
//                                         children: [
//                                           Expanded(
//                                             child: ShaderMask(
//                                                 shaderCallback: (bounds) {
//                                                   return const LinearGradient(
//                                                     begin: Alignment.topCenter,
//                                                     end: Alignment.bottomCenter,
//                                                     colors: [Colors.black, Colors.transparent, Colors.transparent, Colors.transparent],
//                                                     stops: [0.0, 0.1, 0.8, 8.0], // 10% purple, 80% transparent, 10% purple
//                                                   ).createShader(bounds);
//                                                 },
//                                                 blendMode: BlendMode.dstOut,
//                                                 child: Obx(
//                                                   () => ListView.builder(
//                                                     controller: _scrollController,
//                                                     itemCount: SocketManage.comments.length,
//                                                     shrinkWrap: true,
//                                                     scrollDirection: Axis.vertical,
//                                                     physics: const BouncingScrollPhysics(),
//                                                     itemBuilder: (context, index) {
//                                                       Map<String, dynamic> commentMap = jsonDecode(SocketManage.comments[index]);
//                                                       return Row(
//                                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                                         children: [
//                                                           Container(
//                                                             height: 45,
//                                                             width: 45,
//                                                             decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(image: NetworkImage(commentMap["image"]))),
//                                                           ).paddingOnly(right: 10),
//                                                           Column(
//                                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                                             children: [
//                                                               Text(
//                                                                 commentMap["name"],
//                                                                 style: GoogleFonts.plusJakartaSans(color: AppColors.white, fontSize: 14.5, fontWeight: FontWeight.w600),
//                                                               ).paddingOnly(bottom: 4),
//                                                               SizedBox(
//                                                                 width: Get.width * 0.5,
//                                                                 child: Text(
//                                                                   commentMap["comment"],
//                                                                   style: GoogleFonts.plusJakartaSans(
//                                                                     color: AppColors.white,
//                                                                     fontSize: 12.5,
//                                                                   ),
//                                                                 ),
//                                                               )
//                                                             ],
//                                                           )
//                                                         ],
//                                                       ).paddingOnly(bottom: 20);
//                                                     },
//                                                   ).paddingOnly(right: 18),
//                                                 )),
//                                           ),
//                                           ShaderMask(
//                                             shaderCallback: (bounds) {
//                                               return const LinearGradient(
//                                                 begin: Alignment.topCenter,
//                                                 end: Alignment.bottomCenter,
//                                                 colors: [Colors.black, Colors.transparent, Colors.transparent, Colors.transparent],
//                                                 stops: [0.0, 0.1, 0.8, 8.0], // 10% purple, 80% transparent, 10% purple
//                                               ).createShader(bounds);
//                                             },
//                                             blendMode: BlendMode.dstOut,
//                                             child: Obx(
//                                               () => liveSellerForSellingController.isLoading.value
//                                                   ? Shimmers.sellerLiveStreamingBottomSheetShimmer()
//                                                   : SizedBox(
//                                                       width: 84,
//                                                       child: ListView.builder(
//                                                         physics: const BouncingScrollPhysics(),
//                                                         itemCount: liveSellerForSellingController.sellerSelectedProducts.length,
//                                                         itemBuilder: (context, index) {
//                                                           var selectedProduct = liveSellerForSellingController.sellerSelectedProducts[index];
//                                                           return Padding(
//                                                             padding: const EdgeInsets.symmetric(vertical: 5),
//                                                             child: GestureDetector(
//                                                               onTap: () {
//                                                                 productId = selectedProduct.id ?? '';
//                                                                 Get.toNamed("/ProductDetail");
//                                                               },
//                                                               child: Container(
//                                                                 height: 108,
//                                                                 width: 85,
//                                                                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: AppColors.white),
//                                                                 child: Column(
//                                                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                                                   children: [
//                                                                     ClipRRect(
//                                                                       borderRadius: BorderRadius.circular(4),
//                                                                       child: CachedNetworkImage(
//                                                                         height: 80,
//                                                                         width: 75,
//                                                                         fit: BoxFit.cover,
//                                                                         imageUrl: selectedProduct.mainImage.toString(),
//                                                                         placeholder: (context, url) => const Center(
//                                                                             child: CupertinoActivityIndicator(
//                                                                           animating: true,
//                                                                         )),
//                                                                         errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
//                                                                       ),
//                                                                     ),
//                                                                     Text(
//                                                                       "$currencySymbol${selectedProduct.price}",
//                                                                       style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 10.5, color: AppColors.black),
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           );
//                                                         },
//                                                       ),
//                                                     ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 5),
//                                     child: Row(
//                                       children: [
//                                         /// if in future add product method when seller live so use this
//                                         // GestureDetector(
//                                         //   onTap: () {
//                                         //     showCatalogController.getCatalogDataForLive();
//                                         //     // selectedProductForLiveController.getSelectedProduct(forLive: false);
//                                         //     Get.bottomSheet(
//                                         //       barrierColor: Colors.transparent,
//                                         //       isScrollControlled: true,
//                                         //       addProductBottomSheet(),
//                                         //     );
//                                         //   },
//                                         //   child: Container(
//                                         //     height: 52,
//                                         //     width: 52,
//                                         //     decoration: BoxDecoration(
//                                         //       shape: BoxShape.circle,
//                                         //       color: Colors.grey.withValues(alpha:0.50),
//                                         //     ),
//                                         //     child: Padding(
//                                         //         padding: const EdgeInsets.all(12),
//                                         //         child: Icon(
//                                         //           Icons.add,
//                                         //           color: AppColors.white,
//                                         //         )),
//                                         //   ),
//                                         // ),
//                                         // const SizedBox(
//                                         //   width: 12,
//                                         // ),
//                                         Expanded(
//                                           child: TextFormField(
//                                             cursorColor: AppColors.unselected,
//                                             controller: SocketManage.sellerCommentText,
//                                             textAlignVertical: TextAlignVertical.center,
//                                             maxLines: 3,
//                                             minLines: 1,
//                                             decoration: InputDecoration(
//                                                 filled: true,
//                                                 suffixIcon: GestureDetector(
//                                                   onTap: () {
//                                                     if (SocketManage.sellerCommentText.text.isBlank != true) {
//                                                       var addComment = jsonEncode({
//                                                         "image": sellerEditImage,
//                                                         "name": editBusinessName,
//                                                         "comment": SocketManage.sellerCommentText.text,
//                                                         "liveSellingHistoryId": widget.roomID,
//                                                       });
//                                                       if (socket != null && socket!.connected) {
//                                                         socket!.emit("comment", addComment);
//                                                       } else {
//                                                         log("Socket is not connected.");
//                                                       }
//                                                       SocketManage.sellerCommentText.clear();
//                                                       FocusScope.of(context).requestFocus(FocusNode());
//                                                     }
//                                                   },
//                                                   child: Padding(
//                                                     padding: const EdgeInsets.only(right: 8),
//                                                     child: SizedBox(
//                                                       height: 16,
//                                                       width: 16,
//                                                       child: Image(image: AssetImage(AppImage.sendMessage)),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 hintText: St.writeHereTF.tr,
//                                                 fillColor: const Color(0xffF6F8FE),
//                                                 hintStyle: const TextStyle(color: Color(0xff9CA4AB), fontSize: 13),
//                                                 enabledBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(30)),
//                                                 border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryPink), borderRadius: BorderRadius.circular(30))),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     )
//                   : SizedBox(
//                       height: Get.height,
//                       width: Get.width,
//                       child: Column(
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 20, vertical: Get.height / 25),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Obx(() {
//                                   if (userGetSelectedProductController.isLoading.value) {
//                                     return const CupertinoActivityIndicator();
//                                   } else {
//                                     var selectedProduct = userGetSelectedProductController.userGetSelectedProduct!.data;
//                                     return Row(
//                                       children: [
//                                         CircleAvatar(
//                                           radius: 20,
//                                           backgroundImage: NetworkImage("${selectedProduct!.image}"),
//                                         ),
//                                         SizedBox(
//                                           width: Get.width * 0.36,
//                                           child: Padding(
//                                             padding: const EdgeInsets.only(left: 11),
//                                             child: Column(
//                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                               children: [
//                                                 Text(
//                                                   "${selectedProduct.firstName} ${selectedProduct.lastName}",
//                                                   overflow: TextOverflow.ellipsis,
//                                                   style: GoogleFonts.plusJakartaSans(color: AppColors.white, fontSize: 14, fontWeight: FontWeight.bold),
//                                                 ),
//                                                 Text(
//                                                   "${selectedProduct.businessName}",
//                                                   overflow: TextOverflow.ellipsis,
//                                                   style: GoogleFonts.plusJakartaSans(
//                                                     color: AppColors.white,
//                                                     fontSize: 12,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     );
//                                   }
//                                 }),
//                                 BlurryContainer(
//                                   height: 38,
//                                   width: 122,
//                                   blur: 4.5,
//                                   color: AppColors.white.withValues(alpha: 0.2),
//                                   // decoration: BoxDecoration(
//                                   //     color: Colors.grey.withValues(alpha:0.50),
//                                   //     borderRadius: BorderRadius.circular(20)),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                     children: [
//                                       Image(
//                                         image: AssetImage(AppImage.eyeImage),
//                                         height: 15.5,
//                                       ),
//                                       Obx(
//                                         () => Text(
//                                           "${SocketManage.liveWatchCount.value}",
//                                           style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.bold, color: AppColors.white),
//                                         ),
//                                       ),
//                                       Container(
//                                         height: 26,
//                                         width: Get.width / 8,
//                                         decoration: BoxDecoration(color: AppColors.primaryRed, borderRadius: BorderRadius.circular(20)),
//                                         child: Center(
//                                           child: Text(
//                                             St.liveText.tr,
//                                             style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.white),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 GestureDetector(
//                                   onTap: () => Get.back(),
//                                   child: BlurryContainer(
//                                     height: 38,
//                                     width: 38,
//                                     blur: 4.5,
//                                     color: AppColors.white.withValues(alpha: 0.2),
//                                     borderRadius: BorderRadius.circular(50),
//                                     // decoration: BoxDecoration(
//                                     //     color: Colors.grey.withValues(alpha:0.50),
//                                     //     borderRadius: BorderRadius.circular(20)),
//                                     child: Center(
//                                         child: Icon(
//                                       Icons.close,
//                                       color: AppColors.white,
//                                       size: 14,
//                                     )),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                           Expanded(
//                             child: Scaffold(
//                               backgroundColor: Colors.transparent,
//                               body: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(horizontal: 15),
//                                     child: SizedBox(
//                                       height: Get.height / 2.8,
//                                       child: Row(
//                                         children: [
//                                           Expanded(
//                                             child: ShaderMask(
//                                                 shaderCallback: (bounds) {
//                                                   return const LinearGradient(
//                                                     begin: Alignment.topCenter,
//                                                     end: Alignment.bottomCenter,
//                                                     colors: [Colors.black, Colors.transparent, Colors.transparent, Colors.transparent],
//                                                     stops: [0.0, 0.1, 0.8, 8.0], // 10% purple, 80% transparent, 10% purple
//                                                   ).createShader(bounds);
//                                                 },
//                                                 blendMode: BlendMode.dstOut,
//                                                 child: Obx(
//                                                   () => ListView.builder(
//                                                     controller: _scrollController,
//                                                     itemCount: SocketManage.comments.length,
//                                                     shrinkWrap: true,
//                                                     scrollDirection: Axis.vertical,
//                                                     physics: const BouncingScrollPhysics(),
//                                                     itemBuilder: (context, index) {
//                                                       Map<String, dynamic> commentMap = jsonDecode(SocketManage.comments[index]);
//                                                       return Row(
//                                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                                         children: [
//                                                           Container(
//                                                             height: 45,
//                                                             width: 45,
//                                                             decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(image: NetworkImage(commentMap["image"]))),
//                                                           ).paddingOnly(right: 10),
//                                                           Column(
//                                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                                             children: [
//                                                               Text(
//                                                                 commentMap["name"],
//                                                                 style: GoogleFonts.plusJakartaSans(color: AppColors.white, fontSize: 14.5, fontWeight: FontWeight.w600),
//                                                               ).paddingOnly(bottom: 4),
//                                                               SizedBox(
//                                                                 width: Get.width * 0.5,
//                                                                 child: Text(
//                                                                   commentMap["comment"],
//                                                                   style: GoogleFonts.plusJakartaSans(
//                                                                     color: AppColors.white,
//                                                                     fontSize: 12.5,
//                                                                   ),
//                                                                 ),
//                                                               )
//                                                             ],
//                                                           )
//                                                         ],
//                                                       ).paddingOnly(bottom: 20);
//                                                     },
//                                                   ).paddingOnly(right: 18),
//                                                 )),
//                                           ),
//                                           ShaderMask(
//                                             shaderCallback: (bounds) {
//                                               return const LinearGradient(
//                                                 begin: Alignment.topCenter,
//                                                 end: Alignment.bottomCenter,
//                                                 colors: [Colors.black, Colors.transparent, Colors.transparent, Colors.transparent],
//                                                 stops: [0.0, 0.1, 0.8, 8.0], // 10% purple, 80% transparent, 10% purple
//                                               ).createShader(bounds);
//                                             },
//                                             blendMode: BlendMode.dstOut,
//                                             child: Obx(
//                                               () => userGetSelectedProductController.isLoading.value
//                                                   ? Shimmers.sellerLiveStreamingBottomSheetShimmer()
//                                                   : SizedBox(
//                                                       width: 84,
//                                                       child: ListView.builder(
//                                                         physics: const BouncingScrollPhysics(),
//                                                         itemCount: userGetSelectedProductController.userGetSelectedProduct!.data!.selectedProducts!.length,
//                                                         itemBuilder: (context, index) {
//                                                           var selectedProduct = userGetSelectedProductController.userGetSelectedProduct!.data!.selectedProducts![index];
//                                                           return Padding(
//                                                             padding: const EdgeInsets.symmetric(vertical: 5),
//                                                             child: InkWell(
//                                                               onTap: () {
//                                                                 productId = "${selectedProduct.id}";
//                                                                 Get.toNamed("/ProductDetail");
//                                                               },
//                                                               child: Container(
//                                                                 height: 108,
//                                                                 width: 85,
//                                                                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: AppColors.white),
//                                                                 child: Column(
//                                                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                                                   children: [
//                                                                     ClipRRect(
//                                                                       borderRadius: BorderRadius.circular(4),
//                                                                       child: CachedNetworkImage(
//                                                                         height: 80,
//                                                                         width: 75,
//                                                                         fit: BoxFit.cover,
//                                                                         imageUrl: selectedProduct.mainImage.toString(),
//                                                                         placeholder: (context, url) => const Center(
//                                                                             child: CupertinoActivityIndicator(
//                                                                           animating: true,
//                                                                         )),
//                                                                         errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
//                                                                       ),
//                                                                     ),
//                                                                     Text(
//                                                                       "$currencySymbol${selectedProduct.price}",
//                                                                       style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 10.5, color: AppColors.black),
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           );
//                                                         },
//                                                       ),
//                                                     ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         GestureDetector(
//                                           onTap: () {
//                                             Get.bottomSheet(
//                                               barrierColor: Colors.transparent,
//                                               isScrollControlled: true,
//                                               Container(
//                                                 height: Get.height / 1.5,
//                                                 decoration: BoxDecoration(color: isDark.value ? AppColors.blackBackground : const Color(0xffffffff), borderRadius: const BorderRadius.vertical(top: Radius.circular(25))),
//                                                 child: Padding(
//                                                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                                                   child: SizedBox(
//                                                     child: Stack(
//                                                       children: [
//                                                         SingleChildScrollView(
//                                                           physics: const BouncingScrollPhysics(),
//                                                           child: Column(
//                                                             children: [
//                                                               const SizedBox(
//                                                                 height: 60,
//                                                               ),
//                                                               SizedBox(
//                                                                 child: ListView.builder(
//                                                                   shrinkWrap: true,
//                                                                   physics: const NeverScrollableScrollPhysics(),
//                                                                   itemCount: userGetSelectedProductController.userGetSelectedProduct!.data!.selectedProducts!.length,
//                                                                   scrollDirection: Axis.vertical,
//                                                                   itemBuilder: (context, index) {
//                                                                     var selectedProduct = userGetSelectedProductController.userGetSelectedProduct!.data!.selectedProducts![index];
//                                                                     return Padding(
//                                                                       padding: const EdgeInsets.symmetric(vertical: 7),
//                                                                       child: InkWell(
//                                                                         onTap: () {
//                                                                           productId = "${selectedProduct.id}";
//                                                                           Get.toNamed("/ProductDetail");
//                                                                         },
//                                                                         child: SizedBox(
//                                                                           height: Get.height / 8.2,
//                                                                           width: Get.width / 2.5,
//                                                                           child: Stack(
//                                                                             children: [
//                                                                               Row(
//                                                                                 mainAxisAlignment: MainAxisAlignment.start,
//                                                                                 children: [
//                                                                                   ClipRRect(
//                                                                                     borderRadius: BorderRadius.circular(15),
//                                                                                     child: CachedNetworkImage(
//                                                                                       // height: 80,
//                                                                                       width: Get.width / 4.3,
//                                                                                       fit: BoxFit.cover,
//                                                                                       imageUrl: "${selectedProduct.mainImage}",
//                                                                                       placeholder: (context, url) => const Center(
//                                                                                           child: CupertinoActivityIndicator(
//                                                                                         animating: true,
//                                                                                       )),
//                                                                                       errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
//                                                                                     ),
//                                                                                   ),
//                                                                                   Padding(
//                                                                                     padding: const EdgeInsets.only(left: 15),
//                                                                                     child: SizedBox(
//                                                                                       width: Get.width / 1.9,
//                                                                                       child: Column(
//                                                                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                                                                         children: [
//                                                                                           Text(
//                                                                                             "${selectedProduct.productName}",
//                                                                                             overflow: TextOverflow.ellipsis,
//                                                                                             style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w500),
//                                                                                           ).paddingOnly(top: 8),
//                                                                                           Text(
//                                                                                             "${St.size.tr}  ${selectedProduct.attributes![0].value!.join(", ")}",
//                                                                                             overflow: TextOverflow.ellipsis,
//                                                                                             style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w300),
//                                                                                           ).paddingSymmetric(vertical: 7),
//                                                                                           const Spacer(),
//                                                                                           Text(
//                                                                                             "$currencySymbol${selectedProduct.price}",
//                                                                                             style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
//                                                                                           ).paddingOnly(bottom: 20),
//                                                                                         ],
//                                                                                       ),
//                                                                                     ),
//                                                                                   )
//                                                                                 ],
//                                                                               ),
//                                                                               Align(
//                                                                                 alignment: Alignment.bottomRight,
//                                                                                 child: Padding(
//                                                                                   padding: const EdgeInsets.all(11),
//                                                                                   child: GestureDetector(
//                                                                                     onTap: () {
//                                                                                       productId = "${selectedProduct.id}";
//                                                                                       Get.back();
//                                                                                       userProductDetailsController.userProductDetailsData();
//                                                                                       Get.bottomSheet(
//                                                                                         barrierColor: Colors.transparent,
//                                                                                         isScrollControlled: true,
//                                                                                         // isDismissible: false,
//                                                                                         AddToCartBottomSheet(productImage: selectedProduct.mainImage, productName: selectedProduct.productName, productPrice: selectedProduct.price.toString()),
//                                                                                       );
//                                                                                     },
//                                                                                     child: Container(
//                                                                                       height: 35,
//                                                                                       width: 85,
//                                                                                       decoration: BoxDecoration(color: AppColors.primaryPink, borderRadius: BorderRadius.circular(6)),
//                                                                                       child: Center(
//                                                                                           child: Text(
//                                                                                         St.addToCart.tr,
//                                                                                         style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.white, fontWeight: FontWeight.bold),
//                                                                                       )),
//                                                                                     ),
//                                                                                   ),
//                                                                                 ),
//                                                                               ),
//                                                                             ],
//                                                                           ),
//                                                                         ),
//                                                                       ),
//                                                                     );
//                                                                   },
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                         Align(
//                                                           alignment: Alignment.topCenter,
//                                                           child: Container(
//                                                             height: 62,
//                                                             decoration: BoxDecoration(
//                                                               color: isDark.value ? AppColors.blackBackground : const Color(0xffffffff),
//                                                             ),
//                                                             child: Column(
//                                                               children: [
//                                                                 Row(
//                                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                                   children: [
//                                                                     SmallTitle(title: St.liveSelling.tr),
//                                                                     Padding(
//                                                                       padding: const EdgeInsets.only(right: 5),
//                                                                       child: Obx(
//                                                                         () => Image(
//                                                                           image: isDark.value ? AssetImage(AppImage.lightcart) : AssetImage(AppImage.darkcart),
//                                                                           height: 22,
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                   ],
//                                                                 ).paddingOnly(top: 18, bottom: 6),
//                                                                 Obx(
//                                                                   () => Divider(
//                                                                     color: isDark.value ? AppColors.white : AppColors.black,
//                                                                   ),
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                           child: BlurryContainer(
//                                             height: 52,
//                                             width: 52,
//                                             blur: 4.5,
//                                             borderRadius: BorderRadius.circular(50),
//                                             color: AppColors.white.withValues(alpha: 0.4),
//                                             // decoration: const BoxDecoration(
//                                             //   color: Colors.grey,
//                                             //   shape: BoxShape.circle,
//                                             // ),
//                                             child: Padding(
//                                               padding: const EdgeInsets.all(4.5),
//                                               child: Image(image: AssetImage(AppImage.redCart)),
//                                             ),
//                                           ),
//                                         ).paddingOnly(right: 12),
//                                         Expanded(
//                                           child: TextFormField(
//                                             cursorColor: AppColors.unselected,
//                                             textAlignVertical: TextAlignVertical.center,
//                                             controller: SocketManage.userCommentText,
//                                             maxLines: 3,
//                                             minLines: 1,
//                                             decoration: InputDecoration(
//                                                 filled: true,
//                                                 suffixIcon: GestureDetector(
//                                                   onTap: () {
//                                                     if (SocketManage.userCommentText.text.isBlank != true) {
//                                                       var addComment = jsonEncode({
//                                                         "image": editImage,
//                                                         "name": "$editFirstName $editLastName",
//                                                         "comment": SocketManage.userCommentText.text,
//                                                         "liveSellingHistoryId": widget.roomID,
//                                                       });
//                                                       if (socket != null && socket!.connected) {
//                                                         socket!.emit("comment", addComment);
//                                                       } else {
//                                                         log("Socket is not connected.");
//                                                       }
//                                                       SocketManage.userCommentText.clear();
//                                                       FocusScope.of(context).requestFocus(FocusNode());
//                                                     }
//                                                   },
//                                                   child: Padding(
//                                                     padding: const EdgeInsets.only(right: 8),
//                                                     child: SizedBox(
//                                                       height: 16,
//                                                       width: 16,
//                                                       child: Image(image: AssetImage(AppImage.sendMessage)),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 hintText: St.writeHereTF.tr,
//                                                 fillColor: const Color(0xffF6F8FE),
//                                                 hintStyle: const TextStyle(color: Color(0xff9CA4AB), fontSize: 13),
//                                                 enabledBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(30)),
//                                                 border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryPink), borderRadius: BorderRadius.circular(30))),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<ZegoRoomLoginResult> loginRoom() async {
//     log("widget.localUserID :: ${widget.localUserID}");
//     log("widget.localUserName :: ${widget.localUserName}");
//     log("widget.roomID :: ${widget.roomID}");
//
//     final user = ZegoUser(widget.localUserID, widget.localUserName);
//
//     final roomID = widget.roomID;
//
//     ZegoRoomConfig roomConfig = ZegoRoomConfig.defaultConfig()..isUserStatusNotify = true;
//
//     return ZegoExpressEngine.instance.loginRoom(roomID, user, config: roomConfig).then((ZegoRoomLoginResult loginRoomResult) async {
//       debugPrint('loginRoom: errorCode:${loginRoomResult.errorCode}, extendedData:${loginRoomResult.extendedData}');
//       if (loginRoomResult.errorCode == 0) {
//         if (widget.isHost) {
//           startPreview();
//           startPublish();
//           var sellerData = jsonEncode({
//             "liveSellerId": sellerId,
//             "liveSellingHistoryId": widget.roomID,
//           });
//           if (socket != null && socket!.connected) {
//             socket!.emit("liveRoomConnect", sellerData);
//           } else {
//             log("Socket is not connected.");
//           }
//         } else {
//           var userData = jsonEncode({
//             "userId": userId,
//             "liveSellingHistoryId": widget.roomID,
//           });
//
//           if (socket != null && socket!.connected) {
//             socket!.emit("addView", userData);
//           } else {
//             log("Socket is not connected.");
//           }
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${St.loginRoomFailed.tr} ${loginRoomResult.errorCode}')));
//       }
//       return loginRoomResult;
//     });
//   }
//
//   Future<ZegoRoomLogoutResult> logoutRoom() async {
//     stopPreview();
//     stopPublish();
//     stopScreenSharing();
//     whenLogoutRoom();
//
//     if (screenSharingSource != null) {
//       ZegoExpressEngine.instance.destroyScreenCaptureSource(screenSharingSource!);
//     }
//     return ZegoExpressEngine.instance.logoutRoom(widget.roomID);
//   }
//
//   whenLogoutRoom() {
//     _scrollController.dispose();
//     SocketManage.comments.clear();
//     var userData = jsonEncode({
//       "userId": userId,
//       "liveSellingHistoryId": widget.roomID,
//     });
//     SocketManage.liveWatchCount.value = 0;
//     socket!.emit("lessView", userData);
//
//     if (widget.isHost) {
//       var endLiveSeller = jsonEncode({
//         "liveSellingHistoryId": widget.roomID,
//       });
//       socket!.emit("endLiveSeller", endLiveSeller);
//     }
//   }
//
//   void startListenEvent() {
//     ZegoExpressEngine.onRoomUserUpdate = (roomID, updateType, List<ZegoUser> userList) {
//       debugPrint('onRoomUserUpdate: roomID: $roomID, updateType: ${updateType.name}, userList: ${userList.map((e) => e.userID)}');
//     };
//     // Callback for updates on the status of the streams in the room.
//     ZegoExpressEngine.onRoomStreamUpdate = (roomID, updateType, List<ZegoStream> streamList, extendedData) {
//       debugPrint('onRoomStreamUpdate: roomID: $roomID, updateType: $updateType, streamList: ${streamList.map((e) => e.streamID)}, extendedData: $extendedData');
//       if (updateType == ZegoUpdateType.Add) {
//         for (final stream in streamList) {
//           startPlayStream(stream.streamID);
//         }
//       } else {
//         for (final stream in streamList) {
//           stopPlayStream(stream.streamID);
//         }
//       }
//
//       if (updateType == ZegoUpdateType.Delete) {
//         if (!widget.isHost) {
//           log("Stop user stream");
//           Get.back();
//         }
//       }
//     };
//     // Callback for updates on the current user's room connection status.
//     ZegoExpressEngine.onRoomStateUpdate = (roomID, state, errorCode, extendedData) {
//       debugPrint('onRoomStateUpdate: roomID: $roomID, state: ${state.name}, errorCode: $errorCode, extendedData: $extendedData');
//     };
//
//     // Callback for updates on the current user's stream publishing changes.
//     ZegoExpressEngine.onPublisherStateUpdate = (streamID, state, errorCode, extendedData) {
//       debugPrint('onPublisherStateUpdate: streamID: $streamID, state: ${state.name}, errorCode: $errorCode, extendedData: $extendedData');
//     };
//     ZegoExpressEngine.onPublisherStateUpdate = (streamID, state, errorCode, extendedData) {
//       debugPrint('onPublisherStateUpdate: streamID: $streamID, state: ${state.name}, errorCode: $errorCode, extendedData: $extendedData');
//     };
//
//     ZegoExpressEngine.onRoomStreamExtraInfoUpdate = (String roomID, List<ZegoStream> streamList) {
//       for (ZegoStream stream in streamList) {
//         try {
//           Map<String, dynamic> extraInfoMap = jsonDecode(stream.extraInfo);
//           if (extraInfoMap['isCameraEnabled'] is bool) {
//             setState(() {
//               isCameraEnabled = extraInfoMap['isCameraEnabled'];
//             });
//           }
//         } catch (e) {
//           debugPrint('streamExtraInfo is not json');
//         }
//       }
//     };
//     ZegoExpressEngine.onApiCalledResult = (int errorCode, String funcName, String info) {
//       if (errorCode != 0) {
//         String errorMessage = 'onApiCalledResult, $funcName failed: $errorCode, $info';
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
//         debugPrint(errorMessage);
//
//         if (funcName == 'startScreenCapture') {
//           stopScreenSharing();
//         }
//       }
//     };
//
//     ZegoExpressEngine.onPlayerVideoSizeChanged = (String streamID, int width, int height) {
//       String message = 'onPlayerVideoSizeChanged: $streamID, ${width}x$height,isLandScape: ${width > height}';
//       debugPrint(message);
//     };
//   }
//
//   void stopListenEvent() {
//     ZegoExpressEngine.onRoomUserUpdate = null;
//     ZegoExpressEngine.onRoomStreamUpdate = null;
//     ZegoExpressEngine.onRoomStateUpdate = null;
//     ZegoExpressEngine.onPublisherStateUpdate = null;
//     ZegoExpressEngine.onApiCalledResult = null;
//     ZegoExpressEngine.onPlayerVideoSizeChanged = null;
//   }
//
//   Future<void> startScreenSharing() async {
//     screenSharingSource ??= (await ZegoExpressEngine.instance.createScreenCaptureSource())!;
//     await ZegoExpressEngine.instance.setVideoConfig(
//       ZegoVideoConfig.preset(ZegoVideoConfigPreset.Preset720P)..fps = 10,
//       channel: ZegoPublishChannel.Aux,
//     );
//     await ZegoExpressEngine.instance.setVideoSource(ZegoVideoSourceType.ScreenCapture, channel: ZegoPublishChannel.Aux);
//     await screenSharingSource!.startCapture();
//     String streamID = '${widget.roomID}_${widget.localUserID}_screen';
//     await ZegoExpressEngine.instance.startPublishingStream(streamID, channel: ZegoPublishChannel.Aux);
//     await ZegoExpressEngine.instance.stopPublishingStream(channel: ZegoPublishChannel.Aux);
//     await ZegoExpressEngine.instance.startPublishingStream(streamID, channel: ZegoPublishChannel.Aux);
//     setState(() => isSharingScreen = true);
//
//     bool needPreview = false;
//     // ignore: dead_code
//     if (needPreview && (hostScreenViewID == null)) {
//       await ZegoExpressEngine.instance.createCanvasView((viewID) async {
//         hostScreenViewID = viewID;
//         ZegoCanvas previewCanvas = ZegoCanvas(viewID, viewMode: ZegoViewMode.AspectFit);
//         ZegoExpressEngine.instance.startPreview(canvas: previewCanvas, channel: ZegoPublishChannel.Aux);
//       }).then((canvasViewWidget) {
//         setState(() => hostScreenView = canvasViewWidget);
//       });
//     }
//   }
//
//   Future<void> stopScreenSharing() async {
//     await screenSharingSource?.stopCapture();
//     await ZegoExpressEngine.instance.stopPreview(channel: ZegoPublishChannel.Aux);
//     await ZegoExpressEngine.instance.stopPublishingStream(channel: ZegoPublishChannel.Aux);
//     await ZegoExpressEngine.instance.setVideoSource(ZegoVideoSourceType.None, channel: ZegoPublishChannel.Aux);
//     if (mounted) setState(() => isSharingScreen = false);
//     if (hostScreenViewID != null) {
//       await ZegoExpressEngine.instance.destroyCanvasView(hostScreenViewID!);
//       if (mounted) {
//         setState(() {
//           hostScreenViewID = null;
//           hostScreenView = null;
//         });
//       }
//     }
//   }
//
//   Future<void> startPreview() async {
//     // cameraView
//     ZegoExpressEngine.instance.enableCamera(true);
//     await ZegoExpressEngine.instance.createCanvasView((viewID) {
//       hostCameraViewID = viewID;
//       ZegoCanvas previewCanvas = ZegoCanvas(viewID, viewMode: ZegoViewMode.AspectFill);
//       ZegoExpressEngine.instance.startPreview(canvas: previewCanvas, channel: ZegoPublishChannel.Main);
//     }).then((canvasViewWidget) {
//       setState(() => hostCameraView = canvasViewWidget);
//     });
//   }
//
//   Future<void> stopPreview() async {
//     ZegoExpressEngine.instance.stopPreview(channel: ZegoPublishChannel.Main);
//     if (hostCameraViewID != null) {
//       await ZegoExpressEngine.instance.destroyCanvasView(hostCameraViewID!);
//       if (mounted) {
//         setState(() {
//           hostCameraViewID = null;
//           hostCameraView = null;
//         });
//       }
//     }
//   }
//
//   Future<void> startPublish() async {
//     String streamID = '${widget.roomID}_${widget.localUserID}_live';
//     return ZegoExpressEngine.instance.startPublishingStream(streamID, channel: ZegoPublishChannel.Main);
//   }
//
//   Future<void> stopPublish() async {
//     return ZegoExpressEngine.instance.stopPublishingStream();
//   }
//
//   Future<void> startPlayStream(String streamID) async {
//     // Start to play streams. Set the view for rendering the remote streams.
//     bool isScreenSharingStream = streamID.endsWith('_screen');
//     await ZegoExpressEngine.instance.createCanvasView((viewID) {
//       if (isScreenSharingStream) {
//         hostScreenViewID = viewID;
//       } else {
//         hostCameraViewID = viewID;
//       }
//       ZegoCanvas canvas = ZegoCanvas(viewID, viewMode: ZegoViewMode.AspectFill);
//       ZegoExpressEngine.instance.startPlayingStream(streamID, canvas: canvas);
//     }).then((canvasViewWidget) {
//       setState(() {
//         if (isScreenSharingStream) {
//           hostScreenView = canvasViewWidget;
//           isSharingScreen = true;
//         } else {
//           hostCameraView = canvasViewWidget;
//         }
//       });
//     });
//   }
//
//   Future<void> stopPlayStream(String streamID) async {
//     bool isScreenSharingStream = streamID.endsWith('_screen');
//
//     ZegoExpressEngine.instance.stopPlayingStream(streamID);
//     if (isScreenSharingStream) {
//       if (hostScreenViewID != null) {
//         ZegoExpressEngine.instance.destroyCanvasView(hostScreenViewID!);
//         if (mounted) {
//           setState(() {
//             hostScreenViewID = null;
//             hostScreenView = null;
//             isSharingScreen = false;
//           });
//         }
//       }
//     } else {
//       if (hostCameraViewID != null) {
//         ZegoExpressEngine.instance.destroyCanvasView(hostCameraViewID!);
//         if (mounted) {
//           setState(() {
//             hostCameraViewID = null;
//             hostCameraView = null;
//           });
//         }
//       }
//     }
//   }
//
//   /// seller add product bottom sheet
// // addProductBottomSheet() {
// //   return StatefulBuilder(
// //     builder: (context, setState1) {
// //       return Container(
// //         height: Get.height / 1.5,
// //         decoration: BoxDecoration(
// //             color: isDark.value ? AppColors.blackBackground : const Color(0xffffffff),
// //             borderRadius: const BorderRadius.vertical(top: Radius.circular(25))),
// //         child: SizedBox(
// //           child: Stack(
// //             children: [
// //               Padding(
// //                 padding: const EdgeInsets.symmetric(horizontal: 15),
// //                 child: Obx(
// //                       () => showCatalogController.isLoading.value
// //                       ? Padding(
// //                     padding: const EdgeInsets.only(top: 75),
// //                     child: Shimmers.productGridviewShimmer(),
// //                   )
// //                       : SingleChildScrollView(
// //                     physics: const BouncingScrollPhysics(),
// //                     child: GetBuilder<ShowCatalogController>(
// //                       builder: (ShowCatalogController showCatalogController) => GridView.builder(
// //                         cacheExtent: 1000,
// //                         physics: const NeverScrollableScrollPhysics(),
// //                         padding: const EdgeInsets.only(top: 75),
// //                         scrollDirection: Axis.vertical,
// //                         shrinkWrap: true,
// //                         itemCount: showCatalogController.catalogItems.length,
// //                         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //                           mainAxisSpacing: 2,
// //                           crossAxisSpacing: 15,
// //                           crossAxisCount: 2,
// //                           mainAxisExtent: 49.2 * 5,
// //                         ),
// //                         itemBuilder: (context, index) {
// //                           return GestureDetector(
// //                             onTap: () {
// //                               setState1(() {
// //                                 selected[index] = !selected[index];
// //
// //                                 debugPrint("Product ID :: ");
// //                                 productId =
// //                                 "${showCatalogController.showCatalogData!.products![index].id}";
// //
// //                                 selected[index]
// //                                     ? liveSelectProductController.getSelectedProductData()
// //                                     : !selected[index];
// //
// //                                 !selected[index]
// //                                     ? liveSelectProductController.getSelectedProductData()
// //                                     : selected[index];
// //
// //                                 selected[index] == true
// //                                     ? showCatalogController.selectedCatalogId
// //                                     .add(showCatalogController.catalogItems[index].id)
// //                                     : showCatalogController.selectedCatalogId
// //                                     .remove(showCatalogController.catalogItems[index].id);
// //                               });
// //                             },
// //                             child: Stack(
// //                               children: [
// //                                 Column(
// //                                   crossAxisAlignment: CrossAxisAlignment.start,
// //                                   children: [
// //                                     Container(
// //                                       height: 180,
// //                                       decoration: BoxDecoration(
// //                                           image: DecorationImage(
// //                                               image: NetworkImage(showCatalogController
// //                                                   .catalogItems[index].mainImage
// //                                                   .toString()),
// //                                               fit: BoxFit.cover),
// //                                           // color: Colors.black,
// //                                           borderRadius: BorderRadius.circular(10)),
// //                                     ),
// //                                     Padding(
// //                                       padding: const EdgeInsets.only(top: 7),
// //                                       child: Text(
// //                                         showCatalogController.catalogItems[index].productName.toString(),
// //                                         style: GoogleFonts.plusJakartaSans(
// //                                           fontSize: 14,
// //                                         ),
// //                                       ),
// //                                     ),
// //                                     Padding(
// //                                       padding: const EdgeInsets.only(top: 7),
// //                                       child: Text(
// //                                         "$currencySymbol${showCatalogController.catalogItems[index].price}",
// //                                         style: GoogleFonts.plusJakartaSans(
// //                                             fontSize: 14, fontWeight: FontWeight.bold),
// //                                       ),
// //                                     ),
// //                                   ],
// //                                 ),
// //                                 Align(
// //                                   alignment: Alignment.topRight,
// //                                   child: Padding(
// //                                     padding: const EdgeInsets.all(8.0),
// //                                     child: GetBuilder<ShowCatalogController>(
// //                                       builder: (showCatalogController) => Image(
// //                                         image: showCatalogController.catalogItems[index].isSelect ==
// //                                             true & selected[index]
// //                                             ? const AssetImage("assets/icons/round check.png")
// //                                             : const AssetImage("assets/icons/round_cheak_selected.png"),
// //                                         height: 20,
// //                                       ),
// //                                     ),
// //                                   ),
// //                                 )
// //                               ],
// //                             ),
// //                           );
// //                         },
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //               Align(
// //                 alignment: Alignment.topCenter,
// //                 child: Container(
// //                   height: 70,
// //                   decoration: BoxDecoration(
// //                     borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
// //                     color: isDark.value ? AppColors.blackBackground : const Color(0xffffffff),
// //                   ),
// //                   child: Padding(
// //                     padding: const EdgeInsets.symmetric(horizontal: 15),
// //                     child: Column(
// //                       children: [
// //                         const SizedBox(
// //                           height: 18,
// //                         ),
// //                         Row(
// //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                           children: [
// //                             SmallTitle(title: St.addProduct),
// //                             Padding(
// //                               padding: const EdgeInsets.only(right: 5),
// //                               child: GestureDetector(
// //                                 onTap: () {
// //                                   Get.back();
// //                                   /*    showCatalogController
// //                                       .getCatalogData()
// //                                       .then((value) =>*/
// //                                   showCatalogController.catalogItems.clear();
// //                                   showCatalogController.start = 1;
// //                                   showCatalogController
// //                                       .getCatalogData()
// //                                       .then((value) => selectedProductForLiveController.getSelectedProduct());
// //                                 },
// //                                 child: Container(
// //                                   height: 30,
// //                                   width: 65,
// //                                   decoration: BoxDecoration(
// //                                       color: AppColors.primaryPink, borderRadius: BorderRadius.circular(6)),
// //                                   child: Center(
// //                                       child: Text(
// //                                         St.done,
// //                                         style: GoogleFonts.plusJakartaSans(
// //                                             fontSize: 12, color: AppColors.white, fontWeight: FontWeight.bold),
// //                                       )),
// //                                 ),
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                         const SizedBox(
// //                           height: 6,
// //                         ),
// //                         Obx(
// //                               () => Divider(
// //                             color: isDark.value ? AppColors.white : AppColors.black,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       );
// //     },
// //   );
// // }
// }
//
// // class DemoButton extends StatelessWidget {
// //   const DemoButton({
// //     Key? key,
// //     required this.onPressed,
// //     required this.text,
// //   }) : super(key: key);
// //
// //   final VoidCallback? onPressed;
// //   final String text;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.all(8.0),
// //       child: SizedBox(
// //         width: 160,
// //         height: 50,
// //         child: ElevatedButton(onPressed: onPressed, child: Text(text)),
// //       ),
// //     );
// //   }
// // }
//

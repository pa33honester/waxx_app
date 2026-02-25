// import 'dart:io';
//
// import 'package:era_shop/Controller/ApiControllers/seller/api_seller_data_controller.dart';
// import 'package:era_shop/View/MyApp/AppPages/cart_page.dart';
// import 'package:era_shop/View/MyApp/AppPages/reels_page/controller/reels_controller.dart';
// import 'package:era_shop/View/MyApp/AppPages/reels_page/view/reels_view.dart';
// import 'package:era_shop/user_pages/home_page/view/home_view.dart';
// import 'package:era_shop/utils/Zego/create_engine.dart';
// import 'package:era_shop/utils/all_images.dart';
// import 'package:era_shop/utils/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../Controller/GetxController/login/api_who_login_controller.dart';
// import '../Profile/main_profile.dart';
// import 'gallary.dart';
// import 'home_page.dart';
//
// // ignore: must_be_immutable
// class BottomTabBar extends StatefulWidget {
//   int? index;
//
//   BottomTabBar({Key? key, this.index}) : super(key: key);
//
//   @override
//   State<BottomTabBar> createState() => _BottomTabBarState();
// }
//
// class _BottomTabBarState extends State<BottomTabBar> {
//   WhoLoginController whoLoginController = Get.put(WhoLoginController());
//   SellerDataController sellerDataController = Get.put(SellerDataController());
//   ReelsController reelsController = Get.put(ReelsController());
//   var pages = [
//     const HomeView(),
//     const Gallery(),
//     // const ShortsView(),
//     const ReelsView(),
//     const CartPage(),
//     const MainProfile(),
//   ];
//
//   int _selectedIndex = 0;
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     createEngine();
//     if (widget.index != null) {
//       setState(() {
//         _selectedIndex = widget.index!;
//       });
//     }
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: SizedBox(
//         height: (Platform.isIOS)
//             ? Get.height / 9
//             : (Platform.isAndroid)
//                 ? Get.height / 13.1
//                 : 0,
//         child: Column(
//           children: [
//             Divider(
//               color: AppColors.darkGrey.withValues(alpha:0.12),
//               thickness: 1.2,
//               height: 0,
//             ),
//             BottomNavigationBar(
//                 items: [
//                   BottomNavigationBarItem(
//                     label: "Home",
//                     icon: _selectedIndex == 0 ? ImageIcon(AssetImage(AppImage.homee)) : ImageIcon(AssetImage(AppImage.home)),
//                   ),
//                   BottomNavigationBarItem(
//                     label: "Gallery",
//                     icon: _selectedIndex == 1 ? ImageIcon(AssetImage(AppImage.gelleryy)) : ImageIcon(AssetImage(AppImage.gellery)),
//                   ),
//                   BottomNavigationBarItem(
//                       icon: _selectedIndex == 2
//                           ? const ImageIcon(AssetImage("assets/bottombar_image/selected/ReelsS.png"))
//                           : const ImageIcon(AssetImage("assets/bottombar_image/unselected/ReelsU.png")),
//                       label: "Shorts"),
//                   BottomNavigationBarItem(
//                     label: "Cart",
//                     icon: _selectedIndex == 3 ? ImageIcon(AssetImage(AppImage.cartImagee)) : ImageIcon(AssetImage(AppImage.cartImage)),
//                   ),
//                   // BottomNavigationBarItem(
//                   //     icon: _selectedIndex == 3
//                   //         ? ImageIcon(AssetImage(AppImage.wishListt))
//                   //         : ImageIcon(AssetImage(AppImage.wishList)),
//                   //     label: "Favorite"),
//                   BottomNavigationBarItem(icon: _selectedIndex == 4 ? ImageIcon(AssetImage(AppImage.profilee)) : ImageIcon(AssetImage(AppImage.profile)), label: "Profile"),
//                 ],
//                 type: BottomNavigationBarType.fixed,
//                 showSelectedLabels: false,
//                 showUnselectedLabels: false,
//                 unselectedItemColor: Colors.grey,
//                 // backgroundColor: AppColors.bgColors,
//                 currentIndex: _selectedIndex,
//                 iconSize: 20,
//                 onTap: _onItemTapped,
//                 elevation: 0),
//           ],
//         ),
//       ),
//       body: pages[_selectedIndex],
//     );
//   }
// }

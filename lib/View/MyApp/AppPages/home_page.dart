// import 'package:waxxapp/utils/CoustomWidget/App_theme_services/textfields.dart';
// import 'package:waxxapp/utils/CoustomWidget/Page_devided/home_page_divided.dart';
// import 'package:waxxapp/utils/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../Controller/GetxController/user/get_live_seller_list_controller.dart';
// import '../../../Controller/GetxController/user/just_for_you_prroduct_controller.dart';
// import '../../../Controller/GetxController/user/new_collection_controller.dart';
//
// class HomePage extends StatelessWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     GetLiveSellerListController getLiveSellerListController = Get.put(GetLiveSellerListController());
//     JustForYouProductController justForYouProductController = Get.put(JustForYouProductController());
//     NewCollectionController newCollectionController = Get.put(NewCollectionController());
//
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: SafeArea(
//         child: Container(
//           height: Get.height,
//           width: Get.width,
//           color: AppColors.background,
//           child: NestedScrollView(
//             headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//               return [
//                 SliverAppBar(
//                   expandedHeight: 122,
//                   pinned: true,
//                   floating: true,
//                   flexibleSpace: FlexibleSpaceBar(
//                     background: Column(
//                       children: [
//                         homePageAppBar(context),
//                       ],
//                     ),
//                   ),
//                   bottom: PreferredSize(
//                     preferredSize: const Size.fromHeight(75),
//                     child: GestureDetector(
//                         onTap: () {
//                           Get.toNamed("/SearchPage");
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                           child: dummySearchField(),
//                         )),
//                   ),
//                 )
//               ];
//             },
//             body: RefreshIndicator(
//               color: AppColors.primary,
//               backgroundColor: AppColors.black,
//               onRefresh: () => Future.wait([
//                 getLiveSellerListController.getSellerList(),
//                 newCollectionController.getNewCollectionData(),
//                 justForYouProductController.getJustForYouProduct()
//               ]),
//               child: SingleChildScrollView(
//                 physics: const BouncingScrollPhysics(),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const HomePageNewCollection(),
//                     const HomePageLiveSelling().paddingOnly(bottom: 10),
//                     const HomePageShorts(),
//                     const HomepageJustForYou(isShowTitle: true).paddingOnly(bottom: 10),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

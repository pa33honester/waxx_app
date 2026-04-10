import 'package:waxxapp/Controller/GetxController/user/get_all_user_address_controller.dart';
import 'package:waxxapp/Controller/GetxController/user/user_add_address_controller.dart';
import 'package:waxxapp/Controller/GetxController/user/user_address_select_controller.dart';
import 'package:waxxapp/View/MyApp/Profile/MyAddress/update_address.dart';
import 'package:waxxapp/custom/simple_app_bar_widget.dart';
import 'package:waxxapp/utils/CoustomWidget/App_theme_services/text_titles.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/Theme/theme_service.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Controller/GetxController/user/delete_address_by_controller.dart';
import '../../../../utils/CoustomWidget/App_theme_services/no_data_found.dart';
import '../../../../utils/app_circular.dart';
import '../../../../utils/show_toast.dart';

class UserAddress extends StatefulWidget {
  const UserAddress({super.key});

  @override
  State<UserAddress> createState() => _UserAddressState();
}

class _UserAddressState extends State<UserAddress> {
  // var isNavigate = Get.arguments;
  GetAllUserAddressController getAllUserAddressController = Get.put(GetAllUserAddressController());
  UserAddAddressController userAddAddressController = Get.put(UserAddAddressController());
  UserAddressSelectController userAddressSelectController = Get.put(UserAddressSelectController());
  DeleteAddressByUserController deleteAddressByUserController = Get.put(DeleteAddressByUserController());

  final isSelectAddress = false;
  bool isSelectingAddress = false;
  int? selectingAddressIndex;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   getAllUserAddressController.getAllUserAddressData(load: true);
  //   super.initState();
  // }

  @override
  void initState() {
    super.initState();
    getAllUserAddressController.getAllUserAddressData(load: true);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WillPopScope(
          onWillPop: () async {
            Get.back();
            return false;
          },
          child: Scaffold(
            backgroundColor: AppColors.black,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: AppColors.transparent,
                shadowColor: AppColors.black.withValues(alpha: 0.4),
                flexibleSpace: SimpleAppBarWidget(title: St.myAddress.tr),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16, bottom: 8),
                    child: GestureDetector(
                      onTap: () {
                        // Get.offNamed("/NewAddress");
                        Get.toNamed("/NewAddress")?.then((value) => getAllUserAddressController.getAllUserAddressData(load: true));
                        userAddAddressController.nameController.clear();
                        userAddAddressController.cityController.clear();
                        userAddAddressController.zipCodeController.clear();
                        userAddAddressController.addressController.clear();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Image(
                          color: AppColors.white,
                          image: const AssetImage("assets/icons/Plus.png"),
                          height: 25,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            body: SafeArea(
              child: SizedBox(
                height: Get.height,
                width: Get.width,
                child: GetBuilder(
                  builder: (GetAllUserAddressController getAllUserAddressController) {
                    return getAllUserAddressController.isLoading.value
                        ? Center(
                            child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ))
                        : getAllUserAddressController.getAllUserAddress!.address!.isEmpty
                            ? noDataFound(
                                image: "assets/no_data_found/openbox.png",
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: getAllUserAddressController.getAllUserAddress?.address?.length ?? 0,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () async {
                                        if (isSelectingAddress) return;
                                        setState(() {
                                          isSelectingAddress = true;
                                          selectingAddressIndex = index;
                                        });
                                        try {
                                          var currentAddress = getAllUserAddressController.getAllUserAddress!.address![index];
                                          if (getAllUserAddressController.getAllUserAddress!.address!.length == 1) {
                                            currentAddress.isSelect = true;
                                          } else {
                                            for (var addr in getAllUserAddressController.getAllUserAddress!.address!) {
                                              addr.isSelect = false;
                                            }
                                            currentAddress.isSelect = true;
                                          }
                                          setState(() {});
                                          if (currentAddress.isSelect == true) {
                                            addressId = currentAddress.id!;
                                            await userAddressSelectController.userSelectAddressData(addressId: addressId);
                                            if (userAddressSelectController.userAddressSelect?.status == true) {
                                              await getAllUserAddressController.getAllUserAddressData(load: false);
                                            }
                                          }
                                        } catch (e) {
                                          print('Error selecting address: $e');
                                          displayToast(message: 'Error selecting address');
                                        } finally {
                                          setState(() {
                                            isSelectingAddress = false;
                                            selectingAddressIndex = null;
                                          });
                                        }
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 12),
                                        decoration: BoxDecoration(
                                          color: AppColors.tabBackground,
                                          borderRadius: BorderRadius.circular(16),
                                          // border: getAllUserAddressController.getAllUserAddress!.address![index].isSelect == true ? Border.all(color: AppColors.primaryPink, width: 2) : Border.all(color: Colors.transparent, width: 2),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  SmallTitle(title: "${getAllUserAddressController.getAllUserAddress?.address![index].name}"),
                                                  const Spacer(),
                                                  AnimatedContainer(
                                                    duration: Duration(milliseconds: 200),
                                                    height: 24,
                                                    width: 24,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: getAllUserAddressController.getAllUserAddress!.address![index].isSelect == true ? AppColors.primaryPink : Colors.transparent,
                                                      border: Border.all(
                                                        color: getAllUserAddressController.getAllUserAddress!.address![index].isSelect == true ? AppColors.primaryPink : Colors.grey.shade400,
                                                        width: 2,
                                                      ),
                                                    ),
                                                    child: getAllUserAddressController.getAllUserAddress!.address![index].isSelect == true ? const Icon(Icons.check, color: Colors.black, size: 16) : null,
                                                  ),
                                                ],
                                              ),
                                              8.height,
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Icon(
                                                    Icons.location_on_outlined,
                                                    color: Colors.grey.shade600,
                                                    size: 20,
                                                  ),
                                                  SizedBox(width: 6),
                                                  Expanded(
                                                    child: Text(
                                                      _buildAddressString(index),
                                                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              14.height,
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Material(
                                                      color: Colors.blue[50],
                                                      borderRadius: BorderRadius.circular(12),
                                                      child: InkWell(
                                                        borderRadius: BorderRadius.circular(12),
                                                        onTap: getStorage.read("isDemoLogin") ?? false || isDemoSeller == true
                                                            ? () => displayToast(message: St.thisIsDemoUser.tr)
                                                            : () {
                                                                var data = getAllUserAddressController.getAllUserAddress!.address![index];
                                                                addressId = getAllUserAddressController.getAllUserAddress!.address![index].id.toString();
                                                                Get.to(() => UpdateAddress(
                                                                      getName: data.name,
                                                                      getCountry: data.country,
                                                                      getState: data.state,
                                                                      getCity: data.city,
                                                                      getZipCode: data.zipCode,
                                                                      getAddress: data.address,
                                                                    ))?.then((value) => getAllUserAddressController.getAllUserAddressData(load: true));
                                                              },
                                                        child: Container(
                                                          height: 40,
                                                          padding: EdgeInsets.symmetric(horizontal: 16),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Icon(
                                                                Icons.edit_outlined,
                                                                color: Colors.blue[700],
                                                                size: 18,
                                                              ),
                                                              SizedBox(width: 8),
                                                              Text(
                                                                St.changeAddress.tr,
                                                                style: TextStyle(
                                                                  color: Colors.blue[700],
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w600,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 12),
                                                  GestureDetector(
                                                    onTap: getStorage.read("isDemoLogin") ?? false || isDemoSeller == true
                                                        ? () => displayToast(message: St.thisIsDemoUser.tr)
                                                        : () async {
                                                            await deleteAddressByUserController.deleteAddress(addressId: getAllUserAddressController.getAllUserAddress!.address![index].id.toString());
                                                            if (deleteAddressByUserController.deleteAddressByUser!.status == true) {
                                                              getAllUserAddressController.getAllUserAddressData(load: false);
                                                            }
                                                          },
                                                    child: Container(
                                                      height: 40,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                        color: AppColors.redBackground,
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      child: Image.asset("assets/icons/delete_address.png").paddingAll(12),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                // child: ListView.builder(
                                //   physics: const BouncingScrollPhysics(),
                                //   itemCount: getAllUserAddressController.getAllUserAddress?.address?.length ?? 0,
                                //   shrinkWrap: true,
                                //   itemBuilder: (context, index) {
                                //     return Padding(
                                //       padding: const EdgeInsets.symmetric(horizontal: 05, vertical: 10),
                                //       child: GestureDetector(
                                //         onTap: () {
                                //           setState(() {
                                //             var currentAddress = getAllUserAddressController.getAllUserAddress!.address![index];
                                //
                                //             if (getAllUserAddressController.getAllUserAddress!.address!.length == 1) {
                                //               currentAddress.isSelect = true;
                                //             } else {
                                //               currentAddress.isSelect = !(currentAddress.isSelect ?? false);
                                //             }
                                //
                                //             if (currentAddress.isSelect == true) {
                                //               addressId = currentAddress.id!;
                                //               userAddressSelectController.userSelectAddressData(addressId: addressId).then((value) => getAllUserAddressController.getAllUserAddressData(load: false));
                                //             }
                                //           });
                                //           // setState(() {
                                //           //   getAllUserAddressController.getAllUserAddress!.address![index].isSelect =
                                //           //       !(getAllUserAddressController.getAllUserAddress!.address![index].isSelect ?? false);
                                //           // });
                                //           //
                                //           // if (getAllUserAddressController.getAllUserAddress!.address![index].isSelect == true) {
                                //           //   addressId = "${getAllUserAddressController.getAllUserAddress?.address![index].id!}";
                                //           //   userAddressSelectController
                                //           //       .userSelectAddressData(addressId: addressId)
                                //           //       .then((value) => getAllUserAddressController.getAllUserAddressData(load: false));
                                //           // }
                                //         },
                                //         child: Container(
                                //           width: double.maxFinite,
                                //           // color: Colors.transparent,
                                //           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                //           decoration: BoxDecoration(
                                //             color: AppColors.tabBackground,
                                //             borderRadius: BorderRadius.circular(16),
                                //           ),
                                //           child: Column(
                                //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //             crossAxisAlignment: CrossAxisAlignment.start,
                                //             children: [
                                //               Row(
                                //                 children: [
                                //                   SmallTitle(title: "${getAllUserAddressController.getAllUserAddress?.address![index].name}"),
                                //                   const Spacer(),
                                //                   SizedBox(
                                //                     child: getAllUserAddressController.getAllUserAddress!.address![index].isSelect == true
                                //                         ? Container(
                                //                             height: 24,
                                //                             width: 24,
                                //                             decoration: BoxDecoration(
                                //                               shape: BoxShape.circle,
                                //                               color: AppColors.primaryPink,
                                //                             ),
                                //                             child: const Icon(Icons.done_outlined, color: Colors.black, size: 15),
                                //                           )
                                //                         : Container(
                                //                             height: 24,
                                //                             width: 24,
                                //                             decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade400)),
                                //                           ),
                                //                   ),
                                //                 ],
                                //               ),
                                //               Text(
                                //                 _buildAddressString(index),
                                //                 style: AppFontStyle.styleW500(Colors.grey.shade600, 12),
                                //                 maxLines: 2,
                                //               ).paddingOnly(left: 4, right: 30, bottom: 6),
                                //               Row(
                                //                 crossAxisAlignment: CrossAxisAlignment.start,
                                //                 children: [
                                //                   GestureDetector(
                                //                     onTap: isDemoSeller == true
                                //                         ? () => displayToast(message: St.thisIsDemoApp.tr)
                                //                         : () {
                                //                             var data = getAllUserAddressController.getAllUserAddress!.address![index];
                                //                             addressId = getAllUserAddressController.getAllUserAddress!.address![index].id.toString();
                                //                             Get.to(() => UpdateAddress(
                                //                                   getName: data.name,
                                //                                   getCountry: data.country,
                                //                                   getState: data.state,
                                //                                   getCity: data.city,
                                //                                   getZipCode: data.zipCode,
                                //                                   getAddress: data.address,
                                //                                 ))?.then((value) => getAllUserAddressController.getAllUserAddressData(load: true));
                                //                           },
                                //                     child: Padding(
                                //                       padding: const EdgeInsets.only(top: 3),
                                //                       child: Container(
                                //                         height: 32,
                                //                         width: Get.width / 2.7,
                                //                         decoration: BoxDecoration(color: AppColors.redBackground, borderRadius: BorderRadius.circular(8)),
                                //                         child: Center(
                                //                           child: Text(St.changeAddress.tr, style: AppFontStyle.styleW500(AppColors.red, 13)),
                                //                         ),
                                //                       ),
                                //                     ),
                                //                   ),
                                //                   GestureDetector(
                                //                     onTap: isDemoSeller == true
                                //                         ? () => displayToast(message: St.thisIsDemoApp.tr)
                                //                         : () async {
                                //                             await deleteAddressByUserController.deleteAddress(addressId: getAllUserAddressController.getAllUserAddress!.address![index].id.toString());
                                //                             if (deleteAddressByUserController.deleteAddressByUser!.status == true) {
                                //                               getAllUserAddressController.getAllUserAddressData(load: false);
                                //                             }
                                //                           },
                                //                     child: Padding(
                                //                       padding: const EdgeInsets.only(top: 3),
                                //                       child: Container(
                                //                         height: 32,
                                //                         width: 32,
                                //                         decoration: BoxDecoration(
                                //                           color: AppColors.redBackground,
                                //                           borderRadius: BorderRadius.circular(8),
                                //                         ),
                                //                         child: Image.asset("assets/icons/delete_address.png").paddingAll(6.5),
                                //                       ),
                                //                     ),
                                //                   ).paddingOnly(left: 7, bottom: 5),
                                //                 ],
                                //               ),
                                //             ],
                                //           ),
                                //         ),
                                //       ),
                                //     );
                                //   },
                                // ),
                              );
                  },
                ),
              ),
            ),
          ),
        ),
        Obx(
          () => userAddressSelectController.isLoading.value || deleteAddressByUserController.isLoading.value ? ScreenCircular.blackScreenCircular() : const SizedBox(),
        )
      ],
    );
  }

  String _buildAddressString(int index) {
    final addr = getAllUserAddressController.getAllUserAddress?.address![index];
    final parts = [
      addr?.address,
      if (addr?.city?.isNotEmpty ?? false) addr?.city,
      if (addr?.state?.isNotEmpty ?? false) addr?.state,
      addr?.country,
      if (addr?.zipCode != null) addr!.zipCode.toString(),
    ].where((element) => element != null && element.isNotEmpty).toList();

    return parts.join(', ');
  }
}

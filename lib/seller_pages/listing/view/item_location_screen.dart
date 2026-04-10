import 'package:waxxapp/View/MyApp/Profile/MyAddress/widget/address_select_sheet.dart';
import 'package:waxxapp/seller_pages/listing/controller/listing_controller.dart';
import 'package:waxxapp/seller_pages/listing/widget/listing_app_bar_widget.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/app_constant.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/show_toast.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemLocationScreen extends StatelessWidget {
  const ItemLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ListingController>(
      id: AppConstant.idCountries,
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: GetBuilder<ListingController>(
              builder: (controller) {
                return ListingAppBarWidget(
                  title: St.itemLocation.tr,
                  showCheckIcon: true,
                  isCheckEnabled: controller.countryController.text.isNotEmpty || controller.stateController.text.isNotEmpty || controller.cityController.text.isNotEmpty,
                  onCheckTap: () {
                    Get.back();
                  },
                );
              },
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.height,
                Text(
                  St.pleaseProvideItemLocationForYourListing.tr,
                  style: AppFontStyle.styleW500(AppColors.unselected, 14),
                ),
                40.height,
                Text(
                  St.country.tr,
                  style: AppFontStyle.styleW500(AppColors.white, 14),
                ),
                10.height,
                GestureDetector(
                  onTap: () {
                    addressSelectSheet(
                        onStateTap: (value) {},
                        hintText: St.searchCountry.tr,
                        context: context,
                        countries: controller.countries,
                        controller: controller.countryController,
                        onTap: (value) {
                          controller.countryController.text = value;
                          controller.updateStatesData(value);
                        });
                  },
                  child: Container(
                    height: 55,
                    width: Get.width,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: AppColors.tabBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            controller: controller.countryController,
                            style: AppFontStyle.styleW700(AppColors.white, 14),
                            enabled: false,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: St.country.tr,
                              hintStyle: AppFontStyle.styleW500(AppColors.unselected, 14),
                            ),
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down_rounded, size: 25, color: AppColors.unselected),
                      ],
                    ),
                  ),
                ),
                25.height,
                if (controller.selectedCountryData != null && controller.selectedCountryData!.states != null && controller.selectedCountryData!.states!.isNotEmpty) ...{
                  Text(
                    St.state.tr,
                    style: AppFontStyle.styleW500(AppColors.white, 14),
                  ),
                  10.height,
                  GestureDetector(
                    onTap: () {
                      if (controller.countryController.text.isNotEmpty) {
                        addressSelectSheet(
                            updateStateValue: true,
                            isStateValue: true,
                            onStateTap: (value) {
                              controller.stateController.text = value;
                            },
                            hintText: St.searchState.tr,
                            context: context,
                            countries: controller.states,
                            controller: controller.stateController,
                            onTap: (value) {
                              controller.updateCityData(value);
                              controller.cityController.clear();
                            });
                      } else {
                        displayToast(message: St.pleaseSelectCountry.tr);
                      }
                    },
                    child: Container(
                      height: 55,
                      width: Get.width,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: AppColors.tabBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              controller: controller.stateController,
                              style: AppFontStyle.styleW700(AppColors.white, 14),
                              enabled: false,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: St.stateTFHintText.tr,
                                hintStyle: AppFontStyle.styleW500(AppColors.unselected, 14),
                              ),
                            ),
                          ),
                          Icon(Icons.keyboard_arrow_down_rounded, size: 25, color: AppColors.unselected),
                        ],
                      ),
                    ),
                  ),
                  25.height,
                },
                if (controller.selectedStateData != null && controller.selectedStateData!.cities != null && controller.selectedStateData!.cities!.isNotEmpty) ...{
                  Text(
                    St.city.tr,
                    style: AppFontStyle.styleW500(AppColors.white, 14),
                  ),
                  10.height,
                  GestureDetector(
                    onTap: () {
                      if (controller.countryController.text.isNotEmpty && controller.stateController.text.isNotEmpty) {
                        addressSelectSheet(
                            updateStateValue: true,
                            isStateValue: true,
                            onStateTap: (value) {
                              controller.cityController.text = value;
                            },
                            hintText: St.searchCity.tr,
                            context: context,
                            countries: controller.city,
                            controller: controller.cityController,
                            // userAddAddressController: userAddAddressController,
                            onTap: (value) {});
                      } else if (controller.countryController.text.isEmpty && controller.stateController.text.isEmpty) {
                        displayToast(message: St.pleaseSelectCountryAndState.tr);
                      } else if (controller.stateController.text.isEmpty) {
                        displayToast(message: St.pleaseSelectState.tr);
                      } else {
                        displayToast(message: St.pleaseSelectCountry.tr);
                      }
                    },
                    child: Container(
                      height: 55,
                      width: Get.width,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: AppColors.tabBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              controller: controller.cityController,
                              style: AppFontStyle.styleW700(AppColors.white, 14),
                              enabled: false,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: St.cityTFHintText.tr,
                                hintStyle: AppFontStyle.styleW500(AppColors.unselected, 14),
                              ),
                            ),
                          ),
                          Icon(Icons.keyboard_arrow_down_rounded, size: 25, color: AppColors.unselected),
                        ],
                      ),
                    ),
                  ),
                },
                25.height,
              ],
            ),
          ),
        );
      },
    );
  }
}

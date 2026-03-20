import 'dart:convert';
import 'dart:developer';

import 'package:waxxapp/Controller/GetxController/seller/seller_common_controller.dart';
import 'package:waxxapp/View/MyApp/Profile/MyAddress/widget/address_select_sheet.dart';
import 'package:waxxapp/View/MyApp/Seller/SellerAccount/seller_login.dart';
import 'package:waxxapp/custom/custom_color_bg_widget.dart';
import 'package:waxxapp/custom/main_button_widget.dart';
import 'package:waxxapp/custom/simple_app_bar_widget.dart';
import 'package:waxxapp/model/ConutryDataModel.dart' as countryData;
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/Zego/ZegoUtils/device_orientation.dart';
import 'package:waxxapp/utils/app_asset.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/show_toast.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SellerAddressDetails extends StatefulWidget {
  const SellerAddressDetails({super.key});

  @override
  State<SellerAddressDetails> createState() => _SellerAddressDetailsState();
}

class _SellerAddressDetailsState extends State<SellerAddressDetails> {
  SellerCommonController controller = Get.put(SellerCommonController());
  TextEditingController sheetCountryController = TextEditingController();
  TextEditingController sheetStateController = TextEditingController();
  TextEditingController sheetCityController = TextEditingController();
  List<String>? countries = [];
  List<String>? states = [];
  List<String>? city = [];

  List<countryData.ConutryDataModel> countryList = [];
  List<countryData.StateData>? statesList;
  List<Map<String, dynamic>> countriesData = [];
  countryData.ConutryDataModel? selectedCountryData;
  countryData.StateData? selectedStateData;

  @override
  void initState() {
    loadJsonData();
    super.initState();
  }

  Future<void> loadData() async {
    String jsonContent = await rootBundle.loadString('assets/data/countries.json');
    Map<String, dynamic> data = jsonDecode(jsonContent);
    List<dynamic> countriesList = data['countries'];
    countriesData = List<Map<String, dynamic>>.from(countriesList);
    countries = countriesData.map((item) => item['country']).cast<String>().toList();
    states = [];
  }

  Future<void> loadJsonData() async {
    String jsonContent = await rootBundle.loadString('assets/data/country_state_city.json');
    final data = jsonDecode(jsonContent);
    List list = data;

    countryList = list.map((e) => countryData.ConutryDataModel.fromJson(e)).toList();
    countries = countryList.map((e) => e.countryName.toString()).toList();
  }

  void updateStatesData(String selectedCountry) {
    selectedCountryData = countryList.firstWhereOrNull((element) => element.countryName == selectedCountry);
    statesList = selectedCountryData?.states;
    states = selectedCountryData?.states?.map((e) => e.stateName.toString()).toList();

    // Clear state and city when country changes
    controller.stateController.clear();
    controller.cityController.clear();
    city = [];
    selectedStateData = null;

    setState(() {});
  }

  void updateCityData(String selectedStateName) {
    selectedStateData = statesList?.firstWhereOrNull((element) => element.stateName == selectedStateName);
    city = selectedStateData?.cities?.map((e) => e.cityName.toString()).toList();

    // Clear city when state changes
    controller.cityController.clear();

    setState(() {});
  }
  // Future<void> loadJsonData() async {
  //   String jsonContent = await rootBundle.loadString('assets/data/country_state_city.json');
  //   final data = jsonDecode(jsonContent);
  //   List list = data;
  //
  //   countryList = list.map((e) => countryData.ConutryDataModel.fromJson(e)).toList();
  //   countries = countryList.map((e) => e.countryName.toString()).toList();
  //   updateStatesData(controller.countryController.text);
  // }

  // void updateStatesData(String selectedCountry) {
  //   final selectedCountryData = countryList.firstWhereOrNull((element) => element.countryName == selectedCountry);
  //   statesList = selectedCountryData?.states;
  //   states = selectedCountryData?.states?.map((e) => e.stateName.toString()).toList();
  //   updateCityData(controller.stateController.text);
  //
  //   setState(() {});
  // }

  // void updateCityData(String selectedStateName) {
  //   countryData.StateData? tempData = statesList?.firstWhereOrNull((element) => element.stateName == selectedStateName);
  //   city = tempData?.cities?.map((e) => e.cityName.toString()).toList();
  //
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return CustomColorBgWidget(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.transparent,
            surfaceTintColor: AppColors.transparent,
            flexibleSpace: SimpleAppBarWidget(title: St.sellerAccount.tr),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                15.height,
                Center(child: Image.asset(AppAsset.icStoreProduct, color: AppColors.primary, height: 50, fit: BoxFit.cover, width: 50)),
                15.height,
                Center(
                  child: Text(
                    St.completeSellerAccount.tr,
                    style: AppFontStyle.styleW900(AppColors.primary, 20),
                    textAlign: TextAlign.center,
                  ),
                ),
                10.height,
                Center(
                  child: Text(
                    St.securelyProcessYourPayment.tr,
                    style: AppFontStyle.styleW500(AppColors.unselected, 12),
                  ),
                ),
                50.height,

                SellerItemWidget(
                  hintText: St.enterBusinessAddress.tr,
                  title: St.businessAddress.tr,
                  keyboardType: TextInputType.name,
                  controller: controller.businessAddressController,
                ),
                25.height,
                SellerItemWidget(
                  hintText: St.enterLandmark.tr,
                  title: St.landmark.tr,
                  keyboardType: TextInputType.name,
                  controller: controller.landmarkController,
                ),
                // 25.height,
                // SellerItemWidget(
                //   title: St.city.tr,
                //   keyboardType: TextInputType.name,
                //   controller: controller.accountNoController,
                // ),
                25.height,
                SellerItemWidget(
                  hintText: St.enterPinCode.tr,
                  title: St.pinCode.tr,
                  keyboardType: TextInputType.number,
                  controller: controller.pinCodeController,
                ),
                25.height,

                // Text(
                //   St.completeAddressDetails.tr,
                //   style: isDark.value ? SignInTitleStyle.whiteTitle : SignInTitleStyle.blackTitle,
                // ),

                // Padding(
                //   padding: const EdgeInsets.only(top: 10),
                //   child: Text(
                //     St.fillRequiredField.tr,
                //     style: GoogleFonts.plusJakartaSans(color: AppColors.darkGrey),
                //   ),
                // ),
                // const SizedBox(
                //   height: 50,
                // ),
                // PrimaryTextField(
                //   titleText: St.address.tr,
                //   hintText: St.enterAddress.tr,
                //   controllerType: "Address",
                // ),
                // const SizedBox(height: 15),
                // PrimaryTextField(
                //   titleText: St.landmark.tr,
                //   hintText: St.enterLandmark.tr,
                //   controllerType: "Landmark",
                // ),
                // const SizedBox(height: 15),
                // PrimaryTextField(
                //   titleText: St.city.tr,
                //   hintText: St.enterCity.tr,
                //   controllerType: "City",
                // ),
                // PrimaryTextField(
                //   titleText: St.pinCode.tr,
                //   hintText: St.pinCodeHintText.tr,
                //   controllerType: "Pincode",
                // ),
                // const SizedBox(height: 15),
                Text(
                  St.country.tr,
                  style: AppFontStyle.styleW500(AppColors.unselected, 12),
                ),
                10.height,
                GestureDetector(
                  onTap: () {
                    addressSelectSheet(
                        onStateTap: (value) {},
                        hintText: St.searchCountry.tr,
                        context: context,
                        countries: countries,
                        controller: sheetCountryController,
                        // userAddAddressController: userAddAddressController,

                        onTap: (value) {
                          controller.countryController.text = value;
                          log("message>>>>>>>>>>${controller.countryController.text}");
                          updateStatesData(value);
                          controller.stateController.clear();
                          controller.cityController.clear();
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
                              hintStyle: AppFontStyle.styleW600(AppColors.unselected, 12),
                            ),
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down_rounded, size: 25, color: AppColors.unselected),
                      ],
                    ),
                  ),
                ),
                25.height,
                if (selectedCountryData != null && selectedCountryData!.states != null && selectedCountryData!.states!.isNotEmpty) ...{
                  Text(
                    "State",
                    style: AppFontStyle.styleW500(AppColors.unselected, 12),
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
                            countries: states,
                            controller: sheetStateController,
                            // userAddAddressController: userAddAddressController,
                            onTap: (value) {
                              updateCityData(value);
                              controller.cityController.clear();
                            });
                      } else {
                        displayToast(message: "Please Select country");
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
                                hintStyle: AppFontStyle.styleW600(AppColors.unselected, 12),
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
                if (selectedStateData != null && selectedStateData!.cities != null && selectedStateData!.cities!.isNotEmpty) ...{
                  Text(
                    St.city.tr,
                    style: AppFontStyle.styleW500(AppColors.unselected, 12),
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
                            countries: city,
                            controller: sheetCityController,
                            // userAddAddressController: userAddAddressController,
                            onTap: (value) {});
                      } else if (controller.countryController.text.isEmpty && controller.stateController.text.isEmpty) {
                        displayToast(message: "Please Select country and state");
                      } else if (controller.stateController.text.isEmpty) {
                        displayToast(message: "Please Select state");
                      } else {
                        displayToast(message: "Please Select country");
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
                                hintStyle: AppFontStyle.styleW600(AppColors.unselected, 12),
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
        ),
        bottomNavigationBar: MainButtonWidget(
          height: 55,
          width: Get.width,
          margin: const EdgeInsets.all(15),
          color: AppColors.primary,
          child: Text(
            St.nextText.tr.toUpperCase(),
            style: AppFontStyle.styleW700(AppColors.black, 16),
          ),
          callback: () => onSubmitSellerAddressDetails(),
        ),
      ),
    );
  }

  Future<void> onSubmitSellerAddressDetails() async {
    if (controller.businessAddressController.text.trim().isEmpty) {
      Utils.showToast("Please enter business address !!");
    } else if (controller.landmarkController.text.trim().isEmpty) {
      Utils.showToast("Please enter landmark !!");
    } else if (controller.pinCodeController.text.trim().isEmpty) {
      Utils.showToast("Please enter pin code number !!");
    } else if (controller.countryController.text.trim().isEmpty) {
      Utils.showToast("Please enter country !!");
    } else {
      // final businessAddress = controller.businessAddressController.text.trim();
      // final landmark = controller.landmarkController.text.trim();
      // final pinCode = controller.pinCodeController.text.trim();
      // final country = controller.countryController.text.trim();
      final state = controller.stateController.text.trim();
      final city = controller.cityController.text.trim();

      if (selectedCountryData != null && selectedCountryData?.states != null && selectedCountryData!.states!.isNotEmpty) {
        if (state.isEmpty) {
          displayToast(message: "Please select a state");
          return;
        }
        // selectedStateData = selectedCountryData?.states!.firstWhereOrNull((s) => s.stateName == state);
        if (selectedStateData != null && selectedStateData?.cities != null && selectedStateData!.cities!.isNotEmpty) {
          if (city.isEmpty) {
            displayToast(message: "Please select a city");
            return;
          }
        }
      }
      Get.toNamed("/SellerAccountDetails");
    }
  }
}

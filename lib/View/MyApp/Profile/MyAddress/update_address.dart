import 'dart:convert';

import 'package:era_shop/Controller/GetxController/seller/seller_edit_profile_controller.dart';
import 'package:era_shop/Controller/GetxController/user/get_all_user_address_controller.dart';
import 'package:era_shop/Controller/GetxController/user/user_add_address_controller.dart';
import 'package:era_shop/Controller/GetxController/user/user_update_address_controller.dart';
import 'package:era_shop/View/MyApp/Profile/MyAddress/widget/address_select_sheet.dart';
import 'package:era_shop/custom/simple_app_bar_widget.dart';
import 'package:era_shop/model/ConutryDataModel.dart' as countryData;
import 'package:era_shop/utils/CoustomWidget/App_theme_services/primary_buttons.dart';
import 'package:era_shop/utils/CoustomWidget/App_theme_services/textfields.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/Zego/ZegoUtils/device_orientation.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/font_style.dart';

class UpdateAddress extends StatefulWidget {
  final String? getName;
  final String? getCountry;
  final String? getState;
  final String? getCity;
  final int? getZipCode;
  final String? getAddress;
  const UpdateAddress({
    Key? key,
    this.getAddress,
    this.getName,
    this.getCountry,
    this.getState,
    this.getCity,
    this.getZipCode,
  }) : super(key: key);

  @override
  State<UpdateAddress> createState() => _UpdateAddressState();
}

class _UpdateAddressState extends State<UpdateAddress> {
  List<Map<String, dynamic>> countriesData = [];
  List<String>? countries = [];
  List<String>? states = [];
  String? selectedCountry;
  String? selectedState;

  UserAddAddressController userAddAddressController = Get.put(UserAddAddressController());
  GetAllUserAddressController getAllUserAddressController = Get.put(GetAllUserAddressController());
  UserUpdateAddressController userUpdateAddressController = Get.put(UserUpdateAddressController());

  SellerEditProfileController sellerEditProfileController = Get.put(SellerEditProfileController());

  Future<void> loadJsonData() async {
    String jsonContent = await rootBundle.loadString('assets/data/country_state_city.json');
    final data = jsonDecode(jsonContent);
    List list = data;

    countryList = list.map((e) => countryData.ConutryDataModel.fromJson(e)).toList();
    countries = countryList.map((e) => e.countryName.toString()).toList();
    updateStatesData(widget.getCountry ?? "");
  }

  List<String>? city = [];
  void updateStatesData(String selectedCountry) {
    final selectedCountryData = countryList.firstWhereOrNull((element) => element.countryName == selectedCountry);
    statesList = selectedCountryData?.states;
    states = selectedCountryData?.states?.map((e) => e.stateName.toString()).toList();
    updateCityData(widget.getState ?? "");
  }

  List<countryData.StateData>? statesList;
  void updateCityData(String selectedStateName) {
    countryData.StateData? tempData = statesList?.firstWhereOrNull((element) => element.stateName == selectedStateName);
    city = tempData?.cities?.map((e) => e.cityName.toString()).toList();

    setState(() {});
  }

  List<countryData.ConutryDataModel> countryList = [];

  @override
  void initState() {
    super.initState();
    userAddAddressController.nameController.text = widget.getName!;

    userAddAddressController.zipCodeController.text = widget.getZipCode!.toString();
    userAddAddressController.addressController.text = widget.getAddress!;
    userAddAddressController.selectedCountry = widget.getCountry;
    userAddAddressController.selectedState = widget.getState;
    userAddAddressController.myCountryController.text = widget.getCountry ?? "";
    userAddAddressController.myStateController.text = widget.getState ?? "";
    userAddAddressController.myCityController.text = widget.getCity ?? "";

    loadJsonData();
  }

  TextEditingController countryController = TextEditingController();
  TextEditingController stateCountroller = TextEditingController();
  TextEditingController cityCountroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: PrimaryPinkButton(
            onTaped: () {
              userUpdateAddressController.userUpdateAddress(country: userAddAddressController.myCountryController.text, state: userAddAddressController.myStateController.text, city: userAddAddressController.myCityController.text);
            },
            text: St.updateAddress.tr),
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.transparent,
          shadowColor: AppColors.black.withValues(alpha: 0.4),
          flexibleSpace: SimpleAppBarWidget(title: St.updateAddress.tr),
        ),
      ),
      body: SafeArea(
          child: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 25,
                ),
                PrimaryTextField(
                  titleText: St.fullNameTFTitle.tr,
                  hintText: St.fullNameTFHintText.tr,
                  controllerType: "UserAddressName",
                ),
                const SizedBox(height: 18),
                PrimaryTextField(
                  titleText: St.country.tr,
                  readOnly: true,
                  hintText: St.selectCountry.tr,
                  controllerType: "myCountryController",
                  suffixIcon: Icon(Icons.keyboard_arrow_down_outlined, color: Colors.grey.shade400),
                  onTap: () {
                    addressSelectSheet(
                        sellerEditProfileController: sellerEditProfileController,
                        onStateTap: (value) {},
                        hintText: St.searchCountry.tr,
                        context: context,
                        countries: countries,
                        controller: countryController,
                        userAddAddressController: userAddAddressController,
                        onTap: (value) {
                          updateStatesData(value);
                          userAddAddressController.myStateController.clear();
                          userAddAddressController.myCityController.clear();
                        });
                  },
                ),
                const SizedBox(height: 18),

                PrimaryTextField(
                  titleText: St.stateTFTitle.tr,
                  readOnly: true,
                  hintText: St.stateTFHintText.tr,
                  controllerType: "myStateController",
                  suffixIcon: Icon(Icons.keyboard_arrow_down_outlined, color: Colors.grey.shade400),
                  onTap: () {
                    if (userAddAddressController.myCountryController.text.isNotEmpty) {
                      addressSelectSheet(
                          sellerEditProfileController: sellerEditProfileController,
                          isStateValue: true,
                          onStateTap: (value) {
                            userAddAddressController.myStateController.text = value;
                          },
                          hintText: St.searchState.tr,
                          context: context,
                          countries: states,
                          controller: stateCountroller,
                          userAddAddressController: userAddAddressController,
                          onTap: (value) {
                            updateCityData(value);
                            userAddAddressController.myCityController.clear();
                          });
                    } else {
                      displayToast(message: "Please Select country");
                    }
                  },
                ),
                const SizedBox(height: 18),
                PrimaryTextField(
                  titleText: St.cityTFTitle.tr,
                  readOnly: true,
                  hintText: St.cityTFHintText.tr,
                  controllerType: "myCityController",
                  suffixIcon: Icon(Icons.keyboard_arrow_down_outlined, color: Colors.grey.shade400),
                  onTap: () {
                    if (userAddAddressController.myCountryController.text.isNotEmpty && userAddAddressController.myStateController.text.isNotEmpty) {
                      addressSelectSheet(
                          isStateValue: true,
                          onStateTap: (value) {
                            userAddAddressController.myCityController.text = value;
                          },
                          hintText: St.searchCity.tr,
                          context: context,
                          countries: city,
                          controller: cityCountroller,
                          userAddAddressController: userAddAddressController,
                          onTap: (value) {
                            userAddAddressController.myCityController.text = value;
                          });
                    } else if (userAddAddressController.myCountryController.text.isEmpty && userAddAddressController.myStateController.text.isEmpty) {
                      displayToast(message: "Please Select country and state");
                    } else if (userAddAddressController.myStateController.text.isEmpty) {
                      displayToast(message: "Please Select state");
                    } else {
                      displayToast(message: "Please Select country");
                    }
                  },
                ),
                // const SizedBox(height: 25),
                // PrimaryTextField(
                //   titleText: St.cityTFTitle.tr,
                //   hintText: St.cityTFHintText.tr,
                //   controllerType: "UserCity",
                // ),
                const SizedBox(height: 25),
                PrimaryTextField(
                  titleText: St.zipCode.tr,
                  hintText: St.zipCodeHintText.tr,
                  controllerType: "ZipCode",
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    St.detailAddress.tr,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextField(
                  controller: userAddAddressController.addressController,
                  maxLines: 7,
                  minLines: 4,
                  style: AppFontStyle.styleW700(AppColors.white, 14),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.tabBackground,
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryPink), borderRadius: BorderRadius.circular(26)),
                    hintText: St.detailAddressHintText.tr,
                    hintStyle: AppFontStyle.styleW500(AppColors.unselected, 14),
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      )),
    );
  }
}

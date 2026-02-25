import 'dart:convert';
import 'dart:developer';

import 'package:era_shop/Controller/GetxController/user/user_add_address_controller.dart';
import 'package:era_shop/View/MyApp/Profile/MyAddress/widget/address_select_sheet.dart';
import 'package:era_shop/custom/simple_app_bar_widget.dart';
import 'package:era_shop/model/ConutryDataModel.dart' as countryData;
import 'package:era_shop/utils/CoustomWidget/App_theme_services/primary_buttons.dart';
import 'package:era_shop/utils/CoustomWidget/App_theme_services/textfields.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/Theme/theme_service.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:era_shop/utils/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class NewAddress extends StatefulWidget {
  const NewAddress({super.key});

  @override
  State<NewAddress> createState() => _NewAddressState();
}

class _NewAddressState extends State<NewAddress> {
  List<Map<String, dynamic>> countriesData = [];
  List<String>? countries = [];
  List<String>? states = [];
  List<String>? city = [];

  List<countryData.ConutryDataModel> countryList = [];
  countryData.ConutryDataModel? selectedCountryData;
  countryData.StateData? selectedStateData;

  UserAddAddressController userAddAddressController = Get.put(UserAddAddressController());

  Future<void> loadData() async {
    log("Load Data Country");
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

  List<countryData.StateData>? statesList;

  void updateStatesData(String selectedCountry) {
    selectedCountryData = countryList.firstWhereOrNull((element) => element.countryName == selectedCountry);
    statesList = selectedCountryData?.states;
    states = selectedCountryData?.states?.map((e) => e.stateName.toString()).toList();

    // Clear state and city when country changes
    userAddAddressController.myStateController.clear();
    userAddAddressController.myCityController.clear();
    city = [];
    selectedStateData = null;

    setState(() {});
  }

  void updateCityData(String selectedStateName) {
    selectedStateData = statesList?.firstWhereOrNull((element) => element.stateName == selectedStateName);
    city = selectedStateData?.cities?.map((e) => e.cityName.toString()).toList();

    // Clear city when state changes
    userAddAddressController.myCityController.clear();

    setState(() {});
  }

  // void updateStatesData(String selectedCountry) {
  //   countryData.ConutryDataModel? selectedCountryData = countryList.firstWhereOrNull((element) => element.countryName == selectedCountry);
  //   statesList = selectedCountryData?.states;
  //   states = selectedCountryData?.states?.map((e) => e.stateName.toString()).toList();
  //
  //   setState(() {});
  // }
  //
  // void updateCityData(String selectedStateName) {
  //   countryData.StateData? tempData = statesList?.firstWhereOrNull((element) => element.stateName == selectedStateName);
  //   city = tempData?.cities?.map((e) => e.cityName.toString()).toList();
  //
  //   setState(() {});
  // }

  @override
  void initState() {
    userAddAddressController.addressController.clear();
    userAddAddressController.myCountryController.clear();
    userAddAddressController.myStateController.clear();
    userAddAddressController.myCityController.clear();
    userAddAddressController.zipCodeController.clear();
    userAddAddressController.nameController.clear();
    super.initState();
    loadJsonData();
  }

  TextEditingController countryController = TextEditingController();
  TextEditingController stateCountroller = TextEditingController();
  TextEditingController cityCountroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        // Get.off(const UserAddress(), transition: Transition.leftToRight);
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: PrimaryPinkButton(
              onTaped: getStorage.read("isDemoLogin") ?? false || isDemoSeller
                  ? () => displayToast(message: St.thisIsDemoUser.tr)
                  : () {
                      final country = userAddAddressController.myCountryController.text.trim();
                      final state = userAddAddressController.myStateController.text.trim();
                      final city = userAddAddressController.myCityController.text.trim();
                      final name = userAddAddressController.nameController.text.trim();
                      final zip = userAddAddressController.zipCodeController.text.trim();
                      final address = userAddAddressController.addressController.text.trim();

                      // Basic required fields
                      // if (name.isEmpty || country.isEmpty || zip.isEmpty || address.isEmpty) {
                      //   displayToast(message: "All fields are required \nto be filled");
                      //   return;
                      // }
                      if (address.isEmpty) {
                        displayToast(message: "Please enter address");
                        return;
                      }
                      if (country.isEmpty) {
                        displayToast(message: "Please select a country");
                        return;
                      }

                      // Access countryList from your loaded JSON (make sure it's loaded before)
                      // selectedCountryData = countryList.firstWhereOrNull((e) => e.countryName == country);

                      // If country has states, state is required
                      if (selectedCountryData != null && selectedCountryData?.states != null && selectedCountryData!.states!.isNotEmpty) {
                        if (state.isEmpty) {
                          displayToast(message: "Please select a state");
                          return;
                        }

                        // If state has cities, city is required
                        // selectedStateData = selectedCountryData?.states!.firstWhereOrNull((s) => s.stateName == state);
                        if (selectedStateData != null && selectedStateData?.cities != null && selectedStateData!.cities!.isNotEmpty) {
                          if (city.isEmpty) {
                            displayToast(message: "Please select a city");
                            return;
                          }
                        }

                        if (zip.isEmpty) {
                          displayToast(message: "Please enter zipcode");
                          return;
                        }
                        if (name.isEmpty) {
                          displayToast(message: "Please enter address name");
                          return;
                        }
                      }

                      userAddAddressController.useraddAddress(
                        country: country,
                        state: state,
                        city: city,
                      );
                      /*userAddAddressController.useraddAddress(
                          country: userAddAddressController.myCountryController.text,
                          state: userAddAddressController.myStateController.text,
                          city: userAddAddressController.myCityController.text);*/
                      // Get.back();
                      // Get.snackbar(
                      //     duration: const Duration(seconds: 4),
                      //     "Era Shop",
                      //     "New Address Added Successfully");
                    },
              text: St.saveAddress.tr),
        ),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.transparent,
            shadowColor: AppColors.black.withValues(alpha: 0.4),
            flexibleSpace: SimpleAppBarWidget(title: St.newAddress.tr),
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
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        St.address.tr,
                        style: AppFontStyle.styleW500(Colors.grey.shade500, 14),
                      ),
                    ),
                    TextField(
                      style: AppFontStyle.styleW700(AppColors.white, 14),
                      cursorColor: AppColors.unselected,
                      controller: userAddAddressController.addressController,
                      maxLines: 4,
                      minLines: 3,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: isDark.value ? AppColors.tabBackground : AppColors.tabBackground,
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryPink), borderRadius: BorderRadius.circular(26)),
                        hintText: St.detailAddressHintText.tr,
                        hintStyle: AppFontStyle.styleW500(AppColors.unselected, 14),
                      ),
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

                    if (selectedCountryData != null && selectedCountryData!.states != null && selectedCountryData!.states!.isNotEmpty) ...{
                      PrimaryTextField(
                        titleText: St.stateTFTitle.tr,
                        readOnly: true,
                        hintText: St.stateTFHintText.tr,
                        controllerType: "myStateController",
                        suffixIcon: Icon(Icons.keyboard_arrow_down_outlined, color: Colors.grey.shade400),
                        onTap: () {
                          if (userAddAddressController.myCountryController.text.isNotEmpty) {
                            addressSelectSheet(
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
                    },

                    if (selectedStateData != null && selectedStateData!.cities != null && selectedStateData!.cities!.isNotEmpty) ...{
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
                      const SizedBox(height: 25),
                    },

                    // const SizedBox(height: 25),
                    // PrimaryTextField(
                    //   titleText: St.cityTFTitle.tr,
                    //   hintText: St.cityTFHintText.tr,
                    //   controllerType: "UserCity",
                    // ),

                    PrimaryTextField(
                      titleText: St.zipCode.tr,
                      hintText: St.zipCodeHintText.tr,
                      controllerType: "ZipCode",
                    ),
                    const SizedBox(height: 25),
                    PrimaryTextField(
                      titleText: St.addressName.tr,
                      hintText: St.homeOffice.tr,
                      controllerType: "UserAddressName",
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
        )),
      ),
    );
  }

// List<String>? searchCountryList = [];
// searchCountryCall(String value) {
//   log("value:$value");
//   if (value.isNotEmpty) {
//     print("in");
//     searchCountryList = countries
//         .where(
//             (element) => element.toLowerCase().contains(value.toLowerCase()))
//         .toList();
//     log("datat:${searchCountryList?.toList()}");
//     // searchCountryList?.addAll(data);
//   }
//   setState(() {});
//   log("<<<<<<<>>>>>>> ${searchCountryList?.toList()}");
// }
}

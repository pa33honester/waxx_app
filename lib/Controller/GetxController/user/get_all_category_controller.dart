import 'dart:developer';

import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:get/get.dart';

import '../../../ApiModel/user/GetAllCategoryModel.dart';
import '../../../ApiService/user/get_all_category_service.dart';

class GetAllCategoryController extends GetxController {
  GetAllCategoryModel? getAllCategory;
  RxBool isLoading = true.obs;
  List<SubCategory> subCategoryList = [];
  //---------------------------------
  List<Category> categoryList = [];

  List<Map<String, dynamic>> nameAndId = [];

  List<CoolDropdownItem<String>> categoryDropdownItems = [];
  List<CoolDropdownItem<String>> subcategoryDropdownItems = [];

  String? getLabelById(String id) {
    final item = categoryDropdownItems.firstWhere(
      (element) => element.value == id,
    );
    return item.label;
  }

  int selectedTabIndex = 0;

  void onChangeTab(int value) {
    selectedTabIndex = value;
    print('---------${selectedTabIndex}');
    update(["onChangeTab"]);
  }

  Future getCategory() async {
    log("Get category Called --------${selectedTabIndex}");
    try {
      isLoading(true);
      var data = await GetAllCategoryApi().showCategory();
      getAllCategory = data;
      categoryList = getAllCategory!.category!;
      categoryDropdownItems = categoryList.map<CoolDropdownItem<String>>((category) {
        return CoolDropdownItem<String>(
          value: category.id.toString(),
          label: category.name.toString(),
        );
      }).toList();
      for (var i = 0; i < categoryList.length; i++) {
        nameAndId.add({
          'name': categoryList[i].name.toString(),
          'id': categoryList[i].id,
        });
      }
    } catch (e) {
      log('Get All Category Error: $e');
    } finally {
      isLoading(false);
      log("Is Loading :: $isLoading");
      log('Get All Category finally');
    }
    // update();
  }

  @override
  void onClose() {
    selectedTabIndex = 0;
    super.onClose();
  }
}

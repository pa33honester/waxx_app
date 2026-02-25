import 'package:get/get.dart';

import '../../../ApiModel/seller/AttributeAddProductModel.dart';
import '../../../ApiService/seller/attributes_add_product_service.dart';

class AttributesAddProductController extends GetxController {
  AttributeAddProductModel? attributeAddProduct;
  List<bool> isExpandedOpen = [];
  var isLoading = true.obs;

  // RxMap<String, List<String>> selectedValuesByType = <String, List<String>>{}.obs;
  final Map<String, List<String>> selectedValuesByType = {};
  //
  // void toggleSelection(String value, String type) {
  //   if (selectedValuesByType[type]?.contains(value) ?? false) {
  //     selectedValuesByType[type]?.remove(value);
  //   } else {
  //     if (selectedValuesByType[type] == null) {
  //       selectedValuesByType[type] = <String>[value];
  //     } else {
  //       selectedValuesByType[type]?.add(value);
  //     }
  //   }
  // }

  void toggleSelection(String value, String attributeName) {
    if (selectedValuesByType.containsKey(attributeName)) {
      selectedValuesByType[attributeName]!.contains(value)
          ? selectedValuesByType[attributeName]!.remove(value)
          : selectedValuesByType[attributeName]!.add(value);
      if (selectedValuesByType[attributeName]!.isEmpty) {
        selectedValuesByType.remove(attributeName);
      }
    } else {
      selectedValuesByType[attributeName] = [value];
    }
    update();
  }

  void closeAllPanelsExcept(int selectedIndex) {
    isExpandedOpen = List.generate(attributeAddProduct!.attributes!.length, (_) => false);
    isExpandedOpen[selectedIndex] = !isExpandedOpen[selectedIndex];

    update();
  }

  void togglePanel(int index) {
    // Toggle the clicked panel
    isExpandedOpen[index] = !isExpandedOpen[index];

    // Close all other panels
    for (int i = 0; i < isExpandedOpen.length; i++) {
      if (i != index) {
        isExpandedOpen[i] = false;
      }
    }

    update();
  }

  // getAttributesData() async {
  //   try {
  //     isLoading(true);
  //     var data = await AttributesAddProductApi().productAttributes();
  //     attributeAddProduct = data;
  //   } catch (e) {
  //     Exception(e);
  //   } finally {
  //     isLoading(false);
  //   }
  // }

  getAttributesData() async {
    try {
      isLoading(true);
      var data = await AttributesAddProductApi().productAttributes();
      attributeAddProduct = data;
      isExpandedOpen = List.filled(attributeAddProduct?.attributes?.length ?? 0, false);
    } catch (e) {
      Exception(e);
    } finally {
      isLoading(false);
    }
  }
}

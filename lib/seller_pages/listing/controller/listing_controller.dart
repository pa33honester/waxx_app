import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cool_dropdown/controllers/dropdown_controller.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:era_shop/ApiModel/seller/ProductEditModel.dart' as edit;
import 'package:era_shop/ApiService/seller/add_product_service.dart';
import 'package:era_shop/ApiService/seller/product_edit_service.dart';
import 'package:era_shop/Controller/GetxController/seller/seller_product_detail_controller.dart';
import 'package:era_shop/seller_pages/listing/api/fetch_category_sub_attributes_api.dart';
import 'package:era_shop/seller_pages/listing/controller/chat_gpt_controller.dart';
import 'package:era_shop/seller_pages/listing/dialog/listing_error_dialog.dart';
import 'package:era_shop/seller_pages/listing/model/fetch_category_sub_attr_model.dart';
import 'package:era_shop/utils/Zego/ZegoUtils/device_orientation.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/app_constant.dart';
import 'package:era_shop/utils/database.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:era_shop/model/ConutryDataModel.dart' as country_data;
import 'package:path_provider/path_provider.dart';
import '../../../ApiModel/seller/AddProductModel.dart' as product;
import 'package:era_shop/ApiModel/seller/SellerProductDetailsModel.dart' as seller_product_details;

class ListingController extends GetxController {
  SellerProductDetailsController sellerProductDetailsController = Get.put(SellerProductDetailsController());
  bool isEdit = false;
  String productCode = '';

  @override
  void onInit() {
    // fetchCategorySubAttr();
    isEdit = Get.arguments;
    print('ARGS :: $isEdit');
    loadJsonData();

    if (isEdit) {
      final product = sellerProductDetailsController.sellerProductDetails!.product![0];
      convertURLsToFiles(product.images!.toList());
      titleController.text = product.productName ?? '';
      selectedCategoryId = product.category?.id?.toString();
      selectedCategoryName = product.category?.name ?? '';
      selectedSubCategoryId = product.subCategory?.id?.toString();
      selectedSubCategoryName = product.subCategory?.name ?? '';

      fetchCategorySubAttr().then((_) {
        loadExistingProductAttributes();
      });

      descriptionController.text = product.description ?? '';
      prefillPricingData(product);
      prefillPreferencesData(product);
      productCode = product.productCode ?? '';
    } else {
      fetchCategorySubAttr();
    }

    super.onInit();
  }

  Future<List<File>> convertURLsToFiles(List urls) async {
    var rng = Random();
    for (String url in urls) {
      Directory root = await getTemporaryDirectory();
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        String tempPath = '${root.path}/edited-${rng.nextInt(1000000)}photos-${rng.nextInt(1000000)}.jpg';
        File file = File(tempPath);
        await file.writeAsBytes(response.bodyBytes);
        imageFileList.add(file);
        update([AppConstant.idPickImage]);
      }
    }
    print("Converted images :: $imageFileList");
    return imageFileList;
  }

  void loadExistingProductAttributes() {
    final product = sellerProductDetailsController.sellerProductDetails?.product?[0];
    if (product?.attributes != null && product!.attributes!.isNotEmpty) {
      // Clear existing values
      attributeValues.clear();

      // Load existing attribute values
      for (var productAttr in product.attributes!) {
        final attributeName = productAttr.name;
        final attributeValue = productAttr.values;

        if (attributeName != null && attributeValue != null) {
          // Handle different field types
          final fieldType = getAttributeFieldType(attributeName);

          switch (fieldType) {
            case 1: // Text Input
            case 2: // Number Input
            case 4: // Radio Input
              // For single value fields, take the first value if it's a list
              if (attributeValue is List) {
                attributeValues[attributeName] = attributeValue.isNotEmpty ? attributeValue.first : '';
              } else {
                attributeValues[attributeName] = attributeValue;
              }
              break;

            case 3: // File Input
              attributeValues[attributeName] = attributeValue;
              break;

            case 5: // Dropdown (Multiple selection)
            case 6: // Checkboxes
              // Ensure we always have a list
              if (attributeValue is List) {
                attributeValues[attributeName] = attributeValue;
              } else if (attributeValue is String && attributeValue.contains(',')) {
                // Handle comma-separated string (fallback)
                attributeValues[attributeName] = attributeValue.map((e) => e.trim()).toList();
              } else {
                // Single value wrapped in list
                attributeValues[attributeName] = [attributeValue];
              }
              break;

            default:
              attributeValues[attributeName] = attributeValue;
          }
        }
      }
      initializeTextControllersWithValues();
      update();
    }
  }

  int? getAttributeFieldType(String attributeName) {
    final selectedSubCategoryId = this.selectedSubCategoryId;
    if (selectedSubCategoryId == null) return null;

    final relevantAttributes = fetchCategorySubAttrModel?.attributes?.where((attr) => attr.subCategory == selectedSubCategoryId).toList() ?? [];

    for (var attributeData in relevantAttributes) {
      final attributes = attributeData.attributes ?? [];
      for (var attribute in attributes) {
        if (attribute.name == attributeName) {
          return attribute.fieldType;
        }
      }
    }
    return null;
  }

  void initializeTextControllersWithValues() {
    final selectedSubCategoryId = this.selectedSubCategoryId;
    if (selectedSubCategoryId == null) return;

    final relevantAttributes = fetchCategorySubAttrModel?.attributes?.where((attr) => attr.subCategory == selectedSubCategoryId).toList() ?? [];

    for (var attributeData in relevantAttributes) {
      final attributes = attributeData.attributes ?? [];
      for (var attribute in attributes) {
        final attributeName = attribute.name ?? '';
        if (attribute.fieldType == 1 || attribute.fieldType == 2) {
          // Get existing value
          final existingValue = attributeValues[attributeName];

          // Initialize or update controller
          if (!_textControllers.containsKey(attributeName)) {
            _textControllers[attributeName] = TextEditingController(
              text: existingValue?.toString() ?? '',
            );
          } else {
            _textControllers[attributeName]!.text = existingValue?.toString() ?? '';
          }

          // Add listener to update attributeValues when text changes
          _textControllers[attributeName]!.addListener(() {
            final currentText = _textControllers[attributeName]!.text;
            if (attributeValues[attributeName] != currentText) {
              updateAttributeValue(attributeName, currentText);
            }
          });
        }
      }
    }
  }

  void prefillPricingData(seller_product_details.Product product) {
    print('PRICE :: ${buyItNowPriceController.text}');
    buyItNowPriceController.text = product.price?.toString() ?? '';
    shippingChargeController.text = product.shippingCharges?.toString() ?? '';
    isOffersAllowed = product.allowOffer ?? false;
    if (isOffersAllowed) {
      minimumOfferAmountController.text = product.minimumOfferPrice?.toString() ?? '';
    }
    // }
    update();
  }

  void prefillPreferencesData(seller_product_details.Product product) {
    // Prefill business days (processing time)
    if (product.processingTime != null && product.processingTime!.isNotEmpty) {
      // Try to find a matching option in our predefined list
      selectedBusinessDays = businessDays.firstWhere(
        (option) => option == product.processingTime,
        orElse: () => businessDays.first, // Default fallback
      );
    }

    // Prefill immediate payment requirement
    isImmediatePaymentEnabled = product.isImmediatePaymentRequired ?? false;

    // Prefill location data from recipientAddress
    if (product.recipientAddress != null && product.recipientAddress!.isNotEmpty) {
      _parseRecipientAddress(product.recipientAddress!);
    }

    update();
  }

  void _parseRecipientAddress(String address) {
    // Split the address by commas and trim whitespace
    final parts = address.split(',').map((part) => part.trim()).toList();

    // The format is typically "City, State, Country"
    if (parts.length >= 3) {
      cityController.text = parts[0];
      stateController.text = parts[1];
      countryController.text = parts[2];
    } else if (parts.length == 2) {
      // Handle case where only country and state are provided
      stateController.text = parts[0];
      countryController.text = parts[1];
    } else if (parts.length == 1) {
      // Handle case where only country is provided
      countryController.text = parts[0];
    }

    // After setting the country, load the states and cities
    if (countryController.text.isNotEmpty && countryList.isNotEmpty) {
      final countryIndex = countries?.indexOf(countryController.text) ?? -1;
      if (countryIndex != -1) {
        updateStatesData(countryController.text);

        // After states are loaded, try to set the state and city
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (stateController.text.isNotEmpty && states != null && states!.isNotEmpty) {
            final stateIndex = states!.indexOf(stateController.text);
            if (stateIndex != -1) {
              updateCityData(stateController.text);

              // Set the city after a small delay to ensure cities are loaded
              Future.delayed(Duration(milliseconds: 100), () {
                if (cityController.text.isNotEmpty && city != null && city!.isNotEmpty) {
                  final cityIndex = city!.indexOf(cityController.text);
                  if (cityIndex != -1) {
                    update([AppConstant.idCountries]);
                  }
                }
              });
            }
          }
        });
      }
    }
  }

  String? selectedCondition;

  final List<Map<String, String>> conditions = [
    {
      'title': 'New with box',
      'description': 'Brand new, unworn and defect-free with original box, packaging, and accessories.',
    },
    {
      'title': 'New without box',
      'description': 'Brand new, unworn, and defect-free with all accessories but missing the original box.',
    },
    {
      'title': 'New with defects',
      'description': 'Brand new and unworn with missing accessories or defects (scuffs, marks, manufacturing flaws, cuts, damaged box, etc.).',
    },
    {
      'title': 'Pre-owned',
      'description': 'Used, worn, or has signs of wear on any part.',
    },
  ];

  void selectCondition(String condition) {
    selectedCondition = condition;
    update([AppConstant.idCondition]);
  }

  bool get isConditionSelected => selectedCondition != null;

  //-------------------------- PHOTOS --------------------------

  List<File> imageFileList = [];

  // List<XFile>? selectedImages = [];

  XFile? image;
  File? selectImageFile;

  final ImagePicker imagePicker = ImagePicker();

  // onMultiplePickImage() async {
  //   selectedImages = await imagePicker.pickMultiImage();
  //   if (selectedImages!.isNotEmpty) {
  //     for (XFile images in selectedImages!) {
  //       imageFileList.add(File(images.path));
  //     }
  //   }
  //   update([AppConstant.idPickImage]);
  // }
  File? productImageXFile;

  productPickFromGallery() async {
    image = await imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    productImageXFile = File(image!.path);
    imageFileList.add(productImageXFile!);
    print('IMAGE LIST :: $imageFileList');
    update([AppConstant.idPickImage]);
  }

  Future<void> takePhoto() async {
    try {
      final XFile? image = await imagePicker.pickImage(source: ImageSource.camera);
      if (image != null) {
        imageFileList.add(File(image.path));
        update(); // Notify listeners
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to take photo: ${e.toString()}');
    }
  }

  onRemoveImage(int index) {
    imageFileList.removeAt(index);
    update([AppConstant.idRemoveImage, AppConstant.idPickImage]);
  }

  bool get hasPhotos {
    return imageFileList.isNotEmpty;
  }

  //-------------------------- TITLE --------------------------

  TextEditingController titleController = TextEditingController();
  TextEditingController subTitleController = TextEditingController();

  bool get hasTitle {
    return titleController.text.isNotEmpty || subTitleController.text.isNotEmpty;
  }

  //-------------------------- CATEGORY --------------------------

  TextEditingController searchCategoryController = TextEditingController();
  TextEditingController searchSucCatController = TextEditingController();
  FetchCategorySubAttrModel? fetchCategorySubAttrModel;

  String? selectedCategoryId;
  String? selectedCategoryName;
  String? selectedSubCategoryId;
  String? selectedSubCategoryName;

  bool get hasCategory {
    return selectedCategoryId != null || selectedSubCategoryId != null;
  }

  Future<void> fetchCategorySubAttr() async {
    fetchCategorySubAttrModel = await FetchCategorySubAttributesApi.callApi();
    filteredCategories.value = fetchCategorySubAttrModel?.categories ?? [];
  }

  RxList<Category> filteredCategories = <Category>[].obs;

  void filterCategories(String searchText) {
    final allCategories = fetchCategorySubAttrModel?.categories ?? [];
    if (searchText.isEmpty) {
      filteredCategories.value = allCategories;
    } else {
      filteredCategories.value = allCategories.where((cat) => cat.name?.toLowerCase().contains(searchText.toLowerCase()) ?? false).toList();
    }
    update();
  }

  RxList<SubCategory> filteredSubCategories = <SubCategory>[].obs;

  void filterSubCategories(String searchText, String categoryId) {
    final allSubCategories = fetchCategorySubAttrModel?.subCategories?.where((sub) => sub.category == categoryId).toList() ?? [];

    if (searchText.isEmpty) {
      filteredSubCategories.value = allSubCategories;
    } else {
      filteredSubCategories.value = allSubCategories.where((sub) => sub.name?.toLowerCase().contains(searchText.toLowerCase()) ?? false).toList();
    }
    update();
  }

  //-------------------------- ITEM SPECIFIC --------------------------

  // String? selectedSubCategoryId;
  Map<String, dynamic> attributeValues = {};

  final Map<String, TextEditingController> _textControllers = {};

  List<CoolDropdownItem<String>> attrDropdownItems = [];
  final attrDropDownController = DropdownController<String>();

  bool get hasItemSpecific {
    if (attributeValues.isEmpty) return false;
    return attributeValues.values.any((value) => isAttributeValueValid(value));
  }

// Helper method to validate if attribute value is meaningful
  bool isAttributeValueValid(dynamic attributeValue) {
    if (attributeValue == null) return false;

    if (attributeValue is String) {
      return attributeValue.trim().isNotEmpty && attributeValue.trim() != 'null';
    }

    if (attributeValue is List) {
      return attributeValue.isNotEmpty && attributeValue.any((item) => item != null && item.toString().trim().isNotEmpty && item.toString().trim() != 'null');
    }

    return attributeValue.toString().trim().isNotEmpty && attributeValue.toString().trim() != 'null';
  }

  TextEditingController getTextController(String attributeName) {
    if (!_textControllers.containsKey(attributeName)) {
      final existingValue = getAttributeValue(attributeName);
      _textControllers[attributeName] = TextEditingController(
        text: existingValue?.toString() ?? '',
      );

      // Add listener to keep attributeValues in sync
      _textControllers[attributeName]!.addListener(() {
        final currentText = _textControllers[attributeName]!.text;
        if (attributeValues[attributeName] != currentText) {
          attributeValues[attributeName] = currentText;
        }
      });
    }
    return _textControllers[attributeName]!;
  }

  void initializeTextControllers() {
    final selectedSubCategoryId = this.selectedSubCategoryId;
    if (selectedSubCategoryId == null) return;

    final relevantAttributes = fetchCategorySubAttrModel?.attributes?.where((attr) => attr.subCategory == selectedSubCategoryId).toList() ?? [];

    for (var attributeData in relevantAttributes) {
      final attributes = attributeData.attributes ?? [];
      for (var attribute in attributes) {
        final attributeName = attribute.name ?? '';
        if (attribute.fieldType == 1 || attribute.fieldType == 2) {
          // Get the pre-filled value if it exists
          final prefilledValue = attributeValues[attributeName];
          _textControllers[attributeName] = TextEditingController(
            text: prefilledValue?.toString() ?? '',
          );
        }
      }
    }
  }

  void disposeTextControllers() {
    for (var controller in _textControllers.values) {
      controller.dispose();
    }
    _textControllers.clear();
  }

  // Method to update attribute values
  void updateAttributeValue(String attributeName, dynamic value) {
    attributeValues[attributeName] = value;
    update();
  }

  // Method to get attribute value
  dynamic getAttributeValue(String attributeName) {
    return attributeValues[attributeName];
  }

  // Method to clear attribute values
  void clearAttributeValues() {
    attributeValues.clear();
    update();
  }

  String? getValidationError() {
    if (selectedSubCategoryId == null) return "Please select a subcategory first";

    final relevantAttributes = fetchCategorySubAttrModel?.attributes?.where((attr) => attr.subCategory == selectedSubCategoryId).toList() ?? [];

    for (var attributeData in relevantAttributes) {
      final attributes = attributeData.attributes ?? [];
      for (var attribute in attributes) {
        if (attribute.isRequired == true) {
          final value = attributeValues[attribute.name];

          switch (attribute.fieldType) {
            case 6: // Checkboxes
              if (value == null || (value as List).isEmpty) {
                return "Please select at least one option for ${attribute.name}";
              }
              break;
            case 3: // File Input
              if (value == null || value.toString().isEmpty) {
                return "Please select a file for ${attribute.name}";
              }
              break;
            default: // Text, Number, Radio, Dropdown
              if (value == null || value.toString().isEmpty) {
                return "Please fill ${attribute.name}";
              }
          }
        }
      }
    }
    return null;
  }

  Map<String, dynamic> getAttributeValuesForSubmission() {
    return Map.from(attributeValues);
  }

  PlatformFile? _selectedFile;

  PlatformFile? get selectedFile => _selectedFile;

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg', 'svg', 'pdf'],
    );

    if (result != null) {
      _selectedFile = result.files.first;
      update();
    }
  }

  void clearFile() {
    _selectedFile = null;
    update();
  }

  Map<String, bool> isExpandedOpen = {};

  void togglePanel(String attributeName) {
    isExpandedOpen[attributeName] = !(isExpandedOpen[attributeName] ?? false);
    isExpandedOpen.forEach((key, value) {
      if (key != attributeName) {
        isExpandedOpen[key] = false;
      }
    });

    update();
  }

  bool isPanelExpanded(String attributeName) {
    return isExpandedOpen[attributeName] ?? false;
  }

//-------------------------- DESCRIPTION --------------------------

  TextEditingController descriptionController = TextEditingController();
  final isAutoGenerateOn = false.obs;
  final chatGptController = Get.put(ChatGptController());
  final isLoading = false.obs;

  Future<void> generateDescription() async {
    if (!validateRequiredFieldsForDes(showToast: false)) {
      isAutoGenerateOn.value = false;
      return;
    }

    isLoading.value = true;
    update([AppConstant.idOpenAi]);

    try {
      final prompt = """
      Generate a product description in 60-70 words based on:
      Title: ${titleController.text}
      Category: $selectedCategoryName
      Subcategory: $selectedSubCategoryName
      
      Make it engaging and highlight key features.
      Use a professional tone suitable for e-commerce.
      Focus on benefits rather than just features.
    """;

      final generatedText = await chatGptController.generateDescription(prompt);
      descriptionController.text = generatedText;
    } catch (e) {
      Utils.showToast('Failed to generate description: ${e.toString()}');
      isAutoGenerateOn.value = false;
    } finally {
      isLoading.value = false;
      update([AppConstant.idOpenAi]);
    }
  }

  void toggleAutoGenerate(bool value) {
    if (value) {
      if (!validateRequiredFieldsForDes()) {
        isAutoGenerateOn.value = false;
        return;
      }
      isAutoGenerateOn.value = true;
      generateDescription();
    } else {
      isAutoGenerateOn.value = false;
    }
  }

  bool validateRequiredFieldsForDes({bool showToast = true}) {
    if (titleController.text.isEmpty) {
      if (showToast) Utils.showToast('Please enter product title first');
      return false;
    }
    if (selectedCategoryName?.isEmpty ?? true) {
      if (showToast) Utils.showToast('Please select category first');
      return false;
    }
    if (selectedSubCategoryName?.isEmpty ?? true) {
      if (showToast) Utils.showToast('Please select subcategory first');
      return false;
    }
    return true;
  }

  // Future<void> generateDescription(String prompt) async {
  //   if (!isAutoGenerateOn.value || prompt.isEmpty) return;
  //
  //   isLoading.value = true;
  //   update();
  //
  //   try {
  //     final generatedText = await chatGptController.generateDescription(prompt);
  //     descriptionController.text = generatedText;
  //   } catch (e) {
  //     Get.snackbar('Error', 'Failed to generate description');
  //   } finally {
  //     isLoading.value = false;
  //     update();
  //   }
  // }

  var isDescriptionExpanded = false.obs;

  void toggleDescription() {
    isDescriptionExpanded.value = !isDescriptionExpanded.value;
  }

  bool get hasDescription {
    return descriptionController.text.isNotEmpty;
  }

//-------------------------- PRICING --------------------------

  // Pricing Screen Properties
  bool isMoreOptionsEnabled = false;
  bool isOffersAllowed = false;

  // bool hasMinimumOfferAmount = false;

  String? selectedDuration = '1 day';
  DateTime? scheduledStartDate;
  DateTime? scheduledStartTime;

  final TextEditingController startingBidController = TextEditingController();
  final TextEditingController reservePriceController = TextEditingController();
  final TextEditingController buyItNowPriceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController minimumOfferAmountController = TextEditingController();
  final TextEditingController shippingChargeController = TextEditingController();

// Available duration options
  final List<String> durationOptions = ['1 day', '3 days', '5 days', '7 days', '10 days', '30 days'];

  List<CoolDropdownItem<String>> daysDropdownItems = [];
  final daysDropDownController = DropdownController<String>();

  bool get hasPricing {
    return buyItNowPriceController.text.isNotEmpty || (isOffersAllowed && minimumOfferAmountController.text.isNotEmpty) && shippingChargeController.text.isNotEmpty;
  }

  void toggleMoreOptions(bool value) {
    isMoreOptionsEnabled = value;
    update();
  }

  void setOffersAllowed(bool value) {
    isOffersAllowed = value;
    if (!value) {
      minimumOfferAmountController.clear();
    }
    update();
  }

  void toggleMinimumOfferAmount(bool value) {
    // hasMinimumOfferAmount = value;
    if (!value) {
      minimumOfferAmountController.clear();
    }
    update();
  }

// Duration Selection
  void selectDuration(String? duration) {
    if (duration != null) {
      selectedDuration = duration;
      update();
    }
  }

// Date and Time Selection
  Future<void> selectScheduledDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      // initialDate: scheduledStartDate ?? DateTime.now().add(const Duration(days: 1)),
      initialDate: scheduledStartDate ?? DateTime.now().add(Duration(days: 3)),
      // default select after 2 days
      firstDate: DateTime.now().add(Duration(days: 3)),
      // restrict from today + 2
      // firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: Colors.black,
              surface: Color(0xFF1E1E1E),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      scheduledStartDate = picked;
      update();
    }
  }

  Future<void> selectScheduledTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(scheduledStartTime ?? DateTime.now()),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Color(0xFF1E1E1E),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final now = DateTime.now();
      scheduledStartTime = DateTime(
        now.year,
        now.month,
        now.day,
        picked.hour,
        picked.minute,
      );
      update();
    }
  }

  bool get isBuyItNowPriceValid {
    final text = buyItNowPriceController.text.trim();
    if (text.isEmpty) return false;
    final value = double.tryParse(text);
    return value != null && value > 0;
  }

  String get formattedScheduledDateTime {
    if (scheduledStartDate == null) return 'Select date and time';

    String dateStr = '${scheduledStartDate!.day}/${scheduledStartDate!.month}/${scheduledStartDate!.year}';

    if (scheduledStartTime != null) {
      String timeStr = TimeOfDay.fromDateTime(scheduledStartTime!).format(Get.context!);
      return '$dateStr at $timeStr';
    }
    return dateStr;
  }

  //-------------------------- PREFERENCES --------------------------

  // Available duration options
  final List<String> businessDays = ['1 business day', '2 business day', '3 business days', '4 business days', '5 business days', '10 business days', '15 business days', '20 business days', '30 business days'];

  String? selectedBusinessDays;
  bool isImmediatePaymentEnabled = false;

  List<CoolDropdownItem<String>> businessDaysDropdownItems = [];
  final businessDaysDropDownController = DropdownController<String>();

  // Duration Selection
  void selectBusinessDays(String? days) {
    selectedBusinessDays = days;
    update();
  }

  void toggleImmediatePayment(bool value) {
    isImmediatePaymentEnabled = value;
    update();
  }

  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  List<String>? countries = [];
  List<String>? states = [];
  List<String>? city = [];

  List<country_data.ConutryDataModel> countryList = [];
  List<country_data.StateData>? statesList;
  List<Map<String, dynamic>> countriesData = [];
  country_data.ConutryDataModel? selectedCountryData;
  country_data.StateData? selectedStateData;

  bool get hasPreferences {
    bool hasHandlingTime = selectedBusinessDays != null;
    bool hasLocation = countryController.text.isNotEmpty;
    bool hasPaymentPref = isImmediatePaymentEnabled;

    return hasHandlingTime || hasLocation || hasPaymentPref;
  }

  String getRecipientAddress() {
    List<String> locationParts = [];

    if (countryController.text.isNotEmpty) {
      locationParts.add(countryController.text);
    }

    if (stateController.text.isNotEmpty) {
      locationParts.add(stateController.text);
    }

    if (cityController.text.isNotEmpty) {
      locationParts.add(cityController.text);
    }

    return locationParts.join(', ');
  }

  String getFullLocationString() {
    final locationParts = [
      if (cityController.text.isNotEmpty) cityController.text,
      if (stateController.text.isNotEmpty) stateController.text,
      if (countryController.text.isNotEmpty) countryController.text,
    ];
    return locationParts.join(', ');
  }

  Future<void> loadJsonData() async {
    String jsonContent = await rootBundle.loadString('assets/data/country_state_city.json');
    final data = jsonDecode(jsonContent);
    List list = data;

    countryList = list.map((e) => country_data.ConutryDataModel.fromJson(e)).toList();
    countries = countryList.map((e) => e.countryName.toString()).toList();
    update([AppConstant.idCountries]);
  }

  void updateStatesData(String selectedCountry) {
    selectedCountryData = countryList.firstWhereOrNull((element) => element.countryName == selectedCountry);
    statesList = selectedCountryData?.states;
    states = selectedCountryData?.states?.map((e) => e.stateName.toString()).toList();

    // Clear state and city when country changes
    stateController.clear();
    cityController.clear();
    city = [];
    selectedStateData = null;

    update([AppConstant.idCountries]);
  }

  void updateCityData(String selectedStateName) {
    selectedStateData = statesList?.firstWhereOrNull((element) => element.stateName == selectedStateName);
    city = selectedStateData?.cities?.map((e) => e.cityName.toString()).toList();
    cityController.clear();
    update([AppConstant.idCountries]);
  }

  @override
  void onClose() {
    // startingBidController.dispose();
    // reservePriceController.dispose();
    // buyItNowPriceController.dispose();
    // quantityController.dispose();
    // minimumOfferAmountController.dispose();
    resetForm();
    super.onClose();
  }

  //-------------------------- CALL LIST ITEM API --------------------------

  int getAuctionDurationInDays() {
    if (selectedDuration == null) return 7; // default

    switch (selectedDuration) {
      case '1 day':
        return 1;
      case '3 days':
        return 3;
      case '5 days':
        return 5;
      case '7 days':
        return 7;
      case '10 days':
        return 10;
      case '30 days':
        return 30;
      default:
        return 7;
    }
  }

  List<Map<String, dynamic>> prepareAttributesForApi() {
    List<Map<String, dynamic>> apiAttributes = [];

    if (selectedSubCategoryId == null) return apiAttributes;

    // Get all attributes for the selected subcategory
    final relevantAttributes = fetchCategorySubAttrModel?.attributes?.where((attr) => attr.subCategory == selectedSubCategoryId).toList() ?? [];

    print('relevantAttributes: $relevantAttributes');

    for (var attributeData in relevantAttributes) {
      final attributes = attributeData.attributes ?? [];
      print('attributes :: $attributes');

      for (var attribute in attributes) {
        print('attribute1 :: $attribute');
        final attributeId = attribute.id ?? '';
        final attributeName = attribute.name ?? '';
        final attributeImage = attribute.image ?? '';
        print('IMAGE :: $attributeImage');
        final userValue = attributeValues[attributeName];

        if (userValue == null && attribute.isRequired != true) continue;

        Map<String, dynamic> apiAttribute = {
          "_id": attributeId,
          "name": attributeName,
          "image": attributeImage,
        };

        switch (attribute.fieldType) {
          case 1: // Text Input
            apiAttribute["values"] = userValue != null ? [userValue.toString()] : [];
            break;

          case 2: // Number Input
            apiAttribute["values"] = userValue != null ? [userValue.toString()] : [];
            break;

          case 3: // File Input
            apiAttribute["values"] = userValue != null ? [userValue.toString()] : [];
            break;

          case 4: // Radio Button (Single Selection)
            apiAttribute["values"] = userValue != null ? [userValue.toString()] : [];
            break;

          case 5: // Dropdown (Multi Selection)
            apiAttribute["values"] = userValue ?? [];
            break;

          case 6: // Checkbox (Multiple Selection)
            List<String> selectedList = [];
            if (userValue is List<String>) {
              selectedList = userValue;
            } else if (userValue is List) {
              selectedList = userValue.map((e) => e.toString()).toList();
            } else if (userValue != null) {
              selectedList = [userValue.toString()];
            }
            apiAttribute["values"] = selectedList;
            break;
          default:
            apiAttribute["values"] = userValue != null ? [userValue.toString()] : [];
        }

        if (apiAttribute["values"].isNotEmpty || attribute.isRequired == true) {
          apiAttributes.add(apiAttribute);
        }
      }
    }
    print('Final API Attributes: $apiAttributes');
    return apiAttributes;
  }

  bool validateRequiredFields() {
    List<String> missingFields = [];
    double buyItNowPrice = double.tryParse(buyItNowPriceController.text) ?? 0;
    double offerPrice = double.tryParse(minimumOfferAmountController.text) ?? 0;

    // Check title
    if (!hasTitle) {
      missingFields.add('Title');
    }

    // Check category and subcategory
    if (selectedCategoryId == null) {
      missingFields.add('Category');
    }

    if (selectedSubCategoryId == null) {
      missingFields.add('Subcategory');
    }

    // Check description
    if (!hasDescription) {
      missingFields.add('Description');
    }

    // Check photos (minimum 3)
    if (imageFileList.isEmpty) {
      missingFields.add('Photos (minimum 1 required)');
    }

    if (!isBuyItNowPriceValid) {
      missingFields.add('Buy It Now price');
    }
    if (offerPrice > buyItNowPrice) {
      missingFields.add('Offer price should be less than Buy It Now price');
    }

    if (shippingChargeController.text.isEmpty) {
      missingFields.add('Enter Shipping charge');
    }

    if (selectedBusinessDays == null) {
      missingFields.add('Please select handling time');
    }

    if (countryController.text.isEmpty) {
      missingFields.add('Please select location');
    }

    // Check item specifics (attributes)
    String? attributeError = getValidationError();
    if (attributeError != null && !attributeError.contains('subcategory')) {
      missingFields.add('Item specifics required values');
    }

    // Check shipping weight if required
    bool hasWeightAttribute = false;
    if (selectedSubCategoryId != null) {
      final relevantAttributes = fetchCategorySubAttrModel?.attributes?.where((attr) => attr.subCategory == selectedSubCategoryId).toList() ?? [];

      for (var attributeData in relevantAttributes) {
        final attributes = attributeData.attributes ?? [];
        for (var attribute in attributes) {
          if (attribute.name?.toLowerCase().contains('weight') == true) {
            hasWeightAttribute = true;
            if (attributeValues[attribute.name] == null || attributeValues[attribute.name].toString().isEmpty) {
              missingFields.add('Weight of packaged item');
            }
            break;
          }
        }
        if (hasWeightAttribute) break;
      }
    }

    // If there are missing fields, show the custom dialog
    if (missingFields.isNotEmpty) {
      showListingErrorsDialog(missingFields);
      return false;
    }

    return true;
  }

  Future<void> listItem() async {
    try {
      // Validate required fields BEFORE showing loading
      if (!validateRequiredFields()) {
        return; // Don't proceed if validation fails
      }

      // Show loading only after validation passes
      Get.dialog(
        Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
        barrierDismissible: false,
      );

      File mainImage = imageFileList.first;
      List<File> images = imageFileList.toList();
      String productName = titleController.text.trim();
      String description = descriptionController.text.trim();

      int price;

      price = int.tryParse(buyItNowPriceController.text.trim()) ?? 0;

      String category = selectedCategoryId ?? "";
      String subCategory = selectedSubCategoryId ?? "";

      List<Map<String, dynamic>> attributes = prepareAttributesForApi();

      // Offer settings
      bool allowOffer = isOffersAllowed;
      int minimumOfferPrice = 0;
      if (minimumOfferAmountController.text.isNotEmpty) {
        minimumOfferPrice = int.tryParse(minimumOfferAmountController.text.trim()) ?? 0;
      }

      String recipientAddress = getRecipientAddress();

      print('attributes :: $attributes');

      product.AddProductModel result = await AddProductApi().addProduct(
        sellerId: Database.sellerId,
        mainImage: mainImage,
        images: images,
        productName: productName,
        price: price,
        category: category,
        subCategory: subCategory,
        shippingCharges: shippingChargeController.text.trim(),
        description: description,
        productCode: Utils.generateRandomCode(),
        attributes: attributes,
        allowOffer: allowOffer,
        minimumOfferPrice: minimumOfferPrice,
        productSaleType: 1,
        processingTime: selectedBusinessDays ?? '',
        recipientAddress: recipientAddress,
        isImmediatePaymentRequired: isImmediatePaymentEnabled,
      );
      Get.back();
      if (result.status == true) {
        Utils.showToast(result.message ?? 'Item Edit successfully');
        Get.back();
        resetForm();
      } else {
        Utils.showToast(
          result.message ?? 'Failed to list item',
        );
      }
    } catch (e) {
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      Utils.showToast(
        'Something went wrong: ${e.toString()}',
      );
    }
  }

  Future<void> editListItem() async {
    try {
      // Validate required fields BEFORE showing loading
      if (!validateRequiredFields()) {
        return; // Don't proceed if validation fails
      }

      // Show loading only after validation passes
      Get.dialog(
        Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
        barrierDismissible: false,
      );

      File mainImage = imageFileList.first;
      List<File> images = imageFileList.toList();
      String productName = titleController.text.trim();
      String description = descriptionController.text.trim();

      int price;
      price = int.tryParse(buyItNowPriceController.text.trim()) ?? 0;

      String category = selectedCategoryId ?? "";
      String subCategory = selectedSubCategoryId ?? "";

      List<Map<String, dynamic>> attributes = prepareAttributesForApi();

      // Offer settings
      bool allowOffer = isOffersAllowed;
      int minimumOfferPrice = 0;
      if (minimumOfferAmountController.text.isNotEmpty) {
        minimumOfferPrice = int.tryParse(minimumOfferAmountController.text.trim()) ?? 0;
      }

      String recipientAddress = getRecipientAddress();

      print('edit attributes :: $images');

      edit.ProductEditModel result = await ProductEditApi().editProduct(
        sellerId: sellerId,
        mainImage: mainImage,
        images: images,
        productName: productName,
        price: price,
        category: category,
        subCategory: subCategory,
        shippingCharges: shippingChargeController.text.trim(),
        description: description,
        productCode: productCode,
        attributes: attributes,
        productSaleType: 1,
        allowOffer: allowOffer,
        minimumOfferPrice: minimumOfferPrice,
        // enableAuction: isAuctionEnabled,
        // auctionStartingPrice: auctionStartingPrice,
        // enableReservePrice: enableReservePrice,
        // reservePrice: reservePrice,
        // auctionDuration: auctionDuration,
        // scheduleTime: scheduleTime,
        processingTime: selectedBusinessDays ?? '',
        recipientAddress: recipientAddress,
        isImmediatePaymentRequired: isImmediatePaymentEnabled,
      );
      Get.back();
      if (result.status == true) {
        Utils.showToast(result.message ?? 'Item listed successfully');
        Get.close(3);
        resetForm();
      } else {
        Utils.showToast(
          result.message ?? 'Failed to list item',
        );
      }
    } catch (e) {
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      Utils.showToast(
        'Something went wrong: ${e.toString()}',
      );
    }
  }

  onSubmit() async {
    if (isEdit == true) {
      await editListItem();
    } else {
      await listItem();
    }
  }

  void resetForm() {
    // Clear all controllers
    titleController.clear();
    subTitleController.clear();
    descriptionController.clear();
    startingBidController.clear();
    reservePriceController.clear();
    buyItNowPriceController.clear();
    quantityController.clear();
    minimumOfferAmountController.clear();
    _textControllers.clear();
    countryController.clear();
    stateController.clear();
    cityController.clear();
    shippingChargeController.clear();

    // Reset selections
    selectedCondition = null;
    selectedCategoryId = null;
    selectedCategoryName = null;
    selectedSubCategoryId = null;
    selectedSubCategoryName = null;
    selectedDuration = null;
    selectedBusinessDays = null;
    _selectedFile = null;

    // Clear images
    imageFileList.clear();
    // selectedImages?.clear();

    // Reset attribute values
    clearAttributeValues();

    isMoreOptionsEnabled = false;
    isOffersAllowed = true;
    // hasMinimumOfferAmount = false;
    isImmediatePaymentEnabled = false;

    // Clear date/time
    scheduledStartDate = null;
    scheduledStartTime = null;

    update();
  }

  //-------------------------- PREVIEW SCREEN --------------------------

  int selectedImageIndex = 0;
  final productController = PageController();

  onSelectImage(int index) {
    selectedImageIndex = index;
    update([AppConstant.idPreviewImage]);
  }
}

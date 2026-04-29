import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:waxxapp/ApiModel/seller/AddProductModel.dart';
import 'package:waxxapp/Controller/GetxController/seller/add_product_controller.dart';
import 'package:waxxapp/utils/api_url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class AddProductApi extends GetxService {
  MediaType _getMediaType(String path) {
    final ext = path.split('.').last.toLowerCase();
    switch (ext) {
      case 'png':
        return MediaType('image', 'png');
      case 'gif':
        return MediaType('image', 'gif');
      case 'webp':
        return MediaType('image', 'webp');
      case 'bmp':
        return MediaType('image', 'bmp');
      case 'jpg':
      case 'jpeg':
      default:
        return MediaType('image', 'jpeg');
    }
  }

  AddProductController addProductController = Get.put(AddProductController());
  Future<AddProductModel> addProduct({
    required String sellerId,
    required File mainImage,
    required List<File> images,
    required String productName,
    required int price,
    required String category,
    required String subCategory,
    required String shippingCharges,
    required String description,
    required String productCode,
    required List<Map<String, dynamic>> attributes,
    required int productSaleType,
    required bool allowOffer,
    required int minimumOfferPrice,
    required String processingTime,
    required String recipientAddress,
    required bool isImmediatePaymentRequired,
    /// Optional list of admin-managed PromoCode ids the seller has
    /// opted this product into. Backend stores them on Product.promoCodes
    /// and they become eligible at checkout for buyers using those codes.
    List<String> promoCodes = const [],
    /// Optional delivery scope (`local` / `nationwide` / `international`)
    /// from the Pricing-page picker. Skipped from the multipart body when
    /// null/empty so the backend treats it as "leave existing".
    String? deliveryType,
    /// Shape B per-option shipping prices (v1.0.10). Each entry shaped as
    /// `{ "type": "local"|"nationwide"|"international", "price": <num> }`.
    /// JSON-encoded into a single `deliveryOptions` multipart field, mirror
    /// of how `attributes` is sent. Empty list → field is omitted so the
    /// backend's preserve-on-empty path leaves an existing value alone.
    List<Map<String, dynamic>>? deliveryOptions,
  }) async {
    final url = Uri.parse(Api.baseUrl + Api.createProduct);
    var request = http.MultipartRequest("POST", url);

    print('URL :: ${url}');

    if (mainImage.isBlank == true) {
      log("IMAGE NULL");
    } else {
      log("Images :: $images");
      for (int i = 0; i < images.length; i++) {
        var addImages = await http.MultipartFile.fromPath(
          'images',
          images[i].path,
          contentType: _getMediaType(images[i].path),
        );
        request.files.add(addImages);
      }
      log("Images path :: ${mainImage.path}");
      var addImage = await http.MultipartFile.fromPath(
        'mainImage',
        mainImage.path,
        contentType: _getMediaType(mainImage.path),
      );
      request.files.add(addImage);
    }

    request.headers.addAll({
      "key": Api.secretKey,
      "Content-Type": "application/json; charset=UTF-8",
    });

    Map<String, String> body = {
      'sellerId': sellerId,
      'productName': productName,
      'price': price.toString(),
      'category': category,
      'subCategory': subCategory,
      'shippingCharges': shippingCharges,
      'description': description,
      'productCode': productCode,
      'attributes': json.encode(attributes),
      'productSaleType': productSaleType.toString(),
      'allowOffer': allowOffer.toString(),
      'minimumOfferPrice': minimumOfferPrice.toString(),
      'processingTime': processingTime,
      'recipientAddress': recipientAddress,
      'isImmediatePaymentRequired': isImmediatePaymentRequired.toString(),
      // CSV is the simplest cross-language form for an array in
      // multipart/form-data. Backend's parsePromoCodeIds accepts it.
      if (promoCodes.isNotEmpty) 'promoCodes': promoCodes.join(','),
      if (deliveryType != null && deliveryType.isNotEmpty)
        'deliveryType': deliveryType,
      // Shape B (v1.0.10): JSON-encoded array of {type, price}. Skip when
      // empty so the backend's preserve-on-empty path leaves an existing
      // value alone. Mirrors the `attributes` field's encoding shape.
      if (deliveryOptions != null && deliveryOptions.isNotEmpty)
        'deliveryOptions': json.encode(deliveryOptions),
    };

    log("Product create by seller api body :: $body");

    request.fields.addAll(body);
    var res1 = await request.send();
    var response = await http.Response.fromStream(res1);

    log("Product create by seller api response ${response.body}");

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return AddProductModel.fromJson(jsonResponse);
    } else {
      throw Exception('Add Product failed');
    }
  }
}

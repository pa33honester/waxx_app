import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:waxxapp/ApiModel/seller/ProductEditModel.dart';
import 'package:waxxapp/utils/api_url.dart';
import 'package:get/get.dart';

import '../../utils/globle_veriables.dart';

class ProductEditApi extends GetxService {
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

  Future<ProductEditModel> editProduct({
    required String sellerId,
    required File mainImage,
    required List<File> images,
    required String productCode,
    required String productName,
    required int price,
    required String category,
    required String subCategory,
    required String shippingCharges,
    required String description,
    required List<Map<String, dynamic>> attributes,
    required int productSaleType,
    required bool allowOffer,
    required int minimumOfferPrice,
    required String processingTime,
    required String recipientAddress,
    required bool isImmediatePaymentRequired,
    List<String> promoCodes = const [],
  }) async {
    log("Edit Attributes json encode :: ${json.encode(attributes)}");
    log("Edit Attributes json encode :: ${attributes}");
    log("Product Code Service:: $productCode");
    // String uri = Api.getDomainFromURL(Api.baseUrl);
    // var params = {
    //   "productId": productId,
    //   "sellerId": sellerId,
    //   "productCode": productCode,
    // };

    final url = Uri.parse("${Api.baseUrl + Api.updateProductBySeller}?productId=$productId&sellerId=$sellerId&productCode=$productCode");

    print('URL :: $url');
    // final url = Uri.https(uri, Api.updateProductBySeller, params);

    var request = http.MultipartRequest("POST", url);

    if (mainImage.isBlank == true) {
      log("IMAGE NULL");
    } else {
      // for (int i = 0; i < images.length; i++) {
      //   var addImages = await http.MultipartFile.fromPath('images', images[i].path);
      //   request.files.add(addImages);
      // }
      // var addImage = await http.MultipartFile.fromPath('mainImage', mainImage.path);
      // request.files.add(addImage);

      for (final img in images) {
        request.files.add(await http.MultipartFile.fromPath(
          'images',
          img.path,
          contentType: _getMediaType(img.path),
        ));
      }
      request.files.add(await http.MultipartFile.fromPath(
        'mainImage',
        mainImage.path,
        contentType: _getMediaType(mainImage.path),
      ));
    }

    request.headers.addAll({
      "key": Api.secretKey,
      // "Content-Type": "application/json; charset=UTF-8",
    });

    // Map<String, String> body = {
    //   'sellerId': sellerId,
    //   'productName': productName,
    //   'price': price,
    //   'category': category,
    //   'subCategory': subCategory,
    //   'shippingCharges': shippingCharges,
    //   'description': description,
    //   'attributes': json.encode(attributes),
    //   'productSaleType': productSaleType.toString(),
    //   'allowOffer': allowOffer.toString(),
    //   'minimumOfferPrice': minimumOfferPrice.toString(),
    //   'enableAuction': enableAuction.toString(),
    //   'auctionStartingPrice': auctionStartingPrice.toString(),
    //   'enableReservePrice': enableReservePrice.toString(),
    //   'reservePrice': reservePrice.toString(),
    //   'auctionDuration': auctionDuration.toString(),
    //   'scheduleTime': scheduleTime,
    //   'processingTime': processingTime,
    //   'recipientAddress': recipientAddress,
    //   'isImmediatePaymentRequired': isImmediatePaymentRequired.toString(),
    // };

    // log('Seller edit product :: BODY :: $body');

    // request.fields.addAll(body);
    // var res1 = await request.send();
    // var response = await http.Response.fromStream(res1);

    request.fields.addAll({
      'sellerId': sellerId,
      'productName': productName,
      'price': price.toString(),
      'category': category,
      'subCategory': subCategory,
      'shippingCharges': shippingCharges,
      'description': description,
      'attributes': json.encode(attributes),
      'productSaleType': productSaleType.toString(),
      'allowOffer': allowOffer.toString(),
      'minimumOfferPrice': minimumOfferPrice.toString(),
      'processingTime': processingTime,
      'recipientAddress': recipientAddress,
      'isImmediatePaymentRequired': isImmediatePaymentRequired.toString(),
      'promoCodes': promoCodes.join(','),
    });

    log("Body Map :: ${request.fields}");

    try {
      final attrs = json.decode(request.fields['attributes']!);
      log("Attributes Pretty: ${const JsonEncoder.withIndent('  ').convert(attrs)}");
    } catch (e) {
      log("Attributes not valid JSON string: ${request.fields['attributes']}");
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    log('Seller edit product :: STATUS CODE :: ${response.statusCode} \n RESPONSE :: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return ProductEditModel.fromJson(jsonResponse);
    } else {
      throw Exception('Edit Product failed');
    }
  }
}

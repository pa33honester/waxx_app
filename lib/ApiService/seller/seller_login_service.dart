import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:era_shop/ApiModel/seller/SellerLoginModel.dart';
import 'package:era_shop/utils/api_url.dart';
import 'package:get/get.dart';

class SellerLoginApi extends GetxService {
  /// Returns the correct [MediaType] for the given file [path] based on its
  /// extension.  Falls back to `image/jpeg` so that the server never receives
  /// the generic `application/octet-stream` type that multer rejects.
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

  Future<SellerLoginModel?> sellerLogin({
    required String userId,
    required String storeName,
    required String businessTag,
    required String mobileNumber,
    required String countryCode,
    required String email,
    required String password,
    required String address,
    required String landMark,
    required String city,
    required String pinCode,
    required String state,
    required String country,
    required String bankBusinessName,
    required String bankName,
    required String accountNumber,
    required String IFSCCode,
    required String branchName,
    required String businessType,
    required String category,
    required String description,
    required File logo,
    required List<File> govId,
    required List<File> registrationCert,
    required List<File> addressProof,
  }) async {
    final url = Uri.parse(Api.baseUrl + Api.requestCreate);
    var request = http.MultipartRequest("POST", url);

    // Add headers
    request.headers['key'] = Api.secretKey;
    request.headers["Content-Type"] = "multipart/form-data";

    log("Logo path :: ${logo.path}");
    var addImage = await http.MultipartFile.fromPath(
      'logo',
      logo.path,
      contentType: _getMediaType(logo.path),
    );
    request.files.add(addImage);

    log("Gov ID Images :: $govId");
    for (int i = 0; i < govId.length; i++) {
      var addImages = await http.MultipartFile.fromPath(
        'govId',
        govId[i].path,
        contentType: _getMediaType(govId[i].path),
      );
      request.files.add(addImages);
    }
    for (int i = 0; i < registrationCert.length; i++) {
      var addImages = await http.MultipartFile.fromPath(
        'registrationCert',
        registrationCert[i].path,
        contentType: _getMediaType(registrationCert[i].path),
      );
      request.files.add(addImages);
    }
    for (int i = 0; i < addressProof.length; i++) {
      var addImages = await http.MultipartFile.fromPath(
        'addressProof',
        addressProof[i].path,
        contentType: _getMediaType(addressProof[i].path),
      );
      request.files.add(addImages);
    }

    // Add form fields as Map<String, String>
    request.fields.addAll({
      'userId': userId,
      'storeName': storeName,
      'businessTag': businessTag,
      'mobileNumber': mobileNumber,
      'countryCode': countryCode,
      'Email': email,
      'password': password,
      'address': address,
      'landMark': landMark,
      'city': city,
      'pinCode': pinCode,
      'state': state,
      'country': country,
      'bankBusinessName': bankBusinessName,
      'bankName': bankName,
      'accountNumber': accountNumber,
      'IFSCCode': IFSCCode,
      'branchName': branchName,
      'businessType': businessType,
      'category': category,
      'description': description,
    });

    log('Request fields: ${request.fields}');
    log('Request files: ${request.files.length}');

    try {
      var res1 = await request.send();
      var response = await http.Response.fromStream(res1);

      log("Product create by seller api response ${response.body}");
      log("Status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return SellerLoginModel.fromJson(jsonResponse);
      } else {
        log("Error response: ${response.body}");
        throw Exception('Seller Login Failed with status: ${response.statusCode}');
      }
    } catch (e) {
      log("Error in sellerLogin API: $e");
      throw Exception('Network error: $e');
    }
  }
}

import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:waxxapp/ApiModel/search/search_results_model.dart';
import 'package:waxxapp/utils/api_url.dart';

class UnifiedSearchService {
  static Map<String, String> get _headers => {
        'key': Api.secretKey,
        'Content-Type': 'application/json; charset=UTF-8',
      };

  static Future<SearchResults> search({
    required String query,
    String scope = 'all',
    int limit = 20,
  }) async {
    if (query.trim().length < 2) return const SearchResults();

    final url = Uri.parse("${Api.baseUrl}${Api.searchAll}").replace(queryParameters: {
      'q': query,
      'scope': scope,
      'limit': limit.toString(),
    });

    try {
      final resp = await http.get(url, headers: _headers);
      if (resp.statusCode != 200) return const SearchResults();
      final data = jsonDecode(resp.body);
      if (data['status'] != true) return const SearchResults();
      return SearchResults.fromJson(Map<String, dynamic>.from(data));
    } catch (e) {
      log('UnifiedSearchService error: $e');
      return const SearchResults();
    }
  }
}

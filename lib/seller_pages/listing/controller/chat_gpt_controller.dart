import 'dart:convert';
import 'package:era_shop/utils/api_url.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ChatGptController extends GetxController {
  static final key = openAiKey;

  Future<String> generateDescription(String prompt) async {
    final response = await http.post(
      Uri.parse(Api.openai),
      headers: {
        'Authorization': 'Bearer $key',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {
            "role": "system",
            "content": "Generate concise product descriptions (60-70 words) that highlight key features and benefits. Use relevant emojis to make the description more engaging and appealing. Maintain a professional tone while being creative."
          },
          {"role": "user", "content": prompt}
        ],
        "temperature": 0.3,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('Failed to generate description: ${response.statusCode}');
    }
  }
}

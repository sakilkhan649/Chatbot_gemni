import 'dart:convert';
import 'package:ai_chatbot/constant/api_constant.dart';
import 'package:http/http.dart' as http;

class GooglleApiService {
  static String apiKey = ApiContant.apiKey;
  static String baseUrl = ApiContant.baseUrl;

  static Future<String> getApiResponse(String message) async {
    try {
      final uri = Uri.parse("$baseUrl?key=$apiKey");

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": message},
              ],
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data.containsKey("candidates") && data["candidates"].isNotEmpty) {
          var firstCandidate = data["candidates"][0];

          if (firstCandidate.containsKey("content") &&
              firstCandidate["content"].containsKey("parts") &&
              firstCandidate["content"]["parts"].isNotEmpty) {
            return firstCandidate["content"]["parts"][0]["text"] ??
                "AI response is empty.";
          }
        }
        return "AI response is empty.";
      } else {
        print("Response body: ${response.body}");
        return "Error: ${response.statusCode} - ${response.body}";
      }
    } catch (e) {
      print("Error => $e");
      return "Error: $e";
    }
  }
}

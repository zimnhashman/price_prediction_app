import 'dart:convert';
import 'package:http/http.dart' as http;

class APIService {
  static const String baseUrl = 'http://127.0.0.1:5000';  // Your Flask server URL

  Future<double> getPrediction(String date) async {
    final response = await http.post(
      Uri.parse('$baseUrl/predict'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'date': date}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['prediction'];
    } else {
      throw Exception('Failed to load prediction');
    }
  }
}

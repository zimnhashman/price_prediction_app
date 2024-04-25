import 'dart:convert';
import 'package:http/http.dart' as http;

class ExchangeRateService {
  static Future<double> fetchExchangeRate() async {
    try {
      DateTime now = DateTime.now();
      String formattedDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      var apiUrl = 'https://a.success.africa/api/rates/fx-rates?day=$formattedDate';
      var response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        var rates = jsonData['rates'];
        var zigMidRate = rates['ZiG_Mid']; // Assuming 'ZiG_Mid' is the key for the rate in your rates object
        if (zigMidRate is double) {
          return zigMidRate;
        } else if (zigMidRate is int) {
          return zigMidRate.toDouble();
        } else {
          throw Exception('Invalid exchange rate format');
        }
      } else if (response.statusCode == 404) {
        throw Exception('Exchange rates not found for the specified date');
      } else if (response.statusCode == 500) {
        throw Exception('Internal Server Error: Failed to fetch exchange rates');
      } else {
        throw Exception('Failed to fetch exchange rates');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch exchange rates');
    }
  }
}

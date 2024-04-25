import 'package:flutter/material.dart';
import 'package:price_prediction_app/data/grocery_data.dart';
import 'package:price_prediction_app/screens/product_details.dart';
import 'package:price_prediction_app/services/exchangerate_service.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Map<String, dynamic>> filteredItems = [];
  double zigExchangeRate = 0.0; // Declare and initialize the ZigExchangeRate variable

  @override
  void initState() {
    super.initState();
    // Call fetchZigRate in initState and await it
    fetchZigRate();
  }

  Future<void> fetchZigRate() async {
    try {
      double exchangeRate = await ExchangeRateService.fetchExchangeRate();
      setState(() {
        zigExchangeRate = exchangeRate; // Update the ZigExchangeRate variable
      });
      print('ZiG_Mid exchange rate: $exchangeRate');
    } catch (e) {
      print('Error fetching exchange rate: $e');
    }
  }

  void filterItems(String query) {
    setState(() {
      filteredItems = groceryItemsList
          .where((item) => item['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery Item Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                filterItems(value);
              },
              decoration: const InputDecoration(
                hintText: 'Search items...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredItems[index]['name']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          // Use filteredItems[index] directly as the selected item
                          var selectedItem = filteredItems[index];

                          // Extract the price from the selected item, or use a default value if item not found
                          double currentUsdPrice = selectedItem['price'] ?? 0.0;

                          return ProductDetailsPage(
                            productName: selectedItem['name'],
                            currentUsdPrice: currentUsdPrice,
                            currentZigPrice: currentUsdPrice * zigExchangeRate, // Use ZigExchangeRate here
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

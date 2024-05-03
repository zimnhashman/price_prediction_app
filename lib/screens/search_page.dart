import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart'; // Import the page_transition package
import 'package:price_prediction_app/data/grocery_data.dart';
import 'package:price_prediction_app/screens/product_details.dart';
import 'package:price_prediction_app/services/exchangerate_service.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Map<String, dynamic>> filteredItems = [];
  double zigExchangeRate = 14.0; // Declare and initialize the ZigExchangeRate variable

  @override
  void initState() {
    super.initState();
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
        title: const Text(
          'Grocery Item Search',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        elevation: 0.0, // Remove app bar shadow
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[200], // Light background color
          borderRadius: BorderRadius.circular(10.0), // Rounded corners
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                onChanged: (value) {
                  filterItems(value);
                },
                decoration: InputDecoration(
                  hintText: 'Search items...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      filteredItems[index]['name'],
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        // Use PageTransition with slide right animation
                        PageTransition(
                          child: ProductDetailsPage(
                            productName: filteredItems[index]['name'],
                            currentUsdPrice: filteredItems[index]['price'] ?? 0.0,
                            currentZigPrice: (filteredItems[index]['price'] ?? 0.0) * zigExchangeRate,
                          ),
                          type: PageTransitionType.rotate, duration: const Duration(seconds: 2), alignment: Alignment.bottomLeft// Specify slide right animation
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

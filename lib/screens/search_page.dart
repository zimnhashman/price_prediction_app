import 'package:flutter/material.dart';
import 'package:price_prediction_app/models/product_model.dart';
import 'package:price_prediction_app/screens/product_details.dart';

// Sample list of products
List<Product> products = [
  Product(name: 'All Purpose Cleaner 750ml', supermarketsRTGSPrice: 10488.00, imagePath: 'url_to_image', tuckshopsUSDPrice: 1.60),
  // Add more products here
];

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Product> filteredProducts = [];

  void filterProducts(String query) {
    setState(() {
      filteredProducts = products
          .where((product) => product.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void navigateToProductDetails(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsPage(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                filterProducts(value);
              },
              decoration: const InputDecoration(
                hintText: 'Search items...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.network(filteredProducts[index].imagePath), // Image
                  title: Text(filteredProducts[index].name), // Product name
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('\$${filteredProducts[index].tuckshopsUSDPrice.toStringAsFixed(2)}'), // Tuckshops USD Price
                      Text('RTGS \$${filteredProducts[index].supermarketsRTGSPrice.toStringAsFixed(2)}'), // Supermarkets Price
                    ],
                  ),
                  onTap: () {
                    navigateToProductDetails(filteredProducts[index]);
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

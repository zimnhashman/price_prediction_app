import 'package:flutter/material.dart';
import 'package:price_prediction_app/models/product_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:price_prediction_app/screens/price_prediction_screen.dart';


class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage({Key? key, required this.product}) : super(key: key);

  void navigateToPredictionScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PredictionScreen(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                product.imagePath,
                height: 200,
                width: 200,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Historical Price Line Graph',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: LineChart(
                LineChartData(
                  // Define your line chart data here
                  minX: 0,
                  maxX: 10,
                  minY: 0,
                  maxY: 100,
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 10),
                        FlSpot(1, 30),
                        FlSpot(2, 50),
                        FlSpot(3, 70),
                        FlSpot(4, 90),
                      ],
                      isCurved: true,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                navigateToPredictionScreen(context);
              },
              child: const Text('Go to Prediction Screen'),
            ),
          ],
        ),
      ),
    );
  }
}

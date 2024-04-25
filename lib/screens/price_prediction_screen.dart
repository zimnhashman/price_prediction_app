import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:csv/csv.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

class PricePredictionPage extends StatefulWidget {
  @override
  _PricePredictionPageState createState() => _PricePredictionPageState();
}

class _PricePredictionPageState extends State<PricePredictionPage> {
  List<String> dates = [];
  List<double> usdPrices = [];
  List<double> zigPrices = [];
  List<String> products = []; // To store product names

  @override
  void initState() {
    super.initState();
    loadCSVData();
  }

  Future<void> loadCSVData() async {
    final String rawCSV = await rootBundle.loadString('assets/files/data.csv');
    List<List<dynamic>> csvData = const CsvToListConverter().convert(rawCSV);

    // Assuming the first row contains headers
    for (var i = 1; i < csvData.length; i++) {
      dates.add(csvData[i][0]);
      usdPrices.add(double.parse(csvData[i][1].toString().split('\$')[1]));
      zigPrices.add(double.parse(csvData[i][2].toString().split('\$')[1]));
      products.add(csvData[i][0].toString());
    }
    setState(() {}); // Update the UI after loading CSV data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Price Prediction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(products[index]),
                const SizedBox(height: 8),
                LineChart(productLineChartData(index)),
                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }

  LineChartData productLineChartData(int index) {
    List<FlSpot> usdSpots = List.generate(
      dates.length,
          (i) => FlSpot(i.toDouble(), usdPrices[i]),
    );

    List<FlSpot> zigSpots = List.generate(
      dates.length,
          (i) => FlSpot(i.toDouble(), zigPrices[i]),
    );

    return LineChartData(
      lineBarsData: [
        LineChartBarData(
          spots: usdSpots,
          isCurved: true,
          color: Colors.blue,
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
        ),
        LineChartBarData(
          spots: zigSpots,
          isCurved: true,
          color: Colors.green,
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
        ),
      ],
      gridData: const FlGridData(show: false),
      titlesData: const FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
    );
  }
}

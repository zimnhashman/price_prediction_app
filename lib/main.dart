import 'package:flutter/material.dart';
import 'package:price_prediction_app/screens/search_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Price Prediction App',
      theme: ThemeData(
        primaryColor: Colors.grey,
      ),
      home: SearchPage(),
    );
  }
}

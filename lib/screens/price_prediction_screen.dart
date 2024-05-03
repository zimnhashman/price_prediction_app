import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PricePredictionPage extends StatefulWidget {
  final String productName;
  final double currentUsdPrice;
  final double currentZigPrice;

  const PricePredictionPage({
    Key? key,
    required this.productName,
    required this.currentUsdPrice,
    required this.currentZigPrice,
  }) : super(key: key);

  @override
  _PricePredictionPageState createState() => _PricePredictionPageState();
}

class _PricePredictionPageState extends State<PricePredictionPage> {
  final _formKey = GlobalKey<FormState>();
  late double _userPrediction; // Use initial ZIG price
  DateTime? _selectedDate;
  String _predictedPrice = '';
  String _predictedZigPrice = '';

  @override
  void initState() {
    super.initState();
    _userPrediction = widget.currentUsdPrice;
  }

  Future<void> _selectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024, 1, 1),
      lastDate: DateTime(2026, 1, 1),
    );
    if (selectedDate != null) {
      setState(() {
        _selectedDate = selectedDate;
      });
    }
  }

  String _getPrediction() {
    final month = _selectedDate!.month;
    if (month == 8 || month == 10) {
      // Simulate price increase for Nov & Dec
      return 'Predicted Price: \$${(_userPrediction * 1.1).toStringAsFixed(2)} (Potential Increase)';
    } else if (month == 6) {
      return 'Predicted Price: \$${(_userPrediction * 1.01).toStringAsFixed(2)} (Potential Increase)';
    } else if (month == 9) {
      return 'Predicted Price: \$${(_userPrediction * 1.08).toStringAsFixed(2)} (Potential Increase)';
    } else if (month == 11 || month == 12) {
      return 'Predicted Price: \$${(_userPrediction * 0.97).toStringAsFixed(2)} (Potential Decrease)';
    } else if (month == 1 || month == 2) {
      return 'Predicted Price: \$${(_userPrediction * 1.2).toStringAsFixed(2)} (Potential Increase)';
    } else {
      return 'Predicted Price: \$${(_userPrediction * 1.0).toStringAsFixed(2)} (Potential Increase)';
    }
  }

  String _getZigPrediction() {
    final month = _selectedDate!.month;
    if (month == 6) {
      return 'Predicted ZiG Price: \$${(_userPrediction * 1.01 * 20).toStringAsFixed(2)} (Potential Increase)';
    } else if (month == 7) {
      return 'Predicted ZiG Price: \$${(_userPrediction * 1.00 * 23).toStringAsFixed(2)} (Potential Increase)';
    } else if (month == 8) {
      return 'Predicted ZiG Price: \$${(_userPrediction * 1.1 * 22).toStringAsFixed(2)} (Potential Increase)';
    } else if (month == 9) {
      return 'Predicted ZiG Price: \$${(_userPrediction * 1.08 * 27).toStringAsFixed(2)} (Potential Increase)';
    } else if (month == 10) {
      return 'Predicted ZiG Price: \$${(_userPrediction * 1.1 * 30).toStringAsFixed(2)} (Potential Increase)';
    } else if (month == 11) {
      return 'Predicted ZiG Price: \$${(_userPrediction * 0.97 * 37).toStringAsFixed(2)} (Potential Increase)';
    } else if (month == 12) {
      return 'Predicted ZiG Price: \$${(_userPrediction * 0.97 * 40).toStringAsFixed(2)} (Potential Increase)';
    } else if (month == 1) {
      return 'Predicted ZiG Price: \$${(_userPrediction * 1.2 * 41).toStringAsFixed(2)} (Potential Increase)';
    } else if (month == 2) {
      return 'Predicted ZiG Price: \$${(_userPrediction * 1.2 * 44).toStringAsFixed(2)} (Potential Increase)';
    } else {
      return 'Predicted Zig Price: \$${(_userPrediction * 14).toStringAsFixed(2)} (Potential Increase)';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Price Prediction for ${widget.productName}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurpleAccent, Colors.purpleAccent],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Current Tuckshop USD Price: \$${widget.currentUsdPrice.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10),
                Text(
                  'Current ZIG Price: \$${widget.currentZigPrice.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: _selectDate,
                  child: Text(
                    _selectedDate?.toIso8601String() ?? 'Select Prediction Date',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      setState(() {
                        _predictedPrice = _getPrediction();
                        _predictedZigPrice = _getZigPrediction();
                      });
                    }
                  },
                  child: const Text('Predict Price'),
                ),
                const SizedBox(height: 20),
                Text(
                  _predictedPrice,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  _predictedZigPrice,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

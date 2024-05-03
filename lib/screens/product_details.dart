import 'package:flutter/material.dart';
import 'package:price_prediction_app/screens/price_prediction_screen.dart';

class ProductDetailsPage extends StatefulWidget {
  final String productName;
  final double currentUsdPrice;
  final double currentZigPrice;

  const ProductDetailsPage({
    super.key,
    required this.productName,
    required this.currentUsdPrice,
    required this.currentZigPrice,
  });

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _animation = Tween<double>(
      begin: widget.currentZigPrice -
          9, // Starting value slightly below actual value
      end: widget.currentZigPrice,
    ).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Current Tuckshop USD Price: \$${widget.currentUsdPrice.toStringAsFixed(2)}'),
            const SizedBox(height: 10),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Text(
                    'Current ZIG Price: \$${_animation.value.toStringAsFixed(2)}');
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PricePredictionPage(
                              productName: widget.productName,
                              currentUsdPrice: widget.currentUsdPrice,
                              currentZigPrice: widget.currentZigPrice,
                            )));
              },
              child: const Text('Go to Price Prediction'),
            ),
          ],
        ),
      ),
    );
  }
}

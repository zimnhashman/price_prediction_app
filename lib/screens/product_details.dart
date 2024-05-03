import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:price_prediction_app/screens/price_prediction_screen.dart';

class ProductDetailsPage extends StatefulWidget {
  final String productName;
  final double currentUsdPrice;
  final double currentZigPrice;

  const ProductDetailsPage({
    Key? key,
    required this.productName,
    required this.currentUsdPrice,
    required this.currentZigPrice,
  }) : super(key: key);

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
      duration: const Duration(seconds: 1),
    );
    _animation = Tween<double>(
      begin: widget.currentZigPrice - 9,
      end: widget.currentZigPrice,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Tuckshop USD Price: \$${widget.currentUsdPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Text(
                    'Current ZIG Price: \$${_animation.value.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(child: PricePredictionPage(
                        productName: widget.productName,
                        currentUsdPrice: widget.currentUsdPrice,
                        currentZigPrice: widget.currentZigPrice,
                      ), type: PageTransitionType.rotate, duration: const Duration(seconds: 2), alignment: Alignment.bottomLeft,
                    ),
                  );
                },
                icon: const Icon(Icons.trending_up),
                label: const Text('Go to Price Prediction'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blueAccent, backgroundColor: Colors.white,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

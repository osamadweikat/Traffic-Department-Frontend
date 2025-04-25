import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.6),
      child: Center(
        child: Lottie.asset(
          'assets/animations/Animation.json',
          width: 350,
          height: 350,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

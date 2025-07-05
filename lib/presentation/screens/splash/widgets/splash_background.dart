import 'package:flutter/material.dart';

class SplashBackground extends StatelessWidget {
  const SplashBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 0.9,
              colors: [
                Color(0xFF000919),
                Color(0xFF01379C),
              ],
              stops: [0.2, 1.0],
            ),
          ),
        ),
        Positioned.fill(
          child: Image.asset(
            'assets/images/lines.png',
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}

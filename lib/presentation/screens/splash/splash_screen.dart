import 'dart:math';

import 'package:flutter/material.dart';
import '../../../ar_view_screen.dart';
import '../../../data/services/user_local_service.dart';
import '../home/home_screen.dart';
import '../win_screen.dart';


class SplashScreen extends StatefulWidget {
  static const String routeName = "SplashScreen";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () async {
      if (context.mounted) {
        final existingUser = await UserLocalService.getActiveUser();
        if (existingUser != null && existingUser.hasCompletedGame) {
          Navigator.pushReplacementNamed(context, WinScreen.routeName, arguments: {'finalScore': existingUser.points});
        } else if (existingUser != null) {
          Navigator.pushReplacementNamed(context, ARViewScreen.routeName);
        } else {
          Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius:1,
                colors: [
                  Color(0xFFFFFFFF),
                  Color(0xFF0099CC),
                ],
                stops: [0.02,1],
              ),
            ),
          ),
          Positioned.fill(
            child: Image.asset(
              'assets/images/lines3.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Text(
                  "AR GAME FIND ME",
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: const Offset(2, 2),
                        blurRadius: 6,
                        color: Colors.black.withOpacity(0.9),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
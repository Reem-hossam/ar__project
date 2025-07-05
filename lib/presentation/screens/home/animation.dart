import 'package:flutter/animation.dart';

class HomeAnimations {
  final TickerProvider vsync;
  late final AnimationController initialAppearanceController;
  late final AnimationController crownFloatController;

  late final Animation<double> findMeOpacity;
  late final Animation<double> findMeScale;
  late final Animation<double> crownOpacity;
  late final Animation<double> crownScale;
  late final Animation<double> buttonOpacity;
  late final Animation<Offset> crownFloat;

  HomeAnimations(this.vsync) {
    initialAppearanceController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: vsync,
    );

    findMeOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: initialAppearanceController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );
    findMeScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: initialAppearanceController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );
    crownOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: initialAppearanceController,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
      ),
    );
    crownScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: initialAppearanceController,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
      ),
    );
    buttonOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: initialAppearanceController,
        curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
      ),
    );

    crownFloatController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: vsync,
    );
    crownFloat = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, -0.1),
    ).animate(
      CurvedAnimation(
        parent: crownFloatController,
        curve: Curves.easeInOutSine,
      ),
    );
  }

  void startAnimations() {
    initialAppearanceController.forward().whenComplete(() {
      crownFloatController.repeat(reverse: true);
    });
  }

  void dispose() {
    initialAppearanceController.dispose();
    crownFloatController.dispose();
  }
}

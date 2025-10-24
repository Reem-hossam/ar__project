import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../signup/sign_up_screen.dart';
import 'animation.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "HomeScreen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late HomeAnimations animations;

  @override
  void initState() {
    super.initState();
    animations = HomeAnimations(this);
    animations.startAnimations();
  }

  @override
  void dispose() {
    animations.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          const _Background(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50.h),
                FadeTransition(
                  opacity: animations.findMeOpacity,
                  child: ScaleTransition(
                    scale: animations.findMeScale,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        "FindMe",
                        style: theme.textTheme.displaySmall?.copyWith(
                          color: const Color(0xFF0099CC),
                          fontWeight: FontWeight.bold,
                          fontSize: 30.sp,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height:80.h),
                AnimatedBuilder(
                  animation: animations.initialAppearanceController,
                  builder: (_, __) {
                    return Opacity(
                      opacity: animations.crownOpacity.value,
                      child: Transform.scale(
                        scale: animations.crownScale.value,
                        child: SlideTransition(
                          position: animations.crownFloat,
                          child: Image.asset(
                            'assets/images/crown.png',
                            width: 250.w,
                            height: 250.h,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 60.h),
                FadeTransition(
                  opacity: animations.buttonOpacity,
                  child: SizedBox(
                    width: 0.8.sw,
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, SignUpScreen.routeName);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0.r),
                        ),
                      ),
                      child: Text(
                        "Let's Play",
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Background extends StatelessWidget {
  const _Background();

  @override
  Widget build(BuildContext context) {
    return Stack(
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
      ],
    );
  }
}

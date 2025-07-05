import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/utils/app_theme.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/splash/splash_screen.dart';
import 'presentation/screens/signup/sign_up_screen.dart';
import 'presentation/screens/about/about_us_screen.dart';

void main() {
  runApp(const ARGameApp());
}

class ARGameApp extends StatelessWidget {
  const ARGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (_, __) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: SplashScreen.routeName,
        routes: {
          HomeScreen.routeName: (context) => const HomeScreen(),
          SignUpScreen.routeName: (context) => const SignUpScreen(),
          AboutUsScreen.routeName: (context) => const AboutUsScreen(),
          SplashScreen.routeName: (context) => const SplashScreen(),
        },
      ),
    );
  }
}

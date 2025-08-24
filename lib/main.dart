import 'package:ar_project/presentation/screens/win_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'ar_view_screen.dart';
import 'core/db.dart';
import 'core/utils/app_theme.dart';
import 'data/services/api_service.dart';
import 'presentation/screens/signup/sign_up_screen.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/splash/splash_screen.dart';
import 'presentation/screens/about/about_us_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await DB.init();
  await ApiService.syncPendingUsers();
  await ApiService.syncPendingPoints();
  runApp(const ARGameApp());
}

class ARGameApp extends StatefulWidget {
  const ARGameApp({super.key});

  @override
  State<ARGameApp> createState() => _ARGameAppState();
}

class _ARGameAppState extends State<ARGameApp> {
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
          ARViewScreen.routeName: (context) => const ARViewScreen(),
          WinScreen.routeName: (context) => WinScreen(
            finalScore: (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?)?['finalScore'] ?? 0,
          ),
        },
      ),
    );
  }
}

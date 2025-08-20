import 'package:ar_project/presentation/screens/signup/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/services/user_local_service.dart';
import '../../../data/models/user.dart';
import '../../ar_view_screen.dart';


class UserWelcomeScreen extends StatefulWidget {
  static const routeName = "UserWelcomeScreen";
  const UserWelcomeScreen({super.key});

  @override
  State<UserWelcomeScreen> createState() => _UserWelcomeScreenState();
}

class _UserWelcomeScreenState extends State<UserWelcomeScreen> {
  User? user;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final activeUser = await UserLocalService.getActiveUser();
    setState(() {
      user = activeUser;
    });
  }

  void logout() async {
    await UserLocalService.logoutUser();
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        SignUpScreen.routeName,
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Stack(
        children:[
          const _Background(),
          Center(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Welcome, ${user!.username}!",
                  style: TextStyle(color: Colors.white, fontSize: 28.sp),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.h),
                Text(
                  "Your current score: ${user!.points}",
                  style: TextStyle(color: Colors.white70, fontSize: 20.sp),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40.h),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ARViewScreen(),
                      ),
                    );
                  },
                  child: const Text("Start Game"),
                ),
                TextButton(
                  onPressed: logout,
                  child: const Text("Log out", style: TextStyle(color: Colors.redAccent)),
                )
              ],
            ),
          ),
        ),
    ]
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
              radius: 0.9,
              colors: [
                Color(0xFF000919),
                Color(0xFF006F94),
              ],
              stops: [0.2, 1.0],
            ),
          ),
        ),
        Positioned.fill(
          child: Image.asset(
            'assets/images/lines2.png',
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}

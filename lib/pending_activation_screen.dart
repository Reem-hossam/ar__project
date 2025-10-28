import 'dart:async';
import 'package:ar_project/presentation/screens/about/about_us_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/services/api_service.dart';
import '../../data/services/user_local_service.dart';

class PendingActivationScreen extends StatefulWidget {
  static const String routeName = "PendingActivationScreen";

  const PendingActivationScreen({super.key});

  @override
  State<PendingActivationScreen> createState() => _PendingActivationScreenState();
}

class _PendingActivationScreenState extends State<PendingActivationScreen> {
  Timer? _activationTimer;
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  void _startPolling() {
    _activationTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      if (!mounted) { timer.cancel(); return; }
      if (_isChecking) return;

      final activeUser = await UserLocalService.getActiveUser();

      if (activeUser == null || activeUser.serverId == null) {
        timer.cancel();
        print("Error: Active user not found or missing Server ID.");
        return;
      }

      setState(() {
        _isChecking = true;
      });

      final isAuthorized = await ApiService.fetchServerAuthorizationStatus(activeUser.serverId!);

      if (isAuthorized) {
        timer.cancel();

        activeUser.isAuthorizedToPlay = true;
        await UserLocalService.saveUser(activeUser);

        if (mounted) {
          Navigator.of(context).pushReplacementNamed(AboutUsScreen.routeName);
        }
      }

      setState(() {
        _isChecking = false;
      });
    });
  }

  @override
  void dispose() {
    _activationTimer?.cancel();
    super.dispose();
  }

  List<Shadow> _getTextShadows() {
    return [
      Shadow(
        offset: const Offset(2, 2),
        blurRadius: 6,
        color: Colors.black.withOpacity(0.9),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius:1,
                colors: [Color(0xFFFFFFFF), Color(0xFF0099CC)],
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
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: Colors.white),
                  SizedBox(height: 30.h),

                  Text(
                    "Account Registered Successfully!",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontSize: 28.sp,
                      color: Colors.white,
                      shadows: _getTextShadows(),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Please approach the booth administrator to activate your account and allow you to start the game.",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      shadows: _getTextShadows(),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  ElevatedButton(
                    onPressed: _isChecking ? null : () async {
                      final activeUser = await UserLocalService.getActiveUser();
                      if (activeUser == null || activeUser.serverId == null) return;

                      setState(() => _isChecking = true);

                      final isAuthorized = await ApiService.fetchServerAuthorizationStatus(activeUser.serverId!);

                      if (isAuthorized) {
                        _activationTimer?.cancel();
                        activeUser.isAuthorizedToPlay = true;
                        await UserLocalService.saveUser(activeUser);
                        if (mounted) {
                          Navigator.of(context).pushReplacementNamed(AboutUsScreen.routeName);
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Still not activated yet.")),
                        );
                      }

                      setState(() => _isChecking = false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                      child: Text(
                        "Check Again",
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
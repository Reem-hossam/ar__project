import 'package:ar_project/ar_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widgets/about_info_box.dart';

class AboutUsScreen extends StatelessWidget {
  static const String routeName = "AboutUsScreen";
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          const _Background(),
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 80.h),
                Center(
                  child: Text(
                    "PLAYING THE GAME AND LEARN",
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: Color.fromRGBO(1, 58, 77, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                SizedBox(height: 30.h),
                const AboutInfoBox(),
                SizedBox(height: 40.h),
                Center(
                  child: SizedBox(
                    width: 0.8.sw,
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ARViewScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0.r),
                        ),
                      ),
                      child: Text(
                        "PLAY",
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
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
          child: Image.asset('assets/images/lines3.png', fit: BoxFit.cover),
        ),
      ],
    );
  }
}

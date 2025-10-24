import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutInfoBox extends StatelessWidget {
  const AboutInfoBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(32, 93, 114, 1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "ABOUT US",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            "Welcome to FindMe! In this exciting AR game, your mission is to find hidden robots in your real-world environment. Use your device's camera to scan your surroundings. When a robot appears, get closer to it to earn points! The goal is to collect as many points as you can by finding all the robots.",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
            ),
          ),
          const Divider(color: Colors.white),
          _buildInfoText("Platform: Android & iOS"),
          _buildInfoText("Version: 1.0"),
          _buildInfoText("Release: 2025"),
          const Divider(color: Colors.white),
          SizedBox(height: 20.h),
          _buildInfoText("Game Director: Benny burham, M.Pd"),
          _buildInfoText("Game Designer: Lyla Muha, S.Ag"),
          _buildInfoText("Game Developer: COMING SOON"),
          _buildInfoText("Fullstack Developer: COMING SOON"),
          _buildInfoText("Product Manager: COMING SOON"),
        ],
      ),
    );
  }

  Widget _buildInfoText(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0.h),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.sp,
        ),
      ),
    );
  }
}

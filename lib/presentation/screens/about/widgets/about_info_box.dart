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
          _buildInfoText("CSCEC International Egypt is the official Egyptian subsidiary of China State Construction Engineering Corporation (CSCEC), one of the world’s largest construction and engineering conglomerates. As a registered Egyptian contractor, the company operates with full legal presence in Egypt while maintaining the strong backing and expertise of its global parent company."),
          const Divider(color: Colors.white),
          _buildInfoText("CSCEC Ranked No. 1 Global Contractor by the U.S. magazine ENR from 2016 to 2024."),
          const Divider(color: Colors.white),
          _buildInfoText("Awarded the highest credit rating in the global construction industry (A, stable outlook) by Standard & Poor’s, Moody’s, and Fitch."),
          const Divider(color: Colors.white),
          _buildInfoText("Ranked 14th among the Global Fortune 500 Companies in 2024."),
          const Divider(color: Colors.white),
          _buildInfoText("Ranked 4th among the China Fortune 500 Companies in 2024."),
          const Divider(color: Colors.white),
          _buildInfoText("You can find us in Hall 1 stand 1E7"),

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


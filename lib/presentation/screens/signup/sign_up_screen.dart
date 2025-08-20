import 'package:ar_project/presentation/screens/signup/sign_up_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../about/about_us_screen.dart';



class SignUpScreen extends StatefulWidget {
  static const String routeName = "SignUpScreen";
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();

}

class _SignUpScreenState extends State<SignUpScreen> {
  final SignUpController _controller = SignUpController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
            gradient: RadialGradient(center: Alignment.center, radius: 0.9,
              colors: [
                Color(0xFF000919),
                Color(0xFF006F94),],
              stops: [0.2, 1.0],
            ),
            ),
          ),
          Positioned.fill(
            child: Image.asset(
              'assets/images/lines.png',
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 100.h),
                Text(
                  "Register your Account",
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30.h),
                _buildTextField(_controller.userNameController, "Username", "assets/images/person.png"),
                SizedBox(height: 15.h),
                _buildTextField(_controller.jobTitleController, "Job Title", "assets/images/job.png"),
                SizedBox(height: 15.h),
                _buildTextField(_controller.companyNameController, "Company name", "assets/images/company.png"),
                SizedBox(height: 30.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildUserIconOption('user_icon1','male'),
                    SizedBox(width: 30.w),
                    _buildUserIconOption('user_icon2','female'),
                  ],
                ),
                SizedBox(height: 40.h),
                SizedBox(
                  width: 0.8.sw,
                  height: 52.h,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (!_controller.isFormValid) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please fill in all fields.')),
                        );
                        return;
                      }
                      bool success = await _controller.registerUser();
                      if (success) {
                        Navigator.pushNamed(context, AboutUsScreen.routeName);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Registration failed. Check internet or try again later.')),
                        );
                      }
                    },


                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0.r),
                      ),
                    ),
                    child: Text(
                      "SIGN UP",
                      style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Back to Home",
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, String iconPath) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      height: 55.h,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(68, 80, 255, 0.82),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Image.asset(
              iconPath,
              width: 20.w,
              height: 20.h,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              style: theme.textTheme.labelSmall?.copyWith(color: Colors.white),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: theme.textTheme.labelSmall?.copyWith(color: Colors.white),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserIconOption(String iconName, String genderValue) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _controller.selectedGender = genderValue;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: _controller.selectedGender == genderValue
              ? Border.all(color: Colors.white, width: 3.0)
              : null,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Image.asset('assets/images/$iconName.png', width: 80.w, height: 80.h),
      ),
    );
  }
}

import 'package:ar_project/pending_activation_screen.dart';
import 'package:ar_project/presentation/screens/signup/sign_up_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = "SignUpScreen";
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final SignUpController _controller = SignUpController();
  bool _isLoading = false;

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
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1,
                colors: [
                  Color(0xFFFFFFFF),
                  Color(0xFF0099CC),
                ],
                stops: [0.02, 1],
              ),
            ),
          ),
          Positioned.fill(
            child: Image.asset(
              'assets/images/lines3.png',
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50.h),
                Container(
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
                SizedBox(height: 50.h),
                Text(
                  "Register your Account",
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: const Color.fromRGBO(1, 58, 77, 1),
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
                SizedBox(height: 15.h),
                _buildTextField(_controller.phoneNumberController, "Phone Number", "assets/images/phone.png"),
                SizedBox(height: 15.h),
                _buildTextField(_controller.emailController, "Email", "assets/images/email.png"),
                SizedBox(height: 15.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildUserIconOption('user_icon1', 'male'),
                    SizedBox(width: 12.w),
                    _buildUserIconOption('user_icon2', 'female'),
                  ],
                ),
                SizedBox(height: 35.h),
                SizedBox(
                  width: 0.8.sw,
                  height: 52.h,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                      setState(() => _isLoading = true);
                      final result = await _controller.registerUser();
                      setState(() => _isLoading = false);

                      if (result == null) {
                        Navigator.pushNamed(context, PendingActivationScreen.routeName);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(result)),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0.r),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                      "SIGN UP",
                      style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
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
      decoration: const BoxDecoration(color: Color.fromRGBO(0, 153, 204, 1)),
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
        padding: EdgeInsets.all(5.sp),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(0, 153, 204, 1),
          border: _controller.selectedGender == genderValue
              ? Border.all(color: Colors.white, width: 3.0)
              : null,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Image.asset('assets/images/$iconName.png', width: 65.w, height: 65.h),
      ),
    );
  }
}

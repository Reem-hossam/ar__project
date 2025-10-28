import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import '../../../data/models/user.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/user_local_service.dart';

class SignUpController {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  String? selectedGender;

  bool get isFormValid =>
      userNameController.text.isNotEmpty &&
          jobTitleController.text.isNotEmpty &&
          companyNameController.text.isNotEmpty &&
          phoneNumberController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          selectedGender != null;

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    return emailRegex.hasMatch(email);
  }

  bool isValidEgyptianPhone(String phone) {
    final phoneRegex = RegExp(r'^201[0-5]\d{8}$');
    return phoneRegex.hasMatch(phone);
  }

  Future<String?> registerUser() async {
    if (!isFormValid) return "Please fill all fields.";

    if (!isValidEmail(emailController.text.trim())) {
      return "Please enter a valid email address.";
    }

    if (!isValidEgyptianPhone(phoneNumberController.text.trim())) {
      return "Please enter a valid Egyptian phone number (e.g. 2010xxxxxxx).";
    }

    final newUser = User()
      ..username = userNameController.text.trim()
      ..jobTitle = jobTitleController.text.trim()
      ..company = companyNameController.text.trim()
      ..phoneNumber = phoneNumberController.text.trim()
      ..email = emailController.text.trim()
      ..gender = selectedGender!
      ..synced = false
      ..isActive = true
      ..isAuthorizedToPlay = false;

    final connectivityResult = await Connectivity().checkConnectivity();
    final hasInternet = connectivityResult != ConnectivityResult.none;

    if (hasInternet) {
      try {
        final registeredUser = await ApiService.registerUserOnServer(newUser);
        if (registeredUser != null && registeredUser.serverId != null) {
          print('User registered successfully on server: ${newUser.username}');
          return null;
        } else {
          return "Registration failed. Please try again later.";
        }
      } catch (e) {
        print("Error while registering on server: $e");
        return "Server error: unable to register. Please check your email or phone.";
      }
    }

    await UserLocalService.saveUser(newUser);
    print('User saved locally (offline): ${newUser.username}');
    return null;
  }

  void dispose() {
    userNameController.dispose();
    jobTitleController.dispose();
    companyNameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
  }
}

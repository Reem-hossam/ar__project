import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import '../../../core/db.dart';
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

  Future<bool> registerUser() async {
    if (!isFormValid) {
      print("Form is not valid. Please fill all fields.");
      return false;
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
      final registeredUser = await ApiService.registerUserOnServer(newUser);
      if (registeredUser != null && registeredUser.serverId != null) {
        print(' User registered on server and saved locally: ${newUser.username}');
        return true;
      } else {
        print(' Failed to register user on server. Saving locally only.');
      }
    }

    await UserLocalService.saveUser(newUser);

    print(' User saved locally without internet: ${newUser.username}');
    return true;
  }

  void dispose() {
    userNameController.dispose();
    jobTitleController.dispose();
    companyNameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
  }
}

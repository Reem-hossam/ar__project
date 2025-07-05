import 'package:flutter/material.dart';

class SignUpController {
  final TextEditingController userNameController;
  final TextEditingController jobTitleController;
  final TextEditingController companyNameController;

  String? selectedIcon;

  SignUpController({
    String? initialUsername,
    String? initialJobTitle,
    String? initialCompanyName,
  })  : userNameController = TextEditingController(text: initialUsername),
        jobTitleController = TextEditingController(text: initialJobTitle),
        companyNameController = TextEditingController(text: initialCompanyName);

  void selectIcon(String icon) {
    selectedIcon = icon;
  }

  void dispose() {
    userNameController.dispose();
    jobTitleController.dispose();
    companyNameController.dispose();
  }

  bool isFormValid() {
    return userNameController.text.trim().isNotEmpty &&
        jobTitleController.text.trim().isNotEmpty &&
        companyNameController.text.trim().isNotEmpty &&
        selectedIcon != null;
  }

  Map<String, String> get formData => {
    'username': userNameController.text.trim(),
    'jobTitle': jobTitleController.text.trim(),
    'company': companyNameController.text.trim(),
    'icon': selectedIcon ?? '',
  };
}

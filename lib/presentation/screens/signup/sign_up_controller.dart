import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../../../core/db.dart';
import '../../../data/models/user.dart';
import '../../../data/services/api_service.dart';

class SignUpController {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  String? selectedGender;


  bool get isFormValid =>
      userNameController.text.isNotEmpty &&
          jobTitleController.text.isNotEmpty &&
          companyNameController.text.isNotEmpty &&
          selectedGender != null;

  Future<bool> registerUser() async {
    if (!isFormValid) {
      print("Form is not valid. Please fill all fields.");
      return false;
    }

    await DB.isar.writeTxn(() async {
      final oldUsers = await DB.isar.users.where().findAll();
      for (final user in oldUsers) {
        user.isActive = false;
        await DB.isar.users.put(user);
      }
    });

    final newUser = User()
      ..username = userNameController.text.trim()
      ..jobTitle = jobTitleController.text.trim()
      ..company = companyNameController.text.trim()
      ..gender = selectedGender!
      ..synced = false
      ..isActive = true;

    final connectivityResult = await Connectivity().checkConnectivity();
    final hasInternet = connectivityResult != ConnectivityResult.none;

    if (hasInternet) {
      final registeredUser = await ApiService.registerUserOnServer(newUser);

      if (registeredUser != null) {
        registeredUser.isActive = true;

        await DB.isar.writeTxn(() async {
          await DB.isar.users.put(registeredUser);
        });

        print('User registered on server and saved locally: ${registeredUser.username}');
        return true;
      } else {
        print('Server failed. Saving user locally only.');
      }
    }

    await DB.isar.writeTxn(() async {
      await DB.isar.users.put(newUser);
    });

    print('User saved locally without internet: ${newUser.username}');
    return true;
  }


  void dispose() {
    userNameController.dispose();
    jobTitleController.dispose();
    companyNameController.dispose();
  }
}
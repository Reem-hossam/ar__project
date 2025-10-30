import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import 'user_local_service.dart';

class ApiService {
  static const base = 'https://cesec.vercel.app';

  static Future<User?> registerUserOnServer(User user) async {
    final connection = await Connectivity().checkConnectivity();
    if (connection == ConnectivityResult.none) {
      print("No internet connection. Skipping API call.");
      return null;
    }

    try {
      final res = await http.post(
        Uri.parse('$base/api/users/'),
        body: jsonEncode({
          "username": user.username,
          "email":user.email,
          "jobTitle": user.jobTitle,
          "companyName": user.company,
          "phoneNumber": user.phoneNumber,
          "gender": user.gender,

        }),
        headers: {"Content-Type": "application/json"},
      );

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final body = jsonDecode(res.body);

        final serverId = body['data']?['_id'];
        user.serverId = serverId?.toString();
        user.synced = true;

        print("User registered on server with ID: ${user.serverId}");
        await UserLocalService.saveUser(user);
        return user;
      } else {
        print("Failed to register user on server: ${res.statusCode} - ${res.body}");
        return null;
      }
    } catch (e) {
      print("Error registering user on server: $e");
      return null;
    }
  }


  static Future<bool> sendPointsUpdateToServer(String serverId, int points) async {
    try {
      final res = await http.patch(
        Uri.parse('$base/api/users/addPoints/$serverId'),
        body: jsonEncode({"points": points}),
        headers: {"Content-Type": "application/json"},
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        print("Points updated successfully for user $serverId");
        return true;
      } else {
        print("Failed to add points on server for user $serverId: ${res.statusCode} - ${res.body}");
        return false;
      }
    } catch (e) {
      print("Error adding points on server for user $serverId: $e");
      return false;
    }
  }

  static Future<void> syncPendingUsers() async {
    final unsyncedUsers = await UserLocalService.getUnsyncedUsers();

    for (final user in unsyncedUsers) {
      final registeredUser = await registerUserOnServer(user);
      if (registeredUser != null) {
        await UserLocalService.saveUser(registeredUser);
      }
    }
  }

  static Future<void> syncPendingPoints() async {
    final usersWithPendingPoints = await UserLocalService.getUsersWithPendingPoints();

    for (final user in usersWithPendingPoints) {
      if (user.serverId != null) {
        final success = await sendPointsUpdateToServer(user.serverId!, user.points);
        if (success) {
          user.synced = true;
          await UserLocalService.saveUser(user);
        }
      } else {
        print("User ${user.username} has points but no serverId. Attempting to register first.");
        final registeredUser = await registerUserOnServer(user);
        if (registeredUser != null) {
          final success = await sendPointsUpdateToServer(registeredUser.serverId!, registeredUser.points);
          if (success) {
            registeredUser.synced = true;
            await UserLocalService.saveUser(registeredUser);
          }
        }
      }
    }
  }

  static Future<bool> fetchServerAuthorizationStatus(String serverId) async {
    try {
      final res = await http.get(
        Uri.parse('$base/api/users/$serverId'),
        headers: {"Content-Type": "application/json"},
      );

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);

        final serverStatus = body['data']['isActive'] ?? false;
        return serverStatus;
      }
      print("Failed to fetch user status: ${res.statusCode}");
      return false;
    } catch (e) {
      print("Error fetching user status: $e");
      return false;
    }
  }

}

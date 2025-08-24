import 'package:hive/hive.dart';
import '../../core/db.dart';
import '../models/user.dart';

class UserLocalService {

  static Future<int> saveUser(User user) async {
    for (var u in DB.usersBox.values) {
      u.isActive = false;
      await u.save();
    }

    user.isActive = true;
    int id = await DB.usersBox.add(user);
    return id;
  }

  static Future<User?> getActiveUser() async {
    final activeUsers = DB.usersBox.values.where((u) => u.isActive);
    if (activeUsers.isNotEmpty) {
      return activeUsers.first;
    }
    return null;
  }


  static Future<void> updatePoints(User user, int newPoints) async {
    user.points = newPoints;
    user.synced = false;
    await user.save();
  }

  static Future<void> logoutAllUsers() async {
    for (var user in DB.usersBox.values) {
      user.isActive = false;
      await user.save();
    }
  }

  static Future<List<User>> getUnsyncedUsers() async {
    return DB.usersBox.values.where((u) => u.synced == false).toList();
  }

  static Future<List<User>> getUsersWithPendingPoints() async {
    return DB.usersBox.values.where((u) => u.synced == false && u.points > 0).toList();
  }

  static Future<List<User>> getAllUsers() async {
    return DB.usersBox.values.toList();
  }
}

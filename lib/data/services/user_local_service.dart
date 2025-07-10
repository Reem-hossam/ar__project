import 'package:isar/isar.dart';
import '../../core/db.dart';
import '../models/user.dart';

class UserLocalService {

  static Future<int> saveUser(User user) async {
    int id = 0;
    await DB.isar.writeTxn(() async {
      final allUsers = await DB.isar.users.where().findAll();
      for (final u in allUsers) {
        u.isActive = false;
        await DB.isar.users.put(u);
      }

      user.isActive = true;
      id = await DB.isar.users.put(user);
    });
    return id;
  }


  static Future<User?> getInitialUser() async {
    final allUsers = await DB.isar.users.where().findAll();
    allUsers.sort((a, b) => a.id.compareTo(b.id));
    return allUsers.isNotEmpty ? allUsers.first : null;
  }

  static Future<User?> getActiveUser() async {
    return await DB.isar.users.filter().isActiveEqualTo(true).findFirst();
  }
  static Future<void> updatePoints(int userId, int newPoints) async {
    await DB.isar.writeTxn(() async {
      final user = await DB.isar.users.get(userId);
      if (user != null) {
        user.points = newPoints;
        user.synced = false;
        await DB.isar.users.put(user);
      }
    });
  }

  static Future<List<User>> getUnsyncedUsers() async {
    return await DB.isar.users.filter().syncedEqualTo(false).findAll();
  }


  static Future<List<User>> getUsersWithPendingPoints() async {
    return await DB.isar.users.filter().pointsGreaterThan(0).syncedEqualTo(false).findAll();
  }
}

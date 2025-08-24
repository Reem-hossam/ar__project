import 'package:hive_flutter/hive_flutter.dart';
import '../data/models/user.dart';

class DB {
  static late Box<User> usersBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserAdapter());

    usersBox = await Hive.openBox<User>('usersBox');
  }
}

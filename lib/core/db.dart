import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../data/models/user.dart';

class DB {
  static late final Isar isar;
  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([UserSchema], directory: dir.path);
  }
}

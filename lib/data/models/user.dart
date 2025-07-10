import 'package:isar/isar.dart';
part 'user.g.dart';

@Collection()
class User {
  Id id = Isar.autoIncrement;
  String? serverId;
  late String username;
  late String jobTitle;
  late String company;
  late String gender;
  int points = 0;
  bool synced = false;
  bool isActive = false;
}

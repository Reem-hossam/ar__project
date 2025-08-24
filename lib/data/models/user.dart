import 'package:hive/hive.dart';
part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  String? serverId;

  @HiveField(1)
  late String username;

  @HiveField(2)
  late String jobTitle;

  @HiveField(3)
  late String company;

  @HiveField(4)
  late String gender;

  @HiveField(5)
  int points = 0;

  @HiveField(6)
  bool synced = false;

  @HiveField(7)
  bool isActive = false;
}

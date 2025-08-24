// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User()
      ..serverId = fields[0] as String?
      ..username = fields[1] as String
      ..jobTitle = fields[2] as String
      ..company = fields[3] as String
      ..gender = fields[4] as String
      ..points = fields[5] as int
      ..synced = fields[6] as bool
      ..isActive = fields[7] as bool
      ..hasCompletedGame = fields[8] as bool
      ..gameTimeRemaining = fields[9] as int;
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.serverId)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.jobTitle)
      ..writeByte(3)
      ..write(obj.company)
      ..writeByte(4)
      ..write(obj.gender)
      ..writeByte(5)
      ..write(obj.points)
      ..writeByte(6)
      ..write(obj.synced)
      ..writeByte(7)
      ..write(obj.isActive)
      ..writeByte(8)
      ..write(obj.hasCompletedGame)
      ..writeByte(9)
      ..write(obj.gameTimeRemaining);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

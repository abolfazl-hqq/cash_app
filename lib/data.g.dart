// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DepositAdapter extends TypeAdapter<Deposit> {
  @override
  final int typeId = 0;

  @override
  Deposit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Deposit()
      ..name = fields[0] as String
      ..category = fields[1] as String
      ..count = fields[2] as double
      ..isSelectedToDelete = fields[3] as bool;
  }

  @override
  void write(BinaryWriter writer, Deposit obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.count)
      ..writeByte(3)
      ..write(obj.isSelectedToDelete);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DepositAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

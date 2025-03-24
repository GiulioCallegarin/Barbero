// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppointmentTypeAdapter extends TypeAdapter<AppointmentType> {
  @override
  final int typeId = 1;

  @override
  AppointmentType read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppointmentType(
      id: (fields[0] as num).toInt(),
      name: fields[1] as String,
      defaultPrice: (fields[2] as num).toDouble(),
      defaultDuration: (fields[3] as num).toInt(),
      target: fields[4] == null ? 'all' : fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AppointmentType obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.defaultPrice)
      ..writeByte(3)
      ..write(obj.defaultDuration)
      ..writeByte(4)
      ..write(obj.target);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppointmentTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

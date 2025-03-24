// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppointmentAdapter extends TypeAdapter<Appointment> {
  @override
  final int typeId = 2;

  @override
  Appointment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Appointment(
      id: (fields[0] as num).toInt(),
      date: fields[1] as DateTime,
      clientId: (fields[2] as num).toInt(),
      appointmentTypeId: (fields[3] as num).toInt(),
      price: (fields[4] as num).toDouble(),
      duration: (fields[5] as num).toInt(),
      notes: fields[6] as String?,
      status:
          fields[7] == null
              ? AppointmentStatus.pending
              : fields[7] as AppointmentStatus,
    );
  }

  @override
  void write(BinaryWriter writer, Appointment obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.clientId)
      ..writeByte(3)
      ..write(obj.appointmentTypeId)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.duration)
      ..writeByte(6)
      ..write(obj.notes)
      ..writeByte(7)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppointmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AppointmentStatusAdapter extends TypeAdapter<AppointmentStatus> {
  @override
  final int typeId = 3;

  @override
  AppointmentStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AppointmentStatus.pending;
      case 1:
        return AppointmentStatus.done;
      case 2:
        return AppointmentStatus.cancelled;
      case 3:
        return AppointmentStatus.noShow;
      case 4:
        return AppointmentStatus.notPaid;
      default:
        return AppointmentStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, AppointmentStatus obj) {
    switch (obj) {
      case AppointmentStatus.pending:
        writer.writeByte(0);
      case AppointmentStatus.done:
        writer.writeByte(1);
      case AppointmentStatus.cancelled:
        writer.writeByte(2);
      case AppointmentStatus.noShow:
        writer.writeByte(3);
      case AppointmentStatus.notPaid:
        writer.writeByte(4);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppointmentStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

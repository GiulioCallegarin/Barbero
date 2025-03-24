import 'package:hive_ce_flutter/hive_flutter.dart';

part 'appointment.g.dart'; // Hive will generate this file

@HiveType(typeId: 2)
class Appointment extends HiveObject {
  @HiveField(0)
  late int id;

  @HiveField(1)
  late DateTime date;

  @HiveField(2)
  late int clientId;

  @HiveField(3)
  late int appointmentTypeId;

  @HiveField(4)
  late double price;

  @HiveField(5)
  late int duration;

  @HiveField(6)
  late String? notes;

  @HiveField(7)
  late AppointmentStatus status = AppointmentStatus.pending;

  Appointment({
    required this.id,
    required this.date,
    required this.clientId,
    required this.appointmentTypeId,
    required this.price,
    required this.duration,
    this.notes,
    this.status = AppointmentStatus.pending,
  });

  static Future<int> getNextId() async {
    final box = Hive.box<Appointment>('appointments');
    return (box.keys.isNotEmpty ? box.keys.last as int : 0) + 1;
  }
}

@HiveType(typeId: 3)
enum AppointmentStatus {
  @HiveField(0)
  pending,
  @HiveField(1)
  done,
  @HiveField(2)
  cancelled,
  @HiveField(3)
  noShow,
  @HiveField(4)
  notPaid,
}

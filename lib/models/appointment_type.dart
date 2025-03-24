import 'package:hive_ce_flutter/hive_flutter.dart';

part 'appointment_type.g.dart'; // Hive will generate this file

@HiveType(typeId: 1)
class AppointmentType extends HiveObject {
  @HiveField(0)
  late int id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late double defaultPrice;

  @HiveField(3)
  late int defaultDuration;

  AppointmentType({
    required this.id,
    required this.name,
    required this.defaultPrice,
    required this.defaultDuration,
  });

  static Future<int> getNextId() async {
    final box = Hive.box<AppointmentType>('appointmentTypes');
    return (box.keys.isNotEmpty ? box.keys.last as int : 0) + 1;
  }
}

import 'package:isar/isar.dart';

part 'appointment_type.g.dart';

@collection
class AppointmentType {
  Id id = Isar.autoIncrement;
  late String name;
  late double defaultPrice;
  late int defaultDuration;
}

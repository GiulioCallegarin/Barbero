import 'package:isar/isar.dart';

part 'appointment.g.dart';

@collection
class Appointment {
  Id id = Isar.autoIncrement;
  late int clientId;
  late DateTime date;
  late int typeId;
  late int duration;
  late double price;
}

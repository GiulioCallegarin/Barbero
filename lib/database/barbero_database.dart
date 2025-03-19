import 'package:barbero/models/appointment.dart';
import 'package:barbero/models/appointment_type.dart';
import 'package:barbero/models/client.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class BarberoDatabase {
  static late Isar isar;

  // Initialize Isar
  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([
      ClientSchema,
      AppointmentSchema,
      AppointmentTypeSchema,
    ], directory: dir.path);
  }
}

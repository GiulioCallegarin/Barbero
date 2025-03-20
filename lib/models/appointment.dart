class Appointment {
  late int id;
  late DateTime date;
  late int clientId;
  late int appointmentTypeId;
  late double price;
  late int duration;
  late String? notes;
  late AppointmentStatus status = AppointmentStatus.pending;
}

enum AppointmentStatus { pending, done, cancelled, noShow, notPaid }

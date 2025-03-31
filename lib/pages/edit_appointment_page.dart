import 'package:barbero/models/appointment.dart';
import 'package:barbero/models/appointment_type.dart';
import 'package:barbero/models/client.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class EditAppointmentPage extends StatefulWidget {
  final DateTime? timeSlot;
  final Appointment? appointment;

  const EditAppointmentPage({super.key, this.timeSlot, this.appointment});

  @override
  State<EditAppointmentPage> createState() => _EditAppointmentPageState();
}

class _EditAppointmentPageState extends State<EditAppointmentPage> {
  late Box<Appointment> appointmentBox;
  late Box<Client> clientBox;
  late Box<AppointmentType> appointmentTypeBox;

  @override
  void initState() {
    super.initState();
    appointmentBox = Hive.box<Appointment>('appointments');
    clientBox = Hive.box<Client>('clients');
    appointmentTypeBox = Hive.box<AppointmentType>('appointmentTypes');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Appointment')),
      body: Column(children: [
        ],
      ),
    );
  }
}

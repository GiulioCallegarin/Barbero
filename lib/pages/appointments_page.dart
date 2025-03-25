import 'package:barbero/models/client.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:barbero/models/appointment.dart';
import 'package:barbero/widgets/appointment_dialog.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  late Box<Appointment> appointmentBox;
  late Box<Client> clientBox;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    appointmentBox = Hive.box<Appointment>('appointments');
    clientBox = Hive.box<Client>('clients');
  }

  List<Appointment> _getAppointmentsForDay(DateTime day) {
    return appointmentBox.values.where((appt) {
      return appt.date.year == day.year &&
          appt.date.month == day.month &&
          appt.date.day == day.day;
    }).toList();
  }

  void _addAppointment() {
    showDialog(context: context, builder: (context) => AppointmentDialog());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appointments')),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _selectedDate,
            firstDay: DateTime(2000),
            lastDay: DateTime(2100),
            selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() => _selectedDate = selectedDay);
            },
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: appointmentBox.listenable(),
              builder: (context, Box<Appointment> box, _) {
                final appointments = _getAppointmentsForDay(_selectedDate);
                return ListView.builder(
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    final appointment = appointments[index];
                    final client = clientBox.get(appointment.clientId);
                    return ListTile(
                      title: Text(
                        "${appointment.date.hour}:${appointment.date.minute} - ${client?.firstName} ${client?.lastName} ",
                      ),
                      subtitle: Text(appointment.appointmentType),
                      trailing: Text("€${appointment.price}"),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AppointmentDialog(),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addAppointment,
        child: const Icon(Icons.add),
      ),
    );
  }
}

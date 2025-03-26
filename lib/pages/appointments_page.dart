import 'package:barbero/models/client.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:barbero/models/appointment.dart' as barbero;

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  AppointmentsPageState createState() => AppointmentsPageState();
}

class AppointmentsPageState extends State<AppointmentsPage> {
  late Box<barbero.Appointment> appointmentBox;
  late Box<Client> clientBox;
  DateTime _selectedDate = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;

  @override
  void initState() {
    super.initState();
    appointmentBox = Hive.box<barbero.Appointment>('appointments');
    clientBox = Hive.box<Client>('clients');
  }

  List<barbero.Appointment> getAppointmentsForDay(DateTime day) {
    return appointmentBox.values.where((appt) {
      return appt.date.year == day.year &&
          appt.date.month == day.month &&
          appt.date.day == day.day;
    }).toList();
  }

  void showEditAppointmentPage({
    DateTime? timeSlot,
    barbero.Appointment? appointment,
  }) {}

  Color getStatusColor(barbero.AppointmentStatus status) {
    switch (status) {
      case barbero.AppointmentStatus.done:
        return Colors.green;
      case barbero.AppointmentStatus.cancelled:
        return Colors.red;
      case barbero.AppointmentStatus.noShow:
        return Colors.orange;
      case barbero.AppointmentStatus.notPaid:
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }

  List<Appointment> generateCalendarAppointments() {
    final appointments = getAppointmentsForDay(_selectedDate);
    final calendarStateAppointments =
        appointments.map((appt) {
          final client = clientBox.get(appt.clientId);
          return Appointment(
            id: appt.id,
            startTime: appt.date,
            endTime: appt.date.add(Duration(minutes: appt.duration)),
            subject:
                "${client?.firstName ?? 'Unknown'} ${client?.lastName ?? ''} - ${appt.appointmentType}",
            color: getStatusColor(appt.status),
          );
        }).toList();
    return calendarStateAppointments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appointments')),
      body: Column(
        children: [
          TableCalendar(
            headerStyle: HeaderStyle(formatButtonVisible: false),
            selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
            focusedDay: _selectedDate,
            firstDay: DateTime(2000),
            lastDay: DateTime(2100),
            eventLoader: (day) => getAppointmentsForDay(day),
            calendarStyle: CalendarStyle(
              markerDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
                shape: BoxShape.circle,
              ),
            ),
            availableGestures: AvailableGestures.all,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() => _selectedDate = selectedDay);
            },
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
          ),
          const SizedBox(height: 10),
          Expanded(
            child: KeyedSubtree(
              key: ValueKey(
                _selectedDate,
              ), // Forces rebuild when the date changes
              child: SfCalendar(
                initialDisplayDate: _selectedDate,
                onViewChanged: (viewChangedDetails) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      _selectedDate = viewChangedDetails.visibleDates[0];
                    });
                  });
                },
                viewHeaderHeight: 0,
                headerHeight: 0,
                view: CalendarView.day,
                dataSource: AppointmentDataSource(
                  generateCalendarAppointments(),
                ),
                timeSlotViewSettings: TimeSlotViewSettings(
                  timeIntervalHeight: 50,
                  startHour: 8,
                  endHour: 20,
                  timeInterval: Duration(minutes: 30),
                ),
                onLongPress: (CalendarLongPressDetails details) {
                  if (details.targetElement == CalendarElement.appointment) {
                    barbero.Appointment? appointment = appointmentBox.get(
                      details.appointments![0].id,
                    );

                    showEditAppointmentPage(appointment: appointment);
                  } else {
                    final DateTime? selectedTime = details.date;
                    if (selectedTime != null) {
                      showEditAppointmentPage(timeSlot: selectedTime);
                    }
                  }
                },
                allowDragAndDrop: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> appointments) {
    this.appointments = appointments;
  }
}

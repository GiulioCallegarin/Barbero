import 'package:barbero/models/client.dart';
import 'package:barbero/pages/edit_appointment_page.dart';
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
  }) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => EditAppointmentPage(
              timeSlot: timeSlot,
              appointment: appointment,
            ),
      ),
    );
    setState(() {});
  }

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
    final List<Appointment> calendarStateAppointments = [];

    for (final appt in appointments) {
      final client = clientBox.get(appt.clientId);
      final startTime = appt.date;
      final totalDuration = appt.duration;
      final pause = appt.pauseDurationMinutes.clamp(0, 180);

      // If no pause, add single appointment segment
      if (pause <= 0) {
        calendarStateAppointments.add(
          Appointment(
            id: appt.id,
            startTime: startTime,
            endTime: startTime.add(Duration(minutes: totalDuration)),
            subject:
                '${client?.firstName ?? 'Unknown'} ${client?.lastName ?? ''} - ${appt.appointmentType}',
            color: getStatusColor(appt.status),
          ),
        );
        continue;
      }

      // compute segments: service first, then pause appended after the service
      final serviceDuration = totalDuration;
      final serviceStart = startTime;
      final serviceEnd = serviceStart.add(Duration(minutes: serviceDuration));

      final pauseStart = serviceEnd;
      final pauseEnd = pauseStart.add(Duration(minutes: pause));

      // service segment (normal appointment color)
      calendarStateAppointments.add(
        Appointment(
          id: appt.id,
          startTime: serviceStart,
          endTime: serviceEnd,
          subject:
              '${client?.firstName ?? 'Unknown'} ${client?.lastName ?? ''} - ${appt.appointmentType}',
          color: getStatusColor(appt.status),
        ),
      );

      // pause segment (gray, indicates unavailability after the service)
      if (pause > 0) {
        calendarStateAppointments.add(
          Appointment(
            id: appt.id,
            startTime: pauseStart,
            endTime: pauseEnd,
            subject: 'Pausa',
            color: Colors.grey.shade400,
          ),
        );
      }
    }

    return calendarStateAppointments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appuntamenti')),
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
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children:
                        getAppointmentsForDay(_selectedDate).map((appt) {
                          final client = clientBox.get(appt.clientId);
                          final time =
                              "${appt.date.hour.toString().padLeft(2, '0')}:${appt.date.minute.toString().padLeft(2, '0')}";
                          return ListTile(
                            title: Text(
                              "${client?.firstName ?? ''} ${client?.lastName ?? ''}",
                            ),
                            subtitle: Text('Ora: $time'),
                            trailing: Text(appt.appointmentType),
                            onTap:
                                () =>
                                    showEditAppointmentPage(appointment: appt),
                          );
                        }).toList(),
                  ),
                ),
                SizedBox(
                  height: 300,
                  child: KeyedSubtree(
                    key: ValueKey(_selectedDate),
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
                        endHour: 22,
                        timeInterval: Duration(minutes: 15),
                        timeFormat: 'HH:mm',
                      ),
                      onLongPress: (CalendarLongPressDetails details) {
                        if (details.targetElement ==
                            CalendarElement.appointment) {
                          // If the tapped appointment is a Pause segment, open editor to create inside the pause
                          final dynamic raw = details.appointments![0];
                          final subject = raw.subject?.toString() ?? '';
                          if (subject == 'Pausa') {
                            final DateTime? selectedTime = details.date;
                            if (selectedTime != null) {
                              showEditAppointmentPage(timeSlot: selectedTime);
                            }
                            return;
                          }

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

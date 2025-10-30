import 'package:barbero/models/client.dart';
import 'package:barbero/pages/edit_appointment_page.dart';
import 'dart:convert';
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
        return Colors.orange;
      case barbero.AppointmentStatus.noShow:
        return Colors.orange;
      case barbero.AppointmentStatus.notPaid:
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }

  // Deterministic color per client id so each client is visually distinct.
  // If clientId is null or not found, fallback to a neutral color.
  Color _colorForClient(int? clientId) {
    final palette = [
      Colors.teal,
      Colors.indigo,
      Colors.deepOrange,
      Colors.cyan,
      Colors.amber,
      Colors.pink,
      Colors.lightGreen,
      Colors.lime,
      Colors.blueGrey,
      Colors.brown,
    ];
    if (clientId == null) return Colors.grey;
    return palette[(clientId.abs()) % palette.length];
  }

  // Avoid using Color.withOpacity due to analyzer deprecation; construct ARGB directly.
  Color _withOpacity(Color base, double opacity) {
    int alpha = (opacity * 255).round();
    if (alpha < 0) alpha = 0;
    if (alpha > 255) alpha = 255;
  final int v = base.toARGB32();
  final int r = (v >> 16) & 0xFF;
  final int g = (v >> 8) & 0xFF;
  final int b = v & 0xFF;
    return Color.fromARGB(alpha, r, g, b);
  }

  List<Appointment> generateCalendarAppointments() {
    final appointments = getAppointmentsForDay(_selectedDate);
    final List<Appointment> calendarStateAppointments = [];

    for (final appt in appointments) {
      final client = clientBox.get(appt.clientId);
      final startTime = appt.date;

      // If appointment has serialized services in notes, reconstruct segments sequentially
      bool handled = false;
      try {
        if (appt.notes != null && appt.notes!.isNotEmpty) {
          final parsed = jsonDecode(appt.notes!);
          if (parsed is Map && parsed['services'] is List) {
            DateTime cursor = startTime;
            final services = parsed['services'] as List;
            for (final s in services) {
              final mp =
                  s is Map<String, dynamic> ? s : Map<String, dynamic>.from(s);
              final name = (mp['name'] as String?) ?? appt.appointmentType;
              final dur = (mp['duration'] as int?) ?? 0;
              final pauseAfter = (mp['pauseAfter'] as int?) ?? 0;
              // Add the service block if it has a positive duration
              if (dur > 0) {
                final serviceStart = cursor;
                final serviceEnd = cursor.add(Duration(minutes: dur));
                calendarStateAppointments.add(
                  Appointment(
                    id: appt.id,
                    startTime: serviceStart,
                    endTime: serviceEnd,
                    subject:
                        '${client?.firstName ?? 'Unknown'} ${client?.lastName ?? ''} - $name',
                    color: _colorForClient(appt.clientId),
                  ),
                );
                // Do NOT add a calendar block for the pause: advance the cursor by dur + pauseAfter
                // so the next service (if any) starts after the pause and the calendar shows
                // that time as empty space.
                cursor = cursor.add(Duration(minutes: dur + pauseAfter));
              } else {
                // if duration is zero, still advance cursor by pauseAfter to keep timeline consistent
                cursor = cursor.add(Duration(minutes: pauseAfter));
              }
            }
            handled = true;
          }
        }
      } catch (_) {
        handled = false;
      }

      if (handled) continue;

      // fallback: single segment for the whole appointment duration (pauses already summed into appt.duration)
      final totalDuration = appt.duration;
      calendarStateAppointments.add(
        Appointment(
          id: appt.id,
          startTime: startTime,
          endTime: startTime.add(Duration(minutes: totalDuration)),
          subject:
              '${client?.firstName ?? 'Unknown'} ${client?.lastName ?? ''} - ${appt.appointmentType}',
          color: _colorForClient(appt.clientId),
        ),
      );
    }

    return calendarStateAppointments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appuntamenti')),
      body: Column(
        children: [
          // modern calendar header container with subtle gradient
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _withOpacity(Theme.of(context).colorScheme.primary, 0.12),
                  _withOpacity(Theme.of(context).colorScheme.secondary, 0.06),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: _withOpacity(Colors.black, 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: TableCalendar(
              locale: 'it_IT',
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleTextStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
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
                todayDecoration: BoxDecoration(
                  color: _withOpacity(Theme.of(
                    context,
                  ).colorScheme.primary, 0.18),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                outsideDaysVisible: false,
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
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Text('Ore: $time'),
                            trailing: SizedBox(
                              width: 160,
                              height: 56,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Chip(
                                      label: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          appt.status ==
                                                  barbero
                                                      .AppointmentStatus
                                                      .pending
                                              ? 'In attesa'
                                              : appt.status ==
                                                  barbero.AppointmentStatus.done
                                              ? 'Completato'
                                              : appt.status ==
                                                  barbero
                                                      .AppointmentStatus
                                                      .cancelled
                                              ? 'Annullato'
                                              : appt.status ==
                                                  barbero
                                                      .AppointmentStatus
                                                      .noShow
                                              ? 'No show'
                                              : 'Non pagato',
                                          style: TextStyle(
                                            color: getStatusColor(appt.status),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                      backgroundColor: _withOpacity(
                                        getStatusColor(
                                          appt.status,
                                        ),
                                        0.12,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 6,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Chip(
                                      label: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          '${appt.duration} min',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      backgroundColor: _withOpacity(
                                        _colorForClient(
                                          appt.clientId,
                                        ),
                                        0.16,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 6,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                      appointmentBuilder: (context, details) {
                        // details.appointments contains the appointment objects we created earlier
                        final dynamic raw =
                            details.appointments.isNotEmpty
                                ? details.appointments.first
                                : null;
                        final subject = (raw?.subject ?? '').toString();
                        // subject was built as 'ClientName - ServiceName'
                        final parts = subject.split(' - ');
                        final nameText = parts.isNotEmpty ? parts[0] : subject;
                        final typeText =
                            parts.length > 1
                                ? parts.sublist(1).join(' - ')
                                : '';
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                raw?.color ??
                                Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                nameText,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              if (typeText.isNotEmpty)
                                Text(
                                  typeText,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.white70,
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
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

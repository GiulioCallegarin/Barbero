import 'package:barbero/models/appointment.dart';
import 'package:barbero/models/client.dart';
import 'package:barbero/widgets/appointments/appointments_recap.dart';
import 'package:barbero/widgets/clients/client_stats.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class ClientHistoryPage extends StatefulWidget {
  const ClientHistoryPage({super.key, required this.client});
  final Client client;

  @override
  State<ClientHistoryPage> createState() => ClientHistoryPageState();
}

class ClientHistoryPageState extends State<ClientHistoryPage> {
  late Box<Appointment> appointmentsBox;
  late List<Appointment> appointments;
  bool isDescending = true;
  int totalAppointments = 0;
  double totalMoneySpent = 0.0;
  double avgMoneySpent = 0.0;
  double avgTimeBetweenAppointments = 0.0;

  @override
  void initState() {
    super.initState();
    appointmentsBox = Hive.box<Appointment>('appointments');
    appointments =
        appointmentsBox.values
            .where((appointment) => appointment.clientId == widget.client.key)
            .toList();
    sortAppointments();
    generateStats();
  }

  void sortAppointments() {
    appointments.sort(
      (a, b) =>
          isDescending ? b.date.compareTo(a.date) : a.date.compareTo(b.date),
    );
  }

  void toggleSortOrder() {
    setState(() {
      isDescending = !isDescending;
      sortAppointments();
    });
  }

  void generateStats() {
    totalAppointments = appointments.length;
    if (totalAppointments > 0) {
      totalMoneySpent = appointments.fold(0, (sum, item) => sum + item.price);
      avgMoneySpent = totalMoneySpent / totalAppointments;
      if (totalAppointments > 1) {
        List<DateTime> dates = appointments.map((a) => a.date).toList();
        double totalDaysBetween = 0;
        for (int i = 0; i < dates.length - 1; i++) {
          totalDaysBetween += dates[i].difference(dates[i + 1]).inDays;
        }
        avgTimeBetweenAppointments = totalDaysBetween / (dates.length - 1);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.client.firstName} ${widget.client.lastName}'),
      ),
      body: Column(
        children: [
          ClientStats(
            totalAppointments: totalAppointments,
            totalMoneySpent: totalMoneySpent,
            avgMoneySpent: avgMoneySpent,
            avgTimeBetweenAppointments: avgTimeBetweenAppointments,
          ),
          AppointmentsRecap(
            appointments: appointments,
            toggleSortOrder: toggleSortOrder,
            isDescending: isDescending,
          ),
        ],
      ),
    );
  }
}

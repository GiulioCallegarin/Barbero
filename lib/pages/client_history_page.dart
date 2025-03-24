import 'package:barbero/models/appointment.dart';
import 'package:barbero/models/client.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

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
    _sortAppointments();
    _calculateStats();
  }

  void _sortAppointments() {
    appointments.sort(
      (a, b) =>
          isDescending ? b.date.compareTo(a.date) : a.date.compareTo(b.date),
    );
  }

  void _toggleSortOrder() {
    setState(() {
      isDescending = !isDescending;
      _sortAppointments();
    });
  }

  void _calculateStats() {
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Client Statistics",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildStatTile(
                              "Total Appointments",
                              "$totalAppointments",
                            ),
                            _buildStatTile(
                              "Avg. Spent",
                              "€${avgMoneySpent.toStringAsFixed(2)}",
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildStatTile(
                              "Total Spent",
                              "€${totalMoneySpent.toStringAsFixed(2)}",
                            ),
                            _buildStatTile(
                              "Avg. Days Between",
                              "${avgTimeBetweenAppointments.toStringAsFixed(1)} days",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (appointments.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              child: ElevatedButton(
                onPressed: _toggleSortOrder,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isDescending ? Icons.arrow_downward : Icons.arrow_upward,
                    ),
                    const SizedBox(width: 4),
                    const Text("Sort by Date"),
                  ],
                ),
              ),
            ),
          Expanded(
            child:
                appointments.isEmpty
                    ? Center(
                      child: Text(
                        "No appointments yet.",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                    : ListView.builder(
                      itemCount: appointments.length,
                      itemBuilder: (context, index) {
                        final appointment = appointments.elementAt(index);
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(
                              DateFormat(
                                'hh:mm - dd/MM/yyyy',
                              ).format(appointment.date),
                            ),
                            subtitle: Text(
                              "Type: ${appointment.appointmentTypeId.toString()}",
                            ),
                            trailing: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("€${appointment.price}"),
                                Text("${appointment.duration} mins"),
                              ],
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            tileColor: Theme.of(context).colorScheme.secondary,
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatTile(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
        ),
      ],
    );
  }
}

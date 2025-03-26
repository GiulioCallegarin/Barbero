import 'package:barbero/models/appointment.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentsRecap extends StatelessWidget {
  final Function toggleSortOrder;
  final bool isDescending;

  const AppointmentsRecap({
    super.key,
    required this.appointments,
    required this.toggleSortOrder,
    required this.isDescending,
  });

  final List<Appointment> appointments;

  @override
  Widget build(BuildContext context) {
    if (appointments.isNotEmpty) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: ElevatedButton(
              onPressed: () => toggleSortOrder,
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
          ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments.elementAt(index);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    DateFormat('hh:mm - dd/MM/yyyy').format(appointment.date),
                  ),
                  subtitle: Text("Type: ${appointment.appointmentType}"),
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
        ],
      );
    }
    return Column(
      children: [
        SizedBox(height: 200),
        Center(
          child: Text(
            "No appointments yet.",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}

import 'package:barbero/models/appointment.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Local helper to produce deterministic per-client colors for consistent UI
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

// Helper to replace deprecated .withOpacity usages
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

class AppointmentsRecap extends StatelessWidget {
  final Function toggleSortOrder;
  final bool isDescending;
  final Function(Appointment)? onCancel;
  final bool showDuration;

  const AppointmentsRecap({
    super.key,
    required this.appointments,
    required this.toggleSortOrder,
    required this.isDescending,
    this.onCancel,
    this.showDuration = true,
  });

  final List<Appointment> appointments;

  @override
  Widget build(BuildContext context) {
    if (appointments.isNotEmpty) {
      return Expanded(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: ElevatedButton(
                onPressed: () => toggleSortOrder(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isDescending ? Icons.arrow_downward : Icons.arrow_upward,
                    ),
                    const SizedBox(width: 4),
                    const Text('Ordina per data'),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  final appointment = appointments.elementAt(index);
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(
                        DateFormat('HH:mm - dd/MM/yyyy').format(appointment.date),
                      ),
                      subtitle: Text('Tipo: ${appointment.appointmentType}'),
                      trailing: SizedBox(
                        width: 220,
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
                                    _statusLabel(appointment.status),
                                    style: TextStyle(
                                      color: _statusColor(appointment.status),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                                backgroundColor: _withOpacity(
                                  _statusColor(appointment.status),
                                  0.12,
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('€${appointment.price.toStringAsFixed(2)}'),
                                if (showDuration)
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Chip(
                                      label: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          '${appointment.duration} min',
                                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      backgroundColor: _withOpacity(_colorForClient(appointment.clientId), 0.16),
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(width: 8),
                            if (appointment.status != AppointmentStatus.cancelled && onCancel != null)
                              ElevatedButton(
                                onPressed: () => onCancel!(appointment),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Text('Annulla', style: TextStyle(color: Colors.white)),
                              ),
                          ],
                        ),
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      tileColor: Theme.of(context).colorScheme.secondary,
                      onLongPress: () {},
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }
    return Expanded(
      child: Center(
        child: Text(
          'Nessun appuntamento al momento.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }

  String _statusLabel(AppointmentStatus s) {
    switch (s) {
      case AppointmentStatus.pending:
        return 'In attesa';
      case AppointmentStatus.done:
        return 'Completato';
      case AppointmentStatus.cancelled:
        return 'Annullato';
      case AppointmentStatus.noShow:
        return 'No show';
      case AppointmentStatus.notPaid:
        return 'Non pagato';
    }
  }

  Color _statusColor(AppointmentStatus s) {
    switch (s) {
      case AppointmentStatus.pending:
        return Colors.blue;
      case AppointmentStatus.done:
        return Colors.green;
      case AppointmentStatus.cancelled:
        return Colors.orange;
      case AppointmentStatus.noShow:
        return Colors.orangeAccent;
      case AppointmentStatus.notPaid:
        return Colors.purple;
    }
  }
}

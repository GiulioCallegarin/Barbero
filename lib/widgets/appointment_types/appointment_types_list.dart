import 'package:flutter/material.dart';
import 'package:barbero/models/appointment_type.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class AppointmentTypesList extends StatelessWidget {
  final Box<AppointmentType> appointmentTypeBox;
  final Function showEditAppointmentTypePage;
  final Function deleteAppointmentType;

  const AppointmentTypesList({
    super.key,
    required this.appointmentTypeBox,
    required this.showEditAppointmentTypePage,
    required this.deleteAppointmentType,
  });

  @override
  Widget build(BuildContext context) {
    // local helper to avoid using deprecated .withOpacity
    Color withOpacity(Color base, double opacity) {
      int alpha = (opacity * 255).round();
      if (alpha < 0) alpha = 0;
      if (alpha > 255) alpha = 255;
  final int v = base.toARGB32();
  final int r = (v >> 16) & 0xFF;
  final int g = (v >> 8) & 0xFF;
  final int b = v & 0xFF;
      return Color.fromARGB(alpha, r, g, b);
    }
    return ValueListenableBuilder(
      valueListenable: appointmentTypeBox.listenable(),
      builder: (context, Box<AppointmentType> box, _) {
        if (box.isEmpty) {
          return const Center(child: Text('Nessun tipo di servizio aggiunto'));
        }
        return ListView.builder(
          itemCount: box.length,
          itemBuilder: (context, index) {
            final key = box.keyAt(index) as int;
            final appointmentType = box.get(key)!;
            final icon =
                appointmentType.target == 'all'
                    ? Icons.handshake_outlined
                    : appointmentType.target == 'male'
                    ? Icons.man_outlined
                    : Icons.woman_outlined;
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 6.0,
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: withOpacity(Theme.of(context).colorScheme.primary, 0.06),
                elevation: 0,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Icon(
                      icon,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    appointmentType.name,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Row(
                    children: [
                      Text(
                        'Durata: ${appointmentType.defaultDuration} min',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Prezzo: €${appointmentType.defaultPrice.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onPressed:
                            () => showEditAppointmentTypePage(
                              context,
                              type: appointmentType,
                            ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        onPressed: () => deleteAppointmentType(context, key),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

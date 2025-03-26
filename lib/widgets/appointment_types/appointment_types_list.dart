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
    return ValueListenableBuilder(
      valueListenable: appointmentTypeBox.listenable(),
      builder: (context, Box<AppointmentType> box, _) {
        if (box.isEmpty) {
          return const Center(child: Text("No appointment types added yet"));
        }
        return ListView.builder(
          itemCount: box.length,
          itemBuilder: (context, index) {
            final key = box.keyAt(index) as int;
            final appointmentType = box.get(key)!;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(appointmentType.name),
                subtitle: Text(
                  "Price: €${appointmentType.defaultPrice}\nDuration: ${appointmentType.defaultDuration} mins",
                ),
                leading: Icon(
                  appointmentType.target == 'all'
                      ? Icons.circle_outlined
                      : appointmentType.target == 'male'
                      ? Icons.male_outlined
                      : Icons.female_outlined,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                tileColor: Theme.of(context).colorScheme.secondary,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Theme.of(context).colorScheme.inversePrimary,
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
            );
          },
        );
      },
    );
  }
}

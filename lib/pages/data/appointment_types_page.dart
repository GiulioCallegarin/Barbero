import 'package:barbero/models/appointment_type.dart';
import 'package:barbero/pages/editing/edit_appointment_type_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class AppointmentTypesPage extends StatefulWidget {
  const AppointmentTypesPage({super.key});
  @override
  State<AppointmentTypesPage> createState() => _AppointmentTypesPageState();
}

class _AppointmentTypesPageState extends State<AppointmentTypesPage> {
  late Box<AppointmentType> appointmentTypeBox;

  @override
  void initState() {
    super.initState();
    appointmentTypeBox = Hive.box<AppointmentType>('appointmentTypes');
  }

  void showAddAppointmentTypeDialog(
    BuildContext context, {
    AppointmentType? type,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => EditAppointmentTypePage(
              box: appointmentTypeBox,
              appointmentType: type,
            ),
      ),
    );
  }

  void _deleteAppointmentType(BuildContext context, int id) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Delete Appointment Type"),
            content: const Text(
              "Are you sure you want to delete this appointment type?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  appointmentTypeBox.delete(id);
                  Navigator.pop(context);
                },
                child: Text(
                  "Delete",
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appointment Types')),
      body: Expanded(
        child: ValueListenableBuilder(
          valueListenable: appointmentTypeBox.listenable(),
          builder: (context, Box<AppointmentType> box, _) {
            if (box.isEmpty) {
              return const Center(
                child: Text("No appointment types added yet"),
              );
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
                              () => showAddAppointmentTypeDialog(
                                context,
                                type: appointmentType,
                              ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          onPressed: () => _deleteAppointmentType(context, key),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddAppointmentTypeDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

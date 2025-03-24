import 'package:flutter/material.dart';
import 'package:barbero/models/appointment_type.dart';
import 'package:barbero/widgets/appointment_type_dialog.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class AppointmentTypeList extends StatelessWidget {
  final Box<AppointmentType> appointmentTypeBox;

  const AppointmentTypeList({super.key, required this.appointmentTypeBox});

  void showAddAppointmentTypeDialog(
    BuildContext context, {
    AppointmentType? type,
  }) {
    showDialog(
      context: context,
      builder:
          (context) => AppointmentTypeDialog(
            appointmentType: type,
            box: appointmentTypeBox,
          ),
    );
  }

  void deleteAppointmentType(int id) {
    appointmentTypeBox.delete(id);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ValueListenableBuilder(
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
              return ListTile(
                title: Text(appointmentType.name),
                subtitle: Text(
                  "Price: €${appointmentType.defaultPrice} | Duration: ${appointmentType.defaultDuration} mins",
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed:
                          () => showAddAppointmentTypeDialog(
                            context,
                            type: appointmentType,
                          ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => deleteAppointmentType(key),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

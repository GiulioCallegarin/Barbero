import 'package:barbero/models/appointment_type.dart';
import 'package:barbero/pages/edit_appointment_type_page.dart';
import 'package:barbero/widgets/appointment_types/appointment_types_list.dart';
import 'package:barbero/widgets/delete_item_dialog.dart';
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

  void showEditAppointmentTypePage(
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

  void deleteAppointmentType(BuildContext context, int id) {
    deleteItemDialog(
      context,
      "Delete appointment type",
      "Are you sure you want to delete this appointment type?",
      () {
        appointmentTypeBox.delete(id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appointment Types')),
      body: AppointmentTypesList(
        appointmentTypeBox: appointmentTypeBox,
        showEditAppointmentTypePage: showEditAppointmentTypePage,
        deleteAppointmentType: deleteAppointmentType,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showEditAppointmentTypePage(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

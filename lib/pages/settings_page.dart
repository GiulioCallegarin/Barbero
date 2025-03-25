import 'package:barbero/pages/editing/edit_appointment_type_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:barbero/theme/theme_provider.dart';
import 'package:barbero/models/appointment_type.dart';
import 'package:barbero/widgets/appointment_type_list.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appointmentTypeBox = Hive.box<AppointmentType>('appointmentTypes');

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text("Dark Mode"),
            value: Provider.of<ThemeProvider>(context).isDarkMode,
            onChanged:
                (value) =>
                    Provider.of<ThemeProvider>(
                      context,
                      listen: false,
                    ).toggleTheme(),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Manage Appointment Types",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          AppointmentTypeList(
            appointmentTypeBox: appointmentTypeBox,
          ), // 🔹 Externalized List
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) =>
                        EditAppointmentTypePage(box: appointmentTypeBox),
              ),
            ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

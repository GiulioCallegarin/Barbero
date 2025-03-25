import 'package:barbero/pages/data/appointment_types_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:barbero/theme/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("Dark Mode"),
            value: Provider.of<ThemeProvider>(context).isDarkMode,
            onChanged: (value) {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
          const Divider(),
          ListTile(
            title: const Text("Manage Appointment Types"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AppointmentTypesPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

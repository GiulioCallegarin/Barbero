import 'package:barbero/pages/appointment_types_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:barbero/theme/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void showAppointmentTypesPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AppointmentTypesPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Impostazioni')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Tema scuro'),
            value: Provider.of<ThemeProvider>(context).isDarkMode,
            onChanged: (value) {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Gestisci tipi di servizio'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => showAppointmentTypesPage(context),
          ),
        ],
      ),
    );
  }
}

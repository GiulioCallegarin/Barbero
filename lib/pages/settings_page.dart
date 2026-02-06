import 'package:barbero/pages/appointment_types_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:barbero/theme/theme_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showAppointmentTypesPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AppointmentTypesPage()),
    );
  }

  void _showThemeDialog(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final currentTheme = themeProvider.currentThemeName;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Scegli il tema'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile(
              title: const Text('Tema chiaro'),
              value: 'light',
              groupValue: currentTheme,
              onChanged: (value) {
                themeProvider.setTheme('light');
                Navigator.pop(context);
              },
            ),
            RadioListTile(
              title: const Text('Tema scuro'),
              value: 'dark',
              groupValue: currentTheme,
              onChanged: (value) {
                themeProvider.setTheme('dark');
                Navigator.pop(context);
              },
            ),
            RadioListTile(
              title: const Text('Tema sperimentale 🎨'),
              value: 'experimental',
              groupValue: currentTheme,
              onChanged: (value) {
                themeProvider.setTheme('experimental');
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Chiudi'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Impostazioni')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Tema'),
            subtitle: Consumer<ThemeProvider>(
              builder: (context, themeProvider, _) {
                final themeName = themeProvider.currentThemeName;
                final displayName = themeName == 'light'
                    ? 'Chiaro'
                    : themeName == 'dark'
                        ? 'Scuro'
                        : 'Sperimentale';
                return Text(displayName);
              },
            ),
            trailing: const Icon(Icons.palette),
            onTap: () => _showThemeDialog(context),
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

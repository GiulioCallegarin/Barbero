import 'package:barbero/models/sms_settings.dart';
import 'package:barbero/pages/appointment_types_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:barbero/theme/theme_provider.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController gatewayUrlController;
  late TextEditingController senderNumberController;
  bool smsGatewayEnabled = false;

  @override
  void initState() {
    super.initState();
    final settingsBox = Hive.box('settings');
    final smsSettings = settingsBox.get('smsSettings') as SMSSettings?;
    
    gatewayUrlController = TextEditingController(text: smsSettings?.gatewayUrl ?? '');
    senderNumberController = TextEditingController(text: smsSettings?.senderNumber ?? '');
    smsGatewayEnabled = smsSettings?.enabled ?? false;
  }

  @override
  void dispose() {
    gatewayUrlController.dispose();
    senderNumberController.dispose();
    super.dispose();
  }

  void _saveSMSSettings() {
    final settingsBox = Hive.box('settings');
    final smsSettings = SMSSettings(
      gatewayUrl: gatewayUrlController.text,
      senderNumber: senderNumberController.text,
      enabled: smsGatewayEnabled,
    );
    settingsBox.put('smsSettings', smsSettings);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Impostazioni SMS salvate')),
    );
  }

  void _showSMSSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Configurazione SMS Gateway'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: const Text('Abilita SMS Gateway'),
                subtitle: const Text('Invia SMS dal numero aziendale'),
                value: smsGatewayEnabled,
                onChanged: (value) {
                  setState(() {
                    smsGatewayEnabled = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              if (smsGatewayEnabled) ...[
                TextField(
                  controller: gatewayUrlController,
                  decoration: InputDecoration(
                    labelText: 'URL Gateway SMS',
                    hintText: 'es: http://192.168.1.100:9090/send',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: senderNumberController,
                  decoration: InputDecoration(
                    labelText: 'Numero Aziendale',
                    hintText: 'es: +39 327 068 7817',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Guida:\n'
                    '1. Installa SMS Gateway 24 o Simexid sul telefono aziendale (Android)\n'
                    '2. Avvia l\'app e annota l\'indirizzo IP locale\n'
                    '3. Assicurati che il telefono sia sulla stessa rete Wi-Fi\n'
                    '4. Incolla l\'URL gateway qui',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annulla'),
          ),
          ElevatedButton(
            onPressed: () {
              _saveSMSSettings();
              Navigator.pop(context);
            },
            child: const Text('Salva'),
          ),
        ],
      ),
    );
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
            title: const Text('SMS Gateway (Numero Aziendale)'),
            subtitle: const Text('Invia SMS dal numero +39 327 068 7817'),
            trailing: const Icon(Icons.sms),
            onTap: _showSMSSettingsDialog,
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

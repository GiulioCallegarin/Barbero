import 'dart:convert';
import 'dart:typed_data';

import 'package:barbero/pages/appointment_types_page.dart';
import 'package:universal_io/io.dart';
import 'package:barbero/services/data_backup_service.dart';
import 'package:barbero/theme/theme_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

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

  Future<void> _exportData() async {
    _showBusyDialog('Creazione backup...');
    try {
      if (kIsWeb) {
        final payload = DataBackupService.buildExportPayload();
        final json = const JsonEncoder.withIndent('  ').convert(payload);
        final bytes = utf8.encode(json);
        if (!mounted) return;
        _closeBusyDialog();
        await Share.shareXFiles(
          [XFile.fromData(Uint8List.fromList(bytes),
              mimeType: 'application/json', name: 'barbero_backup.json')],
          text: 'Backup Barbero',
        );
      } else {
        final file = await DataBackupService.exportToFile();
        if (!mounted) return;
        _closeBusyDialog();
        await Share.shareXFiles(
          [XFile(file!.path)],
          text: 'Backup Barbero',
        );
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Backup creato e pronto da condividere')),
      );
    } catch (e) {
      if (!mounted) return;
      _closeBusyDialog();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore export: $e')),
      );
    }
  }

  Future<void> _importData() async {
    final picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      withData: kIsWeb,
    );
    if (picked == null) return;
    if (!kIsWeb && picked.files.single.path == null) return;

    final shouldImport = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Importa backup'),
        content: const Text(
          'L\'importazione sovrascrive tutti i dati attuali. Vuoi continuare?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annulla'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Importa'),
          ),
        ],
      ),
    );
    if (shouldImport != true) return;

    _showBusyDialog('Importazione in corso...');
    try {
      if (kIsWeb) {
        final bytes = picked.files.single.bytes;
        if (bytes == null) throw Exception('File vuoto');
        final jsonString = utf8.decode(bytes);
        final result = await DataBackupService.importFromJsonString(jsonString);
        if (!mounted) return;
        _closeBusyDialog();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Import completato: ${result.clientsCount} clienti, '
              '${result.appointmentsCount} appuntamenti, '
              '${result.appointmentTypesCount} tipi',
            ),
          ),
        );
      } else {
        final file = File(picked.files.single.path!);
        final result = await DataBackupService.importFromFile(file);
        if (!mounted) return;
        _closeBusyDialog();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Import completato: ${result.clientsCount} clienti, '
              '${result.appointmentsCount} appuntamenti, '
              '${result.appointmentTypesCount} tipi',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      _closeBusyDialog();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore import: $e')),
      );
    }
  }

  void _showBusyDialog(String message) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 16),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }

  void _closeBusyDialog() {
    final navigator = Navigator.of(context, rootNavigator: true);
    if (navigator.canPop()) {
      navigator.pop();
    }
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
          const Divider(),
          ListTile(
            title: const Text('Esporta dati'),
            subtitle: const Text('Crea un file di backup dei dati'),
            leading: const Icon(Icons.upload_file),
            onTap: _exportData,
          ),
          ListTile(
            title: const Text('Importa dati'),
            subtitle: const Text('Ripristina da un file di backup'),
            leading: const Icon(Icons.download_for_offline),
            onTap: _importData,
          ),
        ],
      ),
    );
  }
}

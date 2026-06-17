import 'package:barbero/app_router.dart';
import 'package:barbero/models/appointment.dart';
import 'package:barbero/models/appointment_type.dart';
import 'package:barbero/models/client.dart';
import 'package:barbero/services/backup_sync_service.dart';
import 'package:barbero/theme/theme_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  await init();
  tz.initializeTimeZones();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    ),
  );
  BackupSyncService.checkAndRunAutomaticBackup();
}

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('settings');
  await Hive.openBox('ids');
  Hive.registerAdapter(ClientAdapter());
  Hive.registerAdapter(AppointmentTypeAdapter());
  Hive.registerAdapter(AppointmentStatusAdapter());
  Hive.registerAdapter(AppointmentAdapter());
  await Hive.openBox<Client>('clients');
  await Hive.openBox<AppointmentType>('appointmentTypes');
  await Hive.openBox<Appointment>('appointments');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('it', 'IT'),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        SfGlobalLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('it', 'IT')],
      home: AppRouter(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}

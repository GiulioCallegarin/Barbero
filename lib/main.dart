import 'package:barbero/app_router.dart';
import 'package:barbero/models/appointment.dart';
import 'package:barbero/models/appointment_type.dart';
import 'package:barbero/models/client.dart';
import 'package:barbero/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  await init();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    ),
  );
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
      home: AppRouter(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}

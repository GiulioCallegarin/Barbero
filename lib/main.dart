import 'package:barbero/app_router.dart';
import 'package:barbero/theme/theme_provider.dart';
import 'package:flutter/material.dart';
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

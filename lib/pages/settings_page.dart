import 'package:barbero/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Switch(
        value: Provider.of<ThemeProvider>(context).isDarkMode,
        onChanged:
            (value) =>
                Provider.of<ThemeProvider>(
                  context,
                  listen: false,
                ).toggleTheme(),
      ),
    );
  }
}

import 'dart:convert';

import 'package:barbero/services/data_backup_service.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BackupSyncService {
  static const String _googleScriptUrl = "https://script.google.com/macros/s/AKfycbz7gHCyv_U0DjHNhANtZ8uvJwv6gGcQhMnWudKeCyD8pr0byCcRDAwCvU54TQYCdcDNpg/exec";
  static const String _securityToken = "Ciao1234!";

  static Future<void> checkAndRunAutomaticBackup() async {
    if (!kIsWeb) return;

    final now = DateTime.now();
    if (now.hour < 22 || (now.hour == 22 && now.minute < 30)) return;

    final prefs = await SharedPreferences.getInstance();
    final todayStr = "${now.year}-${now.month}-${now.day}";
    final lastBackupDate = prefs.getString('last_successful_backup_date');
    if (lastBackupDate == todayStr) return;

    final payload = DataBackupService.buildExportPayload();
    if (payload.isEmpty) return;

    try {
      final response = await http.post(
        Uri.parse(_googleScriptUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "token": _securityToken,
          "data": payload,
        }),
      );

      if (response.statusCode == 200) {
        final resBody = jsonDecode(response.body);
        if (resBody["status"] == "success") {
          await prefs.setString('last_successful_backup_date', todayStr);
        }
      }
    } catch (_) {}
  }

  static Future<Map<String, dynamic>?> restoreFromDrive() async {
    if (!kIsWeb) return null;

    try {
      final response = await http.post(
        Uri.parse(_googleScriptUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "token": _securityToken,
          "action": "restore",
        }),
      );

      if (response.statusCode == 200) {
        final resBody = jsonDecode(response.body);
        if (resBody["status"] == "success" && resBody["data"] != null) {
          return Map<String, dynamic>.from(resBody["data"]);
        }
      }
    } catch (_) {}
    return null;
  }
}

import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart';

import 'package:barbero/models/appointment.dart';
import 'package:barbero/models/appointment_type.dart';
import 'package:barbero/models/client.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class DataImportResult {
  final int clientsCount;
  final int appointmentTypesCount;
  final int appointmentsCount;

  const DataImportResult({
    required this.clientsCount,
    required this.appointmentTypesCount,
    required this.appointmentsCount,
  });
}

class DataBackupService {
  static const int exportVersion = 1;
  static const String filePrefix = 'barbero_backup_';

  static Future<File?> exportToFile() async {
    if (kIsWeb) return null;
    final dir = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final file = File('${dir.path}/$filePrefix$timestamp.json');
    final payload = buildExportPayload();
    final json = const JsonEncoder.withIndent('  ').convert(payload);
    await file.writeAsString(json);
    return file;
  }

  static Future<DataImportResult> importFromFile(File file) async {
    final raw = await file.readAsString();
    return importFromJsonString(raw);
  }

  static Future<DataImportResult> importFromJsonString(String raw) async {
    final decoded = jsonDecode(raw);
    if (decoded is! Map) {
      throw const FormatException('Formato file non valido');
    }
    final data = Map<String, dynamic>.from(decoded as Map);
    return importFromPayload(data);
  }

  static Future<DataImportResult> importFromPayload(Map<String, dynamic> data) async {

    final clients = _readList(data, 'clients')
        .map((e) => _clientFromJson(_castMap(e)))
        .toList();
    final appointmentTypes = _readList(data, 'appointmentTypes')
        .map((e) => _appointmentTypeFromJson(_castMap(e)))
        .toList();
    final appointments = _readList(data, 'appointments')
        .map((e) => _appointmentFromJson(_castMap(e)))
        .toList();

    final clientsBox = Hive.box<Client>('clients');
    final appointmentTypesBox = Hive.box<AppointmentType>('appointmentTypes');
    final appointmentsBox = Hive.box<Appointment>('appointments');

    await clientsBox.clear();
    await appointmentTypesBox.clear();
    await appointmentsBox.clear();

    for (final client in clients) {
      clientsBox.put(client.id, client);
    }
    for (final type in appointmentTypes) {
      appointmentTypesBox.put(type.id, type);
    }
    for (final appointment in appointments) {
      appointmentsBox.put(appointment.id, appointment);
    }

    final idsBox = Hive.box('ids');
    final maxClientId = clients.isEmpty
        ? 0
        : clients.map((c) => c.id).reduce((a, b) => max(a, b));
    final storedNextId = _readNextClientId(data);
    final nextClientId =
        max(maxClientId + (clients.isEmpty ? 0 : 1), storedNextId);
    await idsBox.put('client', nextClientId);

    return DataImportResult(
      clientsCount: clients.length,
      appointmentTypesCount: appointmentTypes.length,
      appointmentsCount: appointments.length,
    );
  }

  static Map<String, dynamic> buildExportPayload() {
    final clientsBox = Hive.box<Client>('clients');
    final appointmentTypesBox = Hive.box<AppointmentType>('appointmentTypes');
    final appointmentsBox = Hive.box<Appointment>('appointments');
    final idsBox = Hive.box('ids');

    final clients = clientsBox.values.toList()
      ..sort((a, b) => a.id.compareTo(b.id));
    final appointmentTypes = appointmentTypesBox.values.toList()
      ..sort((a, b) => a.id.compareTo(b.id));
    final appointments = appointmentsBox.values.toList()
      ..sort((a, b) => a.id.compareTo(b.id));

    final maxClientId = clients.isEmpty
        ? 0
        : clients.map((c) => c.id).reduce((a, b) => max(a, b));
    final nextClientId = idsBox.get('client',
        defaultValue: clients.isEmpty ? 0 : maxClientId + 1) as int;

    return {
      'version': exportVersion,
      'exportedAt': DateTime.now().toIso8601String(),
      'ids': {'client': nextClientId},
      'clients': clients.map(_clientToJson).toList(),
      'appointmentTypes': appointmentTypes.map(_appointmentTypeToJson).toList(),
      'appointments': appointments.map(_appointmentToJson).toList(),
    };
  }

  static List<dynamic> _readList(Map<String, dynamic> data, String key) {
    final value = data[key];
    return value is List ? value : const [];
  }

  static Map<String, dynamic> _castMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value as Map);
    throw const FormatException('Formato file non valido');
  }

  static int _readNextClientId(Map<String, dynamic> data) {
    final ids = data['ids'];
    if (ids is Map) {
      final map = Map<String, dynamic>.from(ids as Map);
      final next = map['client'];
      if (next is num) return next.toInt();
    }
    return 0;
  }

  static Map<String, dynamic> _clientToJson(Client c) => {
        'id': c.id,
        'firstName': c.firstName,
        'lastName': c.lastName,
        'phoneNumber': c.phoneNumber,
        'address': c.address,
        'gender': c.gender,
      };

  static Client _clientFromJson(Map<String, dynamic> map) {
    final client = Client(
      firstName: (map['firstName'] ?? '').toString(),
      lastName: (map['lastName'] ?? '').toString(),
      phoneNumber: (map['phoneNumber'] ?? '').toString(),
      address: (map['address'] ?? '').toString(),
      gender: (map['gender'] ?? '').toString(),
    );
    client.id = _toInt(map['id']);
    return client;
  }

  static Map<String, dynamic> _appointmentTypeToJson(AppointmentType t) => {
        'id': t.id,
        'name': t.name,
        'defaultPrice': t.defaultPrice,
        'defaultDuration': t.defaultDuration,
        'target': t.target,
      };

  static AppointmentType _appointmentTypeFromJson(Map<String, dynamic> map) {
    return AppointmentType(
      id: _toInt(map['id']),
      name: (map['name'] ?? '').toString(),
      defaultPrice: _toDouble(map['defaultPrice']),
      defaultDuration: _toInt(map['defaultDuration']),
      target: (map['target'] ?? 'all').toString(),
    );
  }

  static Map<String, dynamic> _appointmentToJson(Appointment a) => {
        'id': a.id,
        'date': a.date.toIso8601String(),
        'clientId': a.clientId,
        'appointmentTypeId': a.appointmentTypeId,
        'appointmentType': a.appointmentType,
        'price': a.price,
        'duration': a.duration,
        'notes': a.notes,
        'status': a.status.name,
        'pauseDurationMinutes': a.pauseDurationMinutes,
      };

  static Appointment _appointmentFromJson(Map<String, dynamic> map) {
    final statusValue = map['status'];
    final status = _parseStatus(statusValue);
    return Appointment(
      id: _toInt(map['id']),
      date: DateTime.tryParse((map['date'] ?? '').toString()) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      clientId: _toInt(map['clientId']),
      appointmentTypeId: _toInt(map['appointmentTypeId']),
      appointmentType: (map['appointmentType'] ?? '').toString(),
      price: _toDouble(map['price']),
      duration: _toInt(map['duration']),
      notes: map['notes'] == null ? null : map['notes'].toString(),
      status: status,
      pauseDurationMinutes: _toInt(map['pauseDurationMinutes']),
    );
  }

  static AppointmentStatus _parseStatus(dynamic value) {
    if (value is String) {
      for (final status in AppointmentStatus.values) {
        if (status.name == value) return status;
      }
    }
    if (value is num) {
      final index = value.toInt();
      if (index >= 0 && index < AppointmentStatus.values.length) {
        return AppointmentStatus.values[index];
      }
    }
    return AppointmentStatus.pending;
  }

  static int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }
}

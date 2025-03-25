import 'package:barbero/models/appointment.dart';
import 'package:barbero/models/appointment_type.dart';
import 'package:barbero/models/client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class AppointmentDialog extends StatefulWidget {
  const AppointmentDialog({super.key});

  @override
  _AppointmentDialogState createState() => _AppointmentDialogState();
}

class _AppointmentDialogState extends State<AppointmentDialog> {
  final _formKey = GlobalKey<FormState>();
  Client? _selectedClient;
  AppointmentType? _selectedAppointmentType;
  double _price = 0.0;
  int _duration = 0;
  String? _notes;
  final DateTime _selectedDate = DateTime.now();

  final TextEditingController _clientController = TextEditingController();
  final TextEditingController _appointmentTypeController =
      TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  Future<void> _saveAppointment() async {
    if (_formKey.currentState!.validate() &&
        _selectedClient != null &&
        _selectedAppointmentType != null) {
      final newId = await Appointment.getNextId();
      final appointmentBox = Hive.box<Appointment>('appointments');

      final newAppointment = Appointment(
        id: newId,
        date: _selectedDate,
        clientId: _selectedClient!.id,
        appointmentTypeId: _selectedAppointmentType!.id,
        appointmentType: _selectedAppointmentType!.name,
        price: _price,
        duration: _duration,
        notes: _notes,
      );

      await appointmentBox.put(newId, newAppointment);
      Navigator.of(context).pop();
    }
  }

  Widget _buildTypeAheadField<T>({
    required TextEditingController myController,
    required String labelText,
    required Future<List<T>> Function(String) suggestionsCallback,
    required Widget Function(BuildContext, T) itemBuilder,
    required void Function(T) onSelected,
  }) {
    return TypeAheadField<T>(
      builder:
          (context, controller, focusNode) => TextFormField(
            controller: myController,
            decoration: InputDecoration(labelText: labelText),
            focusNode: focusNode,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a $labelText';
              }
              return null;
            },
          ),
      suggestionsCallback: suggestionsCallback,
      itemBuilder: itemBuilder,
      onSelected: onSelected,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Appointment'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTypeAheadField<Client>(
              myController: _clientController,
              labelText: "Select Client",
              suggestionsCallback: (pattern) async {
                final clientBox = Hive.box<Client>('clients');
                return clientBox.values
                    .where(
                      (client) =>
                          client.firstName.toLowerCase().contains(
                            pattern.toLowerCase(),
                          ) ||
                          client.lastName.toLowerCase().contains(
                            pattern.toLowerCase(),
                          ),
                    )
                    .toList();
              },
              itemBuilder: (context, Client suggestion) {
                return ListTile(
                  title: Text('${suggestion.firstName} ${suggestion.lastName}'),
                );
              },
              onSelected: (Client suggestion) {
                setState(() {
                  _selectedClient = suggestion;
                  _clientController.text =
                      '${suggestion.firstName} ${suggestion.lastName}';
                });
              },
            ),
            _buildTypeAheadField<AppointmentType>(
              myController: _appointmentTypeController,
              labelText: "Select Type",
              suggestionsCallback: (pattern) async {
                final typeBox = Hive.box<AppointmentType>('appointmentTypes');
                return typeBox.values
                    .where(
                      (type) => type.name.toLowerCase().contains(
                        pattern.toLowerCase(),
                      ),
                    )
                    .toList();
              },
              itemBuilder: (context, AppointmentType suggestion) {
                return ListTile(title: Text(suggestion.name));
              },
              onSelected: (AppointmentType suggestion) {
                setState(() {
                  _selectedAppointmentType = suggestion;
                  _appointmentTypeController.text = suggestion.name;
                  _price = suggestion.defaultPrice;
                  _duration = suggestion.defaultDuration;
                  _priceController.text = _price.toStringAsFixed(2);
                  _durationController.text = _duration.toString();
                });
              },
            ),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _price = double.tryParse(value) ?? _price;
                  _priceController.text = _price.toStringAsFixed(2);
                });
              },
            ),
            TextFormField(
              controller: _durationController,
              decoration: const InputDecoration(
                labelText: 'Duration (minutes)',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _duration = int.tryParse(value) ?? _duration;
                  _durationController.text = _duration.toString();
                });
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Notes'),
              onChanged: (value) => _notes = value,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: _saveAppointment,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.tertiary,
          ),
          child: const Text('Save Appointment'),
        ),
      ],
    );
  }
}

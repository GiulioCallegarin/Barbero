import 'package:flutter/material.dart';
import 'package:barbero/models/appointment.dart';
import 'package:barbero/models/client.dart';
import 'package:barbero/models/appointment_type.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class AppointmentDialog extends StatefulWidget {
  final DateTime selectedDate;
  final Box<Appointment> box;
  final Appointment? appointment; // Null when adding, provided when editing

  const AppointmentDialog({
    super.key,
    required this.selectedDate,
    required this.box,
    this.appointment,
  });

  @override
  _AppointmentDialogState createState() => _AppointmentDialogState();
}

class _AppointmentDialogState extends State<AppointmentDialog> {
  int? _selectedClient;
  int? _selectedType;
  double _price = 0.0;
  int _duration = 30;
  TimeOfDay _selectedTime = TimeOfDay.now();
  final _notesController = TextEditingController();
  late Box<Client> clientBox;
  late Box<AppointmentType> typeBox;

  @override
  void initState() {
    super.initState();
    clientBox = Hive.box<Client>('clients');
    typeBox = Hive.box<AppointmentType>('appointmentTypes');

    // If editing an existing appointment, pre-fill the fields
    if (widget.appointment != null) {
      final appt = widget.appointment!;
      _selectedClient = appt.clientId;
      _selectedType = appt.appointmentTypeId;
      _price = appt.price;
      _duration = appt.duration;
      _selectedTime = TimeOfDay(hour: appt.date.hour, minute: appt.date.minute);
      _notesController.text = appt.notes ?? '';
    }
  }

  void _pickTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (pickedTime != null) {
      setState(() => _selectedTime = pickedTime);
    }
  }

  void _saveAppointment() async {
    if (_selectedClient == null || _selectedType == null) return;

    // Merge selected date with the chosen time
    final DateTime appointmentDate = DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
      widget.selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    if (widget.appointment == null) {
      int newId = await Appointment.getNextId();
      final newAppointment = Appointment(
        id: newId,
        date: appointmentDate,
        clientId: _selectedClient!,
        appointmentTypeId: _selectedType!,
        price: _price,
        duration: _duration,
        notes: _notesController.text,
      );
      widget.box.put(newId, newAppointment);
    } else {
      widget.appointment!
        ..date = appointmentDate
        ..clientId = _selectedClient!
        ..appointmentTypeId = _selectedType!
        ..price = _price
        ..duration = _duration
        ..notes = _notesController.text;
      widget.appointment!.save();
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.appointment == null ? "Add Appointment" : "Edit Appointment",
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Client Selection
          DropdownButton<int>(
            value: _selectedClient,
            hint: const Text("Select Client"),
            items:
                clientBox.values.map((client) {
                  return DropdownMenuItem<int>(
                    value: client.id,
                    child: Text("${client.firstName} ${client.lastName}"),
                  );
                }).toList(),
            onChanged: (value) => setState(() => _selectedClient = value),
          ),

          // Appointment Type Selection
          DropdownButton<int>(
            value: _selectedType,
            hint: const Text("Select Appointment Type"),
            items:
                typeBox.values.map((type) {
                  return DropdownMenuItem<int>(
                    value: type.id,
                    child: Text(type.name),
                  );
                }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedType = value;
                final type = typeBox.get(value);
                if (type != null) {
                  _price = type.defaultPrice;
                  _duration = type.defaultDuration;
                }
              });
            },
          ),

          // Time Picker
          Row(
            children: [
              Text("Time: ${_selectedTime.format(context)}"),
              IconButton(
                icon: const Icon(Icons.access_time),
                onPressed: _pickTime,
              ),
            ],
          ),

          // Price Input
          TextFormField(
            initialValue: _price.toString(),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Price"),
            onChanged:
                (value) =>
                    setState(() => _price = double.tryParse(value) ?? _price),
          ),

          // Duration Input
          TextFormField(
            initialValue: _duration.toString(),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Duration (mins)"),
            onChanged:
                (value) => setState(
                  () => _duration = int.tryParse(value) ?? _duration,
                ),
          ),

          // Notes Input
          TextField(
            controller: _notesController,
            decoration: const InputDecoration(labelText: "Notes"),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(onPressed: _saveAppointment, child: const Text("Save")),
      ],
    );
  }
}

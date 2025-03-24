import 'package:flutter/material.dart';
import 'package:barbero/models/appointment_type.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class AppointmentTypeDialog extends StatefulWidget {
  final AppointmentType? appointmentType;
  final Box<AppointmentType> box;

  const AppointmentTypeDialog({
    super.key,
    this.appointmentType,
    required this.box,
  });

  @override
  _AppointmentTypeDialogState createState() => _AppointmentTypeDialogState();
}

class _AppointmentTypeDialogState extends State<AppointmentTypeDialog> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _durationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.appointmentType != null) {
      _nameController.text = widget.appointmentType!.name;
      _priceController.text = widget.appointmentType!.defaultPrice.toString();
      _durationController.text =
          widget.appointmentType!.defaultDuration.toString();
    }
  }

  void saveAppointmentType() async {
    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _durationController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("All fields are required!")));
      return;
    }

    if (widget.appointmentType == null) {
      int newId = await AppointmentType.getNextId();
      final newType = AppointmentType(
        id: newId,
        name: _nameController.text,
        defaultPrice: double.parse(_priceController.text),
        defaultDuration: int.parse(_durationController.text),
      );
      widget.box.put(newId, newType);
    } else {
      widget.appointmentType!.name = _nameController.text;
      widget.appointmentType!.defaultPrice = double.parse(
        _priceController.text,
      );
      widget.appointmentType!.defaultDuration = int.parse(
        _durationController.text,
      );
      widget.appointmentType!.save();
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.appointmentType == null
            ? 'Add Appointment Type'
            : 'Edit Appointment Type',
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: _priceController,
            decoration: const InputDecoration(labelText: 'Default Price'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _durationController,
            decoration: const InputDecoration(
              labelText: 'Default Duration (mins)',
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: saveAppointmentType,
          child: const Text('Save'),
        ),
      ],
    );
  }
}

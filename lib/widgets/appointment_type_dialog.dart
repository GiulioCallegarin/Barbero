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
  String _selectedTarget = "all"; // Default value

  @override
  void initState() {
    super.initState();
    if (widget.appointmentType != null) {
      _nameController.text = widget.appointmentType!.name;
      _priceController.text = widget.appointmentType!.defaultPrice.toString();
      _durationController.text =
          widget.appointmentType!.defaultDuration.toString();
      _selectedTarget = widget.appointmentType!.target;
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
        target: _selectedTarget, // Save selected gender
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
      widget.appointmentType!.target = _selectedTarget; // Update target
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
          const SizedBox(height: 20),
          const Text("Gender"),
          const SizedBox(height: 10),
          ToggleButtons(
            isSelected: [
              _selectedTarget == "male",
              _selectedTarget == "female",
              _selectedTarget == "all",
            ],
            onPressed: (index) {
              setState(() {
                _selectedTarget = ["male", "female", "all"][index];
              });
            },
            borderRadius: BorderRadius.circular(10.0),
            constraints: const BoxConstraints(minHeight: 50, minWidth: 75),
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text("Male"),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text("Female"),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text("All"),
              ),
            ],
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
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.tertiary,
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }
}

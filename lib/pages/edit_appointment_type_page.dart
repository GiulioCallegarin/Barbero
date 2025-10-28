import 'package:barbero/widgets/styled_text_field.dart';
import 'package:flutter/material.dart';
import 'package:barbero/models/appointment_type.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class EditAppointmentTypePage extends StatefulWidget {
  final AppointmentType? appointmentType;
  final Box<AppointmentType> box;

  const EditAppointmentTypePage({
    super.key,
    this.appointmentType,
    required this.box,
  });

  @override
  EditAppointmentTypePageState createState() => EditAppointmentTypePageState();
}

class EditAppointmentTypePageState extends State<EditAppointmentTypePage> {
  final _nameController = TextEditingController();
  final _durationController = TextEditingController();
  String _selectedTarget = 'all'; // Default value

  @override
  void initState() {
    super.initState();
    if (widget.appointmentType != null) {
      _nameController.text = widget.appointmentType!.name.trim();
      _durationController.text =
          widget.appointmentType!.defaultDuration.toString();
      _selectedTarget = widget.appointmentType!.target;
    }
  }

  void saveAppointmentType() async {
    if (_nameController.text.isEmpty || _durationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tutti i campi sono obbligatori')),
      );
      return;
    }

    if (widget.appointmentType == null) {
      int newId = await AppointmentType.getNextId();
      // When creating a new type we no longer ask for a price in the UI.
      // Set defaultPrice to 0.0 for new types.
      final newType = AppointmentType(
        id: newId,
        name: _nameController.text,
        defaultPrice: 0.0,
        defaultDuration: int.parse(_durationController.text),
        target: _selectedTarget, // Save selected gender
      );
      widget.box.put(newId, newType);
    } else {
      widget.appointmentType!.name = _nameController.text;
      widget.appointmentType!.defaultDuration = int.parse(
        _durationController.text,
      );
      widget.appointmentType!.target = _selectedTarget; // Update target
      widget.appointmentType!.save();
    }
  }

  void exit() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.appointmentType == null
              ? 'Aggiungi tipo di servizio'
              : 'Modifica tipo di servizio',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 20,
          children: [
            StyledTextField(label: 'Nome', controller: _nameController),
            StyledTextField(
              label: 'Durata predefinita (minuti)',
              controller: _durationController,
              keyboardType: TextInputType.number,
            ),
            targetSelection(context),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(64.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annulla'),
            ),
            ElevatedButton(
              onPressed: () {
                saveAppointmentType();
                exit();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.tertiary,
              ),
              child: const Text('Salva'),
            ),
          ],
        ),
      ),
    );
  }

  Column targetSelection(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text('Destinatari'),
        const SizedBox(height: 10),
        Center(
          child: ToggleButtons(
            isSelected: [
              _selectedTarget == 'male',
              _selectedTarget == 'female',
              _selectedTarget == 'all',
            ],
            onPressed: (index) {
              setState(() {
                _selectedTarget = ['male', 'female', 'all'][index];
              });
            },
            borderRadius: BorderRadius.circular(10.0),
            constraints: BoxConstraints(
              minWidth: (MediaQuery.of(context).size.width - 64) / 3,
              minHeight: 50,
            ),
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text('Uomo'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text('Donna'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text('Tutti'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

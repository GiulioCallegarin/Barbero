import 'package:flutter/material.dart';
import 'package:barbero/models/client.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class ClientDialog extends StatefulWidget {
  final Client? client;
  final Box<Client> box;

  const ClientDialog({super.key, this.client, required this.box});

  @override
  _ClientDialogState createState() => _ClientDialogState();
}

class _ClientDialogState extends State<ClientDialog> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  String _selectedGender = "male";

  @override
  void initState() {
    super.initState();
    if (widget.client != null) {
      _firstNameController.text = widget.client!.firstName;
      _lastNameController.text = widget.client!.lastName;
      _phoneController.text = widget.client!.phoneNumber;
      _addressController.text = widget.client!.address;
      _selectedGender = widget.client!.gender;
    }
  }

  void _saveClient() {
    if (!_formKey.currentState!.validate()) return;

    if (widget.client == null) {
      int newId = widget.box.isEmpty ? 1 : widget.box.length + 1;
      final newClient = Client(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        phoneNumber: _phoneController.text,
        address: _addressController.text,
        gender: _selectedGender,
      )..id = newId;
      widget.box.put(newId, newClient);
    } else {
      widget.client!
        ..firstName = _firstNameController.text
        ..lastName = _lastNameController.text
        ..phoneNumber = _phoneController.text
        ..address = _addressController.text
        ..gender = _selectedGender;
      widget.client!.save();
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.client == null ? "Add Client" : "Edit Client"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: "First Name"),
              validator: (value) => value!.isEmpty ? "Required" : null,
            ),
            TextFormField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: "Last Name"),
              validator: (value) => value!.isEmpty ? "Required" : null,
            ),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: "Phone Number"),
              validator: (value) => value!.isEmpty ? "Required" : null,
            ),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: "Address"),
              validator: (value) => value!.isEmpty ? "Required" : null,
            ),

            // Gender Selection
            const SizedBox(height: 20),
            const Text("Gender"),
            const SizedBox(height: 10),
            SizedBox(
              child: ToggleButtons(
                isSelected: [
                  _selectedGender == "male",
                  _selectedGender == "female",
                ],
                onPressed: (index) {
                  setState(() {
                    _selectedGender = ["male", "female"][index];
                  });
                },
                borderRadius: BorderRadius.circular(10.0),
                constraints: const BoxConstraints(minHeight: 50, minWidth: 100),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.man_outlined),
                      const SizedBox(width: 8.0),
                      const Text("Male"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.woman_outlined),
                      const SizedBox(width: 8.0),
                      const Text("Female"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: _saveClient,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.tertiary,
          ),
          child: const Text("Save"),
        ),
      ],
    );
  }
}

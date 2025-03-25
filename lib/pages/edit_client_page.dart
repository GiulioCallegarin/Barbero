import 'package:flutter/material.dart';
import 'package:barbero/models/client.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class EditClientPage extends StatefulWidget {
  final Client? client;
  final Box<Client> box;

  const EditClientPage({super.key, this.client, required this.box});

  @override
  EditClientPageState createState() => EditClientPageState();
}

class EditClientPageState extends State<EditClientPage> {
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

  void saveClient() async {
    if (!_formKey.currentState!.validate()) return;

    if (widget.client == null) {
      int newId = await Client.getNextId();
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
  }

  void exit() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.client == null ? "Add Client" : "Edit Client"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(children: [clientForm(), genderSelection(context)]),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(64.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                saveClient();
                exit();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.tertiary,
              ),
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }

  Column clientForm() {
    return Column(
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
      ],
    );
  }

  Column genderSelection(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text("Gender"),
        const SizedBox(height: 10),
        Center(
          // Centering the ToggleButtons horizontally
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
            constraints: BoxConstraints(
              minWidth: (MediaQuery.of(context).size.width - 64) / 2,
              minHeight: 50,
            ),
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
    );
  }
}

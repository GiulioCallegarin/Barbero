import 'package:barbero/models/appointment.dart';
import 'package:barbero/models/appointment_type.dart';
import 'package:barbero/models/client.dart';
import 'package:barbero/widgets/appointments/custom_date_picker.dart';
import 'package:barbero/widgets/appointments/custom_time_picker.dart';
import 'package:barbero/widgets/styled_text_field.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:dropdown_search/dropdown_search.dart';

class EditAppointmentPage extends StatefulWidget {
  final DateTime? timeSlot;
  final Appointment? appointment;

  const EditAppointmentPage({super.key, this.timeSlot, this.appointment});

  @override
  State<EditAppointmentPage> createState() => _EditAppointmentPageState();
}

class _EditAppointmentPageState extends State<EditAppointmentPage> {
  late Box<Appointment> appointmentBox;
  late Box<Client> clientBox;
  late Box<AppointmentType> appointmentTypeBox;

  late DateTime selectedDate;
  int? selectedClientId;
  int? selectedTypeId;

  final TextEditingController priceController = TextEditingController();
  final TextEditingController durationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    appointmentBox = Hive.box<Appointment>('appointments');
    clientBox = Hive.box<Client>('clients');
    appointmentTypeBox = Hive.box<AppointmentType>('appointmentTypes');
    selectedDate = widget.timeSlot ?? DateTime.now();
  }

  void saveAppointment() {
    if (selectedClientId == null || selectedTypeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select client and type')),
      );
      return;
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Appointment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DropdownSearch<int>(
                items:
                    (filter, infiniteScrollProps) =>
                        clientBox.values.map((client) => client.id).toList(),
                popupProps: PopupProps.menu(
                  showSelectedItems: true,
                  showSearchBox: true,
                  itemBuilder: (context, item, isSelected, searchEntry) {
                    final client = clientBox.values.firstWhere(
                      (c) => c.id == item,
                      orElse:
                          () => Client(
                            firstName: '',
                            lastName: '',
                            phoneNumber: '',
                            address: '',
                            gender: '',
                          ),
                    );
                    return ListTile(
                      title: Text('${client.firstName} ${client.lastName}'),
                      subtitle: Text(client.phoneNumber),
                    );
                  },
                ),
                onChanged: (value) {
                  setState(() {
                    selectedClientId = value;
                  });
                },
                dropdownBuilder: (context, selectedItem) {
                  final client = clientBox.values.firstWhere(
                    (c) => c.id == selectedItem,
                    orElse:
                        () => Client(
                          firstName: '',
                          lastName: '',
                          phoneNumber: '',
                          address: '',
                          gender: '',
                        ),
                  );
                  return Text('${client.firstName} ${client.lastName}');
                },
                decoratorProps: DropDownDecoratorProps(
                  decoration: InputDecoration(
                    labelText: 'Select Client',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownSearch<int>(
                items: (filter, infiniteScrollProps) {
                  final selectedClient = clientBox.values.firstWhere(
                    (c) => c.id == selectedClientId,
                    orElse:
                        () => Client(
                          firstName: '',
                          lastName: '',
                          phoneNumber: '',
                          address: '',
                          gender: '',
                        ),
                  );
                  final clientGender = selectedClient.gender;
                  return appointmentTypeBox.values
                      .where(
                        (type) =>
                            type.target == 'all' ||
                            (clientGender.isNotEmpty &&
                                type.target == clientGender),
                      )
                      .map((type) => type.id)
                      .toList();
                },
                popupProps: PopupProps.menu(
                  showSelectedItems: true,
                  showSearchBox: true,
                  itemBuilder: (context, item, isSelected, searchEntry) {
                    final type = appointmentTypeBox.get(item);
                    return ListTile(
                      title: Text(type?.name ?? ''),
                      subtitle: Text(
                        '€${type?.defaultPrice} • ${type?.defaultDuration} mins',
                      ),
                    );
                  },
                ),
                onChanged: (value) {
                  setState(() {
                    selectedTypeId = value;
                    final type = appointmentTypeBox.get(value);
                    priceController.text = type?.defaultPrice.toString() ?? '';
                    durationController.text =
                        type?.defaultDuration.toString() ?? '';
                  });
                },
                dropdownBuilder: (context, selectedItem) {
                  final type = appointmentTypeBox.get(selectedItem);
                  return Text(type?.name ?? '');
                },
                decoratorProps: DropDownDecoratorProps(
                  decoration: InputDecoration(
                    labelText: 'Select Type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomDatePicker(
                    selectedDate: selectedDate,
                    onDateChanged: (date) {
                      setState(() {
                        selectedDate = date;
                      });
                    },
                  ),
                  const SizedBox(width: 20),
                  CustomTimePicker(
                    selectedDate: selectedDate,
                    onTimeChanged: (time) {
                      setState(() {
                        selectedDate = time;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              StyledTextField(
                label: 'Price',
                controller: priceController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              StyledTextField(
                label: 'Duration',
                controller: durationController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: saveAppointment,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Confirm', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

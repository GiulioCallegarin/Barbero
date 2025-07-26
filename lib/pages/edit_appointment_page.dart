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

    if (widget.appointment != null) {
      selectedDate = widget.appointment!.date;
      selectedClientId = widget.appointment!.clientId;
      selectedTypeId =
          appointmentTypeBox.values
              .firstWhere(
                (type) => type.name == widget.appointment!.appointmentType,
                orElse: () => appointmentTypeBox.values.first,
              )
              .id;
      priceController.text = widget.appointment!.price.toString();
      durationController.text = widget.appointment!.duration.toString();
    }
  }

  void saveAppointment() {
    if (selectedClientId == null || selectedTypeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select client and type')),
      );
      return;
    }

    final price = double.tryParse(priceController.text) ?? 0.0;
    final duration = int.tryParse(durationController.text) ?? 0;
    final appointmentType = appointmentTypeBox.get(selectedTypeId);

    final localDate = selectedDate;

    if (widget.appointment != null) {
      final appt = widget.appointment!;
      appt.date = localDate;
      appt.clientId = selectedClientId!;
      appt.appointmentType = appointmentType?.name ?? '';
      appt.appointmentTypeId = selectedTypeId!;
      appt.price = price;
      appt.duration = duration;
      appointmentBox.put(appt.id, appt);
    } else {
      final newId =
          appointmentBox.isEmpty
              ? 1
              : appointmentBox.values
                      .map((a) => a.id)
                      .reduce((a, b) => a > b ? a : b) +
                  1;
      final newAppointment = Appointment(
        id: newId,
        date: localDate,
        clientId: selectedClientId!,
        appointmentType: appointmentType?.name ?? '',
        appointmentTypeId: selectedTypeId!,
        price: price,
        duration: duration,
        status: AppointmentStatus.pending,
      );
      appointmentBox.put(newId, newAppointment);
    }

    Navigator.pop(context);
  }

  void markAsCompleted() {
    if (widget.appointment != null) {
      setState(() {
        widget.appointment!.status = AppointmentStatus.done;
        appointmentBox.put(widget.appointment!.id, widget.appointment!);
      });
      Navigator.pop(context);
    }
  }

  void deleteAppointment() {
    if (widget.appointment != null) {
      appointmentBox.delete(widget.appointment!.id);
      Navigator.pop(context);
    }
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
                selectedItem: selectedClientId,
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
                    selectedTypeId = null;
                    priceController.clear();
                    durationController.clear();
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
                enabled: selectedClientId != null,
                selectedItem: selectedTypeId,
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
                        selectedDate = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          selectedDate.hour,
                          selectedDate.minute,
                        );
                      });
                    },
                  ),
                  const SizedBox(width: 20),
                  CustomTimePicker(
                    selectedDate: selectedDate,
                    onTimeChanged: (time) {
                      setState(() {
                        selectedDate = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          time.hour,
                          time.minute,
                        );
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
              if (widget.appointment != null)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: markAsCompleted,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Mark as Completed',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: deleteAppointment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Delete',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              if (widget.appointment != null) const SizedBox(height: 16),
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

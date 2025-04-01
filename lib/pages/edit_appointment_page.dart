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

  @override
  void initState() {
    super.initState();
    appointmentBox = Hive.box<Appointment>('appointments');
    clientBox = Hive.box<Client>('clients');
    appointmentTypeBox = Hive.box<AppointmentType>('appointmentTypes');
    selectedDate = widget.timeSlot ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Appointment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 20,
          children: [
            DropdownSearch<int>(
              items: (filter, infiniteScrollProps) => [1, 2, 3, 4, 5],
              popupProps: PopupProps.menu(
                showSelectedItems: true,
                showSearchBox: true,
              ),
              onChanged: (value) {
                // Handle the selected value
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
            DropdownSearch<int>(
              items: (filter, infiniteScrollProps) => [1, 2, 3, 4, 5],
              popupProps: PopupProps.menu(
                showSelectedItems: true,
                showSearchBox: true,
              ),
              onChanged: (value) {
                // Handle the selected value
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
            StyledTextField(
              label: 'Price',
              controller: TextEditingController(),
              keyboardType: TextInputType.number,
            ),
            StyledTextField(
              label: 'Duration',
              controller: TextEditingController(),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }
}

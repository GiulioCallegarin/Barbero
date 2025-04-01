import 'package:flutter/material.dart';

class CustomTimePicker extends StatelessWidget {
  final DateTime? selectedDate;
  final Function(DateTime) onTimeChanged;
  const CustomTimePicker({
    super.key,
    required this.selectedDate,
    required this.onTimeChanged,
  });

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDate!),
    );
    if (pickedTime != null &&
        pickedTime != TimeOfDay.fromDateTime(selectedDate!)) {
      final DateTime newDateTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      onTimeChanged(newDateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 20,
      children: [
        OutlinedButton(
          onPressed: () => _selectTime(context),
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.access_time,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              const SizedBox(width: 10),
              Text(
                '${selectedDate!.hour}:${selectedDate!.minute.toString().padLeft(2, '0')}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

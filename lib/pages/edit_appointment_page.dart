import 'package:barbero/models/appointment.dart';
import 'package:barbero/models/appointment_type.dart';
import 'package:barbero/models/client.dart';
import 'package:barbero/widgets/appointments/custom_date_picker.dart';
import 'package:barbero/widgets/appointments/custom_time_picker.dart';
import 'package:barbero/widgets/styled_text_field.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'dart:convert';

class AddedService {
  int? typeId;
  String name;
  int durationMinutes; // fixed from appointment type default
  int pauseAfterMinutes; // gap after this service (tempo di posa)
  AddedService({
    this.typeId,
    this.name = '',
    this.durationMinutes = 0,
    this.pauseAfterMinutes = 0,
  });
  Map<String, dynamic> toJson() => {
    'typeId': typeId,
    'name': name,
    'duration': durationMinutes,
    'pauseAfter': pauseAfterMinutes,
  };
  static AddedService fromJson(Map<String, dynamic> j) => AddedService(
    typeId: j['typeId'] as int?,
    name: (j['name'] as String?) ?? '',
    durationMinutes: (j['duration'] as int?) ?? 0,
    pauseAfterMinutes: (j['pauseAfter'] as int?) ?? 0,
  );
}

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
  final TextEditingController durationController = TextEditingController();
  // multiple services support: a list of added service entries (each has its own type and duration)
  final List<AddedService> addedServices = [];
  // pause duration in minutes (tempo di posa), between 0 and 180
  int pauseDurationMinutes = 0;

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
      durationController.text = widget.appointment!.duration.toString();
      pauseDurationMinutes = widget.appointment!.pauseDurationMinutes;
      // If this appointment contains serialized services in notes, restore them
      try {
        if (widget.appointment!.notes != null &&
            widget.appointment!.notes!.isNotEmpty) {
          final parsed = jsonDecode(widget.appointment!.notes!);
          if (parsed is Map && parsed['services'] is List) {
            final services = parsed['services'] as List;
            addedServices.clear();
            for (final s in services) {
              if (s is Map<String, dynamic>) {
                addedServices.add(AddedService.fromJson(s));
              } else if (s is Map) {
                addedServices.add(
                  AddedService.fromJson(Map<String, dynamic>.from(s)),
                );
              }
            }
            // If notes contained a main service as first element, extract it into selectedTypeId
            if (addedServices.isNotEmpty) {
              final first = addedServices.first;
              if (first.typeId != null) {
                selectedTypeId = first.typeId;
                // preserve the main service pause value into the global pause slider
                pauseDurationMinutes = first.pauseAfterMinutes;
                // remove main service from addedServices so UI shows it as the main selected type
                addedServices.removeAt(0);
                // update duration controller to reflect durations only
                durationController.text = computeTotalDuration().toString();
              }
            }
          }
        }
      } catch (_) {
        // ignore malformed notes
      }
      // If we didn't get selectedTypeId from notes, fallback to appointmentType string
      selectedTypeId ??=
          appointmentTypeBox.values
              .firstWhere(
                (type) => type.name == widget.appointment!.appointmentType,
                orElse: () => appointmentTypeBox.values.first,
              )
              .id;
    }
  }

  // Compute total duration including the main selected type (if any)
  // sum only durations (exclude pauses)
  int computeAddedServicesDurationsSum() {
    if (addedServices.isEmpty) return 0;
    return addedServices.map((s) => s.durationMinutes).fold(0, (a, b) => a + b);
  }

  int computeTotalDuration() {
    // total should be sum of service durations only (do not include pauses)
    int total = 0;
    if (selectedTypeId != null) {
      final sel = appointmentTypeBox.get(selectedTypeId);
      total += sel?.defaultDuration ?? 0;
    }
    total += computeAddedServicesDurationsSum();
    return total;
  }


  void saveAppointment() {
    if (selectedClientId == null || selectedTypeId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Seleziona cliente e tipo')));
      return;
    }

    // price removed: store 0.0 (prices are not set at appointment creation)
    final price = 0.0;
    // compute duration: if user added services, sum those durations, otherwise use typed duration or selected type default
    int duration = int.tryParse(durationController.text) ?? 0;
    if (addedServices.isNotEmpty) {
      // include the main selected service (if any) plus all added services and their pauses
      duration = computeTotalDuration();
    } else if (selectedTypeId != null && duration == 0) {
      final sel = appointmentTypeBox.get(selectedTypeId);
      duration = sel?.defaultDuration ?? duration;
    }
    final appointmentType =
        selectedTypeId != null ? appointmentTypeBox.get(selectedTypeId) : null;

    final localDate = selectedDate;

    if (widget.appointment != null) {
      final appt = widget.appointment!;
      appt.date = localDate;
      appt.clientId = selectedClientId!;
      // if multiple services were added, store a joined representation in appointmentType
      if (addedServices.isNotEmpty) {
        // include main selected service as first element in the representation
        final List<String> names = [];
        if (selectedTypeId != null) {
          final main = appointmentTypeBox.get(selectedTypeId);
          if (main != null && main.name.isNotEmpty) names.add(main.name);
        }
        names.addAll(
          addedServices.map((s) => s.name).where((n) => n.isNotEmpty),
        );
        appt.appointmentType = names.join(' + ');
        appt.appointmentTypeId =
            selectedTypeId ?? (addedServices.first.typeId ?? 0);
      } else {
        appt.appointmentType = appointmentType?.name ?? '';
        appt.appointmentTypeId = selectedTypeId ?? 0;
      }
      appt.price = price; // kept as 0.0
      appt.duration = duration;
      // store sum of pauses: include main pauseDurationMinutes plus pauses from added services
      appt.pauseDurationMinutes =
          addedServices.isNotEmpty
              ? (pauseDurationMinutes +
                  addedServices
                      .map((s) => s.pauseAfterMinutes)
                      .fold(0, (a, b) => a + b))
              : pauseDurationMinutes;
      // serialize services into notes so calendar can reconstruct segments
      if (addedServices.isNotEmpty) {
        final servicesForNotes = <Map<String, dynamic>>[];
        // include main selected service first (if any) with its pauseDurationMinutes
        if (selectedTypeId != null) {
          final main = appointmentTypeBox.get(selectedTypeId);
          if (main != null) {
            servicesForNotes.add({
              'typeId': main.id,
              'name': main.name,
              'duration': main.defaultDuration,
              'pauseAfter': pauseDurationMinutes,
            });
          }
        }
        servicesForNotes.addAll(addedServices.map((s) => s.toJson()));
        final data = {'services': servicesForNotes};
        appt.notes = jsonEncode(data);
      } else {
        // Clear notes if no services are added (revert to single service)
        appt.notes = null;
      }
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
        appointmentType:
            addedServices.isNotEmpty
                ? (() {
                  final List<String> names = [];
                  if (selectedTypeId != null) {
                    final main = appointmentTypeBox.get(selectedTypeId);
                    if (main != null && main.name.isNotEmpty) {
                      names.add(main.name);
                    }
                  }
                  names.addAll(
                    addedServices.map((s) => s.name).where((n) => n.isNotEmpty),
                  );
                  return names.join(' + ');
                })()
                : (appointmentType?.name ?? ''),
        appointmentTypeId:
            selectedTypeId ??
            (addedServices.isNotEmpty ? (addedServices.first.typeId ?? 0) : 0),
        price: price,
        duration: duration,
        status: AppointmentStatus.pending,
        pauseDurationMinutes:
            addedServices.isNotEmpty
                ? (pauseDurationMinutes +
                    addedServices
                        .map((s) => s.pauseAfterMinutes)
                        .fold(0, (a, b) => a + b))
                : pauseDurationMinutes,
      );
      if (addedServices.isNotEmpty) {
        final servicesForNotes = <Map<String, dynamic>>[];
        if (selectedTypeId != null) {
          final main = appointmentTypeBox.get(selectedTypeId);
          if (main != null) {
            servicesForNotes.add({
              'typeId': main.id,
              'name': main.name,
              'duration': main.defaultDuration,
              'pauseAfter': pauseDurationMinutes,
            });
          }
        }
        servicesForNotes.addAll(addedServices.map((s) => s.toJson()));
        final data = {'services': servicesForNotes};
        newAppointment.notes = jsonEncode(data);
      }
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

  void markAsCancelled() {
    if (widget.appointment != null) {
      setState(() {
        widget.appointment!.status = AppointmentStatus.cancelled;
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
      appBar: AppBar(
        title: Text(
          widget.appointment == null
              ? 'Nuovo appuntamento'
              : 'Modifica appuntamento',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DropdownSearch<Client>(
                selectedItem: selectedClientId != null
                    ? clientBox.values.firstWhere(
                        (c) => c.id == selectedClientId,
                        orElse: () => clientBox.values.isNotEmpty
                            ? clientBox.values.first
                            : Client(
                                firstName: '',
                                lastName: '',
                                phoneNumber: '',
                                address: '',
                                gender: '',
                              ),
                      )
                    : null,
                items: (filter, infiniteScrollProps) {
                  return clientBox.values.toList();
                },
                compareFn: (item1, item2) => item1.id == item2.id,
                popupProps: PopupProps.modalBottomSheet(
                  showSelectedItems: true,
                  showSearchBox: true,
                  modalBottomSheetProps: ModalBottomSheetProps(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    elevation: 6,
                    useSafeArea: true,
                  ),
                  searchFieldProps: TextFieldProps(
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Cerca cliente...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  itemBuilder: (context, client, isSelected, searchEntry) {
                    return ListTile(
                      dense: true,
                      title: Text('${client.firstName} ${client.lastName}'),
                      subtitle: Text(client.phoneNumber),
                      selected: isSelected,
                    );
                  },
                ),
                filterFn: (client, filter) {
                  if (filter.isEmpty) return true;
                  final filterLower = filter.toLowerCase();
                  final fullName =
                      '${client.firstName} ${client.lastName}'.toLowerCase();
                  final phone = client.phoneNumber.toLowerCase();
                  return fullName.contains(filterLower) ||
                      phone.contains(filterLower);
                },
                onChanged: (client) {
                  setState(() {
                    selectedClientId = client?.id;
                    selectedTypeId = null;
                    durationController.clear();
                  });
                },
                dropdownBuilder: (context, client) {
                  if (client == null) return const Text('');
                  return Text('${client.firstName} ${client.lastName}');
                },
                decoratorProps: DropDownDecoratorProps(
                  decoration: InputDecoration(
                    labelText: 'Seleziona Cliente',
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
                      subtitle: Text('${type?.defaultDuration} mins'),
                    );
                  },
                ),
                onChanged: (value) {
                  setState(() {
                    selectedTypeId = value;
                    // update duration to include selected main service + any added services
                    durationController.text = computeTotalDuration().toString();
                  });
                },
                dropdownBuilder: (context, selectedItem) {
                  final type = appointmentTypeBox.get(selectedItem);
                  return Text(type?.name ?? '');
                },
                decoratorProps: DropDownDecoratorProps(
                  decoration: InputDecoration(
                    labelText: 'Seleziona Servizio',
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
              // Price removed from appointment creation UI
              const SizedBox(height: 16),
              StyledTextField(
                label: 'Durata (Minuti)',
                controller: durationController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Align(alignment: Alignment.centerLeft),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Tempo post servizio: ${pauseDurationMinutes ~/ 60}h ${pauseDurationMinutes % 60}m',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ore: ${pauseDurationMinutes ~/ 60}'),
                        Slider(
                          value: (pauseDurationMinutes ~/ 60).toDouble(),
                          min: 0,
                          max: 3,
                          divisions: 3,
                          label: '${pauseDurationMinutes ~/ 60}h',
                          onChanged: (v) {
                            setState(() {
                              final hours = v.toInt();
                              final minutesPart = pauseDurationMinutes % 60;
                              pauseDurationMinutes = hours * 60 + minutesPart;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Minuti: ${pauseDurationMinutes % 60}'),
                        Slider(
                          value: (pauseDurationMinutes % 60).toDouble(),
                          min: 0,
                          max: 55,
                          divisions: 11, // 0..55 step 5
                          label: '${pauseDurationMinutes % 60}m',
                          onChanged: (v) {
                            setState(() {
                              // snap to nearest 5
                              final snapped = (v / 5).round() * 5;
                              final hours = pauseDurationMinutes ~/ 60;
                              pauseDurationMinutes = hours * 60 + snapped;
                              if (pauseDurationMinutes > 180) {
                                pauseDurationMinutes = 180;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Tempo totale: ${pauseDurationMinutes ~/ 60}h ${pauseDurationMinutes % 60}m',
                ),
              ),
              const SizedBox(height: 16),
              // Added services list and add-button
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Servizi aggiunti',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 8),
              Column(
                children: [
                  // render each added service as its own card with a dropdown and sliders
                  ...addedServices.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final service = entry.value;
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: DropdownSearch<int>(
                                    selectedItem: service.typeId,
                                    items:
                                        (filter, infiniteScrollProps) =>
                                            appointmentTypeBox.values
                                                .map((t) => t.id)
                                                .toList(),
                                    popupProps: PopupProps.menu(
                                      showSelectedItems: true,
                                      showSearchBox: true,
                                      itemBuilder: (
                                        context,
                                        item,
                                        isSelected,
                                        search,
                                      ) {
                                        final type = appointmentTypeBox.get(
                                          item,
                                        );
                                        return ListTile(
                                          title: Text(type?.name ?? ''),
                                          subtitle: Text(
                                            '${type?.defaultDuration} mins',
                                          ),
                                        );
                                      },
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        service.typeId = value;
                                        final t = appointmentTypeBox.get(value);
                                        service.name = t?.name ?? '';
                                        // Set service duration from the selected type's default
                                        service.durationMinutes =
                                            t?.defaultDuration ?? 0;
                                        // include main selected service as well
                                        durationController.text =
                                            computeTotalDuration().toString();
                                      });
                                    },
                                    dropdownBuilder: (context, selectedItem) {
                                      final type = appointmentTypeBox.get(
                                        selectedItem,
                                      );
                                      return Text(type?.name ?? '');
                                    },
                                    decoratorProps: DropDownDecoratorProps(
                                      decoration: InputDecoration(
                                        labelText: 'Seleziona Servizio',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () {
                                    setState(() {
                                      addedServices.removeAt(idx);
                                      durationController.text =
                                          computeTotalDuration().toString();
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // show pause sliders only (tempo di posa) after the service
                            if (service.typeId != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Durata servizio: ${service.durationMinutes} min',
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Tempo post servizio: ${service.pauseAfterMinutes ~/ 60}h ${service.pauseAfterMinutes % 60}m',
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Ore: ${service.pauseAfterMinutes ~/ 60}',
                                            ),
                                            Slider(
                                              value:
                                                  (service.pauseAfterMinutes ~/
                                                          60)
                                                      .toDouble(),
                                              min: 0,
                                              max: 3,
                                              divisions: 3,
                                              label:
                                                  '${service.pauseAfterMinutes ~/ 60}h',
                                              onChanged: (v) {
                                                setState(() {
                                                  final hours = v.toInt();
                                                  final minutesPart =
                                                      service
                                                          .pauseAfterMinutes %
                                                      60;
                                                  service.pauseAfterMinutes =
                                                      hours * 60 + minutesPart;
                                                  durationController.text =
                                                      computeTotalDuration()
                                                          .toString();
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Minuti: ${service.pauseAfterMinutes % 60}',
                                            ),
                                            Slider(
                                              value:
                                                  (service.pauseAfterMinutes %
                                                          60)
                                                      .toDouble(),
                                              min: 0,
                                              max: 55,
                                              divisions: 11,
                                              label:
                                                  '${service.pauseAfterMinutes % 60}m',
                                              onChanged: (v) {
                                                setState(() {
                                                  final snapped =
                                                      (v / 5).round() * 5;
                                                  final hours =
                                                      service
                                                          .pauseAfterMinutes ~/
                                                      60;
                                                  service.pauseAfterMinutes =
                                                      hours * 60 + snapped;
                                                  if (service
                                                          .pauseAfterMinutes >
                                                      180) {
                                                    service.pauseAfterMinutes =
                                                        180;
                                                  }
                                                  durationController.text =
                                                      computeTotalDuration()
                                                          .toString();
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          // add an empty service entry; user will select type in the new card
                          addedServices.add(AddedService());
                        });
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Aggiungi servizio'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const SizedBox(height: 32),
              if (widget.appointment != null)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: markAsCompleted,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Completato',
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
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Cancella',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 12),
              if (widget.appointment != null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: markAsCancelled,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Annulla',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              if (widget.appointment != null) const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: saveAppointment,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Conferma', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

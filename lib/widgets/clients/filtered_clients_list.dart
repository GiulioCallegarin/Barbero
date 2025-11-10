import 'package:barbero/models/client.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class FilteredClientsList extends StatelessWidget {
  final Box<Client> clientBox;
  final String searchQuery;
  final Function showEditClientPage;
  final Function deleteClient;
  final Function showClientHistory;

  const FilteredClientsList({
    super.key,
    required this.clientBox,
    required this.searchQuery,
    required this.showEditClientPage,
    required this.deleteClient,
    required this.showClientHistory,
  });

  @override
  Widget build(BuildContext context) {
    // local helper to avoid using deprecated .withOpacity
    Color withOpacity(Color base, double opacity) {
      int alpha = (opacity * 255).round();
      if (alpha < 0) alpha = 0;
      if (alpha > 255) alpha = 255;
  final int v = base.toARGB32();
  final int r = (v >> 16) & 0xFF;
  final int g = (v >> 8) & 0xFF;
  final int b = v & 0xFF;
      return Color.fromARGB(alpha, r, g, b);
    }
    return ValueListenableBuilder(
      valueListenable: clientBox.listenable(),
      builder: (context, Box<Client> box, _) {
        if (box.isEmpty) {
          return const Center(child: Text('Nessun cliente'));
        }

        final filteredClients =
            box.values.where((client) {
              final name =
                  '${client.firstName} ${client.lastName}'.toLowerCase();
              return name.contains(searchQuery);
            }).toList();

        filteredClients.sort((a, b) {
          final aName = '${a.firstName} ${a.lastName}'.toLowerCase();
          final bName = '${b.firstName} ${b.lastName}'.toLowerCase();
          return aName.compareTo(bName);
        });

        if (filteredClients.isEmpty) {
          return const Center(child: Text('Nessun cliente corrispondente'));
        }

        return ListView.builder(
          itemCount: filteredClients.length,
          itemBuilder: (context, index) {
            final client = filteredClients[index];

            final initials =
                '${client.firstName.isNotEmpty ? client.firstName[0] : ''}${client.lastName.isNotEmpty ? client.lastName[0] : ''}'
                    .toUpperCase();
            // client.key holds the Hive key for this object
            final clientKeyActual = client.key as int;
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 6.0,
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: withOpacity(Theme.of(context).colorScheme.primary, 0.06),
                elevation: 0,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => showClientHistory(client),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                        initials,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    title: Text(
                      '${client.firstName} ${client.lastName}',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      '${client.address}\n${client.phoneNumber}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: () => showEditClientPage(client),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          onPressed: () => deleteClient(clientKeyActual),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

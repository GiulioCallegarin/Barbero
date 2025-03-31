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
    return ValueListenableBuilder(
      valueListenable: clientBox.listenable(),
      builder: (context, Box<Client> box, _) {
        if (box.isEmpty) {
          return const Center(child: Text('No Clients'));
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
          return const Center(child: Text('No matching clients'));
        }

        return ListView.builder(
          itemCount: filteredClients.length,
          itemBuilder: (context, index) {
            final client = filteredClients[index];
            final clientKey = box.keyAt(index);

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text('${client.firstName} ${client.lastName}'),
                subtitle: Text('${client.address}\n${client.phoneNumber}'),
                leading: Icon(
                  client.gender == 'male'
                      ? Icons.man_outlined
                      : Icons.woman_outlined,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                tileColor: Theme.of(context).colorScheme.secondary,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                      onPressed: () => showEditClientPage(client),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      onPressed: () => deleteClient(clientKey),
                    ),
                  ],
                ),
                onTap: () => showClientHistory(client),
              ),
            );
          },
        );
      },
    );
  }
}

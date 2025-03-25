import 'package:barbero/pages/client_history_page.dart';
import 'package:barbero/pages/editing/edit_client_page.dart';
import 'package:flutter/material.dart';
import 'package:barbero/models/client.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  late Box<Client> clientBox;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    clientBox = Hive.box<Client>('clients');
  }

  void _addOrEditClient([Client? client]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditClientPage(client: client, box: clientBox),
      ),
    );
  }

  void _deleteClient(int key) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Delete Client"),
            content: const Text("Are you sure you want to delete this client?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  clientBox.delete(key);
                  Navigator.pop(context);
                  setState(() {}); // Refresh UI after deleting
                },
                child: Text(
                  "Delete",
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search clients...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditClient(),
        child: const Icon(Icons.add),
      ),
      body: ValueListenableBuilder(
        valueListenable: clientBox.listenable(),
        builder: (context, Box<Client> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text("No Clients"));
          }

          final filteredClients =
              box.values.where((client) {
                final name =
                    "${client.firstName} ${client.lastName}".toLowerCase();
                return name.contains(searchQuery);
              }).toList();

          if (filteredClients.isEmpty) {
            return const Center(child: Text("No matching clients"));
          }

          return ListView.builder(
            itemCount: filteredClients.length,
            itemBuilder: (context, index) {
              final client = filteredClients[index];
              final clientKey = box.keyAt(index);

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text("${client.firstName} ${client.lastName}"),
                  subtitle: Text("${client.address}\n${client.phoneNumber}"),
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
                        onPressed: () => _addOrEditClient(client),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        onPressed: () => _deleteClient(clientKey),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ClientHistoryPage(client: client),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

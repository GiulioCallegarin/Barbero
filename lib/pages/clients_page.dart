import 'package:barbero/widgets/client_dialog.dart';
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

  @override
  void initState() {
    super.initState();
    clientBox = Hive.box<Client>('clients');
  }

  void _addOrEditClient([Client? client]) {
    showDialog(
      context: context,
      builder: (context) => ClientDialog(client: client, box: clientBox),
    ).then((_) => setState(() {})); // Refresh UI
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
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clients')),
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
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final client = box.getAt(index)!;
              final clientKey = box.keyAt(index); // Get Hive key

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
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _addOrEditClient(client),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteClient(clientKey),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

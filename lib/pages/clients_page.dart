import 'package:barbero/pages/client_history_page.dart';
import 'package:barbero/pages/edit_client_page.dart';
import 'package:barbero/widgets/clients/filtered_clients_list.dart';
import 'package:barbero/widgets/delete_item_dialog.dart';
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
  final searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    clientBox = Hive.box<Client>('clients');
  }

  void showEditClientPage([Client? client]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditClientPage(client: client, box: clientBox),
      ),
    );
  }

  void deleteClient(int key) {
    deleteItemDialog(
      context,
      'Elimina cliente',
      'Sei sicuro di voler eliminare questo cliente?',
      () {
        clientBox.delete(key);
        setState(() {});
      },
    );
  }

  void showClientHistory(Client client) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClientHistoryPage(client: client),
      ),
    );
  }

  void clearFilter() {
    setState(() {
      searchQuery = '';
      searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clienti'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Cerca clienti...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon:
                    searchQuery.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: clearFilter,
                        )
                        : null,
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
      body: ValueListenableBuilder(
        valueListenable: clientBox.listenable(),
        builder: (context, Box<Client> box, _) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Totale clienti: ${box.length}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: FilteredClientsList(
                  clientBox: clientBox,
                  searchQuery: searchQuery,
                  showEditClientPage: showEditClientPage,
                  deleteClient: deleteClient,
                  showClientHistory: showClientHistory,
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showEditClientPage(),
        tooltip: 'Aggiungi cliente',
        child: const Icon(Icons.add),
      ),
    );
  }
}

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
      'Delete Client',
      'Are you sure you want to delete this client?',
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search clients...',
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
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
        ),
      ),
      body: FilteredClientsList(
        clientBox: clientBox,
        searchQuery: searchQuery,
        showEditClientPage: showEditClientPage,
        deleteClient: deleteClient,
        showClientHistory: showClientHistory,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showEditClientPage(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

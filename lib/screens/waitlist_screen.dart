import 'package:flutter/material.dart';

import '../models/party.dart';
import '../services/storage_service.dart';
import '../widgets/add_party_form.dart';
import '../widgets/party_list_item.dart';

class WaitlistScreen extends StatefulWidget {
  const WaitlistScreen({super.key});

  @override
  State<WaitlistScreen> createState() => _WaitlistScreenState();
}

class _WaitlistScreenState extends State<WaitlistScreen> {
  final StorageService _storageService = StorageService();

  List<Party> _waitlist = [];
  int _lastTicketNumber = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final waitlist = await _storageService.loadWaitlist();
    final lastTicketNumber = await _storageService.loadLastTicketNumber();

    if (!mounted) return;

    setState(() {
      _waitlist = waitlist;
      _lastTicketNumber = lastTicketNumber;
      _isLoading = false;
    });
  }

  Future<void> addParty({
    required String name,
    required int numberOfPeople,
  }) async {
    final trimmedName = name.trim();

    if (trimmedName.isEmpty || numberOfPeople <= 0) {
      return;
    }

    final newTicketNumber = _lastTicketNumber + 1;

    final party = Party(
      name: trimmedName,
      numberOfPeople: numberOfPeople,
      ticketNumber: newTicketNumber,
    );

    setState(() {
      _waitlist.add(party);
      _lastTicketNumber = newTicketNumber;
    });

    await _storageService.saveWaitlist(_waitlist);
    await _storageService.saveLastTicketNumber(_lastTicketNumber);
  }

  Future<void> removeParty(int ticketNumber) async {
    setState(() {
      _waitlist.removeWhere(
        (party) => party.ticketNumber == ticketNumber,
      );
    });

    await _storageService.saveWaitlist(_waitlist);
  }

  void _showAddPartyDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AddPartyForm(
          onAdd: addParty,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Waitlist'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _waitlist.isEmpty
              ? const Center(
                  child: Text(
                    'No parties waiting',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _waitlist.length,
                  itemBuilder: (context, index) {
                    final party = _waitlist[index];

                    return PartyListItem(
                      party: party,
                      partiesAhead: index,
                      onRemove: () => removeParty(party.ticketNumber),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddPartyDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Party'),
      ),
    );
  }
}

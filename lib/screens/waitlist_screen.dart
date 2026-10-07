import 'package:flutter/material.dart';
import 'package:restaurant_waitlist_app/screens/history_screen.dart';

import '../models/party.dart';
import '../services/waitlist_service.dart';
import '../widgets/add_party_form.dart';
import '../widgets/party_list_item.dart';

class WaitlistScreen extends StatefulWidget {
  const WaitlistScreen({super.key});

  @override
  State<WaitlistScreen> createState() => _WaitlistScreenState();
}

class _WaitlistScreenState extends State<WaitlistScreen> {
  final WaitlistService _waitlistService = WaitlistService();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _waitlistService.loadData();

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _addParty({
    required String name,
    required int numberOfPeople,
  }) async {
    await _waitlistService.addParty(
      name: name,
      numberOfPeople: numberOfPeople,
    );

    if (!mounted) return;

    setState(() {});
  }

  Future<void> _removeParty(Party party) async {
    final removed = await _waitlistService.removeParty(
      party.ticketNumber,
    );

    if (!mounted || !removed) return;

    setState(() {});

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('${party.name} removed'),
    duration: const Duration(seconds: 4),
    persist: false, // allow auto-dismiss even with an action
    action: SnackBarAction(
      label: 'UNDO',
      onPressed: _undoLastRemoval,
    ),
  ),
);
  }

  Future<void> _undoLastRemoval() async {
    final restored = await _waitlistService.undoLastRemoval();

    if (!mounted || !restored) return;

    setState(() {});

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  Future<void> _updateParty({
    required int ticketNumber,
    required String name,
    required int numberOfPeople,
  }) async {
    final updated = await _waitlistService.updateParty(
      ticketNumber: ticketNumber,
      name: name,
      numberOfPeople: numberOfPeople,
    );

    if (!mounted || !updated) return;

    setState(() {});
  }

  void _showAddPartyDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AddPartyForm(
          onSubmit: _addParty,
        );
      },
    );
  }

  void _showEditPartyDialog(Party party) {
    showDialog(
      context: context,
      builder: (context) {
        return AddPartyForm(
          title: 'Edit Party',
          submitButtonText: 'Save',
          initialName: party.name,
          initialNumberOfPeople: party.numberOfPeople,
          onSubmit: ({
            required String name,
            required int numberOfPeople,
          }) {
            return _updateParty(
              ticketNumber: party.ticketNumber,
              name: name,
              numberOfPeople: numberOfPeople,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final waitlist = _waitlistService.waitlist;

 return Scaffold(
  appBar: AppBar(
    title: const Text('Restaurant Waitlist'),
    actions: [
      IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HistoryScreen(),
            ),
          );
        },
        icon: const Icon(Icons.history),
        tooltip: 'History',
      ),
    ],
  ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : waitlist.isEmpty
              ? const Center(
                  child: Text(
                    'No parties waiting',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: waitlist.length,
                  itemBuilder: (context, index) {
                    final party = waitlist[index];

                    return PartyListItem(
                      party: party,
                      partiesAhead: index,
                      onRemove: () => _removeParty(party),
                      onEdit: () => _showEditPartyDialog(party),
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

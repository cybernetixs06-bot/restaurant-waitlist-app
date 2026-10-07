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
    await _waitlistService.addParty(name: name, numberOfPeople: numberOfPeople);

    if (!mounted) return;

    setState(() {});
  }

  Future<void> _removeParty(Party party) async {
    final removed = await _waitlistService.removeParty(party.ticketNumber);

    if (!mounted || !removed) return;

    setState(() {});

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${party.name} removed'),
        duration: const Duration(seconds: 4),
        persist: false, // allow auto-dismiss even with an action
        action: SnackBarAction(label: 'UNDO', onPressed: _undoLastRemoval),
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
        return AddPartyForm(onSubmit: _addParty);
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
          onSubmit: ({required String name, required int numberOfPeople}) {
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Restaurant Waitlist',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HistoryScreen()),
            ),
            icon: const Icon(Icons.history),
            tooltip: 'History',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        // Keeps the layout nice on tablets / web / landscape
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: _isLoading
              ? const CircularProgressIndicator()
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: _SummaryBanner(count: waitlist.length),
                    ),
                    Expanded(
                      child: waitlist.isEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.event_seat_outlined,
                                  size: 72,
                                  color: theme.colorScheme.outline,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'No parties waiting',
                                  style: theme.textTheme.titleMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Tap “Add Party” to get started',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.outline,
                                  ),
                                ),
                              ],
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.fromLTRB(
                                16,
                                12,
                                16,
                                96,
                              ),
                              itemCount: waitlist.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 10),
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
                    ),
                  ],
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddPartyDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Party'),
      ),
    );
  }
}


class _SummaryBanner extends StatelessWidget {
  const _SummaryBanner({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [scheme.primary, scheme.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.groups_rounded, color: scheme.onPrimary, size: 32),
          const SizedBox(width: 12),
          Text(
            count == 1 ? '1 party waiting' : '$count parties waiting',
            style: TextStyle(
              color: scheme.onPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
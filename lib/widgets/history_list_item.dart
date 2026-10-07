import 'package:flutter/material.dart';

import '../models/removed_party.dart';

class HistoryListItem extends StatelessWidget {
  final RemovedParty removedParty;

  const HistoryListItem({
    super.key,
    required this.removedParty,
  });

  @override
  Widget build(BuildContext context) {
    final party = removedParty.party;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            '${party.ticketNumber}',
          ),
        ),
        title: Text(
          party.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${party.numberOfPeople} people\n'
          'Removed at ${_formatTime(removedParty.removedAt)}',
        ),
        isThreeLine: true,
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period';
  }
} 
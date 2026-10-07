import 'package:flutter/material.dart';

import '../models/party.dart';

class PartyListItem extends StatelessWidget {
  final Party party;
  final int partiesAhead;
  final VoidCallback onRemove;
  final VoidCallback onEdit;



  const PartyListItem({
    super.key,
    required this.party,
    required this.partiesAhead,
    required this.onRemove,
    required this.onEdit,


  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(
          party.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${party.numberOfPeople} people • '
          '$partiesAhead ${partiesAhead == 1 ? 'party' : 'parties'} ahead',
        ),
        leading: CircleAvatar(
          child: Text('# ${party.ticketNumber}'),
        ),
       trailing: Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    IconButton(
      onPressed: onEdit,
      icon: const Icon(Icons.edit_outlined),
      tooltip: 'Edit party',
    ),
    IconButton(
      onPressed: onRemove,
      icon: const Icon(Icons.delete_outline),
      tooltip: 'Remove party',
    ),
  ],
),
      ),
    );
  }
}

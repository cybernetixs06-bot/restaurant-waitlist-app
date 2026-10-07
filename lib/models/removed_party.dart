import 'party.dart';

class RemovedParty {
  final Party party;
  final DateTime removedAt;

  const RemovedParty({
    required this.party,
    required this.removedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'party': party.toJson(),
      'removedAt': removedAt.toIso8601String(),
    };
  }

  factory RemovedParty.fromJson(Map<String, dynamic> json) {
    return RemovedParty(
      party: Party.fromJson(
        Map<String, dynamic>.from(json['party']),
      ),
      removedAt: DateTime.parse(json['removedAt']),
    );
  }
}
  
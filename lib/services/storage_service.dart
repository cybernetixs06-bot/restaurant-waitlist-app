import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/party.dart';
import '../models/removed_party.dart';

class StorageService {
  static const String _waitlistKey = 'waitlist';
  static const String _lastTicketNumberKey = 'last_ticket_number';
  static const String _historyKey = 'waitlist_history';

  Future<void> saveWaitlist(List<Party> waitlist) async {
    final preferences = await SharedPreferences.getInstance();

    final data = waitlist
        .map((party) => party.toJson())
        .toList();

    await preferences.setString(
      _waitlistKey,
      jsonEncode(data),
    );
  }

  Future<List<Party>> loadWaitlist() async {
    final preferences = await SharedPreferences.getInstance();

    final data = preferences.getString(_waitlistKey);

    if (data == null) {
      return [];
    }

    final List<dynamic> decodedData = jsonDecode(data);

    return decodedData
        .map(
          (item) => Party.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }

  Future<void> saveLastTicketNumber(int ticketNumber) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setInt(
      _lastTicketNumberKey,
      ticketNumber,
    );
  }

  Future<int> loadLastTicketNumber() async {
    final preferences = await SharedPreferences.getInstance();

    return preferences.getInt(_lastTicketNumberKey) ?? 0;
  }

  Future<void> saveHistory(List<RemovedParty> history) async {
    final preferences = await SharedPreferences.getInstance();

    final data = history
        .map((removedParty) => removedParty.toJson())
        .toList();

    await preferences.setString(
      _historyKey,
      jsonEncode(data),
    );
  }

  Future<List<RemovedParty>> loadHistory() async {
    final preferences = await SharedPreferences.getInstance();

    final data = preferences.getString(_historyKey);

    if (data == null) {
      return [];
    }

    final List<dynamic> decodedData = jsonDecode(data);

    return decodedData
        .map(
          (item) => RemovedParty.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }
}
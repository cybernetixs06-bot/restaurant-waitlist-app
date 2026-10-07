import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/party.dart';

class StorageService {
  static const String _waitlistKey = 'waitlist';
  static const String _lastTicketNumberKey = 'lastTicketNumber';

  Future<void> saveWaitlist(List<Party> waitlist) async {
    final prefs = await SharedPreferences.getInstance();

    final data = waitlist
        .map((party) => jsonEncode(party.toJson()))
        .toList();

    await prefs.setStringList(_waitlistKey, data);
  }

  Future<List<Party>> loadWaitlist() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getStringList(_waitlistKey);

    if (data == null) {
      return [];
    }

    return data
        .map((item) => Party.fromJson(jsonDecode(item)))
        .toList();
  }

  Future<void> saveLastTicketNumber(int ticketNumber) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(_lastTicketNumberKey, ticketNumber);
  }

  Future<int> loadLastTicketNumber() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getInt(_lastTicketNumberKey) ?? 0;
  }
}

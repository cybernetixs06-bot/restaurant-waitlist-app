import '../models/party.dart';
import '../models/removed_party.dart';
import 'storage_service.dart';

class WaitlistService {
  final StorageService _storageService;

  List<Party> waitlist = [];
  List<RemovedParty> history = [];

  int lastTicketNumber = 0;

  Party? lastRemovedParty;
  int? lastRemovedIndex;

  WaitlistService({
    StorageService? storageService,
  }) : _storageService = storageService ?? StorageService();

  Future<void> loadData() async {
    waitlist = await _storageService.loadWaitlist();
    history = await _storageService.loadHistory();
    lastTicketNumber =
        await _storageService.loadLastTicketNumber();
  }

  Future<void> addParty({
    required String name,
    required int numberOfPeople,
  }) async {
    final trimmedName = name.trim();

    if (trimmedName.isEmpty || numberOfPeople <= 0) {
      return;
    }

    lastTicketNumber++;

    final party = Party(
      name: trimmedName,
      numberOfPeople: numberOfPeople,
      ticketNumber: lastTicketNumber,
    );

    waitlist.add(party);

    await _storageService.saveWaitlist(waitlist);
    await _storageService.saveLastTicketNumber(lastTicketNumber);
  }

  Future<bool> removeParty(int ticketNumber) async {
    final index = waitlist.indexWhere(
      (party) => party.ticketNumber == ticketNumber,
    );

    if (index == -1) {
      return false;
    }

    lastRemovedParty = waitlist[index];
    lastRemovedIndex = index;

    final removedParty = waitlist.removeAt(index);

    history.add(
      RemovedParty(
        party: removedParty,
        removedAt: DateTime.now(),
      ),
    );

    await _storageService.saveWaitlist(waitlist);
    await _storageService.saveHistory(history);

    return true;
  }

  Future<bool> undoLastRemoval() async {
    if (lastRemovedParty == null || lastRemovedIndex == null) {
      return false;
    }

    final party = lastRemovedParty!;
    final index = lastRemovedIndex!.clamp(0, waitlist.length);

    waitlist.insert(index, party);

    history.removeWhere(
      (removedParty) =>
          removedParty.party.ticketNumber == party.ticketNumber,
    );

    await _storageService.saveWaitlist(waitlist);
    await _storageService.saveHistory(history);

    lastRemovedParty = null;
    lastRemovedIndex = null;

    return true;
  }

  Future<bool> updateParty({
    required int ticketNumber,
    required String name,
    required int numberOfPeople,
  }) async {
    final trimmedName = name.trim();

    if (trimmedName.isEmpty || numberOfPeople <= 0) {
      return false;
    }

    final index = waitlist.indexWhere(
      (party) => party.ticketNumber == ticketNumber,
    );

    if (index == -1) {
      return false;
    }

    waitlist[index] = Party(
      name: trimmedName,
      numberOfPeople: numberOfPeople,
      ticketNumber: ticketNumber,
    );

    await _storageService.saveWaitlist(waitlist);

    return true;
  }
}
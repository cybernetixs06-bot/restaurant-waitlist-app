class Party {
  final String name;
  final int numberOfPeople;
  final int ticketNumber;

  const Party({
    required this.name,
    required this.numberOfPeople,
    required this.ticketNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'numberOfPeople': numberOfPeople,
      'ticketNumber': ticketNumber,
    };
  }

  factory Party.fromJson(Map<String, dynamic> json) {
    return Party(
      name: json['name'] as String,
      numberOfPeople: json['numberOfPeople'] as int,
      ticketNumber: json['ticketNumber'] as int,
    );
  }
}

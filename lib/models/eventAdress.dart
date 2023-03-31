class EventAdress {
  final String name;
  final String description;
  final DateTime date;
  final String namePlace;
  final Address address;

  EventAdress({
    required this.name,
    required this.description,
    required this.date,
    required this.namePlace,
    required this.address,
  });
}

class Address {
  final String street;
  final String city;

  Address({required this.street, required this.city});
}

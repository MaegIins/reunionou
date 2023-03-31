class event {
  String? id;
  String? name;
  String? description;
  DateTime? date;
  String time;
  String? nameOrga;
  String? mailOrga;
  String? address;
  String city = '';
  String street = '';
  double? lat;
  double? lon;

  event({
    this.id,
    this.name,
    this.description,
    this.date,
    this.time = '',
    this.nameOrga,
    this.mailOrga,
    this.address,
    this.city = '',
    this.lat,
    this.lon,
  });
}

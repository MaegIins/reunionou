class attendee {
  final int id;
  final String nameUser;
  final String? mailUser;
  final int status;
  final String? details;

  attendee({
    required this.id,
    required this.nameUser,
    this.mailUser,
    this.status = 0,
    this.details,
  });
}

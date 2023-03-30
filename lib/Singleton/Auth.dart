class Auth {
  String _token = "";

  static final Auth _singleton = Auth._internal();

  factory Auth() {
    return _singleton;
  }

  Auth._internal();

  String get token => _token;

  set token(String value) {
    _token = value;
  }
}
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

  bool get isAuthenticated {
    // Check if the token is not empty or null to determine if the user is authenticated.
    return _token.isNotEmpty && _token != null;
  }
}

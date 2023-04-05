
/**
 * This is a singleton class that will be used to store the user's authentication token.
 */
class Auth {
  String _token = "";
  String _email = "";

  static final Auth _singleton = Auth._internal();

  factory Auth() {
    return _singleton;
  }

  Auth._internal();

  String get token => _token;

  set token(String value) {
    _token = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  bool get isAuthenticated {
    // Check if the token is not empty or null to determine if the user is authenticated.
    return _token.isNotEmpty && _token != null;
  }

  Future<String> getToken() async {
    // Implement your logic for getting the token here, and return the token as a string.
    // For example, you might make an API call to authenticate the user and get a token.
    // This is just a placeholder implementation.
    _token = "my_token";
    _email = "example@example.com";
    return _token;
  }
}


import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/auth.dart';

class AuthProvider {
  Future<AuthCheck> getAuth(String bearerToken) async {
    final url = Uri.parse('http://docketu.iutnc.univ-lorraine.fr:20005/auth/validate');
    final response = await http.get(
      url,
      headers: {'Authorization': bearerToken },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch data from API');
    }

    final jsonData = jsonDecode(response.body);
    return AuthCheck(
      userId: jsonData['userId'],
      email: jsonData['email'],
      name: jsonData['name'],
    );
  }
}
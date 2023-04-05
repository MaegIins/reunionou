import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Singleton/Auth.dart';

// Endpoint du serveur Node.js pour générer les tokens
const String tokenEndpoint =
    "http://docketu.iutnc.univ-lorraine.fr:20005/auth/signin";

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Les clés de formulaire pour récupérer les informations d'identification de l'utilisateur
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // La fonction de connexion qui envoie les informations d'identification au serveur Node.js pour vérification
  Future<void> _login() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    // Envoie des informations d'identification au serveur Node.js pour vérification
    final http.Response response = await http.post(
      Uri.parse(tokenEndpoint),
      headers: {
        "Authorization":
            'Basic ${base64.encode(utf8.encode('$username:$password'))}',
      },
    );

    // Si les informations d'identification sont valides, stockez le token d'authentification localement
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Connexion réussie !"),
          backgroundColor: Colors.green,
        ),
      );
      setState(() {
        Auth().token = data["access_token"];
        Auth().email = username;
      });
    } else {
      // Si les informations d'identification ne sont pas valides, afficher un message d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Nom d'utilisateur ou mot de passe incorrect."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _logout() {
    setState(() {
      Auth().token = "";
      Auth().email = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Auth().token != ""
          ? AppBar(
              title: const Text("Bienvenue"),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    _logout();
                  },
                ),
              ],
            )
          : AppBar(
              title: const Text("Page de connexion"),
            ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Page de connexion",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28.0,
                ),
              ),
              const SizedBox(height: 32.0),
              Auth().token != ""
                  ? Expanded(
                      child: Center(
                        child: const Text(
                          "Vous êtes connecté",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28.0,
                          ),
                        ),
                      ),
                    )
                  : Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _usernameController,
                            decoration: const InputDecoration(
                              labelText: "Nom d'utilisateur",
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return "Veuillez entrer un nom d'utilisateur";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: "Mot de passe",
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return "Veuillez entrer un mot de passe";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 32.0),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _login();
                                }
                              },
                              child: const Text("Se connecter"),
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

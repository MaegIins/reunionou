import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Endpoint du serveur Node.js pour générer les tokens
const String tokenEndpoint = "http://localhost:3333/auth/signin";

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Les clés de formulaire pour récupérer les informations d'identification de l'utilisateur
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Le token d'authentification généré par le serveur Node.js
  late String _token = "";

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
      setState(() {
        _token = data["access_token"];
      });
    } else {
      // Si les informations d'identification ne sont pas valides, afficher un message d'erreur
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Erreur de connexion"),
            content: Text("Nom d'utilisateur ou mot de passe incorrect."),
            actions: <Widget>[
              ElevatedButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  // La fonction de déconnexion qui supprime le token d'authentification stocké localement
  void _logout() {
    setState(() {
      _token = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    // Si l'utilisateur est déjà connecté, afficher une page de bienvenue
    if (_token != "") {
      return Scaffold(
        appBar: AppBar(
          title: Text("Bienvenue"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                _logout();
              },
            ),
          ],
        ),
        body: Center(
          child: Text("Vous êtes connecté !"),
        ),
      );
    } else {
      // Si l'utilisateur n'est pas encore connecté, afficher la page de connexion
      return Scaffold(
        appBar: AppBar(
          title: Text("Page de connexion"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(labelText: "Nom d'utilisateur"),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return "Veuillez entrer un message";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: "Mot de passe"),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return "Veuillez entrer un mot de passe";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _login();
                      }
                    },
                    child: Text("Se connecter"),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}

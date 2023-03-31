import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:partouille/models/event.dart';
import 'package:http/http.dart' as http;

import '../Singleton/Auth.dart';

class EventForm extends StatefulWidget {
  const EventForm({Key? key}) : super(key: key);

  @override
  _EventFormState createState() => _EventFormState();
}

final String apiUrl = 'http://localhost:3333/events';

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();
  final _event = event();
  late DateTime _selectedDate;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final bearerToken = "Bearer " + Auth().token;
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un événement'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Nom'),
                  onSaved: (value) => _event.name = value!,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer un nom';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  onSaved: (value) => _event.description = value!,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer une description';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Adresse Complète'),
                  onSaved: (value) => _event.address = value!,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer une adresse';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Ville'),
                  onSaved: (value) => _event.city = value!,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer une adresse';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Rue'),
                  onSaved: (value) => _event.street = value!,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer une adresse';
                    }
                    return null;
                  },
                ),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Date',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      controller: TextEditingController(
                          text: DateFormat('dd/mm/yyyy').format(_selectedDate)),
                      onSaved: (value) =>
                          _event.date = DateFormat('yyyy/mm/dd').parse(value!),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Veuillez entrer une date';
                        }
                        try {
                          DateFormat('yyyy/mm/dd').parse(value);
                        } catch (e) {
                          return 'Veuillez entrer une date valide';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Heure'),
                  onSaved: (value) => _event.time = value!,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer une heure';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration:
                      InputDecoration(labelText: 'Nom de l\'organisateur'),
                  onSaved: (value) => _event.nameOrga = value!,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer un nom d\'organisateur';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Adresse email de l\'organisateur'),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (value) => _event.mailOrga = value!,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer une adresse email';
                    }
                    if (!value.contains('@')) {
                      return 'Veuillez entrer une adresse email valide';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      final headers = <String, String>{
                        'Authorization': bearerToken,
                      };
                      final body = <String, dynamic>{
                        'title': _event.name,
                        'description': _event.description,
                        'date': {
                          'date': _event.date?.toIso8601String(),
                          'time': _event.time,
                        },
                        "name_place": _event.address,
                        'address': {
                          'street': _event.street,
                          'city': _event.city,
                        },
                        'nameOrga': _event.nameOrga,
                        'mailOrga': _event.mailOrga,
                      };
                      final response = await http.post(Uri.parse(apiUrl),
                          headers: headers, body: body);

                      if (response.statusCode == 200) {
                        // La requête a réussi, afficher un message de confirmation
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("La requête a réussi"),
                          duration: Duration(seconds: 2),
                        ));
                      } else {
                        // La requête a échoué, afficher une erreur
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("La requête a échoué"),
                        ));
                      }

                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Enregistrer'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

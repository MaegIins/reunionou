import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:partouille/models/event.dart';

class EventForm extends StatefulWidget {
  const EventForm({Key? key}) : super(key: key);

  @override
  _EventFormState createState() => _EventFormState();
}

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
               GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Date',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    controller: TextEditingController(
                        text: DateFormat('dd/MM/yyyy').format(_selectedDate)),
                    onSaved: (value) =>
                        _event.date = DateFormat('dd/MM/yyyy').parse(value!),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Veuillez entrer une date';
                      }
                      try {
                        DateFormat('dd/MM/yyyy').parse(value);
                      } catch (e) {
                        return 'Veuillez entrer une date valide';
                      }
                      return null;
                    },
                  ),
                ),
              ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Nom de l\'organisateur'),
                  onSaved: (value) => _event.nameOrga = value!,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer un nom d\'organisateur';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Adresse email de l\'organisateur'),
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
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // TODO: sauvegarder l'événement dans la base de données
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

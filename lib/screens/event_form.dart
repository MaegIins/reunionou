import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:partouille/models/eventAdress.dart';
import '../providers/events_provider.dart';
import 'package:flutter/cupertino.dart';

import 'package:partouille/Singleton/Auth.dart';

class EventForm extends StatefulWidget {
  const EventForm({Key? key}) : super(key: key);

  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _dateController;
  late TextEditingController _namePlaceController;
  late TextEditingController _streetController;
  late TextEditingController _cityController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
   _dateController = TextEditingController(
    text: DateFormat('yyyy-MM-ddTHH:mm').format(DateTime.now()),
);
    _namePlaceController = TextEditingController();
    _streetController = TextEditingController();
    _cityController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _namePlaceController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final bearerToken = "Bearer " + Auth().token;
      
      final eventAdress = EventAdress(
        name: _nameController.text,
        description: _descriptionController.text,
        date: DateTime.parse(_dateController.text),
        namePlace: _namePlaceController.text,
        address: Address(
          street: _streetController.text,
          city: _cityController.text,
        ),
      );
      try {
        print(eventAdress.name);
        print(bearerToken);
        await EventsProvider().addEvent(bearerToken, eventAdress);
        Navigator.of(context).pop();
      } catch (error) {
        print(error);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add event'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty){
return 'Please enter a description';
}
return null;
},
),
GestureDetector(
  onTap: () async {
    final initialDate = DateTime.parse(_dateController.text);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );
      if (pickedTime != null) {
        final newDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        _dateController.text = DateFormat('yyyy-MM-ddTHH:mm').format(newDateTime);
      }
    }
  },
  child: AbsorbPointer(
    child: TextFormField(
      controller: _dateController,
      decoration: InputDecoration(
        labelText: 'Date',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a date';
        }
        return null;
      },
    ),
  ),
),
TextFormField(
controller: _namePlaceController,
decoration: InputDecoration(
labelText: 'Place name',
),
validator: (value) {
if (value == null || value.isEmpty) {
return 'Please enter a place name';
}
return null;
},
),
TextFormField(
controller: _streetController,
decoration: InputDecoration(
labelText: 'Street address',
),
validator: (value) {
if (value == null || value.isEmpty) {
return 'Please enter a street address';
}
return null;
},
),
TextFormField(
controller: _cityController,
decoration: InputDecoration(
labelText: 'City',
),
validator: (value) {
if (value == null || value.isEmpty) {
return 'Please enter a city';
}
return null;
},
),
SizedBox(height: 16.0),
ElevatedButton(
onPressed: _submitForm,
child: Text('Add Event'),
),
],
),
),
),
),
);
}
}
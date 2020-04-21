import 'package:flutter/material.dart';

import 'model.dart';

class NewEventPage extends StatefulWidget {
  NewEventPage({Key key, this.name: '', this.description: '', this.date: null}) : super(key: key);

  final String name;
  final String description;
  final DateTime date;

  @override
  _NewEventPageState createState() => _NewEventPageState(date);
}

class _NewEventPageState extends State<NewEventPage> {
  final _formKey = GlobalKey<FormState>();
  final focusDescription = FocusNode();
  final focusDate = FocusNode();
  final TextEditingController dateCtl = TextEditingController();
  final Map<String, dynamic> formData = {'name': null, 'description': null, 'date': null};

  _NewEventPageState(DateTime initialDate) {
    dateCtl.text = (initialDate != null) ? initialDate.toString().substring(0, 10) : '';
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditMode = !widget.name.isEmpty;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          tooltip: 'Zurück',
          onPressed: () {
            Navigator.pop(context);
          }
        ),
        title: Text(isEditMode ? 'Event ändern' : 'Neues Event'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                initialValue: widget.name,
                decoration: const InputDecoration(
                  hintText: 'Name',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Bitte einen Namen eingeben!';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (v) {
                  FocusScope.of(context).requestFocus(focusDescription);
                },
                onSaved: (String value) {
                  formData['name'] = value;
                },
              ),
              TextFormField(
                initialValue: widget.description,
                decoration: const InputDecoration(
                  hintText: 'Beschreibung (optional)',
                ),
                focusNode: focusDescription,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (v) {
                  FocusScope.of(context).requestFocus(focusDate);
                },
                onSaved: (String value) {
                  formData['description'] = value;
                },
              ),
              TextFormField(
                controller: dateCtl,
                decoration: const InputDecoration(
                  hintText: 'Datum (optional)',
                ),
                validator: (value) {
                  if (value.isNotEmpty && DateTime.tryParse(value) == null) {
                    return 'Bitte ein gültiges Datum auswählen!';
                  }
                  return null;
                },
                focusNode: focusDate,
                onTap: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());

                  DateTime selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2018),
                    lastDate: DateTime(2030),
                  );

                  dateCtl.text = (selectedDate != null) ? selectedDate.toString().substring(0, 10) : '';
                },
                onFieldSubmitted: (v) {
                  _submitForm();
                },
                onSaved: (String value) {
                  formData['date'] = value;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  onPressed: () {
                    _submitForm();
                  },
                  child: Text(isEditMode ? 'Speichern' : 'Hinzufügen'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Navigator.pop(context, Event(name: formData['name'], description: formData['description'], date: DateTime.tryParse(formData['date'])));
    }
  }
}

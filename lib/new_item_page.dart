import 'package:flutter/material.dart';

import 'model.dart';

class NewItemPage extends StatefulWidget {
  NewItemPage({Key key, this.name: '', this.notes: '', this.person: ''}) : super(key: key);

  final String name;
  final String notes;
  final String person;

  @override
  _NewItemPageState createState() => _NewItemPageState();
}

class _NewItemPageState extends State<NewItemPage> {
  final _formKey = GlobalKey<FormState>();
  final focusNotes = FocusNode();
  final focusPerson = FocusNode();
  final Map<String, dynamic> formData = {'name': null, 'notes': null, 'person': null};

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
        title: Text(isEditMode ? 'Eintrag ändern' : 'Neuer Eintrag'),
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
                  FocusScope.of(context).requestFocus(focusNotes);
                },
                onSaved: (String value) {
                  formData['name'] = value;
                },
              ),
              TextFormField(
                initialValue: widget.notes,
                decoration: const InputDecoration(
                  hintText: 'Zusätzliche Notizen (optional)',
                ),
                focusNode: focusNotes,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (v) {
                  FocusScope.of(context).requestFocus(focusPerson);
                },
                onSaved: (String value) {
                  formData['notes'] = value;
                },
              ),
              TextFormField(
                initialValue: widget.person,
                decoration: const InputDecoration(
                  hintText: 'Zugeteilte Person (optional)',
                ),
                focusNode: focusPerson,
                onFieldSubmitted: (v) {
                  _submitForm();
                },
                onSaved: (String value) {
                  formData['person'] = value;
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
      Navigator.pop(context, Item(formData['name'], formData['notes'], formData['person']));
    }
  }
}

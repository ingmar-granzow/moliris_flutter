import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:moliris_flutter/models/event.dart';
import 'package:moliris_flutter/models/item.dart';
import 'package:moliris_flutter/providers/events_model.dart';

class AddItemScreen extends StatefulWidget {
  final Event event;
  final Item item;

  AddItemScreen({@required this.event, this.item = null});

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final focusNotes = FocusNode();
  final focusPerson = FocusNode();

  final Map<String, dynamic> formData = {
    'name': null,
    'notes': null,
    'person': null,
  };

  bool _isEditMode = false;

  @override
  void initState() {
    _isEditMode = widget.item != null;
    super.initState();
  }

  void _submitForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      if (_isEditMode) {
        widget.item.name = formData['name'];
        widget.item.notes = formData['notes'];
        widget.item.person = formData['person'];
      } else {
        final Item newItem = Item(name: formData['name'], notes: formData['notes'], person: formData['person']);
        Provider.of<EventsModel>(context, listen: false).addItem(widget.event, newItem);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          tooltip: 'Zurück',
          onPressed: () {
            Navigator.pop(context);
          }
        ),
        title: Text(_isEditMode ? 'Eintrag ändern' : 'Neuer Eintrag'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                initialValue: widget.item?.name,
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
                initialValue: widget.item?.notes,
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
                initialValue: widget.item?.person,
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
                  child: Text(_isEditMode ? 'Speichern' : 'Hinzufügen'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

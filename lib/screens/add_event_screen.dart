import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:moliris_flutter/models/event.dart';
import 'package:moliris_flutter/providers/events_model.dart';

class AddEventScreen extends StatefulWidget {
  final Event event;

  AddEventScreen({this.event: null});

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _focusDescription = FocusNode();
  final _focusDate = FocusNode();
  final _dateCtl = TextEditingController();

  final Map<String, dynamic> formData = {
    'name': null,
    'description': null,
    'date': null
  };

  bool _isEditMode = false;

  @override
  void initState() {
    _isEditMode = widget.event != null;
    _dateCtl.text = widget.event?.date?.toString()?.substring(0, 10) ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _dateCtl.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      if (_isEditMode) {
        widget.event.name = formData['name'];
        widget.event.description = formData['description'];
        widget.event.date = DateTime.tryParse(formData['date']);
      } else {
        final Event newEvent = Event(name: formData['name'], description: formData['description'], date: DateTime.tryParse(formData['date']));
        Provider.of<EventsModel>(context, listen: false).addEvent(newEvent);
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
        title: Text(_isEditMode ? 'Event ändern' : 'Neues Event'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                initialValue: widget.event?.name,
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
                  FocusScope.of(context).requestFocus(_focusDescription);
                },
                onSaved: (String value) {
                  formData['name'] = value;
                },
              ),
              TextFormField(
                initialValue: widget.event?.description,
                decoration: const InputDecoration(
                  hintText: 'Beschreibung (optional)',
                ),
                focusNode: _focusDescription,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (v) {
                  FocusScope.of(context).requestFocus(_focusDate);
                },
                onSaved: (String value) {
                  formData['description'] = value;
                },
              ),
              TextFormField(
                controller: _dateCtl,
                decoration: const InputDecoration(
                  hintText: 'Datum (optional)',
                ),
                validator: (value) {
                  if (value.isNotEmpty && DateTime.tryParse(value) == null) {
                    return 'Bitte ein gültiges Datum auswählen!';
                  }
                  return null;
                },
                focusNode: _focusDate,
                onTap: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());

                  DateTime selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2018),
                    lastDate: DateTime(2030),
                  );

                  _dateCtl.text = (selectedDate != null) ? selectedDate.toString().substring(0, 10) : '';
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

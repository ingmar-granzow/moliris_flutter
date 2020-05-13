import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:moliris_flutter/providers/preferences_model.dart';

class PreferencesScreen extends StatefulWidget {
  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> formData = {
    'user_name': null,
  };

  void _submitForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      Provider.of<PreferencesModel>(context, listen: false).update(formData['user_name']);

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
        title: Text('Einstellungen'),
      ),
      body: _createForm(),
    );
  }

  Widget _createForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _createUserNameField(),
            _createSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _createUserNameField() {
    return TextFormField(
      initialValue: Provider.of<PreferencesModel>(context, listen: false).user_name,
      decoration: const InputDecoration(
        hintText: 'Anzeigename',
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Bitte einen Namen eingeben!';
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      // onFieldSubmitted: (v) {
      //   FocusScope.of(context).requestFocus(_focusDescription);
      // },
      onSaved: (String value) {
        formData['user_name'] = value;
      },
    );
  }

  Widget _createSubmitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        onPressed: () {
          _submitForm();
        },
        child: Text('Speichern'),
      ),
    );
  }
}

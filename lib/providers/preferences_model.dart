import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:couchbase_lite/couchbase_lite.dart';

class PreferencesModel {
  Database database;
  Query _query;
  String _document_id;
  String _user_name;

  PreferencesModel() {
    _initDatabase();
  }

  String get user_name => _user_name;

  void _initDatabase() async {
    try {
      database = await Database.initWithName('events');
    } on PlatformException {
      print('Error initializing database');
    }

    _query = QueryBuilder
      .select([
        SelectResult.expression(Meta.id),
        SelectResult.property('user_name'),
      ])
      .from('events')
      .where(Expression.property('type').equalTo(Expression.string('preferences')));

    _fetchAndStorePreferences();
  }

  void _fetchAndStorePreferences() async {
    ResultSet preferences = await _query.execute();

    if (preferences.isNotEmpty) {
      _document_id = preferences.first.getString(key: 'id');
      _user_name = preferences.first.getString(key: 'user_name');
    } else {
      _initPreferences();
    }
  }

  void _initPreferences() async {
    var mutableDoc = MutableDocument()
      .setString('type', 'preferences')
      .setString('user_name', '');

    try {
      await database.saveDocument(mutableDoc);
    } on PlatformException {
      print('Error saving document');
    }

    _fetchAndStorePreferences();
  }

  void update(String user_name) async {
    var mutableDoc = (await database.document(_document_id))?.toMutable();

    if (mutableDoc != null) {
      mutableDoc.setString('user_name', user_name);

      try {
        await database.saveDocument(mutableDoc);
      } on PlatformException {
        print('Error saving document');
      }
    }

    _user_name = user_name;
  }
}

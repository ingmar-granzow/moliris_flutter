import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:couchbase_lite/couchbase_lite.dart';

import 'package:moliris_flutter/models/event.dart';
import 'package:moliris_flutter/models/item.dart';

class EventsModel extends ChangeNotifier {
  Database database;
  List<Event> _events = [];

  EventsModel() {
    _initPlatformState();
  }

  void _initPlatformState() async {
    try {
      database = await Database.initWithName('events');
    } on PlatformException {
      print('Error initializing database');
    }

    var query = QueryBuilder
      .select([
        SelectResult.expression(Meta.id),
        SelectResult.property('name'),
        SelectResult.property('description'),
        SelectResult.property('date'),
        SelectResult.property('items'),
      ])
      .from('events')
      .where(Expression.property('type').equalTo(Expression.string('event')));

    var token = query.addChangeListener(_changeListener);

    try {
      query.execute();
    } on PlatformException {
      print('Error running the query');
    }
  }

  void _changeListener(change) {
    print('change listener called with ${change.results.allResults().length} results');

    _events = change.results.map((result) => Event(
      id: result.getString(key: 'id'),
      name: result.getString(key: 'name'),
      description: result.getString(key: 'description'),
      date: DateTime.tryParse(result.getString(key: 'date') ?? ''),
      items: result.getList(key: 'items').map((e) => Item.fromMap(e)).toList().cast<Item>(),
    )).toList().cast<Event>();

    notifyListeners();
  }

  UnmodifiableListView<Event> get allEvents => UnmodifiableListView(_events);

  void addEvent(Event event) async {
    var mutableDoc = MutableDocument()
      .setString('type', 'event')
      .setString('name', event.name)
      .setString('description', event?.description)
      .setString('date', event.date?.toIso8601String())
      .setList('items', event.items);

    try {
      await database.saveDocument(mutableDoc);
    } on PlatformException {
      print('Error saving document');
    }
  }

  void updateEvent(Event event) async {
    var mutableDoc = (await database.document(event.id))?.toMutable();

    if (mutableDoc != null) {
      mutableDoc
        .setString('name', event.name)
        .setString('description', event.description)
        .setString('date', event.date?.toIso8601String());

      try {
        await database.saveDocument(mutableDoc);
      } on PlatformException {
        print('Error saving document');
      }
    }
  }

  void deleteEvent(Event event) {
    database.deleteDocument(event?.id);
  }

  UnmodifiableListView<Item> getAllItems(Event event) {
    var _event = _events.firstWhere((element) => element == event);
    return UnmodifiableListView(_event.items);
  }

  void addItem(Event event, Item item) async {
    var _event = _events.firstWhere((element) => element == event);
    _event.items.add(item);
    _persistItems(_event);
  }

  void updateItem(Event event, Item item) async {
    var _event = _events.firstWhere((element) => element == event);
    var index = _event.items.indexWhere((element) => element == item);

    if (index != -1) {
      _event.items[index] = item;
      _persistItems(_event);
    }
  }

  void deleteItem(Event event, Item item) {
    var _event = _events.firstWhere((element) => element == event);
    var index = _event.items.indexWhere((element) => element == item);

    if (index != -1) {
      _event.items.removeAt(index);
      _persistItems(_event);
    }
  }

  void _persistItems(Event event) async {
    var mutableDoc = (await database.document(event.id))?.toMutable();

    if (mutableDoc != null) {
      var itemList = event.items.map((item) => item.asMap()).toList();
      mutableDoc.setList('items', itemList);

      try {
        await database.saveDocument(mutableDoc);
      } on PlatformException {
        print('Error saving document');
      }
    }
  }
}

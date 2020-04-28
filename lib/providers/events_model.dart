import 'dart:collection';

import 'package:flutter/material.dart';

import 'package:moliris_flutter/models/event.dart';
import 'package:moliris_flutter/models/item.dart';

class EventsModel extends ChangeNotifier {
  final List<Event> _events = [];

  UnmodifiableListView<Event> get allEvents => UnmodifiableListView(_events);

  void addEvent(Event event) {
    _events.add(event);
    notifyListeners();
  }

  void deleteEvent(Event event) {
    _events.remove(event);
    notifyListeners();
  }

  UnmodifiableListView<Item> getAllItems(Event event) {
    return UnmodifiableListView(event?.items);
  } // necessary?

  void addItem(Event event, Item item) {
    event?.items.add(item);
    notifyListeners();
  }

  void deleteItem(Event event, Item item) {
    event?.items.remove(item);
    notifyListeners();
  }
}

import 'package:flutter/material.dart';

class Event {
  Event({this.name: 'Event', this.description: '', this.date: null});

  var id = UniqueKey();
  String name, description;
  DateTime date;

  List<Item> items = [];
}

class Item {
  Item(this.name, this.notes, this.person);

  var id = UniqueKey();
  String name, notes, person;
  DateTime date = DateTime.now();
}

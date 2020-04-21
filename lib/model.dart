import 'package:flutter/material.dart';

class Event {
  var id = UniqueKey();
  String name, description;
  DateTime date;

  List<Item> items = [];

  Event(this.name, this.description, this.date);
}

class Item {
  var id = UniqueKey();
  String name, notes, person;
  DateTime date = DateTime.now();

  Item(this.name, this.notes, this.person);
}

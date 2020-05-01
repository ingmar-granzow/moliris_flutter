import 'package:flutter/material.dart';

import 'package:moliris_flutter/models/item.dart';

class Event {
  String id;
  String name;
  String description;
  DateTime date;

  final List<Item> items;

  Event({this.id, @required this.name, this.description = '', this.date, this.items = const []});

  operator ==(Event e) => this.id == e.id;

  int get hashCode => id.hashCode;
}


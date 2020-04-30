import 'package:flutter/material.dart';

import 'package:moliris_flutter/models/item.dart';

class Event {
  String id;
  String name;
  String description;
  DateTime date;

  final List<Item> items = [];

  Event({this.id, @required this.name, this.description = '', this.date});
}


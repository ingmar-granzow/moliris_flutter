import 'package:flutter/material.dart';

import 'package:moliris_flutter/models/item.dart';

class Event {
  String name, description;
  DateTime date;

  final List<Item> items = [];

  Event({@required this.name, this.description = '', this.date = null});
}


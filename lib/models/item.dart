import 'package:flutter/material.dart';

class Item {
  String name, notes, person;
  DateTime date = DateTime.now();

  Item({@required this.name, this.notes = '', this.person = ''});
}

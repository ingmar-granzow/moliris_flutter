import 'package:flutter/material.dart';

class Item {
  String name, notes, person;
  //DateTime date = DateTime.now();

  Item({@required this.name, this.notes = '', this.person = ''});

  Item.fromMap(Map map) {
  	this.name = map['name'];
  	this.notes = map['notes'];
  	this.person = map['person'];
  }

  Map<dynamic, dynamic> asMap() => {'name': name, 'notes': notes, 'person': person};
}

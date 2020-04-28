import 'package:flutter/material.dart';

import 'package:moliris_flutter/models/event.dart';
import 'package:moliris_flutter/models/item.dart';
import 'package:moliris_flutter/widgets/item_entry.dart';

class ItemList extends StatelessWidget {
  final Event event;
  final List<Item> items;

  ItemList({@required this.event, @required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: getChildrenItems(),
    );
  }

  List<Widget> getChildrenItems() {
    return items.fold(List<Widget>(), (list, item) {
      list.add(ItemEntry(event: event, item: item));
      list.add(Divider());
      return list;
    });
  }
}

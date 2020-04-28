import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:moliris_flutter/models/event.dart';
import 'package:moliris_flutter/models/item.dart';
import 'package:moliris_flutter/providers/events_model.dart';
import 'package:moliris_flutter/new_item_page.dart';

enum ItemAction {
  assign,
  edit,
  delete
}

class ItemEntry extends StatelessWidget {
  final Event event;
  final Item item;

  ItemEntry({@required this.event, @required this.item});

  _handleItemAction(BuildContext context, ItemAction result) async {
    switch (result) {
      case ItemAction.assign:
        // TODO: assign
        break;
      case ItemAction.edit:
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewItemPage(event: event, item: item)),
        );
        break;
      case ItemAction.delete:
        Provider.of<EventsModel>(context, listen: false).deleteItem(event, item);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.name),
      subtitle: (item.notes.isEmpty)
          ? null
          : Text(item.notes),
      leading: CircleAvatar(
        backgroundColor: Colors.blue.shade800,
        child: Text('IR'),
        //radius: 20,
      ),
      trailing: PopupMenuButton<ItemAction>(
        onSelected: (action) {
          _handleItemAction(context, action);
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<ItemAction>>[
          const PopupMenuItem<ItemAction>(
            value: ItemAction.assign,
            child: ListTile(
              leading: Icon(Icons.assignment_ind),
              title: Text('Mitbringen')),
          ),
          const PopupMenuItem<ItemAction>(
            value: ItemAction.edit,
            child: ListTile(
              leading: Icon(Icons.edit),
              title: Text('Ändern'),
            ),
          ),
          const PopupMenuDivider(),
          const PopupMenuItem<ItemAction>(
            value: ItemAction.delete,
            child: ListTile(
              leading: Icon(Icons.delete),
              title: Text('Löschen'),
            ),
          ),
        ],
      )
    );
  }
}

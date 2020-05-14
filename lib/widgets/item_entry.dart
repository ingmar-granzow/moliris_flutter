import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:moliris_flutter/models/event.dart';
import 'package:moliris_flutter/models/item.dart';
import 'package:moliris_flutter/providers/events_model.dart';
import 'package:moliris_flutter/providers/preferences_model.dart';
import 'package:moliris_flutter/screens/add_item_screen.dart';

enum ItemAction {
  edit,
  delete
}

class ItemEntry extends StatelessWidget {
  final Event event;
  final Item item;

  Widget _subtitleWidget;

  ItemEntry({@required this.event, @required this.item}) {
    _subtitleWidget = (item.notes.isNotEmpty) ? Text(item.notes) : null;
  }

  _assignPerson(context) {
    item.person = Provider.of<PreferencesModel>(context, listen: false).user_name;
    Provider.of<EventsModel>(context, listen: false).updateItem(event, item);
  }

  _handleItemAction(BuildContext context, ItemAction result) async {
    switch (result) {
      case ItemAction.edit:
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddItemScreen(event: event, item: item)),
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
      subtitle: _subtitleWidget,
      leading: buildLeadingPart(context),
      trailing: PopupMenuButton<ItemAction>(
        onSelected: (action) {
          _handleItemAction(context, action);
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<ItemAction>>[
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

  Widget buildLeadingPart(context) {
    if (item.person.isNotEmpty) {
      // first letter (in uppercase) of first and last word is used as initials
      var initials = item.person.trim().splitMapJoin((RegExp(r'(^\S+|\S+$)')),
        onMatch: (m) => m.input[m.start].toUpperCase(),
        onNonMatch: (n) => ''
      );

      // show avatar with initials and unique color derived from person name
      var hash = item.person.hashCode;
      return CircleAvatar(
        backgroundColor: Color.fromRGBO(hash, hash >> 8, hash >> 16, 1.0),
        child: Text(initials),
        //radius: 20,
      );
    } else {
      // show assign icon for unassigned items
      return Container(
        constraints: BoxConstraints.expand(
          width: 40,
        ),
        child: Center(
          child: IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: () {
              _assignPerson(context);
            },
          ),
        ),
      );
    }
  }
}

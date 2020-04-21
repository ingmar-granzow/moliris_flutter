import 'package:flutter/material.dart';

import 'model.dart';
import 'item_entry.dart';
import 'new_item_page.dart';

class EventPage extends StatefulWidget {
  final Event event;

  EventPage({Key key, this.event: null}) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    List<Widget> renderItems = [];
    widget.event.items.forEach((item) {
      renderItems.add(ItemEntry(key: item.id, name: item.name, notes: item.notes, person: item.person, assignItemCallback: assignItem, editItemCallback: editItem, deleteItemCallback: deleteItem));
      renderItems.add(Divider());
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          tooltip: 'Zurück',
          onPressed: () {
            Navigator.pop(context);
          }
        ),
        title: Text(widget.event.name),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.sort),
            tooltip: 'Sortierung',
            onPressed: null,
          ),
        ],
      ),
      body: ListView(
        children: renderItems,
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Hinzufügen',
        child: Icon(Icons.add),
        onPressed: () {
          _navigateAndAddItem(context);
        },
      ),
    );
  }

  _navigateAndAddItem(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewItemPage()),
    );

    if (result != null) {
      setState(() {
        widget.event.items.add(result);
      });
    }
  }

  assignItem(Key id, String person) {
    setState(() {
      var item = widget.event.items.firstWhere((i) => i.id == id);
      item?.person = person;
    });
  }

  editItem(Key id) async {
    var item = widget.event.items.firstWhere((i) => i.id == id);

    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewItemPage(name: item.name, notes: item.notes, person: item.person)),
    );

    if (result != null) {
      setState(() {
        item.name = result.name;
        item.notes = result.notes;
        item.person = result.person;
      });
    }
  }

  deleteItem(Key id) {
    setState(() {
      widget.event.items.removeWhere((i) => i.id == id);
    });
  }
}

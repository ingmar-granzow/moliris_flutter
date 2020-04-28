import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:moliris_flutter/models/event.dart';
import 'package:moliris_flutter/providers/events_model.dart';
import 'package:moliris_flutter/widgets/item_list.dart';
import 'package:moliris_flutter/new_item_page.dart';

class EventPage extends StatelessWidget {
  final Event event;

  EventPage({@required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          tooltip: 'Zurück',
          onPressed: () {
            Navigator.pop(context);
          }
        ),
        title: Text(event.name),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.sort),
            tooltip: 'Sortierung',
            onPressed: null,
          ),
        ],
      ),
      body: Consumer<EventsModel>(
        builder: (context, events, child) => ItemList(
          event: event,
          items: events.getAllItems(event),
        ),
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
      MaterialPageRoute(builder: (context) => NewItemPage(event: event)),
    );
  }
}

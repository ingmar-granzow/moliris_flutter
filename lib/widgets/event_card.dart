import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:moliris_flutter/models/event.dart';
import 'package:moliris_flutter/providers/events_model.dart';
import 'package:moliris_flutter/screens/event_screen.dart';
import 'package:moliris_flutter/screens/add_event_screen.dart';

enum EventAction {
  edit,
  delete,
}

class EventCard extends StatelessWidget {
  final Event event;

  EventCard({@required this.event});

  _navigateAndShowEvent(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
          EventScreen(event: event)),
    );
  }

  _handleEventAction(BuildContext context, EventAction action) async {
    switch (action) {
      case EventAction.edit:
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddEventScreen(event: event),
          ),
        );
        break;
      case EventAction.delete:
        Provider.of<EventsModel>(context, listen: false).deleteEvent(event);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(event.name),
        subtitle:
          (event.description.isEmpty && event.date == null)
              ? null
              : Text(
                  "${event.date != null ? event.date.toString().substring(0, 11) : ''}${event.description}",
                ),
        onTap: () {
          _navigateAndShowEvent(context);
        },
        trailing: PopupMenuButton<EventAction>(
          onSelected: (action) {
            _handleEventAction(context, action);
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<EventAction>>[
            const PopupMenuItem<EventAction>(
              value: EventAction.edit,
              child: ListTile(
                leading: Icon(Icons.edit), title: Text('Ändern')),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem<EventAction>(
              value: EventAction.delete,
              child: ListTile(
                leading: Icon(Icons.delete), title: Text('Löschen')),
            ),
          ]
        ),
      ),
    );
  }
}

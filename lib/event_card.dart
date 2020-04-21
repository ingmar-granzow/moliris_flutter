import 'package:flutter/material.dart';

import 'model.dart';
import 'event_page.dart';

class EventCard extends StatefulWidget {
  EventCard({Key key, this.event: null, this.editEventCallback: null, this.deleteEventCallback: null}) : super(key: key);

  Event event;

  final editEventCallback;
  final deleteEventCallback;

  @override
  _EventCardState createState() => _EventCardState();
}

enum EventAction { edit, delete }

class _EventCardState extends State<EventCard> {
  _handleEventAction(EventAction result) {
    switch (result) {
        case EventAction.edit :
          widget.editEventCallback(widget.key);
          break;
        case EventAction.delete :
          widget.deleteEventCallback(widget.key);
          break;
      }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(widget.event.name),
        subtitle: (widget.event.description.isEmpty && widget.event.date == null) ? null : Text(
          "${widget.event.date != null ? widget.event.date.toString().substring(0, 11) : ''}${widget.event.description}",
        ),
        onTap: () {
          _navigateAndShowEvent(context);
        },
        trailing: PopupMenuButton<EventAction>(
          onSelected: _handleEventAction,
          itemBuilder: (BuildContext context) => <PopupMenuEntry<EventAction>>[
            const PopupMenuItem<EventAction>(
              value: EventAction.edit,
              child: ListTile(leading: Icon(Icons.edit), title: Text('Ändern')),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem<EventAction>(
              value: EventAction.delete,
              child: ListTile(leading: Icon(Icons.delete), title: Text('Löschen')),
            ),
          ]
        ),
      ),
    );
  }

  _navigateAndShowEvent(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EventPage(key: widget.event.id, event: widget.event)),
    );
  }
}

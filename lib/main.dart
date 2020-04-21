import 'package:flutter/material.dart';

import 'model.dart';
import 'event_card.dart';
import 'new_event_page.dart';

void main() {
  runApp(MaterialApp(
    title: 'Moliris Event Planner',
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Event> _events = [];

  _navigateAndAddEvent(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewEventPage()),
    );

    if (result != null) {
      setState(() {
        _events.add(result);
      });
    }
  }

  editEvent(Key id) async {
    var event = _events.firstWhere((i) => i.id == id);

    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewEventPage(name: event.name, description: event.description, date: event.date)),
    );

    if (result != null) {
      setState(() {
        event.name = result.name;
        event.description = result.description;
        event.date = result.date;
      });
    }
  }

  deleteEvent(Key id) {
    setState(() {
      _events.removeWhere((i) => i.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> renderEvents = [];
    _events.forEach((event) {
      renderEvents.add(EventCard(key: event.id, event: event, editEventCallback: editEvent, deleteEventCallback: deleteEvent));
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Moliris Event Planner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            tooltip: 'Einstellungen',
            onPressed: null,
          ),
        ],
      ),
      body: ListView(
        children: renderEvents,
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Hinzufügen',
        child: Icon(Icons.add),
        onPressed: () {
          _navigateAndAddEvent(context);
        },
      ),
    );
  }
}

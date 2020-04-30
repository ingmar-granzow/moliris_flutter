import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:moliris_flutter/providers/events_model.dart';
import 'package:moliris_flutter/screens/add_event_screen.dart';
import 'package:moliris_flutter/widgets/event_list.dart';

class HomeScreen extends StatelessWidget {
  _navigateAndAddEvent(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEventScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
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
      body: Consumer<EventsModel>(
        builder: (context, events, child) => EventList(
          events: events.allEvents,
        ),
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:moliris_flutter/models/event.dart';
import 'package:moliris_flutter/providers/events_model.dart';
import 'package:moliris_flutter/widgets/event_list.dart';
import 'package:moliris_flutter/widgets/event_card.dart';
import 'package:moliris_flutter/new_event_page.dart';

void main() => runApp(MolirisApp());

class MolirisApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EventsModel(),
      child: MaterialApp(
        title: 'Moliris Event Planner',
        home: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  _navigateAndAddEvent(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewEventPage()),
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

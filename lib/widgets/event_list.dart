import 'package:flutter/material.dart';

import 'package:moliris_flutter/models/event.dart';
import 'package:moliris_flutter/widgets/event_card.dart';

class EventList extends StatelessWidget {
  final List<Event> events;

  EventList({@required this.events});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: getChildrenEvents(),
    );
  }

  List<Widget> getChildrenEvents() {
    return events.map((element) => EventCard(event: element)).toList();
  }
}

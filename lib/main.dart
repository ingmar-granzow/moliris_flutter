import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:couchbase_lite/couchbase_lite.dart';

import 'package:moliris_flutter/providers/events_model.dart';
import 'package:moliris_flutter/screens/home_screen.dart';

void main() => runApp(MolirisApp());

class MolirisApp extends StatefulWidget {
  @override
  _MolirisAppState createState() => _MolirisAppState();
}

class _MolirisAppState extends State<MolirisApp> {
  Database database;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void initPlatformState() async {
    try {
      database = await Database.initWithName('events');
    } on PlatformException {
      print('Error initializing database');
    }
  }

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

  @override
  void dispose() async {
    // await replicator?.removeChangeListener(_listenerToken);
    // await replicator?.stop();
    // await replicator?.dispose();
    await database?.close();

    super.dispose();
  }
}

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
  Replicator replicator;
  ListenerToken _listenerToken;

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

    ReplicatorConfiguration config =
        ReplicatorConfiguration(database, "ws://10.0.2.2:4984/moliris");
    config.replicatorType = ReplicatorType.pushAndPull;
    config.continuous = true;

    //config.authenticator = BasicAuthenticator("foo", "bar");

    replicator = Replicator(config);

    _listenerToken = replicator.addChangeListener((ReplicatorChange event) {
      if (event.status.error != null) {
        print("Error: " + event.status.error);
      }

      print(event.status.activity.toString());
    });

    await replicator.start();
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
    await replicator?.removeChangeListener(_listenerToken);
    await replicator?.stop();
    await replicator?.dispose();
    await database?.close();

    super.dispose();
  }
}

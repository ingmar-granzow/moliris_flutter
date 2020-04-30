import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:moliris_flutter/providers/events_model.dart';
import 'package:moliris_flutter/screens/home_screen.dart';

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

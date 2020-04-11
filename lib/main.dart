import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Moliris Event Planner',
    home: TutorialHome(),
  ));
}

class ItemWidget extends StatefulWidget {
  @override
  _ItemWidgetState createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  String _name = 'name';
  String _notes = 'note';
  String _person;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(_name),
        subtitle: Text(
          _notes
        ),
        trailing: (_person != null ? Text(_person) : IconButton(
          icon: Icon(Icons.add),
          onPressed: _addPerson,
        )),
      ),
    );
  }

  void _addPerson() {
    setState(() {
      _person = 'Ingmar';
    });
  }
}

class TutorialHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Scaffold is a layout for the major Material Components.
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          tooltip: 'Navigation menu',
          onPressed: null,
        ),
        title: Text('Himmelfahrtskommando 2020'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            tooltip: 'Search',
            onPressed: null,
          ),
        ],
      ),
      // body is the majority of the screen.
      body: ListView(
        children: <Widget>[
          Card(
            child: ListTile(
              title: Text('Grill'),
              subtitle: Text(
                'Kleiner Holzkohlegrill'
              ),
              trailing: Text(
                'Ingmar'
              ),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Holzkohle'),
              subtitle: Text(
                '1 Sack'
              ),
              trailing: Icon(Icons.add),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Grillzange'),
              subtitle: Text(
                'Eine ganz tolle, feuerfeste Grillzange mit einer langen Beschreibung',
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Icon(Icons.add),
            ),
          ),
          ItemWidget(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add', // used by assistive technologies
        child: Icon(Icons.add),
        onPressed: null,
      ),
    );
  }
}

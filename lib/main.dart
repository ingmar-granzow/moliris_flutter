import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Moliris Event Planner',
    home: Event(),
  ));
}

class Event extends StatefulWidget {
  @override
  _EventState createState() => _EventState();
}

class _EventState extends State<Event> {
  String _name = 'Himmelfahrtskommando 2020';
  // description
  // identifier
  var _items = [
    {'name': 'Grill', 'notes': 'Kleiner Holzkohlegrill', 'person': null, 'date': DateTime.now()},
  ];

  void _handleAddItem() {
    setState(() {
      _items.add({'name': 'Holzkohle', 'notes': '1 Sack', 'person': null, 'date': DateTime.now()});
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> renderItems = [];
    _items.forEach((item) {
        renderItems.add(ItemWidget(name: item['name'], notes: item['notes']));
      });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          tooltip: 'Navigation menu',
          onPressed: null,
        ),
        title: Text(_name),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            tooltip: 'Search',
            onPressed: null,
          ),
        ],
      ),
      body: ListView(
        children: renderItems,
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add',
        child: Icon(Icons.add),
        onPressed: _handleAddItem,
      ),
    );
  }
}

class ItemWidget extends StatefulWidget {
  ItemWidget({Key key, this.name: '', this.notes: ''})
      : super(key: key);

  final String name;
  final String notes;

   _ItemWidgetState createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  String _person;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(widget.name),
        subtitle: Text(
          widget.notes,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: (_person != null ? Text(_person) : IconButton(
          icon: Icon(Icons.edit),
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

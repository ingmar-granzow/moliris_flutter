import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Moliris Event Planner',
    home: Event(),
  ));
}

class Item {
  String name, notes, person;
  DateTime date = DateTime.now();

  Item(this.name, this.notes, this.person);
}

class Event extends StatefulWidget {
  @override
  _EventState createState() => _EventState();
}

class _EventState extends State<Event> {
  String _name = 'Himmelfahrtskommando 2020';
  // description
  // identifier
  // _items = List(Item('Grill', 'Kleiner Holzkohlegrill', 'Ingmar'));
  //var _items = List();
  List<Item> _items = [];

  @override
  Widget build(BuildContext context) {
    List<Widget> renderItems = [];
    _items.forEach((item) {
      renderItems.add(ItemWidget(name: item.name, notes: item.notes));
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          tooltip: 'Back',
          onPressed: null,
        ),
        title: Text(_name),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.sort),
            tooltip: 'Sort',
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
        onPressed: () {
          _navigateAndAddItem(context);
      },
      ),
    );
  }

  _navigateAndAddItem(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddItem()),
    );

    if (result != null) {
      setState(() {
        _items.add(result);
      });
    }
  }
}

class ItemWidget extends StatefulWidget {
  ItemWidget({Key key, this.name: '', this.notes: ''}) : super(key: key);

  final String name;
  final String notes;

  @override
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
        trailing: IconButton(
          icon: Icon(Icons.edit),
          onPressed: null,
        ), // or better PopupMenuButton?
      ),
    );
  }
}

class AddItem extends StatefulWidget {
  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final notesController = TextEditingController();
  final personController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    notesController.dispose();
    personController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          tooltip: 'Zurück',
          onPressed: () {
            Navigator.pop(context);
          }
        ),
        title: Text('Neuer Eintrag'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'Name',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Bitte einen Namen eingeben!';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: notesController,
                decoration: const InputDecoration(
                  hintText: 'Zusätzliche Notizen (optional)',
                ),
              ),
              TextFormField(
                controller: personController,
                decoration: const InputDecoration(
                  hintText: 'Zugeteilte Person (optional)',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      Navigator.pop(context, Item(nameController.text, notesController.text, personController.text));
                    }
                  },
                  child: Text('Hinzufügen'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

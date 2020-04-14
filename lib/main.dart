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
  var id = UniqueKey();

  Item(this.name, this.notes, this.person);
}

class Event extends StatefulWidget {
  @override
  _EventState createState() => _EventState();
}

class _EventState extends State<Event> {
  String _name = 'Himmelfahrtskommando 2020';
  // description
  // date
  // identifier
  List<Item> _items = [];

  @override
  Widget build(BuildContext context) {
    List<Widget> renderItems = [];
    _items.forEach((item) {
      renderItems.add(ItemWidget(key: item.id, name: item.name, notes: item.notes, person: item.person, assignItemCallback: assignItem, deleteItemCallback: deleteItem));
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

  assignItem(Key id, String person) {
    setState(() {
      var item = _items.firstWhere((i) => i.id == id);
      item?.person = person;
    });
  }

  deleteItem(Key id) {
    setState(() {
      _items.removeWhere((i) => i.id == id);
    });
  }
}

class ItemWidget extends StatefulWidget {
  ItemWidget({Key key, this.name: '', this.notes: '', this.person: '', this.assignItemCallback: null, this.deleteItemCallback: null}) : super(key: key);

  final String name;
  final String notes;
  final String person;

  final assignItemCallback;
  final deleteItemCallback;

  @override
  _ItemWidgetState createState() => _ItemWidgetState();
}

enum ItemAction { assign, edit, delete }

class _ItemWidgetState extends State<ItemWidget> {
  _handleItemAction(ItemAction result) {
    switch (result) {
        case ItemAction.assign :
          widget.assignItemCallback(widget.key, 'Ingmar');
          break;
        case ItemAction.edit :
          break;
        case ItemAction.delete :
          widget.deleteItemCallback(widget.key);
          break;
      }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(widget.name),
        subtitle: (widget.notes.isEmpty) ? null : Text(
          widget.notes,
        ),
        trailing: Container(
          constraints: BoxConstraints(minWidth: 0.0, maxWidth: 128.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                widget.person
              ),
              PopupMenuButton<ItemAction>(
                onSelected: _handleItemAction,
                itemBuilder: (BuildContext context) => <PopupMenuEntry<ItemAction>>[
                  const PopupMenuItem<ItemAction>(
                    value: ItemAction.assign,
                    child: ListTile(leading: Icon(Icons.assignment_ind), title: Text('Mitbringen')),
                  ),
                  const PopupMenuItem<ItemAction>(
                    value: ItemAction.edit,
                    child: ListTile(leading: Icon(Icons.edit), title: Text('Ändern')),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem<ItemAction>(
                    value: ItemAction.delete,
                    child: ListTile(leading: Icon(Icons.delete), title: Text('Löschen')),
                  ),
                ],
              )
            ],
          ),
        ),
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

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Moliris Event Planner',
    home: HomeWidget(),
  ));
}

class Event {
  Event({this.name: 'Event', this.description: '', this.date: null});

  var id = UniqueKey();
  String name, description;
  DateTime date;

  List<Item> items = [];
}

class Item {
  Item(this.name, this.notes, this.person);

  String name, notes, person;
  DateTime date = DateTime.now();
  var id = UniqueKey();
}

/* Home Widget */
class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  List<Event> _events = [];

  @override
  Widget build(BuildContext context) {
    List<Widget> renderEvents = [];
    _events.forEach((event) {
      renderEvents.add(EventWidget(key: event.id, event: event));
    });

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
      body: ListView(
        children: renderEvents,
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

  _navigateAndAddEvent(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEventWidget()),
    );

    if (result != null) {
      setState(() {
        _events.add(result);
      });
    }
  }
}

/* Event Widget */
class EventWidget extends StatefulWidget {
  EventWidget({Key key, this.event: null}) : super(key: key);

  Event event;

  @override
  _EventWidgetState createState() => _EventWidgetState();
}

//enum ItemAction { assign, edit, delete }

class _EventWidgetState extends State<EventWidget> {
 /* _handleItemAction(ItemAction result) {
    switch (result) {
        case ItemAction.assign :
          widget.assignItemCallback(widget.key, 'Ingmar');
          break;
        case ItemAction.edit :
          widget.editItemCallback(widget.key);
          break;
        case ItemAction.delete :
          widget.deleteItemCallback(widget.key);
          break;
      }
  }*/

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(widget.event.name),
        subtitle: (widget.event.description.isEmpty && widget.event.date == null) ? null : Text(
          "${widget.event.date?.toString()?.substring(0, 11)}${widget.event.description}",
        ),
        onTap: () {
          _navigateAndShowEvent(context);
        },
        trailing: Container(
          constraints: BoxConstraints(minWidth: 0.0, maxWidth: 128.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                "${widget.event.items.length}"
              ),
/*              PopupMenuButton<ItemAction>(
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
              )*/
            ],
          ),
        ),
      ),
    );
  }

  _navigateAndShowEvent(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EventDetailWidget(key: widget.event.id, event: widget.event)),
    );
  }
}

/* Event Detail Widget */
class EventDetailWidget extends StatefulWidget {
  EventDetailWidget({Key key, this.event: null}) : super(key: key);

  final Event event;

  @override
  _EventDetailWidgetState createState() => _EventDetailWidgetState();
}

class _EventDetailWidgetState extends State<EventDetailWidget> {
  @override
  Widget build(BuildContext context) {
    List<Widget> renderItems = [];
    widget.event.items.forEach((item) {
      renderItems.add(ItemWidget(key: item.id, name: item.name, notes: item.notes, person: item.person, assignItemCallback: assignItem, editItemCallback: editItem, deleteItemCallback: deleteItem));
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          tooltip: 'Zurück',
          onPressed: () {
            Navigator.pop(context);
          }
        ),
        title: Text(widget.event.name),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.sort),
            tooltip: 'Sortierung',
            onPressed: null,
          ),
        ],
      ),
      body: ListView(
        children: renderItems,
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Hinzufügen',
        child: Icon(Icons.add),
        onPressed: () {
          _navigateAndAddItem(context);
        },
      ),
    );
  }

  _navigateAndAddItem(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddItemWidget()),
    );

    if (result != null) {
      setState(() {
        widget.event.items.add(result);
      });
    }
  }

  assignItem(Key id, String person) {
    setState(() {
      var item = widget.event.items.firstWhere((i) => i.id == id);
      item?.person = person;
    });
  }

  editItem(Key id) async {
    var item = widget.event.items.firstWhere((i) => i.id == id);

    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddItemWidget(name: item.name, notes: item.notes, person: item.person)),
    );

    if (result != null) {
      setState(() {
        item.name = result.name;
        item.notes = result.notes;
        item.person = result.person;
      });
    }
  }

  deleteItem(Key id) {
    setState(() {
      widget.event.items.removeWhere((i) => i.id == id);
    });
  }
}

/* Item Widget */
class ItemWidget extends StatefulWidget {
  ItemWidget({Key key, this.name: '', this.notes: '', this.person: '', this.assignItemCallback: null, this.editItemCallback: null, this.deleteItemCallback: null}) : super(key: key);

  final String name;
  final String notes;
  final String person;

  final assignItemCallback;
  final editItemCallback;
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
          widget.editItemCallback(widget.key);
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

/* Add/Edit Event Widget */
class AddEventWidget extends StatefulWidget {
  AddEventWidget({Key key, this.name: '', this.description: '', this.date: null}) : super(key: key);

  final String name;
  final String description;
  final DateTime date;

  @override
  _AddEventWidgetState createState() => _AddEventWidgetState();
}

class _AddEventWidgetState extends State<AddEventWidget> {
  final _formKey = GlobalKey<FormState>();
  final focusDescription = FocusNode();
  final focusDate = FocusNode();
  final TextEditingController dateCtl = TextEditingController();
  final Map<String, dynamic> formData = {'name': null, 'description': null, 'date': null};

  @override
  Widget build(BuildContext context) {
    final bool isEditMode = !widget.name.isEmpty;


    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          tooltip: 'Zurück',
          onPressed: () {
            Navigator.pop(context);
          }
        ),
        title: Text(isEditMode ? 'Event ändern' : 'Neues Event'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                initialValue: widget.name,
                decoration: const InputDecoration(
                  hintText: 'Name',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Bitte einen Namen eingeben!';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (v) {
                  FocusScope.of(context).requestFocus(focusDescription);
                },
                onSaved: (String value) {
                  formData['name'] = value;
                },
              ),
              TextFormField(
                initialValue: widget.description,
                decoration: const InputDecoration(
                  hintText: 'Beschreibung (optional)',
                ),
                focusNode: focusDescription,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (v) {
                  FocusScope.of(context).requestFocus(focusDate);
                },
                onSaved: (String value) {
                  formData['description'] = value;
                },
              ),
              TextFormField(
                controller: dateCtl,
                initialValue: widget.date?.toIso8601String(),
                decoration: const InputDecoration(
                  hintText: 'Datum (optional)',
                ),
                validator: (value) {
                  if (DateTime.tryParse(value) == null) {
                    return 'Bitte ein gültiges Datum auswählen!';
                  }
                  return null;
                },
                focusNode: focusDate,
                onTap: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());

                  DateTime selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2018),
                    lastDate: DateTime(2030),
                  );

                  dateCtl.text = (selectedDate != null) ? selectedDate.toString().substring(0, 10) : '';
                },
                onFieldSubmitted: (v) {
                  _submitForm();
                },
                onSaved: (String value) {
                  formData['date'] = value;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  onPressed: () {
                    _submitForm();
                  },
                  child: Text(isEditMode ? 'Speichern' : 'Hinzufügen'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Navigator.pop(context, Event(name: formData['name'], description: formData['description'], date: DateTime.tryParse(formData['date'])));
    }
  }
}

/* Add/Edit Item Widget */
class AddItemWidget extends StatefulWidget {
  AddItemWidget({Key key, this.name: '', this.notes: '', this.person: ''}) : super(key: key);

  final String name;
  final String notes;
  final String person;

  @override
  _AddItemWidgetState createState() => _AddItemWidgetState();
}

class _AddItemWidgetState extends State<AddItemWidget> {
  final _formKey = GlobalKey<FormState>();
  final focusNotes = FocusNode();
  final focusPerson = FocusNode();
  final Map<String, dynamic> formData = {'name': null, 'notes': null, 'person': null};

  @override
  Widget build(BuildContext context) {
    final bool isEditMode = !widget.name.isEmpty;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          tooltip: 'Zurück',
          onPressed: () {
            Navigator.pop(context);
          }
        ),
        title: Text(isEditMode ? 'Eintrag ändern' : 'Neuer Eintrag'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                initialValue: widget.name,
                decoration: const InputDecoration(
                  hintText: 'Name',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Bitte einen Namen eingeben!';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (v) {
                  FocusScope.of(context).requestFocus(focusNotes);
                },
                onSaved: (String value) {
                  formData['name'] = value;
                },
              ),
              TextFormField(
                initialValue: widget.notes,
                decoration: const InputDecoration(
                  hintText: 'Zusätzliche Notizen (optional)',
                ),
                focusNode: focusNotes,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (v) {
                  FocusScope.of(context).requestFocus(focusPerson);
                },
                onSaved: (String value) {
                  formData['notes'] = value;
                },
              ),
              TextFormField(
                initialValue: widget.person,
                decoration: const InputDecoration(
                  hintText: 'Zugeteilte Person (optional)',
                ),
                focusNode: focusPerson,
                onFieldSubmitted: (v) {
                  _submitForm();
                },
                onSaved: (String value) {
                  formData['person'] = value;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  onPressed: () {
                    _submitForm();
                  },
                  child: Text(isEditMode ? 'Speichern' : 'Hinzufügen'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Navigator.pop(context, Item(formData['name'], formData['notes'], formData['person']));
    }
  }
}

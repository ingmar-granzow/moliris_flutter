import 'package:flutter/material.dart';

class ItemEntry extends StatefulWidget {
  ItemEntry({Key key, this.name: '', this.notes: '', this.person: '', this.assignItemCallback: null, this.editItemCallback: null, this.deleteItemCallback: null}) : super(key: key);

  final String name;
  final String notes;
  final String person;

  final assignItemCallback;
  final editItemCallback;
  final deleteItemCallback;

  @override
  _ItemEntryState createState() => _ItemEntryState();
}

enum ItemAction { assign, edit, delete }

class _ItemEntryState extends State<ItemEntry> {
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
    return ListTile(
      title: Text(widget.name),
      subtitle: (widget.notes.isEmpty) ? null : Text(
        widget.notes,
      ),
      leading: CircleAvatar(
        backgroundColor: Colors.blue.shade800,
        child: Text('IR'),
        //radius: 20,
      ),
      trailing: PopupMenuButton<ItemAction>(
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
    );
  }
}

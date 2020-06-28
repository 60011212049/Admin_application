import 'package:flutter/material.dart';

class ManageDriver extends StatefulWidget {
  ManageDriver({Key key}) : super(key: key);

  @override
  _ManageDriverState createState() => _ManageDriverState();
}

class _ManageDriverState extends State<ManageDriver> {
  final GlobalKey _menuKey = new GlobalKey();
  var _selection;
  @override
  Widget build(BuildContext context) {
    final button = new PopupMenuButton(
        key: _menuKey,
        itemBuilder: (_) => <PopupMenuItem<String>>[
              new PopupMenuItem<String>(
                  child: const Text('Doge'), value: 'Doge'),
              new PopupMenuItem<String>(
                  child: const Text('Lion'), value: 'Lion'),
            ],
        onSelected: (_) {});

    final tile = new ListTile(
        title: new Text('Doge or lion?'),
        trailing: button,
        onTap: () {
          // This is a hack because _PopupMenuButtonState is private.
          dynamic state = _menuKey.currentState;
          state.showButtonMenu();
        });
    return new Scaffold(
      body: new Center(
        child: popUpmenu,
      ),
    );
  }

  get popUpmenu {
    return PopupMenuButton<String>(
      onSelected: (String value) {
        setState(() {
          _selection = value;
        });
      },
      child: ListTile(
        leading: IconButton(
          icon: Icon(Icons.add_alarm),
          onPressed: () {
            print('Hello world');
          },
        ),
        title: Text('Title'),
        subtitle: Column(
          children: <Widget>[
            Text('Sub title'),
            Text(_selection == null
                ? 'Nothing selected yet'
                : _selection.toString()),
          ],
        ),
        trailing: Icon(Icons.account_circle),
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'Value1',
          child: Text('Choose value 1'),
        ),
        const PopupMenuItem<String>(
          value: 'Value2',
          child: Text('Choose value 2'),
        ),
        const PopupMenuItem<String>(
          value: 'Value3',
          child: Text('Choose value 3'),
        ),
      ],
    );
  }
}

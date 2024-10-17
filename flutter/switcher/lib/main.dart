import 'package:flutter/material.dart';
import 'package:switcher/ditto/ditto_manager.dart';
import 'dart:async';
import 'model/item_model.dart';
import 'realm/realm_manager.dart';

void main() {
  runApp(const MyApp());
}

const appTitle = 'Switcher';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  //// ⚠️ Toggle this value to switch between Realm and Ditto.
  bool isRealm = true;

  late RealmManager _realmManager;
  late DittoManager _dittoManager;
  List<Item> items = [];
  StreamSubscription? _realmSubscription;
  StreamSubscription? _dittoSubscription;

  @override
  void initState() {
    super.initState();
    _realmManager = RealmManager();
    _dittoManager = DittoManager();
    _loadItems();
  }

  void _loadItems() {
    setState(() {
      items = isRealm ? _realmManager.getAllItems() : _dittoManager.items;
    });
    _watchItems();
  }

  void _watchItems() {
    _cancelSubscription();
    if (isRealm) {
      _realmSubscription = _realmManager.watchItems().listen((changes) {
        _loadItems();
      });
    } else {
      _dittoSubscription = _dittoManager.watchItems().listen((changes) {
        _loadItems();
      });
    }
  }

  void _cancelSubscription() {
    _realmSubscription?.cancel();
    _realmSubscription = null;
    _dittoSubscription?.cancel();
    _dittoSubscription = null;
  }

  void _addItem() {
    final newItem = Item(
      id: (items.length + 1).toString(),
      detail: 'Detail for item ${items.length + 1}',
      subitems: List.generate(3, (index) => 'Subitem ${index + 1}'),
    );
    
    isRealm ? _realmManager.addItem(newItem) : _dittoManager.addItem(newItem);
  }

  void _showSelector() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Local Store'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Realm'),
                onTap: () {
                  setState(() {
                    isRealm = true;
                  });
                  _loadItems();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('Ditto'),
                onTap: () {
                  setState(() {
                    isRealm = false;
                  });
                  _loadItems();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
        leading: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
          child: InkWell(
            onTap: _showSelector,
            child: Center(
              child: Text(
                isRealm ? 'Realm' : 'Ditto',
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Card(
            child: ExpansionTile(
              title: Text('Item ${items[index].id}'),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Detail: ${items[index].detail}'),
                        const SizedBox(height: 8),
                        const Text('Subitems:'),
                        ...items[index].subitems.map((subitem) => Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Text('- $subitem'),
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        tooltip: 'Add Item',
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _cancelSubscription();
    _realmManager.close();
    super.dispose();
  }
}

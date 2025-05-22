import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/new_item.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/config/env_config.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    _loadItems();
    super.initState();
  }

  void _loadItems() async {
    final url = Uri.https(
      EnvConfig.firebaseUrl,
      'shopping-list.json', // subdomain added at the end
    );

    try{
          final response = await http.get(url);
    if (response.statusCode >= 400) {
      setState(() {
        _error = 'Failed to fetch data';
      });
    }

    if (response.body == 'null') {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    final Map<String, dynamic> listData = json.decode(
      // burada veritutu map icinde key ve map ama flutter bu kadar detay istemiyor <String, dynamic> ver gec diyor.
      response.body,
    );

    final List<GroceryItem> loadedItem = [];
    for (final item in listData.entries) {
      // tek sorunlu olan category cunku o da bir sinif ama db ye sadece title degeri yaziliyor geri alirken duzeltmemiz gerekiyordu.
      var category =
          categories.entries
              .firstWhere(
                (catItem) => catItem.value.title == item.value['category'],
              )
              .value;

      loadedItem.add(
        GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category,
        ),
      );
    }
    setState(() {
      _groceryItems =
          loadedItem; // burada en yukarda tanimlanan listeyi guncelliyoruz
      _isLoading = false;
    });
    }
    catch(error){
      setState(() {
        _error = 'Something went wrong!';
      });
    }

  }

  void _addItem() async {
    final newItem = await Navigator.of(
      context,
    ).push<GroceryItem>(MaterialPageRoute(builder: (ctx) => NewItem()));
    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryItems.add(
        newItem,
      ); // yeni build atsin diye yoksa build gelene kadar ekranda degisim olmaz.
    });
  }

  void _removeItem(GroceryItem item) async {
    setState(() {
      _groceryItems.remove(item);
    });

    var index = _groceryItems.indexOf(item);

    final url = Uri.https(
      EnvConfig.firebaseUrl,
      'shopping-list/${item.id}.json', // subdomain added at the end
    );
    final response = await http.delete(url);

    if (response.statusCode > 400) {
      setState(() {
        _groceryItems.insert(index, item);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(child: Text('There is no data you can add it! '));

    if (_isLoading) {
      content = Center(child: CircularProgressIndicator());
    }

    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder:
            (context, index) => Dismissible(
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              ),
              key: ValueKey(_groceryItems[index].id),
              onDismissed: (direction) {
                _removeItem(_groceryItems[index]);
              },
              child: ListTile(
                leading: Container(
                  width: 24,
                  height: 24,
                  color: _groceryItems[index].category.color,
                ),
                title: Text(_groceryItems[index].name),
                trailing: Text(_groceryItems[index].quantity.toString()),
              ),
            ),
      );
    }

    if (_error != null) {
      content = Center(child: Text(_error!));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Groceries '),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.red),
            onPressed: _addItem,
          ),
        ],
      ),
      body: content,
    );
  }
}

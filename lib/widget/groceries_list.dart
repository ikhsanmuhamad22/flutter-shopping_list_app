import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list_app/data/categories.dart';
import 'package:shopping_list_app/models/grocery_item.dart';
import 'package:shopping_list_app/widget/new_item.dart';
import 'package:http/http.dart' as http;

class GroceriesList extends StatefulWidget {
  const GroceriesList({super.key});

  @override
  State<GroceriesList> createState() => _GroceriesListState();
}

class _GroceriesListState extends State<GroceriesList> {
  List<GroceryItem> _groceriesItem = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final url = Uri.https(
        'learning-28fcc-default-rtdb.firebaseio.com', 'shooping_list.json');
    final response = await http.get(url);
    final Map<String, dynamic> listData = json.decode(response.body);
    final List<GroceryItem> laodedItems = [];
    for (final item in listData.entries) {
      final category = categories.entries
          .firstWhere(
              (itemCat) => itemCat.value.title == item.value['category'])
          .value;
      laodedItems.add(GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category));
    }
    setState(() {
      _groceriesItem = laodedItems;
    });
  }

  void _addItem() async {
    Navigator.of(context)
        .push<GroceryItem>(MaterialPageRoute(builder: (context) => NewItem()));
    _loadData();
  }

  void removeItem(GroceryItem item) {
    setState(() {
      _groceriesItem.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Groceries'),
          actions: [IconButton(onPressed: _addItem, icon: Icon(Icons.add))],
        ),
        body: _groceriesItem.isNotEmpty
            ? ListView.builder(
                itemCount: _groceriesItem.length,
                itemBuilder: (context, index) => Dismissible(
                  onDismissed: (direction) => removeItem(_groceriesItem[index]),
                  key: ValueKey(_groceriesItem[index].id),
                  child: ListTile(
                    title: Text(_groceriesItem[index].name),
                    leading: Container(
                        width: 24,
                        height: 24,
                        color: _groceriesItem[index].category.color),
                    trailing: Text(_groceriesItem[index].quantity.toString()),
                  ),
                ),
              )
            : Center(
                child: Text(
                'Your groceries is empty',
                style: Theme.of(context).textTheme.bodyLarge,
              )));
  }
}

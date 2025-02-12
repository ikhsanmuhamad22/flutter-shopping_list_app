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
  List<GroceryItem> groceriesItems = [];
  late Future<List<GroceryItem>> loadedItems;

  @override
  void initState() {
    super.initState();
    loadedItems = _loadData();
  }

  Future<List<GroceryItem>> _loadData() async {
    final url = Uri.https(
        'learning-28fcc-default-rtdb.firebaseio.com', 'shooping_list.json');
    final response = await http.get(url);
    if (response.statusCode >= 400) {
      setState(() {
        throw Exception('Failed to fetch data, Please try again latter');
      });
    }
    if (response.body == 'null') {
      return [];
    }
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
    return laodedItems;
  }

  void _addItem() async {
    final newItem = await Navigator.of(context)
        .push<GroceryItem>(MaterialPageRoute(builder: (context) => NewItem()));

    if (newItem == null) {
      return;
    }

    setState(() {
      groceriesItems.add(newItem);
    });
  }

  void removeItem(GroceryItem item) async {
    final index = groceriesItems.indexOf(item);
    setState(() {
      groceriesItems.remove(item);
    });
    final url = Uri.https('learning-28fcc-default-rtdb.firebaseio.com',
        'shooping_list/${item.id}.json');
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      setState(() {
        groceriesItems.insert(index, item);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Groceries'),
        actions: [IconButton(onPressed: _addItem, icon: Icon(Icons.add))],
      ),
      body: FutureBuilder(
        future: _loadData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
                child: Text(snapshot.error.toString(),
                    style: Theme.of(context).textTheme.bodyLarge));
          }

          if (snapshot.data!.isEmpty) {
            return Center(
                child: Text('Your groceries is empty',
                    style: Theme.of(context).textTheme.bodyLarge));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) => Dismissible(
              onDismissed: (direction) => removeItem(snapshot.data![index]),
              key: ValueKey(snapshot.data![index].id),
              child: ListTile(
                title: Text(snapshot.data![index].name),
                leading: Container(
                    width: 24,
                    height: 24,
                    color: snapshot.data![index].category.color),
                trailing: Text(snapshot.data![index].quantity.toString()),
              ),
            ),
          );
        },
      ),
    );
  }
}

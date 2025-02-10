import 'package:flutter/material.dart';
import 'package:shopping_list_app/models/grocery_item.dart';
import 'package:shopping_list_app/widget/new_item.dart';

class GroceriesList extends StatefulWidget {
  const GroceriesList({super.key});

  @override
  State<GroceriesList> createState() => _GroceriesListState();
}

class _GroceriesListState extends State<GroceriesList> {
  final List<GroceryItem> _groceriesItem = [];
  void _addItem() async {
    final newItem = await Navigator.of(context)
        .push<GroceryItem>(MaterialPageRoute(builder: (context) => NewItem()));

    if (newItem == null) {
      return;
    }
    setState(() {
      _groceriesItem.add(newItem);
    });
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

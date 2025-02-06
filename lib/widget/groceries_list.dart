import 'package:flutter/material.dart';
import 'package:shopping_list_app/data/dummy_items.dart';
import 'package:shopping_list_app/widget/new_item.dart';

class GroceriesList extends StatefulWidget {
  const GroceriesList({super.key});

  @override
  State<GroceriesList> createState() => _GroceriesListState();
}

class _GroceriesListState extends State<GroceriesList> {
  void _addItem() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => NewItem()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Groceries'),
          actions: [
            IconButton(onPressed: _addItem, icon: Icon(Icons.plus_one))
          ],
        ),
        body: ListView.builder(
          itemCount: groceryItems.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(groceryItems[index].name),
            leading: Container(
                width: 24,
                height: 24,
                color: groceryItems[index].category.color),
            trailing: Text(groceryItems[index].quantity.toString()),
          ),
        ));
  }
}

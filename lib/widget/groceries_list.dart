import 'package:flutter/material.dart';
import 'package:shopping_list_app/data/dummy_items.dart';

class GroceriesList extends StatelessWidget {
  const GroceriesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Groceries'),
        ),
        body: ListView.builder(
          itemCount: groceryItems.length,
          itemBuilder: (context, index) => 
          ListTile(
            title: Text(groceryItems[index].name),
            leading: Container(width: 24, height: 24, color: groceryItems[index].category.color),
            trailing: Text(groceryItems[index].quantity.toString()),
            ),
        ));
  }
}

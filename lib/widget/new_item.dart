import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shopping_list_app/data/categories.dart';
import 'package:shopping_list_app/models/category.dart';
import 'package:shopping_list_app/models/grocery_item.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() {
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItem> {
  final _keyForm = GlobalKey<FormState>();
  var _enteredName = '';
  var _enterdQuantity = 1;
  var _selectedCategory = categories[Categories.vegetables]!;

  void _saveItem() {
    _keyForm.currentState!.validate();
    _keyForm.currentState!.save();
    Navigator.of(context).pop<GroceryItem>(GroceryItem(
        id: DateTime.now().toString(),
        name: _enteredName,
        quantity: _enterdQuantity,
        category: _selectedCategory));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Item'),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _keyForm,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: InputDecoration(label: Text('Name')),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 2 ||
                      value.trim().length > 50) {
                    return 'must be between 3 - 50 character';
                  }
                  return null;
                },
                onSaved: (newValue) => _enteredName = newValue!,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(label: Text('Quantity')),
                      initialValue: _enterdQuantity.toString(),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! < 0) {
                          return 'must be valid positif number';
                        }
                        return null;
                      },
                      onSaved: (newValue) =>
                          _enterdQuantity = int.parse(newValue!),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selectedCategory,
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: category.value.color,
                                ),
                                SizedBox(width: 8),
                                Text(category.value.title)
                              ],
                            ),
                          ),
                      ],
                      onChanged: (value) => setState(() {
                        _selectedCategory = value!;
                      }),
                    ),
                  )
                ],
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () => _keyForm.currentState!.reset(),
                      child: Text('Reset')),
                  ElevatedButton(onPressed: _saveItem, child: Text('Submit'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

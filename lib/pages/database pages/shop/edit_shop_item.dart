import 'package:adalato_dashboard/models/shop_item_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditShopItemPage extends StatefulWidget {
  final ShopItemModel shopItem;

  const EditShopItemPage({super.key, required this.shopItem});

  @override
  _EditShopItemPageState createState() => _EditShopItemPageState();
}

class _EditShopItemPageState extends State<EditShopItemPage> {
  final _formKey = GlobalKey<FormState>();

  late String _itemName;
  late String _description;
  late double _price;
  late String _imageUrl;
  late String _category;
  late bool _isAvailable;
  late bool _isHidden;

  @override
  void initState() {
    super.initState();
    _itemName = widget.shopItem.itemName;
    _description = widget.shopItem.description;
    _price = widget.shopItem.price;
    _imageUrl = widget.shopItem.imageUrl;
    _category = widget.shopItem.category;
    _isAvailable = widget.shopItem.isAvailable;
    _isHidden = widget.shopItem.isHidden;
  }

  void _updateShopItem() {
    if (_formKey.currentState!.validate()) {
      FirebaseFirestore.instance
          .collection('shop_items')
          .doc(widget.shopItem.itemId)
          .update({
        'itemName': _itemName,
        'description': _description,
        'price': _price,
        'imageUrl': _imageUrl,
        'category': _category,
        'isAvailable': _isAvailable,
        'isHidden': _isHidden,
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Shop item updated successfully')),
        );
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Shop Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _itemName,
                decoration: const InputDecoration(labelText: 'Item Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter item name';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _itemName = value;
                  });
                },
              ),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _description = value;
                  });
                },
              ),
              TextFormField(
                initialValue: _price.toString(),
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _price = double.parse(value);
                  });
                },
              ),
              TextFormField(
                initialValue: _imageUrl,
                decoration: const InputDecoration(labelText: 'Image URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter image URL';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _imageUrl = value;
                  });
                },
              ),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: [
                  'Category',
                  'Equipment',
                  'Protein & Nutritions',
                  'Accessories'
                ]
                    .map((label) => DropdownMenuItem(
                          value: label,
                          child: Text(label),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _category = value!;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Available'),
                value: _isAvailable,
                onChanged: (value) {
                  setState(() {
                    _isAvailable = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Hidden'),
                value: _isHidden,
                onChanged: (value) {
                  setState(() {
                    _isHidden = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateShopItem,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

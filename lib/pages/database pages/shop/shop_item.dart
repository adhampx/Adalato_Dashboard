import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:uuid/uuid.dart';

class ShopItemPage extends StatefulWidget {
  const ShopItemPage({super.key});

  @override
  _ShopItemPageState createState() => _ShopItemPageState();
}

class _ShopItemPageState extends State<ShopItemPage> {
  final _formKey = GlobalKey<FormState>();
  final _itemNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  String _category = 'Category';
  Uint8List? _imageData;
  String? _imageUrl;
  bool _isAvailable = true;
  bool _isHidden = false;

  Future<void> pickImage() async {
    final image = await ImagePickerWeb.getImageAsBytes();

    if (image != null) {
      final imageUrl = await uploadImage(image);
      setState(() {
        _imageData = image;
        _imageUrl = imageUrl;
      });
    }
  }

  Future<String> uploadImage(Uint8List fileData) async {
    try {
      final storageRef =
          FirebaseStorage.instance.ref().child('shop_items/${const Uuid().v4()}.jpg');
      final uploadTask = storageRef.putData(fileData);

      final taskSnapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return Future.error('Error uploading image');
    }
  }

  Future<void> saveShopItem(String itemId, String itemName, String description,
      double price, String category, String? imageUrl) async {
    await FirebaseFirestore.instance.collection('shop_items').doc(itemId).set({
      'itemId': itemId,
      'itemName': itemName,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'isAvailable': _isAvailable,
      'isHidden': _isHidden,
    });
  }

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      final itemId = const Uuid().v4();
      await saveShopItem(
        itemId,
        _itemNameController.text,
        _descriptionController.text,
        double.parse(_priceController.text),
        _category,
        _imageUrl,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Shop item saved successfully')),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Shop Item')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _itemNameController,
                decoration: const InputDecoration(labelText: 'Item Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter item name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _category,
                onChanged: (newValue) {
                  setState(() {
                    _category = newValue!;
                  });
                },
                items: <String>[
                  'Category',
                  'Accessories',
                  'Protein & Nutritions',
                  'Equipments',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (value) {
                  if (value == null || value == 'Category') {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Available'),
                  Switch(
                    value: _isAvailable,
                    onChanged: (value) {
                      setState(() {
                        _isAvailable = value;
                      });
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Hidden'),
                  Switch(
                    value: _isHidden,
                    onChanged: (value) {
                      setState(() {
                        _isHidden = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: pickImage,
                child: const Text('Pick Image'),
              ),
              if (_imageData != null) ...[
                const SizedBox(height: 10),
                Image.memory(_imageData!, height: 150),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveItem,
                child: const Text('Save Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

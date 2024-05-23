import 'package:cloud_firestore/cloud_firestore.dart';

class ShopItemModel {
  String itemId;
  String itemName;
  String description;
  double price;
  String imageUrl;
  String category; // Points to tags for categories
  bool isAvailable;
  bool isHidden;

  ShopItemModel({
    required this.itemId,
    required this.itemName,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.isAvailable,
    required this.isHidden,
  });

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'itemName': itemName,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'isAvailable': isAvailable,
      'isHidden': isHidden,
    };
  }

  factory ShopItemModel.fromMap(Map<String, dynamic> map) {
    return ShopItemModel(
      itemId: map['itemId'] ?? '',
      itemName: map['itemName'] ?? '',
      description: map['description'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      imageUrl: map['imageUrl'] ?? '',
      category: map['category'] ?? '',
      isAvailable: map['isAvailable'] ?? true,
      isHidden: map['isHidden'] ?? false,
    );
  }

  factory ShopItemModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ShopItemModel.fromMap(data);
  }
}

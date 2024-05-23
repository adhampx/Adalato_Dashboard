import 'package:adalato_dashboard/models/shop_item_model.dart';
import 'package:adalato_dashboard/pages/database%20pages/shop/shop_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'edit_shop_item.dart';

class ShopItemList extends StatelessWidget {
  const ShopItemList({Key? key}) : super(key: key);

  Future<void> _deleteItem(String id) async {
    await FirebaseFirestore.instance.collection('shop_items').doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop Items'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('shop_items').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              ShopItemModel shopItem = ShopItemModel.fromMap(data);

              return Card(
                child: ListTile(
                  leading: shopItem.imageUrl != ''
                      ? Image.network(
                          shopItem.imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return const Icon(Icons.error);
                          },
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ??
                                            1)
                                    : null,
                              ),
                            );
                          },
                        )
                      : const Icon(Icons.image),
                  title: Text(shopItem.itemName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Description: ${shopItem.description}'),
                      Text('Price: \$${shopItem.price}'),
                      Text('Category: ${shopItem.category}'),
                      Text('Available: ${shopItem.isAvailable ? 'Yes' : 'No'}'),
                      Text('Hidden: ${shopItem.isHidden ? 'Yes' : 'No'}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditShopItemPage(shopItem: shopItem),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _deleteItem(doc.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const ShopItemPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

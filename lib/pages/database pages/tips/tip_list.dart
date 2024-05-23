import 'package:adalato_dashboard/pages/database%20pages/tips/tips.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'edit_tip.dart';

class TipListPage extends StatefulWidget {
  const TipListPage({super.key});

  @override
  _TipListPageState createState() => _TipListPageState();
}

class _TipListPageState extends State<TipListPage> {
  final CollectionReference _tipsCollection =
      FirebaseFirestore.instance.collection('tips');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tips List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _tipsCollection.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final List<DocumentSnapshot> documents = snapshot.data!.docs;

          return ListView(
            children: documents
                .map((doc) => ListTile(
                      title: Text(doc['title']),
                      subtitle: Text(doc['description']),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditTipPage(
                                tipId: doc.id,
                              ),
                            ),
                          );
                        },
                      ),
                    ))
                .toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TipPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

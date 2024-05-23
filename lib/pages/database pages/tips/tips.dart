import 'package:adalato_dashboard/models/tips_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TipPage extends StatelessWidget {
  const TipPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Tip'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isEmpty ||
                    descriptionController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields')),
                  );
                  return;
                }

                final newTip = TipModel(
                  tipId: FirebaseFirestore.instance.collection('tips').doc().id,
                  title: titleController.text,
                  description: descriptionController.text,
                );

                await FirebaseFirestore.instance
                    .collection('tips')
                    .doc(newTip.tipId)
                    .set(newTip.toMap());
                Navigator.pop(context);
              },
              child: const Text('Add Tip'),
            )
          ],
        ),
      ),
    );
  }
}

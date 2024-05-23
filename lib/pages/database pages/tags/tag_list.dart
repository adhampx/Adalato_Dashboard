import 'package:adalato_dashboard/models/tag_model.dart';
import 'package:adalato_dashboard/pages/database%20pages/tags/edit_tag.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class TagListPage extends StatefulWidget {
  const TagListPage({super.key});

  @override
  _TagListPageState createState() => _TagListPageState();
}

class _TagListPageState extends State<TagListPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tags'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AddTagPage()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('tags').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final tags = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return TagModel.fromMap(data);
          }).toList();

          return ListView.builder(
            itemCount: tags.length,
            itemBuilder: (context, index) {
              final tag = tags[index];
              return ListTile(
                title: Text(tag.name),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EditTagPage(tagId: tag.tagId),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class AddTagPage extends StatefulWidget {
  const AddTagPage({super.key});

  @override
  _AddTagPageState createState() => _AddTagPageState();
}

class _AddTagPageState extends State<AddTagPage> {
  final _formKey = GlobalKey<FormState>();
  String _tagName = '';

  void _saveTag() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newTag = TagModel(
        tagId: const Uuid().v4(),
        name: _tagName,
      );

      await FirebaseFirestore.instance
          .collection('tags')
          .doc(newTag.tagId)
          .set(newTag.toMap());

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Tag'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Tag Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a tag name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _tagName = value!;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTag,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

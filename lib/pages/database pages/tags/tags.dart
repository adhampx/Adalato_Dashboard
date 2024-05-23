import 'package:adalato_dashboard/models/tag_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class TagPage extends StatefulWidget {
  const TagPage({super.key});

  @override
  _TagPageState createState() => _TagPageState();
}

class _TagPageState extends State<TagPage> {
  final _formKey = GlobalKey<FormState>();
  String _tagName = '';
  bool _isEditMode = false;
  String? _editTagId;

  void _saveTag() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_isEditMode && _editTagId != null) {
        await FirebaseFirestore.instance
            .collection('tags')
            .doc(_editTagId)
            .update({'name': _tagName});
      } else {
        final newTag = TagModel(
          tagId: const Uuid().v4(),
          name: _tagName,
        );

        await FirebaseFirestore.instance
            .collection('tags')
            .doc(newTag.tagId)
            .set(newTag.toMap());
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final TagModel? tag =
        ModalRoute.of(context)!.settings.arguments as TagModel?;

    if (tag != null && !_isEditMode) {
      _isEditMode = true;
      _editTagId = tag.tagId;
      _tagName = tag.name;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Tag' : 'Add Tag'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _tagName,
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

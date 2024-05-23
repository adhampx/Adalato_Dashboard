import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditTagPage extends StatefulWidget {
  final String tagId;

  const EditTagPage({super.key, required this.tagId});

  @override
  _EditTagPageState createState() => _EditTagPageState();
}

class _EditTagPageState extends State<EditTagPage> {
  final _formKey = GlobalKey<FormState>();
  String _tagName = '';

  void _loadTag() async {
    final doc = await FirebaseFirestore.instance
        .collection('tags')
        .doc(widget.tagId)
        .get();
    final data = doc.data() as Map<String, dynamic>;

    setState(() {
      _tagName = data['name'] ?? '';
    });
  }

  void _updateTag() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await FirebaseFirestore.instance
          .collection('tags')
          .doc(widget.tagId)
          .update({'name': _tagName});

      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadTag();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Tag'),
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
                onPressed: _updateTag,
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

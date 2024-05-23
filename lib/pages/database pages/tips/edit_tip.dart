import 'package:adalato_dashboard/models/tips_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditTipPage extends StatefulWidget {
  final String tipId;

  const EditTipPage({super.key, required this.tipId});

  @override
  _EditTipPageState createState() => _EditTipPageState();
}

class _EditTipPageState extends State<EditTipPage> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late TipModel _tip;

  @override
  void initState() {
    super.initState();
    _loadTip();
  }

  Future<void> _loadTip() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('tips')
        .doc(widget.tipId)
        .get();
    setState(() {
      _tip = TipModel.fromDocument(doc);
      _title = _tip.title;
      _description = _tip.description;
    });
  }

  Future<void> _updateTip() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      TipModel updatedTip = TipModel(
        tipId: widget.tipId,
        title: _title,
        description: _description,
      );

      await FirebaseFirestore.instance
          .collection('tips')
          .doc(updatedTip.tipId)
          .update(updatedTip.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tip updated successfully')),
      );

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Tip'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // ignore: unnecessary_null_comparison
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) => _title = value ?? '',
              ),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) => _description = value ?? '',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateTip,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

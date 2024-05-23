import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddWorkoutPage extends StatefulWidget {
  const AddWorkoutPage({super.key});

  @override
  _AddWorkoutPageState createState() => _AddWorkoutPageState();
}

class _AddWorkoutPageState extends State<AddWorkoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();
  String _difficultyLevel = 'Beginner';
  final List<String> _selectedTags = [];
  final List<String> _selectedExercises = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Workout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _durationController,
                  decoration: const InputDecoration(labelText: 'Duration (minutes)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the duration';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _difficultyLevel,
                  decoration: const InputDecoration(labelText: 'Difficulty Level'),
                  items: ['Beginner', 'Intermediate', 'Advanced']
                      .map((label) => DropdownMenuItem(
                            value: label,
                            child: Text(label),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _difficultyLevel = value!;
                    });
                  },
                ),
                const SizedBox(height: 20),
                const Text('Select Tags'),
                Wrap(
                  spacing: 10,
                  children: [
                    'Beginner',
                    'Intermediate',
                    'Advanced',
                    'Back',
                    'Biceps',
                    'Chest',
                    'Triceps',
                    'Shoulders',
                    'Legs',
                    'Abs',
                    'Dip Bar',
                    'Parallettes',
                    'Barbell',
                    'Dumbbell',
                    'Pull Up Bar',
                    'Other'
                  ].map((tag) {
                    return FilterChip(
                      label: Text(tag),
                      selected: _selectedTags.contains(tag),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            _selectedTags.add(tag);
                          } else {
                            _selectedTags.remove(tag);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                const Text('Select Exercises'),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('exercises')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const CircularProgressIndicator();
                    final exercises = snapshot.data!.docs;
                    return Wrap(
                      spacing: 10,
                      children: exercises.map((doc) {
                        return FilterChip(
                          label: Text(doc['exerciseTitle']),
                          selected: _selectedExercises.contains(doc.id),
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                _selectedExercises.add(doc.id);
                              } else {
                                _selectedExercises.remove(doc.id);
                              }
                            });
                          },
                        );
                      }).toList(),
                    );
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final newWorkout = {
                        'id': const Uuid().v4(),
                        'title': _titleController.text,
                        'description': _descriptionController.text,
                        'duration': int.parse(_durationController.text),
                        'difficultyLevel': _difficultyLevel,
                        'tagIds': _selectedTags,
                        'exerciseIds': _selectedExercises,
                        'rating': 0.0,
                        'favoritesCount': 0,
                        'isHidden': false,
                      };
                      await FirebaseFirestore.instance
                          .collection('workouts')
                          .doc(newWorkout['id'] as String)
                          .set(newWorkout)
                          .then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Workout saved successfully')),
                        );
                      });
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
